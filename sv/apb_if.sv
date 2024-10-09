interface apb_if
#(localparam DATA_WIDTH = 32, ADDR_WIDTH = 4)
(input clk, input rst);

    timeunit 1ns;
    timeprecision 100ps;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import apb_pkg::*;

   // Actual Signals
    logic [ADDR_WIDTH-1:0] PADDR;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic                PWRITE;
    logic                PREADY;
    logic                PSEL;    
    logic                PENABLE;

    // signal for transaction recording
    bit monstart, drvstart;

    // modport monitor (
    // input  clk, rst, PADDR, PRDATA, PWDATA, PWRITE, PREADY, PSEL, PENABLE ,monstart
    // );
    // modport master_driver (
    // input  clk, rst, PREADY, PRDATA, drvstart,
    // output PADDR, PWDATA, PWRITE, PSEL, PENABLE
    // );
    // modport slave_driver (
    // input  clk, rst, PADDR, PRDATA, PWDATA, PWRITE, 
    // output PREADY, PSEL, PENABLE
    // );

    task apb_rst();
        @(negedge rst);
        PWDATA        <=  'hz;
        PADDR         <=  'hz;
        PWRITE        <=  'hz;
        PENABLE       <= 1'b0;
        PSEL          <= 1'b0;
        disable send_to_dut;
    endtask : apb_rst

    task send_to_dut(input  bit write,
        bit [DATA_WIDTH-1:0] wdata,
        bit [DATA_WIDTH-1:0] rdata,
        bit [ADDR_WIDTH-1:0] addr 
        );

        @(posedge clk)

        // trigger for transaction recording
        drvstart = 1'b1;

        PENABLE <= 1'b0;
        PSEL <= 1'b1;
        PADDR <= addr;    //     
        PWRITE <=  write;

        // Write
        if (write == 1) begin

            PWDATA <= wdata;
            
            @(posedge clk or posedge PREADY);
            PENABLE <= 'b1;
            if ( PREADY) begin
                @(posedge clk);
            end
            else begin
                @(posedge PREADY);
                @(posedge clk);
            end
        
        end

        // Read
        else begin 

                PWDATA <= 1'b0;
                @(posedge clk);
                PENABLE <= 1'b1;
                @(posedge PREADY);
                @(posedge clk);
        end

        PENABLE <= 'b0;
        PWRITE <= 'b0;
        PSEL <= 'b0;
        PWDATA <= 'z;
        PADDR <= 'z;

        // reset trigger
        drvstart <= 'b0;

    endtask : send_to_dut

    // Collect Packets
    task collect_packet(output bit  write,
        bit [ADDR_WIDTH-1:0]  addr,
        bit [DATA_WIDTH-1:0]  wdata,
        bit [DATA_WIDTH-1:0]  rdata);

       @(posedge clk iff PSEL) 
        @(posedge PREADY iff (PENABLE))
        // trigger transaction
        monstart <= 1'b1;

        write <= PWRITE;
        addr  <= PADDR;
        wdata <= PWDATA;
        rdata <= PRDATA;            

    
        if (PWRITE == 1) begin
            wdata <= PWDATA;
        end
       // else if(write == 0) begin

        else begin
           // @(posedge PREADY);
            rdata <= PRDATA;            
        end

       //  else 
         //    `uvm_error("IF", "Signal PWRITE is unknown")


        @(posedge clk)
        monstart <= 1'b0;

    endtask : collect_packet

endinterface : apb_if
module hw_top;

    logic clk;
    logic rst;

    // APB Interface to the DUT
    apb_if in_if(
        .clk(clk), 
        .rst(rst));

    apb_slave apb_slv(
        .pclk(clk),
        .rst_n(rst),

        .paddr(in_if.PADDR),
        .psel(in_if.PSEL),
        .penable(in_if.PENABLE),
        .pwrite(in_if.PWRITE), 
        .pwdata(in_if.PWDATA),
        .pready(in_if.PREADY),
        .prdata(in_if.PRDATA)
    );
    
    initial begin
        clk = 0;
        forever #10 clk= ~clk;
    end
    
    initial begin
        rst <= 0;
        #10 rst <= 0;
        #10 rst <= 1;
    end

endmodule : hw_top
class apb_driver extends uvm_driver #(apb_packet);

    virtual interface apb_if vif;

    // Count packets sent
    int num_sent;

     // component macro
    `uvm_component_utils_begin(apb_driver)
        `uvm_field_int(num_sent, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // UVM run_phase
    task run_phase(uvm_phase phase);
        fork
            get_and_drive();
            rst_signals();

        join
    endtask : run_phase

    function void connect_phase (uvm_phase phase);
        if (! apb_vif_config::get(
            this, get_full_name(), "vif",vif) )
            `uvm_error(get_full_name(), "Missing virtual I/F")

    endfunction : connect_phase
    
       
    task get_and_drive();
            @(negedge vif.rst);
            @(posedge vif.rst);
          
            forever begin
                // Get new item from the sequencer
                seq_item_port.get_next_item(req);

                // concurrent blocks for packet driving and transaction recording
                fork
                    // send packet
                    vif.send_to_dut(.write(req.pwrite), 
                                    .rdata(req.prdata),
                                    .addr (req.paddr ),
                                    .wdata(req.pwdata)
                                    // .packet_delay(req.packet_delay)
                    );
                    @(posedge vif.drvstart) void'(begin_tr(req, "master_driver_APB_Packet"));
                join
                // End transaction recording
                end_tr(req);
                `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_LOW)
                
                // Communicate item done to the sequencer
                seq_item_port.item_done();
                num_sent++;
            end
        endtask : get_and_drive
    
     

     // Reset all TX signals
    task rst_signals();
        forever 
            vif.apb_rst();
    endtask : rst_signals

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: APB TX driver sent %0d packets", num_sent), UVM_LOW)
    endfunction : report_phase


endclass : apb_driver
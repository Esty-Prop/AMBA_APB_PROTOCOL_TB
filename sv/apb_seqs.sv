class apb_base_seq extends uvm_sequence #(apb_packet);

    `uvm_object_utils(apb_base_seq)

    // Constructor
    function new(string name="apb_packet");
        super.new(name);
    endfunction

    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
          // in UVM1.2, get starting phase from method
          phase = get_starting_phase();
        `else
          phase = starting_phase;
        `endif
        if (phase != null) begin
          phase.raise_objection(this, get_type_name());
          `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body
    
    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
          // in UVM1.2, get starting phase from method
          phase = get_starting_phase();
        `else
          phase = starting_phase;
        `endif
        if (phase != null) begin
          phase.drop_objection(this, get_type_name());
          `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body

endclass : apb_base_seq

class apb_5_packets extends apb_base_seq;

    `uvm_object_utils(apb_5_packets)

    // Constructor
    function new(string name="apb_5_packets");
      super.new(name);
    endfunction
  
    // Sequence body definition
    virtual task body();
      `uvm_info(get_type_name(), "Executing ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddapb_base_seq sequence", UVM_LOW)
       repeat(5)
        `uvm_do(req)
    endtask

endclass : apb_5_packets

class apb_write_read_same_address extends apb_base_seq;

  `uvm_object_utils(apb_write_read_same_address)

  rand bit [3:0] address;

  function new(string name  = "apb_write_read_same_address");
      super.new(name);
  endfunction : new

   // Sequence body definition
  virtual task body();
     
      `uvm_info(get_type_name(), "Executing apb_write_read_same_address sequence", UVM_LOW)
      `uvm_do_with(req, {req.pwrite == 1'b1; req.paddr == address;}) 
      `uvm_do_with(req, {req.pwrite == 1'b0; req.paddr == address;}) 
  endtask : body

endclass : apb_write_read_same_address


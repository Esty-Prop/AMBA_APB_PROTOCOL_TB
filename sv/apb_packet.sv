class apb_packet extends uvm_sequence_item;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 4;

    // Define protocol data
    rand bit [ADDR_WIDTH-1:0] paddr;
    rand bit [DATA_WIDTH-1:0] pwdata;
    rand int                packet_delay;
         bit [DATA_WIDTH-1:0] prdata;
    rand bit                pwrite;
    

    // Define control knobs
    `uvm_object_utils_begin(apb_packet)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwdata,UVM_ALL_ON)
        `uvm_field_int(prdata,UVM_ALL_ON)
        `uvm_field_int(pwrite,UVM_ALL_ON)
        `uvm_field_int(packet_delay,UVM_ALL_ON+UVM_NOCOMPARE)
    `uvm_object_utils_end

     // Define packet constraints
    // constraint addr_valid   { addr != 2'b11; }
    // constraint payload_size { length == payload.size(); }
    // constraint pct_length   { length > 0; length < 64; }
    // constraint pct_delay    { packet_delay >= 1; packet_delay < 20; }
    // constraint parity_dist  { parity_type dist{GOOD_PARITY := 5, BAD_PARITY:=1}; }
    
    // Constractor
    function new (string name = "apb_packet");
        super.new(name);
    endfunction : new
      
endclass : apb_packet
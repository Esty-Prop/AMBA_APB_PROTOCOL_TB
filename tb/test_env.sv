class test_env extends uvm_env;

     // Component macro
    `uvm_component_utils(test_env)

    // apb environment
    apb_env apb;

     // Constractor
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // APB UVC
        apb = apb_env::type_id::create("apb", this);

    endfunction : build_phase


endclass : test_env
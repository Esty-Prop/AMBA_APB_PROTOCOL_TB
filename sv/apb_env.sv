class apb_env extends uvm_env;

     // Component macro
    `uvm_component_utils(apb_env)

    // components
    apb_agent tx_agent;

    // Constractor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tx_agent = apb_agent::type_id::create("tx_agent", this);
    endfunction : build_phase

endclass : apb_env
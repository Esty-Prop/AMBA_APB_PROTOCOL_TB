class apb_sequencer extends uvm_sequencer #(apb_packet);

    virtual interface apb_if vif;

    `uvm_component_utils(apb_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // function void build_phase(uvm_phase phase);
    //     if (!apb_vif_config::get(this, get_full_name(),"vif", vif))
    //       `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    // endfunction: build_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
      endfunction : start_of_simulation_phase
  

endclass : apb_sequencer
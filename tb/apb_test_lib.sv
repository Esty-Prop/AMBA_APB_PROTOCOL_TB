class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    test_env tb;
    uvm_factory my_f;
     // Constractor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // UVM build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(this, "*","recording_detail",1);
        //`uvm_info ("MSG","Base Test build phase is being executed.",UVM_HIGH)
        tb = test_env::type_id::create("tb", this);
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
      endfunction : start_of_simulation_phase
    
    virtual task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask : run_phase

    // configuration checker
    virtual function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction : check_phase

endclass : base_test

class simple_test extends base_test;

    // component macro
    `uvm_component_utils(simple_test)
  
    // component constructor
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_wrapper::set(this, "tb.apb.tx_agent.sequencer.run_phase",
                                     "default_sequence",
                                     apb_5_packets::get_type());
    endfunction : build_phase
endclass : simple_test


class read_test extends base_test;

    // component macro
    `uvm_component_utils(read_test)
  
    // component constructor
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_wrapper::set(this, "tb.apb.tx_agent.sequencer.run_phase",
                                     "default_sequence",
                                     apb_write_read_same_address::get_type());
    endfunction : build_phase
endclass : read_test


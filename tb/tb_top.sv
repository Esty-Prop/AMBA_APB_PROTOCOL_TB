module tb_top;

    import uvm_pkg::*;

    `include "uvm_macros.svh"

    import apb_pkg::*;
    
    `include "test_env.sv"
    `include "apb_test_lib.sv"

    initial begin 
        apb_vif_config::set(null, "*.tb.apb.*","vif",hw_top.in_if);
        
        run_test();
    end

endmodule : tb_top
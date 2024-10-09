// 64 bit option for AWS labs
-64

-uvmhome $UVMHOME

-timescale 1ns/1ns


// include directories
-incdir ../sv 

// compile files
../sv/apb_pkg.sv
../sv/apb_if.sv 

tb_top.sv
hw_top.sv
../apb_slave/dut.sv



+UVM_TESTNAME=read_test
+UVM_VERBOSITY=UVM_LOW

-gui -access rwc

// +UVM_VERBOSITY=UVM_LOW
// +UVM_TESTNAME=base_test

+SVSEED=random

# simulation
vsim -novopt rtl_lib.testbench_top -l vsim.log

do ../../../../../qsim_prj/Basic.do
#do ../../../../../qsim_prj/Core.do
#do ../../../../../qsim_prj/DUT.do
run -all


quit


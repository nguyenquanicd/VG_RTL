#!/bin/csh -f

# config parameter
set XLEN = 32
set HAS_RVC = 0
set HAS_U = 1
set HAS_S   = 1
set HAS_H   = 0
set HAS_RVA = 0
set HAS_FPU = 0
set HAS_MMU = 0
set HAS_RVM = 1
set HAS_DIV = 1
set CORES   = 1

#testcase list
# Integer list
if (${XLEN} == 32) then
  set U_INT_TESTS = (add addi and andi auipc beg bge bgeu blt bltu bne fence_i jal jalr lb lbu lh lhu lw lui or ori sb sh sw sll slli slt slti sltiu sltu sra srai srl srli sub xor xori)
else if (${XLEN} == 64) then
  set U_INT_TESTS = (add addi and andi auipc beg bge bgeu blt bltu bne fence_i jal jalr lb lbu lh lhu lw lui or ori sb sh sw sll slli slt slti sltiu sltu sra srai srl srli sub xor xori addiw addw lwu ld sd sllw slliw sltu sltiu sraw sraiw srlw srliw subw)
endif

# RVC test
set U_RVC_TEST = (rvc)

#AMO testlist
if (${XLEN} == 32) then
  set U_AMO_TESTS = (amoadd_w amoand_w amomax_w amomaxu_w amomin_w amominu_w amoor_w amoxor_w amoswap_w lrsc)
  set U_MUL_TESTS = (mul mulh mulhu mulhsu)
  set U_DIV_TESTS = (div divu rem remu)
  ###Machine mode test
  set M_TESTS = (breakpoint csr illegal ma_addr ma_fetch mcsr sbreak scall)
  ###Supervisor mode tests
  set S_TEST = (csr dirty illegal ma_fetch sbreak scall wfi)
else if (${XLEN} ==64) then
  set U_AMO_TESTS = (amoadd_w amoand_w amomax_w amomaxu_w amomin_w amominu_w amoor_w amoxor_w amoswap_w lrsc amoadd_d amoand_d amomax_d amomaxu_d amomin_d amominu_d amoor_d amoxor_d amoswap_d)
  set U_MUL_TESTS = (mul mulh mulhu mulhsu mulw)
  set U_DIV_TESTS = (div divu rem remu divw divuw remw remuw)
  ###Machine mode test
  set M_TESTS = (breakpoint csr illegal ma_addr ma_fetch mcsr sbreak scall shamt)
  ###Supervisor mode tests
  set S_TEST = (csr dirty illegal ma_fetch sbreak scall wfi)
endif

#####User mode interger test
set uitst_lst = ""
foreach t (${U_INT_TESTS}) 
  set uitst_lst = (${uitst_lst} rv${XLEN}ui-p-$t)
end

###RVM
if (${HAS_RVM} > 0) then
  foreach t (${U_MUL_TESTS})
    set uitst_lst = (${uitst_lst} rv${XLEN}um-p-$t)
  end
endif
###DIV
if (${HAS_DIV} > 0) then
  foreach t (${U_DIV_TESTS})
    set uitst_lst = (${uitst_lst} rv${XLEN}um-p-$t)
  end
endif
####
set uitests = ""
if (${HAS_U} > 0) then
  set uitests = (${uitst_lst})
endif

########### user mode RVC test
set uctst_lst = ""
if (${HAS_RVC} >0) then
  foreach t (${U_RVC_TESTS})
    set uctst_lst = (uctst_lst rv${XLEN}uc-p-$t)
  end
endif
if (${HAS_U} > 0) then
  set ustests = (${uctst_lst})
endif

#########Supervisor  mode test
set sitst_lst = (${S_TEST})
set sitests =""
if (${HAS_S} > 0)then
  foreach t (${sitst_lst})
    set sitests = (${sitests} rv${XLEN}si-p-$t)
  end
endif

########Machine mode test
set mitst_lst = (${M_TESTS})
set mitests =""
foreach t (${mitst_lst})
  set mitests = (${mitests} rv${XLEN}mi-p-$t)
end

#all tests

set tests = (${uitests} ${mitests})
echo $tests



set ROOT_DIR = "../../../../.."
set TEST_DIR_1 = "${ROOT_DIR}/bench/tests/regression"
set TEST_DIR = "../../../../bench/tests/regression"

set DUT_SRC_DIR = "${ROOT_DIR}/rtl/verilog"
set MEM_SRC_DIR = "${ROOT_DIR}/rtl/verilog/core/memory"

set busif = "axi3"

## RTL list
set RTL_VLOG = "${DUT_SRC_DIR}/pkg/riscv_rv12_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/pkg/riscv_opcodes_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/pkg/riscv_state1.10_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/pkg/riscv_pma_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/pkg/riscv_du_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/pkg/biu_constants_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/pkg/${busif}_pkg.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/ex/riscv_alu.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/ex/riscv_lsu.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/ex/riscv_bu.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/ex/riscv_mul.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/ex/riscv_div.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_ex.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_id.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_if.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_mem.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_wb.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_rf.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_state1.10.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_bp.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_du.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/riscv_core.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1r1w.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1r1w_generic.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1r1w_easic_n3x.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1r1w_easic_n3xs.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1rw.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1rw_generic.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_ram_1rw_easic_n3x.sv "
set RTL_VLOG = "${RTL_VLOG} ${MEM_SRC_DIR}/rl_queue.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_membuf.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_memmisaligned.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_mmu.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_pmachk.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_pmpchk.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/biu_mux.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_imem_ctrl.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/memory/riscv_dmem_ctrl.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/cache/riscv_icache_core.sv"
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/cache/riscv_dcache_core.sv"
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/core/cache/riscv_dext.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/${busif}/biu_${busif}.sv "
set RTL_VLOG = "${RTL_VLOG} ${DUT_SRC_DIR}/${busif}/riscv_top_${busif}.sv "

#Testbench
set TB_SRC_DIR = "${ROOT_DIR}/bench/verilog/${busif}"
set TB_VLOG = "${TB_SRC_DIR}/testbench_top.sv"
set TB_VLOG = "${TB_VLOG} ${TB_SRC_DIR}/memory_model_${busif}.sv"
set TB_VLOG = "${TB_VLOG} ${TB_SRC_DIR}/dbg_bfm.sv"
echo "$RTL_VLOG"
echo "$TB_VLOG"

if (${1} == "regression") then
  #foreach test (`ls ${TEST_DIR} | grep hex | grep rv32 | awk -F "." '{print $1}'`)
  foreach test (${tests})
    echo "$test"
    if (-d $test) then
      rm -rf $test
    endif
    mkdir $test
    cd $test
    ###################### compile
    cp -f ${TEST_DIR_1}/${test}.hex ./test.hex
    if (-d rtl_dir) then
      rm -rf rtl_dir
    endif
    vlib rtl_dir
    vmap rtl_lib rtl_dir
    vlog -work rtl_lib -sv \
    +define+SIM \
    ${RTL_VLOG} \
    ${TB_VLOG}
    
    ########  Simulation
    vsim -c -do ../sim.tcl
    cd ..
  end
else
  foreach test (`cat ${1}`)
    echo $test
    if (-d $test) then
      rm -rf $test
    endif
    mkdir $test
    cd $test
    ###################### compile
    cp -f ${TEST_DIR_1}/${test}.hex ./test.hex
    if (-d rtl_dir) then
      rm -rf rtl_dir
    endif
    vlib rtl_dir
    vmap rtl_lib rtl_dir
    vlog -work rtl_lib -sv \
    +define+SIM \
    ${RTL_VLOG} \
    ${TB_VLOG}

    ########  Simulation
    vsim -c -do ../sim.tcl
    cd .. 
end

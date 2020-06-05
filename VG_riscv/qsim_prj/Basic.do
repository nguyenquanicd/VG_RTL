onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/clk
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/rstn
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/if_nxt_pc
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/if_stall
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/branch_pc
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/branch_taken
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/if_pc
add wave -noupdate -group General -group IF_s /testbench_top/dut/core/if_unit/if_instr
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/id_src1
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/id_src2
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/id_opA
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/id_opB
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/immI
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/immU
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/if_opcode
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/id_opcode
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/ex_opcode
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/mem_opcode
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/wb_opcode
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/id_dst
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/ex_dst
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/mem_dst
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/wb_dst
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/can_bypex
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/can_bypmem
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/can_ldwb
add wave -noupdate -group General -expand -group ID_s /testbench_top/dut/core/id_unit/can_bypwb
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/id_opA
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/id_opB
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/ex_r
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/wb_r
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/opA
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/opB
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/alu_r
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/lsu_r
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/mul_r
add wave -noupdate -group General -expand -group EX_s /testbench_top/dut/core/ex_units/div_r
add wave -noupdate -group General -expand -group MEM_s /testbench_top/dut/core/mem_unit/mem_pc
add wave -noupdate -group General -expand -group MEM_s /testbench_top/dut/core/mem_unit/mem_bubble
add wave -noupdate -group General -expand -group MEM_s /testbench_top/dut/core/mem_unit/mem_instr
add wave -noupdate -group General -expand -group MEM_s /testbench_top/dut/core/mem_unit/dmem_adr
add wave -noupdate -group General -expand -group MEM_s /testbench_top/dut/core/mem_unit/mem_r
add wave -noupdate -group General -expand -group MEM_s /testbench_top/dut/core/mem_unit/mem_memadr
add wave -noupdate -group General -expand -group WB_s /testbench_top/dut/core/wb_unit/wb_stall_o
add wave -noupdate -group General -expand -group WB_s /testbench_top/dut/core/wb_unit/wb_dst_o
add wave -noupdate -group General -expand -group WB_s /testbench_top/dut/core/wb_unit/wb_r_o
add wave -noupdate -group General -expand -group WB_s /testbench_top/dut/core/wb_unit/wb_we_o
add wave -noupdate -group DUT /testbench_top/dut/HRESETn
add wave -noupdate -group DUT /testbench_top/dut/HCLK
add wave -noupdate -group DUT /testbench_top/dut/pma_cfg_i
add wave -noupdate -group DUT /testbench_top/dut/pma_adr_i
add wave -noupdate -group DUT /testbench_top/dut/ins_HSEL
add wave -noupdate -group DUT /testbench_top/dut/ins_HADDR
add wave -noupdate -group DUT /testbench_top/dut/ins_HWDATA
add wave -noupdate -group DUT /testbench_top/dut/ins_HRDATA
add wave -noupdate -group DUT /testbench_top/dut/ins_HWRITE
add wave -noupdate -group DUT /testbench_top/dut/ins_HSIZE
add wave -noupdate -group DUT /testbench_top/dut/ins_HBURST
add wave -noupdate -group DUT /testbench_top/dut/ins_HPROT
add wave -noupdate -group DUT /testbench_top/dut/ins_HTRANS
add wave -noupdate -group DUT /testbench_top/dut/ins_HMASTLOCK
add wave -noupdate -group DUT /testbench_top/dut/ins_HREADY
add wave -noupdate -group DUT /testbench_top/dut/ins_HRESP
add wave -noupdate -group DUT /testbench_top/dut/dat_HSEL
add wave -noupdate -group DUT /testbench_top/dut/dat_HADDR
add wave -noupdate -group DUT /testbench_top/dut/dat_HWDATA
add wave -noupdate -group DUT /testbench_top/dut/dat_HRDATA
add wave -noupdate -group DUT /testbench_top/dut/dat_HWRITE
add wave -noupdate -group DUT /testbench_top/dut/dat_HSIZE
add wave -noupdate -group DUT /testbench_top/dut/dat_HBURST
add wave -noupdate -group DUT /testbench_top/dut/dat_HPROT
add wave -noupdate -group DUT /testbench_top/dut/dat_HTRANS
add wave -noupdate -group DUT /testbench_top/dut/dat_HMASTLOCK
add wave -noupdate -group DUT /testbench_top/dut/dat_HREADY
add wave -noupdate -group DUT /testbench_top/dut/dat_HRESP
add wave -noupdate -group DUT /testbench_top/dut/ext_nmi
add wave -noupdate -group DUT /testbench_top/dut/ext_tint
add wave -noupdate -group DUT /testbench_top/dut/ext_sint
add wave -noupdate -group DUT /testbench_top/dut/ext_int
add wave -noupdate -group DUT /testbench_top/dut/dbg_stall
add wave -noupdate -group DUT /testbench_top/dut/dbg_strb
add wave -noupdate -group DUT /testbench_top/dut/dbg_we
add wave -noupdate -group DUT /testbench_top/dut/dbg_addr
add wave -noupdate -group DUT /testbench_top/dut/dbg_dati
add wave -noupdate -group DUT /testbench_top/dut/dbg_dato
add wave -noupdate -group DUT /testbench_top/dut/dbg_ack
add wave -noupdate -group DUT /testbench_top/dut/dbg_bp
add wave -noupdate -group DUT /testbench_top/dut/if_stall_nxt_pc
add wave -noupdate -group DUT /testbench_top/dut/if_nxt_pc
add wave -noupdate -group DUT /testbench_top/dut/if_stall
add wave -noupdate -group DUT /testbench_top/dut/if_flush
add wave -noupdate -group DUT /testbench_top/dut/if_parcel
add wave -noupdate -group DUT /testbench_top/dut/if_parcel_pc
add wave -noupdate -group DUT /testbench_top/dut/if_parcel_valid
add wave -noupdate -group DUT /testbench_top/dut/if_parcel_misaligned
add wave -noupdate -group DUT /testbench_top/dut/if_parcel_page_fault
add wave -noupdate -group DUT /testbench_top/dut/dmem_req
add wave -noupdate -group DUT /testbench_top/dut/dmem_adr
add wave -noupdate -group DUT /testbench_top/dut/dmem_size
add wave -noupdate -group DUT /testbench_top/dut/dmem_we
add wave -noupdate -group DUT /testbench_top/dut/dmem_d
add wave -noupdate -group DUT /testbench_top/dut/dmem_q
add wave -noupdate -group DUT /testbench_top/dut/dmem_ack
add wave -noupdate -group DUT /testbench_top/dut/dmem_err
add wave -noupdate -group DUT /testbench_top/dut/dmem_misaligned
add wave -noupdate -group DUT /testbench_top/dut/dmem_page_fault
add wave -noupdate -group DUT /testbench_top/dut/st_prv
add wave -noupdate -group DUT /testbench_top/dut/st_pmpcfg
add wave -noupdate -group DUT /testbench_top/dut/st_pmpaddr
add wave -noupdate -group DUT /testbench_top/dut/cacheflush
add wave -noupdate -group DUT /testbench_top/dut/dcflush_rdy
add wave -noupdate -group DUT /testbench_top/dut/ibiu_stb
add wave -noupdate -group DUT /testbench_top/dut/ibiu_stb_ack
add wave -noupdate -group DUT /testbench_top/dut/ibiu_d_ack
add wave -noupdate -group DUT /testbench_top/dut/ibiu_adri
add wave -noupdate -group DUT /testbench_top/dut/ibiu_adro
add wave -noupdate -group DUT /testbench_top/dut/ibiu_size
add wave -noupdate -group DUT /testbench_top/dut/ibiu_type
add wave -noupdate -group DUT /testbench_top/dut/ibiu_we
add wave -noupdate -group DUT /testbench_top/dut/ibiu_lock
add wave -noupdate -group DUT /testbench_top/dut/ibiu_prot
add wave -noupdate -group DUT /testbench_top/dut/ibiu_d
add wave -noupdate -group DUT /testbench_top/dut/ibiu_q
add wave -noupdate -group DUT /testbench_top/dut/ibiu_ack
add wave -noupdate -group DUT /testbench_top/dut/ibiu_err
add wave -noupdate -group DUT /testbench_top/dut/dbiu_stb
add wave -noupdate -group DUT /testbench_top/dut/dbiu_stb_ack
add wave -noupdate -group DUT /testbench_top/dut/dbiu_d_ack
add wave -noupdate -group DUT /testbench_top/dut/dbiu_adri
add wave -noupdate -group DUT /testbench_top/dut/dbiu_adro
add wave -noupdate -group DUT /testbench_top/dut/dbiu_size
add wave -noupdate -group DUT /testbench_top/dut/dbiu_type
add wave -noupdate -group DUT /testbench_top/dut/dbiu_we
add wave -noupdate -group DUT /testbench_top/dut/dbiu_lock
add wave -noupdate -group DUT /testbench_top/dut/dbiu_prot
add wave -noupdate -group DUT /testbench_top/dut/dbiu_d
add wave -noupdate -group DUT /testbench_top/dut/dbiu_q
add wave -noupdate -group DUT /testbench_top/dut/dbiu_ack
add wave -noupdate -group DUT /testbench_top/dut/dbiu_err
add wave -noupdate -group DUT /testbench_top/dut/if_parcel_error
add wave -noupdate -group DUT /testbench_top/dut/dmem_lock
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rstn
add wave -noupdate -group CPU_Core /testbench_top/dut/core/clk
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_stall_nxt_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_nxt_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_stall
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_flush
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_parcel
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_parcel_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_parcel_valid
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_parcel_misaligned
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_parcel_page_fault
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_adr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_d
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_q
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_we
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_size
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_req
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_ack
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_err
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_misaligned
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dmem_page_fault
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_prv
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_pmpcfg
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_pmpaddr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_cacheflush
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ext_nmi
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ext_tint
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ext_sint
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ext_int
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_stall
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_strb
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_we
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_addr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_dati
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_dato
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_ack
add wave -noupdate -group CPU_Core /testbench_top/dut/core/dbg_bp
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_nxt_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_nxt_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/mem_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_instr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_instr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_instr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/mem_instr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_instr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_bubble
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bubble
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_bubble
add wave -noupdate -group CPU_Core /testbench_top/dut/core/mem_bubble
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_bubble
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_flush
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_flush
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_flush
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_stall
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_stall
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_stall
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_stall
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_stall_dly
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bp_bp_predict
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_bp_predict
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bp_predict
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_bp_predict
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_bp_history
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_bp_btaken
add wave -noupdate -group CPU_Core /testbench_top/dut/core/bu_bp_update
add wave -noupdate -group CPU_Core /testbench_top/dut/core/if_exception
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_exception
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_exception
add wave -noupdate -group CPU_Core /testbench_top/dut/core/mem_exception
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_exception
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_srcv2
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_src1
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_src2
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_dst
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_srcv1
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_srcv2
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_dstv
add wave -noupdate -group CPU_Core /testbench_top/dut/core/rf_we
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_opA
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_opB
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_r
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_memadr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/mem_r
add wave -noupdate -group CPU_Core /testbench_top/dut/core/mem_memadr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_userf_opA
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_userf_opB
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bypex_opA
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bypex_opB
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bypmem_opA
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bypmem_opB
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bypwb_opA
add wave -noupdate -group CPU_Core /testbench_top/dut/core/id_bypwb_opB
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_xlen
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_tvm
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_tw
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_tsr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_mcounteren
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_scounteren
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_interrupt
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_csr_reg
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_csr_wval
add wave -noupdate -group CPU_Core /testbench_top/dut/core/st_csr_rval
add wave -noupdate -group CPU_Core /testbench_top/dut/core/ex_csr_we
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_dst
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_r
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_we
add wave -noupdate -group CPU_Core /testbench_top/dut/core/wb_badaddr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_we_rf
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_we_frf
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_we_csr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_we_pc
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_addr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_dato
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_dati_rf
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_dati_frf
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_dati_csr
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_ie
add wave -noupdate -group CPU_Core /testbench_top/dut/core/du_exceptions
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/rstn
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/clk
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/id_stall
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_stall_nxt_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_parcel
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_parcel_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_parcel_valid
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_parcel_misaligned
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_parcel_page_fault
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_instr
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_bubble
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_exception
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/bp_bp_predict
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_bp_predict
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/bu_flush
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/st_flush
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/du_flush
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/bu_nxt_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/st_nxt_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_nxt_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_stall
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_flush
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/if_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/is_16bit_instruction
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/is_32bit_instruction
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/flushes
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/parcel_shift_register
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/new_parcel
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/active_parcel
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/converted_instruction
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/pd_instr
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/pd_bubble
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/pd_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/parcel_valid
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/parcel_sr_valid
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/parcel_sr_bubble
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/opcode
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/parcel_exception
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/pd_exception
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/branch_pc
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/branch_taken
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/immB
add wave -noupdate -group CPU_IF /testbench_top/dut/core/if_unit/immJ
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/illegal_csr_wr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/illegal_csr_rd
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/illegal_muldiv_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/illegal_lsu_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/illegal_alu_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/illegal_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/can_ldwb
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/can_bypwb
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/can_bypmem
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/can_bypex
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/wb_dst
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/mem_dst
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/ex_dst
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_dst
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_src2
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_src1
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/has_h
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/has_s
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/has_u
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/has_amo
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/has_muldiv
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/has_fpu
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/xlen32
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/xlen64
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/xlen
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_func7
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_func3
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/wb_opcode
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/mem_opcode
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/ex_opcode
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_opcode
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_opcode
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/immU
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/immI
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/stall
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/multi_cycle_instruction
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bubble_r
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/wb_r
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/mem_r
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bypwb_opB
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bypwb_opA
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bypmem_opB
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bypmem_opA
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bypex_opB
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bypex_opA
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_userf_opB
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_userf_opA
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_opB
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_opA
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_src2
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_src1
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_scounteren
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_mcounteren
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_tsr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_tw
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_tvm
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_xlen
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_prv
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_exception
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/wb_exception
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/mem_exception
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/ex_exception
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_exception
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/wb_bubble
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/wb_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/mem_bubble
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/mem_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/ex_bubble
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/ex_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bubble
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_bubble
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_instr
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_bp_predict
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_bp_predict
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_pc
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/if_pc
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_nxt_pc
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/bu_nxt_pc
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/du_flush
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/st_flush
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/bu_flush
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/du_stall
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/ex_stall
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/id_stall
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/clk
add wave -noupdate -group CPU_ID /testbench_top/dut/core/id_unit/rstn
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/rstn
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/clk
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/wb_stall
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_stall
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_pc
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_pc
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_nxt_pc
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_flush
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_cacheflush
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bp_predict
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_bp_predict
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_bp_history
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_bp_btaken
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_bp_update
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bubble
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_instr
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_bubble
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_instr
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_exception
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/mem_exception
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/wb_exception
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_exception
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_userf_opA
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_userf_opB
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bypex_opA
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bypex_opB
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bypmem_opA
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bypmem_opB
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bypwb_opA
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_bypwb_opB
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/rf_srcv1
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/rf_srcv2
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/mem_r
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_csr_reg
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_csr_wval
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_csr_we
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/st_prv
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/st_xlen
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/st_flush
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/st_csr_rval
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_adr
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_d
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_req
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_we
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_size
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_ack
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_q
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_misaligned
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/dmem_page_fault
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/du_stall
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/du_stall_dly
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/du_flush
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/du_we_pc
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/du_dato
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/du_ie
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/alu_bubble
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/lsu_bubble
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/mul_bubble
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/div_bubble
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/lsu_stall
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/mul_stall
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/div_stall
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/bu_exception
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/lsu_exception
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_opA
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/id_opB
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/ex_r
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/wb_r
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/opA
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/opB
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/alu_r
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/lsu_r
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/mul_r
add wave -noupdate -group CPU_EX /testbench_top/dut/core/ex_units/div_r
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/rstn
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/clk
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/wb_stall
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/ex_pc
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/mem_pc
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/ex_bubble
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/ex_instr
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/mem_bubble
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/mem_instr
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/ex_exception
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/wb_exception
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/mem_exception
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/ex_r
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/dmem_adr
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/mem_r
add wave -noupdate -expand -group CPU_MEM /testbench_top/dut/core/mem_unit/mem_memadr
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/rst_ni
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/clk_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_stall_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/mem_pc_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_pc_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/mem_instr_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/mem_bubble_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_instr_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_bubble_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/mem_exception_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_exception_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_badaddr_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/mem_r_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/mem_memadr_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/dmem_ack_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/dmem_err_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/dmem_q_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/dmem_misaligned_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/dmem_page_fault_i
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_dst_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_r_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/wb_we_o
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/opcode
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/func3
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/func7
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/dst
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/exception
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/m_data
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/m_qb
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/m_qh
add wave -noupdate -group CPU_WB /testbench_top/dut/core/wb_unit/m_qw
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/rstn
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/clk
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/id_pc
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/id_bubble
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/id_instr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/id_stall
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/bu_flush
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/bu_nxt_pc
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_flush
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_nxt_pc
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/wb_pc
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/wb_bubble
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/wb_instr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/wb_exception
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/wb_badaddr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_interrupt
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_prv
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_xlen
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_tvm
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_tw
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_tsr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_mcounteren
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_scounteren
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_pmpcfg
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_pmpaddr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ext_int
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ext_tint
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ext_sint
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ext_nmi
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ex_csr_reg
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ex_csr_we
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/ex_csr_wval
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_csr_rval
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_stall
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_flush
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_we_csr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_dato
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_addr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_ie
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/du_exceptions
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/csr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/is_rv32
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/is_rv32e
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/is_rv64
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/is_rv128
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_rvc
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_fpu
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_fpud
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_fpuq
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_decfpu
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_mmu
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_muldiv
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_amo
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_bm
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_tmem
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_simd
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_n
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_u
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_s
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_h
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/has_ext
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/mstatus
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/uxl_wval
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/sxl_wval
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/soft_seip
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/soft_ueip
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/take_interrupt
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/st_int
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/interrupt_cause
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/trap_cause
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/csr_raddr
add wave -noupdate -group CPU_STATE /testbench_top/dut/core/cpu_state/csr_wval
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rstn
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/clk
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_src1
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_src2
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_srcv1
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_srcv2
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_we
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_dst
add wave -noupdate -group REGs -expand /testbench_top/dut/core/int_rf/rf
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/rf_dstv
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/du_stall
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/du_we_rf
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/du_dato
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/du_dati_rf
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/du_addr
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/src1_is_x0
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/src2_is_x0
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/dout1
add wave -noupdate -group REGs /testbench_top/dut/core/int_rf/dout2
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/rst_ni
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/clk_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/pma_cfg_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/pma_adr_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/nxt_pc_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/stall_nxt_pc_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/stall_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/flush_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_pc_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_valid_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/err_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/misaligned_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/page_fault_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/cache_flush_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/dcflush_rdy_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/st_pmpcfg_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/st_pmpaddr_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/st_prv_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_stb_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_stb_ack_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_d_ack_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_adri_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_adro_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_size_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_type_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_we_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_lock_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_prot_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_d_o
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_q_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_ack_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_err_i
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_req
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_adr
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_adr_dly
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_size
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_lock
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/buf_prot
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/nxt_pc_queue_req
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/nxt_pc_queue_empty
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/nxt_pc_queue_full
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/misaligned
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/preq
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/padr
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/psize
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/plock
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/pprot
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/page_fault
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/pma_exception
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/pma_misaligned
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/is_cache_access
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/is_ext_access
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/ext_access_req
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/is_tcm_access
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/pmp_exception
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/cache_q
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/cache_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/cache_err
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/tcm_q
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/tcm_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/ext_vadr
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/ext_q
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/ext_access_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/ext_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/ext_err
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_stb
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_stb_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_d_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_adro
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_adri
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_size
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_type
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_we
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_lock
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_prot
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_d
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_q
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_ack
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/biu_err
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_valid
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_queue_d
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_queue_q
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_queue_empty
add wave -noupdate -group IMem /testbench_top/dut/imem_ctrl_inst/parcel_queue_full
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/rst_ni
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/clk_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pma_cfg_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pma_adr_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_req_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_adr_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_size_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_lock_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_we_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_d_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_q_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_ack_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_err_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_misaligned_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/mem_page_fault_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/cache_flush_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/dcflush_rdy_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/st_pmpcfg_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/st_pmpaddr_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/st_prv_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_stb_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_stb_ack_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_d_ack_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_adri_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_adro_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_size_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_type_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_we_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_lock_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_prot_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_d_o
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_q_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_ack_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_err_i
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/queue_d
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/queue_q
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_req
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_adr
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_size
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_lock
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_prot
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_we
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/buf_d
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/misaligned
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/preq
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/padr
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/psize
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/plock
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pprot
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pwe
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pd
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pma_exception
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/is_cache_access
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/is_ext_access
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/ext_access_req
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/is_tcm_access
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/pmp_exception
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/exception
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/cache_q
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/cache_ack
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/cache_err
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/tcm_q
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/tcm_ack
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/ext_q
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/ext_ack
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/ext_err
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_stb
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_stb_ack
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_d_ack
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_adro
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_adri
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_size
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_type
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_we
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_lock
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_prot
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_d
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_q
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_err
add wave -noupdate -expand -group DMem /testbench_top/dut/dmem_ctrl_inst/biu_ack
add wave -noupdate -expand -group DMem /testbench_top/dut/core/du_unit/mem_read
add wave -noupdate -expand -group DMem /testbench_top/dut/core/du_unit/mem_write
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HRESETn
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HCLK
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HSEL
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HADDR
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HRDATA
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HWDATA
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HWRITE
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HSIZE
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HBURST
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HPROT
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HTRANS
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HMASTLOCK
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HREADY
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/HRESP
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_stb_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_stb_ack_o
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_d_ack_o
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_adri_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_adro_o
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_size_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_type_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_prot_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_lock_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_we_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_d_i
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_q_o
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_ack_o
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_err_o
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/burst_cnt
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/data_ena
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/ddata_ena
add wave -noupdate -group I_BIU /testbench_top/dut/ibiu_inst/biu_di_dly
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HRESETn
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HCLK
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HSEL
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HADDR
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HRDATA
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HWDATA
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HWRITE
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HSIZE
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HBURST
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HPROT
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HTRANS
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HMASTLOCK
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HREADY
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/HRESP
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_stb_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_stb_ack_o
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_d_ack_o
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_adri_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_adro_o
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_size_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_type_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_prot_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_lock_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_we_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_d_i
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_q_o
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_ack_o
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_err_o
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/burst_cnt
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/data_ena
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/ddata_ena
add wave -noupdate -group D_BIU /testbench_top/dut/dbiu_inst/biu_di_dly
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/rstn
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/clk
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_stall
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_strb
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_we
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_addr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_dati
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_dato
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_ack
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_bp
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_stall
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_stall_dly
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_flush
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_we_rf
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_we_frf
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_we_csr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_we_pc
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_addr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_dato
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_ie
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_dati_rf
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_dati_frf
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/st_csr_rval
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/if_pc
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/id_pc
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/ex_pc
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/bu_nxt_pc
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/bu_flush
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/st_flush
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/if_instr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/mem_instr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/if_bubble
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/mem_bubble
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/mem_exception
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/mem_memadr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dmem_ack
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/ex_stall
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_exceptions
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg_strb_dly
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_bank_addr
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_sel_internal
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_sel_gprs
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_sel_csrs
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_access
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_we
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_ack
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_we_internal
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/du_internal_regs
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/dbg
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/bp_instr_hit
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/bp_branch_hit
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/bp_hit
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/mem_read
add wave -noupdate -expand -group CPU_DU /testbench_top/dut/core/du_unit/mem_write
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/rstn
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/clk
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_bp_i
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_stall_o
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/rstn
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_bp_i
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/stall_cpu
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_stb_o
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_we_o
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_adr_o
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_dat_o
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_dat_i
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/cpu_ack_i
add wave -noupdate -expand -group Debug_Ctrl /testbench_top/dbg_ctrl/stall_cpu
add wave -noupdate /testbench_top/genblk1/mmio_if_inst/catch_test
add wave -noupdate /testbench_top/genblk1/mmio_if_inst/catch_uart_tx
add wave -noupdate /testbench_top/dut/core/du_unit/ex_stall
add wave -noupdate /testbench_top/dut/core/du_unit/dbg.hit
add wave -noupdate /testbench_top/dut/core/du_unit/dbg
add wave -noupdate /testbench_top/dut/core/du_unit/du_stall
add wave -noupdate /testbench_top/dut/core/du_unit/du_flush
add wave -noupdate /testbench_top/dut/core/du_unit/bu_flush
add wave -noupdate /testbench_top/dut/core/du_unit/st_flush
add wave -noupdate /testbench_top/dut/core/du_unit/du_exceptions
add wave -noupdate /testbench_top/dut/core/du_unit/dbg_bp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1456 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 202
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1404 ns} {1489 ns}

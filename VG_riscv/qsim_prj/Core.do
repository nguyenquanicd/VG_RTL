onerror {resume}
quietly WaveActivateNextPane {} 0
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
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rstn
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/clk
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_stall_nxt_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_nxt_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_stall
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_flush
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_parcel
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_parcel_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_parcel_valid
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_parcel_misaligned
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_parcel_page_fault
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_adr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_d
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_q
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_we
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_size
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_req
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_ack
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_err
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_misaligned
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dmem_page_fault
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_prv
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_pmpcfg
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_pmpaddr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_cacheflush
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ext_nmi
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ext_tint
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ext_sint
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ext_int
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_stall
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_strb
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_we
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_addr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_dati
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_dato
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_ack
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/dbg_bp
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_nxt_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_nxt_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/mem_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_instr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_instr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_instr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/mem_instr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_instr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_bubble
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bubble
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_bubble
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/mem_bubble
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_bubble
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_flush
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_flush
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_flush
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_stall
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_stall
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_stall
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_stall
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_stall_dly
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bp_bp_predict
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_bp_predict
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bp_predict
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_bp_predict
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_bp_history
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_bp_btaken
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/bu_bp_update
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/if_exception
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_exception
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_exception
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/mem_exception
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_exception
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_srcv2
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_src1
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_src2
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_dst
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_srcv1
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_srcv2
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_dstv
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/rf_we
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_opA
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_opB
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_r
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_memadr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/mem_r
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/mem_memadr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_userf_opA
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_userf_opB
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bypex_opA
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bypex_opB
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bypmem_opA
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bypmem_opB
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bypwb_opA
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/id_bypwb_opB
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_xlen
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_tvm
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_tw
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_tsr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_mcounteren
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_scounteren
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_interrupt
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_csr_reg
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_csr_wval
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/st_csr_rval
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/ex_csr_we
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_dst
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_r
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_we
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/wb_badaddr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_we_rf
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_we_frf
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_we_csr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_we_pc
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_addr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_dato
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_dati_rf
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_dati_frf
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_dati_csr
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_ie
add wave -noupdate -expand -group CPU_Core /testbench_top/dut/core/du_exceptions
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {78 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {295 ns}

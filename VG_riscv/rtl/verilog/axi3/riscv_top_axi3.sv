/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//    RISC-V                                                       //
//    Top Level - AMBA3 AHB-Lite Bus Interface                     //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2014-2018 ROA Logic BV                //
//             www.roalogic.com                                    //
//                                                                 //
//     Unless specifically agreed in writing, this software is     //
//   licensed under the RoaLogic Non-Commercial License            //
//   version-1.0 (the "License"), a copy of which is included      //
//   with this file or may be found on the RoaLogic website        //
//   http://www.roalogic.com. You may not use the file except      //
//   in compliance with the License.                               //
//                                                                 //
//     THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY           //
//   EXPRESS OF IMPLIED WARRANTIES OF ANY KIND.                    //
//   See the License for permissions and limitations under the     //
//   License.                                                      //
//                                                                 //
/////////////////////////////////////////////////////////////////////


import riscv_state_pkg::*;
import riscv_pma_pkg::*;
import riscv_du_pkg::*;
import biu_constants_pkg::*;

module riscv_top_ahb3lite #(
  parameter            XLEN               = 32,
  parameter            PLEN               = XLEN,
  parameter [XLEN-1:0] PC_INIT            = 'h200,
  parameter            HAS_USER           = 0,
  parameter            HAS_SUPER          = 0,
  parameter            HAS_HYPER          = 0,
  parameter            HAS_BPU            = 1,
  parameter            HAS_FPU            = 0,
  parameter            HAS_MMU            = 0,
  parameter            HAS_RVM            = 0,
  parameter            HAS_RVA            = 0,
  parameter            HAS_RVC            = 0,
  parameter            IS_RV32E           = 0,

  parameter            MULT_LATENCY       = 0,

  parameter            BREAKPOINTS        = 3,  //Number of hardware breakpoints

  parameter            PMA_CNT            = 16,
  parameter            PMP_CNT            = 16, //Number of Physical Memory Protection entries

  parameter            BP_GLOBAL_BITS     = 2,
  parameter            BP_LOCAL_BITS      = 10,

  parameter            ICACHE_SIZE        = 0,  //in KBytes
  parameter            ICACHE_BLOCK_SIZE  = 32, //in Bytes
  parameter            ICACHE_WAYS        = 2,  //'n'-way set associative
  parameter            ICACHE_REPLACE_ALG = 0,
  parameter            ITCM_SIZE          = 0,

  parameter            DCACHE_SIZE        = 0,  //in KBytes
  parameter            DCACHE_BLOCK_SIZE  = 32, //in Bytes
  parameter            DCACHE_WAYS        = 2,  //'n'-way set associative
  parameter            DCACHE_REPLACE_ALG = 0,
  parameter            DTCM_SIZE          = 0,
  parameter            WRITEBUFFER_SIZE   = 8,

  parameter            TECHNOLOGY         = "GENERIC",

  parameter            MNMIVEC_DEFAULT    = PC_INIT -'h004,
  parameter            MTVEC_DEFAULT      = PC_INIT -'h040,
  parameter            HTVEC_DEFAULT      = PC_INIT -'h080,
  parameter            STVEC_DEFAULT      = PC_INIT -'h0C0,
  parameter            UTVEC_DEFAULT      = PC_INIT -'h100,

  parameter            JEDEC_BANK            = 10,
  parameter            JEDEC_MANUFACTURER_ID = 'h6e,

  parameter            HARTID             = 0,

  parameter            PARCEL_SIZE        = 32,
  
  parameter            DATA_SIZE = XLEN,
  parameter            ADDR_SIZE = PLEN,
  parameter            STRB_SIZE = (DATA_SIZE / 8)
)
(
  //AHB interfaces
  input                               ACLK,
                                      ARESETn,
				
  input  pmacfg_t                     pma_cfg_i [PMA_CNT],
  input  logic    [XLEN         -1:0] pma_adr_i [PMA_CNT],
 
 //
  //AXI3 Bus
  //Instruction
  //AW channel
  output logic [          3:0]  ins_AWID,
  output logic [ADDR_SIZE-1:0]	ins_AWADDR,
  output logic [          3:0]  ins_AWLEN,
  output logic [          2:0]	ins_AWSIZE,
  output logic [          1:0]	ins_AWBURST,
  output logic                  ins_AWVALID,
  input	                        ins_AXI_AWREADY,
  //W channel
  output logic [          3:0]	ins_WID,
  output logic [DATA_SIZE-1:0]	ins_WDATA,
  output logic [STRB_SIZE-1:0]	ins_WSTRB,
  output logic                  ins_WLAST,
  output logic                  ins_WVALID,  
  input	                        ins_AXI_WREADY,
  //B channel (write response)
  input	       [          3:0]	ins_AXI_BID,
  input	       [          1:0]	ins_AXI_BRESP,
  input	                        ins_AXI_BVALID,
  output logic                  ins_BREADY,
  //AR channel
  output logic [          3:0]	ins_ARID,
  output logic [ADDR_SIZE-1:0]	ins_ARADDR,
  output logic [          3:0]	ins_ARLEN,
  output logic [          2:0]	ins_ARSIZE,
  output logic [          1:0]	ins_ARBURST,
  output logic                  ins_ARVALID,
  input                         ins_AXI_ARREADY,
  //R channel
  input	       [          3:0]	ins_AXI_RID,
  input	       [DATA_SIZE-1:0]	ins_AXI_RDATA,
  input	       [          1:0]	ins_AXI_RRESP,
  input	                        ins_AXI_RLAST,
  input	                        ins_AXI_RVALID,
  output logic                  ins_RREADY,
  
  //Data
  //AW channel
  output logic [          3:0]  dat_AWID,
  output logic [ADDR_SIZE-1:0]	dat_AWADDR,
  output logic [          3:0]  dat_AWLEN,
  output logic [          2:0]	dat_AWSIZE,
  output logic [          1:0]	dat_AWBURST,
  output logic                  dat_AWVALID,
  input	                        dat_AXI_AWREADY,
  //W channel
  output logic [          3:0]	dat_WID,
  output logic [DATA_SIZE-1:0]	dat_WDATA,
  output logic [STRB_SIZE-1:0]	dat_WSTRB,
  output logic                  dat_WLAST,
  output logic                  dat_WVALID,  
  input	                        dat_AXI_WREADY,
  //B channel (write response)
  input	       [          3:0]	dat_AXI_BID,
  input	       [          1:0]	dat_AXI_BRESP,
  input	                        dat_AXI_BVALID,
  output logic                  dat_BREADY,
  //AR channel
  output logic [          3:0]	dat_ARID,
  output logic [ADDR_SIZE-1:0]	dat_ARADDR,
  output logic [          3:0]	dat_ARLEN,
  output logic [          2:0]	dat_ARSIZE,
  output logic [          1:0]	dat_ARBURST,
  output logic                  dat_ARVALID,
  input                         dat_AXI_ARREADY,
  //R channel
  input	       [          3:0]	dat_AXI_RID,
  input	       [DATA_SIZE-1:0]	dat_AXI_RDATA,
  input	       [          1:0]	dat_AXI_RRESP,
  input	                        dat_AXI_RLAST,
  input	                        dat_AXI_RVALID,
  output logic                  dat_RREADY,

  //Interrupts
  input                               ext_nmi,
                                      ext_tint,
                                      ext_sint,
  input           [              3:0] ext_int,

  //Debug Interface
  input                               dbg_stall,
  input                               dbg_strb,
  input                               dbg_we,
  input           [DBG_ADDR_SIZE-1:0] dbg_addr,
  input           [XLEN         -1:0] dbg_dati,
  output          [XLEN         -1:0] dbg_dato,
  output                              dbg_ack,
  output                              dbg_bp
);

  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  logic                               if_stall_nxt_pc;
  logic          [XLEN          -1:0] if_nxt_pc;
  logic                               if_stall,
                                      if_flush;
  logic          [PARCEL_SIZE   -1:0] if_parcel;
  logic          [XLEN          -1:0] if_parcel_pc;
  logic          [PARCEL_SIZE/16-1:0] if_parcel_valid;
  logic                               if_parcel_misaligned;
  logic                               if_parcel_page_fault;

  logic                               dmem_req;
  logic          [XLEN          -1:0] dmem_adr;
  biu_size_t                          dmem_size;
  logic                               dmem_we;
  logic          [XLEN          -1:0] dmem_d,
                                      dmem_q;
  logic                               dmem_ack,
                                      dmem_err;
  logic                               dmem_misaligned;
  logic                               dmem_page_fault;

  logic          [               1:0] st_prv;
  pmpcfg_t [15:0]                     st_pmpcfg;
  logic    [15:0][XLEN          -1:0] st_pmpaddr;

  logic                               cacheflush,
                                      dcflush_rdy;

  /* Instruction Memory BIU connections
   */
  logic                               ibiu_stb;
  logic                               ibiu_stb_ack;
  logic                               ibiu_d_ack;
  logic          [PLEN          -1:0] ibiu_adri,
                                      ibiu_adro;
  biu_size_t                          ibiu_size;
  biu_type_t                          ibiu_type;
  logic                               ibiu_we;
  logic                               ibiu_lock;
  biu_prot_t                          ibiu_prot;
  logic          [XLEN          -1:0] ibiu_d;
  logic          [XLEN          -1:0] ibiu_q;
  logic                               ibiu_ack,
                                      ibiu_err;
  /* Data Memory BIU connections
   */
  logic                               dbiu_stb;
  logic                               dbiu_stb_ack;
  logic                               dbiu_d_ack;
  logic          [PLEN          -1:0] dbiu_adri,
                                      dbiu_adro;
  biu_size_t                          dbiu_size;
  biu_type_t                          dbiu_type;
  logic                               dbiu_we;
  logic                               dbiu_lock;
  biu_prot_t                          dbiu_prot;
  logic          [XLEN          -1:0] dbiu_d;
  logic          [XLEN          -1:0] dbiu_q;
  logic                               dbiu_ack,
                                      dbiu_err;


  ////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

  /*
   * Instantiate RISC-V core
   */
  riscv_core #(
    .XLEN                  ( XLEN                  ),
    .HAS_USER              ( HAS_USER              ),
    .HAS_SUPER             ( HAS_SUPER             ),
    .HAS_HYPER             ( HAS_HYPER             ),
    .HAS_BPU               ( HAS_BPU               ),
    .HAS_FPU               ( HAS_FPU               ),
    .HAS_MMU               ( HAS_MMU               ),
    .HAS_RVM               ( HAS_RVM               ),
    .HAS_RVA               ( HAS_RVA               ),
    .HAS_RVC               ( HAS_RVC               ),
    .IS_RV32E              ( IS_RV32E              ),
	 
    .MULT_LATENCY          ( MULT_LATENCY          ),

    .BREAKPOINTS           ( BREAKPOINTS           ),
    .PMP_CNT               ( PMP_CNT               ),

    .BP_GLOBAL_BITS        ( BP_GLOBAL_BITS        ),
    .BP_LOCAL_BITS         ( BP_LOCAL_BITS         ),

    .TECHNOLOGY            ( TECHNOLOGY            ),

    .MNMIVEC_DEFAULT       ( MNMIVEC_DEFAULT       ),
    .MTVEC_DEFAULT         ( MTVEC_DEFAULT         ),
    .HTVEC_DEFAULT         ( HTVEC_DEFAULT         ),
    .STVEC_DEFAULT         ( STVEC_DEFAULT         ),
    .UTVEC_DEFAULT         ( UTVEC_DEFAULT         ),

    .JEDEC_BANK            ( JEDEC_BANK            ),
    .JEDEC_MANUFACTURER_ID ( JEDEC_MANUFACTURER_ID ),

    .HARTID                ( HARTID                ), 

    .PC_INIT               ( PC_INIT               ),
    .PARCEL_SIZE           ( PARCEL_SIZE           )
  )
  core (
    .rstn ( ARESETn ),
    .clk  ( ACLK    ),

    .bu_cacheflush ( cacheflush ),
    .*
  ); 


  /*
   * Instantiate bus interfaces and optional caches
   */

  /* Instruction Memory Access Block
   */
  riscv_imem_ctrl #(
    .XLEN             ( XLEN              ),
    .PLEN             ( PLEN              ),
    .PARCEL_SIZE      ( PARCEL_SIZE       ),

    .PMA_CNT          ( PMA_CNT           ),
    .PMP_CNT          ( PMP_CNT           ),

    .CACHE_SIZE       ( ICACHE_SIZE       ),
    .CACHE_BLOCK_SIZE ( ICACHE_BLOCK_SIZE ),
    .CACHE_WAYS       ( ICACHE_WAYS       ),
    .TCM_SIZE         ( ITCM_SIZE         ) )
  imem_ctrl_inst (
    .rst_ni           ( ARESETn           ),
    .clk_i            ( ACLK              ),

    .pma_cfg_i        ( pma_cfg_i         ),
    .pma_adr_i        ( pma_adr_i         ),

    .nxt_pc_i         ( if_nxt_pc            ),
    .stall_nxt_pc_o   ( if_stall_nxt_pc      ),
    .stall_i          ( if_stall             ),
    .flush_i          ( if_flush             ),
    .parcel_pc_o      ( if_parcel_pc         ),
    .parcel_o         ( if_parcel            ),
    .parcel_valid_o   ( if_parcel_valid      ),
    .err_o            ( if_parcel_error      ),
    .misaligned_o     ( if_parcel_misaligned ),
    .page_fault_o     ( if_parcel_page_fault ),

    .cache_flush_i    ( cacheflush       ),
    .dcflush_rdy_i    ( dcflush_rdy      ),

    .st_prv_i         ( st_prv           ),
    .st_pmpcfg_i      ( st_pmpcfg        ),
    .st_pmpaddr_i     ( st_pmpaddr       ),

    .biu_stb_o        ( ibiu_stb         ),
    .biu_stb_ack_i    ( ibiu_stb_ack     ),
    .biu_d_ack_i      ( ibiu_d_ack       ),
    .biu_adri_o       ( ibiu_adri        ),
    .biu_adro_i       ( ibiu_adro        ),
    .biu_size_o       ( ibiu_size        ),
    .biu_type_o       ( ibiu_type        ),
    .biu_we_o         ( ibiu_we          ),
    .biu_lock_o       ( ibiu_lock        ),
    .biu_prot_o       ( ibiu_prot        ),
    .biu_d_o          ( ibiu_d           ),
    .biu_q_i          ( ibiu_q           ),
    .biu_ack_i        ( ibiu_ack         ),
    .biu_err_i        ( ibiu_err         )
  );


  /* Data Memory Access Block
   */
  riscv_dmem_ctrl #(
    .XLEN             ( XLEN               ),
    .PLEN             ( PLEN               ),

    .PMA_CNT          ( PMA_CNT            ),
    .PMP_CNT          ( PMP_CNT            ),

    .CACHE_SIZE       ( DCACHE_SIZE        ),
    .CACHE_BLOCK_SIZE ( DCACHE_BLOCK_SIZE  ),
    .CACHE_WAYS       ( DCACHE_WAYS        ),
    .TCM_SIZE         ( DTCM_SIZE          ),
    .WRITEBUFFER_SIZE ( WRITEBUFFER_SIZE   ) )
  dmem_ctrl_inst (
    .rst_ni           ( ARESETn          ),
    .clk_i            ( ACLK             ),

    .pma_cfg_i        ( pma_cfg_i        ),
    .pma_adr_i        ( pma_adr_i        ),

    .mem_req_i        ( dmem_req         ),
    .mem_adr_i        ( dmem_adr         ),
    .mem_size_i       ( dmem_size        ),
    .mem_lock_i       ( dmem_lock        ),
    .mem_we_i         ( dmem_we          ),
    .mem_d_i          ( dmem_d           ),
    .mem_q_o          ( dmem_q           ),
    .mem_ack_o        ( dmem_ack         ),
    .mem_err_o        ( dmem_err         ),
    .mem_misaligned_o ( dmem_misaligned  ),
    .mem_page_fault_o ( dmem_page_fault  ),

    .cache_flush_i    ( cacheflush       ),
    .dcflush_rdy_o    ( dcflush_rdy      ),

    .st_prv_i         ( st_prv           ),
    .st_pmpcfg_i      ( st_pmpcfg        ),
    .st_pmpaddr_i     ( st_pmpaddr       ),

    .biu_stb_o        ( dbiu_stb         ),
    .biu_stb_ack_i    ( dbiu_stb_ack     ),
    .biu_d_ack_i      ( dbiu_d_ack       ),
    .biu_adri_o       ( dbiu_adri        ),
    .biu_adro_i       ( dbiu_adro        ),
    .biu_size_o       ( dbiu_size        ),
    .biu_type_o       ( dbiu_type        ),
    .biu_we_o         ( dbiu_we          ),
    .biu_lock_o       ( dbiu_lock        ),
    .biu_prot_o       ( dbiu_prot        ),
    .biu_d_o          ( dbiu_d           ),
    .biu_q_i          ( dbiu_q           ),
    .biu_ack_i        ( dbiu_ack         ),
    .biu_err_i        ( dbiu_err         )
  );


  /* Instantiate BIU
   */
  biu_axi3 #(
    .DATA_SIZE ( XLEN ),
    .ADDR_SIZE ( PLEN )
  )
  ibiu_inst (
    // Outputs
    .AWID                 (ins_AWID       [          3:0] ),
    .AWADDR               (ins_AWADDR     [ADDR_SIZE-1:0] ),
    .AWLEN                (ins_AWLEN      [          3:0] ),
    .AWSIZE               (ins_AWSIZE     [          2:0] ),
    .AWBURST              (ins_AWBURST    [          1:0] ),
    .AWVALID              (ins_AWVALID                    ),
    .WID                  (ins_WID        [          3:0] ),
    .WDATA                (ins_WDATA      [DATA_SIZE-1:0] ),
    .WSTRB                (ins_WSTRB      [STRB_SIZE-1:0] ),
    .WLAST                (ins_WLAST                      ),
    .WVALID               (ins_WVALID                     ),
    .BREADY               (ins_BREADY                     ),
    .ARID                 (ins_ARID       [          3:0] ),
    .ARADDR               (ins_ARADDR     [ADDR_SIZE-1:0] ),
    .ARLEN                (ins_ARLEN      [          3:0] ),
    .ARSIZE               (ins_ARSIZE     [          2:0] ),
    .ARBURST              (ins_ARBURST    [          1:0] ),
    .ARVALID              (ins_ARVALID                    ),
    .RREADY               (ins_RREADY                     ),
    // Inputs
    .ARESETn              (ARESETn                        ),
    .ACLK                 (ACLK                           ),
    .AXI_AWREADY          (ins_AXI_AWREADY                ),
    .AXI_WREADY           (ins_AXI_WREADY                 ),
    .AXI_BID              (ins_AXI_BID    [          3:0] ),
    .AXI_BRESP            (ins_AXI_BRESP  [          1:0] ),
    .AXI_BVALID           (ins_AXI_BVALID                 ),
    .AXI_ARREADY          (ins_AXI_ARREADY                ),
    .AXI_RID              (ins_AXI_RID    [          3:0] ),
    .AXI_RDATA            (ins_AXI_RDATA  [DATA_SIZE-1:0] ),
    .AXI_RRESP            (ins_AXI_RRESP  [          1:0] ),
    .AXI_RLAST            (ins_AXI_RLAST                  ),
    .AXI_RVALID           (ins_AXI_RVALID                 ),

    .biu_stb_i     ( ibiu_stb      ),
    .biu_stb_ack_o ( ibiu_stb_ack  ),
    .biu_d_ack_o   ( ibiu_d_ack    ),
    .biu_adri_i    ( ibiu_adri     ),
    .biu_adro_o    ( ibiu_adro     ),
    .biu_size_i    ( ibiu_size     ),
    .biu_type_i    ( ibiu_type     ),
    .biu_prot_i    ( ibiu_prot     ),
    .biu_lock_i    ( ibiu_lock     ),
    .biu_we_i      ( ibiu_we       ),
    .biu_d_i       ( ibiu_d        ),
    .biu_q_o       ( ibiu_q        ),
    .biu_ack_o     ( ibiu_ack      ),
    .biu_err_o     ( ibiu_err      )
  );

  biu_axi3 #(
    .DATA_SIZE ( XLEN ),
    .ADDR_SIZE ( PLEN )
  )
  dbiu_inst (
    // Outputs
    .AWID                 (dat_AWID       [          3:0] ),
    .AWADDR               (dat_AWADDR     [ADDR_SIZE-1:0] ),
    .AWLEN                (dat_AWLEN      [          3:0] ),
    .AWSIZE               (dat_AWSIZE     [          2:0] ),
    .AWBURST              (dat_AWBURST    [          1:0] ),
    .AWVALID              (dat_AWVALID                    ),
    .WID                  (dat_WID        [          3:0] ),
    .WDATA                (dat_WDATA      [DATA_SIZE-1:0] ),
    .WSTRB                (dat_WSTRB      [STRB_SIZE-1:0] ),
    .WLAST                (dat_WLAST                      ),
    .WVALID               (dat_WVALID                     ),
    .BREADY               (dat_BREADY                     ),
    .ARID                 (dat_ARID       [          3:0] ),
    .ARADDR               (dat_ARADDR     [ADDR_SIZE-1:0] ),
    .ARLEN                (dat_ARLEN      [          3:0] ),
    .ARSIZE               (dat_ARSIZE     [          2:0] ),
    .ARBURST              (dat_ARBURST    [          1:0] ),
    .ARVALID              (dat_ARVALID                    ),
    .RREADY               (dat_RREADY                     ),
    // Inputs
    .ARESETn              (ARESETn                        ),
    .ACLK                 (ACLK                           ),
    .AXI_AWREADY          (dat_AXI_AWREADY                ),
    .AXI_WREADY           (dat_AXI_WREADY                 ),
    .AXI_BID              (dat_AXI_BID    [          3:0] ),
    .AXI_BRESP            (dat_AXI_BRESP  [          1:0] ),
    .AXI_BVALID           (dat_AXI_BVALID                 ),
    .AXI_ARREADY          (dat_AXI_ARREADY                ),
    .AXI_RID              (dat_AXI_RID    [          3:0] ),
    .AXI_RDATA            (dat_AXI_RDATA  [DATA_SIZE-1:0] ),
    .AXI_RRESP            (dat_AXI_RRESP  [          1:0] ),
    .AXI_RLAST            (dat_AXI_RLAST                  ),
    .AXI_RVALID           (dat_AXI_RVALID                 ),

    .biu_stb_i     ( dbiu_stb      ),
    .biu_stb_ack_o ( dbiu_stb_ack  ),
    .biu_d_ack_o   ( dbiu_d_ack    ),
    .biu_adri_i    ( dbiu_adri     ),
    .biu_adro_o    ( dbiu_adro     ),
    .biu_size_i    ( dbiu_size     ),
    .biu_type_i    ( dbiu_type     ),
    .biu_prot_i    ( dbiu_prot     ),
    .biu_lock_i    ( dbiu_lock     ),
    .biu_we_i      ( dbiu_we       ),
    .biu_d_i       ( dbiu_d        ),
    .biu_q_o       ( dbiu_q        ),
    .biu_ack_o     ( dbiu_ack      ),
    .biu_err_o     ( dbiu_err      )
  );

endmodule


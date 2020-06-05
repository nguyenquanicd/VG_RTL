/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//    RISC-V                                                       //
//    Instruction Memory Access Block                              //
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

import biu_constants_pkg::*;

module riscv_icache_ahb3lite #(
  parameter XLEN           = 32,
  parameter PHYS_ADDR_SIZE = XLEN,
  parameter PARCEL_SIZE    = 32,

  parameter SIZE           = 64, //KBYTES
  parameter BLOCK_SIZE     = 32, //BYTES
  parameter WAYS           =  2, // 1           : Direct Mapped
                                 //<n>          : n-way set associative
                                 //<n>==<blocks>: fully associative
  parameter REPLACE_ALG    = 1,  //0: Random
                                 //1: FIFO
                                 //2: LRU

//cacheable region ...
  parameter TECHNOLOGY     = "GENERIC",
  
  parameter DATA_SIZE  = XLEN,
  parameter ADDR_SIZE  = PHYS_ADDR_SIZE,
  parameter STRB_SIZE = (DATA_SIZE / 8)
)
(
  input                           ARESETn,
  input                           ACLK,
 
//
  //AXI3 Bus
  //AW channel
  output logic [          3:0]  AWID,
  output logic [ADDR_SIZE-1:0]	AWADDR,
  output logic [          3:0]  AWLEN,
  output logic [          2:0]	AWSIZE,
  output logic [          1:0]	AWBURST,
  output logic                  AWVALID,
  input	                        AXI_AWREADY,
  //W channel
  output logic [          3:0]	WID,
  output logic [DATA_SIZE-1:0]	WDATA,
  output logic [STRB_SIZE-1:0]	WSTRB,
  output logic                  WLAST,
  output logic                  WVALID,  
  input	                        AXI_WREADY,
  //B channel (write response)
  input	       [          3:0]	AXI_BID,
  input	       [          1:0]	AXI_BRESP,
  input	                        AXI_BVALID,
  output logic                  BREADY,

  //AR channel
  output logic [          3:0]	ARID,
  output logic [ADDR_SIZE-1:0]	ARADDR,
  output logic [          3:0]	ARLEN,
  output logic [          2:0]	ARSIZE,
  output logic [          1:0]	ARBURST,
  output logic                  ARVALID,
  input                         AXI_ARREADY,
  //R channel
  input	       [          3:0]	AXI_RID,
  input	       [DATA_SIZE-1:0]	AXI_RDATA,
  input	       [          1:0]	AXI_RRESP,
  input	                        AXI_RLAST,
  input	                        AXI_RVALID,
  output logic                  RREADY,

  //CPU side
  output                       if_stall_nxt_pc,
  input                        if_stall,
                               if_flush,
  input      [XLEN       -1:0] if_nxt_pc,
  output     [XLEN       -1:0] if_parcel_pc,
  output     [PARCEL_SIZE-1:0] if_parcel,
  output                       if_parcel_valid,
  output                       if_parcel_misaligned,
  input                        bu_cacheflush,
                               dcflush_rdy,

  input       [           1:0] st_prv
);

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  //From Cache Controller Core
  logic                      biu_stb;
  logic                      biu_stb_ack;
  logic                      biu_d_ack;
  logic [PHYS_ADDR_SIZE-1:0] biu_adro,
                             biu_adri;  
  biu_size_t                 biu_size;
  biu_type_t                 biu_type;
  logic                      biu_lock;
  biu_prot_t                 biu_prot;
  logic                      biu_we;
  logic [XLEN          -1:0] biu_di;
  logic [XLEN          -1:0] biu_do;
  logic                      biu_ack;      //data acknowledge, 1 per data
  logic                      biu_err;      //data error,

  logic                      biu_is_cacheable,
                             biu_is_instruction;
  logic [               1:0] biu_prv;       


  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //

generate
if (SIZE == 0)
begin
  /*
   * No Instruction Cache Core
   * Control and glue logic only
   */
   riscv_noicache_core #(
    .XLEN           ( XLEN           ),
    .PHYS_ADDR_SIZE ( PHYS_ADDR_SIZE ),
    .PARCEL_SIZE    ( PARCEL_SIZE    )
  )
  noicache_core_inst (
    //common signals
    .rstn                 ( ARESETn ),
    .clk                  ( ACLK    ),

    //from CPU Core
    //To BIU
    .*
  );
end
else //SIZE > 0
begin
  /*
   * Instantiate Instruction Cache Core
   */
  riscv_icache_core #(
    .XLEN           ( XLEN           ),
    .PHYS_ADDR_SIZE ( PHYS_ADDR_SIZE ),
    .PARCEL_SIZE    ( PARCEL_SIZE    ),

    .SIZE           ( SIZE           ),
    .BLOCK_SIZE     ( BLOCK_SIZE     ),
    .WAYS           ( WAYS           ),
    .REPLACE_ALG    ( REPLACE_ALG    ),
    .TECHNOLOGY     ( TECHNOLOGY     )
  )
  icache_core_inst (
    //common signals
    .rstn                 ( ARESETn ),
    .clk                  ( ACLK    ),

    //from CPU Core
    //To BIU
    .*
  );
end
endgenerate

  /*
   * Instantiate BIU
   */
  biu_axi3 #(
    .DATA_SIZE ( XLEN           ),
    .ADDR_SIZE ( PHYS_ADDR_SIZE )
  )
  biu_inst (
    .biu_stb_i     ( biu_stb     ),
    .biu_stb_ack_o ( biu_stb_ack ),
    .biu_d_ack_o   ( biu_d_ack   ),
    .biu_adri_i    ( biu_adri    ),
    .biu_adro_o    ( biu_adro    ),
    .biu_size_i    ( biu_size    ),
    .biu_type_i    ( biu_type    ),
    .biu_prot_i    ( biu_prot    ),
    .biu_lock_i    ( biu_lock    ),
    .biu_we_i      ( biu_we      ),
    .biu_d_i       ( biu_di      ),
    .biu_q_o       ( biu_do      ),
    .biu_ack_o     ( biu_ack     ),
    .biu_err_o     ( biu_err     ),

    .*
  );

endmodule



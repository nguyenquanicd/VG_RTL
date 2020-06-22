module testbench_top; 

//core parameters
parameter XLEN             = 32;
parameter PLEN             = XLEN;         //32bit address bus
parameter PC_INIT          = 'h8000_0000;  //Start here after reset
parameter BASE             = PC_INIT;      //offset where to load program in memory
parameter INIT_FILE        = "test.hex";
parameter MEM_LATENCY      = 1;
parameter WRITEBUFFER_SIZE = 4;
parameter HAS_U            = 1;
parameter HAS_S            = 1;
parameter HAS_H            = 0;
parameter HAS_MMU          = 0;
parameter HAS_FPU          = 0;
parameter HAS_RVA          = 0;
parameter HAS_RVM          = 0;
parameter MULT_LATENCY     = 0;
parameter CORES            = 1;

parameter HTIF             = 0; //Host-interface
parameter TOHOST           = 32'h80001000;
parameter UART_TX          = 32'h80001080;


//caches
parameter ICACHE_SIZE      = 0;
parameter DCACHE_SIZE      = 0;

parameter PMA_CNT          = 4;

parameter            DATA_SIZE = XLEN             ;
parameter            ADDR_SIZE = PLEN             ;
parameter            STRB_SIZE = (DATA_SIZE / 8)  ;

//////////////////////////////////////////////////////////////////
//
// Constants
//
import riscv_state_pkg::*;
import riscv_pma_pkg::*;
//import ahb3lite_pkg::*;
import axi3_pkg::*;

localparam MULLAT = MULT_LATENCY > 4 ? 4 : MULT_LATENCY;


//////////////////////////////////////////////////////////////////
//
// Variables
//
logic            ACLK, ARESETn;

//PMA configuration
pmacfg_t         pma_cfg [PMA_CNT];
logic [PLEN-1:0] pma_adr [PMA_CNT];

//Instruction interface
logic                     ins_ARREADY       ;
logic                     ins_AWREADY       ;
logic [3:0]               ins_BID           ;
logic [1:0]               ins_BRESP         ;
logic                     ins_BVALID        ;
logic [DATA_SIZE-1:0]     ins_RDATA         ;
logic [3:0]               ins_RID           ;
logic                     ins_RLAST         ;
logic [1:0]               ins_RRESP         ;
logic                     ins_RVALID        ;
logic                     ins_WREADY        ;
logic [ADDR_SIZE-1:0]     ins_ARADDR        ;
logic [1:0]               ins_ARBURST       ;
logic [3:0]               ins_ARID          ;
logic [3:0]               ins_ARLEN         ;
logic [2:0]               ins_ARSIZE        ;
logic                     ins_ARVALID       ;
logic [ADDR_SIZE-1:0]     ins_AWADDR        ;
logic [1:0]               ins_AWBURST       ;
logic [3:0]               ins_AWID          ;
logic [3:0]               ins_AWLEN         ;
logic [2:0]               ins_AWSIZE        ;
logic                     ins_AWVALID       ;
logic                     ins_BREADY        ;
logic                     ins_RREADY        ;
logic [DATA_SIZE-1:0]     ins_WDATA         ;
logic [3:0]               ins_WID           ;
logic                     ins_WLAST         ;
logic [STRB_SIZE-1:0]     ins_WSTRB         ;
logic                     ins_WVALID        ;

//Data interface
logic                     dat_ARREADY       ;
logic                     dat_AWREADY       ;
logic [3:0]               dat_BID           ;
logic [1:0]               dat_BRESP         ;
logic                     dat_BVALID        ;
logic [DATA_SIZE-1:0]     dat_RDATA         ;
logic [3:0]               dat_RID           ;
logic                     dat_RLAST         ;
logic [1:0]               dat_RRESP         ;
logic                     dat_RVALID        ;
logic                     dat_WREADY        ;
logic [ADDR_SIZE-1:0]     dat_ARADDR        ;
logic [1:0]               dat_ARBURST       ;
logic [3:0]               dat_ARID          ;
logic [3:0]               dat_ARLEN         ;
logic [2:0]               dat_ARSIZE        ;
logic                     dat_ARVALID       ;
logic [ADDR_SIZE-1:0]     dat_AWADDR        ;
logic [1:0]               dat_AWBURST       ;
logic [3:0]               dat_AWID          ;
logic [3:0]               dat_AWLEN         ;
logic [2:0]               dat_AWSIZE        ;
logic                     dat_AWVALID       ;
logic                     dat_BREADY        ;
logic                     dat_RREADY        ;
logic [DATA_SIZE-1:0]     dat_WDATA         ;
logic [3:0]               dat_WID           ;
logic                     dat_WLAST         ;
logic [STRB_SIZE-1:0]     dat_WSTRB         ;
logic                     dat_WVALID        ;

//Debug Interface
logic            dbp_bp,
                 dbg_stall,
                 dbg_strb,
                 dbg_ack,
                 dbg_we;
logic [    15:0] dbg_addr;
logic [XLEN-1:0] dbg_dati,
                 dbg_dato;



//Host Interface
logic            host_csr_req,
                 host_csr_ack,
                 host_csr_we;
logic [XLEN-1:0] host_csr_tohost,
                 host_csr_fromhost;


//Unified memory interface
logic                     mem_ARREADY [2] ;
logic                     mem_AWREADY [2] ;
logic [3:0]               mem_BID     [2] ;
logic [1:0]               mem_BRESP   [2] ;
logic                     mem_BVALID  [2] ;
logic [DATA_SIZE-1:0]     mem_RDATA   [2] ;
logic [3:0]               mem_RID     [2] ;
logic                     mem_RLAST   [2] ;
logic [1:0]               mem_RRESP   [2] ;
logic                     mem_RVALID  [2] ;
logic                     mem_WREADY  [2] ;

logic [ADDR_SIZE-1:0]     mem_ARADDR      [2] ;
logic [1:0]               mem_ARBURST     [2] ;
logic [3:0]               mem_ARID        [2] ;
logic [3:0]               mem_ARLEN       [2] ;
logic [2:0]               mem_ARSIZE      [2] ;
logic                     mem_ARVALID     [2] ;
logic [ADDR_SIZE-1:0]     mem_AWADDR      [2] ;
logic [1:0]               mem_AWBURST     [2] ;
logic [3:0]               mem_AWID        [2] ;
logic [3:0]               mem_AWLEN       [2] ;
logic [2:0]               mem_AWSIZE      [2] ;
logic                     mem_AWVALID     [2] ;
logic                     mem_BREADY      [2] ;
logic                     mem_RREADY      [2] ;
logic [DATA_SIZE-1:0]     mem_WDATA       [2] ;
logic [3:0]               mem_WID         [2] ;
logic                     mem_WLAST       [2] ;
logic [STRB_SIZE-1:0]     mem_WSTRB       [2] ;
logic                     mem_WVALID      [2] ;





////////////////////////////////////////////////////////////////
//
// Module Body
//


//Define PMA regions

//crt.0 (ROM) region
assign pma_adr[0]          = TOHOST >> 2;
assign pma_cfg[0].mem_type = MEM_TYPE_MAIN;
assign pma_cfg[0].r        = 1'b1;
assign pma_cfg[0].w        = 1'b1; //this causes fence_i test to fail, which is expected/correct.
                                   //Set to '1' for fence_i test
assign pma_cfg[0].x        = 1'b1;
assign pma_cfg[0].c        = 1'b1; //Should be '0'. Set to '1' to test dcache fence_i
assign pma_cfg[0].cc       = 1'b0;
assign pma_cfg[0].ri       = 1'b0;
assign pma_cfg[0].wi       = 1'b0;
assign pma_cfg[0].m        = 1'b0;
assign pma_cfg[0].amo_type = AMO_TYPE_NONE;
assign pma_cfg[0].a        = TOR;

//TOHOST region
assign pma_adr[1]          = ((TOHOST >> 2) & ~'hf) | 'h7;
assign pma_cfg[1].mem_type = MEM_TYPE_IO;
assign pma_cfg[1].r        = 1'b1;
assign pma_cfg[1].w        = 1'b1;
assign pma_cfg[1].x        = 1'b0;
assign pma_cfg[1].c        = 1'b0;
assign pma_cfg[1].cc       = 1'b0;
assign pma_cfg[1].ri       = 1'b0;
assign pma_cfg[1].wi       = 1'b0;
assign pma_cfg[1].m        = 1'b0;
assign pma_cfg[1].amo_type = AMO_TYPE_NONE;
assign pma_cfg[1].a        = NAPOT;

//UART-Tx region
assign pma_adr[2]          = UART_TX >> 2;
assign pma_cfg[2].mem_type = MEM_TYPE_IO;
assign pma_cfg[2].r        = 1'b0;
assign pma_cfg[2].w        = 1'b1;
assign pma_cfg[2].x        = 1'b0;
assign pma_cfg[2].c        = 1'b0;
assign pma_cfg[2].cc       = 1'b0;
assign pma_cfg[2].ri       = 1'b0;
assign pma_cfg[2].wi       = 1'b0;
assign pma_cfg[2].m        = 1'b0;
assign pma_cfg[2].amo_type = AMO_TYPE_NONE;
assign pma_cfg[2].a        = NA4;

//RAM region
assign pma_adr[3]          = 32'hF0000000 >> 2;
assign pma_cfg[3].mem_type = MEM_TYPE_MAIN;
assign pma_cfg[3].r        = 1'b1;
assign pma_cfg[3].w        = 1'b1;
assign pma_cfg[3].x        = 1'b1;
assign pma_cfg[3].c        = 1'b0;
assign pma_cfg[3].cc       = 1'b0;
assign pma_cfg[3].ri       = 1'b0;
assign pma_cfg[3].wi       = 1'b0;
assign pma_cfg[3].m        = 1'b0;
assign pma_cfg[3].amo_type = AMO_TYPE_NONE;
assign pma_cfg[3].a        = TOR;


//Hookup Device Under Test
riscv_top_axi3 #(
  .XLEN             ( XLEN             ),
  .PLEN             ( PLEN             ), //31bit address bus
  .PC_INIT          ( PC_INIT          ),
  .HAS_USER         ( HAS_U            ),
  .HAS_SUPER        ( HAS_S            ),
  .HAS_HYPER        ( HAS_H            ),
  .HAS_RVA          ( HAS_RVA          ),
  .HAS_RVM          ( HAS_RVM          ),
  .MULT_LATENCY     ( MULLAT           ),

  .PMA_CNT          ( PMA_CNT          ),
  .ICACHE_SIZE      ( ICACHE_SIZE      ),
  .ICACHE_WAYS      ( 1                ),
  .DCACHE_SIZE      ( DCACHE_SIZE      ),
  .DTCM_SIZE        ( 0                ),
  .WRITEBUFFER_SIZE ( WRITEBUFFER_SIZE ),

  .MTVEC_DEFAULT    ( 32'h80000004     )
)
dut (
  .ARESETn   ( ARESETn ),
  .ACLK      ( ACLK    ),

  .pma_cfg_i ( pma_cfg ),
  .pma_adr_i ( pma_adr ),

  .ext_nmi   ( 1'b0    ),
  .ext_tint  ( 1'b0    ),
  .ext_sint  ( 1'b0    ),
  .ext_int   ( 4'h0    ),

  .*
 ); 

//Hookup Debug Unit
dbg_bfm #(
  .DATA_WIDTH ( XLEN ),
  .ADDR_WIDTH ( 16   )
)
dbg_ctrl (
  .rstn ( ARESETn ),
  .clk  ( ACLK    ),

  .cpu_bp_i    ( dbg_bp    ),
  .cpu_stall_o ( dbg_stall ),
  .cpu_stb_o   ( dbg_strb  ),
  .cpu_we_o    ( dbg_we    ),
  .cpu_adr_o   ( dbg_addr  ),
  .cpu_dat_o   ( dbg_dati  ),
  .cpu_dat_i   ( dbg_dato  ),
  .cpu_ack_i   ( dbg_ack   )
);


//bus <-> memory model connections
//I-BIU
assign ins_ARREADY              = mem_ARREADY [0] ;
assign ins_AWREADY              = mem_AWREADY [0] ;
assign ins_BID                  = mem_BID     [0] ;
assign ins_BRESP                = mem_BRESP   [0] ;
assign ins_BVALID               = mem_BVALID  [0] ;
assign ins_RDATA                = mem_RDATA   [0] ;
assign ins_RID                  = mem_RID     [0] ;
assign ins_RLAST                = mem_RLAST   [0] ;
assign ins_RRESP                = mem_RRESP   [0] ;
assign ins_RVALID               = mem_RVALID  [0] ;
assign ins_WREADY               = mem_WREADY  [0] ;

assign mem_ARADDR      [0]    = ins_ARADDR      ;
assign mem_ARBURST     [0]    = ins_ARBURST     ;
assign mem_ARID        [0]    = ins_ARID        ;
assign mem_ARLEN       [0]    = ins_ARLEN       ;
assign mem_ARSIZE      [0]    = ins_ARSIZE      ;
assign mem_ARVALID     [0]    = ins_ARVALID     ;
assign mem_AWADDR      [0]    = ins_AWADDR      ;
assign mem_AWBURST     [0]    = ins_AWBURST     ;
assign mem_AWID        [0]    = ins_AWID        ;
assign mem_AWLEN       [0]    = ins_AWLEN       ;
assign mem_AWSIZE      [0]    = ins_AWSIZE      ;
assign mem_AWVALID     [0]    = ins_AWVALID     ;
assign mem_BREADY      [0]    = ins_BREADY      ;
assign mem_RREADY      [0]    = ins_RREADY      ;
assign mem_WDATA       [0]    = ins_WDATA       ;
assign mem_WID         [0]    = ins_WID         ;
assign mem_WLAST       [0]    = ins_WLAST       ;
assign mem_WSTRB       [0]    = ins_WSTRB       ;
assign mem_WVALID      [0]    = ins_WVALID      ;

//D-BIU
assign dat_ARREADY              = mem_ARREADY [1] ;
assign dat_AWREADY              = mem_AWREADY [1] ;
assign dat_BID                  = mem_BID     [1] ;
assign dat_BRESP                = mem_BRESP   [1] ;
assign dat_BVALID               = mem_BVALID  [1] ;
assign dat_RDATA                = mem_RDATA   [1] ;
assign dat_RID                  = mem_RID     [1] ;
assign dat_RLAST                = mem_RLAST   [1] ;
assign dat_RRESP                = mem_RRESP   [1] ;
assign dat_RVALID               = mem_RVALID  [1] ;
assign dat_WREADY               = mem_WREADY  [1] ;

assign mem_ARADDR      [1]    = dat_ARADDR      ;
assign mem_ARBURST     [1]    = dat_ARBURST     ;
assign mem_ARID        [1]    = dat_ARID        ;
assign mem_ARLEN       [1]    = dat_ARLEN       ;
assign mem_ARSIZE      [1]    = dat_ARSIZE      ;
assign mem_ARVALID     [1]    = dat_ARVALID     ;
assign mem_AWADDR      [1]    = dat_AWADDR      ;
assign mem_AWBURST     [1]    = dat_AWBURST     ;
assign mem_AWID        [1]    = dat_AWID        ;
assign mem_AWLEN       [1]    = dat_AWLEN       ;
assign mem_AWSIZE      [1]    = dat_AWSIZE      ;
assign mem_AWVALID     [1]    = dat_AWVALID     ;
assign mem_BREADY      [1]    = dat_BREADY      ;
assign mem_RREADY      [1]    = dat_RREADY      ;
assign mem_WDATA       [1]    = dat_WDATA       ;
assign mem_WID         [1]    = dat_WID         ;
assign mem_WLAST       [1]    = dat_WLAST       ;
assign mem_WSTRB       [1]    = dat_WSTRB       ;
assign mem_WVALID      [1]    = dat_WVALID      ;


//hookup memory model
memory_model_axi3 #(
    .DATA_SIZE ( XLEN        ),
    .ADDR_SIZE ( PLEN        ),
    .BASE      ( BASE        ),
    .PORTS     ( 2           ),
    .LATENCY   ( MEM_LATENCY )
)
unified_memory
    (
    // Outputs
    .AWID                 (mem_AWID     ),
    .AWADDR               (mem_AWADDR   ),
    .AWLEN                (mem_AWLEN    ),
    .AWSIZE               (mem_AWSIZE   ),
    .AWBURST              (mem_AWBURST  ),
    .AWVALID              (mem_AWVALID  ),
    .WID                  (mem_WID      ),
    .WDATA                (mem_WDATA    ),
    .WSTRB                (mem_WSTRB    ),
    .WLAST                (mem_WLAST    ),
    .WVALID               (mem_WVALID   ),
    .BREADY               (mem_BREADY   ),
    .ARID                 (mem_ARID     ),
    .ARADDR               (mem_ARADDR   ),
    .ARLEN                (mem_ARLEN    ),
    .ARSIZE               (mem_ARSIZE   ),
    .ARBURST              (mem_ARBURST  ),
    .ARVALID              (mem_ARVALID  ),
    .RREADY               (mem_RREADY   ),
    // Inputs
    .ARESETn              (ARESETn),
    .ACLK                 (ACLK),
    .AWREADY              (mem_AWREADY  ),
    .WREADY               (mem_WREADY   ),
    .BID                  (mem_BID      ),
    .BRESP                (mem_BRESP    ),
    .BVALID               (mem_BVALID   ),
    .ARREADY              (mem_ARREADY  ),
    .RID                  (mem_RID      ),
    .RDATA                (mem_RDATA    ),
    .RRESP                (mem_RRESP    ),
    .RLAST                (mem_RLAST    ),
    .RVALID               (mem_RVALID   )
    );

//Front-End Server
generate
  if (HTIF)
  begin
      //Old HTIF interface
      htif #(XLEN)
      htif_inst (
        .rstn              ( ARESETn           ),
        .clk               ( ACLK              ),
        .host_csr_req      ( host_csr_req      ),
        .host_csr_ack      ( host_csr_ack      ),
        .host_csr_we       ( host_csr_we       ),
        .host_csr_tohost   ( host_csr_tohost   ),
        .host_csr_fromhost ( host_csr_fromhost ) );
  end
  else
  begin
      //New MMIO interface
      mmio_if #(XLEN, PLEN, TOHOST, UART_TX)
      mmio_if_inst (
            // Outputs
    .AWID                 (dat_AWID     ),
    .AWADDR               (dat_AWADDR   ),
    .AWLEN                (dat_AWLEN    ),
    .AWSIZE               (dat_AWSIZE   ),
    .AWBURST              (dat_AWBURST  ),
    .AWVALID              (dat_AWVALID  ),
    .WID                  (dat_WID      ),
    .WDATA                (dat_WDATA    ),
    .WSTRB                (dat_WSTRB    ),
    .WLAST                (dat_WLAST    ),
    .WVALID               (dat_WVALID   ),
    .BREADY               (dat_BREADY   ),
    .ARID                 (dat_ARID     ),
    .ARADDR               (dat_ARADDR   ),
    .ARLEN                (dat_ARLEN    ),
    .ARSIZE               (dat_ARSIZE   ),
    .ARBURST              (dat_ARBURST  ),
    .ARVALID              (dat_ARVALID  ),
    .RREADY               (dat_RREADY   ),
    // Inputs
    .ARESETn              (ARESETn),
    .ACLK                 (ACLK),
    .AWREADY              (dat_AWREADY  ),
    .WREADY               (dat_WREADY   ),
    .BID                  (dat_BID      ),
    .BRESP                (dat_BRESP    ),
    .BVALID               (dat_BVALID   ),
    .ARREADY              (dat_ARREADY  ),
    .RID                  (dat_RID      ),
    .RDATA                (dat_RDATA    ),
    .RRESP                (dat_RRESP    ),
    .RLAST                (dat_RLAST    ),
    .RVALID               (dat_RVALID   ) );
  end
endgenerate


//Generate clock
always #1 ACLK = ~ACLK;


initial
begin
    $display("\n\n");
    $display ("------------------------------------------------------------");
    $display (" ,------.                    ,--.                ,--.       ");
    $display (" |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---. ");
    $display (" |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--' ");
    $display (" |  |\\  \\ ' '-' '\\ '-'  |    |  '--.' '-' ' '-' ||  |\\ `--. ");
    $display (" `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---' ");
    $display ("- RISC-V Regression Testbench -----------  `---'  ----------");
    $display ("  XLEN | PRIV | MMU | FPU | RVA | RVM | MULLAT | CORES  ");
    $display ("   %3d | %C%C%C%C | %3d | %3d | %3d | %3d | %6d | %3d   ", 
               XLEN, "M", HAS_H > 0 ? "H" : " ", HAS_S > 0 ? "S" : " ", HAS_U > 0 ? "U" : " ",
               HAS_MMU, HAS_FPU, HAS_RVA, HAS_RVM, MULLAT, CORES);
    $display ("-------------------------------------------------------------");
    $display ("  Test   = %s", INIT_FILE);
    $display ("  ICache = %0dkB", ICACHE_SIZE);
    $display ("  DCache = %0dkB", DCACHE_SIZE);
    $display ("-------------------------------------------------------------");
    $display ("\n");

`ifdef WAVES
    $shm_open("waves");
    $shm_probe("AS",testbench_top,"AS");
    $display("INFO: Signal dump enabled ...\n\n");
`endif

//  unified_memory.read_elf2hex(INIT_FILE);
  unified_memory.read_ihex(INIT_FILE);
  unified_memory.dump;

  ACLK  = 'b0;

  ARESETn = 'b1;
  repeat (5) @(negedge ACLK);
  ARESETn = 'b0;
  repeat (5) @(negedge ACLK);
  ARESETn = 'b1;


  #112;
  //stall CPU
  dbg_ctrl.stall;

  //Enable BREAKPOINT to call external debugger
//  dbg_ctrl.write('h0004,'h0008);

  //Enable Single Stepping
  dbg_ctrl.write('h0000,'h0001);

  //single step through 10 instructions
  repeat (100)
  begin
      while (!dbg_ctrl.stall_cpu) @(posedge ACLK);
      repeat(15) @(posedge ACLK);
      dbg_ctrl.write('h0001,'h0000); //clear single-step-hit
      dbg_ctrl.unstall;
  end

  //last time ...
  @(posedge ACLK);
  while (!dbg_ctrl.stall_cpu) @(posedge ACLK);
  //disable Single Stepping
  dbg_ctrl.write('h0000,'h0000);
  dbg_ctrl.write('h0001,'h0000);
  dbg_ctrl.unstall;

end		

endmodule



/*
 * MMIO Interface
 */
module mmio_if #(
  parameter DATA_SIZE    = 32,
  parameter ADDR_SIZE    = 32,
  parameter CATCH_TEST    = 80001000,
  parameter CATCH_UART_TX = 80001080,
  parameter STRB_SIZE = (DATA_SIZE / 8)
)
(
  //
  //AXI3 Bus
  //Clock, Reset
  input  logic                 ARESETn,
  input  logic                 ACLK,
 
  //
  //AXI3 Bus
  //AW channel
  input                [          3:0]  AWID      ,
  input                [ADDR_SIZE-1:0]	AWADDR    ,
  input                [          3:0]  AWLEN     ,
  input                [          2:0]	AWSIZE    ,
  input                [          1:0]	AWBURST   ,
  input                                 AWVALID   ,
  input logic	                        AWREADY   ,
  //W channel
  input                [          3:0]	WID       ,
  input                [DATA_SIZE-1:0]	WDATA     ,
  input                [STRB_SIZE-1:0]	WSTRB     ,
  input                                 WLAST     ,
  input                                 WVALID    ,
  input logic	                        WREADY    ,
  //B channel (write response)
  input logic	       [          3:0]	BID       ,
  input logic	       [          1:0]	BRESP     ,
  input logic	                        BVALID    ,
  input                                 BREADY    ,

  //AR channel
  input                [          3:0]	ARID      ,
  input                [ADDR_SIZE-1:0]	ARADDR    ,
  input                [          3:0]	ARLEN     ,
  input                [          2:0]	ARSIZE    ,
  input                [          1:0]	ARBURST   ,
  input                                 ARVALID   ,
  input logic                          ARREADY   ,
  //R channel                                     
  input logic	       [          3:0]	RID       ,
  input logic	       [DATA_SIZE-1:0]	RDATA     ,
  input logic	       [          1:0]	RRESP     ,
  input logic	                        RLAST     ,
  input logic	                        RVALID    ,
  input                                 RREADY    
);
  //
  // Variables
  //
  logic  [DATA_SIZE-1:0] data_reg;
  logic                  catch_test,
                         catch_uart_tx;


  logic                  dAWVALID;
  logic  [ADDR_SIZE-1:0] dAWADDR ;


  //
  // Functions
  //
  function string hostcode_to_string;
    input integer hostcode;

    case (hostcode)
      1337: hostcode_to_string = "OTHER EXCEPTION";
    endcase
  endfunction


  //
  // Module body
  //
  //import ahb3lite_pkg::*;
  import axi3_pkg::*;


  //Generate watchdog counter
  integer watchdog_cnt;
  always @(posedge ACLK,negedge ARESETn)
    if (!ARESETn) watchdog_cnt <= 0;
    else          watchdog_cnt <= watchdog_cnt +1;


  //Catch write to host address
  assign RRESP = RESP_OKAY;
  assign BRESP = RESP_OKAY;

  always @(posedge ACLK)
  begin
      dAWVALID <= AWVALID;
      dAWADDR  <= AWADDR;
  end


  always @(posedge ACLK,negedge ARESETn)
    if (!ARESETn)
    begin
        //AWREADY  <= 1'b1;
    end
    else if (AWVALID == 0)
    begin
    end


  always @(posedge ACLK,negedge ARESETn)
    if (!ARESETn)
    begin
         catch_test    <= 1'b0;
         catch_uart_tx <= 1'b0;
    end
    else
    begin
        catch_test    <= dAWVALID && dAWADDR == CATCH_TEST;
        catch_uart_tx <= dAWVALID && dAWADDR == CATCH_UART_TX;
        data_reg      <= WDATA;
    end


  /*
   * Generate output
   */

  //Simulated UART Tx (prints characters on screen)
  always @(posedge ACLK)
    if (catch_uart_tx) $write ("%0c", data_reg);


  //Tests ...
  always @(posedge ACLK)
  begin
      if (watchdog_cnt > 1000_000 || catch_test)
      begin
          $display("\n\n");
          $display("-------------------------------------------------------------");
          $display("* RISC-V test bench finished");
          if (data_reg[0] == 1'b1)
          begin
              if (~|data_reg[DATA_SIZE-1:1])
                $display("* PASSED %0d", data_reg);
              else
                $display ("* FAILED: code: 0x%h (%0d: %s)", data_reg >> 1, data_reg >> 1, hostcode_to_string(data_reg >> 1) );
          end
          else
            $display ("* FAILED: watchdog count reached (%0d) @%0t", watchdog_cnt, $time);
            $display("-------------------------------------------------------------");
          $display("\n");

          $finish();
          //$stop();
      end
  end
endmodule



/*
 * HTIF Interface
 */
module htif #(
  parameter XLEN=32
)
(
  input             rstn,
  input             clk,

  output            host_csr_req,
  input             host_csr_ack,
  output            host_csr_we,
  input  [XLEN-1:0] host_csr_tohost,
  output [XLEN-1:0] host_csr_fromhost
);
  function string hostcode_to_string;
    input integer hostcode;

    case (hostcode)
      1337: hostcode_to_string = "OTHER EXCEPTION";
    endcase
  endfunction


  //Generate watchdog counter
  integer watchdog_cnt;
  always @(posedge clk,negedge rstn)
    if (!rstn) watchdog_cnt <= 0;
    else       watchdog_cnt <= watchdog_cnt +1;


  always @(posedge clk)
  begin
      if (watchdog_cnt > 200_000 || host_csr_tohost[0] == 1'b1)
      begin
          $display("\n\n");
          $display("*****************************************************");
          $display("* RISC-V test bench finished");
          if (host_csr_tohost[0] == 1'b1)
          begin
              if (~|host_csr_tohost[XLEN-1:1])
                $display("* PASSED %0d", host_csr_tohost);
              else
                $display ("* FAILED: code: 0x%h (%0d: %s)", host_csr_tohost >> 1, host_csr_tohost >> 1, hostcode_to_string(host_csr_tohost >> 1) );
          end
          else
            $display ("* FAILED: watchdog count reached (%0d) @%0t", watchdog_cnt, $time);
          $display("*****************************************************");
          $display("\n");

          $finish();
      end
  end
endmodule






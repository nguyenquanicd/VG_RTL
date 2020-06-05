/*
 * Assert all biu_*_i signals until biu_stb_ack_i is asserted.
 * biu_stb_i must be negated once biu_stb_ack_o is asserted.
 * Upon completion of the transfer biu_ack_o is asserted
 * biu_err_o is asserted if there was a transfer error
 */


import axi3_pkg::*;
import biu_constants_pkg::*;

module biu_axi3 #(
  parameter DATA_SIZE = 32,
  parameter ADDR_SIZE = DATA_SIZE,
  parameter STRB_SIZE = (DATA_SIZE / 8),
  parameter BIU_ID    = 4'b0001
)
(
  //Clock, Reset
  input  logic                 ARESETn,
  input  logic                 ACLK,
 
  //
  //AXI3 Bus
  //AW channel
  output logic [          3:0]  AWID,
  output logic [ADDR_SIZE-1:0]	AWADDR,
  output logic [          3:0]  AWLEN,
  output logic [          2:0]	AWSIZE,
  output logic [          1:0]	AWBURST,
  output logic                  AWVALID,
  input	                        AWREADY,
  //W channel
  output logic [          3:0]	WID,
  output logic [DATA_SIZE-1:0]	WDATA,
  output logic [STRB_SIZE-1:0]	WSTRB,
  output logic                  WLAST,
  output logic                  WVALID,  
  input	                        WREADY,
  //B channel (write response)
  input	       [          3:0]	BID,
  input	       [          1:0]	BRESP,
  input	                        BVALID,
  output logic                  BREADY,

  //AR channel
  output logic [          3:0]	ARID,
  output logic [ADDR_SIZE-1:0]	ARADDR,
  output logic [          3:0]	ARLEN,
  output logic [          2:0]	ARSIZE,
  output logic [          1:0]	ARBURST,
  output logic                  ARVALID,
  input                         ARREADY,
  //R channel
  input	       [          3:0]	RID,
  input	       [DATA_SIZE-1:0]	RDATA,
  input	       [          1:0]	RRESP,
  input	                        RLAST,
  input	                        RVALID,
  output logic                  RREADY,


  //BIU Bus (Core ports)
  input  logic                 biu_stb_i,      //strobe
  output logic                 biu_stb_ack_o,  //strobe acknowledge; can send new strobe (handshake for request)
  output logic                 biu_d_ack_o,    //data acknowledge (send new biu_d_i); for pipelined buses (handshake for data)
  input  logic [ADDR_SIZE-1:0] biu_adri_i,     //request address from CPU
  output logic [ADDR_SIZE-1:0] biu_adro_o,     //current address in burst
  input  biu_size_t            biu_size_i,     //transfer size
  input  biu_type_t            biu_type_i,     //burst type
  input  biu_prot_t            biu_prot_i,     //protection
  input  logic                 biu_lock_i,
  input  logic                 biu_we_i,
  input  logic [DATA_SIZE-1:0] biu_d_i,
  output logic [DATA_SIZE-1:0] biu_q_o,
  output logic                 biu_ack_o,      //transfer acknowledge
  output logic                 biu_err_o       //transfer error
);

  //////////////////////////////////////////////////////////////////
  //
  // Constants
  //

  //////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  //logic [          3:0] burst_cnt;
  //logic                 addr_ena,
  //                      data_ena;
  logic [DATA_SIZE-1:0] biu_di_dly;

  //internal logics
  logic biu_write;
  logic aw_handshake;
  logic req_burst;
  logic wdata_update;
  logic w_handshake;
  logic [6:0] addr_buffer;
  logic [3:0] wr_cnt;
  logic wlast_setup;
  logic wresp_ok;
  logic wr_ack;
  logic wr_err;
  logic b_handshake;

  logic ar_handshake;
  logic r_handshake;
  logic biu_data_ready;
  logic [3:0] rd_cnt;
  logic rresp_ok;
  logic rd_ack;
  logic rd_err;

  
  
  
  //////////////////////////////////////////////////////////////////
  //
  // Module Body
  //
  always @(posedge ACLK) begin
    if (!ARESETn)
        biu_write  <=#1 1'b0;
    else if (biu_stb_ack_o)
        biu_write  <=#1 biu_we_i;
  end
  
  //AW channel
  assign AWID = BIU_ID;
  
  always @(posedge ACLK) begin
    if (biu_stb_ack_o) begin
        AWADDR  <=#1 biu_adri_i;
        AWLEN   <=#1 biu_type2xlen(biu_type_i);
        AWSIZE  <=#1 biu_size2xsize(biu_size_i);
        AWBURST <=#1 biu_type2xburst(biu_type_i);
    end  
  end
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        AWVALID  <=#1 1'b0;
    else if (biu_stb_ack_o & biu_we_i)
        AWVALID  <=#1 1'b1;
    else if (AWREADY)
        AWVALID  <=#1 1'b0;
  end
  
  assign aw_handshake = AWVALID & AWREADY;


  //W channel
  assign WID = BIU_ID;
  assign wdata_update = aw_handshake | (~WLAST & w_handshake);
  
  always @(posedge ACLK) begin
    if (wdata_update) begin
      WDATA  <=#1 biu_d_i; //
      WSTRB  <=#1 biu_size2xstrb(addr_buffer, biu_size2xsize(biu_size_i));
    end
  end
  
  assign req_burst = (AWBURST == XBURST_INCR) | (AWBURST == XBURST_WRAP);
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        wr_cnt  <=#1 'd0;
    else if (w_handshake & WLAST)
        wr_cnt  <=#1 'd0;
    else if (w_handshake & req_burst)
        wr_cnt  <=#1 wr_cnt + 1'b1;
  end
  
  assign wlast_setup = (~req_burst & aw_handshake) | (req_burst & (wr_cnt == (AWLEN - 1)) & w_handshake);
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        WLAST  <=#1 1'b0;
    else if (wlast_setup)
        WLAST  <=#1 1'b1;
    else if (w_handshake)
        WLAST  <=#1 1'b0;
  end
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        WVALID  <=#1 1'b0;
    else if (wdata_update)
        WVALID  <=#1 1'b1;
    else if (w_handshake & WLAST )
        WVALID  <=#1 1'b0;
  end
  
  assign w_handshake = WVALID & WREADY;
  
  //B channel (write response)
  assign BREADY = 1'b1;
  assign b_handshake = BVALID;
  assign wresp_ok = (BRESP[1] == 1'b0) & (BID == BIU_ID);
  assign wr_ack = wresp_ok & b_handshake;
  assign wr_err = ~wresp_ok & b_handshake;
  
  
  //AR channel
  assign ARID = BIU_ID;
  assign ARADDR   = AWADDR;
  assign ARLEN    = AWLEN;
  assign ARSIZE   = AWSIZE;
  assign ARBURST  = AWBURST;
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        ARVALID  <=#1 1'b0;
    else if (biu_stb_ack_o & ~biu_we_i)
        ARVALID  <=#1 1'b1;
    else if (ARREADY)
        ARVALID  <=#1 1'b0;
  end
  
  assign ar_handshake = ARVALID & ARREADY;
  
  assign biu_q_o = RDATA;
  assign RREADY = 1'b1;
  assign r_handshake = RVALID;
  assign rresp_ok = (RRESP[1] == 1'b0) & (RID == BIU_ID);
  assign rd_ack = rresp_ok & biu_data_ready;
  assign rd_err = ~wresp_ok & biu_data_ready;
  assign biu_data_ready = r_handshake & (~RLAST | (RLAST & (rd_cnt == ARLEN)));
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        rd_cnt  <=#1 'd0;
    else if (r_handshake & ~RLAST)
        rd_cnt  <=#1 rd_cnt + 1'b1;
    else if (RLAST & (rd_cnt = ARLEN))
        rd_cnt  <=#1 'd0;
  end
  
  
  
  
  
  
  
  
  
  
  //Using for both Write and Read
  assign biu_stb_ack_o = biu_stb_i & ~AWVALID & ~ARVALID;
  assign biu_ack_o = wr_ack | rd_ack;
  assign biu_err_o = wr_err | rd_err;
  
  always @(posedge ACLK) begin
    if (!ARESETn)
        addr_buffer  <=#1 'd0;
    else if (biu_stb_ack_o)
        addr_buffer  <=#1 biu_adri_i[6:0];
    else if (w_handshake)
        if (biu_write)
            addr_buffer  <=#1 nxt_addr(addr_buffer, AWBURST, AWLEN);
        else
            addr_buffer  <=#1 nxt_addr(addr_buffer, ARBURST, ARLEN);
  end
  
  assign biu_adro_o = {AWADDR[ADDR_SIZE-1:7], addr_buffer[6:0]};
  
  //Data section
  always @(posedge ACLK) 
    if (AWREADY | WREADY) biu_di_dly <=#1 biu_d_i;

  //always @(posedge ACLK)
  //  if (AWREADY | WREADY)
  //  begin
  //      WDATA      <=#1 biu_di_dly;
  //      biu_adro_o <=#1 {AWADDR[ADDR_SIZE-1:7], addr_buffer[6:0]};
  //  end

  //always @(posedge ACLK,negedge ARESETn)
  //  if      (!ARESETn) data_ena <=#1 1'b0;
  //  else if ( AWREADY ) data_ena <=#1 addr_ena;


  //assign biu_ack_o      = AWREADY & data_ena;
  assign biu_d_ack_o    = wdata_update;


//////////////////////////////////////////////////////////////////
  //
  // Functions
  //
  function automatic [2:0] biu_size2xsize;
    input biu_size_t size;

    case (size)
      BYTE   : biu_size2xsize = XSIZE_1;
      HWORD  : biu_size2xsize = XSIZE_2;
      WORD   : biu_size2xsize = XSIZE_4;
      DWORD  : biu_size2xsize = XSIZE_8;
      default: biu_size2xsize = 3'hx; //OOPSS
    endcase
  endfunction: biu_size2xsize


  //convert burst type to wr_cnt length (actually length -1)
  function automatic [3:0] biu_type2xlen;
    input biu_type_t biu_type;

    case (biu_type)
      SINGLE : biu_type2xlen =  0;
      INCR   : biu_type2xlen =  0;
      WRAP4  : biu_type2xlen =  3;
      INCR4  : biu_type2xlen =  3;
      WRAP8  : biu_type2xlen =  7;
      INCR8  : biu_type2xlen =  7;
      WRAP16 : biu_type2xlen = 15;
      INCR16 : biu_type2xlen = 15;
      default: biu_type2xlen = 4'hx; //OOPS
    endcase
  endfunction: biu_type2xlen


  //convert burst type to wr_cnt length (actually length -1)
  function automatic [2:0] biu_type2xburst;
    input biu_type_t biu_type;

    case (biu_type)
      SINGLE : 
            biu_type2xburst = XBURST_FIXED;
      INCR, INCR4, INCR8, INCR16   :
            biu_type2xburst = XBURST_INCR;
      WRAP4, WRAP8, WRAP16  : 
            biu_type2xburst = XBURST_WRAP;
      default: biu_type2xburst = XBURST_RESERVED; //OOPS
    endcase
  endfunction: biu_type2xburst


  //convert burst type to wr_cnt length (actually length -1)
  function automatic [ADDR_SIZE-1:0] nxt_addr;
    input [6:0] addr;   //current address
    input [          2:0] burst; //burst type
    input [          3:0] len;   //burst length


    //next linear address
    if (DATA_SIZE==32) nxt_addr = (addr + 'h4) & ~'h3;
    else               nxt_addr = (addr + 'h8) & ~'h7;

    if (burst == XBURST_WRAP) begin
        case (len)
          3 : nxt_addr = (DATA_SIZE==32) ? {addr[6: 4],nxt_addr[3:0]} : {addr[6:5],nxt_addr[4:0]};
          7 : nxt_addr = (DATA_SIZE==32) ? {addr[6: 5],nxt_addr[4:0]} : {addr[6:6],nxt_addr[5:0]};
          15: nxt_addr = (DATA_SIZE==32) ? {addr[6: 6],nxt_addr[5:0]} : {nxt_addr[6:0]};
          default      : ;
        endcase
    end
  endfunction: nxt_addr

  //convert size to byte strobe
  function automatic [STRB_SIZE-1:0] biu_size2xstrb;
    input [6:0] addr;   //current address
    input [          2:0] size;   //burst type

    biu_size2xstrb = 'd0; 
    if (DATA_SIZE == 32) begin
        case(size)
            XSIZE_1 : biu_size2xstrb[addr[1:0]] = 1'b1;
            XSIZE_2 : 
                if (addr[1] == 0)
                    biu_size2xstrb[1:0] = 2'b11;
                else
                    biu_size2xstrb[3:2] = 2'b11;
            //XSIZE_4 : ;
            default : biu_size2xstrb[3:0] = 4'b1111;   
        endcase
    end
    else begin
        case(size)
            XSIZE_1 : biu_size2xstrb[addr[2:0]] = 1'b1;
            XSIZE_2 :
                case(addr[2:1])
                    2'b00: biu_size2xstrb[1:0] = 2'b11;
                    2'b01: biu_size2xstrb[3:2] = 2'b11;
                    2'b10: biu_size2xstrb[5:4] = 2'b11;
                    2'b11: biu_size2xstrb[7:6] = 2'b11;
                    default: ;
                endcase                
            XSIZE_4 : 
                if (addr[2] == 0)
                    biu_size2xstrb[3:0] = 4'b1111;
                else
                    biu_size2xstrb[7:4] = 4'b1111;
            //XSIZE_8
            default : biu_size2xstrb[7:0] = {8{1'b1}};
        endcase
    end    
  endfunction: biu_size2xstrb



  //convert burst type to wr_cnt length (actually length -1)
  function automatic [3:0] biu_prot2hprot;
    input biu_prot_t biu_prot;

    /*
    biu_prot2hprot  = biu_prot & PROT_DATA       ? APROT_DATA       : APROT_OPCODE;
    biu_prot2hprot |= biu_prot & PROT_PRIVILEGED ? APROT_PRIVILEGED : APROT_USER;
    biu_prot2hprot |= biu_prot & PROT_CACHEABLE  ? APROT_CACHEABLE  : APROT_NON_CACHEABLE;
    */
  endfunction: biu_prot2hprot


endmodule



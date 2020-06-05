import axi3_pkg::*;
import biu_constants_pkg::*;

module memory_model_axi3 #(
  parameter DATA_SIZE = 32,
  parameter ADDR_SIZE = DATA_SIZE,
  parameter STRB_SIZE = (DATA_SIZE / 8),
  parameter BIU_ID    = 4'b0001,
  
  parameter BASE       = 'h0,  //offset where to load program

  parameter PORTS      = 2,
  parameter LATENCY    = 1,
  parameter BURST      = 8
)
(
  //Clock, Reset
  input  logic                 ARESETn,
  input  logic                 ACLK,
 
  //
  //AXI3 Bus
  //AW channel
  input                [          3:0]  AWID           [PORTS],
  input                [ADDR_SIZE-1:0]	AWADDR         [PORTS],
  input                [          3:0]  AWLEN          [PORTS],
  input                [          2:0]	AWSIZE         [PORTS],
  input                [          1:0]	AWBURST        [PORTS],
  input                                 AWVALID        [PORTS],
  output logic	                        AWREADY        [PORTS],
  //W channel
  input                [          3:0]	WID            [PORTS],
  input                [DATA_SIZE-1:0]	WDATA          [PORTS],
  input                [STRB_SIZE-1:0]	WSTRB          [PORTS],
  input                                 WLAST          [PORTS],
  input                                 WVALID         [PORTS],
  output logic	                        WREADY         [PORTS],
  //B channel (write response)
  output logic	       [          3:0]	BID            [PORTS],
  output logic	       [          1:0]	BRESP          [PORTS],
  output logic	                        BVALID         [PORTS],
  input                                 BREADY         [PORTS],

  //AR channel
  input                [          3:0]	ARID           [PORTS],
  input                [ADDR_SIZE-1:0]	ARADDR         [PORTS],
  input                [          3:0]	ARLEN          [PORTS],
  input                [          2:0]	ARSIZE         [PORTS],
  input                [          1:0]	ARBURST        [PORTS],
  input                                 ARVALID        [PORTS],
  output logic                          ARREADY        [PORTS],
  //R channel                                          
  output logic	       [          3:0]	RID            [PORTS],
  output logic	       [DATA_SIZE-1:0]	RDATA          [PORTS],
  output logic	       [          1:0]	RRESP          [PORTS],
  output logic	                        RLAST          [PORTS],
  output logic	                        RVALID         [PORTS],
  input                                 RREADY         [PORTS]
);

  ////////////////////////////////////////////////////////////////
  //
  // Typedefs
  //
  typedef bit  [           7:0] octet;
  typedef bit  [DATA_SIZE-1:0] data_type;
  typedef logic[ADDR_SIZE-1:0] addr_type;


  ////////////////////////////////////////////////////////////////
  //
  // Variables
  //
  integer i,j;
  genvar  p;

  localparam RADRCNT_MSB = $clog2(BURST) + $clog2(DATA_SIZE/8)-1;

  data_type mem_array[addr_type];
  logic [ADDR_SIZE   -1:0]  raddr   [PORTS],
                            waddr   [PORTS];
  logic [RADRCNT_MSB    :0] radrcnt [PORTS];

  logic                     wreq    [PORTS];
  logic [DATA_SIZE/8 -1:0]  dbe     [PORTS];

  logic [LATENCY        :1] ack_latency [PORTS];
  logic [              3:0] rd_cnt [PORTS];
  logic                     rd_update [PORTS];

  ////////////////////////////////////////////////////////////////
  //
  // Tasks
  //

  /*
   * Read Intel HEX
   */
  task automatic read_ihex;
    input string file;

    integer i;
    integer fd,
            cnt,
            eof;
    reg   [ 31:0] tmp;

    octet         byte_cnt;
    octet [  1:0] address;
    octet         record_type;
    octet [255:0] data;
    octet         checksum, crc;

    addr_type     base_addr=BASE;
    /*
     * 1: start code
     * 2: byte count  (2 hex digits)
     * 3: address     (4 hex digits)
     * 4: record type (2 hex digits)
     *    00: data
     *    01: end of file
     *    02: extended segment address
     *    03: start segment address
     *    04: extended linear address (16lsbs of 32bit address)
     *    05: start linear address
     * 5: data
     * 6: checksum    (2 hex digits)
     */

    fd = $fopen(file, "r"); //open file
    if (fd < 32'h8000_0000)
    begin
        $display ("ERROR  : Skip reading file %s. Reason file not found", file);
        $finish();
        return ;
    end

    eof = 0;
    while (eof == 0)
    begin
        if ($fscanf(fd, ":%2h%4h%2h", byte_cnt, address, record_type) != 3)
          $display ("ERROR  : Read error while processing %s", file);

        //initial CRC value
        crc = byte_cnt + address[1] + address[0] + record_type;

        for (i=0; i<byte_cnt; i++)
        begin
            if ($fscanf(fd, "%2h", data[i]) != 1)
              $display ("ERROR  : Read error while processing %s", file);

            //update CRC
            crc = crc + data[i];
        end

        if ($fscanf(fd, "%2h", checksum) != 1)
          $display ("ERROR  : Read error while processing %s", file);

        if (checksum + crc)
          $display ("ERROR  : CRC error while processing %s", file);

        case (record_type)
          8'h00  : begin
                       for (i=0; i<byte_cnt; i++)
                       begin
//                           mem_array[ base_addr+address+ (i & ~(DATA_SIZE/8 -1)) ][ (i%(DATA_SIZE/8))*8+:8 ] = data[i];
                           mem_array[ (base_addr + address + i) & ~(DATA_SIZE/8 -1) ][ ((base_addr + address + i) % (DATA_SIZE/8))*8+:8 ] = data[i];
//$display ("write %2h to %8h (base_addr=%8h, address=%4h, i=%2h)", data[i], base_addr+address+ (i & ~(DATA_SIZE/8 -1)), base_addr, address, i);
//$display ("(%8h)=%8h",base_addr+address+4*(i/4), mem_array[ base_addr+address+4*(i/4) ]);
                       end
                   end
          8'h01  : eof = 1;
          8'h02  : base_addr = {data[0],data[1]} << 4;
          8'h03  : $display("INFO   : Ignored record type %0d while processing %s", record_type, file);
          8'h04  : base_addr = {data[0], data[1]} << 16;
          8'h05  : base_addr = {data[0], data[1], data[2], data[3]};
          default: $display("ERROR  : Unknown record type while processing %s", file);
        endcase
    end

    $fclose (fd);                //close file
  endtask


  /*
   * Read HEX generated by RISC-V elf2hex
   */
  task automatic read_elf2hex;
    input string file;

    integer fd,
            i,
            line=0;
    reg [127:0] data;
    addr_type   base_addr = BASE;


    fd = $fopen(file, "r"); //open file
    //if (fd < 32'h8000_0000)
    if (fd < 32'h0)
    begin
        $display ("ERROR  : Skip reading file %s. File not found", file);
        $finish();
        return ;
    end
    else
      $display ("INFO   : Reading %s", file);

    //Read data from file
    while ( !$feof(fd) )
    begin
        line=line+1;
        if ($fscanf(fd, "%32h", data) != 1)
          $display("ERROR  : Read error while processing %s (line %0d)", file, line);

        for (i=0; i< 128/DATA_SIZE; i++)
        begin
//$display("[%8h]:%8h",base_addr,data[i*DATA_SIZE +: DATA_SIZE]);
            mem_array[ base_addr ] = data[i*DATA_SIZE +: DATA_SIZE];
            base_addr = base_addr + (DATA_SIZE/8);
        end
    end
    
    //close file
    $fclose(fd);
  endtask



  /*
   * Dump memory
   */
  task dump;
    foreach (mem_array[i])
      $display("[%8h]:%8h", i,mem_array[i]);
  endtask



  ////////////////////////////////////////////////////////////////
  //
  // Module body
  //

generate
  for (p=0; p<PORTS; p++)
  begin

      /*
       * Write Section
       */
      //delay control signals
      assign AWREADY[p] = AWVALID[p];
      
      //always @(posedge ACLK)
      //  if (AWREADY[p])
      //  begin
      //      dHTRANS[p] <=#1 HTRANS[p];
      //      dHWRITE[p] <=#1 HWRITE[p];
      //      dHSIZE [p] <=#1 AWSIZE [p];
      //      dHBURST[p] <=#1 AWBURST[p];
      //  end

      always @(posedge ACLK)
        if (AWREADY[p] && AWVALID[p])
        begin
            waddr[p] <=#1 AWADDR[p] & ( {DATA_SIZE{1'b1}} << $clog2(DATA_SIZE/8) );

            case (AWSIZE[p])
               XSIZE_1: dbe[p] <=#1 1'h1  << AWADDR[p][$clog2(DATA_SIZE/8)-1:0];
               XSIZE_2: dbe[p] <=#1 2'h3  << AWADDR[p][$clog2(DATA_SIZE/8)-1:0];
               XSIZE_4: dbe[p] <=#1 4'hf  << AWADDR[p][$clog2(DATA_SIZE/8)-1:0];
               XSIZE_8: dbe[p] <=#1 8'hff << AWADDR[p][$clog2(DATA_SIZE/8)-1:0];
            endcase
        end
        else if (wreq[p]) begin
            waddr[p] <=#1 nxt_addr(waddr[p], AWBURST[p], AWLEN[p]);

            case (AWSIZE[p])
               XSIZE_1: dbe[p] <=#1 1'h1  << waddr[p][$clog2(DATA_SIZE/8)-1:0];
               XSIZE_2: dbe[p] <=#1 2'h3  << waddr[p][$clog2(DATA_SIZE/8)-1:0];
               XSIZE_4: dbe[p] <=#1 4'hf  << waddr[p][$clog2(DATA_SIZE/8)-1:0];
               XSIZE_8: dbe[p] <=#1 8'hff << waddr[p][$clog2(DATA_SIZE/8)-1:0];
            endcase        
        end

      assign WREADY[p] = WVALID[p];
      
      assign wreq[p] = WVALID[p] & WREADY[p];

      always @(posedge ACLK)
        if (wreq[p])
          for (i=0; i<DATA_SIZE/8; i++)
            if (dbe[p][i]) mem_array[waddr[p]][i*8+:8] = WDATA[p][i*8+:8];
      
      assign BID[p] = BIU_ID;
      always @ (posedge ACLK) begin
          if (!ARESETn)
              BVALID[p] <=#1 1'b0;
          else if (WLAST[p] & WREADY[p])
              BVALID[p] <=#1 1'b1;
          else if (BVALID[p] & BREADY[p])
              BVALID[p] <=#1 1'b0;
      end
      assign BRESP[p] = RESP_OKAY;
      
      /*
       * Read Section
       */
       assign ARID[p] = BIU_ID;
       assign RID[p] = BIU_ID;
       
       assign ARREADY[p] = 1;
       
         /*
         * Generate ACK
         */
       if (LATENCY > 0)
       begin
          always @(posedge ACLK,negedge ARESETn)
             if      (!ARESETn  )
                ack_latency[p] <=#1 {LATENCY{1'b0}};
             else if (ARREADY[p] && ARVALID[p])
                ack_latency[p] <=#1 'h1;
             else
                ack_latency[p] <=#1 ack_latency[p]<<1;
       end
       else
          assign ack_latency[p] = 1'b1;
       
       always @ (posedge ACLK) begin
          if (!ARESETn)
              RVALID[p] <=#1 1'b0;
          else if (ack_latency[p][LATENCY])
              RVALID[p] <=#1 1'b1;
          else if (RLAST[p] & RVALID[p] & RREADY[p])
              RVALID[p] <=#1 1'b0;
      end
              
       always @(posedge ACLK) begin
            if (!ARESETn)
                rd_cnt[p]  <=#1 'd0;
            else if (RVALID[p] & RREADY[p]) begin
                if (RLAST[p])
                    rd_cnt[p]  <=#1 'd0;
                else
                    rd_cnt[p]  <=#1 rd_cnt[p] + 1'b1;
            end
       end
       
       assign RLAST[p] = RVALID[p] & (rd_cnt[p] == ARLEN[p]);
       
       assign rd_update[p] = ack_latency[p][LATENCY] | (RREADY[p] && RVALID[p]);
       
       always @(posedge ACLK)
        if (ARREADY[p] && ARVALID[p])
            raddr[p] <=#1 ARADDR[p] & ( {DATA_SIZE{1'b1}} << $clog2(DATA_SIZE/8) );
        else if (rd_cnt[p]==0 && (ARLEN[p] > 0) && rd_update[p]) //send next address for preparing next data
            raddr[p] <=#1 {raddr[p][ADDR_SIZE-1:7], nxt_addr(raddr[p], ARBURST[p], ARLEN[p])};
        else if ((RVALID[p] && RREADY[p])) 
            raddr[p] <=#1 {raddr[p][ADDR_SIZE-1:7], nxt_addr(raddr[p], ARBURST[p], ARLEN[p])};

       always @(posedge ACLK)
        if (rd_update[p]) begin
          if (raddr[p] == waddr[p] && wreq[p])
              begin
                  for (j=0; j<DATA_SIZE/8; j++)
                    if (dbe[p][j]) RDATA[p][j*8+:8] <=#1 WDATA[p][j*8+:8];
                    else           RDATA[p][j*8+:8] <=#1 mem_array[ raddr[p] ][j*8+:8];
              end
          else
              begin
                  RDATA[p] <=#1 mem_array[ raddr[p] ];
              end
        end
        
        assign RRESP[p] = RESP_OKAY;
  end
endgenerate

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

endmodule

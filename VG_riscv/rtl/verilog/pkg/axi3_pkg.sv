/************************************************
 * AXI3 Package
 */
package axi3_pkg;
  //AxSIZE
  parameter [2:0] XSIZE_1    = 3'b000, //number of bytes
                  XSIZE_2    = 3'b001,
                  XSIZE_4    = 3'b010,
                  XSIZE_8    = 3'b011,
                  XSIZE_16   = 3'b100,
                  XSIZE_32   = 3'b101,
                  XSIZE_64   = 3'b110,
                  XSIZE_128  = 3'b111;
                  
  //AxBURST
  parameter [1:0] XBURST_FIXED      = 2'b00,
                  XBURST_INCR       = 2'b01,
                  XBURST_WRAP       = 2'b10,
                  XBURST_RESERVED   = 2'b11;               
                  
  //RRESP, BRESP
  parameter [1:0] RESP_OKAY     = 2'b00,
                  RESP_EXOKAY   = 2'b01,
                  RESP_SLVERR   = 2'b10,
                  RESP_DECERR   = 2'b11;                   
                  
  //AxCACHE
  parameter [3:0] XCACHE_BUFFERABLE  = 4'b0001,
                  XCACHE_CACHEABLE   = 4'b0010,
                  XCACHE_RALLOCATE   = 4'b0100,
                  XCACHE_WALLOCATE   = 4'b1000;    

  //AxPROT
  parameter [2:0] XPROT_PRIVILEGED    = 3'b001,
                  XPROT_NONSECURE     = 3'b010,
                  XPROT_INSTRUCTION   = 3'b100; //Instruction/Data

endpackage
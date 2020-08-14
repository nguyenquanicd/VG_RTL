//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_package.sv
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

package	SPI_package;
	parameter	SPI_DATA_WIDTH = 32;
    parameter	SPI_POINTER_WIDTH = 6;
    parameter	SPI_FIFO_DEPTH = 2**SPI_POINTER_WIDTH;
    parameter	SPI_PADDR_WIDTH = 5;
	
	typedef	logic [SPI_DATA_WIDTH-1:0] bus;
	
	typedef struct packed	{
	logic	pclk, preset_n;
	logic 	[SPI_PADDR_WIDTH-1:0] paddr;
	logic 	[2:0] pprot;
	logic 	psel, penable, pwrite;
	bus 	pwdata;
	logic 	[3:0] pstrb;
	}	apb_interfaces_in;
	
	typedef struct packed	{
	logic 	pready;
	bus		prdata;
	logic 	pslverr;
	}	apb_interfaces_out;
	

	typedef struct packed	{
	logic	rfifo_ren;
	logic 	tfifo_wen;
	}	as2sd;

	
	typedef struct packed	{
	logic	inter_wen, br_wen, cr_wen;
	}	as2sc;
	
	typedef struct packed 	{
	bus intr_out;
	bus rintr_out;
	bus sr_out;
	bus	inter_out;
	bus	br_out;
	bus	cr_out;
	}	sc2as;
	
	typedef struct packed	{
	logic	fifo_full;
	logic 	fifo_empty;
	logic 	fifo_overflow;
	logic 	fifo_underflow;
	}	fifo_interrupt;
	
	typedef	struct packed	{
	logic	tfifo_wen;
	logic 	tfifo_ren;
	logic 	tfifo_clear;
	logic 	rfifo_wen;
	logic 	rfifo_ren;
	logic 	rfifo_clear;
	logic 	dord;
	logic	[4:0] datalen;
	}	sc2sd;
	
	typedef struct packed 	{
	logic	transfer_start;
	logic 	mclk_sel;
	logic	cpol;
	logic	mstr;
	logic	cpha;
	logic	dord;
	logic	talk;
	logic 	[4:0] data_len;
	logic 	[7:0] spi_br;	
	}	sc2scc;
	
	typedef struct packed	{
	logic			SPIE;
	logic 			SWR;
	logic 			DORD;
	logic 			MSTR;
	logic			CPOL;
	logic 			CPHA;
	logic 			MCLKSEL;
	logic 			TALK;
	logic 	[7:0]	SPITXDL;
	logic 	[1:0]	SS;
	logic 	[3:0]	REV_1;
	logic 			SPITXRST;
	logic 			SPIRXRST;
	logic 	[2:0]	REV_2;
	logic	[4:0]	DATALEN;
	}	spicr_type;
	
	typedef struct packed	{
	logic 	[23:0]	REV;
	logic 	[7:0]	SPIBR;
	}	spibr_type;	
	
	typedef struct packed	{
	logic 			SPITRCINTE;
	logic 	[18:0]	REV_1;
	logic 			SPITXFINTE;
	logic 			SPITXOINTE;
	logic			SPITXEINTE;
	logic 			SPITXUINTE;
	logic 	[3:0]	REV_2;
	logic 			SPIRXFINTE;
	logic 			SPIRXOINTE;
	logic 			SPIRXEINTE;
	logic 			SPIRXUINTE;
	}	spiinter_type;
	
	typedef struct packed 	{
	logic 	[17:0]	REV_1;
	logic 	[5:0]	SPITXST;
	logic 	[1:0]	REV_2;
	logic 	[5:0]	SPIRXST;
	}	spisr_type;
	
	typedef struct packed	{
	logic 			SPITRCRINT;
	logic 	[18:0]	REV_1;
	logic 			SPITXFRINT;
	logic 			SPITXORINT;
	logic 			SPITXERINT;
	logic 			SPITXURINT;
	logic 	[3:0]	REV_2;
	logic 			SPIRXFRINT;
	logic 			SPIRXORINT;
	logic 			SPIRXERINT;
	logic 			SPIRXURINT;
	}	spirintr_type;
	
	typedef struct packed	{
	logic 			SPITRCINT;
	logic 	[18:0]	REV_1;
	logic 			SPITXFINT;
	logic 			SPITXOINT;
	logic 			SPITXEINT;
	logic 			SPITXUINT;
	logic 	[3:0]	REV_2;
	logic 			SPIRXFINT;
	logic 			SPIRXOINT;
	logic 			SPIRXEINT;
	logic 			SPIRXUINT;
	}	spiintr_type;
	
	function mux4_1 (input logic [1:0] sel, input logic [3:0] in);
		unique case(sel)
		2'b00:	return in[0];
		2'b01:	return in[1];
		2'b10:	return in[2];
		2'b11:	return in[3];
		default:	return 1'bx;
		endcase
	endfunction

	function mux32_1 (input logic [4:0] sel, input logic [SPI_DATA_WIDTH-1:0] in);
		logic	[7:0]	in_buf;
		logic 	[1:0]	out_buf;
		in_buf[0] = mux4_1(sel[1:0], in[3:0]);
		in_buf[1] = mux4_1(sel[1:0], in[7:4]);
		in_buf[2] = mux4_1(sel[1:0], in[11:8]);
		in_buf[3] = mux4_1(sel[1:0], in[15:12]);
		in_buf[4] = mux4_1(sel[1:0], in[19:16]);
		in_buf[5] = mux4_1(sel[1:0], in[23:20]);		
		in_buf[6] = mux4_1(sel[1:0], in[27:24]);
		in_buf[7] = mux4_1(sel[1:0], in[31:28]);	
		out_buf[0] = mux4_1(sel[3:2], in_buf[3:0]);
		out_buf[1] = mux4_1(sel[3:2], in_buf[7:4]);
		return (sel[4] ? out_buf[1] : out_buf[0]);
	endfunction
 	
	`define SIMULATE;
	
endpackage 
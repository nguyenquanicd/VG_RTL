//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_package.sv
// Module Name:		SPI
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
	
	typedef struct	{
	logic	pclk, preset_n;
	logic 	[SPI_PADDR_WIDTH-1:0] paddr;
	logic 	[2:0] pprot;
	logic 	psel, penable, pwrite;
	bus 	pwdata;
	logic 	[3:0] pstrb;
	}	apb_interfaces_in;
	
	typedef struct	{
	logic 	pready;
	bus		prdata;
	logic 	pslverr;
	}	apb_interfaces_out;
	
	typedef struct	{
	logic	rfifo_ren;
	logic 	tfifo_wen;
	}	as2sd;
	
	typedef struct 	{
	logic	inter_wen, br_wen, cr_wen;
	}	as2sc;
	
	typedef struct 	{
	bus intr_out;
	bus rintr_out;
	bus sr_out;
	bus	inter_out;
	bus	br_out;
	bus	cr_out;
	}	sc2as;
	
	typedef struct	{
	logic	fifo_full;
	logic 	fifo_empty;
	logic 	fifo_overflow;
	logic 	fifo_underflow;
	}	fifo_interrupt;
	
	typedef	struct	{
	logic	tfifo_wen;
	logic 	tfifo_ren;
	logic 	tfifo_clear;
	logic 	rfifo_wen;
	logic 	rfifo_ren;
	logic 	rfifo_clear;
	logic 	dord;
	logic	[4:0] datalen;
	}	sc2sd;
	
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
 	
endpackage
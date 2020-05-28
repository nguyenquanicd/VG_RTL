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
	
endpackage
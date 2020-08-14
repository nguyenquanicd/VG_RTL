//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_sync_fifo.sv
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

import	SPI_package::*;
module SPI_sync_fifo
(
	output	fifo_interrupt interrupt,
	output 	bus	data_out,
	output	logic	[SPI_POINTER_WIDTH-1:0]	fifo_status,
	input 	bus	data_in,
	input 	logic clear,
	input 	logic store,
	input 	logic load,
	input 	logic clk,
	input 	logic rst_n
);
	
//================================================================================	
//	Internal Signals
	logic [SPI_POINTER_WIDTH:0] w_ptr;
	logic [SPI_POINTER_WIDTH:0] r_ptr;
	logic [SPI_POINTER_WIDTH-1:0] w_addr;
	logic [SPI_POINTER_WIDTH-1:0] r_addr;
	logic write_en;
	logic read_en;
	logic [SPI_DATA_WIDTH-1:0] RAM [SPI_FIFO_DEPTH-1:0];
	
//================================================================================
//	Write Counter
	always_ff @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			w_ptr <= '0;
		else if(clear)
			w_ptr <= '0;
		else if(write_en)
			w_ptr <= w_ptr + 1'b1;
		else
			w_ptr <= w_ptr;
	end
	
	assign 	write_en = store && !interrupt.fifo_full;
	
//	Read Counter
	always_ff @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			r_ptr <= '0;
		else if(clear)
			r_ptr <= '0;
		else if(read_en)
			r_ptr <= r_ptr + 1'b1;
		else
			r_ptr <= r_ptr;
	end		
	
	assign	read_en = load && !interrupt.fifo_empty;
	
//	Sync RAM with sync read, write, reset
	assign	w_addr = w_ptr[SPI_POINTER_WIDTH-1:0];
	assign	r_addr = r_ptr[SPI_POINTER_WIDTH-1:0];
	
	always_ff @(posedge clk)
	begin
		if(write_en)
			RAM[w_addr] <= data_in;
	end
	
	assign 	data_out = RAM[r_addr];
	
//	Interrupt Flag Generator
	assign	interrupt.fifo_full = (w_ptr[SPI_POINTER_WIDTH-1:0] == r_ptr[SPI_POINTER_WIDTH-1:0]) && (w_ptr[SPI_POINTER_WIDTH] != r_ptr[SPI_POINTER_WIDTH]);
	assign 	interrupt.fifo_empty = w_ptr[SPI_POINTER_WIDTH:0] == r_ptr[SPI_POINTER_WIDTH:0];
	assign 	interrupt.fifo_overflow = interrupt.fifo_full && store;
	assign 	interrupt.fifo_underflow = interrupt.fifo_empty && load;
	
//	Status Gen
//	assign 	fifo_status = '{w_ptr - r_ptr};
	assign	fifo_status = w_ptr - r_ptr;
endmodule
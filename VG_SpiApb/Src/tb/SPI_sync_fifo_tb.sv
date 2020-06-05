//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_sync_fifo_tb.sv
// Module Name:		SPI
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

module SPI_sync_fifo_tb();
	import	SPI_package::*;
	parameter 	FIFODATA = "D:/VG_CPU/SPI/FIFO.txt";	
	fifo_interrupt interrupt;
	bus	data_out;
	bus	data_in;
	logic clear;
	logic store;
	logic load;
	logic clk;
	logic rst_n;
	logic [SPI_POINTER_WIDTH:0]	r_ptr;
	logic [SPI_POINTER_WIDTH:0] w_ptr;
	logic [SPI_POINTER_WIDTH-1:0] fifo_status;
	
	include"SPI_sync_fifo.sv";
	SPI_sync_fifo	DUT
	(interrupt,
	data_out,
	fifo_status,
	data_in,
	clear,
	store,
	load,
	clk,
	rst_n);

//	assign r_ptr = DUT.r_ptr;
//	assign w_ptr = DUT.w_ptr;
	initial begin
		$readmemh(FIFODATA, DUT.RAM);
	end
	
	initial begin
		clk = 1;
		forever #10 clk = !clk;
	end
	
	initial begin
		rst_n = 1;
		#12
		rst_n = 0;
		#25
		rst_n = 1;
	end
	
	initial begin
		store = 1'b0;
		#80
		data_in = 32'h27;
		#80
		store = 1'b1;	
	end
	
	always @(posedge clk)
	begin
		data_in <= data_in + 1;
	end
	
	initial begin
		load = 1'b0;
		forever #20 load = !load;
	end	
	
endmodule	
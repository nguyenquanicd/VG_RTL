//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_Data.sv
// Module Name:		SPI
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

module	SPI_Data
	import	SPI_package::*;
	(output bus rfifo_out,
	output	fifo_interrupt	rfifo_interrupt,
	output 	fifo_interrupt	tfifo_interrupt,
	output 	logic	[SPI_POINTER_WIDTH-1:0]	rfifo_status,
	output 	logic	[SPI_POINTER_WIDTH-1:0]	tfifo_status,	
	output 	bus	transfer_data,
	input 	bus receive_data,
	input 	sc2sd	sd_control,
	input 	bus 	wdata,
	input 	logic 	clk,
	input 	logic 	rst_n);

//================================================================================
//	include"SPI_sync_fifo.sv";
//================================================================================
//	Internal Signals
	bus	std_wdata;
	bus	pre_data;
	bus pre_swap;
	bus t_rev_data;
	bus r_rev_data;
	bus swap_data;
	
//================================================================================


//	T Data Standardize
	genvar i;
	generate 
		for(i = 0; i < SPI_DATA_WIDTH; i++)
		begin:	t_rev_gen
			assign	t_rev_data[i] = mux32_1( sd_control.datalen, {wdata[SPI_DATA_WIDTH-i-1:0], {i{wdata[i]}}});
		end
	endgenerate

	assign	std_wdata = sd_control.dord ? wdata : t_rev_data;
	
//	R Data Standardize
	genvar j;
	generate 	
		for(j = 0; j < SPI_DATA_WIDTH; j++)
		begin:	r_rev_gen
			assign	r_rev_data[j] = mux32_1(sd_control.datalen, {swap_data[SPI_DATA_WIDTH-j-1:0], {j{swap_data[j]}}});
		end
	endgenerate	
	
	genvar k;
	generate	
		for(k = 0; k < SPI_DATA_WIDTH; k++)
		begin:	r_swap_gen
			assign 	swap_data[k] = mux32_1(sd_control.datalen, {pre_swap[SPI_DATA_WIDTH-1-k:0], {k{1'b0}}}); 
		end
	endgenerate

	genvar l;
	generate
		for(l = 0; l < SPI_DATA_WIDTH; l++)
		begin:	pre_swap_gen
			assign pre_swap[l] = pre_data[SPI_DATA_WIDTH-l-1]; 
		end
	endgenerate

	assign	rfifo_out = sd_control.dord	? swap_data : r_rev_data;
	
//	Transfer FIFO
	SPI_sync_fifo	T_FIFO
	(tfifo_interrupt,
	transfer_data,
	tfifo_status,
	std_wdata,
	sd_control.tfifo_clear,
	sd_control.tfifo_wen,
	sd_control.tfifo_ren,
	clk,
	rst_n);
	
//	Receive FIFO
	SPI_sync_fifo	R_FIFO
	(rfifo_interrupt,
	pre_data,
	rfifo_status,
	receive_data,
	sd_control.rfifo_clear,
	sd_control.rfifo_wen,
	sd_control.rfifo_ren,
	clk,
	rst_n);	

endmodule	
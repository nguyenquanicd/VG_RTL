//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_Data.sv
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

import	SPI_package::*;	
module	SPI_Data
(
	output bus rfifo_out,
	output	fifo_interrupt	rfifo_interrupt,
	output 	fifo_interrupt	tfifo_interrupt,
	output 	logic	[SPI_POINTER_WIDTH-1:0]	rfifo_status,
	output 	logic	[SPI_POINTER_WIDTH-1:0]	tfifo_status,	
	output 	bus	transfer_data,
	input 	bus receive_data,
	input 	sc2sd	sc2sd_control,
	input 	bus 	wdata,
	input 	logic 	clk,
	input 	logic 	rst_n
);

//================================================================================
	`ifdef SIMULATE
		include"SPI_sync_fifo.sv";
	`endif
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
			assign	t_rev_data[i] = mux32_1( sc2sd_control.datalen, {wdata[SPI_DATA_WIDTH-i-1:0], {i{wdata[i]}}});
		end
	endgenerate

	assign	std_wdata = sc2sd_control.dord ? wdata : t_rev_data;
	
//	R Data Standardize
	genvar j;
	generate 	
		for(j = 0; j < SPI_DATA_WIDTH; j++)
		begin:	r_rev_gen
			assign	r_rev_data[j] = mux32_1(sc2sd_control.datalen, {swap_data[SPI_DATA_WIDTH-j-1:0], {j{swap_data[j]}}});
		end
	endgenerate	
	
	genvar k;
	generate	
		for(k = 0; k < SPI_DATA_WIDTH; k++)
		begin:	r_swap_gen
			assign 	swap_data[k] = mux32_1(sc2sd_control.datalen, {pre_swap[SPI_DATA_WIDTH-1-k:0], {k{1'b0}}}); 
		end
	endgenerate

	genvar l;
	generate
		for(l = 0; l < SPI_DATA_WIDTH; l++)
		begin:	pre_swap_gen
			assign pre_swap[l] = pre_data[SPI_DATA_WIDTH-l-1]; 
		end
	endgenerate

	assign	rfifo_out = sc2sd_control.dord	? swap_data : r_rev_data;
	
//	Transfer FIFO
	SPI_sync_fifo	T_FIFO
	(
	.interrupt(tfifo_interrupt),
	.data_out(transfer_data),
	.fifo_status(tfifo_status),
	.data_in(std_wdata),
	.clear(sc2sd_control.tfifo_clear),
	.store(sc2sd_control.tfifo_wen),
	.load(sc2sd_control.tfifo_ren),
	.*
	);
	
//	Receive FIFO
	SPI_sync_fifo	R_FIFO
	(
	.interrupt(rfifo_interrupt),
	.data_out(pre_data),
	.fifo_status(rfifo_status),
	.data_in(receive_data),
	.clear(sc2sd_control.rfifo_clear),
	.store(sc2sd_control.rfifo_wen),
	.load(sc2sd_control.rfifo_ren),
	.*
	);	

endmodule	
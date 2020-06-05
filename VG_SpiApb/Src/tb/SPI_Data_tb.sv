//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_Data_tb.sv
// Module Name:		SPI
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

module SPI_Data_tb();
	import	SPI_package::*;
	bus rfifo_out;
	fifo_interrupt	rfifo_interrupt;
	fifo_interrupt	tfifo_interrupt;
	logic	[SPI_POINTER_WIDTH-1:0]	rfifo_status;
	logic	[SPI_POINTER_WIDTH-1:0]	tfifo_status;	
	bus	transfer_data;
	bus receive_data;
	sc2sd	sd_control;
	bus 	wdata;
	logic 	clk;
	logic 	c_clk;
	logic	rst_n;
//	logic 	c_clk;
//	logic	c_rst_n;
	parameter 	FIFODATA = "D:/VG_CPU/SPI/FIFO.txt";	
	
	include"SPI_Data.sv";
	SPI_Data	DUT
	(rfifo_out,
	rfifo_interrupt,
	tfifo_interrupt,
	rfifo_status,
	tfifo_status,	
	transfer_data,
	receive_data,
	sd_control,
	wdata,
	clk,
	rst_n);
///*
	initial begin
		$readmemh(FIFODATA, DUT.T_FIFO.RAM);
		$readmemh(FIFODATA, DUT.R_FIFO.RAM);
	end
	
//	assign 	c_clk = DUT.clk;
//	assign 	c_rst_n = DUT.rst_n;
	
//	Clock Gen
	initial begin
		clk = 1;
		forever #10 clk = !clk;
	end
	
	initial begin
		c_clk = 1;
		forever #20 c_clk= !c_clk;	
	end
//	Reset Gen	
	initial begin
		rst_n = 1;
		#12
		rst_n = 0;
		#25
		rst_n = 1;
	end
		
	logic	t_load;
	logic 	t_store;
	logic 	r_load;
	logic 	r_store;
	
	initial begin
		t_load = 0;
		t_store = 0;
		r_load = 0;
		r_store = 0;
		wdata = '0;
		receive_data = 32'hf0000000;
		sd_control = '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'b0};
	//	MSB first, 4-bit data
		sd_control.dord = 0;
		sd_control.datalen = 5'h03;
		#100
		t_store = 1;
		#20
		t_load = 1;
		#20
		r_store = 1;
	end
	
	always @(posedge c_clk)
	begin
		wdata <= wdata +1;
	end
	
	always @(posedge clk)
	begin
		receive_data <= receive_data - 1;
	end
	
	always @(posedge clk)
	begin
		if(t_store)
			sd_control.tfifo_wen <= !sd_control.tfifo_wen;
	end
	
	always @(posedge clk)
	begin
		if(t_load)
			sd_control.tfifo_ren <= !sd_control.tfifo_ren;
	end
	
	always @(posedge clk)
	begin
		if(r_store)
			sd_control.rfifo_wen <= !sd_control.rfifo_wen;
	end
	
	always @(posedge clk)
	begin
		if(r_load)
			sd_control.rfifo_ren <= !sd_control.rfifo_ren;
	end
//*/	
endmodule 
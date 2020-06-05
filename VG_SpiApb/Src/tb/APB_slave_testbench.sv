//////////////////////////////////////////////////////////////////////////////////
// File Name: 		APB_slave_testbench.sv
// Module Name:		SPI
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

module APB_slave_testbench();
	timeunit 10ns;
	timeprecision 1ns;
	import 	SPI_package::*;
	apb_interfaces_out	apb_slave_out;
	as2sd	data_req;
	as2sc	control_reg;
	bus		wdata;
	apb_interfaces_in	apb_slave_in;
	sc2as	reg_out;
	bus		rfifo_out;
	logic 	clk;
	logic	error;
	logic 	wen_reg;
	
	`include"SPI_APB_slave.sv";
	
	SPI_APB_slave	DUT(.*);
	
	assign 	error = DUT.error;
	assign	wen_reg = DUT.wen_reg;
	
//	Clock Gen
	always #10 apb_slave_in.pclk = !apb_slave_in.pclk;
	
	initial begin
	apb_slave_in = '{1'b1, 1'b0, 5'b0, 3'b0, 1'b0, 1'b0, 1'b0, 32'b0, '1};
	reg_out = '{32'h1, 32'h2, 32'h3, 32'h4, 32'h5, 32'h6};
	rfifo_out = '1;
	
	#9 
	apb_slave_in.preset_n = 1;
	#12							//	Write into TFIFO
	apb_slave_in.pwdata = 32'h18;	
	apb_slave_in.paddr = 5'h18; 
	apb_slave_in.psel  = 1'b1;
	apb_slave_in.pwrite = 1'b1;
	#20
	apb_slave_in.penable = 1'b1;
	#20							//	Write into CR
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h00; 
	apb_slave_in.pwdata = '0;	
	#20
	apb_slave_in.penable = 1'b1;	
	#20 						//	Write into BR
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h04; 
	apb_slave_in.pwdata = 32'h14;
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Write into INTER with pstrb error
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h08; 
	apb_slave_in.pwdata = 32'h18;
	apb_slave_in.pstrb = 4'b1011;
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Write into INTER 
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h08; 
	apb_slave_in.pstrb = '1;
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Read from CR
	apb_slave_in.pwrite = 1'b0;		
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h00; 
	apb_slave_in.pwdata = 32'h00;
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Read from BR with wrong addr	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h05; 
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Read from BR with wrong addr	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h07; 
	#20	
	apb_slave_in.penable = 1'b1;
	#20 						//	Read from BR 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h04; 
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Read from INTER 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h08; 
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Read from SR 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h0c; 
	#20	
	apb_slave_in.penable = 1'b1;
	#20 						//	Read from RINTR 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h10; 
	#20	
	apb_slave_in.penable = 1'b1;
	#20 						//	Read from INTR 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h14; 
	#20	
	apb_slave_in.penable = 1'b1;
	#20 						//	Read from TFIFO 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h18; 
	#20	
	apb_slave_in.penable = 1'b1;
	#20 						//	Read from RFIFO 	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.paddr = 5'h1c; 
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Write into wrong addr (RFIFO)	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.pwrite = 1'b1;
	apb_slave_in.pwdata = '0;	
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Write into wrong addr (SR)	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.pwrite = 1'b1;
	apb_slave_in.paddr = 5'h0c; 	
	#20	
	apb_slave_in.penable = 1'b1;	
	#20 						//	Write into wrong addr (RINTR)	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.pwrite = 1'b1;
	apb_slave_in.paddr = 5'h10; 	
	#20	
	apb_slave_in.penable = 1'b1;
	#20 						//	Write into wrong addr (INTR)	
	apb_slave_in.penable = 1'b0;
	apb_slave_in.pwrite = 1'b1;
	apb_slave_in.paddr = 5'h14; 	
	#20	
	apb_slave_in.penable = 1'b1;	
	end
	
endmodule
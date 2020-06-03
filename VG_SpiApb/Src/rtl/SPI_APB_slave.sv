//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_APB_slave.sv
// Module Name:		SPI
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////

//`default_nettype uwire;
module	SPI_APB_slave	
	import	SPI_package::*;
	(output	apb_interfaces_out	apb_slave_out,
	output	as2sd	data_req,
	output 	as2sc	control_reg,
	output 	bus		wdata,
	output 	logic	clk,
	output 	logic 	rst_n,
	input 	apb_interfaces_in	apb_slave_in,
	input 	sc2as	reg_out,	
	input 	bus		rfifo_out);

//=================================================================================
//	Internal Signals
	logic	[SPI_DATA_WIDTH-1:0] prdata_buf1, prdata_buf2;
	logic 	wen_reg;
	logic 	error;
	logic 	[1:0] wen_sel;

//=================================================================================	
//	Read Req
	always_comb begin
		if(error)
			prdata_buf1 = '0;
		else begin
			case (apb_slave_in.paddr[SPI_PADDR_WIDTH-1:2]) 
			3'b000:	prdata_buf1 = reg_out.cr_out;
			3'b001:	prdata_buf1 = reg_out.br_out;
			3'b010:	prdata_buf1 = reg_out.inter_out;
			3'b011:	prdata_buf1 = reg_out.sr_out;
			3'b100:	prdata_buf1 = reg_out.rintr_out;
			3'b101: prdata_buf1 = reg_out.intr_out;
			3'b110: prdata_buf1 = '0;
			3'b111:	prdata_buf1 = rfifo_out;
			default: prdata_buf1 = 'x;	
			endcase
		end
	end
	
	assign	prdata_buf2 = (apb_slave_in.psel && (~apb_slave_in.pwrite))	? 	prdata_buf1 : apb_slave_out.prdata;
	assign 	data_req.rfifo_ren = &apb_slave_in.paddr[4:2] && (!error);
	
	always_ff @(posedge apb_slave_in.pclk or negedge apb_slave_in.preset_n)
	begin
		if(!apb_slave_in.preset_n)
			apb_slave_out.prdata <= '0;
		else
			apb_slave_out.prdata <= prdata_buf2;
	end
	
//	Write Req
	assign 	wen_reg = apb_slave_in.penable && apb_slave_in.pwrite && apb_slave_in.psel && (!error);
	assign 	wen_sel = (~apb_slave_in.paddr[2] && apb_slave_in.paddr[3] && apb_slave_in.paddr[4]) ? 2'b11 : apb_slave_in.paddr[3:2];
	
	always_comb begin
		case (wen_sel)
/*
		2'b00:	{data_req.tfifo_wen, control_reg} =	'{1'b1, 1'b0, 1'b0, 1'b0}; 
		2'b01:	{data_req.tfifo_wen, control_reg} = '{1'b0, 1'b1, 1'b0, 1'b0}; 	
		2'b10:	{data_req.tfifo_wen, control_reg} = '{1'b0, 1'b0, 1'b1, 1'b0}; 
		2'b11:	{data_req.tfifo_wen, control_reg} = '{1'b0, 1'b0, 1'b0, 1'b1}; 
		default:{data_req.tfifo_wen, control_reg} = '{1'bx, 1'bx, 1'bx, 1'bx};  	
*/
		2'b11:
		begin
			data_req.tfifo_wen = wen_reg;
			control_reg = '{1'b0, 1'b0, 1'b0};
		end
		2'b10:
		begin
			data_req.tfifo_wen = 1'b0;
			control_reg = '{wen_reg, 1'b0, 1'b0};			
		end
		2'b01:
		begin
			data_req.tfifo_wen = 1'b0;
			control_reg = '{1'b0, wen_reg, 1'b0};			
		end
		2'b00:
		begin
			data_req.tfifo_wen = 1'b0;
			control_reg = '{1'b0, 1'b0, wen_reg};			
		end
		default:
		begin
			data_req.tfifo_wen = 1'bx;
			control_reg = '{1'bx, 1'bx, 1'bx};			
		end
	endcase
	end
	
//	Error flag
	assign 	error = (|apb_slave_in.paddr[1:0])||(~&apb_slave_in.pstrb[3:0])||(apb_slave_in.pwrite&&((&apb_slave_in.paddr[3:2])||(apb_slave_in.paddr[4]&&~apb_slave_in.paddr[3])));
	
//	Other Signals
	always_ff @(posedge apb_slave_in.pclk or negedge apb_slave_in.preset_n )
	begin
		if(!apb_slave_in.preset_n)
			apb_slave_out.pslverr <= 1'b0;
		else 
			apb_slave_out.pslverr <= error && ~apb_slave_in.penable && apb_slave_in.psel;
	end

	assign 	apb_slave_out.pready = 1'b1;
	assign 	wdata = apb_slave_in.pwdata;
	assign 	clk = apb_slave_in.pclk;
	assign 	rst_n = apb_slave_in.preset_n;
	
endmodule
//`default_nettype wire;
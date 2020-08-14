//////////////////////////////////////////////////////////////////////////////////
// File Name: 		SPI_Control.sv
// Project Name:	VG CPU
// Author:	 		hungbk99
// Page:     		VLSI Technology
//////////////////////////////////////////////////////////////////////////////////


import SPI_package::*;
module	SPI_Control
(
//	APB_slave::SPI_Control
	output	spicr_type				cr_out,
	output	spibr_type				br_out,
	output	spiinter_type			inter_out,
	output 	spisr_type				sr_out,
	output 	spirintr_type			rintr_out,
	output	spiintr_type			intr_out,
	input 	as2sc					as2sc_wen,
	input 	as2sd					as2sd_wen,
	input							clk,
									rst_n,
	input	bus 					wdata,
//	SPI_Control::SPI_Data
	input	fifo_interrupt			rfifo_interrupt, 				
									tfifo_interrupt,
	input	[SPI_POINTER_WIDTH-1:0]	rfifo_status,						
									tfifo_status,
//	SPI_Control::Shift Clock Control
	output 	sc2scc					sc2scc_control,
	output 	logic 	[4:0]			data_len,
	input 							transfer_complete							
);

//========================================================================================
//Internal Signals
	spicr_type		c_reg;
	spibr_type		b_reg;
	spiinter_type	inte_reg;
	spisr_type		s_reg;
	spirintr_type	rint_reg;
	spiintr_type	int_reg;
	
	logic 		sync_1,
			sync_2,
			sync_3;
//========================================================================================
	always_ff @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
			c_reg.SPIE <= 1'b0;
		else if(!c_reg.SPIE)	
		begin
			c_reg <= 32'h307;
			b_reg <= '0;
			inte_reg <= '0;
			s_reg <= '0;
			rint_reg <= '0;
			int_reg <= '0;
		end
		else 
		begin
			if(as2sc_wen.cr_wen)
				c_reg <= {wdata[31:14], 4'b0, wdata[9:8], 3'b0, wdata[4:0]};
			
			if(as2sc_wen.br_wen)
				b_reg <= {24'b0, wdata[7:0]};
			
			if(as2sc_wen.inter_wen)
				inte_reg <= {wdata[31], 19'b0, wdata[11:8], 4'b0, wdata[3:0]};
			//	Status register
			s_reg.SPIRXST <= rfifo_status;
			s_reg.SPITXST <= tfifo_status;
			//	Raw interrupt register
			rint_reg.SPIRXURINT <= rfifo_interrupt.fifo_underflow;
			rint_reg.SPIRXERINT <= rfifo_interrupt.fifo_empty;
			rint_reg.SPIRXORINT <= rfifo_interrupt.fifo_overflow;
			rint_reg.SPIRXFRINT <= rfifo_interrupt.fifo_full;
			rint_reg.SPITXURINT <= tfifo_interrupt.fifo_underflow;
			rint_reg.SPITXERINT <= tfifo_interrupt.fifo_empty;
			rint_reg.SPITXORINT <= tfifo_interrupt.fifo_overflow;
			rint_reg.SPITXFRINT <= tfifo_interrupt.fifo_full;			
	
			//	Interrupt register	
			int_reg.SPIRXUINT <= rfifo_interrupt.fifo_underflow & inte_reg.SPIRXUINTE;
			int_reg.SPIRXEINT <= rfifo_interrupt.fifo_empty & inte_reg.SPIRXEINTE;
			int_reg.SPIRXOINT <= rfifo_interrupt.fifo_overflow & inte_reg.SPIRXOINTE;
			int_reg.SPIRXFINT <= rfifo_interrupt.fifo_full & inte_reg.SPIRXFINTE;
			int_reg.SPITXUINT <= tfifo_interrupt.fifo_underflow & inte_reg.SPITXUINTE;
			int_reg.SPITXEINT <= tfifo_interrupt.fifo_empty & inte_reg.SPITXEINTE;
			int_reg.SPITXOINT <= tfifo_interrupt.fifo_overflow & inte_reg.SPITXOINTE;
			int_reg.SPITXFINT <= tfifo_interrupt.fifo_full & inte_reg.SPITXFINTE;			
			
		end
	end

	assign	cr_out = c_reg;
	assign	br_out = b_reg; 	
	assign 	inter_out = inte_reg;
	assign 	sr_out = s_reg;
	assign 	rintr_out = rint_reg;
	assign 	intr_out = int_reg;
	assign 	sc2scc_control.mclk_sel = c_reg.MCLKSEL;
	assign	sc2scc_control.cpol = c_reg.CPOL; 
	assign	sc2scc_control.mstr = c_reg.MSTR;
	assign 	sc2scc_control.cpha = c_reg.CPHA;
	assign 	sc2scc_control.dord = c_reg.DORD;
	assign 	sc2scc_control.talk = c_reg.TALK;
	assign	sc2scc_control.data_len = c_reg.DATALEN;	 
	assign	sc2scc_control.spi_br = b_reg.SPIBR;

//	Transfer Control
	always_ff @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			sync_1 <= 1'b0;
			sync_2 <= 1'b0;
			sync_3 <= 1'b0;
		end
		else 
		begin
			sync_1 <= transfer_complete;
			sync_2 <= sync_1;
			sync_3 <= sync_2;							 
		end
	end		

	assign 	pos_edge_complete = ~sync_3 & sync_2;

endmodule

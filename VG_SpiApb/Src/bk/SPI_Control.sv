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
	output	spicr_type			cr_out,
	output	spibr_type			br_out,
	output	spiinter_type			inter_out,
	output 	spisr_type			sr_out,
	output 	spirintr_type			rintr_out,
	output	spiintr_type			intr_out,
	input 	as2sc				as2sc_wen,
	input 	as2sd				as2sd_wen,
	input					clk,
						rst_n,
	input	bus 				wdata,
//	SPI_Control::SPI_Data
	input	fifo_interrupt			rfifo_interrupt, 				
						tfifo_interrupt,
	input	[SPI_POINTER_WIDTH-1:0]		rfifo_status,						
						tfifo_status,
	output 	sc2sd				sc2sd_control,								
//	SPI_Control::Shift Clock Control
	output 	sc2scc				sc2scc_control,
	input 					transfer_start_ack,
	output 	logic 	[4:0]			data_len,
	input 					transfer_complete,
//	System
	input 					pclk,
						preset_n	
);

//========================================================================================
// Internal Signals
	spicr_type	c_reg;
	spibr_type	b_reg;
	spiinter_type	inte_reg;
	spisr_type	s_reg;
	spirintr_type	rint_reg;
	spiintr_type	int_reg;
	
	logic 		sync_1,
			sync_2,
			sync_3,
			ack_1,
			ack_2;
// Transfer delay
	enum	logic
	{
	UN_COUNT,
	COUNT
	}	delay_state, delay_next_state;
		
	logic 			count_done;
	logic 	[7:0]		count;
// Transfer control
	enum 	logic	[1:0]
	{
	IDLE,
	INITIAL,
	WAIT,
	DELAY
	} transfer_state, transfer_next_state;

	logic 	transfer_trigger;
//========================================================================================
	always_ff @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
//			c_reg.SPIE <= 1'b0;
		begin
			c_reg <= 32'h307;
			b_reg <= '0;
			inte_reg <= '0;
			s_reg <= '0;
			rint_reg <= '0;
			int_reg <= '0;
		end
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

	assign 	sc2sd_control.tfifo_clear = c_reg.SWR;
	assign	sc2sd_control.rfifo_clear = c_reg.SWR;
	
//	Transfer Control
	always_ff @(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			sync_1 <= 1'b0;
			sync_2 <= 1'b0;
			sync_3 <= 1'b0;
			ack_1 <= 1'b0;
			ack_2 <= 1'b0;
			sc2scc_control.transfer_start <= 1'b0;
		end
		else 
		begin
			sync_1 <= transfer_complete;
			sync_2 <= sync_1;
			sync_3 <= sync_2;
			ack_1 <= transfer_start_ack;
			ack_2 <= ack_1;
			sc2scc_control.transfer_start <= transfer_trigger;
		end
	end		

	assign 	pos_edge_complete = ~sync_3 & sync_2;
	assign 	sc2sd_control.tfifo_wen = pos_edge_complete;
	assign	sc2sd_control.rfifo_wen = pos_edge_complete;

	always_comb begin 
		unique case (transfer_state) 
		IDLE: 
		begin
			if(!tfifo_interrupt.fifo_empty)
				transfer_next_state = INITIAL;
			else 
				transfer_next_state = transfer_state;
		end
		INITIAL:
		begin	
			transfer_trigger = 1'b1;
			if(ack_2) 
				transfer_next_state = WAIT;
			else 
				transfer_next_state = transfer_state;
		end
		WAIT:
		begin
			if(pos_edge_complete)
				transfer_next_state = DELAY;
			else 
				transfer_next_state = transfer_state;
		end
		DELAY:
		begin
			if(count_done)
				transfer_next_state = INITIAL;
			else	
				transfer_next_state = transfer_state;
		end
		default: transfer_next_state = transfer_state;
		endcase
	end

	always_ff @(posedge pclk, negedge preset_n)
	begin
		if(!preset_n)
			transfer_state <= IDLE;
		else if(c_reg.SWR == 1'b1)
			transfer_state <= IDLE;
		else
			transfer_state <= transfer_next_state;
	end

//	Transfer delay
	always_comb begin
		unique case (delay_state)
		UN_COUNT:
		begin
			if(pos_edge_complete)
				delay_next_state = COUNT;
			else
				delay_next_state = delay_state;
		end
		COUNT:
		begin
			if(count_done)
				delay_next_state = UN_COUNT;
			else 
				
				delay_next_state = delay_state;
		end
		default: 
				delay_next_state = delay_state;
		endcase
	end

	always_ff @(posedge pclk, negedge preset_n)
	begin
		if(!preset_n)
			delay_state <= UN_COUNT;
		else if(c_reg.SWR == 1'b1)
			delay_state <= UN_COUNT;
		else 
			delay_state <= delay_next_state;
	end

	always_ff @(posedge pclk, negedge preset_n)
	begin
		if(!preset_n)
			count <= '0;
		else if(c_reg.SWR == 1'b1)
			count <= '0;
		else if(delay_state == COUNT)
			count <= count + 1;
		else if(count_done)
			count <= '0;
	end

	assign	count_done = (count == c_reg.SPITXDL) ? 1'b1 : 1'b0; 

endmodule

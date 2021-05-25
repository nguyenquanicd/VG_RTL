//=================================================================
// Module name:   spi_top
// Project name:  VG SoC 
// Page:          VLSI Technology
// Version  Date        Author    Description
// v0.0     03.10.2021  hungbk99  Merge rtl from previous design   
//          05.16.2021  hungbk99  seperate psel from apb_slave_in  
//=================================================================

`define SIM
`include "D:/Project/renas-mcu/SPI/rtl/spi_package.sv"
import spi_package::*;
module spi_top
(
// spi APB interface
  output  apb_package::slave_s_type     apb_slave_out,
  input   apb_package::master_s_type    apb_slave_in,
  input                                 psel, //Hung_mod
  input                                 pclk, //Hung_mod
  input                                 preset_n,
// SPI interface
  output                                mosi_somi,
                                        ss_0,
                                        ss_1,
                                        ss_2,
                                        ss_3,
  input                                 miso_simo,
  inout                                 sclk                            
);

//=================================================================
// Interface signals
// APB Slave
  logic   rst_n_sync;
//          preset_n,

  bus     wdata,
          rfifo_out;      
  
  sc2as   reg_out;            // outputs from status and control registers
  as2sd   data_req;           // FIFO - user control signals 
  as2sc   as2sc_wen;        // Control registers - user control signals 
// SPI Data
  as2sd                         as2sd_control;
  fifo_interrupt                rfifo_interrupt,
                                tfifo_interrupt;
  logic [SPI_POINTER_WIDTH-1:0] rfifo_status,
                                tfifo_status;
  bus                           transfer_data,
                                receive_data;
  sc2sd                         sc2sd_control;
// SPI Control
  sc2scc                        sc2scc_control;
  logic                         transfer_start_ack,
                                transfer_complete,
                                transfer_complete_ack,
                                slave_ena,
                                talk_ena;
                              
  logic [1:0]                   slave_select;
// SPI Clock
  logic                         fclk,
                                s_clock,
                                shift_clock;
// SPI Shift
  logic                         mstr;
  logic                         transfer_start;
  logic                         cpha;
  logic                         cpol;
// Other signals
  
//=================================================================
// Sub-module
  assign as2sd_control = data_req;  //Hung_add_03.10_2021
  assign transfer_start = sc2scc_control.transfer_start;
  assign cpha = sc2scc_control.cpha;
  assign cpol = sc2scc_control.cpol;
  spi_apb_slave APBS_U
  (
    .control_req(as2sc_wen),
    .*
  );

  spi_data SPID_U
  (
    .clk(pclk),
    .rst_n(rst_n_sync),
    .*
  );
  
  spi_control SPIC_U
  (
    .cr_out(reg_out.cr_out),
    .br_out(reg_out.br_out),
    .inter_out(reg_out.inter_out),
    .sr_out(reg_out.sr_out),
    .rintr_out(reg_out.rintr_out),
    .intr_out(reg_out.intr_out),
    .pclk(pclk),
    .preset_n(rst_n_sync),
    .*
  );
  
  spi_clock SPICL_U
  (
    .pclk(pclk),
    .preset_n(rst_n_sync),
    .*
  );

  spi_shift SPIS_U
  (
    .pclk(pclk),
    .preset_n(rst_n_sync),
    .*
  );

//=================================================================
// Internal Connections
  //assign pclk = apb_slave_in.pclk;
  assign mstr = sc2scc_control.mstr;
//  assign preset_n = apb_slave_in.preset_n;
//  assign control_req = as2sc_wen;



endmodule


//////////////////////////////////////////////////////////////////////////////////
// Module Name:		spi_sync_fifo
// Project Name:	VG CPU
// Page:     		  VLSI Technology
// Version  Date        Author    Description
// v0.0     03.10.2021  hungbk99  Merge rtl from previous design    
//////////////////////////////////////////////////////////////////////////////////

module spi_sync_fifo
	(output	fifo_interrupt interrupt,
	output 	bus	data_out,
	output	logic	[SPI_POINTER_WIDTH-1:0]	fifo_status,
	input 	bus	data_in,
	input 	logic clear,
	input 	logic store,
	input 	logic load,
	input 	logic clk,
	input 	logic rst_n);
	
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
endmodule: spi_sync_fifo
  
//////////////////////////////////////////////////////////////////////////////////
// Module name:   spi_apb_slave
// Project Name:	VG CPU
// Page:          VLSI Technology
// Version  Date        Author    Description
// v0.0     03.10.2021  hungbk99  Merge rtl from previous design    
//          05.16.2021  hungbk99  seperate psel from apb_slave_in 
//          05.25.2021  hungbk99  Debug rfifo_ren
//////////////////////////////////////////////////////////////////////////////////

module	spi_apb_slave	
	(output	apb_package::slave_s_type	apb_slave_out,
	output	as2sd	data_req,
	output 	as2sc	control_req,
	output 	bus		wdata,
	output 	logic 	rst_n_sync,
	input 	apb_package::master_s_type	apb_slave_in,
  input   psel,     //Hung_mod
  input   preset_n, //Hung_mod
  input   pclk,     //Hung_mod
	input 	sc2as	reg_out,	
	input 	bus		rfifo_out);

//=================================================================================
//	Internal Signals
	logic	[SPI_DATA_WIDTH-1:0] prdata_buf1, prdata_buf2;
	logic 	wen_reg;
	logic 	error;
	logic 	[1:0] wen_sel;
  logic                         sync_rst_1,
                                sync_rst_2,
                                //Hung_mod preset_n,
                                clk;
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
	
	//Hung_mod assign	prdata_buf2 = (apb_slave_in.psel && (~apb_slave_in.pwrite))	? 	prdata_buf1 : apb_slave_out.prdata;
	assign	prdata_buf2 = (psel && (~apb_slave_in.pwrite))	? 	prdata_buf1 : apb_slave_out.prdata;
	//Hung_db assign 	data_req.rfifo_ren = &apb_slave_in.paddr[4:2] && (!error);
	assign 	data_req.rfifo_ren = &apb_slave_in.paddr[4:2] && (!error) && psel && apb_slave_in.penable;
	
	//always_ff @(posedge apb_slave_in.pclk, negedge rst_n_sync)
	always_ff @(posedge pclk, negedge rst_n_sync)
	begin
		if(!rst_n_sync)
			apb_slave_out.prdata <= '0;
		else
			apb_slave_out.prdata <= prdata_buf2;
	end
	
//	Write Req
	//Hung_mod assign 	wen_reg = apb_slave_in.penable && apb_slave_in.pwrite && apb_slave_in.psel && (!error);
	assign 	wen_reg = apb_slave_in.penable && apb_slave_in.pwrite && psel && (!error);
	assign 	wen_sel = (~apb_slave_in.paddr[2] && apb_slave_in.paddr[3] && apb_slave_in.paddr[4]) ? 2'b11 : apb_slave_in.paddr[3:2];
	
	always_comb begin
		data_req.tfifo_wen = 1'b0;
		control_req = 3'b0;
		case (wen_sel)
		2'b11:
			data_req.tfifo_wen = wen_reg;
		2'b10:
			control_req.inter_wen = wen_reg;			
		2'b01:
			control_req.br_wen = wen_reg;
		2'b00:
			control_req.cr_wen = wen_reg;			
	endcase
	end
	
//	Error flag
	assign 	error = (|apb_slave_in.paddr[1:0])||(~&apb_slave_in.pstrb[3:0])||(apb_slave_in.pwrite&&((&apb_slave_in.paddr[3:2])||(apb_slave_in.paddr[4]&&~apb_slave_in.paddr[3])));
	
//	Other Signals
	//always_ff @(posedge apb_slave_in.pclk, negedge rst_n_sync )
	always_ff @(posedge pclk, negedge rst_n_sync )
	begin
		if(!rst_n_sync)
			apb_slave_out.pslverr <= 1'b0;
		else 
			//apb_slave_out.pslverr <= error && ~apb_slave_in.penable && apb_slave_in.psel;
			apb_slave_out.pslverr <= error && ~apb_slave_in.penable && psel;
	end

	assign 	apb_slave_out.pready = 1'b1;
	assign 	wdata = apb_slave_in.pwdata;
	//assign 	clk = apb_slave_in.pclk;
	assign 	clk = pclk;
	//Hung_mod assign 	preset_n = apb_slave_in.preset_n;

// Reset Synchronous Logic
  always_ff @(posedge clk, negedge preset_n)
  begin
    if(!preset_n)
    begin
      sync_rst_1 <= 1'b0;
      sync_rst_2 <= 1'b0;
    end
    else
    begin
      sync_rst_1 <= 1'b1;
      sync_rst_2 <= sync_rst_1;
    end
  end

  assign  rst_n_sync = preset_n & sync_rst_2;
endmodule: spi_apb_slave


//////////////////////////////////////////////////////////////////////////////////
// Module Name:   spi_control
// Project Name:	VG SoC
// Page:          VLSI Technology
// Version  Date        Author    Description
// v0.0     03.10.2021  hungbk99  Merge rtl from previous design    
//////////////////////////////////////////////////////////////////////////////////


module	spi_control
(
//	APB_slave::spi_control
	output	spicr_type			  cr_out,
	output	spibr_type			  br_out,
	output	spiinter_type			inter_out,
	output 	spisr_type			  sr_out,
	output 	spirintr_type			rintr_out,
	output	spiintr_type			intr_out,
	input 	as2sc				      as2sc_wen,
//	input 	as2sd				      as2sd_wen,
//	input					clk,
//						rst_n,
	input	bus 				wdata,
//	spi_control::spi_data
	input	fifo_interrupt			      rfifo_interrupt, 				
						                      tfifo_interrupt,
	input	[SPI_POINTER_WIDTH-1:0]		rfifo_status,						
						                      tfifo_status,
	output 	sc2sd				            sc2sd_control,								
//	spi_control::Shift Clock Control
	output 	sc2scc				          sc2scc_control,
	input 					                transfer_start_ack,
//	output 	logic 	                [4:0]			data_len,
	input 					                transfer_complete,
  output                          transfer_complete_ack,
// SPI Interface
  output  logic                   slave_ena,
  output  logic [1:0]             slave_select,
  output  logic                   talk_ena,
//	System
	input 					                pclk,
						                      preset_n	
);

//========================================================================================
// Internal Signals
	spicr_type	  c_reg;
	spibr_type	  b_reg;
	spiinter_type	inte_reg;
	spisr_type	  s_reg;
	spirintr_type	rint_reg;
	spiintr_type	int_reg;

  //`ifdef SIM
  //  initial begin
  //    $readmemh("mem.txt", c_reg);
  //    $readmemh("mem.txt", b_reg);
  //    $readmemh("mem.txt", inte_reg);
  //    $readmemh("mem.txt", s_reg);
  //    $readmemh("mem.txt", rint_reg);
  //    $readmemh("mem.txt", int_reg);
  //  end
  //`endif
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
		
	logic 			    count_done,
                  pos_edge_complete;
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
	always_ff @(posedge pclk, negedge preset_n)
	begin
		if(!preset_n)
//			c_reg.SPIE <= 1'b0;
		begin
			c_reg <= 32'h307;
			b_reg <= '0;
			inte_reg <= '0;
			s_reg <= '0;
			rint_reg <= '0;
			int_reg <= '0;
		end
		//else if(!c_reg.SPIE)	
		//begin
		//	c_reg <= 32'h307;
		//	b_reg <= '0;
		//	inte_reg <= '0;
		//	s_reg <= '0;
		//	rint_reg <= '0;
		//	int_reg <= '0;
		//end
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

  assign 	sc2sd_control.dord = c_reg.DORD;
  assign  sc2sd_control.datalen = c_reg.DATALEN;

  assign 	talk_ena = c_reg.TALK;
	assign	sc2scc_control.datalen = c_reg.DATALEN;	 
	assign	sc2scc_control.spi_br = b_reg.SPIBR;

	assign 	sc2sd_control.tfifo_clear = c_reg.SWR;
	assign	sc2sd_control.rfifo_clear = c_reg.SWR;
	
//	Transfer Control
	always_ff @(posedge pclk, negedge preset_n)
	begin
		if(!preset_n)
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
			sc2scc_control.transfer_start <= transfer_trigger & ~c_reg.SWR & c_reg.SPIE;
		end
	end		

	assign 	pos_edge_complete = ~sync_3 & sync_2;
	assign 	sc2sd_control.tfifo_ren = pos_edge_complete & ~tfifo_interrupt.fifo_empty; //The empty flag ensures that SPI won't read the tfifo after all data has been transferd
	assign	sc2sd_control.rfifo_wen = pos_edge_complete;
  assign  transfer_complete_ack = sync_2;

	always_comb begin
    transfer_trigger = 1'b0;
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
			//if(count_done)
			//	transfer_next_state = INITIAL;
			//else	
			//	transfer_next_state = transfer_state;
      if(count_done) begin
				if(!tfifo_interrupt.fifo_empty) transfer_next_state = INITIAL;
        else  transfer_next_state = IDLE;
      end
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
		//Hung_db else if(delay_state == COUNT)
		else if((delay_state == COUNT) && !count_done)
			count <= count + 1;
		else if(count_done)
			count <= '0;
	end

	assign	count_done = (count == c_reg.SPITXDL) ? 1'b1 : 1'b0; 
  assign  slave_ena = (c_reg.SPIE && !c_reg.SWR && !tfifo_interrupt.fifo_empty) ? 1'b0 : 1'b1;
endmodule: spi_control

//////////////////////////////////////////////////////////////////////////////////
// Module Name:   spi_data
// Project Name:	VG_SoC
// Page:          VLSI Technology
// Version  Date        Author    Description
// v0.0     03.10.2021  hungbk99  Merge rtl from previous design    
//////////////////////////////////////////////////////////////////////////////////

module	spi_data
(
	output 	bus                           rfifo_out,
	output	fifo_interrupt	              rfifo_interrupt,
	output 	fifo_interrupt	              tfifo_interrupt,
	output 	logic	[SPI_POINTER_WIDTH-1:0]	rfifo_status,
	output 	logic	[SPI_POINTER_WIDTH-1:0]	tfifo_status,	
	output 	bus	                          transfer_data,
	input 	bus 	                        receive_data,
	input 	sc2sd	                        sc2sd_control,
  input   as2sd                         as2sd_control,
	input 	bus 	                        wdata,
	input 	logic 	                      clk,
	input 	logic 	                      rst_n
);

//================================================================================
//================================================================================
//	Internal Signals
	bus	std_wdata;
	bus	pre_data;
	bus 	pre_swap;
	bus 	t_rev_data;
	bus 	r_rev_data;
	bus 	swap_data;
	
//================================================================================
//	T Data Standardize
	//genvar i;
	//generate 
	//	for(i = 0; i < SPI_DATA_WIDTH; i++)
	//	begin:	t_rev_gen
	//		assign	t_rev_data[i] = mux32_1( sc2sd_control.datalen, {wdata[SPI_DATA_WIDTH-i-1:0], {i{wdata[i]}}});
	//	end
	//endgenerate

	//assign	std_wdata = sc2sd_control.dord ? wdata : t_rev_data;
	//
////	R Data Standardize
	//genvar j;
	//generate 	
	//	for(j = 0; j < SPI_DATA_WIDTH; j++)
	//	begin:	r_rev_gen
	//		assign	r_rev_data[j] = mux32_1(sc2sd_control.datalen, {swap_data[SPI_DATA_WIDTH-j-1:0], {j{swap_data[j]}}});
	//	end
	//endgenerate	
	//
	//genvar k;
	//generate	
	//	for(k = 0; k < SPI_DATA_WIDTH; k++)
	//	begin:	r_swap_gen
	//		assign 	swap_data[k] = mux32_1(sc2sd_control.datalen, {pre_swap[SPI_DATA_WIDTH-1-k:0], {k{1'b0}}}); 
	//	end
	//endgenerate

	//genvar l;
	//generate
	//	for(l = 0; l < SPI_DATA_WIDTH; l++)
	//	begin:	pre_swap_gen
	//		assign pre_swap[l] = pre_data[SPI_DATA_WIDTH-l-1]; 
	//	end
	//endgenerate

	//assign	rfifo_out = sc2sd_control.dord	? swap_data : r_rev_data;
	
//	R Data Standardize
	genvar i;
	generate 
		for(i = 0; i < SPI_DATA_WIDTH; i++)
		begin:	r_rev_gen
			assign	r_rev_data[i] = mux32_1( sc2sd_control.datalen, {pre_data[SPI_DATA_WIDTH-i-1:0], {i{pre_data[i]}}});
		end
	endgenerate

	assign	rfifo_out = sc2sd_control.dord ? r_rev_data : pre_data;
	
//	T Data Standardize
	//genvar j;
	//generate 	
	//	for(j = 0; j < SPI_DATA_WIDTH; j++)
	//	begin:	t_rev_gen
	//		assign	t_rev_data[j] = mux32_1(sc2sd_control.datalen, {swap_data[SPI_DATA_WIDTH-j-1:0], {j{swap_data[j]}}});
	//	end
	//endgenerate	
	//
	//genvar k;
	//generate	
	//	for(k = 0; k < SPI_DATA_WIDTH; k++)
	//	begin:	t_swap_gen
	//		assign 	swap_data[k] = mux32_1(sc2sd_control.datalen, {wdata[SPI_DATA_WIDTH-1-k:0], {k{1'b0}}}); 
	//	end
	//endgenerate

  assign t_rev_data = wdata << (32 - sc2sd_control.datalen - 1);
    
	genvar l;
	generate
		for(l = 0; l < SPI_DATA_WIDTH; l++)
		begin:	pre_swap_gen
			assign pre_swap[l] = wdata[SPI_DATA_WIDTH-l-1]; 
		end
	endgenerate

	assign	std_wdata = sc2sd_control.dord	? pre_swap : t_rev_data;
//	Transfer FIFO
	spi_sync_fifo	T_FIFO
	(
	.interrupt(tfifo_interrupt),
	.data_out(transfer_data),
	.fifo_status(tfifo_status),
	.data_in(std_wdata),
	.clear(sc2sd_control.tfifo_clear),
	.store(as2sd_control.tfifo_wen),
	.load(sc2sd_control.tfifo_ren),
	.*
	);
	
//	Receive FIFO
	spi_sync_fifo	R_FIFO
	(
	.interrupt(rfifo_interrupt),
	.data_out(pre_data),
	.fifo_status(rfifo_status),
	.data_in(receive_data),
	.clear(sc2sd_control.rfifo_clear),
	.store(sc2sd_control.rfifo_wen),
	.load(as2sd_control.rfifo_ren),
	.*
	);	

endmodule: spi_data	


//============================================================================
// Module name:   spi_clock
// Project name:  VG_SoC
// Page:          VLSI Technology
// Version  Date        Author    Description
// v0.0     03.10.2021  hungbk99  Merge rtl from previous design   
//          05.22.2021  hungbk99  Mod: add transfer_start_ack
//============================================================================


module spi_clock
(
//  SPI internal connect  
  input sc2scc  sc2scc_control, 
  output logic  transfer_complete,
  input         fclk,
                pclk,
                preset_n,
                transfer_complete_ack,
  output logic  transfer_start_ack,              
//  Slave connect
  input         s_clock,
  
  output        shift_clock
//              slave_select
);

//============================================================================
// Internal signals
  logic pre_clock, 
        transfer_req,
        req_buf,
        req_detect,
        transfer_done,
        sync_req,
        pre_gen_clock,
        clock_enable,
        gen_clock,
        single_pulse_done,
        transfer_done_h,
        transfer_done_l;

  logic [4:0]  pulse_count_h,
            pulse_count_l;
 
  logic [7:0] invert_count;
  //logic [4:0] count;
  
  enum logic [1:0]
  {
    IDLE,
    TRANS,
    DONE_ACK
  } current_state, next_state;

//============================================================================
// Clock select
  assign  pre_clock = sc2scc_control.mclk_sel ? fclk : pclk;
  assign  transfer_req = sc2scc_control.mclk_sel ? sync_req : sc2scc_control.transfer_start; 
  //Hung_add_05.22.2021
  assign  transfer_start_ack = req_detect; 

// Synchronous logic
  always_ff @(posedge fclk, negedge preset_n) 
  begin
    if(!preset_n)
    begin
      req_buf <= 1'b0;
      sync_req <= 1'b0;
    end
    else 
    begin
      req_buf <= sc2scc_control.transfer_start;
      sync_req <= req_buf;
    end
  end

// Request detect
  always_ff @(posedge pre_clock, negedge preset_n)
  begin
    if(!preset_n)
      req_detect <= 1'b0;
    else 
      req_detect <= transfer_req;
  end

// Clock generator   
  assign  shift_clock = sc2scc_control.mstr ? gen_clock : s_clock;
  //Hung_mod assign  gen_clock = (sc2scc_control.cpol ^ sc2scc_control.cpha) ? pre_gen_clock : ~pre_gen_clock; 
  assign  gen_clock = sc2scc_control.cpol ? ~pre_gen_clock : pre_gen_clock; 
// FSM    
  always_comb begin
    clock_enable = 1'b0;
    transfer_complete = 1'b0;
    unique case (current_state)
    IDLE:
    begin
      if(req_detect == 1'b1)   
        next_state = TRANS;
      else
        next_state = current_state;
    end
    TRANS:
    begin
      clock_enable = 1'b1;
      if(transfer_done == 1'b1)
        next_state = DONE_ACK;
      else
        next_state = current_state;
    end
    DONE_ACK:
    begin
      transfer_complete = 1'b1;
      if(transfer_complete_ack)
        next_state = IDLE;
      else 
        next_state = current_state;
    end
    default: next_state = current_state;
    endcase
  end

  always_ff @(posedge pre_clock, negedge preset_n)
  begin
    if(!preset_n)
      current_state <= IDLE;
    else 
      current_state <= next_state;
  end
// Master clock  
  always_ff @(posedge pre_clock, negedge preset_n)
  begin
    if(!preset_n)
      invert_count <= sc2scc_control.spi_br;
    else if(clock_enable == 1'b1)
    begin
      if(single_pulse_done == 1'b1)
        invert_count <= '0;
      else        
        invert_count <= invert_count + 1; 
    end
    else
      invert_count <= sc2scc_control.spi_br;
  end
  
  always_ff @(posedge pre_clock, negedge preset_n)
  begin
    if(!preset_n)
      pre_gen_clock <= 1'b0;
    else if(current_state == TRANS)
    begin
      if(single_pulse_done)
        pre_gen_clock <= ~pre_gen_clock;
      else 
        pre_gen_clock <= pre_gen_clock;
    end
    else 
      pre_gen_clock <= sc2scc_control.cpol;
  end

//  precede generated clock
  //always_ff @(posedge pre_clock, negedge preset_n)
  //always_ff @(negedge shift_clock, negedge preset_n)
  //begin
  //  if(!preset_n)
  //    pulse_count_h <= '0;
  //  else if(clock_enable)
  //    pulse_count_h <= pulse_count_h + 1;
  //  else if(transfer_done_h)
  //    pulse_count_h <= '0;
  //end
 
  always_ff @(posedge shift_clock, negedge preset_n)
  begin
    if(!preset_n)
      pulse_count_h <= '0;
    else if(clock_enable)
    begin
      if(transfer_done_h)
        pulse_count_h <= '0;
      else  
        pulse_count_h <= pulse_count_h + 1;
    end
  end
//  following generated clock    
  //always_ff @(negedge pre_clock, negedge preset_n)
  //always_ff @(negedge shift_clock, negedge preset_n)
  //begin
  //  if(!preset_n)
  //    pulse_count_l <= '0;
  //  else if(current_state == TRANS)
  //    pulse_count_l <= pulse_count_l + 1;
  //  else if(transfer_done_l)
  //    pulse_count_l <= '0;
  //end
  
  always_ff @(negedge shift_clock, negedge preset_n)
  begin
    if(!preset_n)
      pulse_count_l <= '0;
    else if(clock_enable)
    begin
      if(transfer_done_l)
        pulse_count_l <= '0;
      else  
        pulse_count_l <= pulse_count_l + 1;
    end
  end

  assign single_pulse_done = (invert_count == sc2scc_control.spi_br) ? 1'b1 : 1'b0;
  //assign transfer_done_h = (pulse_count_h == sc2scc_control.datalen + 1) ? 1'b1 : 1'b0;
  //assign transfer_done_l = (pulse_count_l == sc2scc_control.datalen + 1) ? 1'b1 : 1'b0;
  assign transfer_done_h = (pulse_count_h == sc2scc_control.datalen - 1) ? 1'b1 : 1'b0;
  assign transfer_done_l = (pulse_count_l == sc2scc_control.datalen - 1) ? 1'b1 : 1'b0;
  //Hung_mod assign transfer_done = (sc2scc_control.cpol == 1'b1) ? transfer_done_h : transfer_done_l;
  logic transfer_done_h_d, transfer_done_l_d;
  
  always_ff @(posedge pre_clock, negedge preset_n)
  begin
    if(!preset_n)
      transfer_done_h_d <= 1'b0;
    else
      transfer_done_h_d <= transfer_done_h; 
  end

  always_ff @(posedge pre_clock, negedge preset_n)
  begin
    if(!preset_n)
      transfer_done_l_d <= 1'b0;
    else
      transfer_done_l_d <= transfer_done_l; 
  end
  
  assign transfer_done = (sc2scc_control.cpol == 1'b1) ? (~transfer_done_h & transfer_done_h_d) : (~transfer_done_l & transfer_done_l_d);
  //always_ff @(posedge pre_clock, negedge preset_n)
  //begin
  //  if(!preset_n)
  //    transfer_done <= 1'b0;
  //  else if(sc2scc_control.cpol == 1'b1)
  //    transfer_done <= ~transfer_done_h & transfer_done_h_d;
  //  else
  //    transfer_done <= ~transfer_done_l & transfer_done_l_d;
  //end
endmodule: spi_clock


//======================================================================
// Module name:   spi_shift
// Project name:  VG_SoC
// Page:          VLSI Technology
// Version  Date        Author    Description
// v0.0     10.03.2021  hungbk99  Merge rtl from previous design   
//          05.22.2021  hungbk99  Modify: add transfer_start
//======================================================================

module spi_shift
(
//  SPI interface
  output logic    mosi_somi,
                  ss_0,
                  ss_1,
                  ss_2,
                  ss_3,
  input           miso_simo,
  inout           sclk,
//  Control signals
  input           transfer_complete,
  input           transfer_start,
                  cpol,
                  cpha,
                  shift_clock,
                  slave_ena,
                  talk_ena,
                  mstr,
  input [1:0]     slave_select,
  output          s_clock,                
//  Data
  input bus       transfer_data,
  output  bus     receive_data,
//  System
  input           pclk,
                  preset_n
);

//======================================================================
//  Internal Signals
  logic           serial_in,
                  serial_out;

  logic           transfer_trigger,
                  transfer_trigger1,
                  transfer_sample;               

  bus             spi_shift_reg,
                  spi_receive_reg;
  logic           sample_clock;
//======================================================================
  
  assign  sample_clock = (cpol ^ cpha) ? shift_clock : ~shift_clock; 
  //always_comb begin
  //  if(cpol == 0)
  //  begin
  //    if(cpha = 1)
  //      sample_clock = shift_clock;
  //    else
  //      sample_clock = ~shift_clock;
  //  end
  //  else begin
  //    if(cpha = 1)
  //      sample_clock = ~shift_clock;
  //    else
  //      sample_clock = shift_clock;
  //  end
  //end

//  SPI Shift Register
  always_ff @(posedge pclk, negedge preset_n)
  begin
    if(!preset_n)
    begin
      transfer_trigger <= 1'b0;
      transfer_trigger1 <= 1'b0;
    end
    else begin
      transfer_trigger <= transfer_start;
      transfer_trigger1 <= transfer_trigger;
    end
  end

  //Hung_mod assign transfer_sample = transfer_complete | (transfer_trigger & !transfer_trigger1);
  assign transfer_sample = transfer_trigger & !transfer_trigger1;

  always_ff @(posedge sample_clock, posedge transfer_sample)
  begin
      if (transfer_sample)
        spi_shift_reg <= transfer_data;      
      else   
        //spi_shift_reg <= {spi_shift_reg[SPI_DATA_WIDTH-1:0] << 1, 1'b0}; 
        spi_shift_reg <= spi_shift_reg[SPI_DATA_WIDTH-1:0] << 1; 
  end
  
  assign serial_out = spi_shift_reg[SPI_DATA_WIDTH-1];
//  SPI Receive Register
  //always_ff @(posedge pclk, negedge preset_n)
  //begin
  //  if(!preset_n)
  //      spi_receive_reg <= '0;
  //  else if(transfer_complete) 
  //      spi_receive_reg <= spi_shift_reg;
  //  else 
  //      spi_receive_reg <= spi_receive_reg;
  //end
  always_ff @(negedge sample_clock, negedge preset_n)
  begin
    if(!preset_n)
        spi_receive_reg <= '0;
    //else if(transfer_complete) 
    //    spi_receive_reg <= spi_shift_reg;
    else 
        //spi_receive_reg <= {spi_shift_reg[SPI_DATA_WIDTH-1:0] << 1, serial_in};
        spi_receive_reg <= (spi_receive_reg << 1) | serial_in;
  end
//  SPI Interface
  assign mosi_somi = talk_ena ? serial_out : 1'b0;
  assign serial_in = talk_ena ? miso_simo : 1'b0;
  assign s_clock = sclk;
  assign sclk = mstr ? shift_clock : 1'bz;
  assign receive_data = spi_receive_reg;
  
  always_comb begin
    ss_0 = 1'b0;
    ss_1 = 1'b0;
    ss_2 = 1'b0;
    ss_3 = 1'b0;
    unique case(slave_select)
    2'b00: ss_0 = slave_ena;
    2'b01: ss_1 = slave_ena;
    2'b10: ss_2 = slave_ena;
    2'b11: ss_3 = slave_ena;
    endcase    
  end

endmodule: spi_shift
                  


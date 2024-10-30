`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// SPI Interface
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module spi_interface(
		     input wire	       SCLK,
		     input wire	       MOSI,
		     input wire	       CSN,
		     input wire	       rst_n,
		     input wire [7:0] reg_read_data,
		     output reg	       MISO,
		     output reg	       MISO_enable,
		     output reg [9:0] reg_addr,
		    output reg	       enable,
		    input wire        mapping,
			 input wire        read_empty,
			 output reg  [7:0]  write_data,
			 output reg [9:0]   write_addr,
			 output reg  reg_read_enable,
            output reg  reg_write_enable,
            output  reg  fifo_write_data_enable,
             output reg  fifo_write_addr_enable
		     );

   // internal registers
   reg [9:0]			       spi_shift_reg_current;
   reg [2:0]			       state_current;
   reg [5:0]			       bit_count_current;
   reg				       reg_rw_current;  // read/write bit, 0=read, 1=write
   reg				       MISO_pos_edge;
   reg				       MISO_enable_pos_edge;
   reg [7:0]               register_array_test;
   
   // internal combinational variables
   reg [15:0]			       spi_shift_reg_next;			       
   reg [2:0]			       state_next;
   reg [5:0]			       bit_count_next;
   reg				       reg_rw_next;
   reg [8:0]			       reg_write_data_next;
   reg				       enable_next;
   reg				       MISO_next;
   reg				       MISO_enable_next;
   reg [7:0]				reg_read_data_current;
   reg [7:0]				reg_read_data_next;
   
   reg [7:0] register_array_em_next;
   reg [7:0] register_array_test_next;
   
   reg [9:0] reg_addr_next;

   reg  reg_read_enable_next;
   reg  reg_write_enable_next;
   reg  fifo_write_data_enable_next;
   reg  fifo_write_addr_enable_next;
   
   reg [7:0] reg_fifo_write_data_next;
   reg [9:0] reg_fifo_write_addr_next;
   
   reg write_flag;
   reg read_flag;
   reg fifo_write_flag;
   
   // decalare stat names
   parameter [5:0]		       S0_IDLE                     = 6'd0;
   parameter [5:0]		       S1_RW                       = 6'd1;
   parameter [5:0]		       S2_REG_ADDR                 = 6'd2;
   parameter [5:0]		       S3_DEAD_TIME_1              = 6'd3; 
   parameter [5:0]		       S4_DECISION_EM              = 6'd40;
   parameter [5:0]		       S4_DECISION_TEST            = 6'd41;
   parameter [5:0]		       S4_DECISION_FREQ            = 6'd42;
   parameter [5:0]		       S4_DECISION_I_COEFF         = 6'd43;
   parameter [5:0]		       S4_DECISION_Q_COEFF         = 6'd44;
   parameter [5:0]		       S4_DECISION_I_FIRST         = 6'd45;
   parameter [5:0]		       S4_DECISION_I_LAST          = 6'd46;
   parameter [5:0]		       S4_DECISION_Q_FIRST         = 6'd47;
   parameter [5:0]		       S4_DECISION_Q_LAST          = 6'd48;
   parameter [5:0]		       S4_DECISION_UNUSED          = 6'd49;
   parameter [5:0]		       S5_DEAD_TIME_2              = 6'd5; 
   
   parameter READ_MODE = 1'b0;
   parameter WRITE_MODE = 1'b1;
   
   integer i;
    

   // clock in registers, asynch active-low reset
   always @(posedge SCLK or negedge rst_n)
     begin
	if (rst_n == 1'b0) begin
	   state_current         <= S0_IDLE;
	   spi_shift_reg_current <= 10'b0000000000;
	   bit_count_current     <= 6'd33;
	   reg_rw_current        <= 1'b0;
	   reg_addr              <= 10'd0;
	   MISO_pos_edge         <= 1'b0;
	   MISO_enable_pos_edge  <= 1'b0;
	   reg_read_data_current <= 16'h0000;
	   enable                <= 1'b0;
	   reg_read_enable       <= 1'b0;
	   register_array_test   <= 8'd0;
	   write_data            <= 8'h00;
	   write_addr            <= 10'd0;
	   reg_read_enable       <= 1'b0;
	   reg_write_enable       <= 1'b0;
	   fifo_write_data_enable       <= 1'b0;
	   fifo_write_addr_enable       <= 1'b0;
	end else begin
	   state_current         <= state_next;
	   spi_shift_reg_current <= spi_shift_reg_next;
	   bit_count_current     <= bit_count_next;
	   reg_rw_current        <= reg_rw_next;
	   MISO_pos_edge         <= MISO_next;
	   MISO_enable_pos_edge  <= MISO_enable_next;
	   reg_read_data_current <= reg_read_data_next;
	   enable                <= enable_next;
	   reg_read_enable       <= reg_read_enable_next;
	   register_array_test   <= register_array_test_next;
	   reg_addr              <= reg_addr_next;
	   write_data            <= reg_fifo_write_data_next;
	   write_addr            <= reg_fifo_write_addr_next;
	   reg_read_enable       <= reg_read_enable_next;
	   reg_write_enable       <= reg_write_enable_next;
	   fifo_write_data_enable       <= fifo_write_data_enable_next;
	   fifo_write_addr_enable       <= fifo_write_addr_enable_next;
	end
     end // always @ (posedge clk or negedge rst_n)

   // clock out MISO and MISO_enable on clock falling edge
   always @(negedge SCLK or negedge rst_n)
     begin
	if (rst_n == 1'b0) begin
	   MISO                  <= 1'b0;
	   MISO_enable           <= 1'b0;
	end else begin
	   MISO                  <= MISO_pos_edge;
	   MISO_enable           <= MISO_enable_pos_edge;
	  
	end
     end // always @ (negedge clk or negedge rst_n)

   // combinational logic for MOSI shift register
   always @(*)
     begin
	// shift in data on MOSI
	spi_shift_reg_next = {spi_shift_reg_current[9:0], MOSI};
     end
  

	
	// handle enables
     always @(*)
	 begin
		reg_read_enable_next = 1'b0;
		reg_read_data_next = reg_read_data;
	 end


   // combinational logic for state machine
   always @(*)
     begin
	// assign default value for all combinational signals
        state_next            = state_current;
	bit_count_next        = bit_count_current;
	reg_rw_next           = reg_rw_current;
	reg_addr_next         = reg_addr;
	MISO_next             = 1'b0;
	MISO_enable_next      = 1'b0;
	
		
	   //  
	
   
	case(state_current)
	  S0_IDLE : begin
	     if (CSN == 1'b0) begin
		state_next     = S1_RW;
		//bit_count_next = bit_count_current - 1'b1;
	     end
	  end
	  S1_RW : begin
	     
	     state_next     = S2_REG_ADDR;
	     reg_rw_next    = spi_shift_reg_current[0];
	     bit_count_next = bit_count_current - 1'b1;
	      
	  end
	  S2_REG_ADDR : begin
	     bit_count_next = bit_count_current - 1'b1;
	     if (bit_count_current == 6'd23) begin
	       state_next      = S3_DEAD_TIME_1; 
	       

		   if(reg_addr_next == 10'd2) begin
				if(reg_rw_current == WRITE_MODE) begin
				   reg_fifo_write_addr_next = spi_shift_reg_current[9:0]; 
				   write_flag = 1'b1;
				   end
				else begin
			       reg_addr_next   = spi_shift_reg_current[9:0];
				   read_flag = 1'b1;
				   end   
		        end
		   else if(reg_addr_next >= 10'd128 && reg_addr_next <= 10'd198) begin
				if(reg_rw_current == WRITE_MODE) begin
				   reg_fifo_write_addr_next = spi_shift_reg_current[9:0];
					write_flag = 1'b1;
				   end
				else begin
			       reg_addr_next   = spi_shift_reg_current[9:0];
				   read_flag = 1'b1;
				   end   
		        end
		   else if(reg_addr_next >= 10'd256 && reg_addr_next <= 10'd326) begin
				if(reg_rw_current == WRITE_MODE) begin
				   reg_fifo_write_addr_next = spi_shift_reg_current[9:0];
				   write_flag = 1'b1;
				   end
				else begin
			       reg_addr_next   = spi_shift_reg_current[9:0];
				   read_flag = 1'b1;
				   end   
		        end
		   else if(reg_addr_next >= 10'd512 && reg_addr_next <= 10'd1023) begin
				if(reg_rw_current == WRITE_MODE) begin
				   reg_fifo_write_addr_next = spi_shift_reg_current[9:0];
				   write_flag = 1'b1;
				   end
				else begin
			       reg_addr_next   = spi_shift_reg_current[9:0];
				   read_flag = 1'b1;
				   end   
		        end
		    else
			     reg_addr_next   = spi_shift_reg_current[9:0];		
		  
		   
	       
	     end
	  end
	  S3_DEAD_TIME_1 : begin
		  bit_count_next = bit_count_current - 1'b1;


          if(write_flag == 1'b1)
		      fifo_write_addr_enable_next = 1'b1;
		  else 
		      fifo_write_addr_enable_next = 1'b0;	  

		   if(read_flag == 1'b1)
		      reg_write_enable_next = 1'b1;
		   else 
		      reg_write_enable_next = 1'b0;	  	  
		

          
		if(read_empty == 1'b0)
			    reg_read_enable_next = 1'b1;

	     if(bit_count_current <= 6'd21) begin	
				write_flag = 1'b0;
				 read_flag = 1'b0;
			 end 
		 		
		     	 

		 if (bit_count_current == 6'd14)  begin
		   
		   if(reg_addr == 10'd1)
	             state_next      = S4_DECISION_TEST;
	       else if(reg_addr == 10'd0) begin
				state_next      = S4_DECISION_EM;
				reg_read_data_next = {6'd0,mapping,enable};
				end
		   else if(reg_addr == 10'd2) begin
				state_next      = S4_DECISION_FREQ;
				
		        end
		   else if(reg_addr >= 10'd128 && reg_addr <= 10'd198) begin
				state_next      = S4_DECISION_I_COEFF; 
				
				end
		   else if(reg_addr >= 10'd256 && reg_addr <= 10'd326) begin
				state_next      = S4_DECISION_Q_COEFF;
				
				end
		   else if(reg_addr >= 10'd512 && reg_addr <= 10'd639) begin
				state_next      = S4_DECISION_I_FIRST;
				
				end
		   else if(reg_addr >= 10'd640 && reg_addr <= 10'd767) begin
				state_next      = S4_DECISION_I_LAST;
				
				end
		   else if(reg_addr >= 10'd768 && reg_addr <= 10'd895) begin
				state_next      = S4_DECISION_Q_FIRST;
				
				end
		   else if(reg_addr >= 10'd896 && reg_addr <= 10'd1023) begin
				state_next      = S4_DECISION_Q_LAST;
				
				end
		   else
			    state_next      = S4_DECISION_UNUSED;
				
	         
   		
	       end
	  end  
	  
	  S4_DECISION_EM : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	        if(reg_rw_current == WRITE_MODE) 
			     enable_next = spi_shift_reg_current[0];
		  end
			  
	      
	  end
	  
	  S4_DECISION_TEST : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = register_array_test[7];
			register_array_test_next = {register_array_test[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	        if(reg_rw_current == WRITE_MODE) 
			     reg_fifo_write_data_next = spi_shift_reg_current[7:0];
			 
		   end 
	      
	  end

	   S4_DECISION_FREQ : begin
		  bit_count_next = bit_count_current - 1'b1;
		  

		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	        if(reg_rw_current == WRITE_MODE) begin
			     reg_fifo_write_data_next = spi_shift_reg_current[7:0];
				 fifo_write_flag = 1'b1;
			end 
			 
		   end 

	  end
	  
	  S4_DECISION_I_COEFF : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	        if(reg_rw_current == WRITE_MODE) begin
			     reg_fifo_write_data_next = spi_shift_reg_current[7:0];
				 fifo_write_flag = 1'b1;
			end 
			 
		   end 

	  end	   

	  S4_DECISION_Q_COEFF : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	         if(reg_rw_current == WRITE_MODE) begin
			     reg_fifo_write_data_next = spi_shift_reg_current[7:0];
				 fifo_write_flag = 1'b1;
			end 
			 
		   end	   
	      
	  end

	  S4_DECISION_I_FIRST : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	      
			 
		   end	   
	      
	  end

	  S4_DECISION_I_LAST : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	
			 
		   end	   
	      
	  end

	  S4_DECISION_Q_FIRST : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;
	
			 
		   end	   
	      
	  end

	  S4_DECISION_Q_LAST : begin
		  bit_count_next = bit_count_current - 1'b1;
		   
		 if(reg_rw_current == READ_MODE && bit_count_current >= 6'd6) begin
			MISO_enable_next = 1'b1;
			MISO_next = reg_read_data_current[7];
			reg_read_data_next = {reg_read_data_current[6:0],MISO_next};
		  end
		  
		  if (bit_count_current == 6'd6) begin
	        state_next      = S5_DEAD_TIME_2;

			 
		   end	   
	      
	  end
  
	  S5_DEAD_TIME_2 : begin
	     bit_count_next = bit_count_current - 1'b1;

		if(fifo_write_flag == 1'b1) 
	     	fifo_write_data_enable = 1'b1;
		else
		    fifo_write_data_enable = 1'b0;	

		if(bit_count_current <= 6'd3) begin
              fifo_write_flag = 1'b0;
		end

	     if(bit_count_current == 6'd0) begin
			state_next     = S0_IDLE;
			bit_count_next = 6'd33;
			reg_read_enable_next = 1'b0;
			MISO_enable_next = 1'b0;
	     end
	  end
	  
	  default: begin
	  state_next     = S0_IDLE;
	  end
	endcase // case (state_current)
	
	
     end // always @ (*)
	 
	
   
endmodule // spi_interface
	     `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// SPI Interface
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module baseband(
		     input wire	       clk,
		     input wire	       data_in,
		     input wire	       rst_n,
		     output reg [3:0] I_data,
		     output reg [3:0] Q_data,
		     input wire        enable,
			 output reg        mapping
		     );

   // internal registers
	reg [11:0] counter;
	reg [2:0]  state_current;
	reg  mapping_next;
	reg [11:0]	spi_shift_reg_current;
   
   // internal combinational variables
    reg enable_next;
	reg [11:0] count_next;
	reg [9:0] new_symbol_count_next;
	reg [2:0]  state_next;
	reg [11:0]	spi_shift_reg_next;
	reg  new_symbol_next;
	reg [3:0] I_data_next;
	reg [3:0] Q_data_next;
   
   // decalare state names
   parameter [1:0]		       S0_IDLE              = 2'd0;
   parameter [1:0]		       S1_SYMBOL            = 2'd1;
   parameter [1:0]		       S2_END               = 2'd2;
    parameter [11:0]		  HEADER_INFO           = 12'hB38;
   
   integer i;
    

   // clock in registers, asynch active-low reset
   always @(posedge clk or negedge rst_n)
     begin
	if (rst_n == 1'b0) begin
	 mapping <= 1'b0;
	 state_current <= S0_IDLE;
	 spi_shift_reg_current <= 12'h000;
	end else begin
	 mapping <= mapping_next;
	 state_current <= state_next;
	 spi_shift_reg_current <= spi_shift_reg_next;
	 I_data <= I_data_next;
	 Q_data <= Q_data_next;
	end
     end // always @ (posedge clk or negedge rst_n)


   always @(*)
     begin
	spi_shift_reg_next = {spi_shift_reg_current[10:0], data_in};
     end

   // combinational logic for state machine
   always @(*)
     begin
	// assign defautl value for all combinational signals
	 mapping_next = mapping;
	 state_next = state_current;
	 
   
	case(state_current)
	  S0_IDLE : begin
	  count_next = counter + 1'b1;
	    if(spi_shift_reg_current == HEADER_INFO) begin
		   state_next     = S1_SYMBOL;
		end
	  end
	  
	  S1_SYMBOL : begin
	   if(enable == 1'b1) begin
	     
	      I_data_next[0] = 1'b1;
		  Q_data_next[0] = 1'b1;
		  I_data_next[3] = ~spi_shift_reg_current[2];
		  Q_data_next[3] = ~spi_shift_reg_current[5];
		  I_data_next[2:1] = spi_shift_reg_current[1:0];
		  Q_data_next[2:1] = spi_shift_reg_current[4:3];
		  
		  mapping_next = 1'b1;
	   end
	   else
	     mapping_next = 1'b0;
		 state_next     = S0_IDLE;
	  end 
	  
	  default: begin
	  state_next     = S0_IDLE;
	  end
	endcase // case (state_current)
	
	
     end // always @ (*)
	 
	
   
endmodule // baseband

	
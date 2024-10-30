`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// 64-QAM modulator top module
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module symbol_storage(
			   input wire  sym_clk,
			   input wire [3:0] I_data,
			   input wire [3:0] Q_data,
			   input wire  rst_n_sym,
			   input wire  IQ_empty,
			   input wire  SPI_addr_empty,
			   input wire [8:0]  reg_addr,
			   output reg [7:0] reg_data		     
		     );

   // internal signals
   
   
   
   reg [7:0] register_array [0:511];
   reg [7:0] register_array_next;
   reg [9:0] count;
   reg [9:0] count_next;
   reg [7:0] reg_data_next;
   
   integer i;
   
      always @(posedge sym_clk or negedge rst_n_sym)
	  begin
	     if(rst_n_sym == 1'b0) begin
		   count <= 10'd0;
		   for(i=0;i<512;i=i+1'b1)
		     register_array[i] <= 8'h00;
		 end
		 
		 else begin
		  count <= count_next;
		  register_array[count_next] <= register_array_next;
		  reg_data <= reg_data_next;
		 end
		 
	  end
   
   always @(IQ_empty)
   begin
     if(IQ_empty == 1'b0) begin
	    register_array_next = {I_data,Q_data};
		count_next = count + 1'b1;
		end
	else
      count_next = count;	
   end
   
   always @(SPI_addr_empty)
   begin
     if(SPI_addr_empty == 1'b0)
	    reg_data_next = register_array[reg_addr];
	   else
        reg_data_next = reg_data;	   
   end
   
	   
   	   
  
   // read data
   
    // write data 

endmodule // qam

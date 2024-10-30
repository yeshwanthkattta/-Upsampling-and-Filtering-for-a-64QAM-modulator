`timescale 1ns / 1ps
module sync_fifo_ff_syn(
	    input wire	     clk,
	    input wire	     rst_n,
	    input wire [3:0]     data_in,
	    output reg [3:0]    data_out
    );

   // internal registers
   reg 		     data_mid;

   // write sequential logic, active-low asynch reset
   always @(posedge clk or negedge rst_n)
     begin
	if (rst_n == 1'b0) begin
	   // reset all registers to default values
	   data_out <= 1'b0;
	   data_mid <= 1'b0;
	end else begin
	   data_out <= data_mid;
	   data_mid <= data_in;
	end // else: !if(rst_n == 1'b0)
     end // always @ (posedge clk or negedge rst_n)

endmodule

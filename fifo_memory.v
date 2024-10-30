`timescale 1ns / 1ps
module fifo_mem (
  input write_clk, write_enable, read_clk, read_enable,
  input [3:0] write_pointer, read_pointer,
  input [7:0] data_in,
  input full, empty,
  output reg [7:0] data_out
);
  reg [7:0]		     fifo_data[0:3];
  
  always@(posedge write_clk) begin
    if(write_enable & !full) begin
      fifo_data[write_pointer[2:0]] <= data_in;
    end
  end
  always@(posedge read_clk) begin
    if(read_enable & !empty) begin
      data_out <= fifo_data[read_pointer[2:0]];
    end
  end
  
endmodule
`timescale 1ns / 1ps
module rptr_handler (
  input read_clk, read_rst_n, read_enable,
  input [3:0] write_pointer_sync,
  output reg [3:0] read_pointer, read_gray_pointer,
  output reg empty
);

  wire [3:0] read_pointer_next;
  wire [3:0] read_gray_pointer_next;
   
  
  wire empty_next;
  
  assign read_pointer_next = read_pointer+(read_enable & !empty);
  assign read_gray_pointer_next = (read_pointer_next >>1)^read_pointer_next;
  
  always@(posedge read_clk or negedge read_rst_n) begin
    if(!read_rst_n) begin
      read_pointer <= 0;
      read_gray_pointer <= 0;
	  empty <= 1'd1;
    end
    else begin
      read_pointer <= read_pointer_next;
      read_gray_pointer <= read_gray_pointer_next;
	  empty <= empty_next;
    end
  end

  assign empty_next = (read_gray_pointer_next == write_pointer_sync);

endmodule
`timescale 1ns / 1ps
module wptr_handler (
  input write_clk, write_rst_n, write_enable,
  input [3:0] read_pointer_sync,
  output reg [3:0] write_pointer, write_gray_pointer,
  output reg full
);

  wire [3:0] write_pointer_next;
  wire [3:0] write_gray_pointer_next;
   
  
  wire full_next;
  
  assign write_pointer_next = write_pointer+(write_enable & !full);
  assign write_gray_pointer_next = (write_pointer_next >>1)^write_pointer_next;
  
  always@(posedge write_clk or negedge write_rst_n) begin
    if(!write_rst_n) begin
      write_pointer <= 0;
      write_gray_pointer <= 0;
	  full <= 0;
    end
    else begin
      write_pointer <= write_pointer_next;
      write_gray_pointer <= write_gray_pointer_next;
	  full <= full_next;
    end
  end

  assign full_next = (write_gray_pointer_next == {~read_pointer_sync[3:2], read_pointer_sync[1:0]});

endmodule
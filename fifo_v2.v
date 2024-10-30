`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// FIFO
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_v2(
	    input wire	     write_clk,
	    input wire	     write_rst_n,
		input wire	     read_clk,
	    input wire	     read_rst_n,
	    input wire [7:0] data_in,
	    input wire	     write_enable,
	    input wire	     read_enable,
	    output reg [7:0] data_out,
	    output reg	     full,
	    output reg	     empty
    );



  wire [3:0] write_pointer_sync, read_pointer_sync;
  wire [3:0] write_pointer, read_pointer;
  wire [3:0] write_gray_pointer, read_gray_pointer;
  
  wire empty_ff, full_ff;
  wire [7:0] data_out_ff;
  
  always @(*) begin
  
  full = full_ff;
  empty = empty_ff;
  data_out = data_out_ff;

  end


  sync_fifo_ff_syn  sync_wptr (write_clk, write_rst_n, write_gray_pointer, write_pointer_sync);
  sync_fifo_ff_syn  sync_rptr (read_clk, read_rst_n, read_gray_pointer, read_pointer_sync);
  
  wptr_handler  wptr_h(write_clk, write_rst_n, write_enable,read_pointer_sync,write_pointer,write_gray_pointer,full_ff);
  rptr_handler  rptr_h(read_clk, read_rst_n, read_enable,write_pointer_sync,read_pointer,read_gray_pointer,empty_ff);
  fifo_mem    fifom(write_clk, write_enable, read_clk, read_enable,write_pointer, read_pointer, data_in,full,empty, data_out_ff);

	 

endmodule

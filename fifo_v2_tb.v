
`timescale 1ns / 1ps

module fifo_v2_tb(
    );
    
   reg        write_clk;
   reg	      write_rst_n;
   reg        read_clk;
   reg        read_rst_n;
   reg	      write_enable;
   reg	      read_enable;	    
   reg  [7:0] write_data;
   wire [7:0] read_data;
   wire	      fifo_full;  
   wire	      fifo_empty;
   
    integer i;
	
   fifo_v2 DUT(
	    .write_clk(write_clk),
	    .write_rst_n(write_rst_n),
		.read_clk(read_clk),
	    .read_rst_n(read_rst_n),
	    .data_in(write_data),
	    .write_enable(write_enable),
	    .read_enable(read_enable),	    
	    .data_out(read_data),
	    .full(fifo_full),
	    .empty(fifo_empty)
	    );
    
    always #5 write_clk = ~write_clk;
	always #8.5 read_clk = ~read_clk;
	
    
    initial begin
    write_clk = 1'b0; 
	write_rst_n = 1'b0;
    write_enable = 1'b0;
    write_data = 0;
    
    repeat(10) @(posedge write_clk);
    write_rst_n = 1'b1;

    repeat(2) begin
      for ( i=0; i < 30; i=i+1) begin
        @(posedge write_clk);
        write_enable = (i%2 == 0)? 1'b1 : 1'b0;
        if (write_enable & !fifo_full) begin
          write_data = $urandom;
        end
      end
      #50;
    end
  end

  initial begin
    read_clk = 1'b0; 
	read_rst_n = 1'b0;
    read_enable = 1'b0;

    repeat(10) @(posedge read_clk);
    read_rst_n = 1'b1;

    repeat(2) begin
      for ( i=0; i < 30; i=i+1) begin
        @(posedge read_clk );
        read_enable = (i%2 == 0)? 1'b1 : 1'b0;
        if (read_enable & !fifo_empty) begin
          $display(" read_data = %h",read_data);
        end
      end
      #50;
    end

    $finish;
  end
    
endmodule


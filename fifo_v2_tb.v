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
       // initial values
       write_clk           = 0;
	   read_clk           = 0;
       write_rst_n         = 0;
	   read_rst_n         = 0; 
       write_enable   = 0;
       read_enable   = 0;
       write_data    = 0;


		$monitor("FIFO full = %b, FIFO empty = %b, %d", fifo_full, fifo_empty, $time);

       // write tests       
       #20
       write_rst_n = 1;
	   read_rst_n = 1;
	   
	   #20 
	   
	   write_data = 8'h11;
	   write_enable = 1;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'h23;
	  $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'h36;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'h75;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'h21;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'h99;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'hAB;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'hFE;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'h48;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	    #9
	   write_data = 8'hFF;
	   $display ( " Write_data = %h, Time %d" , write_data, $time);
	   
	   #20
	   write_enable = 0;

	 
	   // read tests
	   
	 
		
		read_enable = 1;
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   #17
	   $display ( " Read_data = %h, Time %d" , read_data, $time);
	   
	   read_enable = 0;
     
      
       #30
	 $finish;
    end
    
endmodule

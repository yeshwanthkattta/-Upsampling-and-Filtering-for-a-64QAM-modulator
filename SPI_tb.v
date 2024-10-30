`timescale 1ns / 1ps

///////////////////////////////////////
// Professor Matthew LaRue
// ECE6213
// SPI controller Testbench Example
///////////////////////////////////////

module SPI_tb(
    );

   // SPI interface_signals   
   reg	      SCLK   = 1'b0;
   reg	      CSN    = 1'b1;
   reg	      MOSI   = 1'b0;	    
   reg	      MISO   = 1'b0;  
   reg	      MISO_enable = 1'b0;

   // signal for SPI data output 
   reg [15:0] SPI_data_out;

   // signals for simulation control
   reg             tb_clk = 1'b0; 	      
   reg [8*39:0]    testcase;	
   reg		   MISO_rand = 1'b0;

    // 100 kHz clk = 10,000ns period
    always #5000 tb_clk = ~tb_clk;

    // send random data on MISO to verify functionality
    always begin
       if (MISO_rand == 1'b1)
	 @(negedge tb_clk) MISO = $random;
       else
	 @(negedge tb_clk) MISO = 1'b0;
    end
   
    
    initial begin
       testcase = "Initializing";
       repeat(20)
	 @(posedge tb_clk);
       
       // send SPI command
       testcase = "SEND_SPI_1";
       SPI_CMD(1'b1,8'hAA,16'hCCDD,SPI_data_out);

       repeat(10)
	 @(posedge tb_clk);
       testcase = "RECEIVE_SPI_1";
       MISO_rand   = 1'b1;
       MISO_enable = 1'b1;
       SPI_CMD(1'b0,8'hA2,16'hCCDD,SPI_data_out);
       MISO_rand   = 1'b0;      

       repeat(10)
	 @(posedge tb_clk);
       
       testcase = "SEND_SPI_2";
       MISO_enable = 1'b0;
       SPI_CMD(1'b1,8'h3A,16'h2222,SPI_data_out);

       repeat(10)
	 @(posedge tb_clk);
       
       testcase = "RECEIVE_SPI_2";
       MISO_rand   = 1'b1;
       MISO_enable = 1'b1;
       SPI_CMD(1'b0,8'h67,16'hFFFF,SPI_data_out);
       MISO_rand   = 1'b0;
       
       repeat(10)
	 @(posedge tb_clk);
       
       testcase = "RECEIVE_SPI_HiZ";
       MISO_enable = 1'b0;
       SPI_CMD(1'b0,8'hAB,16'hCCDD,SPI_data_out);
       
       repeat(10)
	 @(posedge tb_clk);
       
       $finish;
    end


   task SPI_CMD (input	       SPI_read_write, 
                 input  [7:0]  SPI_addr,
		 input  [15:0] SPI_data_in,
                 output [15:0] SPI_data_out); 	 
      integer		       i;
      begin
	 
	 // active-low CSN active at clock negative edge, send read/write bit
	 @(negedge tb_clk)
           CSN = 1'b0;
	 
	 MOSI = SPI_read_write;
	 @(posedge tb_clk)
	   SCLK = 1'b1;
	 
	 // 8-bit address shifted on clock negedge, send SCLK aligned with tb_clk
	 for(i=7; i>=0; i=i-1) begin
	    @(negedge tb_clk)
	      SCLK = 1'b0;
	    MOSI = SPI_addr[i];	
            @(posedge tb_clk)
	      SCLK = 1'b1; 
	 end

	 // 5-bit dead time for data retrieval
	 for(i=4; i>=0; i=i-1) begin
	    @(negedge tb_clk)
	      SCLK = 1'b0;
	    MOSI = 1'b0;
            @(posedge tb_clk)
	      SCLK = 1'b1;	 
	 end
   
	 // 16-bit data shifted on clock negedge, send SCLK aligned with tb_clk
	 for(i=15; i>=0; i=i-1) begin
	    @(negedge tb_clk)
	      SCLK = 1'b0;
	    if ( SPI_read_write == 1'b1) begin
	       MOSI = SPI_data_in[i];
	    end else begin
	       MOSI = 1'b0;
	    end
	    
            @(posedge tb_clk)
	      SCLK = 1'b1;
	    // clock in data on MISO if MISO_enable = 1, else clock in that it is high-z
	    if (MISO_enable == 1'b1) begin
	      SPI_data_out[i] = MISO;
	    end else begin
	      SPI_data_out[i] = 1'bz;
	    end
	 end
	      
	 // 4-bit dead time for data write
	 for(i=4; i>=0; i=i-1) begin
	    @(negedge tb_clk)
	      SCLK = 1'b0;
	    MOSI = 1'b0;
            @(posedge tb_clk)
	      SCLK = 1'b1;	 
	 end

	 // end message and CSN goes inactive
	   SCLK = 1'b0;
	   CSN = 1'b1;

      end     
   endtask // SPI_CMD
   
   
endmodule

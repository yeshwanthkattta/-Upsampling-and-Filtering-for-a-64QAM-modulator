`timescale 1ns / 1ps

///////////////////////////////////////
// Professor Matthew LaRue
// ECE6213
// 64-QAM modulator testbench
// Only SPI interface implemented
///////////////////////////////////////

module final_tb(
    );

   // SPI interface_signals   
   reg	      SCLK   = 1'b0;
   reg	      data_clk   = 1'b0;
   reg	      sym_clk   = 1'b0;
   reg	      CSN    = 1'b1;
   reg	      MOSI   = 1'b0;
   reg	      rst_n  = 1'b0;	    
   reg	      data_in;	    
   wire	      MISO;  
   wire	      MISO_enable;
   
  

   // signal for SPI data output 
   reg [15:0] SPI_data_out;
    reg [15:0] SPI_data_out_next ;

   // signals for simulation control     
   reg [8*39:0]    testcase;	
   
   reg [9:0] reg_addr = 10'd513;
   reg [7:0] reg_data = 16'hABCD;
   
   integer i;
   integer j;
   integer pass_count = 0;

   // instantiate DUT
   modulator DUT(
		     .SCLK(SCLK),
		     .data_clk(data_clk),
		     .sym_clk(sym_clk),
		     .MOSI(MOSI),
		     .CSN(CSN),
		     .rst_n(rst_n),
		     .data_in(data_in),
		     .MISO(MISO),
		     .MISO_enable(MISO_enable)
		     );
   

    always #5000 SCLK = ~SCLK;
    always #8.3 data_clk = ~data_clk;
    always #50 sym_clk = ~sym_clk;
    
    always @(posedge SCLK)
    begin
       SPI_data_out <= SPI_data_out_next;
    end
	
	always @(*)
	begin
	  SPI_data_out_next = {SPI_data_out[14:0],MISO};
	end
	
	
	initial begin
	
	CSN = 1'b1;
	rst_n = 1'b0;
	#10 
	
	rst_n = 1'b1;
	#20
	
	  reg_data = 8'hAB;
	 
	  @(negedge SCLK); begin
	     CSN = 1'b0;
         MOSI = 1'b1;
         end
	  
      for(i=9; i>=0; i=i-1) begin
	      @(negedge SCLK)
	        MOSI = reg_addr[i];   
	   end
	  
      repeat (9) @(negedge SCLK);	
	  
      for(i=7; i>=0; i=i-1) begin
	      @(negedge SCLK)
	        MOSI = reg_data[i];
	   end
	  
       repeat (6) @(negedge SCLK);
	 
	   CSN = 1'b1;
	 

	 
	   #10
	 

	
		@(negedge SCLK) begin
		CSN = 1'b0;
		MOSI = 1'b0;
		end
		
		for(i=9; i>=0; i=i-1) begin
			@(negedge SCLK)
			MOSI = reg_addr[i];	
		end
	
		repeat (9) @(negedge SCLK);	
		
		repeat (8) @(negedge SCLK);
	
		repeat (6) @(negedge SCLK);
		
		
		CSN = 1'b1;
		   
		   
		  
		
  end


    //$finish;
	
	
endmodule
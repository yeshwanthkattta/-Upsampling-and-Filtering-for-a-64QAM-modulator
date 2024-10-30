`timescale 1ns / 1ps

module FIRFilter_tb();

reg clk = 1'b1;
reg signed [3:0] x_n = 4'h0;
reg write_en = 1'b0;
reg signed [7:0] coefficient; //coeff_in
reg signed [6:0] addr;
wire signed [11:0] y_n; //fir output
//wire [7:0] coeff_out;

reg [8*39:0]       testcase;
integer i;


/*CoeffRegisterArray uut (
    .clk(clk_tb),
    .addr(addr_tb),
    .coeff_in(coeff_in_tb),
    .write_en(write_en_tb),
    .coeff_out(coeff_out_tb)
);*/


FIRFilter dut(
    .clk(clk),
    .x_n(x_n),
    .write_en(write_en),
    .coefficient(coefficient),
    .addr(addr),
    .y_n(y_n)
);

    
always #5 clk = ~clk; // Generate a clock with 100MHz frequency

initial begin
      testcase = "Initializing";
/*
initial begin
    clk = 0;
  //  rst_tb = 0;
    #10;
    rst_tb = 1; // Release reset
    #10;IRFilter dut(
    .clk(clk),
    .x_n(x_n),
    .write_en(write_en),
    .coefficient(coefficient),
    .addr(addr),
    .y_n(y_n)
	

	x_n_tb = 4'd9;
	#710;
	#710;
	$display("output %d", y_n_tb);
	#710;
	#710;
	//$display("coeff %d", y_n_tb);

end
*/

      repeat(10)
	@(posedge clk);
	     

      // generate data to write into coeff memory
      for (i=0; i <=70; i = i+1) begin
	 write_en = 1'b1;
         addr  = i;
         coefficient   = i;
	 @(negedge clk);	 
      end
	
      write_en = 1'b0;

      // flush the pipeline
      repeat(100)
	@(posedge clk);


      // simulate filter impulse response  
      testcase = "Impulse";
      @(negedge clk);
      x_n = 4'h1;
      @(negedge clk);
      x_n = 4'h0;
      @(negedge clk);
      repeat(100)
	@(posedge clk);
      @(negedge clk);

      // simulate filter step response
      testcase = "Step";
      x_n = 4'h1;
      repeat(100)
	@(posedge clk);

      // flush the pipeline
      x_n = 4'h0;
      repeat(100)
	@(posedge clk);

      // simulate filter negativeimpulse response  
      testcase = "Neg_Impulse";
      @(negedge clk);
      x_n = 4'hF;
      @(negedge clk);
      x_n = 4'h0;
      @(negedge clk);
      repeat(100)
	@(posedge clk);
      @(negedge clk);

      // simulate filter negative step response
      testcase = "Neg_Step";
      x_n = 4'hF;
      repeat(100)
	@(posedge clk);


      repeat(1000)
	@(posedge clk);

      $finish;
      
   end // initial begin
endmodule

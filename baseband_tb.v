`timescale 1ns / 1ps

///////////////////////////////////////
// Professor Matthew LaRue
// ECE6213
// 64-QAM modulator testbench
// Only SPI interface implemented
///////////////////////////////////////

module baseband_tb(
    );

   // SPI interface_signals   
			 reg	       CLK = 1'b0;
		      reg	       data_in = 1'b0;
		      reg	       rst_n;
		       wire signed [3:0] I_data;
		       wire signed [3:0] Q_data;
		      wire        new_symbol;
	
   
   
   integer i;
   integer j;
   
   reg [5:0] data_vec = 6'd0;

   // instantiate DUT
   baseband DUT(
		     .CLK(CLK),
		     .data_in(data_in),
		     .rst_n(rst_n),
		     .I_data(I_data),
		     .Q_data(Q_data),
		     .new_symbol(new_symbol)
		     );
   

    reg [11:0] header = 12'hB38;

    always #10 CLK = ~CLK;

 
	initial begin
	
	$monitor("%b , I = %d, Q = %d",data_vec,I_data,Q_data);
	
	rst_n = 1'b0;
	#10
	rst_n = 1'b1;
	#20
	

	
	for(i=11;i>=0;i=i-1) begin
	@(posedge CLK) 
	data_in = header[i];
	end
	
   #40
 
	for(j=0;j<512;j=j+1) begin
	data_vec [5:0] = $random;
	  for(i=5;i>=0;i=i-1) begin
	  @(posedge CLK)
	      data_in = data_vec[i];
	  end
	  #40;
	end
	
	$finish;
	
	end // end initial
	
endmodule
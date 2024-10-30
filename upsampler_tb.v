`timescale 1ns / 1ps

module upsampler_tb;
 
parameter clk_period = 10;
parameter simulation_time = 2000; 
  
reg clk;
reg rst;
reg [3:0] data_in;
wire [3:0] data_out;
  
upsampler upsampler (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out));
  
always #(clk_period/2) clk = ~clk;
  
initial 
  begin
    clk = 0;
    rst = 1;
    data_in = 4'b1010;
    #10 rst = 0;
    #20 data_in = 4'b0110;
    #simulation_time 
    $finish;
  end
  
always @(posedge clk) 
  begin
    $display("Time = %0t, data_out = %b", $time, data_out);
  end

endmodule

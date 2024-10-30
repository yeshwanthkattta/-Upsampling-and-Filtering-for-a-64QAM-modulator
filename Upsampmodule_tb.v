`timescale 1ns / 1ps

module Upsampmodule_tb;

    reg clk;
    reg rst;
    reg [3:0] data_in;
  //  reg [3:0] I;
   // reg [3:0] Q;
   // reg valid_data;
  //  reg [8:0] upsampling_rate;
    wire [9:0] I_out;
    wire [9:0] Q_out;
  //  reg spi_read;
   // reg [7:0] spi_address;
    wire [11:0] spi_data_out;

    // Instantiate the top module
    Upsampmodule dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
      //  .valid_data(valid_data),
      //  .upsampling_rate(upsampling_rate),
        .I_out(I_out),
        .Q_out(Q_out),
       //.spi_read(spi_read),
       // .spi_address(spi_address),
        .spi_data_out(spi_data_out)
    );


    always #5 clk = ~clk;

    initial begin

        rst = 1;
        clk = 0;
        data_in = 0;
    //    valid_data = 0;
    //    upsampling_rate = 9'b0;
    //    spi_read = 0;
      //  spi_address = 8'b0; 
        #20 rst = 0;  
        #10 data_in = 4'b1010; 
     //   #10 valid_data = 1;
        #10 data_in = 4'b0101;
     //   #10 valid_data = 1; 

        #10 $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("At time %t, I_out = %b, Q_out = %b", $time, I_out, Q_out);
    end

endmodule


`timescale 1ns / 1ps

module Upsampmodule(
    input wire clk,  // Clock for the operation (presumably the upsampling clock)
    input wire rst,  // Active-low reset
    input wire [3:0] data_in,
   // input wire [3:0] I,
  // input wire [3:0] Q,
 // input wire [11:0] I_filter,  // Filtered I-channel data
   // input wire [11:0] Q_filter,  // Filtered Q-channel data
   // input wire valid_data,  // Signal indicating data validity from the filter
   // input wire [8:0] upsampling_rate,  // Upsampling rate, affects packet size
    output reg [9:0] I_out,  // Validated I-channel output to DAC
    output reg [9:0] Q_out,  // Validated Q-channel output to DAC
 //   input wire spi_read,  // SPI read signal for reading stored samples
  //  input wire [7:0] spi_address,  // SPI address for accessing specific samples
    output reg [8:0] spi_data_out  // Data output for SPI interface
//output reg [11:0] filtered_output  // Declare filtered_output as an output
);
/*
//reg filtered_output;
reg [3:0] I;
reg [3:0] Q;
reg [11:0] I_filter_int;
reg [11:0] Q_filter_int;

always @* begin
        I = data_in[3:0];
        Q = data_in[3:0];
    end

always @* begin
        I_filter_int = filtered_output[11:0];
        Q_filter_int = filtered_output[11:0];
    end

*/
UpsampFilter upsamp_filter_inst (
	.clk(clk),
	.rst(rst),
	.data_in(data_in),
	.addr(addr),
	.coefficient(coefficient),
	.write_en(write_en),
	.filtered_output(filtered_output)
);


/*
UpsampFilter upsamp_filter_inst (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .I(I),
    .Q(Q),
    .I_filter(I_filter),
    .Q_filter(Q_filter),
  //  .valid_data(valid_data),
  //  .upsampling_rate(upsampling_rate),
    .I_out(I_out),
    .Q_out(Q_out),
    .spi_read(spi_read),
    .spi_address(spi_address),
    .spi_data_out(spi_data_out)
//.filtered_output(I_filter_int),  // Connect filtered_output to I_filter_int
   // .filtered_output(Q_filter_int)   // Connect filtered_output to Q_filter_int
);
*/
OutputStorageAndValidation output_storage_inst (
	.clk(clk),
	.rst(rst),
	.I_filter(I_filter),
	.Q_filter(Q_filter),
	.valid_data(valid_data),
	.upsampling_rate(upsampling_rate),
	.I_out(I_out),
	.Q_out(Q_out),
	.spi_read(spi_read),
	.spi_address(spi_address),
	.spi_data_out(spi_out_data)
);

endmodule

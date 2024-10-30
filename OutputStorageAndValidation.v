`timescale 1ns / 1ps

module OutputStorageAndValidation(
    input wire clk,  // Clock for the operation (presumably the upsampling clock)
    input wire rst,  // Active-low reset
    input wire [11:0] I_filter,  // Filtered I-channel data
    input wire [11:0] Q_filter,  // Filtered Q-channel data
    input wire valid_data,  // Signal indicating data validity from the filter
    input wire [8:0] upsampling_rate,  // Upsampling rate, affects packet size
    output reg [9:0] I_out,  // Validated I-channel output to DAC
    output reg [9:0] Q_out,  // Validated Q-channel output to DAC
    input wire spi_read,  // SPI read signal for reading stored samples
    input wire [7:0] spi_address,  // SPI address for accessing specific samples
    output reg [11:0] spi_data_out  // Data output for SPI interface
);

    // Dynamic packet size based on upsampling rate
    wire [9:0] packet_size;  // Adjusted packet size
    assign packet_size = upsampling_rate * 512;  // Example multiplier, adjust as necessary

    localparam integer STORE_SIZE = 128;  // Storing first 64 and last 64 samples

    // Registers for storing I and Q samples
    reg [11:0] i_samples[STORE_SIZE-1:0];
    reg [11:0] q_samples[STORE_SIZE-1:0];
    integer i;

    // Control signals
    reg [9:0] sample_count;  // Track the total number of samples processed

    // Process input samples and store relevant ones
    always @(posedge clk or negedge rst) begin
        if (!reset) begin
            sample_count <= 0;
            I_out <= 0;
            Q_out <= 0;
            for (i = 0; i < STORE_SIZE; i = i + 1) begin
                i_samples[i] <= 0;
                q_samples[i] <= 0;
            end
        end else if (valid_data) begin
            // Increment sample counter and reset if necessary
            sample_count <= (sample_count == packet_size - 1) ? 0 : sample_count + 1;

            // Check if the current sample should be stored
            if (sample_count < 64) begin
                i_samples[sample_count] <= I_filter;
                q_samples[sample_count] <= Q_filter;
            end else if (sample_count >= (packet_size - 64)) begin
                i_samples[64 + sample_count - (packet_size - 64)] <= I_filter;
                q_samples[64 + sample_count - (packet_size - 64)] <= Q_filter;
            end

            // Output validation and formatting
            I_out <= I_filter[11:2];  // Taking the 10 MSBs
            Q_out <= Q_filter[11:2];
        end else begin
            I_out <= 0;  // Output zeros when data is not valid
            Q_out <= 0;
        end
    end

    // SPI interface to read stored samples
    always @(posedge clk) begin
        if (spi_read) begin
            if (spi_address < STORE_SIZE) begin
                spi_data_out <= (spi_address % 2 == 0) ? i_samples[spi_address / 2] : q_samples[spi_address / 2];
            end else begin
                spi_data_out <= 12'b0;
            end
        end
    end

endmodule

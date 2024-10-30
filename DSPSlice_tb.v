`timescale 1ns / 1ps

module DSPSlice_tb;

    reg clk_tb;
    reg rst_tb;
    reg [3:0] x_n_tb;
    reg [7:0] coefficient_tb;
    reg [11:0] acc_in_tb;
    wire [3:0] x_out_tb;
    wire [11:0] acc_out_tb;

    // Instantiate the DSPSlice
    DSPSlice uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .x_n(x_n_tb),
        .coefficient(coefficient_tb),
        .acc_in(acc_in_tb),
        .x_out(x_out_tb),
        .acc_out(acc_out_tb)
    );

    // Clock generation
    always #5 clk_tb = ~clk_tb; // Generate a clock with 100MHz frequency

    initial begin
        // Initialize
        clk_tb = 0;
        rst_tb = 0;
        x_n_tb = 0;
        coefficient_tb = 0;
        acc_in_tb = 0;

        // Release reset
        #10;
        rst_tb = 1;

        // Test Case 1: Simple multiplication
        x_n_tb = 4'b1010; // 10
        coefficient_tb = 8'b00000101; // 5
        acc_in_tb = 12'b0; // No previous accumulator value
        #10; // Wait for a clock cycle

        // Test Case 2: Add to accumulator
        x_n_tb = 4'b0101; // 5
        coefficient_tb = 8'b00000011; // 3
        acc_in_tb = acc_out_tb; // Feed previous acc_out as new acc_in
        #10; // Wait for a clock cycle

        // Additional test cases can be added here to fully exercise the module

        // End simulation
        $finish;
    end

endmodule

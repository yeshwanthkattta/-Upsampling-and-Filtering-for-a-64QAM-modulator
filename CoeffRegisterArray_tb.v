`timescale 1ns / 1ps

module CoeffRegisterArray_tb;

// Testbench Signals
reg clk_tb;
reg [6:0] addr_tb;
reg [7:0] coeff_in_tb;
reg write_en_tb;
wire [7:0] coeff_out_tb;

// Instantiate the Unit Under Test (UUT)
CoeffRegisterArray uut (
    .clk(clk_tb),
    .addr(addr_tb),
    .coeff_in(coeff_in_tb),
    .write_en(write_en_tb),
    .coeff_out(coeff_out_tb)
);

// Clock Generation for ~108.333 MHz (Period ~9.234 ns, rounded to 9.2ns for simplicity)
always #(4.6) clk_tb = ~clk_tb; // Half period is about 4.6ns for a full period of ~9.2ns

// Test Sequence
initial begin
    // Initialize Inputs
    clk_tb = 0;
    addr_tb = 0;
    coeff_in_tb = 0;
    write_en_tb = 0;

    // Reset Sequence
    #10; // Wait a bit before starting the test
    
    // Write coefficients to the array
    for (int i = 0; i < 71; i++) begin
        addr_tb = i; // Set address
        coeff_in_tb = i + 10; // Example coefficient value
        write_en_tb = 1; // Enable writing
        #10; // Wait a clock cycle
        write_en_tb = 0; // Disable writing
        #10; // Wait a clock cycle for the write to complete
    end
    
    // Read and verify the coefficients
    for (int i = 0; i < 71; i++) begin
        addr_tb = i; // Set address to read from
        #10; // Wait a clock cycle to update the output
        if (coeff_out_tb !== i + 10) begin
            $display("Mismatch at address %d: expected %d, got %d", i, i + 10, coeff_out_tb);
        end else begin
            $display("Address %d: verified coefficient %d", i, coeff_out_tb);
        end
    end
    
    // End of test
    $finish;
end

endmodule

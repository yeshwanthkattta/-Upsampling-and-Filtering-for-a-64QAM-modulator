`timescale 1ns /1ps

module DSPSlice(
    input wire clk,
  //  input wire rst_n,
    input wire signed [3:0] x_n, // 4-bit input data
    input wire signed [7:0] coefficient, // 8-bit coefficient
    input wire signed [11:0] acc_in, // 12-bit accumulator input, 0 for the first slice
    output wire signed [3:0] x_out, // 4-bit output for the next DSP slice
    output wire signed [11:0] acc_out // 12-bit accumulator output, delayed
);

// Corrected internal registers for delays
reg signed [3:0] x_n_delay1, x_n_delay2; // Delay registers for x[n]
reg signed [11:0] mult_result; // For storing the immediate multiplication result
//reg [11:0] mult_result_delay; // Delayed multiplication result for simulation processing time
reg signed [11:0] acc_temp; // Temporary accumulator register for holding delayed acc_out


// Sequential logic for handling delays and updating outputs
/*always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        // Reset all registers on reset
        x_n_delay1 <= 4'b0;
        mult_result_delay <= 12'b0;
        acc_temp <= 12'b0;
        acc_out <= 12'b0;
        x_out <= 4'b0;
    end else begin
        x_n_delay1 <= x_n;
		
        x_out <= x_n_delay1;
        
		mult_result_delay <= x_out * coefficient;

		acc_out <= mult_result_delay + acc_in;
    end
end
*/

assign x_out = x_n_delay2;
assign acc_out = acc_temp;

always @(posedge clk)
begin
x_n_delay1 <= x_n;
x_n_delay2 <= x_n_delay1;
mult_result <= x_n_delay2 * coefficient;
acc_temp <= acc_in + mult_result;
end

endmodule

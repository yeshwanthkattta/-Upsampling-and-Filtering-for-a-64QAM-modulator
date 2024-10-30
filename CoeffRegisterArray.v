`timescale 1ns / 1ps

module CoeffRegisterArray(
    input wire clk,                // Clock input
    input wire [6:0] addr,         // 7-bit address for accessing 71 entries
    input wire signed [7:0] coefficient,     // 8-bit input data for coefficients
    input wire write_en,           // Write enable signal
     // 8-bit output data for reading coefficients
    output wire signed [7:0] coeff_out0,
output wire signed [7:0] coeff_out1,
output wire signed [7:0] coeff_out2,
output wire signed [7:0] coeff_out3,
output wire signed [7:0] coeff_out4,
output wire signed [7:0] coeff_out5,
output wire signed [7:0] coeff_out6,
output wire signed [7:0] coeff_out7,
output wire signed [7:0] coeff_out8,   
output wire signed [7:0] coeff_out9,
output wire signed [7:0] coeff_out10,
output wire signed [7:0] coeff_out11,
output wire signed [7:0] coeff_out12,
output wire signed [7:0] coeff_out13,
output wire signed [7:0] coeff_out14,
output wire signed [7:0] coeff_out15,
output wire signed [7:0] coeff_out16,
output wire signed [7:0] coeff_out17,
output wire signed [7:0] coeff_out18,
output wire signed [7:0] coeff_out19,
output wire signed [7:0] coeff_out20,
output wire signed [7:0] coeff_out21,
output wire signed [7:0] coeff_out22,
output wire signed [7:0] coeff_out23,
output wire signed [7:0] coeff_out24,
output wire signed [7:0] coeff_out25,
output wire signed [7:0] coeff_out26,
output wire signed [7:0] coeff_out27,
output wire signed [7:0] coeff_out28,
output wire signed [7:0] coeff_out29,
output wire signed [7:0] coeff_out30,
output wire signed [7:0] coeff_out31,
output wire signed [7:0] coeff_out32,
output wire signed [7:0] coeff_out33,
output wire signed [7:0] coeff_out34,
output wire signed [7:0] coeff_out35,
output wire signed [7:0] coeff_out36,
output wire signed [7:0] coeff_out37,
output wire signed [7:0] coeff_out38,
output wire signed [7:0] coeff_out39,
output wire signed [7:0] coeff_out40,
output wire signed [7:0] coeff_out41,
output wire signed [7:0] coeff_out42,
output wire signed [7:0] coeff_out43,
output wire signed [7:0] coeff_out44,
output wire signed [7:0] coeff_out45,
output wire signed [7:0] coeff_out46,
output wire signed [7:0] coeff_out47,
output wire signed [7:0] coeff_out48,
output wire signed [7:0] coeff_out49,
output wire signed [7:0] coeff_out50,
output wire signed [7:0] coeff_out51,
output wire signed [7:0] coeff_out52,
output wire signed [7:0] coeff_out53,
output wire signed [7:0] coeff_out54,
output wire signed [7:0] coeff_out55,
output wire signed [7:0] coeff_out56,
output wire signed [7:0] coeff_out57,
output wire signed [7:0] coeff_out58,
output wire signed [7:0] coeff_out59,
output wire signed [7:0] coeff_out60,
output wire signed [7:0] coeff_out61,
output wire signed [7:0] coeff_out62,
output wire signed [7:0] coeff_out63,
output wire signed [7:0] coeff_out64,
output wire signed [7:0] coeff_out65,
output wire signed [7:0] coeff_out66,
output wire signed [7:0] coeff_out67,
output wire signed [7:0] coeff_out68,
output wire signed [7:0] coeff_out69,
output wire signed [7:0] coeff_out70
);

// Define a 71-address by 8-bit register array for storing the coefficients
reg signed [7:0] coeff_array[0:70];

// Write operation: Update coefficients on positive clock edge when write enabled
always @(posedge clk) begin
    if (write_en == 1'b1) begin
        coeff_array[addr] <= coefficient;
    end
end

// Read operation: Continuously output the coefficient at the current address
// Note: Read operation does not need to be clocked for this example
/*always @(*) begin
    coeff_out = coeff_array[addr];
end
*/

assign coeff_out0 = coeff_array[0];
assign coeff_out1 = coeff_array[1];
assign coeff_out2 = coeff_array[2];
assign coeff_out3 = coeff_array[3];
assign coeff_out4 = coeff_array[4];
assign coeff_out5 = coeff_array[5];
assign coeff_out6 = coeff_array[6];
assign coeff_out7 = coeff_array[7];
assign coeff_out8 = coeff_array[8];
assign coeff_out9 = coeff_array[9];
assign coeff_out10 = coeff_array[10];
assign coeff_out11 = coeff_array[11];
assign coeff_out12 = coeff_array[12];
assign coeff_out13 = coeff_array[13];
assign coeff_out14 = coeff_array[14];
assign coeff_out15 = coeff_array[15];
assign coeff_out16 = coeff_array[16];
assign coeff_out17 = coeff_array[17];
assign coeff_out18 = coeff_array[18];
assign coeff_out19 = coeff_array[19];
assign coeff_out20 = coeff_array[20];
assign coeff_out21 = coeff_array[21];
assign coeff_out22 = coeff_array[22];
assign coeff_out23 = coeff_array[23];
assign coeff_out24 = coeff_array[24];
assign coeff_out25 = coeff_array[25];
assign coeff_out26 = coeff_array[26];
assign coeff_out27 = coeff_array[27];
assign coeff_out28 = coeff_array[28];
assign coeff_out29 = coeff_array[29];
assign coeff_out30 = coeff_array[30];
assign coeff_out31 = coeff_array[31];
assign coeff_out32 = coeff_array[32];
assign coeff_out33 = coeff_array[33];
assign coeff_out34 = coeff_array[34];
assign coeff_out35 = coeff_array[35];
assign coeff_out36 = coeff_array[36];
assign coeff_out37 = coeff_array[37];
assign coeff_out38 = coeff_array[38];
assign coeff_out39 = coeff_array[39];
assign coeff_out40 = coeff_array[40];
assign coeff_out41 = coeff_array[41];
assign coeff_out42 = coeff_array[42];
assign coeff_out43 = coeff_array[43];
assign coeff_out44 = coeff_array[44];
assign coeff_out45 = coeff_array[45];
assign coeff_out46 = coeff_array[46];
assign coeff_out47 = coeff_array[47];
assign coeff_out48 = coeff_array[48];
assign coeff_out49 = coeff_array[49];
assign coeff_out50 = coeff_array[50];
assign coeff_out51 = coeff_array[51];
assign coeff_out52 = coeff_array[52];
assign coeff_out53 = coeff_array[53];
assign coeff_out54 = coeff_array[54];
assign coeff_out55 = coeff_array[55];
assign coeff_out56 = coeff_array[56];
assign coeff_out57 = coeff_array[57];
assign coeff_out58 = coeff_array[58];
assign coeff_out59 = coeff_array[59];
assign coeff_out60 = coeff_array[60];
assign coeff_out61 = coeff_array[61];
assign coeff_out62 = coeff_array[62];
assign coeff_out63 = coeff_array[63];
assign coeff_out64 = coeff_array[64];
assign coeff_out65 = coeff_array[65];
assign coeff_out66 = coeff_array[66];
assign coeff_out67 = coeff_array[67];
assign coeff_out68 = coeff_array[68];
assign coeff_out69 = coeff_array[69];
assign coeff_out70 = coeff_array[70];

endmodule

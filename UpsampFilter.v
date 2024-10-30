`timescale 1ns / 1ps

module UpsampFilter(
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
input wire signed [6:0] addr, // Coefficient address
input wire signed [7:0] coefficient, // Coefficient input value corff_in
input wire write_en, // Write enable
output wire [11:0] filtered_output
);
    // Interconnection wires

wire [3:0] upsampled_data;
wire signed [3:0] x_out_wires[0:71];
wire signed [11:0] acc_out_wires[0:71];
wire signed [7:0] coeff[0:70];
wire signed [11:0] y_n;


    // Instantiate Upsampler
    upsampler upsamp_inst(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(upsampled_data)
    );

    // Instantiate FIR Filter
    FIRFilter fir_filter_inst(
        .clk(clk),
        .x_n(upsampled_data),
        .write_en(write_en),
        .coefficient(coefficient),
        .addr(addr), 
        .y_n(filtered_output)
    );
/*

genvar i;

assign x_out_wires[0] = x_n;
   assign acc_out_wires[0] = 12'h000;
   assign y_n = acc_out_wires[71];


generate
    for (i = 0; i < 71; i = i + 1) begin : dslice
        DSPSlice slice (
            .clk(clk),
            .x_n(x_out_wires[i]),
            .coefficient(coeff[i]),
            .acc_in(acc_out_wires[i]),
            .x_out(x_out_wires[i+1]),
            .acc_out(acc_out_wires[i+1])
        );
    end
endgenerate

// Output assignment
//assign y_n = x_out_wires[N-1];  // The output from the last DSP slice

// filter coeff memory
   CoeffRegisterArray u_CoeffRegisterArray (
			       .clk(clk),
			       .coefficient(coefficient),
			       .addr(addr),
			       .write_en(write_en),
			       .coeff_out0(coeff[0]),
			       .coeff_out1(coeff[1]),
			       .coeff_out2(coeff[2]),
			       .coeff_out3(coeff[3]),
			       .coeff_out4(coeff[4]),
			       .coeff_out5(coeff[5]),
			       .coeff_out6(coeff[6]),
			       .coeff_out7(coeff[7]),
			       .coeff_out8(coeff[8]),
			       .coeff_out9(coeff[9]),
			       .coeff_out10(coeff[10]),
			       .coeff_out11(coeff[11]),
			       .coeff_out12(coeff[12]),
			       .coeff_out13(coeff[13]),
			       .coeff_out14(coeff[14]),
			       .coeff_out15(coeff[15]),
			       .coeff_out16(coeff[16]),
			       .coeff_out17(coeff[17]),
			       .coeff_out18(coeff[18]),
			       .coeff_out19(coeff[19]),
			       .coeff_out20(coeff[20]),
			       .coeff_out21(coeff[21]),
			       .coeff_out22(coeff[22]),
			       .coeff_out23(coeff[23]),
			       .coeff_out24(coeff[24]),
			       .coeff_out25(coeff[25]),
			       .coeff_out26(coeff[26]),
			       .coeff_out27(coeff[27]),
			       .coeff_out28(coeff[28]),
			       .coeff_out29(coeff[29]),
			       .coeff_out30(coeff[30]),
			       .coeff_out31(coeff[31]),
			       .coeff_out32(coeff[32]),
			       .coeff_out33(coeff[33]),
			       .coeff_out34(coeff[34]),
			       .coeff_out35(coeff[35]),
			       .coeff_out36(coeff[36]),
			       .coeff_out37(coeff[37]),
			       .coeff_out38(coeff[38]),
			       .coeff_out39(coeff[39]),
			       .coeff_out40(coeff[40]),
			       .coeff_out41(coeff[41]),
			       .coeff_out42(coeff[42]),
			       .coeff_out43(coeff[43]),
			       .coeff_out44(coeff[44]),
			       .coeff_out45(coeff[45]),
			       .coeff_out46(coeff[46]),
			       .coeff_out47(coeff[47]),
			       .coeff_out48(coeff[48]),
			       .coeff_out49(coeff[49]),
			       .coeff_out50(coeff[50]),
			       .coeff_out51(coeff[51]),
			       .coeff_out52(coeff[52]),
			       .coeff_out53(coeff[53]),
			       .coeff_out54(coeff[54]),
			       .coeff_out55(coeff[55]),
			       .coeff_out56(coeff[56]),
			       .coeff_out57(coeff[57]),
			       .coeff_out58(coeff[58]),
			       .coeff_out59(coeff[59]),
			       .coeff_out60(coeff[60]),
			       .coeff_out61(coeff[61]),
			       .coeff_out62(coeff[62]),
			       .coeff_out63(coeff[63]),
			       .coeff_out64(coeff[64]),
			       .coeff_out65(coeff[65]),
			       .coeff_out66(coeff[66]),
			       .coeff_out67(coeff[67]),
			       .coeff_out68(coeff[68]),
			       .coeff_out69(coeff[69]),
			       .coeff_out70(coeff[70])
			       );
*/
endmodule
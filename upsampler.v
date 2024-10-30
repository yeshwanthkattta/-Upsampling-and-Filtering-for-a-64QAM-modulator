`timescale 1ns / 1ps

module upsampler (
    input wire clk,         
    input wire rst,          
    input wire [3:0] data_in, 
    output reg [3:0] data_out);

parameter upsample_rate = 13; 
reg [3:0] counter = 0; 

always @(posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        counter <= 0; 
        data_out <= 4'b0;
    end
    else 
    begin
        if (counter == 0) 
	begin
            data_out <= data_in;
        end 
	else 
	begin
            data_out <= 4'b0;
        end
        if (counter == upsample_rate - 1) 
	begin
            counter <= 0;
        end 
	else
	begin
	    counter <= counter + 1;
	end
    end
end

endmodule


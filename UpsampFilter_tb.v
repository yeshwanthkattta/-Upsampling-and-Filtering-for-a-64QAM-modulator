`timescale 1ns / 1ps

module UpsampFilter_tb;

// Inputs
reg clk = 1'b1;
reg rst = 1'b1;
reg [3:0] data_in = 0;
wire [11:0] filtered_output;

reg signed [6:0] addr; // Coefficient address
reg signed [7:0] coefficient; // Coefficient input value corff_in
reg write_en = 1'b0; // Disable write initially
//wire signed [11:0] y_n;

//testcases
reg [8*39:0]       testcase;
integer i;

// Instantiate the Unit Under Test (UUT)
UpsampFilter uut (
    .clk(clk),
    .rst(rst),  
    .data_in(data_in), 
    .addr(addr), 
    .coefficient(coefficient), 
    .write_en(write_en), 
    .filtered_output(filtered_output)
);
/*
   upsampler dut1 (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(upsampled_data)
);
   FIRFilter dut (
        .clk(clk),
        .x_n(upsampled_data),
        .write_en(write_en),
        .coefficient(coefficient),
        .addr(addr), 
        .y_n(filtered_output)
    );
*/
/*
UpsampFilter uut (
    .clk(clk),
    .rst(rst),  
    .data_in(data_in), 
    .addr(addr), // Connect addr
    .coefficient(coefficient), // Connect coefficient
    .write_en(write_en), // Connect write_en
    .filtered_output(filtered_output)
);
*/
// Clock generation (approximately 108.33 MHz, period ≈ 9.23 ns)


// Test Sequence

   // rst = 1; // Assert reset
  //  data_in = 0; // Initial input
    
    // Initialize coefficients
    // Wait for reset release and stabilization
  // #13.851; //one and half clock cycle
  // reg rst = 1'b0;


always #4.615 clk = ~clk; // Half period ~4.615 ns for a full period of ~9.23 ns

initial begin
      testcase = "Initializing";

     repeat(10)
	@(posedge clk);
	     

      // generate data to write into coeff memory
      for (i=0; i <=70; i = i+1) begin
	 write_en = 1'b1;
         addr  = i;
         coefficient   = i;
	 @(negedge clk);	 
      end
	
      write_en = 1'b0;

      // flush the pipeline
      repeat(100)
	@(posedge clk);


      // simulate filter impulse response  
      testcase = "Impulse";
      @(negedge clk);
        data_in = 4'b1010;
      //data_in = 4'h1;
      @(negedge clk);
      data_in = 4'b0110;
      //data_in = 4'h0;
      @(negedge clk);
      repeat(100)
	@(posedge clk);
      @(negedge clk);

      // simulate filter step response
      testcase = "Step";
      data_in = 4'h1;
      repeat(100)
	@(posedge clk);

      // flush the pipeline
      data_in = 4'h0;
      repeat(100)
	@(posedge clk);

      // simulate filter negativeimpulse response  
      testcase = "Neg_Impulse";
      @(negedge clk);
      data_in = 4'hF;
      @(negedge clk);
      data_in = 4'h0;
      @(negedge clk);
      repeat(100)
	@(posedge clk);
      @(negedge clk);

      // simulate filter negative step response
      testcase = "Neg_Step";
      data_in = 4'hF;
      repeat(100)
	@(posedge clk);


      repeat(1000)
	@(posedge clk);

      $finish;
      
   end // initial begin

endmodule

    // Mimic writing coefficients to the CoeffRegisterArray
    // Coefficients are taken from the fixed-point representation
    // Example of writing first few coefficients, extend this to all coefficients
   /* integer i;
    for (i = 0; i < 71; i = i + 1) begin
        addr = i;
        write_en = 1;
        // Assign coeff_in_tb based on the coefficient values, one at a time
        case (i)
            // Add cases for each coefficient
            0: coefficient = 8'sd0;
            1: coefficient = 8'sd15;
            2: coefficient = 8'sd26;
            3: coefficient = 8'sd30;
            4: coefficient = 8'sd22;
            5: coefficient = 8'sd0;
            6: coefficient = -8'sd31;
            7: coefficient = -8'sd59;
            8: coefficient = -8'sd71;
            9: coefficient = -8'sd52;
            10: coefficient = 8'sd0;
            11: coefficient = 8'sd73;
            12: coefficient = 8'sd139;
            13: coefficient = 8'sd162;
            14: coefficient = 8'sd116;
            15: coefficient = 8'sd0;
            16: coefficient = -8'sd154;
            17: coefficient = -8'sd286;
            18: coefficient = -8'sd327;
            19: coefficient = -8'sd230;
            20: coefficient = 8'sd0;
            21: coefficient = 8'sd298;
            22: coefficient = 8'sd549;
            23: coefficient = 8'sd625;
            24: coefficient = 8'sd441;
            25: coefficient = 8'sd0;
            26: coefficient = -8'sd583;
            27: coefficient = -8'sd1097;
            28: coefficient = -8'sd1290;
            29: coefficient = -8'sd953;
            30: coefficient = 8'sd0;
            31 coefficient = 8'sd15;
            32: coefficient = 8'sd26;
            33: coefficient = 8'sd30;
            34: coefficient = 8'sd22;
            35: coefficient = 8'sd0;
            36: coefficient = -8'sd31;
            37: coefficient = -8'sd59;
            38: coefficient = -8'sd71;
            39: coefficient = -8'sd52;
            40: coefficient = 8'sd0;
            41: coefficient = 8'sd73;
            42: coefficient = 8'sd139;
            43: coefficient = 8'sd162;
            44: coefficient = 8'sd116;
            45: coefficient = 8'sd0;
            46: coefficient = -8'sd154;
            47: coefficient = -8'sd286;
            48: coefficient = -8'sd327;
            49: coefficient = -8'sd230;
            50: coefficient = 8'sd0;
            51: coefficient = 8'sd298;
            52: coefficient = 8'sd549;
            53: coefficient = 8'sd625;
            54: coefficient = 8'sd441;
            55: coefficient = 8'sd0;
            56: coefficient = -8'sd583;
            57: coefficient = -8'sd1097;
            58: coefficient = -8'sd1290;
            59: coefficient = -8'sd953;
            60: coefficient = 8'sd22;
            61: coefficient = 8'sd30;
            62: coefficient = 8'sd26;
            63: coefficient = 8'sd15;
            64: coefficient = 8'sd0;
            65: coefficient = 8'sd0;
            66: coefficient = -8'sd31;
            67: coefficient = -8'sd59;
            68: coefficient = -8'sd71;
            69: coefficient = -8'sd52;
            70: coefficient = 8'sd0;
            
            default: coefficient = 8'sd0; // Default case, should not occur
            // Continue for all coefficients...
            default: coefficient = 8'sd0;
        endcase
        #655.614; // Wait for a clock cycle
        write_en = 0; // Disable write
        #9; // Wait for the next cycle
    end
end
    // Provide input signals to the FIR filter after coefficients are loaded
    // Simulate input data
    #655.614 // wait for 71 clock cycles to loadf the data
    x_n = 4'b1010;
    #1311.22 //142 clock cycles
    x_n = 4'b1111;
     #1311.22 //142 clock cycles
   
*/


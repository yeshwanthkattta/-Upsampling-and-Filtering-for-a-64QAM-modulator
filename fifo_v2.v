`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Matthew LaRue 
// FIFO
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo(
	    input wire	     write_clk,
	    input wire	     write_rst_n,
		input wire	     read_clk,
	    input wire	     read_rst_n,
	    input wire [7:0] data_in,
	    output reg [7:0] data_out,
	    output reg	     full,
	    output reg	     empty
    );

   // internal registers
   reg [7:0]		     fifo_data_current[0:511];
   reg [8:0]		     write_pointer;
   reg [8:0]		     read_pointer;
   reg [8:0]		     write_gray_pointer;
   reg [8:0]		     read_gray_pointer;
   reg [8:0]		     qw;
   reg [8:0]		     qr;
   reg [8:0]		     write_pointer_sync;
   reg [8:0]		     read_pointer_sync;

   // internal combinational variables
   reg [7:0]		     fifo_data_next[0:511];
   reg [8:0]		     write_pointer_next;
   reg [8:0]		     read_pointer_next;
   reg [7:0]		     data_out_next;
   wire [8:0]		     write_gray_pointer_next;
   wire [8:0]		     read_gray_pointer_next;
   wire			     full_next;
   wire			     empty_next;

   // loop variables
   integer		     i;
   integer		     j;

   // sequential logic, active-low asynch reset
   always @(posedge write_clk or negedge write_rst_n)
     begin
	if (write_rst_n == 1'b0) begin
	   // reset all registers to default values
	   write_pointer <= 9'b000000000;
	   full          <= 1'b0;
	   write_gray_pointer <= 9'b000000000;
	   qr <= 9'b000000000;
	   read_pointer_sync <= 9'b000000000;
	   for(i=0;i<=7;i=i+1) begin
	      fifo_data_current[i] <= 8'h00;
	   end
	end else begin
	   write_pointer <= write_pointer_next;
	   full          <= full_next;
	   write_gray_pointer <= write_gray_pointer_next;
	   qr <= read_gray_pointer;
	   read_pointer_sync <= qr;
	   for(i=0;i<=7;i=i+1) begin
	      fifo_data_current[i] <= fifo_data_next[i];
	   end
	end // else: !if(rst_n == 1'b0)
     end // always @ (posedge clk or negedge rst_n)
	 
	 
	  // sequential logic, active-low asynch reset
   always @(posedge read_clk or negedge read_rst_n)
     begin
	if (read_rst_n == 1'b0) begin
	   // reset all registers to default values
	   read_pointer  <= 9'b000000000;
	   data_out      <= 8'h00;
	   empty         <= 1'b1;
	   read_gray_pointer <= 9'b000000000;
	   qw <= 9'b000000000;
	   write_pointer_sync <= 9'b000000000;
	end else begin
	   read_pointer  <= read_pointer_next;
	   data_out      <= data_out_next;
	   empty         <= empty_next;
	   read_gray_pointer <= read_gray_pointer_next;
	   qw <= write_gray_pointer;
	   write_pointer_sync <= qw;
	end // else: !if(rst_n == 1'b0)
     end // always @ (posedge clk or negedge rst_n)



/////////////////////////////////////////
   // combinational logic
   always @(*)
     begin
	// assign default values to all comb variables
	for(j=0;j<=7;j=j+1) begin
	      fifo_data_next[j] = fifo_data_current[j];
	end
	write_pointer_next = write_pointer;
	read_pointer_next  = read_pointer;
        data_out_next      = data_out;

	// fifo write logic
	if ( full == 1'b0 ) begin
	   fifo_data_next[write_pointer[2:0]] = data_in;
	   write_pointer_next                 = write_pointer + 1'b1;
	end

	// fifo read logic
	if ( empty == 1'b0 ) begin
	   data_out_next    = fifo_data_current[read_pointer[2:0]];
	   read_pointer_next = read_pointer + 1'b1;
	end
	  
	

	
     
	end // always @ (*)
	
		assign write_gray_pointer_next = (write_pointer_next >> 1) ^ write_pointer_next;
	assign read_gray_pointer_next = (read_pointer_next >> 1) ^ read_pointer_next;

assign 	empty_next = (write_pointer_sync == read_gray_pointer_next);
assign  full_next = (write_gray_pointer_next == {~read_pointer_sync[8:7],read_pointer_sync[6:0]} );
	 
	 


  

endmodule


module fifo_9bit(
	    input wire	     write_clk,
	    input wire	     write_rst_n,
		input wire	     read_clk,
	    input wire	     read_rst_n,
	    input wire [8:0] data_in,
	    output reg [8:0] data_out,
	    output reg	     full,
	    output reg	     empty
    );

   // internal registers
   reg [8:0]		     fifo_data_current[0:511];
   reg [8:0]		     write_pointer;
   reg [8:0]		     read_pointer;
   reg [8:0]		     write_gray_pointer;
   reg [8:0]		     read_gray_pointer;
   reg [8:0]		     qw;
   reg [8:0]		     qr;
   reg [8:0]		     write_pointer_sync;
   reg [8:0]		     read_pointer_sync;

   // internal combinational variables
   reg [8:0]		     fifo_data_next[0:511];
   reg [8:0]		     write_pointer_next;
   reg [8:0]		     read_pointer_next;
   reg [8:0]		     data_out_next;
   wire [8:0]		     write_gray_pointer_next;
   wire [8:0]		     read_gray_pointer_next;
   wire			     full_next;
   wire			     empty_next;

   // loop variables
   integer		     i;
   integer		     j;

   // sequential logic, active-low asynch reset
   always @(posedge write_clk or negedge write_rst_n)
     begin
	if (write_rst_n == 1'b0) begin
	   // reset all registers to default values
	   write_pointer <= 9'b000000000;
	   full          <= 1'b0;
	   write_gray_pointer <= 9'b000000000;
	   qr <= 9'b000000000;
	   read_pointer_sync <= 9'b000000000;
	   for(i=0;i<=8;i=i+1) begin
	      fifo_data_current[i] <= 9'h000;
	   end
	end else begin
	   write_pointer <= write_pointer_next;
	   full          <= full_next;
	   write_gray_pointer <= write_gray_pointer_next;
	   qr <= read_gray_pointer;
	   read_pointer_sync <= qr;
	   for(i=0;i<=8;i=i+1) begin
	      fifo_data_current[i] <= fifo_data_next[i];
	   end
	end // else: !if(rst_n == 1'b0)
     end // always @ (posedge clk or negedge rst_n)
	 
	 
	  // sequential logic, active-low asynch reset
   always @(posedge read_clk or negedge read_rst_n)
     begin
	if (read_rst_n == 1'b0) begin
	   // reset all registers to default values
	   read_pointer  <= 9'b000000000;
	   data_out      <= 9'h000;
	   empty         <= 1'b1;
	   read_gray_pointer <= 9'b000000000;
	   qw <= 9'b000000000;
	   write_pointer_sync <= 9'b000000000;
	end else begin
	   read_pointer  <= read_pointer_next;
	   data_out      <= data_out_next;
	   empty         <= empty_next;
	   read_gray_pointer <= read_gray_pointer_next;
	   qw <= write_gray_pointer;
	   write_pointer_sync <= qw;
	end // else: !if(rst_n == 1'b0)
     end // always @ (posedge clk or negedge rst_n)



/////////////////////////////////////////
   // combinational logic
   always @(*)
     begin
	// assign default values to all comb variables
	for(j=0;j<=8;j=j+1) begin
	      fifo_data_next[j] = fifo_data_current[j];
	end
	write_pointer_next = write_pointer;
	read_pointer_next  = read_pointer;
        data_out_next      = data_out;

	// fifo write logic
	if ( full == 1'b0 ) begin
	   fifo_data_next[write_pointer[2:0]] = data_in;
	   write_pointer_next                 = write_pointer + 1'b1;
	end

	// fifo read logic
	if ( empty == 1'b0 ) begin
	   data_out_next    = fifo_data_current[read_pointer[2:0]];
	   read_pointer_next = read_pointer + 1'b1;
	end
	  
	

	
     
	end // always @ (*)
	
		assign write_gray_pointer_next = (write_pointer_next >> 1) ^ write_pointer_next;
	assign read_gray_pointer_next = (read_pointer_next >> 1) ^ read_pointer_next;

assign 	empty_next = (write_pointer_sync == read_gray_pointer_next);
assign  full_next = (write_gray_pointer_next == {~read_pointer_sync[8:7],read_pointer_sync[6:0]} );
	 
	 


  

endmodule
	
        
	
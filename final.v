module final_modulator(
		input wire SCLK,
		input wire data_clk,
		input wire sym_clk,
		input wire MOSI,
		input wire CSN,
		input wire rst_n,
		input wire data_in,
		output reg	  MISO,
		output reg	  MISO_enable

    );

wire enable_sync;
wire [7:0] reg_read_data;
wire MISO_assign;
wire MISO_enable_assign;
wire [9:0] reg_write_addr_data;

wire [3:0] I_data;
wire [3:0] Q_data;

//assign MISO_assign = MISO;
//assign MISO_enable_assign = MISO_enable;
always @(negedge SCLK)
begin
MISO <= MISO_assign;
MISO_enable <= MISO_enable_assign;
//$display("here %b",MISO_assign);
end

wire  [7:0] reg_data;
wire  [7:0] IQ_data_out;

wire [8:0]  reg_addr;

reg [3:0] I_data_assign;
reg [3:0] Q_data_assign;

always @(*)
begin
I_data_assign = IQ_data_out[7:4];
Q_data_assign = IQ_data_out[3:0];
end




spi_interface u_spi(
             .SCLK(SCLK),
		     .MOSI(MOSI),
		     .CSN(CSN),
		     .rst_n(rst_n),
		     .reg_read_data(reg_read_data),
		     .MISO(MISO_assign),
		     .MISO_enable(MISO_enable_assign),
		     .reg_addr(reg_write_addr_data),
		     .enable(enable),
		     .mapping(map),
			 .read_empty(read_data_cdc_empty)
			 );
			 
		

baseband u_mapping(
             .clk(data_clk),
		     .data_in(data_in),
		     .rst_n(rst_n_data),
		     .I_data(I_data),
		     .Q_data(Q_data),
		     .enable(enable),
			 .mapping(map)
);



symbol_storage u_reg(
			   .sym_clk(sym_clk),
			   .I_data(I_data_assign),
			   .Q_data(Q_data_assign),
			   .rst_n_sym(rst_n_sym),
			   .IQ_empty(IQ_empty),
			   .SPI_addr_empty(SPI_addr_empty),
			   .reg_addr(reg_addr),
			   .reg_data(reg_data)
);

fifo u_IQ_cdc(
        .write_clk(data_clk),
	    .write_rst_n(rst_n_data),
		.read_clk(sym_clk),
	    .read_rst_n(rst_n_sym),
	    .data_in({I_data,Q_data}),
	    .data_out(IQ_data_out),
	    .full(read_IQ_full),
	    .empty(IQ_empty)
);

fifo_9bit u_read_addr_cdc(
        .write_clk(SCLK),
	    .write_rst_n(rst_n_SPI),
		.read_clk(data_clk),
	    .read_rst_n(rst_n_data),
	    .data_in(reg_write_addr_data),
	    .data_out(reg_addr),
	    .full(read_addr_cdc_full),
	    .empty(SPI_addr_empty)
		);

fifo u_read_data_cdc(
        .write_clk(sym_clk),
	    .write_rst_n(rst_n_sym),
		.read_clk(SCLK),
	    .read_rst_n(rst_n_SPI),
	    .data_in(reg_data),
	    .data_out(reg_read_data),
	    .full(read_data_cdc_full),
	    .empty(read_data_cdc_empty)
		);

sync_fifo_ff_syn reset_sync_SPI(.clk(SCLK),
	    .rst_n(rst_n),
	    .data_in(rst_n),
	    .data_out(rst_n_SPI));
		
sync_fifo_ff_syn reset_sync_data(.clk(data_clk),
	    .rst_n(rst_n),
	    .data_in(rst_n_SPI & rst_n),
	    .data_out(rst_n_data));
		
sync_fifo_ff_syn reset_sync_sym(.clk(sym_clk),
	    .rst_n(rst_n),
	    .data_in(rst_n_data & rst_n),
	    .data_out(rst_n_sym));
		
sync_fifo_ff_syn enable_ff(.clk(data_clk),
	    .rst_n(rst_n),
	    .data_in(enable),
	    .data_out(enable_sync));
		
sync_fifo_ff_syn mapping_ff(.clk(SCLK),
	    .rst_n(rst_n),
	    .data_in(mapping),
	    .data_out(mapping_sync));
	    
	    	 

endmodule


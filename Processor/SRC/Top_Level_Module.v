module Top_Level_Module(input clk, output Tx_ready);
								
wire [7:0] IRAM_address;
wire [15:0] IRAM_to_processor;
wire [15:0] DRAM_address;
wire [7:0] DRAM_write_data;
wire write_DRAM;
wire [15:0] DRAM_address_processor;
wire [7:0] DRAM_to_processor;
wire start_Tx;
//wire [7:0] DRAM_read_data;
//wire clk_out;
//wire [7:0] DRAM_data_processor;
//wire write_DRAM_processor;
//wire enable_processor;
//wire [7:0] DRAM_to_transmitter;
//wire [15:0] DRAM_address_receiver;
//wire [7:0] DRAM_data_receiver;
//wire select_DRAM_write_data;
//wire write_DRAM_receiver;
//wire select_DRAM_write_enable;
//wire [5:0] state_7seg;
//wire [7:0] AC_LED;
//wire Rx_done;
//assign Rx_indicator = Rx_done;
//assign address_LED = DRAM_address_receiver[15:8];
//assign data_LED = DRAM_read_data;
//assign start_Tx_indicator = start_Tx;
								
IRAM IRAM(.address(IRAM_address),
		.clock(clk),
		.q(IRAM_to_processor));
		
DRAM DRAM(.address(DRAM_address),
		.clock(clk),
		.data(DRAM_write_data),
		.wren(write_DRAM),
		.q(DRAM_to_processor));
		
Processor Processor(.IRAM_address(IRAM_address),
						  .IRAM_data(IRAM_to_processor),
						  .clock(clk),
						  .DRAM_address_processor(DRAM_address),
						  .DRAM_output_data(DRAM_write_data),
						  .DRAM_input_data(DRAM_to_processor),
						  .write_DRAM(write_DRAM),
						  .start_Tx(Tx_ready)
						  //.enable_processor(Rx_done)						  
						  //.LED(state_7seg),
						  //.AC_LED(AC_LED)
						  );
						  

//DRAM_write_data_mux DRAM_write_data_mux(.outputmux(DRAM_write_data),
													 //.inputmux1(DRAM_data_processor),
													 //.inputmux2(DRAM_data_receiver),
													 //.select(Rx_done));
													 
//DRAM_write_enable_mux DRAM_write_enable_mux(.outputmux(write_DRAM),
													 //.inputmux1(write_DRAM_processor),
													 //.inputmux2(write_DRAM_receiver),
													 //.select(Rx_done));
													 
//DRAM_read_data_splitter DRAM_read_data_splitter(.output1(DRAM_to_processor),
													  //.output2(DRAM_to_transmitter),
													  //.inputsplitter(DRAM_read_data));
													
//DRAM_address_mux DRAM_address_mux(.outputmux(DRAM_address),
											//.inputmux1(DRAM_address_processor),
											//.inputmux2(DRAM_address_receiver),
											//.Rx_done(Rx_done),
											//.start_Tx(start_Tx));
											
//clock_selector clock_selector(.clk_in(clk_in),
										//.clock_select(0),
										//.clk_out(clk_out));
											
//UART_Transceiver UART_Transceiver(.data_in(DRAM_to_transmitter),
											 //.start_transmit(),
											 //.clk(clk_in),
											 //.Tx(Tx),
											 //.RX(Rx));
											 
											 
//state_to_7seg state_to_7seg(.bin(state_7seg),
									 //.dout1(dout1),
									 //.dout2(dout2));	

//AC_to_7seg AC_to_7seg(.din(AC_LED),
					   //.dout2(AC_2),
						//.dout1(AC_1),
						//.dout0(AC_0));									 
													  
endmodule
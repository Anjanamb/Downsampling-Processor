module statemachine(input [15:0] instruction,
					input clock,
					output reg load_instruction,
					output reg [3:0] ALU_control,
					output reg [3:0] select_source,
					output reg [2:0] select_destination,
					output reg [1:0] IDC_control,
					output reg [1:0] MDR_control,
					output reg [1:0] MAR_control,
					output reg [1:0] PC_control,
					output reg write_DRAM,
					output reg start_Tx
					//input enable_processor,
					//output wire [5:0] LED
					);
		
							
reg [7:0] state;
reg [3:0] source_register;
reg [2:0] destination_register;
reg [3:0] opcode;
//assign LED = state[5:0];

initial
begin
	state = 8'b00010000; //start
end

always@(instruction)
begin
	opcode = instruction[15:12];
	source_register = instruction[11:8];
	destination_register = instruction[2:0];
end

always@(negedge clock)
begin
	case(state)
		8'b00010000: //start (16)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1							
			end
			
		8'b00010001: //fetch1 (17)
			begin
				load_instruction <= 1; //read IRAM
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010010; //fetch2
			end
			
		8'b00010010: //fetch2 (18)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b01; //increment PC
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= {4'b0000, opcode}; //loaded instruction
			end
			
		8'b00000101: //add1 (5)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= source_register; //copy register to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010011; //add2
			end
		
		8'b00010011: //add2 (19)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0001; // AC + Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00000110: //sub1 (6)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= source_register; //copy register to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010100; //add2
			end
		
		8'b00010100: //sub2 (20)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0010; // AC - Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00000111: //mul1 (7)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b1011;  //copy constant(from instruction) to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010101; //mul2
			end
			
		8'b00010101: //mul2 (13)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0011; // AC * Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00001000: //div1 (8)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b1011; //copy constant(from instruction) to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010110; //div2
			end
			
		8'b00010110: //div2 (22)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0100; // AC / Bus
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00000011: //copy (3)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= source_register; //copy register to the Bus
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010111; //copy2
			end
			
		8'b00010111: //copy2 (23)
			begin
				load_instruction <= 0;
				if (destination_register == 3'b001) //If the destination is AC
					ALU_control <= 4'b0101;         //Set Bus value to AC
				else
					ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				if (destination_register == 3'b001) //If the destination is AC
					select_destination <= 3'b000;
				else
					select_destination <= destination_register; //Assignthe destination to Bus
				if (destination_register == 3'b101) //If the destination is MDR
					MDR_control <= 2'b10;           //Set Bus value to MDR
				else
					MDR_control <= 2'b00;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00001100: //loadk (12)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0110; //copy constant(from instruction) to the AC
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00000100: //jump (4)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b10; //copy Address(from instruction) to the PC
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00001010: //inc (10)
			begin
				load_instruction <= 0;
				if (source_register == 4'b0001) //If the source register is AC
					ALU_control <= 4'b0111;     //increment AC by 1
				else
					ALU_control <= 4'b0000;
				if (source_register == 4'b0001) //If the source register is AC
					IDC_control <= 2'b00;
				else	
					IDC_control <= 2'b01;       //increment done via IDC controller
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00001011: //dec (11)
			begin
				load_instruction <= 0;
				if (source_register == 4'b0001) //If the source register is AC
					ALU_control <= 4'b1000;     //decrement AC by 1
				else
					ALU_control <= 4'b0000;     
				if (source_register == 4'b0001) //If the source register is AC
					IDC_control <= 2'b00;
				else	
					IDC_control <= 2'b10;       //deccrement done via IDC controller
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00001001: //clr (9)
			begin
				load_instruction <= 0;
				if (source_register == 4'b0001) //If the source register is AC
					ALU_control <= 4'b1001;     // AC = 0
				else
					ALU_control <= 4'b0000;
				if (source_register == 4'b0001) //If the source register is AC
					IDC_control <= 2'b00;
				else	
					IDC_control <= 2'b11;       //clear done via IDC controller
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00000001: //load1 (1)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				if (source_register == 4'b0001)      //If the source register is AC 
					MAR_control <= 2'b01;            // MAR <= AC
				else if (source_register == 4'b0010) //If the source register is RR
					MAR_control <= 2'b10;            // MAR <= {RRR,CRR}
				else
					MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00011000; //load2
			end
			
		8'b00011000: //load2 (24)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b01; // MDR <= DRAM
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
			
		8'b00000010: //store1 (2)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				if (source_register == 4'b0001)      //If the source register is AC 
					MAR_control <= 2'b01;            // MAR <= AC
				else if (source_register == 4'b0010) //If the source register is WR 	
					MAR_control <= 2'b11;            // MAR <= {RWR,CWR}
				else
					MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;
				state <= 8'b00011001; //store2
			end
			
		8'b00011001: //store2 (25)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 1; // DRAM <= MDR
				start_Tx <= 0;
				state <= 8'b00010001; //fetch1
			end
		
		8'b00000000: //nop (0)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 0;       
				state <= 8'b00010001; //fetch1
			end
			
		8'b00001111: //end (15)
			begin
				load_instruction <= 0;
				ALU_control <= 4'b0000;
				select_source <= 4'b0000;
				select_destination <= 3'b000;
				PC_control <= 2'b00;
				IDC_control <= 2'b00;
				MDR_control <= 2'b00;
				MAR_control <= 2'b00;
				write_DRAM <= 0;
				start_Tx <= 1;        //indicate that the processing is done
				state <= 8'b00001111; //end
			end
			
		default: state <= 8'b00010000; // start 
      endcase
	end
endmodule
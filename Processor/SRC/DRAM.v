module DRAM (
input wire [15:0] address,
input clock,
input wire [7:0] data,
input wren,
output reg [7:0] q);
reg [7:0] DRAM[255:0];

initial begin
    DRAM[0] = 8'b10100001;
DRAM[1] = 8'b10100001;
DRAM[2] = 8'b10011101;
DRAM[3] = 8'b10100001;
DRAM[4] = 8'b10100001;
DRAM[5] = 8'b10011111;
DRAM[6] = 8'b10100011;
DRAM[7] = 8'b10011011;
DRAM[8] = 8'b10011011;
DRAM[9] = 8'b10100001;
DRAM[10] = 8'b10011011;
DRAM[11] = 8'b10011101;
DRAM[12] = 8'b10011101;
DRAM[13] = 8'b10010111;
DRAM[14] = 8'b10011001;
DRAM[15] = 8'b10011011;
DRAM[16] = 8'b10011101;
DRAM[17] = 8'b10011111;
DRAM[18] = 8'b10100111;
DRAM[19] = 8'b10100101;
DRAM[20] = 8'b10100101;
DRAM[21] = 8'b10101011;
DRAM[22] = 8'b10101111;
DRAM[23] = 8'b10101001;
DRAM[24] = 8'b10101011;
DRAM[25] = 8'b10101111;
DRAM[26] = 8'b10100111;
DRAM[27] = 8'b10100001;
DRAM[28] = 8'b10010011;
DRAM[29] = 8'b10001101;
DRAM[30] = 8'b10001111;
DRAM[31] = 8'b10001001;
end

always @ (negedge clock)
begin
    if(wren == 0)
        q <= DRAM[address];
    else
        DRAM[address] <= data;
end
endmodule
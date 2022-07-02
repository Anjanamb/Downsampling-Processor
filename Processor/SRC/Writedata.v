module Writedata(input wren,
                 input wire [7:0] data,
                 input clock,             
                 input wire [7:0] IRAM_address
                 );

//reg [7:0] Inputdata;
integer file;
reg [3:0] Check;
//assign data=Inputdata;
//initial begin    
    //file = $fopen("output.txt","w");    
//end


initial begin 
Check=0;
end

always@(negedge clock)
begin  
    case (wren)
        1:
        begin
          Check=Check+1;
          file = $fopen("output.txt","w");
		  $fwrite(file,data);
		  //initial
		  $fclose(file);
		end
	endcase
end



//initial
//$fclose(file);

endmodule

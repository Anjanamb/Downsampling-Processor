module clock();
    reg clk;
    wire Output_ready;
    Top_Level_Module clock(.clk(clk),.Tx_ready(Output_ready));
    

    initial 
        begin
        clk = 0;
        end
    always 
    begin
    #40 clk = ~clk;    
    end
endmodule
`timescale 1ns / 1ns

module divider#(parameter num = 10)(
    input iclk,
    input rst,
    output reg oclk
    );
    integer i = 0;
    always @ (posedge iclk or posedge rst) begin
        if(rst == 1) begin
            oclk <= 0; i <= 0; end
        else begin
            if(i == num - 1) begin
                oclk <= ~oclk; 
                i <= 0; end
            else begin
                i <= i + 1; end
        end
    end
endmodule
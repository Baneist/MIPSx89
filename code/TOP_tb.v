`timescale 10ps / 1ps

module top_tb();
    reg clk_in, rst, en_clk;
    reg [1:0] choose;
    wire [7:0] o_seg, o_sel;
    initial begin 
        clk_in = 1; 
        choose = 2'b0;
        en_clk = 1; 
        rst = 1;
        #2 rst = 0;
    end

    top top_0(
        .clk_in(clk_in),       
        .reset(rst),       
        .en_clk(en_clk),       
        .choose(choose),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );
    always begin 
        #1 clk_in = ~clk_in;
    end 
    wire sclk = top_0.Core_0.clk;
    wire srst = top_0.Core_0.rst;
    wire [31:0] pc = top_0.Core_0.cpu_0.pc;
    wire [31:0] inst = top_0.Core_0.inst;
    wire [31:0] ret = top_0.Core_0.ret;
    
endmodule
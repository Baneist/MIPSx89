`timescale 1ns / 1ps

module top(
    input clk_in,       
    input reset,       
    input en_clk,       
    input [1:0] choose,
    output [7:0] o_seg,
    output [7:0] o_sel
);    
    wire cclk, sclk;
    wire [31:0] inst, pc, ret;
    
    divider#(2) s_div_0 (clk_in, reset, sclk);
    divider#(100000) c_div_0 (clk_in, reset, cclk);
    wire [31:0] inpt = (choose[1]) ? inst :((choose[0]) ? pc : ret);
    seg7 seg7_0 (sclk, reset, inpt, o_seg, o_sel);
    wire rclk = en_clk ? sclk : cclk;
    Core Core_0(rclk, reset, pc, inst, ret);

endmodule

module Core(
	input clk,
	input rst,
    output [31:0] pc,
    output [31:0] inst,
    output [31:0] ret
);
    wire rom_ce;
    wire mem_we_i;
    wire[`RegBus] mem_addr_i;
    wire[`RegBus] mem_data_i;
    wire[`RegBus] mem_data_o;
    wire[3:0] mem_sel_i; 
    wire mem_ce_i;   
    wire[5:0] int;
    wire timer_int;
    
    assign int = {5'b00000, timer_int};

    cpu cpu_0(
        .clk(clk),
        .rst(rst),
        .rom_addr_o(pc),
        .rom_data_i(inst),
        .rom_ce_o(rom_ce),
        .int_i(int),
        .ram_we_o(mem_we_i),
        .ram_addr_o(mem_addr_i),
        .ram_sel_o(mem_sel_i),
        .ram_data_o(mem_data_i),
        .ram_data_i(mem_data_o),
        .ram_ce_o(mem_ce_i),
        .timer_int_o(timer_int)
    );

    wire [31:0] imem_pc = pc - `TextBegin;
    dist_mem_gen_0 imem_0(imem_pc[12:2], inst);

    dmem dmem_0(
        .clk(clk),
        .ce(mem_ce_i),
        .we(mem_we_i),
        .addr_in(mem_addr_i),
        .sel(mem_sel_i),
        .data_i(mem_data_i),
        .data_o(mem_data_o),
        .ret(ret)
    );
endmodule
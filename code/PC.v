`timescale 1ns / 1ps

module pc_reg(
	input wire clk,
	input wire rst,
	//���Կ���ģ�����Ϣ
	input wire[5:0]               stall,
	input wire                    flush,
	input wire[`RegBus]           new_pc,
	//��������׶ε���Ϣ
	input wire                    branch_flag_i,
	input wire[`RegBus]           branch_target_address_i,
	//���
	output reg[`InstAddrBus] 	  pc,
	output reg               	  ce
);
	initial pc <= `TextBegin;
	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= `TextBegin;
		end else if (ce != `ChipDisable) begin
			if(flush == 1) begin
				pc <= new_pc;
			end else if(stall[0] == `NoStop) begin
				if(branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end else begin
		  		pc <= pc + 4;
		  	end
			end
		end
	end

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;
		end else begin
			ce <= `ChipEnable;
		end
	end

endmodule
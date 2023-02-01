`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2022 01:39:08 PM
// Design Name: 
// Module Name: demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module demo(input   logic 	 clk,     
         input   logic       clk_push, reset_push,       
	     output  logic[6:0]  seg,
	     output  logic[3:0]  an,
	     output  logic       dp,
	     output  logic       memwrite);
	     
	     logic         clear;
	     logic         db_clk, db_reset;
	     logic [31:0]  writedata;
	     logic [31:0]  dataadr;
	     logic [31:0]  pc;
	     logic [31:0]  instr;
	     logic [31:0]  readdata;
	     
	     top TOP(db_clk, db_reset, writedata, dataadr, pc, instr, readdata, memwrite);
	     
	     pulse_controller clockdebouncer(clk, clk_push, clear, db_clk);
	     pulse_controller resetdebouncer(clk, reset_push, clear, db_reset);
	     
	     display_controller ssd(clk, pc[7:4], pc[3:0], dataadr[7:4], dataadr[3:0],
	                               seg, dp, an);
endmodule

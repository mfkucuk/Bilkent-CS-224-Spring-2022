`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 01:02:15 PM
// Design Name: 
// Module Name: imem
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

// External instruction memory used by MIPS single-cycle
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output


module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//		address		instruction
//		-------		-----------
		8'h00: instr = 32'h20020005;  	
		8'h04: instr = 32'h00a2182a;  
		8'h08: instr = 32'h00032020;  	
		8'h0c: instr = 32'h80441803;  	
		8'h10: instr = 32'h0062382a;
		8'h14: instr = 32'h20630001;
		8'h18: instr = 32'h1087fffd;
		8'h1c: instr = 32'h00833024;
		8'h20: instr = 32'h00833025;
		8'h24: instr = 32'h20070038;
		8'h28: instr = 32'hac670044;
		8'h2c: instr = 32'h04660044;
		8'h30: instr = 32'h00000000;
		8'h34: instr = 32'h00000000;
		8'h38: instr = 32'h00c22820;
	     default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule

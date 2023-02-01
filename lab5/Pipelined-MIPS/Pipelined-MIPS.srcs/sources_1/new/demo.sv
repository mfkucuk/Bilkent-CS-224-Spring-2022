`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2022 06:37:14 PM
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


module demo(
    input clk,
    input clk_push,
    input reset_push,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output memwrite, memtoreg, alusrc, branch, regdst, regwrite
    );
    
    logic [31:0] PC, PCF, instrF, instrD, ALUOutE, WriteDataE;
    logic [2:0]  alucontrol;
    logic [1:0]  ForwardAE, ForwardBE, ForwardCE;
    logic        PcSrcD, ForwardAD, ForwardBD;
    logic        clk_db, reset_db;
    
    top_mips mips(clk_db, reset_db, instrF, PC, PCF, PcSrcD, memwrite, memtoreg, alusrc, branch, regdst, regwrite,
                alucontrol, instrD, ALUOutE, WriteDataE, ForwardAE, ForwardBE, ForwardCE, ForwardAD, ForwardBD);
                
    pulse_controller clock_debouncer(clk, clk_push, 0, clk_db);
    pulse_controller reset_debouncer(clk, reset_push, 0, reset_db);
    
    display_controller ssd(clk, PCF[7:4], PCF[3:0], ALUOutE[7:4], ALUOutE[3:0], seg, dp, an);
endmodule

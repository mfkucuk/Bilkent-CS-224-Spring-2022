`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2022 09:17:00 PM
// Design Name: 
// Module Name: mips_tb
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


module mips_tb(
    );
    
    logic [31:0] PC, PCF, instrD, instrF, ALUOutE, WriteDataE;
    logic [2:0] alucontrol;
    logic [1:0] ForwardAE, ForwardBE;
    logic clk, reset, PcSrcD, MemWriteD, MemtoRegD, ALUSrcD, BranchD, RegDstD, RegWriteD, ForwardAD, ForwardBD;
    
    top_mips dut(clk, reset, instrF, PC, PCF, PcSrcD, MemWriteD, MemtoRegD, ALUSrcD, BranchD, RegDstD, RegWriteD,
                alucontrol, instrD, ALUOutE, WriteDataE, ForwardAE, ForwardBE, ForwardAD, ForwardBD);
                
    always begin
        clk = 0; #10;
        clk = 1; #10;
    end
    
    initial begin
        reset = 1; #10;
        reset = 0; #10;
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 02:00:51 PM
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
    
    logic       clk, reset;
    logic[31:0] writedata, dataadr;
    logic[31:0] pc, instr, readdata;
    logic       memwrite;
    
    top dut(clk, reset, writedata, dataadr, pc, instr, readdata, memwrite);
    
    always begin
        clk = 1; #10;
        clk = 0; #10;
    end
    
    initial begin
        reset = 1; #20;
        reset = 0; #10;
    end
endmodule

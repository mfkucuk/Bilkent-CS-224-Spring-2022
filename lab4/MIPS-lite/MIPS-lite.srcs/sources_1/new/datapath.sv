`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 01:02:15 PM
// Design Name: 
// Module Name: datapath
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


module datapath (input  logic clk, reset, memtoreg, pcsrc, alusrc, regdst,
                 input  logic regwrite, jump, memjump, pcreg, addreg, 
		 input  logic[2:0]  alucontrol, 
                 output logic zero, 
		 output logic[31:0] pc, 
	         input  logic[31:0] instr,
                 output logic[31:0] aluout, writedata, 
	         input  logic[31:0] readdata);

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnext2, pcnextbr, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh, srca, srcb, rd, result, wd;
  logic [31:0] addresult, addedaluout;
 
  // next PC logic
  flopr #(32) pcregg(clk, reset, pcnext2, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnext);
  mux2 #(32)  pcmux2(pcnext, result, memjump, pcnext2);

// register file logic
   mux2 #(32)  rfmux(result, pcplus4, pcreg, wd);
   regfile     rf (clk, regwrite, instr[25:21], instr[20:16], instr[15:11], writereg,
                   wd, srca, writedata, rd);

   mux2 #(5)    wrmux (instr[20:16], instr[15:11], regdst, writereg);
   mux2 #(32)  resmux (addedaluout, readdata, memtoreg, result);
   signext         se (instr[15:0], signimm);
   
   adder        addrd(aluout, rd, addresult);
   mux2 #(32)   rdmux(aluout, addresult, addreg, addedaluout);

  // ALU logic
   mux2 #(32)  srcbmux (writedata, signimm, alusrc, srcb);
   alu         alu (srca, srcb, alucontrol, aluout, zero);

endmodule

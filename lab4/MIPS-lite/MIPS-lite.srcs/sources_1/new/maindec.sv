`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2022 01:02:15 PM
// Design Name: 
// Module Name: maindec
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

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite, jump,
	              output logic memjump, pcreg, addreg,
	              output logic[1:0] aluop );
   logic [11:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop, jump, memjump, pcreg, addreg} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 12'b110000100000; // R-type
      6'b100000: controls <= 12'b110000100001; // SRACC
      6'b100011: controls <= 12'b101001000000; // LW
      6'b101011: controls <= 12'b001010000000; // SW
      6'b000100: controls <= 12'b000100010000; // BEQ
      6'b001000: controls <= 12'b101000000000; // ADDI
      6'b000010: controls <= 12'b000000001000; // J
      6'b000001: controls <= 12'b101001000110; // JALM
      default:   controls <= 12'bxxxxxxxxxxxx; // illegal op
    endcase
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2022 06:35:06 PM
// Design Name: 
// Module Name: top_mips
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


// Define pipes that exist in the PipelinedDatapath. 
// The pipe between Writeback (W) and Fetch (F), as well as Fetch (F) and Decode (D) is given to you.
// Create the rest of the pipes where inputs follow the naming conventions in the book.


module PipeFtoD(input logic[31:0] instr, PcPlus4F,
                input logic EN, clear, clk, reset,
                output logic[31:0] instrD, PcPlus4D);

                always_ff @(posedge clk, posedge reset)
                  if(reset)
                        begin
                        instrD <= 0;
                        PcPlus4D <= 0;
                        end
                    else if(EN)
                        begin
                          if(clear) // Can clear only if the pipe is enabled, that is, if it is not stalling.
                            begin
                        	   instrD <= 0;
                        	   PcPlus4D <= 0;
                            end
                          else
                            begin
                        		instrD<=instr;
                        		PcPlus4D<=PcPlus4F;
                            end
                        end
                
endmodule

// Similarly, the pipe between Writeback (W) and Fetch (F) is given as follows.

module PipeWtoF(input logic[31:0] PC,
                input logic EN, clk, reset,		// ~StallF will be connected as this EN
                output logic[31:0] PCF);

                always_ff @(posedge clk, posedge reset)
                    if(reset)
                        PCF <= 0;
                    else if(EN)
                        PCF <= PC;
endmodule

module PipeDtoE(input logic[31:0] RD1, RD2, RD3, SignImmD,
                input logic[4:0] RsD, RtD, RdD,
                input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD,
                input logic[2:0] ALUControlD,
                input logic clear, clk, reset,
                output logic[31:0] RsData, RtData, RdData, SignImmE,
                output logic[4:0] RsE, RtE, RdE, 
                output logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE,
                output logic[2:0] ALUControlE);

        always_ff @(posedge clk, posedge reset)
          if(reset || clear)
                begin
                // Control signals
                RegWriteE <= 0;
                MemtoRegE <= 0;
                MemWriteE <= 0;
                ALUControlE <= 0;
                ALUSrcE <= 0;
                RegDstE <= 0;
                
                // Data
                RsData <= 0;
                RtData <= 0;
                RdData <= 0;
                RsE <= 0;
                RtE <= 0;
                RdE <= 0;
                SignImmE <= 0;
                end
            else
                begin
                // Control signals
                RegWriteE <= RegWriteD;
                MemtoRegE <= MemtoRegD;
                MemWriteE <= MemWriteD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                RegDstE <= RegDstD;
                
                // Data
                RsData <= RD1;
                RtData <= RD2;
                RdData <= RD3;
                RsE <= RsD;
                RtE <= RtD;
                RdE <= RdD;
                SignImmE <= SignImmD;
                end

endmodule

module PipeEtoM(input logic[31:0] ALUOutE, WriteDataE,
                input logic[4:0]  WriteRegE,
                input logic       RegWriteE, MemtoRegE, MemWriteE,
                input logic       clk, reset,
                output logic[31:0] ALUOutM, WriteDataM,
                output logic[4:0] WriteRegM,
                output logic      RegWriteM, MemtoRegM, MemWriteM);

        always_ff @(posedge clk, posedge reset) begin
            if (reset) begin
                // Control Signals
                RegWriteM <= 0;
                MemtoRegM <= 0;
                MemWriteM <= 0;
                
                // Data
                ALUOutM <= 0;
                WriteDataM <= 0;
                WriteRegM <= 0;
            end
            else begin
                // Control signals
                RegWriteM <= RegWriteE;
                MemtoRegM <= MemtoRegE;
                MemWriteM <= MemWriteE;
                
                // Data
                ALUOutM <= ALUOutE;
                WriteDataM <= WriteDataE;
                WriteRegM <= WriteRegE;
            end
        end
endmodule

module PipeMtoW(input logic[31:0] ReadDataM, ALUOutM,
                input logic[4:0]  WriteRegM,
                input logic       RegWriteM, MemtoRegM,
                input logic       clk, reset,
                output logic[31:0] ReadDataW, ALUOutW,
                output logic[4:0] WriteRegW,
                output logic      RegWriteW, MemtoRegW);
        
        always_ff @(posedge clk, posedge reset) begin
            if (reset) begin
                // Control signals
                RegWriteW <= 0;
                MemtoRegW <= 0;
                
                // Data
                ReadDataW <= 0;
                ALUOutW <= 0;
                WriteRegW <= 0;
            end
            else begin
                // Control Signals
                RegWriteW <= RegWriteM;
                MemtoRegW <= MemtoRegM;
                
                // Data
                ReadDataW <= ReadDataM;
                ALUOutW <= ALUOutM;
                WriteRegW <= WriteRegM;
            end
        end
endmodule



// *******************************************************************************
// End of the individual pipe definitions.
// ******************************************************************************

// *******************************************************************************
// Below is the definition of the datapath.
// The signature of the module is given. The datapath will include (not limited to) the following items:
//  (1) Adder that adds 4 to PC
//  (2) Shifter that shifts SignImmD to left by 2
//  (3) Sign extender and Register file
//  (4) PipeFtoD
//  (5) PipeDtoE and ALU
//  (5) Adder for PcBranchD
//  (6) PipeEtoM and Data Memory
//  (7) PipeMtoW
//  (8) Many muxes
//  (9) Hazard unit
//  ...?
// *******************************************************************************

module datapath (input  logic clk, reset,
                input  logic[2:0]  ALUControlD,
                input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
                 output logic [31:0] instrF,		
                 output logic [31:0] instrD, PC, PCF,
                output logic PcSrcD,                 
                output logic [31:0] ALUOutE, WriteDataE,
                output logic [1:0] ForwardAE, ForwardBE, ForwardCE,
                 output logic ForwardAD, ForwardBD); // Add or remove input-outputs if necessary

	// ********************************************************************
	// Here, define the wires that are needed inside this pipelined datapath module
	// ********************************************************************
  
  	//* We have defined a few wires for you
    logic [31:0] PcSrcA, PcSrcB, PcBranchD, PcPlus4F;	
  	logic StallF;
  
	//* You should define others down below
	logic [31:0] PcPlus4D;
	logic [4:0] RsD, RtD, RdD, RsE, RtE, RdE;
    logic [31:0] SignImmD, SignImmE, SignImmDtimes4;
	logic RegWriteE, MemtoRegE, MemWriteE, AluSrcE, RegDstE;
	logic[2:0] ALUControlE;
	logic RegWriteM, MemtoRegM, MemWriteM;
	logic RegWriteW, MemtoRegW;
	logic [31:0] RD1, RD2, RD3;
	logic [31:0] rsData, rtData, rdData;
	logic [31:0] ALUOutM, ALUOutW;
	logic [31:0] RsResult, RtResult, SrcAE, SrcBE, SrcCE;
	logic [31:0] WriteDataM, ReadDataM, ReadDataW;
	logic EqualD;
	logic zero;
	logic [4:0] WriteRegE, WriteRegM, WriteRegW;
	logic [31:0] ResultW;
	
	// Hazard Unit
	logic StallD;
	logic FlushE;
  
  
	// ********************************************************************
	// Instantiate the required modules below in the order of the datapath flow.
	// ********************************************************************

  
  	//* We have provided you with some part of the datapath
    
  	// Instantiate PipeWtoF
  	PipeWtoF pipe1(PC,
                ~StallF, clk, reset,
                PCF);
  
  	// Do some operations
    assign PcPlus4F = PCF + 4;
    assign PcSrcB = PcBranchD;
	assign PcSrcA = PcPlus4F;
  	mux2 #(32) pc_mux(PcSrcA, PcSrcB, PcSrcD, PC);

    imem im1(PCF[7:2], instrF);
    
  	// Instantiate PipeFtoD
  	PipeFtoD pipe2(instrF, PcPlus4F,
  	             ~StallD, PcSrcD, clk, reset,
  	             instrD, PcPlus4D);
  
  	// Do some operations
  	assign RsD = instrD[25:21];
  	assign RtD = instrD[20:16];
  	assign RdD = instrD[15:11];
  	
    regfile rf(clk, reset, RegWriteW, RsD, RtD, RdD, WriteRegW, ResultW, RD1, RD2, RD3);
    signext sext(instrD[15:0], SignImmD);
    sl2 times4(SignImmD, SignImmDtimes4);
    adder branchAdd(SignImmDtimes4, PcPlus4D, PcBranchD);
    
    mux2 #(32) rs_mux(RD1, ALUOutM, ForwardAD, RsResult);
    mux2 #(32) rt_mux(RD2, ALUOutM, ForwardBD, RtResult);
    
    assign EqualD = (RsResult == RtResult);
    assign PcSrcD = BranchD & EqualD;
  
  	// Instantiate PipeDtoE
  	PipeDtoE pipe3(RD1, RD2, RD3, SignImmD,
  	             RsD, RtD, RdD,
  	             RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD,
  	             ALUControlD,
  	             FlushE, clk, reset,
  	             rsData, rtData, rdData, SignImmE,
  	             RsE, RtE, RdE,
  	             RegWriteE, MemtoRegE, MemWriteE, AluSrcE, RegDstE,
  	             ALUControlE);
  
  	// Do some operations
  	mux2 #(5) regdst_mux(RtE, RdE, RegDstE, WriteRegE);
  	
  	mux4 #(32) srcae_mux(rsData, ResultW, ALUOutM, 32'h00000000, ForwardAE, SrcAE);
  	mux4 #(32) writedata_mux(rtData, ResultW, ALUOutM, 32'h00000000, ForwardBE, WriteDataE);
  	mux4 #(32) srcce_mux(rdData, ResultW, ALUOutM, 32'h00000000, ForwardCE, SrcCE);
  	
  	mux2 #(32) srcbe_mux(WriteDataE, SignImmE, AluSrcE, SrcBE);
  	
  	alu ALU(SrcAE, SrcBE, SrcCE, ALUControlE, ALUOutE, zero);
  	

  	// Instantiate PipeEtoM
  	PipeEtoM pipe4(ALUOutE, WriteDataE,
  	             WriteRegE,
  	             RegWriteE, MemtoRegE, MemWriteE,
  	             clk, reset,
  	             ALUOutM, WriteDataM,
  	             WriteRegM,
  	             RegWriteM, MemtoRegM, MemWriteM);
  
  	// Do some operations
  	dmem dm1(clk, MemWriteM, ALUOutM, WriteDataM, ReadDataM);

  	// Instantiate PipeMtoW
  	PipeMtoW pipe5(ReadDataM, ALUOutM,
  	             WriteRegM,
  	             RegWriteM, MemtoRegM,
  	             clk, reset,
  	             ReadDataW, ALUOutW,
  	             WriteRegW,
  	             RegWriteW, MemtoRegW);
  
  	// Do some operations
  	mux2 #(32) result_mux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
  	
  	// Instantiate hazard unit
  	HazardUnit hu(RegWriteW, BranchD,
  	             WriteRegW, WriteRegE,
  	             RegWriteM, MemtoRegM,
  	             WriteRegM,
  	             RegWriteE, MemtoRegE,
  	             RsE, RtE, RdE,
  	             RsD, RtD, RdD,
  	             ForwardAE, ForwardBE, ForwardCE,
  	             FlushE, StallD, StallF, ForwardAD, ForwardBD);

endmodule

module HazardUnit( input logic RegWriteW, BranchD,
                input logic [4:0] WriteRegW, WriteRegE,
                input logic RegWriteM,MemtoRegM,
                input logic [4:0] WriteRegM,
                input logic RegWriteE,MemtoRegE,
                input logic [4:0] rsE,rtE, rdE,
                input logic [4:0] rsD,rtD, rdD,
                output logic [1:0] ForwardAE,ForwardBE,ForwardCE,
                output logic FlushE,StallD,StallF,ForwardAD, ForwardBD
                 ); // Add or remove input-outputs if necessary
       
	// ********************************************************************
	// Here, write equations for the Hazard Logic.
	// If you have troubles, please study pages ~420-430 in your book.
	// ********************************************************************
	
	logic lwstall, branchstall;
	
    always_comb begin
	   if ((rsE != 0) & (rsE == WriteRegM) & RegWriteM)
	        ForwardAE = 2'b10;
       else
            if ((rsE != 0) & (rsE == WriteRegW) & RegWriteW) ForwardAE = 2'b01;
            else ForwardAE = 2'b00;
            
       if ((rtE != 0) & (rtE == WriteRegM) & RegWriteM)
	        ForwardBE = 2'b10;
       else
            if ((rtE != 0) & (rtE == WriteRegW) & RegWriteW) ForwardBE = 2'b01;
            else ForwardBE = 2'b00;
            
       if ((rdE != 0) & (rdE == WriteRegM) & RegWriteM)
	        ForwardCE = 2'b10;
       else
            if ((rdE != 0) & (rdE == WriteRegW) & RegWriteW) ForwardCE = 2'b01;
            else ForwardCE = 2'b00;
       
       ForwardAD = (rsD != 0) & (rsD == WriteRegM) & RegWriteM;
       ForwardBD = (rtD != 0) & (rtD == WriteRegM) & RegWriteM;
            
            
       branchstall = BranchD & RegWriteE & (WriteRegE == rsD | WriteRegE == rtD | WriteRegE === rdD)
                    | BranchD & MemtoRegM & (WriteRegM == rsD | WriteRegM == rtD | WriteRegE == rdD);     
       lwstall = ((rsD == rtE) | (rtD == rtE) | (rdD == rtE)) & MemtoRegE;
       
       FlushE = (lwstall | branchstall);
       StallF = (lwstall | branchstall);
       StallD = (lwstall | branchstall);
    end
  
endmodule


// You can add some more logic variables for testing purposes
// but you cannot remove existing variables as we need you to output 
// these values on the waveform for grading
module top_mips (input  logic clk, reset,
             output  logic[31:0]  instrF,
             output logic[31:0] PC, PCF,
             output logic PcSrcD,
             output logic MemWriteD, MemtoRegD, ALUSrcD, BranchD, RegDstD, RegWriteD,
             output logic [2:0]  alucontrol,
             output logic [31:0] instrD, 
             output logic [31:0] ALUOutE, WriteDataE,
             output logic [1:0] ForwardAE, ForwardBE, ForwardCE,
                 output logic ForwardAD, ForwardBD);


	// ********************************************************************
	// Below, instantiate a controller and a datapath with their new (if modified) signatures
	// and corresponding connections.
	// ********************************************************************
	
	datapath dp(clk, reset, alucontrol, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD, instrF, instrD, PC, PCF, PcSrcD,
	           ALUOutE, WriteDataE, ForwardAE, ForwardBE, ForwardCE, ForwardAD, ForwardBD);
	controller cont(instrD[31:26], instrD[5:0], MemtoRegD, MemWriteD, ALUSrcD, RegDstD, RegWriteD, alucontrol, BranchD);
  
endmodule


// External instruction memory used by MIPS
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output
// Modify it to test your own programs.

module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//
// 	***************************************************************************
//	Here, you can paste your own test cases that you prepared for the part 1-e.
//  An example test program is given below.        
//	***************************************************************************
//
//		address		instruction
//		-------		-----------
	   8'h00: instr = 32'h20080007;
       8'h04: instr = 32'h20090005;
       8'h08: instr = 32'h01095022;
       8'h0c: instr = 32'h01095820;
       8'h10: instr = 32'h016a4801;
       8'h14: instr = 32'h0109502a;
       8'h18: instr = 32'had6a0003;
       8'h1c: instr = 32'h8d280007;
       8'h20: instr = 32'h01685001;
       8'h24: instr = 32'had28000c;
       8'h28: instr = 32'h016a6024;
       8'h2c: instr = 32'h01885825;
       8'h30: instr = 32'h21080001;
       8'h34: instr = 32'h0188582a;
       8'h38: instr = 32'h1160fffd;
       8'h3c: instr = 32'h1108ffff;
       default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule


// 	***************************************************************************
//	Below are the modules that you shouldn't need to modify at all..
//	***************************************************************************

module controller(input  logic[5:0] op, funct,
                  output logic     memtoreg, memwrite,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic[2:0] alucontrol,
                  output logic branch);

   logic [1:0] aluop;

  maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, aluop);

   aludec  ad (funct, aluop, alucontrol);

endmodule

// External data memory used by MIPS single-cycle processor

module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite,
	              output logic[1:0] aluop );
  logic [7:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 8'b11000010; // R-type
      6'b100011: controls <= 8'b10100100; // LW
      6'b101011: controls <= 8'b00101000; // SW
      6'b000100: controls <= 8'b00010001; // BEQ
      6'b001000: controls <= 8'b10100000; // ADDI
      default:   controls <= 8'bxxxxxxxx; // illegal op
    endcase
endmodule

module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic[2:0] alucontrol);
  always_comb
    case(aluop)
      2'b00: alucontrol  = 3'b010;  // add  (for lw/sw/addi)
      2'b01: alucontrol  = 3'b110;  // sub   (for beq)
      default: case(funct)          // R-TYPE instructions
          6'b100000: alucontrol  = 3'b010; // ADD
          6'b100010: alucontrol  = 3'b110; // SUB
          6'b100100: alucontrol  = 3'b000; // AND
          6'b100101: alucontrol  = 3'b001; // OR
          6'b000001: alucontrol  = 3'b101; // SRACC
          6'b101010: alucontrol  = 3'b111; // SLT
          default:   alucontrol  = 3'bxxx; // ???
        endcase
    endcase
endmodule

module regfile (input    logic clk, reset, we3, 
                input    logic[4:0]  ra1, ra2, ra3, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2, rd3);

  logic [31:0] rf [31:0];

  // three ported register file: read two ports combinationally
  // write third port on falling edge of clock. Register0 hardwired to 0.

  always_ff @(negedge clk)
     if (we3) 
         rf [wa3] <= wd3;
  	 else if(reset)
       for (int i=0; i<32; i++) rf[i] = {32{1'b0}};	

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ ra2] : 0;
  assign rd3 = (ra3 != 0) ? rf[ra3]  : 0;

endmodule

module alu(input  logic [31:0] a, b, c, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);
    
    always_comb
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b101: result = (a >> b) + c;
            3'b111: result = (a < b) ? 1 : 0;
            default: result = {32{1'bx}};
        endcase
    
    assign zero = (result == 0) ? 1'b1 : 1'b0;
    
endmodule

module adder (input  logic[31:0] a, b,
              output logic[31:0] y);
     
     assign y = a + b;
endmodule

module sl2 (input  logic[31:0] a,
            output logic[31:0] y);
     
     assign y = {a[29:0], 2'b00}; // shifts left by 2
endmodule

module signext (input  logic[15:0] a,
                output logic[31:0] y);
              
  assign y = {{16{a[15]}}, a};    // sign-extends 16-bit a
endmodule

// parameterized register
module flopr #(parameter WIDTH = 8)
              (input logic clk, reset, 
	       input logic[WIDTH-1:0] d, 
               output logic[WIDTH-1:0] q);

  always_ff@(posedge clk, posedge reset)
    if (reset) q <= 0; 
    else       q <= d;
endmodule


// paramaterized 2-to-1 MUX
module mux2 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1,  
              input  logic s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s ? d1 : d0; 
endmodule

// paramaterized 4-to-1 MUX
module mux4 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1, d2, d3,
              input  logic[1:0] s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s[1] ? ( s[0] ? d3 : d2 ) : (s[0] ? d1 : d0); 
endmodule

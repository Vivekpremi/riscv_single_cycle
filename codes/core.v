//main riscv cpu, controller plus datapath
module riscv_cpu(
    input         clk, reset,
    
    input  [31:0] instr,
    input  [31:0] ReadData,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
	output [31:0] PC,
    output [31:0] Result

);

wire [31:0] ALUResult;
wire Z, N, S, U, V, C;
wire [1:0] PCSrc;
wire [3:0] ALUControl;
wire [2:0] ResultSrc;

wire ALUSrc;
wire [1:0] StoreSrc;
wire [1:0] ImmSrc;
wire RegWrite;
wire [1:0] AluOp;
wire Branch;
wire Jump;


controller c(
    .instr(instr),
    .Z(Z),
    .N(N),
    .S(S),
    .U(U),
    .V(V),
    .C(C),

    .PCSrc(PCSrc),
    .ALUControl(ALUControl),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .StoreSrc(StoreSrc),
    .ImmSrc(ImmSrc),
    .RegWrite(RegWrite),
    .AluOp(AluOp),
    .Branch(Branch),
    .Jump(Jump)
);

datapath dp(
    .clk(clk),
    .reset(reset),
	 .instr(instr),
    .PCSrc(PCSrc),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .ALUControl(ALUControl),
    .StoreSrc(StoreSrc),
    .ImmSrc(ImmSrc),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .Jump(Jump),
		
	 .Z(Z),
    .N(N),
    .S(S),
    .U(U),
    .V(V),
    .C(C),
    .PC(PC),
    .Mem_WrAddr(Mem_WrAddr),
    .Mem_WrData(Mem_WrData),
    .ReadData(ReadData),
    .Result(Result)
);

endmodule
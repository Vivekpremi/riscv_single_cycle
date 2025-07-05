// controller --> main_decoder + ALU_decoder 



module controller(
    input [31:0] instr,
    input Z, N, S, U, V, C,
    
    output   [1:0] PCSrc,
    output [3:0] ALUControl, 
    output   [2:0] ResultSrc,
    output   MemWrite,
    output   ALUSrc,
    output   [1:0] StoreSrc,
    output   [1:0] ImmSrc,
    output   RegWrite,
    output   [1:0] AluOp,
    output   Branch,
    output   Jump
);

main_decoder main_decoder_inst(
    .opcode(instr[6:0]),
    .funct3(instr[14:12]),
    .Z(Z),
    .N(N),
    .S(S),
    .U(U),
    .V(V),
    .C(C),
    
    .PCSrc(PCSrc),
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


alu_decoder alu_decoder_inst(
    .alu_op(AluOp),
	 .op5(instr[5]),
    .funct3(instr[14:12]),
    .funct7_bit5(instr[30]),
    
    .alu_control(ALUControl)
);


endmodule
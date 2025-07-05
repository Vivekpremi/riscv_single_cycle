//data path


module datapath(
    input clk,
    input reset,
    input [31:0] instr,
	 input [31:0] ReadData,
    input [1:0] PCSrc,
    input RegWrite,
    input MemWrite,
    input ALUSrc,
    input [3:0] ALUControl,
    input [1:0] StoreSrc,
    input [1:0] ImmSrc,
    input [2:0] ResultSrc,
    input Branch,
    input Jump,
    output Z, N, V, C, S, U,
    output [31:0] PC,
    output [31:0] Mem_WrAddr,
    output [31:0] Mem_WrData,
    
    output [31:0] Result
);
wire [31:0] PCNext, PCPlus4, PCTarget;
wire [31:0] RD1,RD2;

wire [31:0] extended_imm;
wire [31:0] SrcA, SrcB, ALUOut;



wire [31:0] store_data;

wire [31:0] ReadDataMem,WriteDataMem;

wire [31:0] LUI_or_AUIPC; // LUI or AUIPC instruction
pc pc_reg( 
    .PCNext(PCNext), 
    .clk(clk), 
    .rst(reset), 
    .PC(PC)
);

mux4x1 mux_4x1(
    .a(PCPlus4),
    .b(PCTarget),
    .c(ALUOut),
    .d(PCPlus4),
    .sel(PCSrc),
    .y(PCNext)
);

adder PCPlus4_adder(
    .a(PC),
    .b(32'd4),
    .y(PCPlus4)
);

// instr_mem instr_mem(
//     .instr_addr(PC),
//     .instr(instr)
// );

reg_file reg_file(
    .clk(clk),
    .rs1(instr[19:15]),
    .rs2(instr[24:20]),
    .rd(instr[11:7]),
    .wd(Result),
    .we(RegWrite),
    .rd1(RD1),
    .rd2(RD2)
);
assign SrcA = RD1;

assign SrcB = (ALUSrc) ? extended_imm : RD2;

alu alu(
    .A(SrcA),
    .B(SrcB),
    .ALUCtrl(ALUControl),
    .alu_out(ALUOut),
    .Z(Z),
    .N(N),
    .S(S),
    .U(U),
    .V(V),
    .C(C)
);


mux4x1 store_mux(
    .a({{24{RD2[7]}},RD2[7:0]}), //sb
    .b({{16{RD2[15]}},RD2[15:0]}), //sh
    .c({{8{RD2[23]}},RD2[23:0]}), //sw
    .d(32'b0), //default
    .sel(StoreSrc),
    .y(store_data)
);
assign WriteDataMem = store_data;
assign Mem_WrAddr = ALUOut;
assign Mem_WrData = WriteDataMem; // Memory write data
// data_mem data_mem(
//     .clk(clk),
//     .address(ALUOut),
//     .write_data(WriteDataMem),
//     .we(MemWrite),
//     .read_data(ReadDataMem)
// );

sign_extender sign_extender(
    .imm_src(ImmSrc),
    .semi_instr(instr[31:7]),
    .opcode654(instr[6:4]),
    .sign_extended_imm(extended_imm)
);

adder PCTarget_adder(
    .a(PC),
    .b(extended_imm),
    .y(PCTarget)
);

assign LUI_or_AUIPC = (instr[5]) ? extended_imm : PCTarget; //LUI or AUIPC // ALU result
assign ReadDataMem = ReadData; // Data memory read data
// Result selection using 8x1 mux
mux8x1 result_mux(
    .a(ALUOut), // ALU result
    .b(LUI_or_AUIPC), // LUI or AUIPC
    .c({{24{ReadDataMem[7]}},ReadDataMem[7:0]}), // lb
    .d({{16{ReadDataMem[15]}},ReadDataMem[15:0]}), // lh
    .e(ReadDataMem), // lw
    .f({24'b0,ReadDataMem[7:0]}), // lbu
    .g({16'b0,ReadDataMem[15:0]}), // lhu
    .h(PCPlus4), // jump
    .sel(ResultSrc),
    .y(Result)
);


endmodule
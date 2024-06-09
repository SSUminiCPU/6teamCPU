`timescale 1ns / 1ps

module testbench;
    reg clk,MemoryBus,MemoryData,ReadWrite,MemoryWrite,ProgramReg,Jump,Branch;
    wire [2:0] ProgramCounter;
    wire [2:0] opcode;
    reg [3:0] FunctionSelect;
    reg [2:0]DataReg_A,AdderssReg_A,AddressReg_B;
    wire [15:0] da,aa,ab;
       // testbench 변수와 source code counter 변수 연결
datapath uut(
.clk(clk),.MemoryBus(MemoryBus),.MemoryData(MemoryData),.ReadWrite(ReadWrite),.DataReg_A(DataReg_A),.AdderssReg_A(AdderssReg_A),.AddressReg_B(AddressReg_B),.FunctionSelect(FunctionSelect),.da(da),.aa(aa),.ab(ab),.MemoryWrite(MemoryWrite),.ProgramReg(ProgramReg),.Jump(Jump),.Branch(Branch),.opcode(opcode),.ProgramCounter(ProgramCounter)
);
    always begin
    #1 clk = ~clk;  // clk 신호는 1ns마다 변화
    end
    initial begin
        clk = 0;
        #1 DataReg_A = 3'b010; AdderssReg_A = 3'b011; FunctionSelect=4'b0101; MemoryBus =0; MemoryData = 1; ReadWrite = 1; MemoryWrite = 0;  ProgramReg = 0; Jump = 1; Branch = 0;                // LD R2,R3
        #2 DataReg_A = 3'b010; AdderssReg_A = 3'b010; AddressReg_B = 3'b001; FunctionSelect=4'b0010; MemoryBus =1; MemoryData = 0; ReadWrite = 1; MemoryWrite = 0;  ProgramReg = 0; Jump = 0; Branch = 0;            //ADI R2,R2,1
        #2 DataReg_A = 3'b011; AdderssReg_A = 3'b010; AddressReg_B = 3'b011; FunctionSelect=4'b0001; MemoryBus =0; MemoryData = 0; ReadWrite = 1; MemoryWrite = 0;  ProgramReg = 0; Jump = 1; Branch = 0;            //ADD R3,R2,R3
        #2
        $finish;
    end
endmodule

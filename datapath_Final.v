`timescale 1ns / 1ps

module datapath(
 input clk,MemoryBus,MemoryData,ReadWrite,
 input [2:0] DataReg_A,AdderssReg_A,AddressReg_B,
 // opcode 000_FS
 input ProgramReg,Jump,Branch,MemoryWrite,
 input [3:0] FunctionSelect,
 output reg [2:0] ProgramCounter,opcode,
 output reg [15:0] da,aa,ab
);
// register 초기값 '1'으로 설정. 
reg [15:0] register[7:0];
integer i;
initial begin
ProgramCounter = 0;
for (i=0;i<8;i=i+1)
      register[i] <= 16'd1;
end
// Memory 초기값 '5'으로 설정 
reg [15:0] Memory[7:0];
initial begin
for (i=0;i<8;i=i+1)
      Memory[i] <= 16'd5;
end
// PC는 PC값들이 저장된 PC_counter의 주소역할,
reg [15:0] ProgramCounter_counter[2:0];
//opcode 담고 있는 pc counter 설정. 
always @(posedge clk)
begin
da = register[DataReg_A]; aa= register[AdderssReg_A]; ab = register[AddressReg_B];
// Control word bit에 의한 opcode 설정 
if(~MemoryBus & ~MemoryData & ReadWrite & ~MemoryWrite & ~ProgramReg)
    opcode = 3'b000;   //FS 
else if(~MemoryBus & MemoryData & ReadWrite & ~MemoryWrite & ~ProgramReg)
    opcode = 3'b001;   //Memory read
else if(~MemoryBus & ~ReadWrite & MemoryWrite & ~ProgramReg)
    opcode = 3'b010;   //Memory Load
else if(MemoryBus & ~MemoryData & ReadWrite & ~MemoryWrite & ~ProgramReg)
    opcode = 3'b100;   //FS constant(Immediate)
else if(~ReadWrite & ~MemoryWrite & & ProgramReg & ~Jump & ~Branch)
    opcode = 3'b110;   //Branch on zero(Z)
else if(~ReadWrite & ~MemoryWrite & & ProgramReg & ~Jump & Branch)
    opcode = 3'b110;   //Branch on negative(N)
else if(~ReadWrite & ~MemoryWrite & & ProgramReg & Jump)
    opcode = 3'b111;   //Jump
// opcode에 따른 데이터 변화 
case(opcode)
3'b000:         
     case(FunctionSelect)                   // function code 설정
        4'b0000: da = aa;          //Move A
        4'b0001: da = aa +1;       //increment + 1
        4'b0010: da = aa + ab;     //Add
        4'b0011: da = aa + ab + 1; //Add + 1
        4'b0100: da = aa + ~ab;    //1's Subtract
        4'b0101: da = aa + ~ab + 1;//2's Subtract
        4'b0110: da = aa - 1;      //Decrement -1 
        4'b0111: da = aa ;         //Move A
        4'b1000: da = aa & ab ;    //And
        4'b1001: da = aa | ab ;    //OR
        4'b1010: da = aa ^ ab ;    //XOR
        4'b1011: da = ~aa ;        //Not
        4'b1100: da = ab ;         //Move B
        4'b1101: da = ab >> 1;     //Shift Right
        4'b1110: da = ab << 1;     //Shift Left
    endcase   
//constant 값 사용하여 Immediate 사용       
3'b100:     
        case(FunctionSelect)                   // function code 설정
        4'b0000: da = aa;          //Move A
        4'b0001: da = aa +1;       //increment + 1
        4'b0010: da = aa + AddressReg_B;     //Add immediate
        4'b0011: da = aa + AddressReg_B + 1; //Add + 1
        4'b0100: da = aa + ~AddressReg_B;    //1's Subtract
        4'b0101: da = aa + ~AddressReg_B + 1;//2's Subtract
        4'b0110: da = aa - 1;      //Decrement -1 
        4'b0111: da = aa ;         //Move A
        4'b1000: da = aa & AddressReg_B ;    //And
        4'b1001: da = aa | AddressReg_B ;    //OR
        4'b1010: da = aa ^ AddressReg_B ;    //XOR
        4'b1011: da = ~aa ;        //Not
        4'b1100: da = AddressReg_B ;         //Load Immediate
        4'b1101: da = AddressReg_B >> 1;     //Shift Right
        4'b1110: da = AddressReg_B << 1;     //Shift Left
    endcase
3'b001:
    da = Memory[aa];           //Memory load    
3'b010:
    Memory[aa] <= ab ;          //Memory store
3'b110:
    case(FunctionSelect)
        4'b0000: if(~aa) ProgramCounter = ProgramCounter + ab; else ProgramCounter <= ProgramCounter + 1;     // Branch on Zero
        4'b0001: if(~aa[15]) ProgramCounter = ProgramCounter + ab; else ProgramCounter <= ProgramCounter + 1; // Branch on negative       
    endcase
3'b111:
    ProgramCounter <= aa;   // aa위치로 PC 이동 
endcase
// 예외 3'b110일 때 제외하고  PC counter increment 
ProgramCounter_counter[ProgramCounter] <= {opcode,FunctionSelect,DataReg_A,AdderssReg_A,AddressReg_B};
register[DataReg_A] = da; 
if (opcode != 3'b110)
    ProgramCounter <= ProgramCounter +1;
end
endmodule

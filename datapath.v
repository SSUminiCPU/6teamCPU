`timescale 1ns / 1ps
module datapath(
 input clk,MB,MD,RW,
 input [2:0] DA,AA,BA,
 input [3:0] FS,
 input [15:0] Datain,
 output reg [15:0] Dataout,da,aa,ba
);
// register 초기값 '3'으로 설정. 
reg [15:0] register[7:0];
integer i;
initial begin
for (i=0;i<8;i=i+1)
      register[i] <= 16'd3;
end
always @(posedge clk) 
begin
da <= register[DA]; aa<= register[AA]; ba <= register[BA];
//우선시 되는 신호들 설정 (FS 사용 안함)
if(~RW)  
    Dataout <= ba;    // no write
else if (MD) 
    da <= Datain;     // Data in 
// constant 신호 (FS 사용)
else if (MB)         
    case(FS)                   // function code 설정
    4'b0000: da <= aa;
    4'b0001: da <= aa +1;
    4'b0010: da <= aa + BA;
    4'b0011: da <= aa + BA + 1;
    4'b0100: da <= aa + ~BA;
    4'b0101: da <= aa + ~BA + 1;
    4'b0110: da <= aa - 1;
    4'b0111: da <= aa ;
    4'b1000: da <= aa & BA ;
    4'b1001: da <= aa | BA ;
    4'b1010: da <= aa ^ BA ;
    4'b1011: da <= ~aa ;
    4'b1100: da <= BA ;
    4'b1101: da <= BA >> 1;
    4'b1110: da <= BA << 1;    
endcase   
// function code 설정
else
case(FS)
    4'b0000: da <= aa;
    4'b0001: da <= aa +1;
    4'b0010: da <= aa + ba;
    4'b0011: da <= aa + ba + 1;
    4'b0100: da <= aa + ~ba;
    4'b0101: da <= aa + ~ba + 1;
    4'b0110: da <= aa - 1;
    4'b0111: da <= aa ;
    4'b1000: da <= aa & ba ;
    4'b1001: da <= aa | ba ;
    4'b1010: da <= aa ^ ba ;
    4'b1011: da <= ~aa ;
    4'b1100: da <= ba ;
    4'b1101: da <= ba >> 1;
    4'b1110: da <= ba << 1;    
endcase
end
endmodule

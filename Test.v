`timescale 1ns / 1ps
module Test;
    reg clk,MB,MD,RW;
    reg [2:0] DA,AA,BA;
    reg [3:0] FS;
    reg [15:0] Datain;
    wire [15:0] Dataout;
    wire [15:0] da,aa,ba;
        //testbench 변수와 source code counter 변수 연결
datapath uut(
.clk(clk),.MB(MB),.MD(MD),.RW(RW),.DA(DA),.AA(AA),.BA(BA),.FS(FS),.Dataout(Dataout),.Datain(Datain),.da(da),.aa(aa),.ba(ba)
);
    always begin
    #1 clk = ~clk; //clk 신호는 1ns마다 변화
    end
    
    initial begin
        clk = 0;
        DA = 3'b001; AA = 3'b010; BA = 3'b011; MB = 0; FS=4'b0101;MD=0; RW=1;
        #4 DA=3'b100; BA = 3'b110; MB = 0; FS=4'b1110; MD = 0; RW = 1;
        #2 DA = 3'b111; AA = 3'b111; MB = 0; FS = 4'b0001; MD = 0; RW = 1;
        #2 DA = 3'b001; AA = 3'b000; MB = 1; FS=4'b0010; MD = 0; RW = 1; BA = 3'b010;
        #2 BA = 3'b011; MB = 0; RW=0;
        #2 DA = 3'b100; MD = 1; RW = 1; Datain = 16'd5;
        #2 DA = 3'b101; AA = 3'b000; BA = 3'b000; MB=0; FS=4'b101; MD = 0; RW = 1;
        #2
        $finish;
    end
endmodule 

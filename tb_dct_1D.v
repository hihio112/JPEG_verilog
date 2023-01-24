`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yoon Dong Wan
// 
// Create Date: 2023/01/24 14:37:16
// Design Name: 
// Module Name: tb_dct_1D
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
module dct_1D
#(
    parameter integer N=8
)
(
    input clk,
    input rst_n,
    input signed[N-1:0] x0, 
    input signed[N-1:0] x1, 
    input signed[N-1:0] x2,
    input signed[N-1:0] x3,
    input signed[N-1:0] x4,
    input signed[N-1:0] x5,
    input signed[N-1:0] x6,
    input signed[N-1:0] x7,
    output r_valid,
    output signed[N+11:0] X0,//1-sign,11-int, 8-fixed point
    output signed[N+11:0] X1,
    output signed[N+11:0] X2,
    output signed[N+11:0] X3,
    output signed[N+11:0] X4,
    output signed[N+11:0] X5,
    output signed[N+11:0] X6,
    output signed[N+11:0] X7  
);
    //parameter  
    parameter sin_1 = $signed({1'b0,4'd9});   //sin 3pi/16 * 16
    parameter cos_1 = $signed({1'b0,4'd13});   //cos 3pi/16 * 16
    parameter sin_2 = $signed({1'b0,4'd3});    //sin  pi/16 * 16
    parameter cos_2 = $signed({1'b0,4'd15});   //cos  pi/16 * 16
    parameter sin_3 = $signed({1'b0,4'd14});   //sin  3pi/8 * 16
    parameter cos_3 = $signed({1'b0,4'd6});    //cos  3pi/8 * 16

    parameter cos_4 = $signed({1'b0,4'd11});    //cos  pi/4 * 16
    
    //step 1
    reg signed[N:0] b0,b1,b2,b3,b4,b5,b6,b7;  //1 - sign, 8 - integer
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            b0 <= 8'b0;
            b1 <= 8'b0;
            b2 <= 8'b0;
            b3 <= 8'b0;
            b4 <= 8'b0;
            b5 <= 8'b0;
            b6 <= 8'b0;
            b7 <= 8'b0;
        end
        else begin
            b0 <= x0+x7;
            b1 <= x0-x7;
            
            b2 <= x3+x4;
            b3 <= x3-x4;

            b4 <= x1+x6;
            b5 <= x1-x6;

            b6 <= x2+x5;
            b7 <= x2-x5;
        end
    end

    //step2
    reg signed[N+5:0] c0,c1,c2,c3,c4,c5,c6,c7;  //1 - sign, 9 - integer, 4 - fixed point
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            c0 <= 13'b0;
            c1 <= 13'b0;
            c2 <= 13'b0;
            c3 <= 13'b0;
            c4 <= 13'b0;
            c5 <= 13'b0;
            c6 <= 13'b0;
            c7 <= 13'b0;
        end
        else begin
            c0 <= cos_1 * b1 - sin_1 * b3;
            c1 <= sin_1 * b1 + cos_1 * b3;
            
            c2 <= cos_2 * b5 - sin_2 * b7;
            c3 <= sin_2 * b5 + cos_2 * b7;

            c4 <= (b0 + b2)*16;
            c5 <= (b0 - b2)*16;

            c6 <= (b4 + b6)*16;
            c7 <= (b4 - b6)*16;    
        end
    end

    //step3
    reg signed[N+10:0] d0,d1,d2,d3,d4,d5,d6,d7;  //1 - sign, 10 - integer, 8 - fixed point
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            d0 <= 18'b0;
            d1 <= 18'b0;
            d2 <= 18'b0;
            d3 <= 18'b0;
            d4 <= 18'b0;
            d5 <= 18'b0;
            d6 <= 18'b0;
            d7 <= 18'b0;
        end
        else begin
            d0 <= c0 + c1;
            d1 <= c0 - c1;
            
            d2 <= c2 + c3;
            d3 <= c2 - c3;

            d4 <= cos_3 * c5 - sin_3 * c7;
            d5 <= sin_3 * c5 + cos_3 * c7;

            d6 <= c4 + c6;
            d7 <= c4 - c6;    
        end
    end

    //step4
    reg signed[N+11:0] r_X3,r_X5;  //1 - sign, 11 - integer, 8 - fixed point
    assign X0 = cos_4 * d6;
    assign X1 = cos_4 * (d0 + d2);
    assign X2 = d5;
    assign X3 = r_X3;
    assign X4 = cos_4 * d7;
    assign X5 = r_X5;
    assign X6 = d4;
    assign X7 = cos_4 * (d1 - d3);
    always@(posedge clk, negedge rst_n)
        if(!rst_n) begin
            r_X3 <= 0;
            r_X5 <= 0;
        end
        else begin 
            r_X3 <= (c0 - c3)*16;
            r_X5 <= (c1 - c2)*16;
        end
        
        
        

endmodule

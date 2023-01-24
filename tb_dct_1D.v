`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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


module tb_dct_1D();
    reg clk,rst_n;
    reg signed[7:0] x0,x1, x2, x3, x4, x5, x6, x7;
    wire r_valid;
    wire signed[28:0]  X0, X1, X2, X3, X4, X5, X6, X7;
    
    
    dct_1D DUT(clk,rst_n, 
    x0, x1, x2, x3, x4, x5, x6, x7,
    r_valid,
    X0, X1, X2, X3, X4, X5, X6, X7
    );
    always #5 clk =~clk;
    
    initial begin
        clk = 0;
        rst_n =0;
        x0=64;
        x1=32;
        x2=-45;
        x3=55;
        x4=64;
        x5=-10;
        x6=15;
        x7=78;
        #10 rst_n = 1;
        #2000 $finish;
    end
    
    
endmodule

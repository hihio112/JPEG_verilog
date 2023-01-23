module dct_1D
#(
    //parameter  
    localparam sin_1 = $signed{1'b0,8'd142};   //sin 3pi/16 * 256
    localparam cos_1 = $signed{1'b0,8'd212};   //cos 3pi/16 * 256
    localparam sin_2 = $signed{1'b0,8'd50};    //sin  pi/16 * 256
    localparam cos_2 = $signed{1'b0,8'd251};   //sin  pi/16 * 256
    localparam sin_3 = $signed{1'b0,8'd237};   //sin  3pi/8 * 256
    localparam cos_3 = $signed{1'b0,8'd98};    //cos  3pi/8 * 256

    localparam cos_4 = $signed{1'b0,8'd181};    //cos  pi/4 * 256
)
(
    input clk,
    input rst_n,
    input signed[7:0] x0, x1, x2, x3, x4, x5, x6, x7;
    output r_valid,
    output signed[28:0] X0, X1, X2, X3, X4, X5, X6, X7;  //1-sign,20-int, 8-fixed point
);

    //step 1
    reg signed[8:0] b0,b1,b2,b3,b4,b5,b6,b7;  //1 - sign, 8 - integer
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
    reg signed[17:0] c0,c1,c2,c3,c4,c5,c6,c7;  //1 - sign, 9 - integer, 8 - fixed point
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            c0 <= 18'b0;
            c1 <= 18'b0;
            c2 <= 18'b0;
            c3 <= 18'b0;
            c4 <= 18'b0;
            c5 <= 18'b0;
            c6 <= 18'b0;
            c7 <= 18'b0;
        end
        else begin
            c0 <= cos_1 * b1 - sin_1 * b3;
            c1 <= sin_1 * b1 + cos_1 * b3;
            
            c2 <= cos_2 * b5 - sin_2 * b7;
            c3 <= sin_2 * b5 + cos_2 * b7;

            c4 <= {b0 + b2,8'b0};
            c5 <= {b0 - b2,8'b0};

            c6 <= {b4 + b6,8'b0};
            c7 <= {b4 - b6,8'b0};    
        end
    end

    //step3
    reg signed[18:0] d0,d1,d2,d3,d4,d5,d6,d7;  //1 - sign, 10 - integer, 8 - fixed point
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
    assign X0 = cos_4 * d6;
    assign X1 = cos_4 * (d0 + d2);
    assign X2 = d5;
    assign X4 = cos_4 * d7;
    assign X6 = d4;
    assign X7 = cos_4 * (d1 + d3);
    always@(posedge clk, negedge rst_n)
        if(!rst_n) begin
            X3 <= 0;
            X5 <= 0;
        end
        else begin 
            X3 <= c0 + c3;
            X5 <= c1 + c2;
        end

endmodule
module registers (clk, rst, BUS, LD, t0, t1, t2, t3, i0, i1, const);
    input clk, rst;
    input [15:0] BUS;
    input [3:0] LD;
    output [15:0] t0, t1, t2, t3, i0, i1, const;
    register regt0(clk, rst, LD[3], BUS, t0);
    register regt1(clk, rst, LD[2], BUS, t1);
    register regt2(clk, rst, LD[1], BUS, t2);
    register regt3(clk, rst, LD[0], BUS, t3);
    register regi0(clk, rst, 1'b1, 16'd10, i0);
    register regi1(clk, rst, 1'b1, 16'd100, i1);
    register regconst(clk, rst, 1'b1, 16'd0, const);
endmodule
module register (
    input clk,
    input rst,
    input LD,
    input [15:0] BUS,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if(rst) begin
            q <= 16'd0;
        end else begin
            q <= (LD) ? BUS : q;
        end
    end
endmodule
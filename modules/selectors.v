module selector(t0, t1, t2, t3, i0, i1, const, SEL, Y);
    input [15:0] t0, t1, t2, t3, i0, i1, const;
    input [2:0] SEL;
    output [15:0] Y;

    assign Y = (SEL==3'd0) ? t0 : (SEL==3'd1) ? t1 : (SEL==3'd2) ? t2 : (SEL==3'd3) ? t3 : (SEL==3'd4) ? i0 : (SEL==3'd5) ? i1 : const;
endmodule

module selectors(t0, t1, t2, t3, i0, i1, const, SEL, Y0, Y1, Y2);
    input [15:0] t0, t1, t2, t3, i0, i1, const;
    input [8:0] SEL;
    output [15:0] Y0, Y1, Y2;

    selector selector1(t0, t1, t2, t3, i0, i1, const, SEL[8:6], Y0);
    selector selector2(t0, t1, t2, t3, i0, i1, const, SEL[5:3], Y1);
    selector selector3(t0, t1, t2, t3, i0, i1, const, SEL[2:0], Y2);
endmodule
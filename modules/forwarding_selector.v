module forwarding_selector (
    input [15:0] BUS,
    input [15:0] BUS_past,
    input [3:0] LD_reg,
    input [3:0] LD_reg_past,
    input [5:0] SEL,
    input [15:0] Y0_ex,
    input [15:0] Y1_ex,
    output [15:0] Y0_sel,
    output [15:0] Y1_sel
);

    assign Y0_sel = func_Y(LD_reg, LD_reg_past, SEL[5:3], Y0_ex, BUS, BUS_past);
    assign Y1_sel = func_Y(LD_reg, LD_reg_past, SEL[2:0], Y1_ex, BUS, BUS_past);

    function [15:0] func_Y;
        input [3:0] LD;
        input [3:0] LD_past;
        input [2:0] SEL;
        input [15:0] Y;
        input [15:0] BUS;
        input [15:0] BUS_past;
        begin
            if(SEL==3'd0) begin
                if(LD==4'd8) begin
                    func_Y = BUS;
                end else if(LD_past==4'd8) begin
                    func_Y = BUS_past;
                end else begin
                    func_Y = Y;
                end
            end else if(SEL==3'd1) begin
                if(LD==4'd4) begin
                    func_Y = BUS;
                end else if(LD_past==4'd4) begin
                    func_Y = BUS_past;
                end else begin
                    func_Y = Y;
                end
            end else if(SEL==3'd2) begin
                if(LD==4'd2) begin
                    func_Y = BUS;
                end else if(LD_past==4'd2) begin
                    func_Y = BUS_past;
                end else begin
                    func_Y = Y;
                end
            end else if(SEL==3'd3) begin
                if(LD==4'd1) begin
                    func_Y = BUS;
                end else if(LD_past==4'd1) begin
                    func_Y = BUS_past;
                end else begin
                    func_Y = Y;
                end
            end else begin
                func_Y = Y;
            end
        end
        
    endfunction
endmodule
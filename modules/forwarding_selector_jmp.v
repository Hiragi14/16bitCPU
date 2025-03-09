module forwarding_selector_jmp (
    input [15:0] BUS,
    input [15:0] BUS_past,
    input [3:0] LD_reg,
    input [3:0] LD_reg_past,
    input [2:0] SEL,
    input [15:0] Y2,
    output [15:0] Y2_sel
);
    assign Y2_sel = func_Y(LD_reg, LD_reg_past, SEL, Y2, BUS, BUS_past);
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
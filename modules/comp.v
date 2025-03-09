module comp (
    input [15:0] Y0,
    input [15:0] Y1,
    input [3:0] alu_control,
    output rFlag
);
    assign rFlag = func_rFlag(alu_control, Y0, Y1);

    function func_rFlag;
        input [3:0] alu_control;
        input [15:0] Y0;
        input [15:0] Y1;
        begin
            if((alu_control==4'd6) || ((alu_control==4'd7) && (Y0>Y1)) || ((alu_control==4'd8) && (Y0<Y1)) || ((alu_control==4'd9) && (Y0==Y1))) begin
                func_rFlag = 1'b1;
            end else begin
                func_rFlag = 1'b0;
            end
        end
    endfunction
endmodule
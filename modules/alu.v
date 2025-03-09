module alu (
    input [15:0] Y0,
    input [15:0] Y1,
    input [15:0] Y2,
    input [3:0] alu_control,
    //output rFlag,
    output [15:0] F
);
    assign F = func_result(alu_control, Y0, Y1, Y2);
    //assign rFlag = func_rFlag(alu_control, Y0, Y1);

    function [15:0] func_result;
        input [3:0] alu_control;
        input [15:0] Y0;
        input [15:0] Y1;
        input [15:0] Y2;
        begin
            case (alu_control)
                4'd0: func_result = Y0 + Y1;
                4'd1: func_result = Y0;
                4'd2: func_result = Y0 & Y1;
                4'd3: func_result = Y0 ^ Y1;
                4'd4: func_result = Y0 | Y1;
                4'd5: func_result = ~Y0;
                4'd6: func_result = Y0;//Y2でもよい（つかわない）
                4'd7: func_result = Y0;//Y2
                4'd8: func_result = Y0;//Y2
                4'd9: func_result = Y0;//Y2
                4'd10: func_result = Y0 << Y1;
                4'd11: func_result = Y0 >> Y1;
                default: func_result = Y0;
            endcase
        end
    endfunction

    // function func_rFlag;
    //     input [3:0] alu_control;
    //     input [15:0] Y0;
    //     input [15:0] Y1;
    //     begin
    //         if((alu_control==4'd6) || ((alu_control==4'd7) && (Y0>Y1)) || ((alu_control==4'd8) && (Y0<Y1)) || ((alu_control==4'd9) && (Y0==Y1))) begin
    //             func_rFlag = 1'b1;
    //         end
    //     end
    // endfunction
endmodule
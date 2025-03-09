module decoder (
    input [15:0] im_out,
    output [8:0] SEL,
    output [2:0] data_SEL,
    output [3:0] alu_control,
    output [6:0] LD//LD[6:3]=t0~t3, LD[2]=$p, LD[1]=memory, LD[0]=programcounter
);

    wire [15:0] ld_sel;
    wire [3:0] opcode;
    wire [2:0] mode;
    assign opcode = im_out[15:12];
    assign mode = im_out[2:0];

    assign ld_sel = func_LDSEL(im_out);
    assign LD = ld_sel[15:9];
    assign SEL = ld_sel[8:0];
    assign data_SEL = func_dataSEL(opcode);
    assign alu_control = func_aluSEL(opcode, mode);

    //data_selector SEL
    function [2:0] func_dataSEL;
    input [3:0] opcode;
    begin
        case (opcode)
            `sw: func_dataSEL = 3'd1;
            `mv: func_dataSEL = 3'd2;
            default: func_dataSEL = 3'd0;
        endcase
    end
    endfunction

    //alu control
    function [3:0] func_aluSEL;
    input [3:0] opcode;
    input [2:0] mode;
    begin
        if(opcode==`add) begin
            func_aluSEL = 4'd0;
        end else if(opcode==`lw) begin
            func_aluSEL = 4'd1;
        end else if(opcode==`logical_operations) begin
            case (mode)
                3'd0: func_aluSEL = 4'd2;
                3'd1: func_aluSEL = 4'd3;
                3'd2: func_aluSEL = 4'd4;
                3'd3: func_aluSEL = 4'd5;
                default: func_aluSEL = 4'd0; 
            endcase
        end else if(opcode==`jmp_operations) begin
            case (mode)
                3'd0: func_aluSEL = 4'd6;
                3'd1: func_aluSEL = 4'd7;
                3'd2: func_aluSEL = 4'd8;
                3'd3: func_aluSEL = 4'd9;
                default: func_aluSEL = 4'd0;
            endcase 
        end else if(opcode==`sift_operations) begin
            case (mode)
                3'd0: func_aluSEL = 4'd10;
                3'd1: func_aluSEL = 4'd11;
                default: func_aluSEL = 4'd0;
            endcase
        end else if(opcode==`mv) begin
            func_aluSEL = 4'd2;
        end else begin
            func_aluSEL = 4'd12;
        end
    end
    endfunction

    function [15:0] func_LDSEL;//[15:9]-LD, [8:6]-Y0, [5:3]-Y1, [2:0]-Y2
    input [15:0] inst;
    reg [3:0] opcode;
    begin
        opcode = inst[15:12];
        case (opcode)
            `nop: func_LDSEL = {7'd0, 3'd6, 3'd6, 3'd6};
            `add: func_LDSEL = {func_LD(inst[5:3]), func_SEL(inst[11:9]), func_SEL(inst[8:6]), 3'd6};
            `sw: func_LDSEL = {func_LD(inst[5:3]), 3'd7, 3'd6, 3'd6};
            `lw: func_LDSEL = {7'b0000010, func_SEL(inst[11:9]), 3'd6, 3'd6};
            `mv: func_LDSEL = {func_LD(inst[11:9]), 3'd6, 3'd6, 3'd6};
            `logical_operations: func_LDSEL = {func_LD(inst[5:3]), func_SEL(inst[11:9]), func_SEL(inst[8:6]), 3'd6};
            `jmp_operations: func_LDSEL = {7'b0000001, func_SEL(inst[11:9]), func_SEL(inst[8:6]), func_SEL(inst[5:3])};
            `sift_operations: func_LDSEL = {func_LD(inst[5:3]), func_SEL(inst[11:9]), func_SEL(inst[8:6]), 3'd6};
            default: func_LDSEL = 16'd0;
        endcase
    end
    endfunction

    //register LD signal
    function [6:0] func_LD;
    input [2:0] dr;
    begin
        case (dr)
            `p: func_LD = 7'b0000100;
            `t0: func_LD = 7'b1000000;
            `t1: func_LD = 7'b0100000;
            `t2: func_LD = 7'b0010000;
            `t3: func_LD = 7'b0001000;
            default: func_LD = 7'b0000000;
        endcase
    end
    endfunction

    //SEL signal
    function [2:0] func_SEL;
    input [2:0] sra;
    begin
        case (sra)
            `t0: func_SEL = 3'd0;
            `t1: func_SEL = 3'd1;
            `t2: func_SEL = 3'd2;
            `t3: func_SEL = 3'd3;
            `i0: func_SEL = 3'd4;
            `i1: func_SEL = 3'd5;
            `const: func_SEL = 3'd6;
            default: func_SEL = 3'd6;
        endcase
    end
    endfunction
endmodule
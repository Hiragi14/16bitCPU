`include "./modules/define.v"
`include "./modules/alu.v"
`include "./modules/data_selector.v"
`include "./modules/dec_7seg.v"
`include "./modules/decoder.v"
//`include "im_rom.v"
//`include "memory.v"
`include "./modules/pc_selector.v"
`include "./modules/programcounter.v"
`include "./modules/registers.v"
`include "./modules/selectors.v"
`include "./modules/pipeline_register.v"
`include "./modules/comp.v"
`include "./modules/address_reg.v"
`include "./modules/selecter_pc.v"
`include "./modules/forwarding_selector.v"
`include "./modules/forwarding_selector_jmp.v"
module cpu_pipeline(
    input CLK,//50MHz
    input [3:0] KEY//rst(KEY[0])
    //input [15:0] SW,//i0
    //input [15:0] IN1,//i1
    // output [6:0] HEX0,//programcounter
    // output [6:0] HEX1,
    // output [6:0] HEX2,
    // output [6:0] HEX3,
    // output [6:0] HEX4,//reg t0
    // output [6:0] HEX5,
    // output [6:0] HEX6,
    // output [6:0] HEX7
);
    wire [6:0] LD;
    wire LD_PC, LD_address, LD_memory, LD_memory_ex;
    wire [3:0] LD_registers, LD_registers_ex, LD_registers_wb;
    assign LD_PC = LD[0];
    assign LD_registers = LD[6:3];
    assign LD_address = LD[2];
    assign LD_memory = LD[1];

    wire rst;
    assign rst = !KEY[0];
    wire [15:0] BUS,BUS_wb;
    wire [15:0] t0, t1, t2, t3, i0, i1, const, memory_data;
    wire [15:0] address;
    wire [3:0] alu_control, alu_control_ex;
    wire [8:0] SEL;
    wire [2:0] data_SEL, data_SEL_ex, data_SEL_wb;
    wire [15:0] Y0, Y1, Y2, F, Y0_ex, Y1_ex, Y2_ex, Y0_sel, Y1_sel, Y2_sel;
    wire [15:0] im_out, PC, im_out_id, PC_im;
    wire [7:0] imm, imm_id, imm_ex;
    assign imm = im_out[8:1];

    wire rFlag;


    //IF
    programcounter          programcounter        (CLK, rst, LD_PC, rFlag, Y2_sel, PC);
    selecter_pc             selecter_pc           (Y2_sel, PC, rFlag, PC_im);
    //im_rom                im_rom                (PC, CLK, im_out);
    im_test                 im_test               (PC_im, CLK, im_out);

    comp                    comp                  (Y0_sel, Y1_sel, alu_control, rFlag);


    pipeline_register       pipeline_im           (CLK, (rst | rFlag), im_out, im_out_id);
    pipeline_register #( 8) pipeline_imm          (CLK, (rst | rFlag), imm, imm_id);


    //ID
    decoder                 decoder               (im_out_id, SEL, data_SEL, alu_control, LD);//im_out_id
    selectors               selectors             (t0, t1, t2, t3, i0, i1, const, SEL, Y0, Y1, Y2);
    registers               registers             (CLK, rst, BUS_wb, LD_registers_wb, t0, t1, t2, t3, i0, i1, const);//
    address_reg             address_reg           (CLK, rst, LD_address, BUS, address);//imm_id
    forwarding_selector     sel                   (BUS, BUS_wb, LD_registers_ex, LD_registers_wb, SEL[8:3], Y0, Y1, Y0_sel, Y1_sel);
    forwarding_selector_jmp sel_jmp               (BUS, BUS_wb, LD_registers_ex, LD_registers_wb, SEL[2:0], Y2, Y2_sel);

    pipeline_register #( 1) pipeline_LD_memory    (CLK, rst, LD_memory, LD_memory_ex);
    pipeline_register #( 4) pipeline_LD_registers (CLK, rst, LD_registers, LD_registers_ex);
    pipeline_register #( 3) pipeline_data_SEL     (CLK, rst, data_SEL, data_SEL_ex);
    pipeline_register #( 4) pipeline_alu_control  (CLK, rst, alu_control, alu_control_ex);
    pipeline_register       pipeline_Y0           (CLK, rst, Y0_sel, Y0_ex);
    pipeline_register       pipeline_Y1           (CLK, rst, Y1_sel, Y1_ex);
    pipeline_register       pipeline_Y2           (CLK, rst, Y2_sel, Y2_ex);
    pipeline_register #( 8) pipeline_imm_ex       (CLK, rst, imm_id, imm_ex);//imm_id

    //EX
    alu                     alu                   (Y0_ex, Y1_ex, Y2_ex, alu_control_ex, F);
    //memory                memory                (address, CLK, Y0, LD_memory_ex, memory_data);
    memory_test             memory_test           (address[7:0], CLK, Y0_sel, LD_memory, memory_data);//LD_memory_ex
    data_selector           data_selector         (F, memory_data, imm_ex, data_SEL_ex, BUS);

    pipeline_register #( 4) pipeline_LD_reg_WB    (CLK, rst, LD_registers_ex, LD_registers_wb);
    pipeline_register       pipeline_BUS          (CLK, rst, BUS, BUS_wb);


    // //pc output deback
    // dec_7seg dec_7seg0(PC[3:0], HEX0);
    // dec_7seg dec_7seg1(PC[7:4], HEX1);
    // dec_7seg dec_7seg2(PC[11:8], HEX2);
    // dec_7seg dec_7seg3(PC[15:12], HEX3);

    // //t0 register deback
    // dec_7seg dec_7seg4(t0[3:0], HEX4);
    // dec_7seg dec_7seg5(t0[7:4], HEX5);
    // dec_7seg dec_7seg6(t0[11:8], HEX6);
    // dec_7seg dec_7seg7(t0[15:12], HEX7);
endmodule

module memory_test (
    address,
	clock,
	data,
	wren,
	q
);
    input	[7:0]  address;
	input	  clock;
	input	[15:0]  data;
	input	  wren;
	output	 reg [15:0]  q;

    reg [7:0] mem[0:15];

    integer i;
    initial begin
        for (i = 0; i<256; i=i+1) begin
            mem[i] <= 16'd0;
        end
    end

    always @(posedge clock) begin
        if(wren) begin
            mem[address] <= data;
        end else begin
            q <= mem[address];
        end
    end
endmodule

module mem_reg (
    input clock,
    input rst,
    input [15:0] in,
    output reg [15:0] q
);
    always @(posedge clock) begin
        if(rst) begin
            q <= 16'd0;
        end begin
            q <= in;
        end
    end
endmodule

module im_test (
    address,
	clock,
	q
);
    input	[15:0]  address;
	input	  clock;
	output	reg [15:0]  q;

    reg [15:0] im_rom[0:15];

    integer i;
    initial begin
        // for (i = 4; i<65535; i=i+1) begin
        //     im_rom[i] <= 16'd0;
        // end
        $readmemb("im.txt",im_rom);
    end

    always @(posedge clock) begin
        q <= im_rom[address];
    end
endmodule
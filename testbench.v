`include "cpu_pipeline.v"
//`default_nettype none

module tb_cpu_pipeline;
reg clk;
reg rst;

cpu_pipeline inst(clk, rst);

initial begin
    $dumpfile("tb_cpu_pipeline.vcd");
    $dumpvars(0, tb_cpu_pipeline);
    # 200 $finish;
end

initial begin
    clk <= 1'b0;
    rst <= 1'b0;
    #2 rst <= 1'b1;
end
always begin
    # 1 clk <= ~clk;
end

endmodule
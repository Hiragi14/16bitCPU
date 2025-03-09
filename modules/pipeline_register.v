module pipeline_register #(
    parameter DATA_W = 16
) (
    input clk,
    input rst,
    input [DATA_W-1:0] in,
    output reg [DATA_W-1:0] q
);
    always @(posedge clk) begin
        if(rst) begin
            q <= 16'd0;
        end else begin
            q <= in;
        end
    end
endmodule
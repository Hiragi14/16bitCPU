module programcounter (
    input clk,
    input rst,
    input LD,
    input rFlag,
    input [15:0] Y2,
    output  reg [15:0] PC
);
    always @(posedge clk) begin
        if(rst) begin
            PC <= 16'd0;
        end else begin
            PC <= (LD && rFlag) ? Y2 + 16'd1 : PC + 16'd1;
        end
    end
endmodule
module prog_ctr #(
    parameter WIDTH = 32
) (
    input               clk, rst, 
    input               stall,
    input [WIDTH-1:0]   ctr_in,

    output reg [WIDTH-1:0]  ctr_out
);

    // test
    initial ctr_out = 32'bx;

    // program counter
    always @(posedge clk) begin
        if (rst) begin // reset
            ctr_out <= 32'h0;
        end else if (~rst) begin
            if (stall) begin // stall
            ctr_out <= ctr_out;
            end
            else if (~stall) begin // increment
            ctr_out <= ctr_out + ctr_in;
            end
        end
    end
    
endmodule

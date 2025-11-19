module data_mem #(
    parameter
            WIDTH = 32,
            DEPTH = 32
) (
    input               clk, rst,
    input               write_en, read_en,
    input   [WIDTH-1:0] data_in,
    input   [WIDTH-1:0] addr,
    
    output [WIDTH-1:0] data_out
);

reg [WIDTH-1:0] data_mem_block  [DEPTH-1:0];

    always @(posedge clk ) begin
        if (rst) begin
            data_mem_block[addr] <= data_mem_block[addr];
        end else if (read_en) begin
            data_mem_block[addr] <= data_in;
        end
    end
assign data_out = write_en ? 32'b0 : data_mem_block[addr];

endmodule
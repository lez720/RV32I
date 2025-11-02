module inst_mem #(
    parameter
            WIDTH = 8,
            DEPTH = 32
) (
    input               clk, rst,
    input   [WIDTH+24:0] addr,
    
    output  [WIDTH+24:0] data_out
);

reg [WIDTH-1:0] inst_mem_block  [DEPTH-1:0];

assign data_out[7:0] = inst_mem_block[addr];
assign data_out[15:8] = inst_mem_block[addr+1];
assign data_out[23:16] = inst_mem_block[addr+2];
assign data_out[31:24] = inst_mem_block[addr+3];

endmodule

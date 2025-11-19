module inst_mem #(
    parameter
            WIDTH = 8,
            DEPTH = 32
) (
    input               clk, rst, inst_store,
    input   [WIDTH+24:0] addr, data_in;
    
    output  [WIDTH+24:0] data_out
);

reg [WIDTH-1:0] inst_mem_block  [DEPTH-1:0];


always @(posedge clk ) begin
    if (inst_store) begin
        inst_mem_block[addr] <= data_in [7:0];
        inst_mem_block[addr+1] <= data_in [15:8];
        inst_mem_block[addr+2] <= data_in [23:16];
        inst_mem_block[addr+3] <= data_in [31:24];
    end
end

assign data_out[7:0] = inst_store ? inst_mem_block[addr] : 8'b00000000;
assign data_out[15:8] = inst_store ? inst_mem_block[addr+1] : 8'b00000000;
assign data_out[23:16] = inst_store ? inst_mem_block[addr+2] : 8'b00000000;
assign data_out[31:24] = inst_store ? inst_mem_block[addr+3] : 8'b00000000;

endmodule

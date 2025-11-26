module reg_file #(
    parameter
            WIDTH = 32,
            DEPTH = 32
) (
    input                   clk, rst,
    input                   write_en, read_en,
    input   [WIDTH-1:0]     data_in,
    input   [WIDTH-28:0]    write_addr, 
    input   [WIDTH-28:0]    read_addr_1, read_addr_2,
    
    output  [WIDTH-1:0]     data_out_1, data_out_2
);

reg [WIDTH-1:0] reg_file_block  [DEPTH-1:0];

initial reg_file_block[0] = 32'h0; // x0 is zero constant

    always @(posedge clk ) begin
        if (rst) begin
            reg_file_block[write_addr] <= reg_file_block[write_addr];
        end else if (write_en) begin
            reg_file_block[write_addr] <= data_in;
        end
    end

assign data_out_1 = reg_file_block[read_addr_1];
assign data_out_2 = reg_file_block[read_addr_2];

endmodule

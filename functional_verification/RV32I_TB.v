module RV32I_TB;

reg clk, rst;
wire [31:0] data_out;

	RV32I_top_level RV32I_inst(.clk(clk), .rst(rst), .data_out(data_out));

initial begin
    clk = 0;
    rst = 1;

    #30 rst = 0;
end

always #10 clk = ~clk;

endmodule


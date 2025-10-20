module alu #(
    parameter
            WIDTH = 32
) (
    input                   clk, rst, en,
    input   [WIDTH-1:0]     data_in,
    input   [WIDTH-16:0]    operation,

    output                  z_flag, o_flag,
    output  [WIDTH-1:0]     data_out
);
    
endmodule
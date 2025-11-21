module branch_unit #(
    parameter
        WIDTH = 32
) (
    input               clk, rst, en,
    input   [WIDTH-1:0] data_in_1, data_in_2,

    output  reg [1:0]   branch
);
    // add branch target adder (branch target = PC + imm)
    always @(posedge clk) begin
      if (rst) begin
        branch <= 2'b00;
      end
      else if (en) begin
        if (data_in_1 == data_in_2) begin
          branch <= 2'b01;
        end
        else if (data_in_1 > data_in_2) begin
          branch <= 2'b10;
        end
        else if (data_in_1 < data_in_2) begin
          branch <= 2'b11;
        end
        else begin
          branch <= 2'b00;
        end
      end
    end

endmodule

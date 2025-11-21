module imm_unit #(
    parameter WIDTH = 20
) (
    input clk, rst, 
    input [1:0] imm_en,
    input [WIDTH+11:0] inst_data,

    output reg [11:0]  imm_out
);
    
    // immediate 
    always @(posedge clk ) begin
        case (imm_en)
            2'b01 : imm_out <= inst_data[31:20];
            2'b10 : begin
                imm_out[12] <= inst_data[31];
                imm_out[10:5] <= inst_data[30:25];
                imm_out[4:1] <= inst_data[11:8];
                imm_out[11] <= inst_data[7];
                imm_out[0] <= 0;
            end
            2'b11 : begin 
                imm_out <= inst_data [31:12];
            end
        endcase
    end

endmodule
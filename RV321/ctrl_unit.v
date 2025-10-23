module ctrl_unit #(
    parameter
        WIDTH = 32
) (
    input   clk, rst,
    input   [WIDTH-26:0]  opcode,
    

    output  reg [WIDTH-16:0]    alu_op,


    output  reg           DM_write_en,
    output  reg           port_A_sel,
    output  reg           port_B_sel,
    output  reg [1:0]       write_MUX_sel,
    output  reg           PC_MUX_sel,
    output  reg [1:0]       imm_en,
    output  reg           reg_write_en,
    output  reg           branch_en,
    output  reg           PC_stall
);
    
    always @(posedge clk ) begin
        case (opcode)
            // R-type
            7'b0110011 : begin

            end

            // I-type
            7'b0010011 : begin

            end
            7'b0000011 : begin

            end
            7'b1100111 : begin

            end

            // S-type
            7'b0100011 : begin

            end

            // B-type
            7'b1100011 : begin

            end

            // U-type
            7'b0010111 : begin

            end
            7'b0110111 : begin

            end

            // J-type
            7'b1101111 : begin

            end


            default: 
        endcase
    end
endmodule
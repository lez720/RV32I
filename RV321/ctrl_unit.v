module ctrl_unit #(
    parameter
        WIDTH = 32
) (
    input   clk, rst,
    input   [WIDTH-26:0]  opcode,
    
    output  reg           DM_write_en,
    output  reg           port_A_sel,
    output  reg           port_B_sel,
    output  reg           write_MUX_sel,
    output  reg           PC_MUX_sel,
    output  reg           imm_en,
    output  reg           reg_write_en
);
    
endmodule
module RV32I_top_level #(
    parameter
        WIDTH = 32
) (
    input               clk, rst,
    input   [WIDTH-1:0] data_in,
    output  [WIDTH-1:0] data_out
);

// fetch
    wire [WIDTH-1:0]    inst_addr;
    wire [WIDTH-1:0]    inst_data;

    inst_mem IM_inst (.addr(inst_addr), .data_out(inst_data));

// decode
    wire    DM_write_en, port_A_sel, port_B_sel;
    wire    write_MUX_sel, PC_MUX_sel, imm_en;
    wire    reg_write_en;

    ctrl_unit CU_inst (
        .clk(clk), .rst(rst), .opcode(), .DM_write_en(DM_write_en),
        .port_A_sel(port_A_sel), .port_B_sel(port_B_sel), .write_MUX_sel(write_MUX_sel),
        .PC_MUX_sel(PC_MUX_sel), .imm_en(imm_en), .reg_write_en(reg_write_en)
        );

    wire                reg_write, reg_read;
    wire    [WIDTH-1:0] reg_w_addr, reg_r1_addr, reg_r2_addr;
    wire    [WIDTH-1:0] reg_data_in;
    wire    [WIDTH-1:0] RS1, RS2; // source register 1 & 2

    reg_file reg_file_inst (
        .clk(clk), .rst(rst), .write_en(reg_write),
        .read_en(reg_read), .data_in(reg_data_in), .write_addr(reg_w_addr),
        .read_addr_1(reg_r1_addr), .read_addr_2(reg_r2_addr), .data_out_1(RS1),
        .data_out_2(RS2)
    );

// execute
    alu alu_inst ();
    branch_unit BU_inst ();

// memory
    wire                DM_write, DM_read;
    wire    [WIDTH-1:0] DM_addr;
    wire    [WIDTH-1:0] DM_data_in, DM_data_out;

    data_mem DM_inst (
        .clk(clk), .rst(rst), .write_en(DM_write),
        .read_en(DM_read), .data_in(DM_data_in), .addr(DM_addr),
        .data_out(DM_data_out)
    );

// write back
    
endmodule
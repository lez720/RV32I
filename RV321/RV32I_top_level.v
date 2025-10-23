module RV32I_top_level #(
    parameter
        WIDTH = 32
) (
    input               clk, rst,
    input   [WIDTH-1:0] data_in,
    output  [WIDTH-1:0] data_out
);

// fetch
    reg [WIDTH-1:0] PC_MUX;

    // PC MUX
    always @(posedge clk ) begin
        case (param)
            1'b0 :  PC_MUX <= 4; // +4
            1'b1 :  PC_MUX <= alu_out;
            default: 
        endcase
    end

    reg [WIDTH-1:0] prog_ctr;
    wire            stall;

    // program counter
    always @(posedge clk ) begin
        if (rst) begin // reset
            prog_ctr <= 32'b0;
        end else if (stall) begin // stall
            prog_ctr <= prog_ctr;
        end else begin // increment
            prog_ctr <= prog_ctr + PC_MUX;
        end
    end

    wire [WIDTH-1:0]    inst_addr;
    wire [WIDTH-1:0]    inst_data;

    inst_mem IM_inst (
        .addr(inst_addr), .data_out(inst_data)
        );

// decode
    wire            DM_write_en, port_A_sel, port_B_sel;
    wire    [1:0]   write_MUX_sel, PC_MUX_sel;
    wire    [1:0]   imm_e;
    wire            branch_en;
    wire            reg_write_en;

    // control unit
    ctrl_unit CU_inst (
        .clk(clk), .rst(rst), .opcode(), .DM_write_en(DM_write_en),
        .port_A_sel(port_A_sel), .port_B_sel(port_B_sel), .write_MUX_sel(write_MUX_sel),
        .PC_MUX_sel(PC_MUX_sel), .imm_en(imm_en), .reg_write_en(reg_write_en),
        .branch_en(branch_en), .PC_stall(stall)
        );

    wire                reg_write, reg_read;
    wire    [WIDTH-1:0] reg_w_addr, reg_r1_addr, reg_r2_addr;
    wire    [WIDTH-1:0] RS1, RS2; // source register 1 & 2`

    // register file
    reg_file reg_file_inst (
        .clk(clk), .rst(rst), .write_en(reg_write),
        .read_en(reg_read), .data_in(write_back), .write_addr(reg_w_addr),
        .read_addr_1(reg_r1_addr), .read_addr_2(reg_r2_addr), .data_out_1(RS1),
        .data_out_2(RS2)
    );

    reg    [WIDTH-20:0] imm_out;

    // immediate 
    always @(posedge clk ) begin
        case (imm_en)
            2'b01 : imm_out <= inst_data[31:20];
            2'b10 : begin
                imm_out[11:5] <= inst_data[31:25];
                imm_out[4:0] <= inst_data[24:20];
            end
            default: imm_out <= 12'b0;
        endcase
    end

// execute

    reg [WIDTH-1:0] port_A_out, port_B_out;

    // port A MUX
    always @(posedge clk ) begin
        case (port_A_sel)
            1'b0 : port_A_out <= RS1;
            1'b1 : port_A_out <= imm_out;
            default: port_A_out <= 32'bx;
        endcase
    end

    // port B MUX
    always @(posedge clk ) begin
        case (port_B_sel)
            1'b0 : port_B_out <= RS2;
            1'b1 : port_B_out <= imm_out;
            default: port_B_out <= 32'bx;
        endcase
    end

    wire    alu_en;
    wire    [WIDTH-16:0]    alu_op;
    wire    [WIDTH-1:0]     alu_out;

    // ALU
    alu alu_inst (
        .clk(clk), .rst(rst), .en(alu_en),
        .port_A(port_A_out), .port_B(port_B_out), .operation(alu_op),
        .data_out(alu_out)
    );

    wire    [1:0]   branch_op;

    // branch unit
    branch_unit BU_inst (
        .clk(clk), .rst(rst), .en(branch_en),
        .data_in_1(RS1), .data_in_2(RS2), .branch(branch_op)
    );

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
    reg [WIDTH-1:0] write_back;

    always @(posedge clk ) begin
        case (write_MUX_sel)
            //2'b01 :  write_back <= ;
            2'b10 :  write_back <= DM_data_out;
            2'b11 :  write_back <= alu_out;
            default: write_back <= 32'bx;
        endcase
    end
    
endmodule
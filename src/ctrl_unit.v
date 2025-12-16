module ctrl_unit #(
    parameter
        WIDTH = 32
) (
    input                     clk, rst,
    input   [6:0]             opcode,
    input   [2:0]             func3, 
    input   [6:0]             func7,
    input   [1:0]             branch_op,
    input                     alu_valid,
    
    output  reg [4:0]         alu_op,
    output  reg               DM_write_en,
    output  reg [1:0]         port_A_sel,
    output  reg               port_B_sel,
    output  reg [1:0]         write_MUX_sel,
    output  reg               PC_MUX_sel,
    output  reg [1:0]         imm_en,
    output  reg               reg_write_en,
    output  reg               branch_en,
    output  reg               PC_stall,
    output  reg               alu_en,
    output  reg               reg_read_en,
    output  reg [2:0]         load_store_op,
    output  reg               DM_read_en
);

    reg [5:0] inst_type;
    reg [4:0] state;
    reg       branch;

// process stages
    localparam IF = 5'b00001;
    localparam ID = 5'b00010;
    localparam EX = 5'b00100;
    localparam MEM = 5'b01000;  
    localparam WB = 5'b10000;
    
    // for test 
    initial begin
      state = IF;
      inst_type = 0;
    end

// instruction type
    localparam R_type = 6'b000001;
    localparam I_type = 6'b000010;
    localparam S_type = 6'b000100;
    localparam B_type = 6'b001000;
    localparam U_type = 6'b010000;
    localparam J_type = 6'b100000;


    always @(posedge clk ) begin
      if (rst) begin
        port_A_sel <= 2'b00;
        port_B_sel <= 0;
        DM_write_en <= 0;
        write_MUX_sel <= 0;
        imm_en <= 0;
        reg_read_en <= 0;
        reg_write_en <= 0;
        alu_en <= 0;
        branch_en <= 0;
        load_store_op <= 0;
        branch <= 0;
        PC_MUX_sel <= 0;
        alu_op <= 0;

        PC_stall <= 1;

      end else if (state == IF && ~rst) begin
        port_A_sel <= 2'b00;
        port_B_sel <= 0;
        DM_write_en <= 0;
        write_MUX_sel <= 0;
        imm_en <= 0;
        reg_read_en <= 0;
        reg_write_en <= 0;
        alu_en <= 0;
        branch_en <= 0;
        load_store_op <= 0;
        branch <= 0;
        PC_MUX_sel <= 0;
        alu_op <= 0;

        PC_stall <= 1;
        
        state <= ID;

      end else if (state == ID && ~rst) begin
        case (opcode)																													
            // R-type
            7'b0110011 : begin
              inst_type <= R_type;
              port_A_sel <= 2'b01;
              port_B_sel <= 0;
              reg_read_en <= 1;

              // func3_R (func3, func7, alu_op);
              // test
                case (func3)
                3'b000: begin
                  case (func7)
                    7'b0000000: begin // addition
                      alu_op <= 5'b00001;
                    end
                    7'b0100000: begin // subtraction
                      alu_op <= 5'b00011;
                    end
                  endcase 
                end
                3'b001: begin // shift left logical
                  alu_op <= 5'b01110; 
                end
                3'b010: begin // signed comparison
                  alu_op <= 5'b00101;
                end
                3'b011: begin // unsigned comparison
                  alu_op <= 5'b00101;
                end
                3'b100: begin // bitwise XOR
                  alu_op <= 5'b01101;
                end
                3'b101: begin
                  case (func7)
                    7'b0000000: begin // logical shift right
                      alu_op <= 5'b01111;
                    end
                    7'b0100000: begin
                      alu_op <= 5'b10000; // arithmetic right shift
                    end
                  endcase 
                end
                3'b110: begin // bitwise OR
                  alu_op <= 5'b01100;
                end
                3'b111: begin // bitwise AND
                  alu_op <= 5'b01010;
                end
              endcase
              state <= EX;
            end

            // I-type
            7'b0010011 : begin // immediate arithmetic
              inst_type <= I_type;
              imm_en <= 2'b01;
              reg_read_en <= 1;
              port_A_sel <= 2'b01;
              port_B_sel <= 1;

              //func3_I_A (func3, func7, alu_op);
              // test
              case (func3)
                3'b000: begin // add imm
                  alu_op <= 5'b00001; 
                end
                3'b001: begin // shift left logical
                  // test
                  alu_op <= 5'b00001; 
                end
                3'b010: begin // set if less than (signed)
                  
                end
                3'b011: begin // set if less than (unsigned)
                  
                end
                3'b100: begin // bitwise XOR with imm
                  alu_op <= 5'b01101;
                end
                3'b101: begin
                  case (func7)
                     7'b0000000: begin // shift right logical
                        alu_op <= 5'b01111; 
                     end
                     7'b0100000 : begin // shift right arithmetic 
                        alu_op <= 5'b10000;
                     end
                  endcase
                end
                3'b110: begin // bitwise OR with imm
                  alu_op <= 5'b01100;
                end
                3'b111: begin // bitwise AND with imm
                  alu_op <= 5'b01010;
                end
              endcase
              state <= EX;
            end
            7'b0000011 : begin // immediate load
              inst_type <= I_type;
              imm_en <= 2'b01;
              port_A_sel <= 2'b00;
              port_B_sel <= 1;

	              //func3_I_L (func3, load_store_op);
	              // test
                case (func3)
                3'b000: begin // load byte (sign-extend)
                  load_store_op <= 3'b100;
                end
                3'b001: begin // load half-word (sign-extend)
                  load_store_op <= 3'b101;
                end
                3'b010: begin // load word
                  load_store_op <= 3'b000;
                end
                3'b100: begin // load byte (zero-extend)
                  load_store_op <= 3'b110;
                end
                3'b101: begin // load half-word (zero-extend)
                  load_store_op <= 3'b111;
                end
              endcase
              alu_op <= 5'b11000;
              state <= EX;
            end
            7'b1100111 : begin // jump and link register
              inst_type <= I_type;
              state <= EX;
            end

            // S-type
            7'b0100011 : begin
              inst_type <= S_type;
              imm_en <= 2'b10;

              reg_read_en <= 1;
              DM_write_en <= 1;

              port_A_sel <= 2'b11;
              port_B_sel <= 0;

              // (func3, load_store_op);
              // test
              case (func3)
                3'b000: begin // store byte (8-bit)
                  load_store_op <= 3'b001;
                end
                3'b001: begin // store half-word (16-bit)
                  load_store_op <= 3'b010;
                end
                3'b010: begin // store word (32-bit)
                  load_store_op <= 3'b011;
                end
              endcase
              alu_op <= 5'b11000;
              state <= EX;
            end

            // B-type
            7'b1100011 : begin
              inst_type <= B_type;

              reg_read_en <= 1;
              branch_en <= 1;
              port_A_sel <= 2'b10;
              port_B_sel <= 1;

	            //func3_B(func3, branch);
              //test
              case (func3)
                3'b000: begin // branch if equal
                  if (branch_op == 3'b001) begin
			              alu_op <= 5'b00001;
                    state <= EX;
                  end
                  else state <= IF;
                end
                3'b001: begin // branch if not equal
                  if (branch_op == 3'b010) begin
                    alu_op <= 5'b00001;
                    state <= EX;
                  end
                  else state <= IF;
                end
                3'b100: begin // branch if less than (signed)
                  if (branch_op == 3'b011) begin
                    alu_op <= 5'b00001;
                    state <= EX;
                  end
                  else state <= IF;
                end
                3'b101: begin // branch if greater/equal (signed)
                  if (branch_op == 3'b100) alu_op <= 5'b00001;
                  else branch <= 0;
                end
                3'b110: begin // branch if less than (unsigned)
                  if (branch_op == 3'b101) begin
                    alu_op <= 5'b00001;
                    state <= EX;
                  end
                  else state <= IF;
                end
                3'b111: begin // branch if greater/equal (unsigned)
                  if (branch_op == 3'b110) begin
                    alu_op <= 5'b00001;
                    state <= EX;
                  end
                  else state <= IF;
                end
              endcase
/*
              if (branch) begin 
                alu_op <= 5'b00001;

                state <= EX;
              end
              else state <= IF;
            
*/
	    end

            // U-type
            7'b0010111 : begin
              inst_type <= U_type;

              state <= EX;
            end
            7'b0110111 : begin
              inst_type <= U_type;

              state <= EX;
            end

            // J-type
            7'b1101111 : begin
              inst_type <= J_type;
              imm_en <= 2'b11;

              port_A_sel <= 2'b10;
              port_B_sel <= 1;

              alu_op <= 5'b00001;

              state <= EX;
            end
        endcase
      end else if (state == EX && ~rst) begin
        alu_en <= 1;
        if (alu_valid) begin
          alu_en <= 0;
          case (inst_type)
             R_type: begin
               write_MUX_sel <= 2'b11;
               state <= WB;
             end
             I_type: begin
               write_MUX_sel <= 2'b11;
               state <= WB;
             end
             S_type: begin
               state <= MEM;
             end
             B_type: begin
               state <= IF;
	              PC_stall <= 0;
             end
             U_type: begin
                state <= IF;
		            PC_stall <= 0;
             end
             J_type: begin
                state <= IF;
		            PC_stall <= 0;
             end
          default: begin
            state <= EX; 
          end
          endcase
        end else begin 
          state <= EX;
        end
      end else if (state == MEM && ~rst) begin 
        DM_write_en <= 1;
        state <= IF;
	      PC_stall <= 0;
      end else if (state == WB && ~rst) begin
        reg_write_en <= 1;
        state <= IF;
	      PC_stall <= 0;
      end
    end
endmodule

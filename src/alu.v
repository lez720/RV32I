module alu #(
    parameter
            WIDTH = 32
) (
    input                   clk, rst, en,
    input   [WIDTH-1:0]     port_A, port_B,
    input   [WIDTH-28:0]    operation,

    output  reg  [WIDTH-1:0]     data_out,
    output  reg                  valid,
    output  reg                  Z_flag,
    output  reg                  G_flag,
    output  reg                  L_flag
);

  always @(posedge clk) begin
    if (rst) begin
      data_out <= 32'b0;
      valid <= 0;
      Z_flag <= 0;
      G_flag <= 0;
      L_flag <= 0;
    end
    else if (en) begin
      case (operation)
        5'b00001: begin // add
          data_out <= port_A + port_B; 
        end
        5'b00010: begin // negate
          data_out <= ~port_A;  
        end
        5'b00011: begin // subtract
          data_out <= port_A - port_B;  
        end
        5'b00100: begin // multiply
          data_out <= port_A * port_B; 
        end
        5'b00101: begin // compare
          data_out <= port_A - port_B;
          if (data_out == 0) begin
            Z_flag <= 1;
          end else if (data_out > 0) begin
            G_flag <= 1;
          end else if (data_out < 0) begin
            L_flag <= 1;
          end else begin
            Z_flag <= 0;
            G_flag <= 0;
            L_flag <= 0;
          end
        end
        5'b00110: begin // divide
          data_out <= port_A / port_B; 
        end
        5'b00111: begin // remainder
          data_out <= port_A % port_B; 
        end
        5'b01000: begin // AND
          data_out <= port_A && port_B; 
        end
        5'b01001: begin // NOT
          data_out <= ~port_A;
        end
        5'b01010: begin // OR
          data_out <= port_A || port_B; 
        end
        5'b01011: begin // XOR
          data_out <= port_A ^ port_B;
        end
        5'b01100: begin // shift left logical
          data_out <= port_A << 1;
        end
        5'b01101: begin // shift right logical
          data_out <= port_A >> 1;
        end
        5'b01110: begin // shift right arithmetic
          data_out <= port_A >>> 1;
        end 
        5'b01111: begin
          data_out <= port_B; // immediate to data memory address
        end
        5'b10000: begin // load upper immediate
          data_out <= port_A << 12;
        end
        5'b10001: begin // add upper immediate to PC
          data_out <= port_A + (port_B << 12);
        end
        5'b10010: begin // Jump
          data_out <= port_A + (port_B << 1);
        end
      default: begin
        data_out <= 32'b0;
      end
      endcase
      valid <= 1;
    end else begin 
      valid <= 0;
      Z_flag <= 0;
      G_flag <= 0;
      L_flag <= 0;
    end
  end

endmodule

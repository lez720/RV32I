module alu #(
    parameter
            WIDTH = 32
) (
    input                   clk, rst, en,
    input   [WIDTH-1:0]     port_A, port_B,
    input   [WIDTH-28:0]    operation,

    output  reg  [WIDTH-1:0]     data_out,
    output  reg                  valid,
    output  reg                  zero_flag,
    output  reg                  greater_flag,
    output  reg                  lesser_flag
);

  always @(posedge clk) begin
    if (rst) begin
      data_out <= 32'b0;
      valid <= 0;
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

          end else if (data_out > 0) begin

          end else if (data_out < 0) begin

          end else begin
            
          end
        end
        5'b00110: begin // multiply high unsigned
          
        end
        5'b00111: begin // multiply high unsigned signed
          
        end
        5'b01000: begin // divide
          data_out <= port_A / port_B; 
        end
        5'b01001: begin // remainder
          data_out <= port_A % port_B; 
        end
        5'b01010: begin // AND
          data_out <= port_A && port_B; 
        end
        5'b01011: begin // NOT
          data_out <= ~port_A;
        end
        5'b01100: begin // OR
          data_out <= port_A || port_B; 
        end
        5'b01101: begin // XOR
          data_out <= port_A ^ port_B;
        end
        5'b01110: begin // shift left logical
          data_out <= port_A << 1;
        end
        5'b01111: begin // shift right logical
          data_out <= port_A >> 1;
        end
        5'b10000: begin // shift right arithmetic
          data_out <= port_A >>> 1;
        end 
        5'b11000: begin
          data_out <= port_B; // immediate to data memory address
        end
      default: begin
        data_out <= 32'b0;
      end
      endcase
      valid <= 1;
    end else begin 
      valid <= 0;
    end
  end

endmodule

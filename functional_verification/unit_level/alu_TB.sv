class base;
  bit [4:0] opcode;
  rand bit [31:0] port_A, port_B;
  bit [31:0] result;

  bit [31:0] ex_result;

  logic rst, en, valid;

  logic Z_flag, G_flag, L_flag;

  string status;

  localparam ADD = 1;
  localparam NEG = 2;
  localparam SUB = 3;
  localparam MUL = 4;
  localparam COM = 5;
  localparam DIV = 8;
  localparam REM = 9;
  localparam AND = 10;
  localparam OR = 12;
  localparam XOR = 13;
  localparam SLL = 14;
  localparam SRL = 15;
  localparam SRA = 16;
  localparam IDM = 17;
  localparam LUI = 18;
  localparam AUIPC = 19;
  localparam JAL = 20;

 function void gen_input();
      port_A = $random;
      port_B = $random;
 endfunction

  function void display();
    case (opcode)
        ADD : ex_result = port_A + port_B;
        NEG : ex_result = ~port_A;
        SUB : ex_result = port_A - port_B;
        MUL : ex_result = port_A * port_B;
        COM : begin
	      ex_result = 0;
	      end
        DIV : ex_result = port_A / port_B;
        REM : ex_result = port_A % port_B;
        AND : ex_result = port_A && port_B;
        OR  : ex_result = port_A || port_B;
        XOR : ex_result = port_A ^ port_B;
        SLL : ex_result = port_A << 1;
        SRL : ex_result = port_A >> 1;
        SRA : ex_result = port_A >>> 1;
        IDM : ex_result = port_B;
        LUI : ex_result = port_A << 12;
        AUIPC : ex_result = port_A + (port_B << 12);
        JAL : ex_result = port_A + (port_B << 1);
        default: ex_result = ex_result;
      endcase

    if (result == ex_result) begin
      status = "Success";
    end else begin
      status = "Failed";
    end

    $display("No: | Status: %0s | Expected: %0d ", status, ex_result);
    $display("Port A : %0d       | Port B : %0d       | Actual : %0d       ",  port_A, port_B, result);
    $display(" "); 

  endfunction
endclass 

module alu_TB;

  logic clk;

  bit [4:0] opcode;
  bit [31:0] port_A, port_B;
  bit [31:0] result;

  bit [31:0] ex_result;

  logic rst, en, valid;

  logic Z_flag, G_flag, L_flag;

  

  alu alu_DUT (
    .clk(clk), .rst(rst), .en(en),
    .port_A(port_A), .port_B(port_B), .operation(opcode),
    .data_out(result),. valid(valid), .Z_flag(Z_flag),
    .G_flag(G_flag), .L_flag(L_flag)
    );

  always #15 clk = ~clk;

  base stim; 

  initial begin

    stim = new();
    
    clk <= 0;
    rst <= 1;
    en <= 0;
    opcode <= 0;

    #100;
 
    for ( int op = 0; op < 20; op++) begin

      rst <= 0;
      opcode <= opcode + 1; // increment to change opcode

      $display("Operation: %0h", opcode);
      for ( int i = 0; i < 50; i++) begin
        stim.opcode = opcode;
        stim.gen_input();

        port_A <= stim.port_A;
        port_B <= stim.port_B;
        stim.opcode <= opcode;

        en <= 1;

        #60; // wait for ALU output
        if (valid) begin
          stim.result = result;
          en <= 0;
          stim.display();
        end else begin
          stim.result = stim.result;
        end
        #30;
      end

      rst <= 1;
      port_A <= 0;
      port_B <= 0;
      #200;
    end
    
  end

endmodule

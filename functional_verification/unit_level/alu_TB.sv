
class base;
  bit [4:0] op_c;
  randc bit [31:0] port_A_c, port_B_c, out_c;

 // constraint op_const {op_c < 24;}

 function void display();
   $display("No:  | Operation : %0d       | Port A : %0d       | Port B : %0d       | Output : %0d       ", op_c, port_A_c, port_B_c, out_c);
 endfunction


 function void random(); // custom randomize() function (modelsim doesnt allow randomize, assertion, coverage)
   op_c = $random;
   port_A_c = $random;
   port_B_c = $random;
 endfunction

endclass 

module alu_TB;
  localparam WIDTH = 32;

  logic [WIDTH-1:0] port_A, port_B, out;

  logic [4:0] operation;

  logic en, rst, clk, valid;

  logic Z_flag, G_flag, L_flag;

  alu alu_DUT (.clk(clk), .rst(rst), .en(en),
        .port_A(port_A), .port_B(port_B), .operation(operation),
        .data_out(out),. valid(valid), .Z_flag(Z_flag),
        .G_flag(G_flag), .L_flag(L_flag));


  always #10 clk = ~clk;
	
  base BF;

  initial begin

    BF = new();
    
    rst = 1;
    en = 0;
    operation = 0;
    #30 clk = 0;
    #10 rst = 0;
        port_A = 0;
        port_B = 0;
        en = 1;

    $display("Operation: Addition");
    for ( int i = 0; i < 100 ; i++ ) begin
      en = 1;
      BF.random();
      operation = BF.op_c;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
      BF.out_c = out;
      BF.display();
      //$display("No: %0d | Operation : %0d       | Port A : %0d       | Port B : %0d       | Output : %0d       ", i, operation, port_A, port_B, out);
      #30;
      en = 0;
      #10;
    end
    rst = 1;
    #50;
    rst = 0;
    $display(" ");
    $display("Operation: Comparator");
    for ( int i = 0; i < 100 ; i++ ) begin
      en = 1;
      operation = 5'b00101;
      port_A = $random;
      port_B = $random;
      $display("No: %0d | Operation : %0d       | Port A : %0d       | Port B : %0d       | ZF : %0d |GF : %0d |LF : %0d |", i, operation, port_A, port_B, Z_flag, G_flag, L_flag);
      #30;
      en = 0;
      #10;
    end
  end
endmodule


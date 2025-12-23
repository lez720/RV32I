
class base;
  bit [4:0] op_c;
  randc bit [31:0] port_A_c, port_B_c;
  bit [31:0] out_c;

 // constraint op_const {op_c < 24;}

 function void display();
   $display("Operation : %0d       | Port A : %0d       | Port B : %0d       | Output : %0d       ", op_c, port_A_c, port_B_c, out_c);
 endfunction


 function void random(); // custom randomize() function (modelsim doesnt allow randomize, assertion, coverage)
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

  string status;

  string flag;

  logic [WIDTH-1:0] ans;

  alu alu_DUT (.clk(clk), .rst(rst), .en(en),
        .port_A(port_A), .port_B(port_B), .operation(operation),
        .data_out(out),. valid(valid), .Z_flag(Z_flag),
        .G_flag(G_flag), .L_flag(L_flag));


  always #15 clk = ~clk;
	
  base BF;

  initial begin

    BF = new();
    
    rst = 1;
    en = 0;
    operation = 0;
    clk = 0;
    #50 rst = 0;
        port_A = 0;
        port_B = 0;
        en = 1;

    $display("Operation: Addition");
    for ( int i = 0; i < 50 ; i++ ) begin
      if (~valid) begin
        en = 1;
      end else if (~rst && valid) begin
        en = 0;
        BF.random();
      end 
      operation = 5'b00001; // addition
      BF.op_c = operation;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
    
      
      ans = port_A + port_B;
      #20;
      if (valid) begin
      	if (out == ans) begin
          status = "Success";
      	end else begin
 	  status = "Failed";
      	end
        en = 0;
      end
      else en = 1;
      BF.out_c = out;
      $display("No: %0d | Status: %0s | Expected: %0d ", i, status, ans);
      BF.display();
   
      $display(" ");
    end
    rst = 1;
    port_A = 0;
    port_B = 0;
    #200;
    rst = 0;
    $display("Operation: Negate");
    for ( int i = 0; i < 50 ; i++ ) begin
      if (~valid) begin
       en = 1;
      end else  if (~rst && valid) begin
        en = 0;
        BF.random();
      end
      operation = 5'b00010; // negate
      BF.op_c = operation;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
      
      ans = ~port_A;
      #20;
      if (valid) begin
      	if (out == ans) begin
          status = "Success";
      	end else begin
 	  status = "Failed";
      	end
        en = 0;
      end
      else en = 1;
      BF.out_c = out;
      $display("No: %0d | Status: %0s | Expected: %0d ", i, status, ans);
      BF.display();
   
      $display(" ");
    end
    rst = 1;
    port_A = 0;
    port_B = 0;
    #200;
    rst = 0;
    $display("Operation: Subract");
    for ( int i = 0; i < 50 ; i++ ) begin
      if (~valid) begin
       en = 1;
      end else  if (~rst && valid) begin
        en = 0;
        BF.random();
      end
      operation = 5'b00011; // subraction

      BF.op_c = operation;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
      
      ans = port_A - port_B;
      #20;
      if (valid) begin
      	if (out == ans) begin
          status = "Success";
      	end else begin
 	  status = "Failed";
      	end
        en = 0;
      end
      else en = 1;
      BF.out_c = out;
      $display("No: %0d | Status: %0s | Expected: %0d ", i, status, ans);
      BF.display();
   
      $display(" ");
    end
    rst = 1;
    port_A = 0;
    port_B = 0;
    #200;
    rst = 0;
    $display("Operation: Multiplication");
    for ( int i = 0; i < 50 ; i++ ) begin
      if (~valid) begin
       en = 1;
      end else  if (~rst && valid) begin
        en = 0;
        BF.random();
      end 
      operation = 5'b00100; // multiplication

      BF.op_c = operation;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
      
      ans = port_A * port_B;
      #20;
      if (valid) begin
      	if (out == ans) begin
          status = "Success";
      	end else begin
 	  status = "Failed";
      	end
        en = 0;
      end
      else en = 1;
      BF.out_c = out;
      $display("No: %0d | Status: %0s | Expected: %0d ", i, status, ans);
      BF.display();
   
      $display(" ");
    end
    rst = 1;
    port_A = 0;
    port_B = 0;
    #200;
    rst = 0;
    $display("Operation: Comparation");
    for ( int i = 0; i < 50 ; i++ ) begin
      if (~valid) begin
       en = 1;
      end else  if (~rst && valid) begin
        en = 0;
        BF.random();
      end 
      operation = 5'b00101; // compare
    BF.op_c = operation;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
      
      ans = port_A - port_B;
    
      #20;
      if (valid) begin
      	if (out == ans) begin
          status = "Success";
      	end else begin
 	  status = "Failed";
      	end
        en = 0;
      end
      else en = 1;
      BF.out_c = out;
      if (ans == 0) begin
	flag = "zero flag";
      end else if (ans > 0) begin
	flag = "GT flag";
      end else if (ans < 0) begin
	flag = "LT flag";
      end
      $display("No: %0d | Status: %0s | Expected: %0d ", i, status, ans);
      $display(" Expected FLAG: %0s | ZF: %0d | GTF: %0d | LTF: %0d | Out: %0d", flag, Z_flag, G_flag, L_flag, out);
   
      $display(" ");
    end
    rst = 1;
    port_A = 0;
    port_B = 0;
    #200;
    rst = 0;
    $display("Operation: Divide");
    for ( int i = 0; i < 50 ; i++ ) begin
      if (~valid) begin
       en = 1;
      end else  if (~rst && valid) begin
        en = 0;
        BF.random();
      end 
      operation = 5'b01000; // division

      BF.op_c = operation;
      port_A = BF.port_A_c;
      port_B = BF.port_B_c;
      
      ans = port_A / port_B;
      #20;
      if (valid) begin
      	if (out == ans) begin
          status = "Success";
      	end else begin
 	  status = "Failed";
      	end
        en = 0;
      end
      else en = 1;
      BF.out_c = out;
      $display("No: %0d | Status: %0s | Expected: %0d ", i, status, ans);
      BF.display();
   
      $display(" ");
    end

  end
endmodule


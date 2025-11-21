module inst_mem #(
    parameter
            WIDTH = 8,
            DEPTH = 32
) (
    /*
    input               clk, rst, 
    
    
    input                inst_store,
    input   [WIDTH+24:0] data_in,
    */
    input   [WIDTH+23:0] addr,

    output  [WIDTH+23:0] data_out
);

localparam addr2 = 1;
localparam addr3 = 2;
localparam addr4 = 3;

reg [WIDTH-1:0] inst_mem_block  [DEPTH-1:0];


// preloaded instructions for simulation
initial begin
  inst_mem_block[0] = 8'b00010011; // write 10 in x4  
  inst_mem_block[1] = 8'b00000010;
  inst_mem_block[2] = 8'b10100000; // 00101
  inst_mem_block[3] = 8'b00000000; // 01010

  inst_mem_block[4] = 8'b10010011; // write 15 in x5
  inst_mem_block[5] = 8'b00000010;
  inst_mem_block[6] = 8'b11110000;
  inst_mem_block[7] = 8'b00000000; // 0001111

  inst_mem_block[8] = 8'b10110011; // add x3, x4, x5
  inst_mem_block[9] = 8'b00000001;
  inst_mem_block[10] = 8'b01010010; // 00011
  inst_mem_block[11] = 8'b00000000; // 0000000 00101 00100 000 00011 0110011
/*
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;

  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;

  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;

  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;

  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;  
  inst_mem_block[0] = 8'b;

  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
  inst_mem_block[0] = 8'b;
*/
end

/*
always @(posedge clk ) begin
    if (inst_store) begin
        inst_mem_block[addr] <= data_in [7:0];
        inst_mem_block[addr+1] <= data_in [15:8];
        inst_mem_block[addr+2] <= data_in [23:16];
        inst_mem_block[addr+3] <= data_in [31:24];
    end
end
*/



assign data_out[7:0]   = inst_mem_block[addr];
assign data_out[15:8]  = inst_mem_block[addr+addr2];
assign data_out[23:16] = inst_mem_block[addr+addr3];
assign data_out[31:24] = inst_mem_block[addr+addr4];

/*
assign data_out[7:0] = inst_store ? inst_mem_block[addr] : 8'b00000000;
assign data_out[15:8] = inst_store ? inst_mem_block[addr+1] : 8'b00000000;
assign data_out[23:16] = inst_store ? inst_mem_block[addr+2] : 8'b00000000;
assign data_out[31:24] = inst_store ? inst_mem_block[addr+3] : 8'b00000000;

*/
endmodule

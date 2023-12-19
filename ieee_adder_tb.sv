///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	EE 5320 Final Project
//	Shafiqul Alam Khan
//	Due Date: 12/04/23
//	Objectives:
//	> Testbench for adding two IEEE format floating numbers.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Create module name
module ieee_add_tb();
  reg clk_tb;
  reg rst_tb; 
  reg enable_tb; 
  reg correct;
  reg [31:0] ieee_1_tb;
  reg [31:0] ieee_2_tb;
  
  wire state_tb;
  wire [31:0] ieee_sum_tb;
  
// Instantiate the ieee adder
  ieee_adder dut(
    .enable(enable_tb),
    .rst(rst_tb),
    .clk(clk_tb),
    .ieee_1(ieee_1_tb),
    .ieee_2(ieee_2_tb),
    .ieee_sum(ieee_sum_tb),
    .state(state_tb));
  
// Set initial values and dump variables
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,ieee_adder);
    clk_tb = 0;
    rst_tb = 1;
    enable_tb = 0;
    correct = 0;
    forever #15 clk_tb = ~clk_tb;
  end
  
// Set up code run time
  initial #200ns $finish;
  
// Test
// Give input for test
  initial begin
    #30;
    rst_tb = 0;
    enable_tb = 1;
    
    ieee_1_tb = 32'h4158_0000;
    ieee_2_tb = 32'h41BC_0000;

// Check output of test
    #30
    enable_tb = 0;
    while (state_tb != 0) #30;
    if (ieee_sum_tb == 32'h4214_0000) correct = 1;
    
  end
  endmodule
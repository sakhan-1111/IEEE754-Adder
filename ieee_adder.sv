///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	EE 5320 Final Project
//	Shafiqul Alam Khan
//	Due Date: 12/04/23
//	Objectives:
//	> Add two IEEE format floating numbers.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Create module name
module ieee_adder(
  input wire enable,
  input wire rst,
  input wire clk,
  input wire [31:0] ieee_1,
  input wire [31:0] ieee_2,
  output reg [31:0] ieee_sum,
  output reg state);
  
// Define registers
  reg [7:0] reg_exp_a;
  reg [7:0] reg_exp_b;
  reg [24:0] reg_mantissa_a;
  reg [24:0] reg_mantissa_b;
  reg [7:0] exp_sum;
  reg [25:0] man_sum;
  reg reg_exp_cond;
  reg reg_add_state;
  
// Define parameters
  parameter GT_EQ = 1'b1;
  parameter LT = 1'b0;
  parameter IDLE = 1'b0;
  parameter ADD = 1'b1;
  
// Compare the size of exponents of two inputs
  always @ (*) begin
    if(ieee_1[30:23] >= ieee_2[30:23])
      reg_exp_cond = GT_EQ;
    else
      reg_exp_cond = LT;
  end
  
// Set outputs
  always @ (*) begin
	// Overflow condition
    if (man_sum[25] == 1'b1) begin
      ieee_sum = {1'b0, exp_sum + 1, man_sum[24:2]};
    end
    
	// No overflow
    else begin
      ieee_sum = {1'b0, exp_sum, man_sum[23:1]};
    end
    state = reg_add_state;
  end
  
// Set up reset
// Here for rest pin = 1, set exponent a & b, mantissa a & b, exponent & mantissa sum and add state resistor to 0.
  always @ (posedge clk) begin
    if(rst == 1'b1) begin
      reg_exp_a <= 8'b0;
      reg_mantissa_a <= 24'b0;
      reg_exp_b <= 8'b0;
      reg_mantissa_b <= 24'b0;
      exp_sum <= 8'b0;
      man_sum <= 25'b0;
      reg_add_state <= 1'b0;
    end
  end
  
// Addition happens here
  always @ (posedge clk) begin
    if(rst == 1'b0) begin
      case(reg_add_state)
        IDLE: begin 
          if(enable == 1'b1) begin
            reg_add_state <= ADD;
            case(reg_exp_cond)
              GT_EQ: begin
                exp_sum <= ieee_1[30:23];
                reg_exp_a <= ieee_1[30:23];
                reg_mantissa_a[24:1] <= {1'b1, ieee_1[22:0]};
                
                reg_exp_b <= ieee_2[30:23];
                reg_mantissa_b[24:1] <= {1'b1, ieee_2[22:0]};
              end
              LT: begin
                exp_sum <= ieee_2[30:23];
                reg_exp_a <= ieee_2[30:23];
                reg_mantissa_a[24:1] <= {1'b1, ieee_2[22:0]};
                reg_exp_b <= ieee_1[30:23];
                reg_mantissa_b[24:1] <= {1'b1, ieee_1[22:0]};
              end
              default: begin
                reg_add_state <= IDLE;
              end
              endcase
          end
        end
        
        ADD: begin
          if (reg_exp_a != reg_exp_b) begin
            reg_mantissa_b <= reg_mantissa_b >> 1;
            reg_exp_b <= reg_exp_b + 1;
            reg_add_state <= ADD;
          end
          else begin
            man_sum <= reg_mantissa_a + reg_mantissa_b;
            reg_add_state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule 
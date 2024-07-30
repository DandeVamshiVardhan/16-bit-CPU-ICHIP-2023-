`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2024 14:02:07
// Design Name: 
// Module Name: CPU_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_TB();
reg clk,reset;
wire [15:0]data_out;
initial
begin 
clk=1'b0;
forever 
#5 clk=~clk;
end

initial 
begin 
reset=1'b1;
#2 reset=1'b0;
#2 reset=1'b1;
end


cpu_design dut1(reset,clk,data_out);




endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2024 16:45:23
// Design Name: 
// Module Name: calc_tb
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


module calc_tb();
 reg [7:0]x,y;
 reg zx,nx,zy,ny,f,no;
 reg reset;
 wire [7:0]o;
 wire zr,ng; 
 reg clk;
 reg [7:0]memory[0:179];
 
 //definig clk
 
 initial
 begin
 clk=1'b0;
 repeat(362) 
 #5 clk=~clk; 
 end 

reg [3:0]counter;  //declaring counter to decide input
reg [4:0]counter1;

always @(posedge clk,negedge reset)
begin
if(reset==1'b0||counter==4'b1001) counter<=4'b0;
else counter<=counter+1;
end

wire [8:0]k;

assign k=counter1*10+counter;
always @(posedge clk)
begin
memory[k]<=o;
end



always @(posedge clk,negedge reset)   
 begin
 if(reset==1'b0) counter1<=5'b0;   
 else if(counter==4'b1001)  if(counter1==5'b10001) counter1<=5'b0;
                            else          counter1<=counter1+1;
 end  
 
// X,Y defining
 
 
 always @*
 begin
 case(counter)
 4'b0000:begin x=8'b11111111; y=8'b11001111; end
 4'b0001:begin x=8'b01110110; y=8'b00101010; end
 4'b0010:begin x=8'b11100111; y=8'b11010101; end
 4'b0011:begin x=8'b11000111; y=8'b11001010; end
 4'b0100:begin x=8'b00011100; y=8'b11110101; end
 4'b0101:begin x=8'b11011011; y=8'b00101011; end
 4'b0110:begin x=8'b11110111; y=8'b11011100; end
 4'b0111:begin x=8'b01010101; y=8'b10011011; end
 4'b1000:begin x=8'b10101010; y=8'b11011010; end
 4'b1001:begin x=8'b11001101; y=8'b11111111; end
 default:;
 endcase
 end 
   
 
 always @*
 begin
 case(counter1)
 5'b00000:{zx,nx,zy,ny,f,no}=6'b101010;
 5'b00001:{zx,nx,zy,ny,f,no}=6'b111111;
 5'b00010:{zx,nx,zy,ny,f,no}=6'b111010;
 5'b00011:{zx,nx,zy,ny,f,no}=6'b001100;
 5'b00100:{zx,nx,zy,ny,f,no}=6'b110000;
 5'b00101:{zx,nx,zy,ny,f,no}=6'b001101;
 5'b00110:{zx,nx,zy,ny,f,no}=6'b110001;
 5'b00111:{zx,nx,zy,ny,f,no}=6'b001111;
 5'b01000:{zx,nx,zy,ny,f,no}=6'b110011;
 5'b01001:{zx,nx,zy,ny,f,no}=6'b011111;
 5'b01010:{zx,nx,zy,ny,f,no}=6'b110111;
 5'b01011:{zx,nx,zy,ny,f,no}=6'b001110;
 5'b01100:{zx,nx,zy,ny,f,no}=6'b110010;
 5'b01101:{zx,nx,zy,ny,f,no}=6'b000010;
 5'b01110:{zx,nx,zy,ny,f,no}=6'b010011;
 5'b01111:{zx,nx,zy,ny,f,no}=6'b000111;
 5'b10000:{zx,nx,zy,ny,f,no}=6'b000000;
 5'b10001:{zx,nx,zy,ny,f,no}=6'b010101;
 endcase
 end
 

  
 initial 
 begin
    reset=1'b1;
 #2 reset=1'b0;
 #2 reset=1'b1;
 end
 
 
 //simulate upto 1800 ns and check file generated in project simultion folder 
 // in this address for this "E:\vivado files\I_CHIP_2023_PS1\I_CHIP_2023_PS1.sim\sim_1\behav\xsim"
 always @(k)
 $writememb("output.txt",memory,0,179);
 
 calc_design d1(x,y,zx,nx,zy,ny,f,no,zr,ng,o);   
    
   
endmodule

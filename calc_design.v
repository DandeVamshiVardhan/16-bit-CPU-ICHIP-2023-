`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2024 16:44:44
// Design Name: 
// Module Name: calc_design
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

//~(x+8'b11111111)=-x;  this is used to find exact combination of control bits

module calc_design( input [7:0]x,y,
      input zx,nx,zy,ny,f,no,
      output wire zr,ng,
      output reg [7:0]o
);
  reg [7:0]x_v,y_v;
  
  always @*
  begin
   x_v=x;
   y_v=y;
   x_v={8{~zx}}&x_v;
   x_v=x_v^{8{nx}};
   y_v={8{~zy}}&y_v;
   y_v=y_v^{8{ny}};
  if(f)  o=x_v+y_v; else o=x_v&y_v;
   o=o^{8{no}};
  end
    
    
  //status signals output decided
  //check whether most significant bit is 1 or not for it to be negative
  assign zr=~|o;
  assign ng=o[7];

     
endmodule

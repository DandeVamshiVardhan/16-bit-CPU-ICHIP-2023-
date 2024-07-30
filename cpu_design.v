`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: bhu_university
// Engineer: 
// 
// Create Date: 25.05.2024 10:58:50
// Design Name:  processor
// Module Name: cpu_design
// Project Name: modelling a 16 bit processor
// Target Devices: 
// Tool Versions: digital
// Description: 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////


module cpu( input reset,clk,input [15:0]data_out,ir_am_alias,output reg[15:0]PC,AC,output reg eop);
  

                             // program counter
   
  
  
                                      // stores end of program
  

  wire zx,nx,zy,ny,f,no;
  wire zr,ng;
  wire [15:0]o;
  
 
  
  
  

     // instantiating of memory in the cpu 

  calc_design ALU(AC,data_out,zx,nx,zy,ny,f,no,zr,ng,o);  //instantiating ALU (ALGORITHIM LOGIC UNIT)

  controller ctrl(ir_am_alias[14:10],zx,nx,zy,ny,f,no);  // which controls alu
  
  


   
  reg ZR,NG;                   //register to store previous output signs 
  
  
  always @(posedge clk)        //decoding opcode
  if(eop) 
       begin
             AC<=o;    ZR<=zr;    NG<=ng;
          end
      
    
   
 
   
   
  wire jump_addr;                            //assigns 1 if address is to be jumped
  
  
 
  jump_address jump_calculator(ir_am_alias[14:10],ZR,NG,jump_addr); // instantiating of jump address calculator
  
  
   
   
  always @(negedge reset,posedge clk)          // procedural block for program counter and end of program...
  if(reset==1'b0) begin          PC<=10'b0;     eop<=1'b1;        end
                                        
  else 
  begin 
  if(eop)
        begin
               if(jump_addr==1'b1) PC<=ir_am_alias[9:0];   else PC<=PC+1'b1;
               eop<=~(ir_am_alias[14:10]==5'b10111);
         end 
    end
   

    
    
    
endmodule



module calc_design( input [15:0]x,y,  //calc design which should be used as alu in cpu
      input zx,nx,zy,ny,f,no,
      output wire zr,ng,
      output reg [15:0]o
);
  reg [15:0]x_v,y_v;
  
  always @*
  begin
   x_v=x;
   y_v=y;
   x_v={16{~zx}}&x_v;
   x_v=x_v^{16{nx}};
   y_v={16{~zy}}&y_v;
   y_v=y_v^{16{ny}};
  if(f)  o=x_v+y_v; else o=x_v&y_v;
   o=o^{16{no}};
  end
    
    
  //status signals output decided
  //check whether most significant bit is 1 or not for it to be negative
  assign zr=~|o;
  assign ng=o[15];

     
endmodule




module jump_address(input [4:0]ir_am_alias,input ZR,NG,output wr);

assign wr=(ir_am_alias[4:0]==5'b10100)|(ir_am_alias[4:0]==5'b10101&&ZR==1'b1)|(ir_am_alias[4:0]==5'b10110&&NG==1'b1);

endmodule



// memory modelling
module MEMORY(input [9:0]addr,input [15:0]data_in,input eop,clk,output [15:0]data_out,output [15:0]ir_am_alias);


reg [15:0] memory[0:1023];
wire [15:0]IR=memory[addr];
wire [9:0]memory_alias=memory[IR[9:0]];
assign ir_am_alias=(IR[15]==1'b1)?{IR[15:10],memory_alias}:IR;

wire wr=ir_am_alias[14]&(~ir_am_alias[13])&(~ir_am_alias[12])&ir_am_alias[11]&ir_am_alias[10];


initial                   //loading data into memory
begin                     // files will be saved in the simulation folder of respective project folder
$readmemh("program.txt",memory,0,400);  
$readmemh("data.txt",memory,401,1023);
end


assign data_out=memory[ir_am_alias[9:0]];


always @(posedge clk)   // writing to the memory
if(eop&wr) memory[ir_am_alias[9:0]]<=data_in;


always @(eop)         //writing back to the output file,text file can be found at the simulation folder of this project
$writememh("output.txt",memory,401,1023);


endmodule 





module controller(input [4:0]ir_am_alias,output reg zx,nx,zy,ny,f,no);



// controller that controls operation to be done
  always @(ir_am_alias)
  begin
  case(ir_am_alias)
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
  5'b10010:{zx,nx,zy,ny,f,no}=6'b110000;
  default :{zx,nx,zy,ny,f,no}=6'b001100;
  endcase 
  end


endmodule

module cpu_design(input clk,reset);

wire [15:0]AC,data_out,ir_am_alias;
wire [9:0]PC;
wire eop;
cpu cpu1(reset,clk,data_out,ir_am_alias,PC,AC,eop);

MEMORY  m1(PC,AC,eop,clk,data_out,ir_am_alias);


endmodule
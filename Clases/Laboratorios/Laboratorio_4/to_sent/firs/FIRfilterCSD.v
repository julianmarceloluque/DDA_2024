// Module uses CSD coefficients for implementing the FIR filter
module FIRfilterCSD
  (
   input signed [15:0]      x,
   input                    clk,rst_n,
   output reg signed [31:0] yncsd);
   reg signed [31:0]        yncsd_v;
   reg signed [31:0]        xn [0:4];
   reg signed [31:0]        pp[0:18];
   reg signed [15:0]        x_reg;
   always @(posedge clk) begin
      if(!rst_n)begin
         x_reg <= 0;
         // Tap delay line of FIR filter
         xn[0] <= 0;
         xn[1] <= 0;
         xn[2] <= 0;
         xn[3] <= 0;
         xn[4] <= 0;
         yncsd <= 0; // registering the output
      end
      else begin
         x_reg <= x;
        // Tap delay line of FIR filter
         xn[0] <= $signed({{16{x_reg[15]}},x_reg});
         xn[1] <= xn[0];
         xn[2] <= xn[1];
         xn[3] <= xn[2];
         xn[4] <= xn[3];
         yncsd <= yncsd_v; // registering the output
      end // else: !if(!rst_n)
   end
   
   always @ (*)
     begin
        // Generating PPs using CSD representation of coefficients
        // PP using 4 significant digits in CSD value of coefficient h0
        pp[0 ] = xn[0];
        pp[1 ] = xn[0]<<<2;
        pp[2 ] = xn[0]<<<5;
        pp[3 ] = $signed((xn[0]==32'hffff8000) ? 32'h00008000 : -xn[0])<<<8;
        pp[4 ] = xn[0]<<<10;
        // PP using CSD value of coefficient h1
        pp[5 ] = $signed((xn[1]==32'hffff8000) ? 32'h00008000 : -xn[1])<<<9;
        pp[6 ] = xn[1]<<<13;
        // PP using 4 significant digits in CSD value of coefficient h2
        pp[7 ] = $signed((xn[2]==32'hffff8000) ? 32'h00008000 : -xn[2])<<<1;
        pp[8 ] = $signed((xn[2]==32'hffff8000) ? 32'h00008000 : -xn[2])<<<3;
        pp[9 ] = $signed((xn[2]==32'hffff8000) ? 32'h00008000 : -xn[2])<<<6;
        pp[10] = $signed((xn[2]==32'hffff8000) ? 32'h00008000 : -xn[2])<<<9;
        pp[11] = xn[2]<<<14;
        // PP using CSD value of coefficient h3
        pp[12] = $signed((xn[3]==32'hffff8000) ? 32'h00008000 : -xn[3])<<<9;
        pp[13] = xn[3]<<<13;
        // PP using 4 significant digits in CSD value of coefficient h4
        pp[14] = xn[4];
        pp[15] = xn[4]<<<2;
        pp[16] = xn[4]<<<5;
        pp[17] = $signed((xn[4]==32'hffff8000) ? 32'h00008000 : -xn[4])<<<8;
        pp[18] = xn[4]<<<10;
        // Adding all the PPs, the design to be implemented in a 16:2 compressor
        yncsd_v = pp[0]+pp[1]+pp[2]+pp[3]+pp[4]+pp[5]+
                  pp[6]+pp[7]+pp[8]+pp[9]+pp[10]+pp[11]+
                  pp[12]+pp[13]+pp[14]+pp[15]+pp[16]+pp[17]+pp[18];
     end
endmodule

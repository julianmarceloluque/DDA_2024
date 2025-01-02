// Module uses multipliers to implement an FIR filter
module FIRfilter
  (
   input signed [15:0]      x,
   input                    clk,rst_n,
   output reg signed [31:0] yn);
   reg signed [15:0]        xn [0:4];
   wire signed [31:0]       yn_v;
   reg signed [15:0]        x_reg;
   // Coefficients of the filter
   wire signed [15:0]       h0 = 16'h0325;
   wire signed [15:0]       h1 = 16'h1e00;
   wire signed [15:0]       h2 = 16'h3DB6;
   wire signed [15:0]       h3 = 16'h1e00;
   wire signed [15:0]       h4 = 16'h0325;
   // Implementing filters using multiplication and addition operators
   assign yn_v = (h0*xn[0] + h1*xn[1] + h2*xn[2] + h3*xn[3] + h4*xn[4]);
   always @(posedge clk) begin
      if(!rst_n) begin
         xn[0] <= 0;
         xn[1] <= 0;
         xn[2] <= 0;
         xn[3] <= 0;
         xn[4] <= 0;
         x_reg <= 0;
         yn    <= 0;
      end
      else begin
         // Tap delay line of the filter
         x_reg <= x;
         xn[0] <= x_reg;
         xn[1] <= xn[0];
         xn[2] <= xn[1];
         xn[3] <= xn[2];
         xn[4] <= xn[3];
         // Registering the output
         yn <= yn_v;
      end // else: !if(!rst_n)
   end // always @ (posedge clk)

endmodule

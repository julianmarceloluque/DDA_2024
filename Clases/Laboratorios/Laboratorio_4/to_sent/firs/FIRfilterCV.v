// Module uses a global correction vector by eliminating sign extension logic
module FIRfilterCV
  (
   input signed [15:0]      x,
   input                    clk,rst_n,
   output reg signed [31:0] yn
   );
   reg signed [31:0]        yn_v;
   reg signed [15:0]        xn_0, xn_1, xn_2, xn_3, xn_4;
   reg signed [31:0]        pp[0:15];
   reg signed [15:0]        x_reg;
   // The GCV is computed for sign extension elimination
   reg signed [31:0]        gcv = 32'b0110_1111_0111_0000_0001_0000_1001_0000;
   always @(posedge clk) begin
      if(!rst_n) begin
         x_reg <= 0;
         xn_0  <= 0;
         xn_1  <= 0;
         xn_2  <= 0;
         xn_3  <= 0;
         xn_4  <= 0;
         yn    <= 0; // registering the output
      end
      else begin
        // Tap delay line of FIR filter
         x_reg <= x;
         xn_0 <= x_reg;
         xn_1 <= xn_0;
         xn_2 <= xn_1;
         xn_3 <= xn_2;
         xn_4 <= xn_3;
         yn <= yn_v; // registering the output
      end // else: !if(!rst_n)
   end
   always @ (*)
     begin
        // Generating PPs for 5 coefficients
        // PPs for coefficient h0 with sign extension elimination
        pp[0]= {5'b0, ~xn_0[15], xn_0[14:0], 11'b0};
        pp[1] = {7'b0, xn_0[15], ~xn_0[14:0], 9'b0};
        pp[2] = {10'b0, ~xn_0[15], xn_0[14:0],6'b0};
        pp[3] = {13'b0, ~xn_0[15], xn_0[14:0],3'b0};
        // PPs for coefficient h1 with sign extension elimination
        pp[4] = {2'b0, ~xn_1[15], xn_1[14:0], 14'b0};
        pp[5] = {6'b0, xn_1[15], ~xn_1[14:0], 10'b0};
        // PPs for coefficient h2 with sign extension elimination
        pp[6] = {1'b0, ~xn_2[15], xn_2[14:0], 15'b0};
        pp[7] = {6'b0, xn_2[15], ~xn_2[14:0], 10'b0};
        pp[8] = {9'b0, xn_2[15], ~xn_2[14:0], 7'b0};
        pp[9] = {12'b0, xn_2[15], ~xn_2[14:0], 4'b0};
        // PPs for coefficient h3 with sign extension elimination
        pp[10] = {2'b0, ~xn_3[15], xn_3[14:0], 14'b0};
        pp[11] = {6'b0, xn_3[15], ~xn_3[14:0], 10'b0};
        // PPs for coefficient h4 with sign extension elimination
        pp[12]= {5'b0, ~xn_4[15], xn_4[14:0], 11'b0};
        pp[13] = {7'b0, xn_4[15], ~xn_4[14:0], 9'b0};
        pp[14] = {10'b0, ~xn_4[15], xn_4[14:0],6'b0};
        pp[15] = {13'b0, ~xn_4[15], xn_4[14:0],3'b0};
        // Adding all the PPs with GCV
        // The design to be implemented as Wallace or Dadda reduction scheme
          yn_v = pp[0]+pp[1]+pp[2]+pp[3]+
                 pp[4]+pp[5]+
                 pp[6]+pp[7]+pp[8]+pp[9]+
                 pp[10]+pp[11]+
                 pp[12]+pp[13]+pp[14]+pp[15]+gcv;
     end
endmodule

// Module using TDF structure and 3:2 compressors
module FIRfilterTDFComp
  (
   input signed [15:0]  x,
   input                clk,rst_n,
   output reg signed [31:0] yn);
   integer              i;
   reg signed [15:0]    xn;
   // Registers for partial sums, as filter is symmetric, thecoefficients are numbered
   // for 0, 1, 2, ... , 4 rather 4, 3, ... , 0
   reg signed [31:0]    sn_0, sn_1, sn_2, sn_3, sn_4;
   // Registers for partial carries
   reg signed [32:0]    cn_0, cn_1, cn_2, cn_3, cn_4;
   reg signed [31:0]    pp_0, pp_1, pp_2, pp_3, pp_4, pp_5,
       pp_6, pp_7, pp_8, pp_9, pp_10, pp_11,
       pp_12, pp_13, pp_14, pp_15;
   // Wires for compression tree for intermediate sums and carries
   reg signed [31:0]    s00, s01, s10, s11, s20, s200, s21, s30,
       s31, s40, s400, s41, s02, s22, s42;
   reg signed [32:0]    c00, c01, c10, c11, c20, c200, c21, c30,
       c31, c40, c400, c41, c02, c22, c42;
   // The GCV computed for sign extension elimination
   reg signed [31:0]    gcv = 32'b0110_1111_0111_0000_0001_0000_1001_0000;
   // Add final partial sum and carry using CPA
   //assign yn = cn_4+sn_4;
   always @(posedge clk) begin
      if(!rst_n)begin
         xn   <= 0;
         cn_0 <= 0;
         sn_0 <= 0;
         cn_1 <= 0;
         sn_1 <= 0;
         cn_2 <= 0;
         sn_2 <= 0;
         cn_3 <= 0;
         sn_3 <= 0;
         cn_4 <= 0;
         sn_4 <= 0;
         yn   <= 0;
      end
      else begin
         xn <= x; // register the input sample
         // Register partial sums and carries in two sets of registers for every coeff multiplication
         cn_0 <= c02;
         sn_0 <= s02;
         cn_1 <= c11;
         sn_1 <= s11;
         cn_2 <= c22;
         sn_2 <= s22;
         cn_3 <= c31;
         sn_3 <= s31;
         cn_4 <= c42;
         sn_4 <= s42;
         yn <= cn_4+sn_4;
      end // else: !if(!rst_n)
     end
   always@(*) begin
      // First level of 3:2 compressors, initialize 0 bit of all carries that are not used
      c00[0]=0; c10[0]=0; c20[0]=0; c200[0]=0; c30[0]=0; c40[0]=0;
      c400[0]=0;
      for (i=0; i<32; i=i+1)
        begin
           // 3:2 compressor at level 0 for coefficient 0
           {c00[i+1],s00[i]} = pp_0[i]+pp_1[i]+pp_2[i];
           // 3:2 compressor at level 0 for coefficient 1
           {c10[i+1],s10[i]} = pp_4[i]+pp_5[i]+sn_0[i];
           // 3:2 compressor at level 0 for coefficient 2
           {c20[i+1],s20[i]} = pp_6[i]+pp_7[i]+pp_8[i];
           {c200[i+1],s200[i]} = pp_9[i]+sn_1[i]+cn_1[i];
           // 3:2 compressor at level 0 for coefficient 3
           {c30[i+1],s30[i]} = pp_10[i]+pp_11[i]+sn_2[i];
           // 3:2 compressor at level 0 for coefficient 4
           {c40[i+1],s40[i]} = pp_12[i]+pp_13[i]+pp_14[i];
           {c400[i+1],s400[i]} = pp_15[i]+sn_3[i]+cn_3[i];
        end
      c01[0]=0; c11[0]=0; c21[0]=0; c31[0]=0; c41[0]=0;
      // Second level of 3:2 compressors
      for (i=0; i<32; i=i+1)
        begin
           // For coefficient 0
           {c01[i+1],s01[i]} = c00[i]+s00[i]+pp_3[i];
           // For coefficient 1: complete
           {c11[i+1],s11[i]} = c10[i]+s10[i]+cn_0[i];
           // For coefficient 2
           {c21[i+1],s21[i]} = c20[i]+s20[i]+c200[i];
           // For coefficient 3: complete
           {c31[i+1],s31[i]} = c30[i]+s30[i]+cn_2[i];
           // For coefficient 4
           {c41[i+1],s41[i]} = c40[i]+s40[i]+c400[i];
        end
      // Third level of 3:2 compressors
      c02[0]=0; c22[0]=0; c42[0]=0;
      for (i=0; i<32; i=i+1)
        begin
           // Add global correction vector
           {c02[i+1],s02[i]} = c01[i]+s01[i]+gcv[i];
           // For coefficient 2: complete
           {c22[i+1],s22[i]} = c21[i]+s21[i]+s200[i];
           // For coefficient 4: complete
           {c42[i+1],s42[i]}= c41[i]+s41[i]+s400[i];
        end
   end
   always @(*) begin
      // Generating PPs for 5 coefficients
      // PPs for coefficient h0 with sign extension elimination
      pp_0 = {5'b0, ~xn[15], xn[14:0], 11'b0};
      pp_1 = {7'b0, xn[15], ~xn[14:0], 9'b0};
      pp_2 = {10'b0, ~xn[15], xn[14:0],6'b0};
      pp_3 = {13'b0, ~xn[15], xn[14:0],3'b0};
      // PPs for coefficient h1 with sign extension elimination
      pp_4 = {2'b0, ~xn[15], xn[14:0], 14'b0};
      pp_5 = {6'b0, xn[15], ~xn[14:0], 10'b0};
      // PPs for coefficient h2 with sign extension elimination
      pp_6 = {1'b0, ~xn[15], xn[14:0], 15'b0};
      pp_7 = {6'b0, xn[15], ~xn[14:0], 10'b0};
      pp_8 = {9'b0, xn[15], ~xn[14:0], 7'b0};
      pp_9 = {12'b0, xn[15], ~ xn[14:0], 4'b0};
      // PPs for coefficient h3 with sign extension elimination
      pp_10 = {2'b0, ~xn[15], xn[14:0], 14'b0};
      pp_11 = {6'b0, xn[15], ~xn[14:0], 10'b0};
      // PPs for coefficient h4 with sign extension elimination
      pp_12 = {5'b0, ~xn[15], xn[14:0], 11'b0};
      pp_13 = {7'b0, xn[15], ~xn[14:0], 9'b0};
      pp_14 = {10'b0, ~xn[15], xn[14:0],6'b0};
      pp_15 = {13'b0, ~xn[15], xn[14:0],3'b0};
   end
endmodule

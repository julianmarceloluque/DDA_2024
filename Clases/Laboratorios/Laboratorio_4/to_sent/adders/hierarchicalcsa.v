module hierarchicalcsa(a, b, cin, sum_r, c_out_r, clk);
   input [15:0] a,b;
   input cin,clk;
   output reg c_out_r; output reg [15:0] sum_r;
   wire          c4,c8,c8_0,c8_1,c12_0,c12_1,c16_0, c16_1, c16L2_0, c16L2_1;
   wire [15:4]   sumL1_0, sumL1_1; wire [15:12]  sumL2_0, sumL2_1;
   reg [15:0]    a_r,b_r; reg cin_r; wire c_out; wire [15:0] sum;
   always@(posedge clk)begin
      a_r <= a; b_r <= b; cin_r <= cin; sum_r <= sum; c_out_r <= c_out; end
   // Level one of hierarchical CSA
   assign {c4,sum[3:0]} = a_r[3:0] + b_r[3:0] + cin_r;
   assign {c8_0, sumL1_0[7:4]}= a_r[7:4] + b_r[7:4] + 1'b0;
   assign {c8_1, sumL1_1[7:4]}= a_r[7:4] + b_r[7:4] + 1'b1;
   assign {c12_0,sumL1_0[11:8]}= a_r[11:8] + b_r[11:8] + 1'b0;
   assign {c12_1,sumL1_1[11:8]}= a_r[11:8] + b_r[11:8] + 1'b1;
   assign {c16_0, sumL1_0[15:12]}= a_r[15:12] + b_r[15:12] + 1'b0;
   assign {c16_1, sumL1_1[15:12]}= a_r[15:12] + b_r[15:12] + 1'b1;
   // Level two of hierarchical CSA
   assign c8 = c4 ? c8_1 : c8_0;
   assign sum[7:4] = c4 ? sumL1_1[7:4]: sumL1_0[7:4];
   // Selecting sum and carry within a group
   assign c16L2_0 = c12_0 ? c16_1 : c16_0;
   assign sumL2_0 [15:12] = c12_0? sumL1_1[15:12] : sumL1_0[15:12];
   assign c16L2_1 = c12_1 ? c16_1 : c16_0;
   assign sumL2_1 [15:12] = c12_1? sumL1_1[15:12]: sumL1_0[15:12];
   // Level three selecting the final outputs
   assign c_out = c8 ? c16L2_1 : c16L2_0;
   assign sum[15:8]=c8?{sumL2_1[15:12],sumL1_1[11:8]}:{sumL2_0[15:12],sumL1_0[11:8]};
endmodule

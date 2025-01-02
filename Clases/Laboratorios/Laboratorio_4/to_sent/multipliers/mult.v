module mult
  (
   input signed [5:0]       a,b,
   output reg signed [10:0] prod,
   input                    clock);

   reg signed [5:0]     a_d,b_d;

   always@(posedge clock) begin
      a_d  <= a;
      b_d  <= b;
      prod <= a_d * b_d;
   end

endmodule

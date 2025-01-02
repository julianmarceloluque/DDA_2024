module bcla
  # (parameter N = 16)
   (input      [N-1:0] a,b,
    input              c_in,
    input              clk,
    output reg [N-1:0] sum_r,
    output reg         c_out_r);
   reg [N-1:0]         a_r,b_r;
   reg                 c_in_r;
   reg [N-1:0]         p, g, P, G;
   reg [N:0]           c;
   reg [N-1:0]         sum;
   reg                 c_out;
   integer             i;
   always@(posedge clk) begin
      c_in_r  <= c_in;
      a_r     <= a;
      b_r     <= b;
      c_out_r <= c_out;
      sum_r   <= sum;
   end
   always@(*) begin
      for (i=0;i<N;i=i+1)
        begin
           // Generate all ps and gs
           p[i]= a_r[i] ^ b_r[i];
           g[i]= a_r[i] & b_r[i];
        end
   end
   always@(*) begin
      // Linearly apply dot operators
      P[0] = p[0];
      G[0] = g[0];
      for (i=1; i<N; i=i+1) begin
         P[i]= p[i] & P[i-1];
         G[i]= g[i] | (p[i] & G[i-1]) ;
      end
   end
   always@(*) begin
      //Generate all carries and sum
      c[0]=c_in_r;
      for(i=0;i<N;i=i+1)
        begin
           c[i+1] = G[i] | (P[i] & c[0]);
           sum[i] = p[i] ^ c[i];
        end
      c_out = c[N];
   end
endmodule

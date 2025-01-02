module rca
  #(parameter W=16)
   (input              clk,
    input [W-1:0]      a, b,
    input              cin,
    output reg [W-1:0] s_r,
    output reg         cout_r);

   wire [W-1:0]        s;
   wire                cout;
   reg [W-1:0]         a_r, b_r;
   reg                 cin_r;

   assign {cout,s} = a_r + b_r + cin_r;

   always@(posedge clk)
     begin
        a_r    <= a;
        b_r    <= b;
        cin_r  <= cin;
        s_r    <= s;
        cout_r <= cout;
     end
endmodule

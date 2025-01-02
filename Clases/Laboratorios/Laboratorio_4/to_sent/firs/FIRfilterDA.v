/* Distributed arithmetic FIR filter*/
module FIRfilterDA
  (
   input [15:0]             x,
   input                    clk_g, rst_n,
   output reg signed [31:0] yn
   //output                   valid
   );
   reg signed [31:0]        acc; // accumulator
   reg [15:0]               xn_0, xn_1, xn_2, xn_3,xn_4; // tap delay line
   reg [16:0]               rom_out;
   reg [4:0]                address;
   reg [15:0]               xn_b;
   reg [3:0]                contr;
   wire signed [31:0]       sum;
   wire                     msb;
   // DA ROM storing all the pre-computed values
   always@(*) begin
      //lsb of all registers
      address={xn_4[0],xn_3[0],xn_2[0],xn_1[0],xn_0[0]};
      case(address)
        5'd0: rom_out =17'h0;
        5'd1: rom_out =17'h325;
        5'd2: rom_out =17'h1e00;
        5'd3: rom_out =17'h2125;
        5'd4: rom_out =17'h3db6;
        5'd5: rom_out =17'h40db;
        5'd6: rom_out =17'h5bb6;
        5'd7: rom_out =17'h5edb;
        5'd8: rom_out =17'h1e00;
        5'd9: rom_out =17'h2125;
        5'd10: rom_out =17'h3c00;
        5'd11: rom_out =17'h3f25;
        5'd12: rom_out =17'h5bb6;
        5'd13: rom_out =17'h5edb;
        5'd14: rom_out =17'h79b6;
        5'd15: rom_out =17'h7cdb;
        5'd16: rom_out =17'h325;
        5'd17: rom_out =17'h64a;
        5'd18: rom_out =17'h2125;
        5'd19: rom_out =17'h244a;
        5'd20: rom_out =17'h40db;
        5'd21: rom_out =17'h4400;
        5'd22: rom_out =17'h5edb;
        5'd23: rom_out =17'h6200;
        5'd24: rom_out =17'h2125;
        5'd25: rom_out =17'h244a;
        5'd26: rom_out =17'h3f25;
        5'd27: rom_out =17'h424a;
        5'd28: rom_out =17'h5edb;
        5'd29: rom_out =17'h6200;
        5'd30: rom_out =17'h7cdb;
        5'd31: rom_out =17'h8000;
        default: rom_out= 17'bx;
      endcase
   end // always@ (*)

   //assign valid = ~(|contr); // output data valid signal
   assign msb = (&contr);  // msb = 1 for contr = fff
   assign sum = (acc + {rom_out^{17{msb}}, 16'b0} + // takes 1's complement for msb
                 {15'b0, msb, 16'b0}) >>> 1; // add 1 at 16th bit location for 2's complement logic
   always @ (posedge clk_g) begin
      if(!rst_n) begin
         // Initializing all the registers
         xn_0  <= 0;
         xn_1  <= 0;
         xn_2  <= 0;
         xn_3  <= 0;
         xn_4  <= 0;
         acc   <= 0;
         contr <= 0;
         yn    <= 0;
         xn_b  <= 0;
      end
      else begin
         contr <= contr + 1;
         // Implementing daisy-chain for DA computation
         xn_0 <= {xn_b[contr], xn_0[15:1]};
         xn_1 <= {xn_0[0]    , xn_1[15:1]};
         xn_2 <= {xn_1[0]    , xn_2[15:1]};
         xn_3 <= {xn_2[0]    , xn_3[15:1]};
         xn_4 <= {xn_3[0]    , xn_4[15:1]};
         // A single adder should be used instead, shift right to multiply by 2-i
         if(&contr) begin
            yn    <= sum;
            acc   <= 0;
            xn_b  <= x;
         end
         else begin
            acc  <= sum;
            xn_b <= xn_b;
         end
      end
   end
endmodule

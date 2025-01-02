module boothMult
  (
   input [5:0]       i_multiplier,
   input [5:0]       i_multiplicand,
   output reg [10:0] o_product,
   input             clock);

   parameter WIDTH = 6;
   reg signed [6:0]     pps [0:2];
   reg [10:0]    correctionVector;
   reg [2:0]     recoderOut[2:0];
   wire [6:0]    a, a_n;
   wire [6:0]    _2a, _2a_n;
   reg [5:0]     multiplier;
   reg [5:0]     multiplicand;
   wire [10:0]   product;

   always@(posedge clock) begin
      multiplier     <= i_multiplier;
      multiplicand   <= i_multiplicand;
      o_product      <= product;
   end

   /*
    1 x multiplicand, sign extend the multiplicand, and flip the sign bit
    2 x multiplicand, shift a by 1 and flip the sign bit
    1 x multiplicand, sign extend multiplicand and then flip all bits except the
    sign bit
    2 x multiplicand, shift a by 1, flip all the bits except the sign bit
    */
   assign a_n   = { multiplicand[WIDTH-1], ~multiplicand};
   assign a     = { ~multiplicand[WIDTH-1], multiplicand};
   assign _2a_n = {multiplicand[WIDTH-1], ~multiplicand[WIDTH-2:0], 1'b0};
   assign _2a   = { ~multiplicand[WIDTH-1],multiplicand[WIDTH-2:0], 1'b0};
   // simply add all the PPs and CV, to complete the functionality of the multiplier,
   // for optimized implementation, a reduction tree should be used for compression
   assign product = pps[0] + {pps[1],2'b00} + {pps[2],4'b0000} + correctionVector;

   always@*
     begin
        // compute booth recoded bits
        recoderOut[0] = RECODERfn ({multiplier[1:0],1'b0});
        recoderOut[1] = RECODERfn (multiplier[3:1]);
        recoderOut[2] = RECODERfn (multiplier[5:3]);
        // generate pps and correction vector
        GENERATE_PPtk (recoderOut[0], a, _2a, a_n, _2a_n, pps[0],
                       correctionVector[1:0]);
        GENERATE_PPtk (recoderOut[1], a, _2a, a_n, _2a_n, pps[1],
                       correctionVector[3:2]);
        GENERATE_PPtk (recoderOut[2], a, _2a, a_n, _2a_n, pps[2],
                       correctionVector[5:4]);
        // pre-computed CV for sign extension elimination
        correctionVector[10:6] = 5'b01011;
        //correctionVector[10:6] = 5'b00000;
     end
   /*
    ******************************************************
    * task: GENERATE_PPtk
    * input: multiplicand, multiplicand one's complement
    * recoderOut: output from bit-pair recoder
    * output: correctionVector:add bitsfor2'scomplementcorrection
    * output: ppi: ith partial product
    ******************************************************
    */
   task GENERATE_PPtk;
      input [2:0] recoderOut;
      input [WIDTH:0] a;
      input [WIDTH:0] _2a;
      input [WIDTH:0] a_n;
      input [WIDTH:0] _2a_n;
      output [WIDTH:0] ppi;
      output [1:0]     correctionVector;
      reg [WIDTH-1:0]  zeros;
      begin
         zeros = 0;
         case(recoderOut)
           3'b000:
             begin
                ppi = {1'b1,zeros};
                //ppi = {1'b0,zeros};
                correctionVector = 2'b00;
             end
           3'b001:
             begin
                ppi = a;
                correctionVector = 2'b00;
             end
           3'b010:
             begin
                ppi = _2a;
                correctionVector = 2'b00;
             end
           3'b110:
             begin
                ppi = _2a_n;
                correctionVector = 2'b10;
                //correctionVector = 2'b00;
             end
           3'b111:
             begin
                ppi = a_n;
                correctionVector = 2'b01;
                //correctionVector = 2'b00;
             end
           default:
             begin
                ppi = 'bx;
                correctionVector = 2'bx;
             end
         endcase
      end
   endtask
   /*
    ******************************************************
    * Function: RECODERfn
    * input:one bit pair of multiplier with high order bit of previous pair,for
    *first pair a zero is appended as previous bit
    * output:Booth recoded output in radix-4 format, according to the following
    table
    * ****************************************************** */
   function [2:0] RECODERfn;
      input [2:0] recoderIn;
      begin
         case(recoderIn)
           3'b000: RECODERfn = 3'b000;
           3'b001: RECODERfn = 3'b001;
           3'b010: RECODERfn = 3'b001;
           3'b011: RECODERfn = 3'b010;
           3'b100: RECODERfn = 3'b110;
           3'b101: RECODERfn = 3'b111;
           3'b110: RECODERfn = 3'b111;
           3'b111: RECODERfn = 3'b000;
           default: RECODERfn = 3'bx;
         endcase
      end
   endfunction
endmodule

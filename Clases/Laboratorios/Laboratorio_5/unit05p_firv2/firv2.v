`define CASE1
`define CASE2

//(* dont_touch = "True" *)
module firv2(
           o_data,
           i_data,
           i_enable,
           clock
           );

   parameter NB_DATA   = 8;
   parameter NBF_DATA  = 7;
   parameter NB_COEFF  = 8;
   parameter NBF_COEFF = 7;
   parameter N_COEFFS  = 15;

   localparam NB_DOT       = NB_DATA + NB_COEFF;
   localparam NBF_DOT      = NBF_DATA + NBF_COEFF;
   localparam NB_ADD       = NB_DOT + 4;
   localparam NBF_ADD      = NBF_DOT;
   localparam NB_DATA_OUT  = NB_DATA;
   localparam NBF_DATA_OUT = NBF_DATA;
   localparam NBI_ADD      = NB_ADD-NBF_ADD;
   localparam NBI_DATA_OUT = NB_DATA_OUT-NBF_DATA_OUT;
   localparam NB_SAT       = NBI_ADD-NBI_DATA_OUT;

   output reg signed [NB_DATA_OUT - 1 : 0] o_data;
   input [NB_DATA                 - 1 : 0] i_data;
   input                                   i_enable;
   input                                   clock;

   reg signed  [NB_DATA - 1 : 0] data_r;
   reg signed [NB_COEFF  - 1 : 0] coeff[N_COEFFS - 1 : 0];
   wire signed [NB_DATA  - 1 : 0] datam[N_COEFFS - 1 : 0];
   
   `ifdef CASE1
      wire signed [NB_DOT   - 1 : 0] dots[N_COEFFS - 1 : 0];
    `else
      reg signed [NB_DOT   - 1 : 0] dots[N_COEFFS - 1 : 0];
    `endif

      
   (* srl_style = "srl_register" *)reg [NB_DATA*N_COEFFS - 1 : 0] shift_data;
   reg signed [NB_ADD           - 1 : 0] tmp_add_data;
   wire signed [NB_DATA_OUT-1:0] add_trunc;
   integer                        ptr;

 `ifdef CASE2
   `include "coeffs.v"
  `else
    always@(posedge clock) begin
    coeff[0]   <= 8'hff;
    coeff[1]   <= 8'hff;
    coeff[2]   <= 8'hff;
    coeff[3]   <= 8'hff;
    coeff[4]   <= 8'hff;
    coeff[5]   <= 8'hff;
    coeff[6]   <= 8'hff;
    coeff[7]   <= 8'hff;
    coeff[8]   <= 8'hff;
    coeff[9]   <= 8'hff;
    coeff[10]  <= 8'hff;
    coeff[11]  <= 8'hff;
    coeff[12]  <= 8'hff;
    coeff[13]  <= 8'hff;
    coeff[14]  <= 8'hff;
    end
  `endif 

   always@(posedge clock)
     data_r <= i_data;


   always@(posedge clock) begin
      if(i_enable)
        shift_data <= {{shift_data[(N_COEFFS-1)*NB_DATA - 1 -: (N_COEFFS-1)*NB_DATA]},data_r};
      else
        shift_data <= shift_data;
   end

   generate
      genvar                     ptr_dot;

      for(ptr_dot=0;ptr_dot<N_COEFFS;ptr_dot=ptr_dot+1) begin:dots_prod
         assign datam[ptr_dot] = shift_data[(ptr_dot+1)*NB_DATA - 1 -: NB_DATA];

         `ifdef CASE1
            assign dots[ptr_dot]  = datam[ptr_dot]*coeff[ptr_dot];
         `else
            always@(posedge clock)
               dots[ptr_dot]  <= datam[ptr_dot]*coeff[ptr_dot];
          `endif
      end

   endgenerate

   always@(*) begin
      tmp_add_data = $signed({NB_ADD{1'b0}});
      for(ptr=0;ptr<N_COEFFS;ptr=ptr+1) begin
         tmp_add_data = tmp_add_data + $signed({{NB_ADD-NB_DOT{dots[ptr][NB_DOT-1]}},dots[ptr]});
      end
   end
   
   assign add_trunc = (~|tmp_add_data[NB_ADD-1 -: NB_SAT+1] || &tmp_add_data[NB_ADD-1 -: NB_SAT+1]) ? 
                      tmp_add_data[NB_ADD-NB_SAT-1 -: NB_DATA_OUT] : (tmp_add_data[NB_ADD-1]) ? {{1'b1},{NB_DATA_OUT-1{1'b0}}}:{{1'b0},{NB_DATA_OUT-1{1'b1}}};

   always@(posedge clock) begin
      if(i_enable)      
        o_data <= add_trunc;
      else
        o_data <= o_data;
   end
endmodule // fir

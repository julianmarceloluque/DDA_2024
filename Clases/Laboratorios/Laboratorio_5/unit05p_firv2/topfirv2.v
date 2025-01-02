
module topfirv2(
              o_data,
              i_enable,
              i_reset,
              clock);

   parameter NB_DATA    = 8;
   parameter NBF_DATA   = 7;
   parameter NB_DATA_OUT = NB_DATA;
   
   output signed [NB_DATA_OUT - 1 : 0] o_data;
   input                               i_enable;
   input                               i_reset;
   input                               clock;

   wire [NB_DATA - 1 : 0]              data;


   signal_generator
     u_signal_generator
      (
         .i_clock(clock),
         .i_reset(~i_reset),
         .o_signal(data)
      );

   firv2
      u_firv2(
            .o_data     (o_data  ),
            .i_data     (data    ),
            .i_enable   (i_enable),
            .clock      (clock   )
            );



endmodule // topfir

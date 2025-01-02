

module tb_topfir();




   parameter NB_DATA    = 8;
   parameter NBF_DATA   = 7;
   parameter NB_COUNTER = 4;
   parameter NB_DATA_OUT = NB_DATA;


   wire [NB_DATA_OUT - 1 : 0] o_data;
   reg                        i_enable;
   reg                        i_reset;
   reg                        clock;


   initial begin
      i_reset  = 1'b0;
      i_enable = 1'b0;
      clock    = 1'b1;
      #600 i_reset  = 1'b1;
      #600 i_enable = 1'b1;
      #10000 $finish;
   end

   always #10 clock = ~ clock;

   topfirv2
     u_topfirv2(
              .o_data   (o_data),
              .i_enable (i_enable),
              .i_reset  (i_reset),
              .clock    (clock)
);


endmodule // tb_topfir

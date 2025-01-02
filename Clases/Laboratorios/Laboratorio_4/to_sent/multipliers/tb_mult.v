/* Nota: se considera un bit menos
 en el resultado del producto. */
module tb_mult();

   reg [5:0]   i_sampleA, i_sampleB;
   reg         clock;
   wire [10:0] o_mult;
   wire [10:0] o_booth;
   wire        compare;

   // Inicializacion
   initial begin
      i_sampleA = 1;
      i_sampleB = 0;
      clock     = 0;
      #10000 $finish;
   end

   // Estimulos  
  always@(posedge clock) begin
      i_sampleA <= $random;
      i_sampleB <= $random;
   end
   
   // Clock
   always
     #2 clock = ~clock;

   // Comparador de resultados
   assign compare = (o_mult==o_booth) ? 0 : 1;

   // Instancia de Multiplicadores
   mult
     u_mult
     (.a    (i_sampleA),
      .b    (i_sampleB),
      .prod (o_mult),
      .clock(clock)
      );

   boothMult
     u_boothMult
       (.i_multiplier   (i_sampleA),
        .i_multiplicand (i_sampleB),
        .o_product      (o_booth),
        .clock          (clock)
        );

endmodule

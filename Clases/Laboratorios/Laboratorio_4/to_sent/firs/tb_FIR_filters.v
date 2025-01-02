/* Nota1: La salida del filtro FIR
 FIRfilter y FIRfilterDA tienen un corrimiento
 porque los otros filtros utilizan
 un desplazamiento previo de la entrada. */

/*Nota2: Para poder alinear las salidas de todos los filtros
 se utilizan dos frecuencias de reloj. La frecuencia
 mas rapida se la utiliza en el FIR con aritmetica distribuida y
 el resto de los filtros con la frecuencia mas lenta.*/

module tb_FIRFilters();

   reg signed [15:0]  X_reg;
   reg                CLKg,CLKs;
   wire signed [31:0] YN, YNCV, YNCSD, YNTD, YNDA;
   reg                RST_N;
   reg [3:0]          counter;
   wire               compare;
   wire               compare1,compare2,compare3,compare4;

   // Inicialización
   initial
     begin
        CLKg     = 0; // bit clock
        CLKs     = 0; // sample clock
        RST_N    = 0;
        #100 RST_N = 1;
        #10000000 $finish;
     end

   // Clock
   always
     #2 CLKg = ~CLKg;  // fast clock
   always@(posedge CLKg)
     #32 CLKs = ~CLKs; // 16 times slower clock

   // Estimulos
   always @ (posedge CLKg)
     begin
        if(!RST_N) begin
           counter  <= 0;
           X_reg    <= 0;
        end
        else begin
           counter <= counter+1;
           if (counter == 15)
             X_reg <= $random; //X_reg+2;
        end
     end // always @ (posedge CLKg)

   // Comparacion de resultados
   assign compare =  (YN<<<1==YNCV && YN==YNCSD && YN<<<1==YNTD && YN==YNDA) ? 0 : 1;
   assign compare1 = (YN==YNCSD)   ? 0 : 1;
   assign compare2 = (YN<<<1==YNCV) ? 0 : 1;
   assign compare3 = (YN<<<1==YNTD) ? 0 : 1;
   assign compare4 = (YN==YNDA)    ? 0 : 1;
   // Instancias
   FIRfilter
     u_FIRfilter
       (.x      (X_reg),
        .rst_n  (RST_N),
        .clk    (CLKs),
        .yn     (YN)
        );

   FIRfilterCSD
     u_FIRfilterCSD
       (.x      (X_reg),
        .rst_n  (RST_N),
        .clk    (CLKs),
        .yncsd  (YNCSD)
        );

   FIRfilterCV
     u_FIRfilterCV
       (.x      (X_reg),
        .rst_n  (RST_N),
        .clk    (CLKs),
        .yn     (YNCV)
        );

   FIRfilterTDFComp
     u_FIRfilterTDFComp
       (.x      (X_reg),
        .rst_n  (RST_N),
        .clk    (CLKs),
        .yn     (YNTD));

   FIRfilterDA
     u_FIRfilterDA
       (.x      (X_reg),
        .clk_g  (CLKg),
        .rst_n  (RST_N),
        .yn     (YNDA)
        );


endmodule // tb_FIRFilters

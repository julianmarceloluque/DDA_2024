module count
    #(
        parameter NB_COUNT    = 32,
        parameter NB_SW         = 3
    )
    (
        output                  o_valid,

        input [NB_SW - 1 : 0]   i_sw    ,
        input                   i_reset ,
        input                   clock
    );
        // Localparam
        localparam R0       = (2**(NB_COUNT-10))-1  ; //! Limit of counter
        localparam R1       = (2**(NB_COUNT-9)) -1  ; //! Limit of counter
        localparam R2       = (2**(NB_COUNT-8)) -1  ; //! Limit of counter
        localparam R3       = (2**(NB_COUNT-7)) -1  ; //! Limit of counter

        //var
        wire [NB_COUNT - 1 : 0] limit_ref;

        //Modelado del MUX
        // NB_SW-1 : NB_SW-2 ---> Selecciona 2 bits continuos
        assign limit_ref =  (i_sw[2:1] == 2'b00) ? R0 :
                            (i_sw[2:1] == 2'b01) ? R1 :
                            (i_sw[2:1] == 2'b10) ? R2 : R3;

        // reg [NB_COUNTER - 1 : 0] limit_ref;
        // always@(*) begin
        //     case (i_sw[2:1])
        //         2'b00: limit_ref = R0; 
        //         2'b01: limit_ref = R1; 
        //         2'b10: limit_ref = R2; 
        //         2'b11: limit_ref = R3; 
        //         default: 
        //     endcase
        // end

        reg [NB_COUNT - 1 : 0]    counter;
        reg                         valid;
        

        //Modelado del counter 32bits
        always@(posedge clock) begin
            if (i_reset) begin
                counter <= {NB_COUNT{1'b0}}; //0
                valid   <= 1'b0;
            end
            else if (i_sw[0]) begin
                if(counter >= limit_ref) begin
                    counter <= {NB_COUNT{1'b0}};
                    valid   <= 1'b1;
                end
                else begin
                    counter <= counter + 1;
                    valid   <= 1'b0;
                end
            end
            else begin
                counter <= counter;
                valid   <= valid;
            end
        end

        assign o_valid = valid;

endmodule

//Magnitud para observa LED 2^20 o 2^22
//Al momento de sintetizar utilizamos la máxima expresión o máxima cantidad de bits
//Al momento de simular cambiamos el tipo de parámetro
module count
#(
    parameter NB_COUNTER = 32,
    parameter NB_SW      = 3
)
(
    output                  o_valid,
    
    input [NB_SW - 1 : 0]   i_sw   ,
    input                   i_reset,
    input                   clock
);

    // Localparam
    localparam R0 = 2**(NB_COUNTER-10)-1;
    localparam R1 = 2**(NB_COUNTER-11)-1;
    localparam R2 = 2**(NB_COUNTER-12)-1;
    localparam R3 = 2**(NB_COUNTER-13)-1;

    // localparam R3 = 3;
    // localparam R2 = 7;
    // localparam R1 = 15;
    // localparam R0 = 31;
    
    // Var
    wire [NB_COUNTER - 1 : 0] limit_ref;

    // i_sw[NB_SW-1:NB_SW-2]
    // Con esta expresion genero un multiplexor
    assign limit_ref =  (i_sw[2:1] == 2'b00) ? R0 :
                        (i_sw[2:1] == 2'b01) ? R1 :
                        (i_sw[2:1] == 2'b10) ? R2 : R3;

    // reg [NB_COUNTER - 1 : 0] limit_ref;
    // always@(*) begin
    //     case (i_sw(2:1))
    //         2'b00: limit_ref = R0;
    //         2'b01: limit_ref = R1;
    //         2'b10: limit_ref = R2;
    //         2'b11: limit_ref = R3;
    //         default: 2'b00: limit_ref = R0;
    //     endcase
    // end


    reg [NB_COUNTER - 1 : 0] counter;
    reg                      valid;
    always @(posedge clock) begin
        if(i_reset) begin
            counter <= {NB_COUNTER(1'b0)}; //0;
            valid <= 1'b0;
        end
        else if (i_sw[0]) begin
            if (counter >= limit_ref) begin
                counter <= {NB_COUNTER{1'b0}};
                valid <= 1'b1;
            end
            else begin
                counter <= counter + 1;
                valid <= 1'b0;
            end
        end
        else begin
            counter <= counter;
            valid <= valid;
        end
    end

    assign o_valid = valid;

endmodule
module shiftreg
#(
    parameter NB_LEDS = 4
)
(
    output [NB_LEDS - 1 : 0]    o_led   ,
    input                       i_valid ,
    input                       i_reset ,
    input                       clock
);

    //Vars
    reg [NB_LEDS - 1 : 0]   r_shiftreg;

    always @(posedge clock) begin
        if (i_reset) begin
            r_shiftreg <= {{NB_LEDS - 1{1'b0}}, 1'b1}; //1; //4'b0001;
        end
        else if (i_valid) begin
            // Opcion 1
            r_shiftreg      <= r_shiftreg << 1;
            r_shiftreg[0]   <= r_shiftreg[3];

            // Opcion 2
            r_shiftreg[1]    <= r_shiftreg[0];
            r_shiftreg[2]    <= r_shiftreg[1];
            r_shiftreg[3]    <= r_shiftreg[2];
            r_shiftreg[0]    <= r_shiftreg[3];
            
            // Opcion 3
            for (ptr=0; ptr<NB_LEDS-1; ptr=ptr+1) begin
                r_shiftreg(ptr + 1) <= r_shiftreg(ptr);
            end
            r_shiftreg[0]   <= r_shiftreg[NB_LEDS-1];

            // Opcion 4
            r_shiftreg      <= {r_shiftreg[2:0],r_shiftreg[3]};
        end
        else begin
            r_shiftreg      <= r_shiftreg;
        end
    end

    assign o_led = shiftreg;

endmodule
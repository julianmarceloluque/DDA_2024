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
    reg [NB_LEDS - 1 : 0]   r_ShiftReg;

    always @(posedge clock) begin
        if (i_reset) begin
            r_ShiftReg <= {{NB_LEDS - 1{1'b0}}, 1'b1}; //1; //4'b0001;
        end
        else if (i_valid) begin
            // Opcion 1
            r_ShiftReg      <= r_ShiftReg << 1;
            r_ShiftReg[0]   <= r_ShiftReg[3];

            // Opcion 2
            r_ShiftReg[1]    <= r_ShiftReg[0];
            r_ShiftReg[2]    <= r_ShiftReg[1];
            r_ShiftReg[3]    <= r_ShiftReg[2];
            r_ShiftReg[0]    <= r_ShiftReg[3];
            
            // Opcion 3
            for (ptr=0; ptr<NB_LEDS-1; ptr=ptr+1) begin
                r_ShiftReg(ptr + 1) <= r_ShiftReg(ptr);
            end
            r_ShiftReg[0]   <= r_ShiftReg[NB_LEDS-1];

            // Opcion 4
            r_ShiftReg      <= {r_ShiftReg[2:0],r_ShiftReg[3]};
        end
        else begin
            r_ShiftReg      <= r_ShiftReg;
        end
    end

    assign o_led = shiftreg;

endmodule
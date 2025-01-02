module shiftreg 
#(
    parameter NB_LEDS = 4
)
(
    output [3:0]    o_led  ,
    input           i_valid,
    input           i_reset,
    input           clock
);
    // Vars
    reg[NB_LEDS - 1 : 0] r_ShiftReg;
    integer ptr;

    always @(posedge clock) begin
        if (i_reset) begin
            r_ShiftReg <= {{NB_COUNTER-1{1'b0}},1'b1};
        end
        else if (i_valid) begin
            // Opt 1
            r_ShiftReg    <= r_ShiftReg << 1;
            r_ShiftReg[0] <= r_ShiftReg[3];

            // Opt 2
            r_ShiftReg[1] <= r_ShiftReg[0];
            r_ShiftReg[2] <= r_ShiftReg[1];
            r_ShiftReg[3] <= r_ShiftReg[2];
            r_ShiftReg[0] <= r_ShiftReg[3];

            // Opt 3
            for (ptr = 0; ptr<NB_LEDS; ptr=ptr+1) begin
                r_ShiftReg[ptr+1] <= r_ShiftReg[ptr];
            end
            r_ShiftReg[0] <= r_ShiftReg[NB_LEDS-1];

            // Opt 4
            r_ShiftReg <= {r_ShiftReg[2:0],r_ShiftReg[3]};
        end
        else begin
            r_ShiftReg <= r_ShiftReg;
        end
    end

    assign o_led = shiftreg;

endmodule
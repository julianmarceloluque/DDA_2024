//! @title Shift Register top level
//! @file SR_top.v
//! @author  Julian Luque
//! @date 07/01/2024
//! @version Unit01 - Verilog

//! - Shift Register controlled by Switchs 
//! - **ck_rst** is the system reset, which resets the counter and initializes the shiftregister (SR).
//! - **i_sw[0]** controls the enable (1) of the counter. The value (0) stops the systems without change of the current state of the counter and the SR.
//! - The SR is moved only when the counter reached some limit **R0-R3**. 
//! - The choice of the limit can be made at any time during operation.
//! - **i_sw[3]** chooses the color of the RGB LEDs.

// Definitions
`define N_LEDS 4
`define NB_SEL 2
`define NB_COUNT 32
`define NB_SW 4

module shiftleds
    #(
        // Paameters
        parameter N_LEDS    = `N_LEDS   ,
        parameter NB_SEL    = `NB_SEL   ,
        parameter NB_COUNT  = `NB_COUNT ,
        parameter NB_SW     = `NB_SW
    )
    (
        // Ports
        output [NB_LEDS - 1 : 0]    o_led  ,
        output [NB_LEDS - 1 : 0]    o_led_b,
        output [NB_LEDS - 1 : 0]    o_led_g,

        input [NB_SW    - 1 : 0]    i_sw,
        input                       i_reset,
        input                       clock
    );

    //localparam
    localparam R0   = 2**(NB_COUNTER-10)-1  ;
    localparam R1   = 2**(NB_COUNTER-11)-1  ;
    localparam R2   = 2**(NB_COUNTER-12)-1  ;
    localparam R3   = 2**(NB_COUNTER-13)-1  ;

    localparam SEL0 = `NB_SEL'h0            ;
    localparam SEL1 = `NB_SEL'h1            ;
    localparam SEL2 = `NB_SEL'h2            ;
    localparam SEL3 = `NB_SEL'h3            ;

    // Vars
    wire    [NB_COUNTER - 1 : 0]    limit_ref ;
    reg     [NB_LEDS    - 1 : 0]    shiftreg;
    reg     [NB_COUNT   - 1 : 0]    counter   ; //! Counter
    wire                            init      ; //! Internal Enable
    wire                            reset     ; //! Internal Reset

    //! Mux for limits
    // Op1
    // assign limit_ref =  (i_sw[2:1] == 2'b00) ? R0 :
    //                     (i_sw[2:1] == 2'b01) ? R1 :
    //                     (i_sw[2:1] == 2'b10) ? R2 : R3;

    // Op2
    assign ref_limit =  (i_sw[(NB_SW-1)-1 -: NB_SEL]==SEL0) ? R0 :
                        (i_sw[(NB_SW-1)-1 -: NB_SEL]==SEL1) ? R1 :
                        (i_sw[(NB_SW-1)-1 -: NB_SEL]==SEL2) ? R2 : R3;

    //! Reverse Reset
    assign reset     = ~i_reset ;

    //! Enable of System
    assign init      = i_sw[0]  ;

    //! Describes the behavior of the counterr and Shift Register
    always@(posedge clock or posedge reset) begin: countAndSr
        if(reset) begin
            counter  <= {NB_COUNT{1'b0}};
            shiftreg <= {{N_LEDS-1{1'b0}},{1'b1}};
        end
        else if(init) begin
            if(counter>=ref_limit)begin
                counter  <= {NB_COUNT{1'b0}};
                shiftreg <= {shiftreg[N_LEDS-2 -: N_LEDS-1],shiftreg[N_LEDS-1]};
            end
            else begin
                counter  <= counter + {{NB_COUNT-1{1'b0}},{1'b1}};
                shiftreg <= shiftreg;
            end
        end
        else begin
            counter  <= counter;
            shiftreg <= shiftreg;
        end 
    end

    //! Output to leds
    assign o_led   = shiftreg;

    //! Output to RGB leds
    assign o_led_b = (i_sw[3]==1'b0) ? shiftreg : {N_LEDS{1'b0}};
    assign o_led_g = (i_sw[3]==1'b1) ? shiftreg : {N_LEDS{1'b0}};

endmodule
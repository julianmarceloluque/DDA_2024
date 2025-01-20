//! @title Wrapper Top Level
//! @file wrapperr_top.v
//! @author  Julian Luque
//! @date 14/01/2024
//! @version Unit01 - Verilog - Lab01

//! - Shift Register controlled by Switchs 
//! - **ck_rst** is the system reset, which resets the counter and initializes the SR_topister (SR).
//! - **i_sw[0]** controls the enable (1) of the counter. The value (0) stops the systems without change of the current state of the counter and the SR.
//! - The SR is moved only when the counter reached some limit **R0-R3**. 
//! - The choice of the limit can be made at any time during operation.
//! - **i_sw[3]** chooses the color of the RGB LEDs.

module wrapper_top
    #(
        parameter NB_LEDS       = 4,
        parameter NB_COUNTER    = 32,  
        parameter NB_SW         = 4
    )
    (
        output [NB_LEDS - 1 : 0]    o_led  ,
        output [NB_LEDS - 1 : 0]    o_led_b,
        output [NB_LEDS - 1 : 0]    o_led_g,

        input [NB_SW    - 1 : 0]    i_sw,
        input                       i_reset,
        input                       clock
    );

    //! Mux sw and reset
    // VIO e ILA
    assign sw_to_top    =(selMux) ? sw_from_VIO : i_sw; // bus 4 bits
    assign reset        =(selMux) ? ~reset_from_VIO : ~i_reset;


    //! Top Instance
    top
    #(
        .NB_LEDS       (NB_LEDS),
        .NB_COUNTER    (NB_COUNTER),  
        .NB_SW         (NB_SW)
    )
    u_top
    (
        .o_led      (o_led),
        .o_led_b    (o_led_b),
        .o_led_g    (o_led_g),

        .i_sw       (sw_to_top),
        .i_reset    (reset),
        .clock      (clock)
    );

    //! VIO Instance
    vio
    u_vio
        (
            .clk_0              (clock)         ,
            .probe_in0_0        (o_led)         ,
            .probe_in1_0        (o_led_b)       ,
            .probe_in2_0        (o_led_g)       ,
            .probe_out0_0       (sw_from_VIO)   ,
            .probe_out1_0       (reset_from_VIO),
            .probe_out2_0       (selMux)   
        );

    //! ILA Instance
    ila
    u_ila
        (
            .clk_0      (clock),
            .probe0_0   (o_led),
            .probe1_0   (o_led_b),
            .probe2_0   (o_led_g)
        );

endmodule
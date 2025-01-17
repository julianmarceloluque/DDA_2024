//! @title Shift Register top level - Testbench
//! @file tb_top.v
//! @author Julian Luque
//! @date 15/01/2025
//! @version Unit01 - Verilog - Lab01

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

`timescale 1ns/100ps

module tb_top();

    // Parameters
    parameter N_LEDS    = `N_LEDS  ; //! Number of leds (4)
    parameter NB_SEL    = `NB_SEL  ; //! Number of bits of the selectors (2)
    parameter NB_COUNT  = `NB_COUNT; //! Number of bits of the counter (32)
    parameter NB_SW     = `NB_SW   ; //! Number of bits of the switch (4)

    wire [N_LEDS - 1 : 0] o_led    ; //! Leds
    wire [N_LEDS - 1 : 0] o_led_b  ; //! RGB Leds - Color Blue
    wire [N_LEDS - 1 : 0] o_led_g  ; //! RGB Leds - Color Green
    reg [NB_SW   - 1 : 0] i_sw     ; //! Switchs
    //reg  [4      - 1 : 0] i_sw     ; //! Switchs
    reg                   i_reset  ; //! Reset
    reg                   clock    ; //! System clock
    
    wire [NB_COUNT - 1  : 0] tb_count; //! Read internal counter

    //! Read the counter from module
    assign tb_count = tb_top.u_top.u_count.counter;
    
    //! Stimulus by initial
    initial begin: stimulus
    
        force tb_top.u_top.o_led = 4'b0001;
// whit R3 335ms between states
// Con     
        // Initialize inputs
        clock = 0;
        i_reset = 0; // Reset active (system not functioning)
        i_sw = 4'b0000;

        //#1000         ; // Wait 1u second
        //#1000000      ; // Wait 1m second
        //#1000000000   ; // Wait 1 second
        
        // Reset and enable the system
        #100        i_sw[3]     = 0     ; // Change to basic RGB color
        #100        i_reset     = 0     ; // Reset system
        #100        i_reset     = 1     ; // System starts functioning
        #100        i_sw[0]     = 1     ; // Enable system
        
        // Set limit R0
        #10         i_sw[2:1]   = 2'b00 ; // Select R0 limit
        #20000   i_sw[3]     = 1     ; // Change RGB color
        #20000                       ; // Delay
        
        // Reset and enable the system
        #100        i_sw[3]     = 0     ; // Change to basic RGB color
        #100        i_reset     = 0     ; // Reset system
        #100        i_reset     = 1     ; // System starts functioning
        #100        i_sw[0]     = 1     ; // Enable system      

        // Set limit R1
        #10         i_sw[2:1]   = 2'b01 ; // Select R0 limit
        #20000   i_sw[3]     = 1     ; // Change RGB color
        #20000                       ; // Delay
        
        // Reset and enable the system
        #100        i_sw[3]     = 0     ; // Change to basic RGB color
        #100        i_reset     = 0     ; // Reset system
        #100        i_reset     = 1     ; // System starts functioning
        #100        i_sw[0]     = 1     ; // Enable system        
        
        // Set limit R2
        #10         i_sw[2:1]   = 2'b10 ; // Select R0 limit
        #30000   i_sw[3]     = 1     ; // Change RGB color
        #30000                       ; // Delay
        
        // Reset and enable the system
        #100        i_sw[3]     = 0     ; // Change to basic RGB color
        #100        i_reset     = 0     ; // Reset system
        #100        i_reset     = 1     ; // System starts functioning
        #100        i_sw[0]     = 1     ; // Enable system        
        
        // Set limit R3
        #10         i_sw[2:1]   = 2'b11 ; // Select R0 limit
        #50000   i_sw[3]     = 1     ; // Change RGB color
        #50000                       ; // Delay
        
        // Reset and enable the system
        #100        i_sw[3]     = 0     ; // Change to basic RGB color
        #100        i_reset     = 0     ; // Reset system
        #100        i_reset     = 1     ; // System starts functioning
        #100        i_sw[0]     = 1     ; // Enable system        
        
        // Enable function test
        #100      i_sw        = 4'b0000; // The counter save the last state
        
        // End simulation
        #20000; // Wait 2 seconds
        $finish;

    end
    
    //! Clock generator
    always #5 clock = ~clock;

    //! Instance of shiftleds module
    top
    #(
        .N_LEDS   (N_LEDS  ),
        .NB_COUNT (NB_COUNT),
        .NB_SW    (NB_SW   ),
        .NB_SEL   (NB_SEL  )
    )
    u_top
    (
        .o_led     (o_led  )  ,
        .o_led_b   (o_led_b)  ,
        .o_led_g   (o_led_g)  ,
        .i_sw      (i_sw   )  ,
        .i_reset   (i_reset)  ,
        .clock     (clock  )
    );

endmodule 
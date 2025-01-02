
module mem_top
 #(
    // parameter NB_COUNT          = 32, //! NB del contador       32 bits
    parameter NB_ADDR_RAM_LOG   = 13, //! Longitud de memoria   15bits
    parameter NB_DATA_RAM_LOG   = 32, //! Ancho de memoria      32bits
    parameter NB_ENB_STEP       = 4 , //! Enables to counter    4bits
    parameter INIT_FILE         = ""
)
(
    output [NB_DATA_RAM_LOG - 1 : 0] o_log_data_from_ram         , //! Datos logueados              32bits
    output                           o_log_out_full_from_ram     , //! Memoria completa             1bit
    input                            i_log_in_ram_run_from_micro , //! Inicio de logueo             1bit
    input [NB_ADDR_RAM_LOG  - 1 : 0] i_log_read_addr_from_micro  , //! Direccion de lectura de BRAM 15bits
    input [NB_ENB_STEP      - 1 : 0] i_rf_enables_module         , //! Enables to counter           4bits
    input clock                                                  , //! Clock
    input cpu_reset                                                //! Reset desde el micro
);

    // Data Counter
    reg [NB_DATA_RAM_LOG - 1 : 0] counter_data;

    always @(posedge clock) begin
        if(cpu_reset)
            counter_data <= 0;
        else if(i_rf_enables_module[0])
            counter_data <= counter_data + 1;
        else if(i_rf_enables_module[1])
            counter_data <= counter_data + 2;
        else if(i_rf_enables_module[2])
            counter_data <= counter_data + 3;
        else if(i_rf_enables_module[3])
            counter_data <= counter_data + 4;
        else
            counter_data <= counter_data;
    end

    // Address Counter

    reg [NB_ADDR_RAM_LOG - 1 : 0] counter_addr;

    always @(posedge clock) begin
        if(cpu_reset || fsm_rst)    // <- Agregar control desde la FSM
            counter_addr <= 0;
        else if(fsm_enb)
            counter_addr <= counter_addr + 1;  // Agregar control desde la FSM
    end


    bram
        #(
            .RAM_WIDTH    (NB_DATA_RAM_LOG),
            .NB_RAM_DEPTH (NB_ADDR_RAM_LOG),
            .INIT_FILE    (INIT_FILE      )  
        )
    u_bram
    (
        .o_data      (o_log_data_from_ram       ),
        .i_data      (counter_data              ),
        .i_write_addr(counter_addr              ),
        .i_read_addr (i_log_read_addr_from_micro),
        .i_wr_enb    (fsm_enb                   ),  // Agregar control desde la FSM
        .i_rd_enb    (1'b1                      ),
        .clock       (clock                     )
    )


    fsm
        u_fsm
        (
            .o_fsm_rst                   (fsm_rst                    ),
            .o_fsm_enb                   (fsm_enb                    ),
            .o_full_mem                  (o_log_out_full_from_ram    ),
            .i_counter_addr              (counter_addr               ),
            .i_log_in_ram_run_from_micro (i_log_in_ram_run_from_micro),  // Deteccion por flanco 
            .i_reset                     (cpu_reset                  ),    
            .clock                       (clock                      )
        )


    /*
        // Usan en FSM
        always @(posedge clock) begin
            if(cpu_reset)    
                saveSignal <= 0;
            else if(enb) begin
                saveSignal <= i_log_in_ram_run_from_micro;
                if(!saveSignal && i_log_in_ram_run_from_micro)
                    // ejecuto
                else
                    // no hago nada

            end

        end
    */

endmodule
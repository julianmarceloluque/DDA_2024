`timescale 1ns / 1ps

`define OPTION1
//`define OPTION2

module tb_filter_iir();

   // Inputs
   reg                 clk, reset;
   reg signed [31:0]   x1;
   wire signed [31:0]  y;
   real 	              i;
   real 	              iptr; 
   real 	              aux1;
   
   // Instantiate the Unit Under Test (UUT)
   iir DUT(
	   .clk (clk),
	   .rst (reset),
	   .x   (x1),
	   .y   (y)
	   );

 
   // Generate Clock 
   always #10 clk = ~clk;   
   
   initial 
     begin

	reset = 1;
	clk   = 0;
	x1    = 32'd0;
	#40;
   @(posedge clk);
	reset = 0;
	#40;
	reset = 1;
	#40;
	
	`ifdef OPTION1
        for (i=0;i<4000;i=i+1) begin  
           aux1 = (0.5*$sin(2.0*3.1415926*i*15000.0/48000.0)+$sin(2.0*3.1415926*i*1000.0/48000.0))*(2**8);
           x1   = aux1;
           #10;
           //@(posedge clk);
         end
    `elsif OPTION2
        #40000;
    `endif
	
	
	$display("Simulation Finished");
	$display("");
	$finish;
     end // initial begin

    `ifdef OPTION2
       always@(posedge clk)begin
          if(!reset) begin
             iptr <= 0;
             aux1 <= 0;
             x1   <= 0;
          end 
          else begin
             iptr <= iptr + 1;
             aux1 <= (0.5*$sin(2.0*3.1415926*iptr*15000.0/48000.0)+$sin(2.0*3.1415926*iptr*1000.0/48000.0))*(2**8);
             x1    <= aux1;
          end
       end
     `endif
     
endmodule

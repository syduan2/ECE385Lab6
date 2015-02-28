module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset, Run, Continue;
logic [15:0] S;
logic [11:0] LED;
logic[19:0] A;
logic OE_out, WE_out, CE_out, UB_out, LB_out;
wire[15:0] Bus;
logic [6:0]HEX0,HEX1,HEX2,HEX3;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
SLC3 LC3(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 0;		// Toggle Rest
Run = 1;
Continue = 1;


#2 Reset = 1;

#2 Run = 0;
#2 Run = 1;

#20 Continue = 0;
#2 Continue = 1;


#20 Continue = 0;
#2 Continue = 1;
#20 Continue = 0;
#2 Continue = 1;
#20 Continue = 0;
#2 Continue = 1;
end 
endmodule

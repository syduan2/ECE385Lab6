//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//------------------------------------------------------------------------------


module ISDU (input Clk, 
                   Reset,
						 Run,
						 Continue,
									
				input [3:0]Opcode, 
				
				input IR_5, BEN,
				  
				output logic LD_MAR,
								 LD_MDR,
								 LD_IR,
								 LD_BEN,
								 LD_CC,
								 LD_REG,
								 LD_PC,
								 LD_LED,
									
				output logic GatePC,
								 GateMDR,
								 GateALU,
								 GateMARMUX,
									
				output logic [1:0]PCMUX,
				                  DRMUX,
									   SR1MUX,
										
				output logic SR2MUX,
								 ADDR1MUX,
				output logic [1:0] ADDR2MUX,
				
				output logic MARMUX,
				  
				output logic [1:0]ALUK,
				  
				output logic Mem_CE,
								 Mem_UB,
								 Mem_LB,
								 Mem_OE,
								 Mem_WE
				);
    enum logic [5:0] {Halted, PauseIR1, PauseIR2, S_18, S_33_1, S_33_2, S_33_3, S_35, S_32, 
		S_01, S_05, S_09, S_00, S_12, S_04_1, S_04_2, S_06, S_07, S_13, S_22, S_25_1, S_25_2, S_25_3, S_27, S_23, S_16_1, S_16_2, S_16_3}   State, Next_state;   // Internal state logic
	    
    always_ff @ (posedge Clk or posedge Reset )
    begin : Assign_Next_State
        if (Reset) 
            State = Halted;
        else 
            State = Next_state;
    end
   
	always_comb
    begin 
	    Next_state  = State;
	 
        unique case (State)
            Halted : 
	            if (Run) 
					Next_state = S_18;					  
            S_18 :
						Next_state = S_33_1;
            S_33_1 :
						Next_state = S_33_2;

            S_33_2 : 
						Next_state = S_35;
            S_35 :
                Next_state = S_32;
            PauseIR1 : // Pause to display IR on HEX (for week 1)
                if (~Continue) // Should be ContinueIR
                    Next_state = PauseIR1;
                else 
                    Next_state = PauseIR2;
					
            PauseIR2 : // Wait for ContinueIR to be released (for week 1)
                if (Continue) // Should be ContinueIR
                    Next_state = PauseIR2;
                else 
                    Next_state = S_18;
 
				S_32 : 
				case (Opcode)
					4'b0001 : // ADD 
					    Next_state = S_01;
					4'b0101 : // AND
						 Next_state = S_05;
					4'b1001 : // NOT
						 Next_state = S_09;
					4'b0000 : // BR
						 Next_state = S_00;
					4'b1100 : // JMP
						 Next_state = S_12;
					4'b0100 : // JSR
						 Next_state = S_04_1;
					4'b0110 : // LDR
						 Next_state = S_06;
					4'b0111 : // STR
						 Next_state = S_07;
					4'b1101 : // PAUSE
					    Next_state = PauseIR1;
					default:
						Next_state = S_33_1;
					
				endcase
            S_01 : 
					Next_state = S_18;
				S_00 :
					if(BEN)
						Next_state = S_22;
					else
						Next_state = S_18;
				S_06 :
					Next_state = S_25_1;
				S_25_1 :
					Next_state = S_25_2;
				S_25_2 :
					Next_state = S_27;
				S_07 :
					Next_state = S_23;
				S_23 : 
					Next_state = S_16_1;
				S_16_1:
					Next_state = S_16_2;
				S_16_2:
					Next_state = S_16_3;
				S_04_1:
					Next_state = S_04_2;
			default : 
					Next_state=S_18;
			
	     endcase
    end
   
    always_comb
    begin 
        //default controls signal values; within a process, these can be
        //overridden further down (in the case statement, in this case)
	    LD_MAR = 1'b0;
	    LD_MDR = 1'b0;
	    LD_IR = 1'b0;
	    LD_BEN = 1'b0;
	    LD_CC = 1'b0;
	    LD_REG = 1'b0;
	    LD_PC = 1'b0;
		 
	    GatePC = 1'b0;
	    GateMDR = 1'b0;
	    GateALU = 1'b0;
	    GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
	    PCMUX = 2'b00;
	    DRMUX = 2'b00;
	    SR1MUX = 2'b00;
	    SR2MUX = 1'b0;
	    ADDR1MUX = 1'b0;
	    ADDR2MUX = 2'b00;
	    MARMUX = 1'b0;
		 
	    Mem_OE = 1'b1; 
	    Mem_WE = 1'b1;
		 LD_LED=1'b0;
		 
	    case (State)
			Halted: ;
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00; //00 is +1
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b0;
			S_33_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
            end
            S_35 : 
                begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
                end
            PauseIR1: 
					LD_LED=1'b1;
            PauseIR2: 
					LD_LED=1'b1;
            S_32 : 
                LD_BEN = 1'b1;
            S_01 : //ADD
                begin
					SR1MUX = 2'b01; //added
					SR2MUX = ~IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC=1'b1;
                end
				S_05: //AND
					begin
					SR1MUX = 2'b01;
					SR2MUX = ~IR_5;
					ALUK=2'b01;
					GateALU=1'b1;
					LD_REG=1'b1;
					LD_CC=1'b1;
					end
				S_09: //NOT
					begin
					SR1MUX = 2'b01;
					SR2MUX = IR_5;
					ALUK=2'b10;
					GateALU=1'b1;
					LD_REG=1'b1;
					LD_CC=1'b1;
					end
				S_22: //BR
					begin
					ADDR1MUX=1'b1;
					ADDR2MUX=2'b01;
					PCMUX=2'b01;
					LD_PC=1'b1;
					end
				S_12: //JMP
					begin
					SR1MUX=2'b01;
					ALUK=2'b11;
					GateALU=1'b1;
					PCMUX=2'b10;
					LD_PC=1'b1;
					end
				S_04_1: //JSR
					begin
					 DRMUX=2'b10;
					 LD_REG=1'b1;
					 GatePC=1'b1;					
					end
				S_04_2:
					begin
						LD_PC=1'b1;
						ADDR2MUX=2'b00;
						ADDR1MUX=1'b1;
						PCMUX=2'b01;
					end
				S_06: //LDR
					begin
						ADDR1MUX=1'b0;
						ADDR2MUX=2'b10;
						SR1MUX=2'b01;
						MARMUX=1'b1;
						GateMARMUX=1'b1;
						LD_MAR=1'b1;
					end
				S_25_1 : 
					Mem_OE = 1'b0;
				S_25_2 : 
					begin 
						Mem_OE = 1'b0;
						LD_MDR = 1'b1;
					end
				S_27 :
					begin
						DRMUX=2'b00;
						LD_REG=1'b1;
						GateMDR=1'b1;
						LD_CC=1'b1;
					end
				S_07 : //STR
					begin
						ADDR1MUX=1'b0;
						ADDR2MUX=2'b10;
						SR1MUX=2'b01;
						MARMUX=1'b1;
						GateMARMUX=1'b1;
						LD_MAR=1'b1;
					end
				S_23 :
					begin
						SR1MUX=2'b00;
						ALUK=2'b11;
						GateALU=1'b1;
						LD_MDR=1'b1;
					end
				S_16_1 : 
					begin
						Mem_WE=1'b0;
						GateMDR=1'b1;
						
					end
				S_16_2 :
					begin
						Mem_WE=1'b0;
						GateMDR=1'b1;
					end
            default : ;
           endcase
       end 

	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule

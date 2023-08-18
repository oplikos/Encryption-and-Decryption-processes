// Create Date:    2019.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
// Revision:       2022.05.04
// Additional Comments: 	allows preloading with user constants
// This version is fully synthesizable and highly recommended.

/* parameters are compile time directives 
       this can be an any-width, any-depth reg_file: just override the params!
*/
module RegFile #(parameter W=8, D=3)(		 // W = data path width (leave at 8); D = address pointer width
  input                Clk,
                       Reset,	             // note use of Reset port
                       WriteEn,
  					   MoveToR,
  					   MoveFromR,
						lslWrite,
  input        [D-1:0] RaddrA,				 // address pointers
                       RaddrB,
                       Waddr,
  input		   [3:0]   LoadImd,
  input        [W-1:0] DataIn,
  output logic [W-1:0] DataOutA,			 // showing two different ways to handle DataOutX, for
  output logic [W-1:0] DataOutB				 //   pedagogic reasons only
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
  logic [W-1:0] Registers[2**D];	             // or just registers[16] if we know D=4 always. **We're doing D=3 since we have 8 registers**
  logic [2:0] tempRegAddr;
  
// combinational reads 
/* can use always_comb in place of assign
    difference: assign is limited to one line of code, so
	always_comb is much more versatile     
*/
  always_comb begin
    tempRegAddr = 3'b000;
    if(MoveFromR) begin
      tempRegAddr = RaddrA - 3'b010;
      DataOutA = Registers[tempRegAddr];		// Value of this doesn't matter
      DataOutB = Registers[tempRegAddr];		// Doing it this way helped make machine code nicer
    end
    else begin
    	DataOutA = Registers[RaddrA];	 // assign & always_comb do the same thing here 
    	DataOutB = Registers[RaddrB];    // can read from addr 0, just like ARM
    end
  end

  
  
// sequential (clocked) writes 
always_ff @ (posedge Clk)
  if (Reset) begin
	for(int i=0; i<2**D; i++) begin
	  Registers[i] <= 'h0;

// we can override this universal clear command with desired initialization values

    	Registers[1] <= 'b1000000;	//64
    	Registers[4] <= 'b00001001;	//9
    	Registers[7] <= 'b01001001;	//73
    end
  end
  else if (WriteEn && MoveFromR)	                         // works just like data_memory writes
    Registers[RaddrB] <= DataIn;
  else if(LoadImd == 4'b1111)								// Using the MOV command, which always stores into R0
    Registers[0] <= DataIn;
  else if(WriteEn && lslWrite)
    Registers[RaddrB] <= DataIn;
  else if(WriteEn)
	 Registers[Waddr] <= DataIn;

endmodule

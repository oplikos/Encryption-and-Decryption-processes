// Module Name:    ALU
// Project Name:   CSE141L
//
// Additional Comments:
//   combinational (unclocked) ALU

// includes package "Definitions"
// be sure to adjust "Definitions" to match your final set of ALU opcodes
//import Definitions::*;

module ALU #(parameter W=8)(
  input        [W-1:0]   InputA,       // data inputs
                         InputB,
  input[2:0]			 	OP,            // ALU opcode, part of microcode
  input                  SC_in,        // shift or carry in
  output logic [W-1:0]   Out,          // data output
  output logic          lslWrite, 
								Zero,         // output = zero flag    !(Out)
                        Parity,       // outparity flag        ^(Out)
                        Odd,          // output odd flag        (Out[0])
								SC_out,       // shift or carry out
								AZero		   // Mark if InputA is all zero
  // you may provide additional status flags, if desired
  // comment out or delete any you don't need
);

always_comb begin
// No Op = default
// add desired ALU ops, delete or comment out any you don't need
  Out = 8'b0;				                        // don't need NOOP? Out = 8'bx
  SC_out = 1'b0;		 							// 	 will flag any illegal opcodes
  AZero = 1'b0;
  case(OP)
    3'b100 : {SC_out,Out} = InputA + InputB;   // unsigned add with carry-in and carry-out
	 
    3'b101 : {SC_out,Out} = {1'b0,InputB[5:0],SC_in};       // shift left, fill in with SC_in, fill SC_out with InputA[7]
	
// for logical left shift, tie SC_in = 0
    3'b011 : Out = InputA ^ InputB;                    // bitwise exclusive OR
    3'b010 : Out = InputA & InputB;                    // bitwise AND
    3'b110 : begin									// Branch
      Out = InputB;
      AZero = ~|InputA;
    end
    3'b000 : Out = InputB;							// LDR
    3'b001 : Out = InputB;							// STR
    3'b111 : Out = InputB;							// Move
  endcase
end

assign Zero   = ~|Out;                  // reduction NOR	 Zero = !Out; 
assign Parity = ^Out[6:0];                   // reduction XOR
assign Odd    = Out[0];                 // odd/even -- just the value of the LSB
assign lslWrite = (OP == 3'b101);

endmodule

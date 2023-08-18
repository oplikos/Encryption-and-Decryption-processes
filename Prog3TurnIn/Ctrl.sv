// CSE141L
//import Definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0]   Instruction,	   // machine code
  input[ 7:0]   DatMemAddr,
    input[ 2:0]   RaddrA,//s
   				RaddrB,//s
  output logic  BranchEn  ,
			    RegWrEn   ,	   // write to reg_file (common)
			    MemWrEn   ,	   // write to mem (store only)
			    LoadInst  ,	   // mem or ALU to reg_file ?
			    TapSel    ,
			    Ack		  ,      // "done w/ program"
  				ImdLUT,
  				MoveToR,
  				MoveFromR,
  				ImdVal,
  output logic[2:0]  ALU_inst 
  );
  //assign DatMemAddr = RaddrA[RaddrB];
/* ***** All numerical values are completely arbitrary and for illustration only *****
*/

// alternative -- case format
// always_comb	begin
// // list the defaults here
//    Branch    = 'b0;
//    BranchEn  = 'b0;
//    RegWrEn   = 'b1; 
//    MemWrEn   = 'b0;
//    LoadInst  = 'b0;
//    TapSel    = 'b0;     //
//    PCTarg    = 'b0;     // branch "where to?"
//    case(Instruction[8:6])  // list just the exceptions 
//      3'b000:   begin
//                   MemWrEn = 'b1;   // store, maybe
// 				  RegWrEn = 'b0;
// 			   end
//      3'b001:   LoadInst = 'b1;  // load
//      3'b010:   begin end
//      3'b011:   begin end
//      3'b100:   begin end
//      3'b101:   begin end
//      3'b110:   begin end
// // no default case needed -- covered before "case"
//    endcase
// end

//assign Ack = ProgCtr == 971;
  
// alternative Ack = Instruction == 'b111_000_111

// ALU commands
//assign ALU_inst = Instruction[2:0]; 

// STR commands only -- write to data_memory
  assign MemWrEn = Instruction[8:6]==3'b001;

// all but STR and NOOP (or maybe CMP or TST) -- write to reg_file
  assign RegWrEn = (Instruction[8:6]!=3'b001) && (Instruction[8:6]!=3'b110);

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????; 
  assign LoadInst = Instruction[8:6]==3'b000;  // calls out load specially

assign TapSel = LoadInst &&	 DatMemAddr=='d62;

// branch every time instruction = 9'b?????1111;
  assign BranchEn = Instruction[8:6]==3'b110;

// reserve instruction = 9'b111111111; for Ack
  assign MoveToR = Instruction[8:4] == 5'b11100;
  assign MoveFromR = Instruction[8:4] == 5'b11101;
  assign ImdLUT = Instruction[8:5] == 4'b1111;
  assign Ack = &Instruction; // = ProgCtr == 385;

endmodule


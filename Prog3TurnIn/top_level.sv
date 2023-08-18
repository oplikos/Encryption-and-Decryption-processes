
// skeletal starter code top level of your DUT
module top_level(
  input clk, init, req,
  output logic ack);

  logic mem_wen, // memory writer enagle 
  		reg_wen, // write to register enable
  		zeroBit, // for Alu computation that results 0 
		lastZeroBit,
  		parityBit, // paraty fro alu
  		lastParityBit,
  		oddBit, // Alu 
  		crry, // Alu
  	    start, //start the program to fetch
  		loadInst, // load
  		branch, // active brach
  		branchEn, // active brach 
  		branchCond, //Alu to branch
    	imdLUT, // Immedat LUT
  		moveToR, // for  move comad alu
		lslWrite,
  		moveFromR; // for move comad alu
  logic [2:0] addressA, //reg1
  			  addressB; //reg2
  logic[7:0]  mem_addr, //where to store
  			  dataA,    // read from address 
  			  dataB,	//read from address
  			  dataIn,   // read from address
  			  aluOut,   // write to address
			  mem_out,    //Memory output
  			  LUTout,	// write to address
  branchTarget, // (positive or negative braching)
  			DatMemAddr; //the address where the data will be register
  wire[8:0]  machineCode; // our instruction
  logic[11:0] pctr;		  // temporary program counter

// populate with program counter, instruction ROM, reg_file (if used),
//  accumulator (if used), 

  // Data Memory
  DataMem DM(
    .Clk         (clk), 
    .Reset       (init), 
    .WriteEn     (mem_wen), 
    .DataAddress (aluOut), 
    .DataIn      (dataA), 
    .DataOut     (mem_out));
  
 
  //Mux for the register write data
  Mux mux(
    .in0			(aluOut),
    .in1			(mem_out),
    .in2			(LUTout),
    .sel			(loadInst),
    .selLUT			(imdLUT),
    .out			(dataIn));
  
  // Register File
  RegFile RF(
    .Clk			(clk),
    .Reset			(init),
    .WriteEn		(reg_wen),
    .RaddrA			(machineCode[5:3]), //reg1
    .RaddrB			(machineCode[2:0]),//reg2
    .Waddr			(machineCode[5:3]),//reg1= reg1+reg2
    .LoadImd		(machineCode[8:5]),
    .DataIn			(dataIn),
    .DataOutA		(dataA),
    .DataOutB		(dataB),
    .MoveToR		(moveToR),
    .MoveFromR		(moveFromR),
    .lslWrite		(lslWrite));
  
  // ALU
  ALU Alu(
    .InputA			(dataA),//LOCATION
    .InputB			(dataB),	//location
    .OP				(machineCode[8:6]), //ISTRUCTION
    .SC_in			(lastParityBit),
    .Out				(aluOut),
    .Zero			(zeroBit),
    .Parity			(parityBit),
    .Odd				(oddBit),
    .SC_out			(crry),
    .AZero			(branchCond),
    .lslWrite		(lslWrite));
  
  //Instruction Fetch, program counter
  InstFetch IF(
    .Reset			(init),
    .Start			(start),
    .Clk			(clk),
    .BranchRelEn	(branchEn),
    .ALU_flag		(lastZeroBit),
    .Target			({4'b0000, aluOut}), //(4+8)
    .ProgCtr		(pctr));
  
  // Instruction Memory
  InstROM IROM(
    .InstAddress	(pctr),
    .InstOut		(machineCode));
  
  // Control Decoder
  Ctrl CTRL(
    .Instruction	(machineCode),
    .RaddrA			(machineCode[5:3]),//reg 1
    .RaddrB			(machineCode[2:0]),//reg2
    .DatMemAddr		(DatMemAddr),	// reg1[reg2] machineCode[5:3][machineCode[2:0]]
    .BranchEn  		(branchEn),
    .RegWrEn   		(reg_wen),
    .MemWrEn   		(mem_wen),
    .LoadInst  		(loadInst),
    .ImdLUT			(imdLUT),
    .MoveToR		(moveToR),
    .MoveFromR		(moveFromR));
  
  // Immediate LUT
  Immediate_LUT ImmLut(
    .in				(machineCode[4:0]),
    .datOut			(LUTout));
  
/*
// temporary circuit to provide ack (done) flag to test bench
//   remove or greatly increase the match value once you get a 
//   proper ack 
always @(posedge clk) 
  if(init || req) 
    pctr <= 'h0;
  else  
	pctr <= pctr+'h1;

assign ack = pctr=='h256;  // pctr needed to trigger ack (arbitary time)
*/
  always_ff @ (posedge clk) begin
	lastZeroBit <= zeroBit;
   lastParityBit <= parityBit;
  end

assign ack = pctr=='h256;  // pctr needed to trigger ack (arbitary time)
endmodule


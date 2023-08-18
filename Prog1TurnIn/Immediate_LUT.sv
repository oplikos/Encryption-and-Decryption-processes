/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/
module Immediate_LUT #(PC_width = 10)(
  input               [ 4:0] in,	// in[4] determines if we use the LUT or load immediate directly,
  									// in[3:0] is rather the LUT address or the immediate
  output logic[7:0] datOut			// Output that will be written to a register
  );

always_comb begin
  datOut = 'h00;
  
  if(in[4]) begin	// Bit 4 of our input determines if bits 3:0 are a LUT address or an immediate
    case(in[3:0])		   				// These are our pre-loaded values. Put any desired immediate > 15 or immediate < 0 here
      4'b0000:   		datOut = 'h80;	//128
      4'b0001:	 		datOut = 'h0F;	//15
      4'b0010:	 		datOut = 'hEE;	//-18 
      4'b0011:   	 	datOut = 'h10;  //16 
      4'b0100: 			datOut = 'hEB;   //-21
      4'b0101:			datOut = 'h00;   //0
      4'b0110: 	 		datOut = 'h3D;   //61
      4'b0111:  		datOut = 'h00;
      4'b1000:	 		datOut = 'h00;
      4'b1001:   	 	datOut = 'h00;
      4'b1010:	 		datOut = 'h00;
      4'b1011:	 		datOut = 'h00;
      4'b1100:   	 	datOut = 'h00;
      4'b1101:	 		datOut = 'h00;
      4'b1110:	 		datOut = 'h00;
      4'b1111:			datOut = 'hFF;
      
      
    endcase
  end
  
  else begin		// Load immediate directly, any value from 0 to 15
    datOut = {4'b0000, in[3:0]};
  end

end

endmodule
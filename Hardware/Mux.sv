module Mux(
  input[7:0] 	in0,
  			 	in1,
  				in2,
  input 		sel,
  				selLUT,
  output logic[7:0] 	out);
  
  always_comb begin
    if(selLUT) begin
      out <= in2;
    end
    else if(sel) begin
      out <= in1;
    end
    else begin
      out <= in0;
    end
  end
endmodule
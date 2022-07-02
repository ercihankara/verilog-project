module shift
(input [17:0] buffer1_o, input [17:0] buffer2_o,  input [17:0] buffer3_o, input [17:0] buffer4_o,
input [17:0] buffer1_s, input [17:0] buffer2_s,  input [17:0] buffer3_s, input [17:0] buffer4_s);

	always@ (*) begin

		for(m = 0; m < 15; m = m + 1) begin
		
			buffer1_o[m] <= buffer1_o[m+3];
			buffer1_o[m+3] <= 0;
			
			buffer2_o[m] <= buffer2_o[m+3];
			buffer2_o[m+3] <= 0;
			
			buffer3_o[m] <= buffer3_o[m+3];
			buffer3_o[m+3] <= 0;
			
			buffer4_o[m] <= buffer4_o[m+3];
			buffer4_o[m+3] <= 0;
			
		end
		
		buffer1_s <= buffer1_o;
		buffer2_s <= buffer2_o;
		buffer3_s <= buffer3_o;
		buffer4_s <= buffer4_o;
		
	end
		
endmodule
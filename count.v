module count
(input [17:0] buffer1_o, input [17:0] buffer2_o,  input [17:0] buffer3_o, input [17:0] buffer4_o, output reg [2:0] L1, output reg [2:0] L2,
output reg [2:0] L3, output reg [2:0] L4);

	integer j;

	always @ (*) begin

		L1 = 0;
		L2 = 0;
		L3 = 0;
		L4 = 0;

		for(j = 0; j < 6; j = j + 1) begin

			if(buffer1_o[3*j] == 1)
				L1 = L1 + 1;
			if(buffer2_o[3*j] == 1)
				L2 = L2 + 1;
			if(buffer3_o[3*j] == 1)
				L3 = L3 + 1;
			if(buffer4_o[3*j] == 1)
				L4 = L4 + 1;
				
		end
	end
endmodule
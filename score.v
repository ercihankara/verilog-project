module score
(input [2:0] L1, input [2:0] L2, input [2:0] L3, input [2:0] L4,
output reg [5:0] RS, output reg [5:0] LS);

	always @ (*) begin

		RS <= 1*L1 + 2*L2 + 3*L3 + 4*L4 ;
		LS <= 4*L1 + 3*L2 + 2*L3 + 1*L4 ;
		
	end
endmodule
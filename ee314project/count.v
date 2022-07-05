module count(input clk,  
output reg [2:0] L1, output reg [2:0] L2,
output reg [2:0] L3, output reg [2:0] L4,
output reg [5:0] RS, output reg [5:0] LS);

integer j;
integer m;
reg [17:0] buffer1_o;
reg [17:0] buffer2_o; 
reg [17:0] buffer3_o; 
reg [17:0] buffer4_o;
reg mode;

always @ (posedge clk) begin

	L1=0;
	L2=0;
	L3=0;
	L4=0;

	for(j = 0; j < 5; j = j + 1) begin

		if(buffer1_o[3*j] == 1)
			L1 = L1 + 1;
		if(buffer2_o[3*j] == 1)
			L2 = L2 + 1;
		if(buffer3_o[3*j] == 1)
			L3 = L3 + 1;
		if(buffer4_o[3*j] == 1)
			L4 = L4 + 1;
		
	end

	RS=1*L1 + 2*L2 + 3*L3 + 4*L4;
	LS=4*L1 + 3*L2 + 2*L3 + 1*L4;
	
	
	
	
////
	
	if(RS<LS)
	
		mode <= 0;
		
	else 
	
		mode <= 1;
		
	// Relibility Mode (mode 1)
	// Latency Mode (mode 0)	
		
	case(mode)
	// latency
	1'b0: begin
	
		if(L1>L2 && L1>L3 && L1>L4)begin
			//shift1
			for(m = 0; m < 15; m = m + 1)begin
				buffer1_o[m] <= buffer1_o[m+3];
			end
			end
		else if(L2>L1 && L2>L3 && L2>L4)begin
			//shift2
			for(m = 0; m < 15; m = m + 1)begin
				buffer2_o[m] <= buffer2_o[m+3];
			end
			end
		else if(L3>L4)begin
			//shift3
			for(m = 0; m < 15; m = m + 1)begin
				buffer3_o[m] <= buffer3_o[m+3];
			end
			end
		else begin
			//shift4
			for(m = 0; m < 15; m = m + 1)begin
				buffer4_o[m] <= buffer4_o[m+3];
			end
			end
	end
	
	// reliability
	1'b1: begin
	
		if(L4>L1 && L4>L2 && L4>L3)begin
			//shift4
			for(m = 0; m < 15; m = m + 1)begin
				buffer4_o[m] <= buffer4_o[m+3];
			end
			end
		else if(L3>L1 && L3>L2 && L3>L4)begin
			//shift3
			for(m = 0; m < 15; m = m + 1)begin
				buffer3_o[m] <= buffer3_o[m+3];
			end
			end
		else if(L2>L1)begin
			//shift2
			for(m = 0; m < 15; m = m + 1)begin
				buffer2_o[m] <= buffer2_o[m+3];
			end
			end
		else begin
			//shift1
			for(m = 0; m < 15; m = m + 1)begin
				buffer1_o[m] <= buffer1_o[m+3];
			end
			end
	end
	endcase
end
endmodule

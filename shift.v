module shift
(input [17:0] buffer1_o, input [17:0] buffer2_o,  input [17:0] buffer3_o, input [17:0] buffer4_o, input [2:0] L1, input [2:0] L2,
input [2:0] L3, input [2:0] L4);

	always@ (*) begin

		if(RS<LS)
			
				mode <= 0;
				
			else 
			
				mode <= 1;
				
			// Reliability Mode (mode 1)
			// Latency Mode (mode 0)	
			
				// erci integer m tanıtmayı unutma 
			case(mode)
			// latency
			1'b0: begin
				
				if(L1 >L2 && L1 > L3 && L1 > L4) begin
					//shift1
					for(m = 0; m < 15; m = m + 1) begin
						buffer1_o[m] <= buffer1_o[m+3];
						buffer1_o[m+3] <= 0;
					end
				end
				
				else if(L2>L1 && L2>L3 && L2>L4) begin
					//shift2
					for(m = 0; m < 15; m = m + 1) begin
						buffer2_o[m] <= buffer2_o[m+3];
						buffer2_o[m+3] <= 0;
					end
				end
				
				else if(L3>L4) begin
					//shift3
					for(m = 0; m < 15; m = m + 1) begin
						buffer3_o[m] <= buffer3_o[m+3];
						buffer3_o[m+3] <= 0;
					end
				end
					
				else begin
					//shift4
					for(m = 0; m < 15; m = m + 1) begin
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
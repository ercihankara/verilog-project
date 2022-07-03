module take_in_in
(input start, input key1, input key2, output reg [17:0] buffer1_o, output reg [17:0] buffer2_o, output reg [17:0] buffer3_o,
output reg [17:0] buffer4_o);

// start button is clk signal, when 1 take input
// When start = 1, create the data from key1 and key2 where
// key1 assigned to 1, key2 assigned to 0 !!!
// shifting için module yaz
	
	integer k, l, h, holder;
	
	reg [3:0] data;
	reg [2:0] buffer1 [5:0];
	reg [2:0] buffer2 [5:0];
	reg [2:0] buffer3 [5:0];
	reg [2:0] buffer4 [5:0];
	
	initial begin
	
		for (k = 0; k < 6; k = k+1) begin
		
			buffer1[k] <= 0;
			buffer2[k] <= 0;
			buffer3[k] <= 0;
			buffer4[k] <= 0;
			
		end
	
	end
		
// third bit for validity, if 1 read; if 0 pass

	always@ (posedge start) begin
	
		holder <= 0;
		
	end
	
	initial begin
		
		if (holder != 3) begin
					
				for (h = 0; h < 4; h = h + 1) begin
				
					if (key1)
						data[3 - h] = 1'b1;
					else if (key2)
						data[3 - h] = 1'b0;
						
				end
				holder <= holder+1;
		end
		
	end


	integer i1 = 0, i2 = 0, i3 = 0, i4 = 0;
	integer i;
// BOB1B2B3
// input is stored from left I guess


	
	always@ (*) begin
	
		case(data[3:2])
		
			2'b00 : begin
				
						buffer1[i1] <= {data[1:0], 1'b1};
						if (i1 != 5)
							i1 = i1 + 1;
						else begin // shifting will be realized here
							i1 = 5;
							buffer1[0] <= buffer1[1];
							buffer1[1] <= buffer1[2];
							buffer1[2] <= buffer1[3];
							buffer1[3] <= buffer1[4];
							buffer1[4] <= buffer1[5];
					  end
					 end
					  
			2'b01 : begin
			
						buffer2[i2] <= {data[1:0], 1'b1};
						if (i2 != 5)
							i2 = i2 + 1;
						else begin // shifting will be realized here
							i2 = 5;
							buffer2[0] <= buffer2[1];
							buffer2[1] <= buffer2[2];
							buffer2[2] <= buffer2[3];
							buffer2[3] <= buffer2[4];
							buffer2[4] <= buffer2[5];
							end
					  end
			
			2'b10 : begin
			
						buffer3[i3] <= {data[1:0], 1'b1};
						if (i3 != 5)
							i3 = i3 + 1;
						else begin // shifting will be realized here
							i3 = 5;
							buffer3[0] <= buffer3[1];
							buffer3[1] <= buffer3[2];
							buffer3[2] <= buffer3[3];
							buffer3[3] <= buffer3[4];
							buffer3[4] <= buffer3[5];
							end

					  end
					  
			2'b11 : begin

						buffer4[i4] <= {data[1:0], 1'b1};
						if (i4 != 5)
							i4 = i4 + 1;
						else begin // shifting will be realized here
							i4 = 5;
							buffer4[0] <= buffer4[1];
							buffer4[1] <= buffer4[2];
							buffer4[2] <= buffer4[3];
							buffer4[3] <= buffer4[4];
							buffer4[4] <= buffer4[5];
							end
						end
		
		endcase
	end
	
	always@ (*) begin
		
			for (i = 0; i < 6; i = i+1) begin
		
				buffer1_o[3*i+2 -:3] <= buffer1[i];
				buffer2_o[3*i+2 -:3] <= buffer2[i];
				buffer3_o[3*i+2 -:3] <= buffer3[i];
				buffer4_o[3*i+2 -:3] <= buffer4[i];

			end		
	end
	
endmodule
// modules: take input, read data, shift and arrange registers
//`include "C:/Users/ercih/Desktop/project/shift.v"

module take_in
(input start, input clk, input key0, input key1, output reg [17:0] buffer1_o, output reg [17:0] buffer2_o, output reg [17:0] buffer3_o,
output reg [17:0] buffer4_o);

// start button is clk signal, when 1 take input
// When start = 1, create the data from key0 and key1 where
// key0 assigned to 0, key1 assigned to 1 !!!
// shifting için module yaz
	
	integer k, l, h;
	
	reg [3:0] data;
	reg [3:0] holder;
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
	
	integer i1 = 0, i2 = 0, i3 = 0, i4 = 0;
	integer i, started, opener, indexer;
	initial begin
		data <= 0;
		started <= 0;
		opener <= 0;
		indexer <= 0;
		holder <= 0;
	end
	
// BOB1B2B3
// input is stored from left I guess
	
	always@ (posedge clk) begin
	
	// delay to give input data
		if (start == 0 && started < 3) begin
			data <= 0;
			started <= started + 1;
		end
		
	// create the data	
		else if (started == 3) begin
			
			case({key0, key1})
				
				2'b10: begin // 0 for bit
				// store the input data in a temporary register
					holder[indexer] <= 0;
					indexer = indexer + 1;
					if (indexer == 3) begin
						data[3] <= holder[0];
						data[2] <= holder[1];
						data[1] <= holder[2];
						data[0] <= holder[3];
						opener <= 1;
						indexer <= 0;
						started <= 0;
					end
				
				end
				
				2'b01: begin // 1 for bit
				// store the input data in a temporary register
					holder[indexer] <= 1;
					indexer = indexer + 1;
					if (indexer == 3) begin
						data[3] <= holder[0];
						data[2] <= holder[1];
						data[1] <= holder[2];
						data[0] <= holder[3];
						opener <= 1;
						indexer <= 0;
						started <= 0;
					end
				end
				// data created
			endcase
		end
				
		if (opener == 1) begin
			case(data[3:2])
			
				2'b00 : begin
					
							buffer1[i1] <= {data[1:0], 1'b1};
							if (i1 != 5)
								i1 = i1 + 1;
							else
								i1 = 0; // shifting will be realized here

						  end
						  
				2'b01 : begin
					
							buffer2[i2] <= {data[1:0], 1'b1};
							if (i2 != 5)
								i2 = i2 + 1;
							else
								i2 = 0;

						  end
				
				2'b10 : begin
					
							buffer3[i3] <= {data[1:0], 1'b1};
							if (i3 != 5)
								i3 = i3 + 1;
							else
								i3 = 0;

						  end
						  
				2'b11 : begin
					
							buffer4[i4] <= {data[1:0], 1'b1};
							if (i4 != 5)
								i4 = i4 + 1;
							else
								i4 = 0;
						  end
			
			endcase
		end
			
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
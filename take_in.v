module take_in
(input start, input clk, input key0, input key1, output wire [17:0] buffer1_o, output wire [17:0] buffer2_o, output wire [17:0] buffer3_o,
output wire [17:0] buffer4_o, output wire [3:0] dataaa, output wire drops, output wire received_data);

// When start = 1, create the data from key0 and key1 where
// key0 assigned to 0, key1 assigned to 1 !!!
// buttons are 1 when not pushed!!! 0 when pushed
// count number of drops, read, received data from FPGA
	
	integer k, h;
	
	reg [3:0] data;
	reg [3:0] holder;
	reg [2:0] buffer1 [5:0];
	reg [2:0] buffer2 [5:0];
	reg [2:0] buffer3 [5:0];
	reg [2:0] buffer4 [5:0];
	
	reg [17:0] buffer1_reg;
	reg [17:0] buffer2_reg;
	reg [17:0] buffer3_reg;
	reg [17:0] buffer4_reg;
	
	reg [3:0] data_reg;
	reg drops_reg;
	reg received_data_reg;
	
	initial begin

		for (k = 0; k < 6; k = k+1) begin
		
			buffer1[k] <= 0;
			buffer2[k] <= 0;
			buffer3[k] <= 0;
			buffer4[k] <= 0;
			
		end
		data_reg <= 0;
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
		drops_reg <= 0;
		received_data_reg <= 0;
	
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
					received_data_reg <= received_data_reg + 1;
					
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
								i1 = 5; // shifting will be realized here
								buffer1[0] <= buffer1[1];
								buffer1[1] <= buffer1[2];
								buffer1[2] <= buffer1[3];
								buffer1[3] <= buffer1[4];
								buffer1[4] <= buffer1[5];
								buffer1[5] <= 0;
								drops_reg <= drops_reg + 1;
								
//								for (h = 0; h < 5; h = h +1) begin
//									buffer1[h] <= buffer1[h + 1];								
//									if (h == 5)
//										buffer1[h] <= 0;
//								end
						  end
						  
				2'b01 : begin
					
							buffer2[i2] <= {data[1:0], 1'b1};
							if (i2 != 5)
								i2 = i2 + 1;
							else
								i2 = 5; // shifting will be realized here
								buffer2[0] <= buffer2[1];
								buffer2[1] <= buffer2[2];
								buffer2[2] <= buffer2[3];
								buffer2[3] <= buffer2[4];
								buffer2[4] <= buffer2[5];
								buffer2[5] <= 0;
								drops_reg <= drops_reg + 1;

						  end
				
				2'b10 : begin
					
							buffer3[i3] <= {data[1:0], 1'b1};
							if (i3 != 5)
								i3 = i3 + 1;
							else
								i3 = 5; // shifting will be realized here
								buffer3[0] <= buffer3[1];
								buffer3[1] <= buffer3[2];
								buffer3[2] <= buffer3[3];
								buffer3[3] <= buffer3[4];
								buffer3[4] <= buffer3[5];
								buffer3[5] <= 0;
								drops_reg <= drops_reg + 1;
								
						  end
						  
				2'b11 : begin
					
							buffer4[i4] <= {data[1:0], 1'b1};
							if (i4 != 5)
								i4 = i4 + 1;
							else
								i4 = 5; // shifting will be realized here
								buffer4[0] <= buffer4[1];
								buffer4[1] <= buffer4[2];
								buffer4[2] <= buffer4[3];
								buffer4[3] <= buffer4[4];
								buffer4[4] <= buffer4[5];
								buffer4[5] <= 0;
								drops_reg <= drops_reg + 1;
						  end
			
			endcase
		end
			
	end
	
	always@ (*) begin
	// open the 2D arrays
			for (i = 0; i < 6; i = i+1) begin
		
				buffer1_reg[3*i+2 -:3] = buffer1[i];
				buffer2_reg[3*i+2 -:3] = buffer2[i];
				buffer3_reg[3*i+2 -:3] = buffer3[i];
				buffer4_reg[3*i+2 -:3] = buffer4[i];

			end
			data_reg <= data;
	end
	
	
	assign buffer1_o = buffer1_reg;
	assign buffer2_o = buffer2_reg;
	assign buffer3_o = buffer3_reg;
	assign buffer4_o = buffer4_reg;
	assign dataaa = data_reg;
	assign drops = drops_reg;
	assign received_data = received_data_reg;
	
endmodule
// waveform8 is the simulation file
// data ters amk
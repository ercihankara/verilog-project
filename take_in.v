`include "C:/Users/ercih/Desktop/project/count.v"
`include "C:/Users/ercih/Desktop/project/score.v"
`include "C:/Users/ercih/Desktop/project/freqdivider.v"

module take_in
(input start, input clk, input key0, input key1, output reg [4:0] data, output reg drops, output reg received_data, output reg [18:0] buffer1, output reg [18:0] buffer2,
output reg [18:0] buffer3, output reg [18:0] buffer4, output reg opener, output reg [3:0] holder, output reg [4:0] outputer, input swa);

// When start = 1, create the data from key0 and key1 where
// key0 assigned to 0, key1 assigned to 1 !!!
// buttons are 1 when not pushed!!! 0 when pushed
// count number of drops, read, received data from FPGA
//
//	reg [17:0] buffer1_o;
//	reg [17:0] buffer2_o;
//	reg [17:0] buffer3_o;
//	reg [17:0] buffer4_o;
	
	integer k, h, readNow;
	
	//reg [3:0] data;
	
//	reg [2:0] buffer1 [5:0];
//	reg [2:0] buffer2 [5:0];
//	reg [2:0] buffer3 [5:0];
//	reg [2:0] buffer4 [5:0];

	reg mode;
	reg [5:0] rea_sc;
	reg [5:0] lat_sc;
	reg [3:0] data_reg;
	reg drops_reg;
	reg pressed;
	reg received_data_reg;
	reg [2:0] sizeB1, sizeB2, sizeB3,sizeB4;
	reg [4:0] s1, s2, s3, s4, read;	

	integer i, m, j;
	wire clk_divided;
// LSB of one 3-bit data is the validity bit 1-0

	//count counter(.buffer1_o (buffer1_open_reg), .buffer2_o (buffer2_open_reg), .buffer3_o (buffer3_open_reg), .buffer4_o (buffer4_open_reg), .L1 (L1), .L2 (L2), .L3 (L3), .L4 (L4));
	//score scorer(.L1 (L1), .L2 (L2), .L3 (L3), .L4 (L4), .RS (rea_sc), .LS (lat_sc));
	freqdivider freqdividerer(.clk (clk), .clk_out (clk_divided));
		
// third bit for validity, if 1 read; if 0 pass
	
	integer started, indexer;
	initial begin
		
		s1 = 0;
		s2 = 0;
		s3 = 0;
		s4 = 0;
		buffer1 <= 0;
		buffer2 <= 0;
		buffer3 <= 0;
		buffer4 <= 0;
		data_reg <= 0;
		data <= 0;
		started <= 0;
		opener <= 0;
		indexer = 0;
		holder <= 0;
		drops_reg <= 0;
		received_data_reg = 0;
		pressed = 0;
		sizeB1 = 0;
		sizeB2 = 0;
		sizeB3 = 0;
		sizeB4 = 0;
		
	end
	
// BOB1B2B3
// input is stored from left I guess
	
	always@ (posedge clk) begin
	
		if(swa) readNow = readNow+1;
		else readNow = 0;
		
		if(readNow == 75000000 && swa) begin
		
			outputer <= 0;
			
			if(sizeB1 == 0) s1 <= 0;
			if(sizeB2 == 0) s2 <= 0;
			if(sizeB3 == 0) s3 <= 0;
			if(sizeB4 == 0) s4 <= 0;

			if(sizeB1 > 0 || sizeB2 > 0 || sizeB3 > 0 || sizeB4 > 0) begin
				
				if(sizeB1 > 0) s1 <= sizeB1 <=  3 ?  sizeB1*4+1: sizeB1*1+4; 		
				if(sizeB2 > 0) s2 <= sizeB2 <=  3 ?  sizeB2*3+2: sizeB2*2+3;
				if(sizeB3 > 0) s3 <= sizeB3 <=  3 ?  sizeB3*2+3: sizeB3*3+2;
				if(sizeB4 > 0) s4 <= sizeB4 <=  3 ?  sizeB4*1+4: sizeB4*4+1;
				read <= read +1;			
				
				// Read from Buffer 1
				if(s1 >= s2 && s1 >= s3 && s1 >= s4) begin
				
					outputer[4] <= 1;
					outputer[3] <= 0;
					outputer[2] <= 0;
					outputer[1] <= buffer1[(sizeB1-1)*3+1];
					outputer[0] <= buffer1[(sizeB1-1)*3+2];
				
					buffer1[(sizeB1-1)*3]<=0;
					buffer1[(sizeB1-1)*3+1]<=0;
					buffer1[(sizeB1-1)*3+2]<=0;
					sizeB1 = sizeB1-1;
					
				end
				
				// Read from Buffer 2
				else if(s2 >= s1 && s2 >= s3 && s2 >= s4) begin
					outputer[4] <= 1;
					outputer[3] <= 0;
					outputer[2] <= 1;
					outputer[1] <= buffer2[(sizeB2-1)*3+1];
					outputer[0] <= buffer2[(sizeB2-1)*3+2];
				
					buffer2[(sizeB2-1)*3]<=0;
					buffer2[(sizeB2-1)*3+1]<=0;
					buffer2[(sizeB2-1)*3+2]<=0;
					sizeB2 = sizeB2-1;
					
				end
				
				// Read from Buffer 3
				else if(s3 >= s1 && s3 >= s2 && s3 >= s4) begin
					outputer[4] <= 1;
					outputer[3] <= 1;
					outputer[2] <= 0;
					outputer[1] <= buffer3[(sizeB3-1)*3+1];
					outputer[0] <= buffer3[(sizeB3-1)*3+2];
				
					buffer3[(sizeB3-1)*3]<=0;
					buffer3[(sizeB3-1)*3+1]<=0;
					buffer3[(sizeB3-1)*3+2]<=0;
					sizeB3 = sizeB3-1;
					
				end
				
				// Read from Buffer 4
				else if(s4 >= s1 && s4 >= s2 && s4 >= s3) begin
					outputer[4] <= 1;
					outputer[3] <= 1;
					outputer[2] <= 1;
					outputer[1] <= buffer4[(sizeB4-1)*3+1];
					outputer[0] <= buffer4[(sizeB4-1)*3+2];
				
					buffer4[(sizeB4-1)*3]<=0;
					buffer4[(sizeB4-1)*3+1]<=0;
					buffer4[(sizeB4-1)*3+2]<=0;
					sizeB4 = sizeB4-1;
					
				end

			end
			readNow <= 0;

		end
		
	// input data
	// delay to give input data
		else if (start == 0 && started < 2) begin
			data <= 0;
			started <= started + 1;
		end
		
	// create the data
		else if (started == 2) begin
			
			case({key0,key1,pressed})
								
				3'b111 : begin
					pressed <= 0 ;
				end
				
				3'b010: begin // 0 for bit
				// store the input data in a temporary register
					holder[indexer] = 0;
					pressed <= 1;
					indexer <= indexer + 1;
					if (indexer == 3) begin
						data[4] = 1;
						data[3] = holder[0];
						data[2] = holder[1];
						data[1] = holder[2];
						data[0] = holder[3];
						opener <= 1;
						indexer <= 0;
						started <= 0;
					end
				end
				
				3'b100: begin // 1 for bit
				// store the input data in a temporary register
					holder[indexer] = 1;
					pressed <= 1;
					indexer <= indexer + 1;
					if (indexer == 3) begin
						data[4] = 1;
						data[3] = holder[0];
						data[2] = holder[1];
						data[1] = holder[2];
						data[0] = holder[3];
						opener <= 1;
						indexer <= 0;
						started <= 0;
					end
					//received_data_reg <= received_data_reg + 1;
				end
				// data created
			endcase
				
			if (data[4] == 1) begin
				case(data[3:2])
				
					2'b00 : begin
						
						buffer1[17:3]=buffer1[14:0];
						buffer1[2:0] = {data[1:0],1'b1};
						sizeB1 <= sizeB1 +1;
					end
					2'b01:begin
						buffer2[17:3]=buffer2[14:0];
						buffer2[2:0] = {data[1:0],1'b1};
						sizeB2 <= sizeB2 +1;
					end
					
					2'b10:begin
						buffer3[17:3]=buffer3[14:0];
						buffer3[2:0] = {data[1:0],1'b1};
						sizeB3 <= sizeB3 +1;
					end
					
					2'b11:begin
						buffer4[17:3]=buffer4[14:0];
						buffer4[2:0] = {data[1:0],1'b1};
						sizeB4 <= sizeB4 +1;
					end
			endcase
		end
	end
	
		// read data
		/*
		buffer1_open <= buffer1_o;
		buffer2_open <= buffer2_o;
		buffer3_open <= buffer3_o;
		buffer4_open <= buffer4_o;

		for(j = 0; j < 6; j = j + 1) begin

			if(buffer1_o[3*j] == 1)
				L1 <= L1 + 1;
			if(buffer2_o[3*j] == 1)
				L2 <= L2 + 1;
			if(buffer3_o[3*j] == 1)
				L3 <= L3 + 1;
			if(buffer4_o[3*j] == 1)
				L4 <= L4 + 1;
				
		end
		
		rea_sc <= 1*L1 + 2*L2 + 3*L3 + 4*L4;
		lat_sc <= 4*L1 + 3*L2 + 2*L3 + 1*L4;
		
		if(rea_sc < lat_sc)
			
			mode <= 0;
				
		else
			
			mode <= 1;
					
		case(mode)
			
			1'b0: begin
				
				if(L1 > L2 && L1 > L3 && L1 > L4) begin
						//shift1
											
						disp <= buffer1_open[2:1];
						//buffer1_open[0] <= 1'b0;
						read <= read + 1;
						
						for(m = 0; m < 15; m = m + 1) begin
							buffer1_open[m] <= buffer1_open[m+3];
							// new empty space will be initialized to 0
						end
						
					end
					
				else if(L2 > L1 && L2 > L3 && L2 > L4) begin
					//shift2
					
					disp <= buffer2_open[2:1];
					//buffer2_open[0] <= 1'b0;
					read <= read + 1;
					
					for(m = 0; m < 15; m = m + 1) begin
						buffer2_open[m] <= buffer2_open[m+3];
					end
					
				end
				
				else if(L3 > L4) begin
					//shift3
					
					disp <= buffer3_open[2:1];
					//buffer3_o[0] <= 1'b0;
					read <= read + 1;
					
					for(m = 0; m < 15; m = m + 1) begin
						buffer3_open[m] <= buffer3_open[m+3];
					end
					
				end
					
				else begin
					//shift4
					
					disp <= buffer4_open[2:1];
					//buffer4_o[0] <= 1'b0;
					read <= read + 1;
					
					for(m = 0; m < 15; m = m + 1) begin
						buffer4_open[m] <= buffer4_open[m+3];
					end
					
				end
			end			
			
			1'b1: begin
				
					if(L4 > L1 && L4 > L2 && L4 > L3) begin
						//shift4
						
						disp <= buffer4_open[2:1];
						//buffer4_o[0] <= 1'b0;
						read <= read + 1;
						
						for(m = 0; m < 15; m = m + 1) begin
							buffer4_open[m] <= buffer4_open[m+3];
						end
						
					end
					
					else if(L3>L1 && L3>L2 && L3>L4) begin
						//shift3
						
						disp <= buffer3_open[2:1];
						//buffer3_o[0] <= 1'b0;
						read <= read + 1;
						
						for(m = 0; m < 15; m = m + 1) begin
							buffer3_open[m] <= buffer3_open[m+3];
						end
					
					end
					
					else if(L2>L1) begin
						//shift2
						
						disp <= buffer2_open[2:1];
						//buffer2_o[0] <= 1'b0;
						read <= read + 1;
						
						for(m = 0; m < 15; m = m + 1) begin
							buffer2_open[m] <= buffer2_open[m+3];
						end
						
					end
					
					else begin
						//shift1
						
						disp <= buffer1_open[2:1];
						//buffer1_o[0] <= 1'b0;
						read <= read + 1;
						
						for(m = 0; m < 15; m = m + 1) begin
							buffer1_open[m] <= buffer1_open[m+3];
						end
						
					end
				end
				
			endcase*/
		end
	
endmodule
// waveform8 is the simulation file
// data ters amk
module take_in
(input start, input clk, // 50 MHz
input key0, input key1, input swa,
   output o_hsync,      // horizontal sync
	output o_vsync,	     // vertical sync
	output wire [7:0] o_color,  
	output reg clk25MHz);

	
	integer k, h, readNow;
	parameter loc_x1 = 200;
	parameter loc_x2 = 255;
	parameter loc_x3 = 315;
	parameter loc_x4 = 375;
	
	
	parameter loc_y1 = 120;
	parameter loc_y2 = 165;
	parameter loc_y3 = 210;
	parameter loc_y4 = 255;
	parameter loc_y5 = 300;
	parameter loc_y6 = 345;
	
	parameter delta = 36;
	
	reg opener;
	reg [3:0] holder;
	reg [4:0] outputer;
	reg [18:0] buffer1_o;
	reg [18:0] buffer2_o;
	reg [18:0] buffer3_o;
	reg [18:0] buffer4_o;
	reg received_data;
	//reg drops;
	reg [4:0] data;
	reg [5:0] rea_sc;
	reg [5:0] lat_sc;
	reg [3:0] data_reg;
	reg drops_reg;
	reg pressed;
	reg received_data_reg;
	reg [2:0] sizeB1, sizeB2, sizeB3,sizeB4;
	reg [4:0] s1, s2, s3, s4, reada;	
	reg [9:0] counter_x = 0;  // horizontal counter
	reg [9:0] counter_y = 0;  // vertical counter
	reg [7:0] color = 0;
	
	reg [7:0] empty [0:1224];
	
	reg [7:0] red0 [0:1295];
	reg [7:0] red1 [0:1295];
	reg [7:0] red2 [0:1295];
	reg [7:0] red3 [0:1295];
	
	reg [7:0] blue0 [0:1295];
	reg [7:0] blue1 [0:1295];
	reg [7:0] blue2 [0:1295];
	reg [7:0] blue3 [0:1295];
	
	reg [7:0] green0 [0:1295];
	reg [7:0] green1 [0:1295];
	reg [7:0] green2 [0:1295];
	reg [7:0] green3 [0:1295];
	
	reg [7:0] yellow0 [0:1295];
	reg [7:0] yellow1 [0:1295];
	reg [7:0] yellow2 [0:1295];
	reg [7:0] yellow3 [0:1295];
	
	reg [7:0] emptys [0:483];
	reg [7:0] k1 [0:483];
	reg [7:0] k0 [0:483];
	reg [7:0] inp [0:1224];
	reg [7:0] read[0:1224];
	reg [7:0] trans [0:2449];
	reg [7:0] receive [0:2449];
	reg [7:0] drop [0:2449];

	reg reset = 0;  // for PLL
	reg clk_divided;
	reg[23:0] counter;

	integer i, m, j;
	
	
	
		
	always@(posedge clk) begin //clk for read 3 secs
	
			if(counter==24'd75000000) begin
			counter <= 16'd0;
			clk_divided <= ~clk_divided;
			end
		else begin
			counter <= counter +1;
		end
	
	end
	
	always @ (posedge clk) begin //clk for VGA
			clk25MHz <= ~clk25MHz;
	end
		
// third bit for validity, if 1 read; if 0 pass
	
	integer started, indexer;
	initial begin
		
		s1 = 0;
		s2 = 0;
		s3 = 0;
		s4 = 0;
		buffer1_o <= 0;
		buffer2_o <= 0;
		buffer3_o <= 0;
		buffer4_o <= 0;
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
	
		$readmemh ("empty.txt", empty);
		$readmemh ("emptys.txt", emptys);
		$readmemh ("drop.txt", drop);
		$readmemh ("receive.txt", receive);
		$readmemh ("trans.txt", trans);
		$readmemh ("read.txt", read);
		$readmemh ("input.txt", inp);
		$readmemh ("keyone.txt", k1);
		$readmemh ("keyzero.txt", k0);
		
		$readmemh ("red0.txt", red0);
		$readmemh ("red1.txt", red1);
		$readmemh ("red2.txt", red2);
		$readmemh ("red3.txt", red3);
		
		$readmemh ("blue0.txt", blue0);
		$readmemh ("blue1.txt", blue1);
		$readmemh ("blue2.txt", blue2);
		$readmemh ("blue3.txt", blue3);
		
		$readmemh ("yellow0.txt", yellow0);
		$readmemh ("yellow1.txt", yellow1);
		$readmemh ("yellow2.txt", yellow2);
		$readmemh ("yellow3.txt", yellow3);
		
		$readmemh ("green0.txt", green0);
		$readmemh ("green1.txt", green1);
		$readmemh ("green2.txt", green2);
		$readmemh ("green3.txt", green3);
	
		
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
				reada <= reada +1;			
				
				// Read from Buffer 1
				if(s1 >= s2 && s1 >= s3 && s1 >= s4) begin
				
					outputer[4] <= 1;
					outputer[3] <= 0;
					outputer[2] <= 0;
					outputer[1] <= buffer1_o[(sizeB1-1)*3+1];
					outputer[0] <= buffer1_o[(sizeB1-1)*3+2];
				
					buffer1_o[(sizeB1-1)*3]<=0;
					buffer1_o[(sizeB1-1)*3+1]<=0;
					buffer1_o[(sizeB1-1)*3+2]<=0;
					sizeB1 = sizeB1-1;
					
				end
				
				// Read from Buffer 2
				else if(s2 >= s1 && s2 >= s3 && s2 >= s4) begin
					outputer[4] <= 1;
					outputer[3] <= 0;
					outputer[2] <= 1;
					outputer[1] <= buffer2_o[(sizeB2-1)*3+1];
					outputer[0] <= buffer2_o[(sizeB2-1)*3+2];
				
					buffer2_o[(sizeB2-1)*3]<=0;
					buffer2_o[(sizeB2-1)*3+1]<=0;
					buffer2_o[(sizeB2-1)*3+2]<=0;
					sizeB2 = sizeB2-1;
					
				end
				
				// Read from Buffer 3
				else if(s3 >= s1 && s3 >= s2 && s3 >= s4) begin
					outputer[4] <= 1;
					outputer[3] <= 1;
					outputer[2] <= 0;
					outputer[1] <= buffer3_o[(sizeB3-1)*3+1];
					outputer[0] <= buffer3_o[(sizeB3-1)*3+2];
				
					buffer3_o[(sizeB3-1)*3]<=0;
					buffer3_o[(sizeB3-1)*3+1]<=0;
					buffer3_o[(sizeB3-1)*3+2]<=0;
					sizeB3 = sizeB3-1;
					
				end
				
				// Read from Buffer 4
				else if(s4 >= s1 && s4 >= s2 && s4 >= s3) begin
					outputer[4] <= 1;
					outputer[3] <= 1;
					outputer[2] <= 1;
					outputer[1] <= buffer4_o[(sizeB4-1)*3+1];
					outputer[0] <= buffer4_o[(sizeB4-1)*3+2];
				
					buffer4_o[(sizeB4-1)*3]<=0;
					buffer4_o[(sizeB4-1)*3+1]<=0;
					buffer4_o[(sizeB4-1)*3+2]<=0;
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
						
						buffer1_o[17:3]=buffer1_o[14:0];
						buffer1_o[2:0] = {data[1:0],1'b1};
						sizeB1 <= sizeB1 +1;
					end
					2'b01:begin
						buffer2_o[17:3]=buffer2_o[14:0];
						buffer2_o[2:0] = {data[1:0],1'b1};
						sizeB2 <= sizeB2 +1;
					end
					
					2'b10:begin
						buffer3_o[17:3]=buffer3_o[14:0];
						buffer3_o[2:0] = {data[1:0],1'b1};
						sizeB3 <= sizeB3 +1;
					end
					
					2'b11:begin
						buffer4_o[17:3]=buffer4_o[14:0];
						buffer4_o[2:0] = {data[1:0],1'b1};
						sizeB4 <= sizeB4 +1;
					end
			endcase
		end
	end
	
	end
	

always @(posedge clk25MHz)  // horizontal counter
			begin 
				if (counter_x < 799)
					counter_x <= counter_x + 1;  // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels 
				else
					counter_x <= 0;              
			end  // always 
		
		always @ (posedge clk25MHz)  // vertical counter
			begin 
				if (counter_x == 799)  // only counts up 1 count after horizontal finishes 800 counts
					begin
						if (counter_y < 525)  // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
							counter_y <= counter_y + 1;
						else
							counter_y <= 0;              
					end  // if (counter_x...
			end  // always
		
		
		assign o_hsync = (counter_x >= 0 && counter_x < 96) ? 1:0;  // hsync high for 96 counts                                                 
		assign o_vsync = (counter_y >= 0 && counter_y < 2) ? 1:0;   // vsync high for 2 counts
		
	always @ (posedge clk) begin
	
			// INPUT TEXT
			if(counter_x >= 210 && counter_x <245 && counter_y >= 412 && counter_y < 447)begin
				color <= inp[(counter_x-210)*35 + counter_y-412];
			end
			
			// READ TEXT
			else if(counter_x >= 210 && counter_x <245 && counter_y >= 72 && counter_y < 107)begin
				color <= read[(counter_x-210)*35 + counter_y-72];
			end
			
			// "READ" DATA BOXES
			else if(counter_x >= 255 && counter_x < 277 && counter_y >= 85 && counter_y < 107)begin
					case(outputer[3]) 
					1'b1: color <= k1[(counter_x-255)*22 + counter_y-85];
					1'b0: color <= k0[(counter_x-255)*22 + counter_y-85];
					endcase
				end
	//			else begin
	//			color <= emptys[(counter_x-255)*22 + counter_y-85];
	//			end
	//		end
			
			else if(counter_x >= 280 && counter_x <302 && counter_y >= 85 && counter_y < 107)begin
					 
						case(outputer[2])
						1'b1: color <= k1[(counter_x-280)*22 + counter_y-85];
						1'b0: color <= k0[(counter_x-280)*22 + counter_y-85];
						endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-280)*22 + counter_y-85];
	//				end
	//		end
			else if(counter_x >= 305 && counter_x <327 && counter_y >= 85 && counter_y < 107)begin
					
					case(outputer[1])
					1'b1: color <= k1[(counter_x-305)*22 + counter_y-85];
					1'b0: color <= k0[(counter_x-305)*22 + counter_y-85];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-305)*22 + counter_y-85];
	//				end
	//		end
			
			else if(counter_x >= 330 && counter_x <352 && counter_y >= 85 && counter_y < 107)begin
				 
					case(outputer[0]) 
					1'b1: color <= k1[(counter_x-330)*22 + counter_y-85];
					1'b0: color <= k0[(counter_x-330)*22 + counter_y-85];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-330)*22 + counter_y-85];
	//				end
	//		end
			
			
	//		
			
				// INPUT DATA BOXES
			else if(counter_x >= 255 && counter_x < 277 && counter_y >= 425 && counter_y < 447)begin
					 
					case(data[3])
					1'b1: color <= k1[(counter_x-255)*22 + counter_y-425];
					1'b0: color <= k0[(counter_x-255)*22 + counter_y-425];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-255)*22 + counter_y-425];
	//				end
	//		end
	//		
			else if(counter_x >= 280 && counter_x <302 && counter_y >= 425 && counter_y < 447)begin
				
					case(data[2])
					1'b1: color <= k1[(counter_x-280)*22 + counter_y-425];
					1'b0: color <= k0[(counter_x-280)*22 + counter_y-425];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-280)*22 + counter_y-425];
	//				end
	//		end
			
			else if(counter_x >= 305 && counter_x <327 && counter_y >= 425 && counter_y < 447)begin
				
					case(data[1]) 
					1'b1: color <= k1[(counter_x-305)*22 + counter_y-425];
					1'b0: color <= k0[(counter_x-305)*22 + counter_y-425];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-305)*22 + counter_y-425];
	//				end
	//		end
			
			else if(counter_x >= 330 && counter_x <352 && counter_y >= 425 && counter_y < 447)begin
					
					case(data[0])
					1'b1: color <= k1[(counter_x-330)*22 + counter_y-425];
					1'b0: color <= k0[(counter_x-330)*22 + counter_y-425];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-330)*22 + counter_y-425];
	//				end
	//		end
			
			else if(counter_x >= 600 && counter_x < 670 && counter_y >= 380 && counter_y < 415)begin
				color<=drop[((counter_x-600)*35 + counter_y-380)];			
			end
			
			else if(counter_x >= 600 && counter_x < 670 && counter_y >= 250 && counter_y < 285)begin
				color<=receive[((counter_x-600)*35 + counter_y-250)];
			end
			
			else if(counter_x >= 600 && counter_x < 670 && counter_y >= 120 && counter_y < 155)begin
				color<=trans[((counter_x-600)*35 + counter_y-120)];
			end
//			
			// FIRST BUFFER
			
			else if(counter_x>= loc_x1 && counter_x < loc_x1 + delta)begin
						if	(counter_y >= loc_y1 && counter_y < loc_y1 + delta)begin
							if(buffer1_o[15])begin
								case(buffer1_o[17:16])
								2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
								2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
								2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
								2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
								endcase
							end
							else color <= empty[{(counter_x - loc_x1) * 35 + counter_y - loc_y1}];
						end
						
						else if	(counter_y>= loc_y2 && counter_y< loc_y2 + delta)begin
							if(buffer1_o[12])begin
								case(buffer1_o[14:13])
								2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
								2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
								2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
								2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
								endcase
							end
							else color <= empty[{(counter_x - loc_x1) * 35 + counter_y - loc_y2}];
						end
						
						else if	(counter_y>= loc_y3 && counter_y< loc_y3 + delta)begin
							if(buffer1_o[9])begin
								case(buffer1_o[11:10])
								2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
								2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
								2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
								2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
								endcase
							end
							else color <= empty[{(counter_x - loc_x1) * 35 + counter_y - loc_y3}];
						end
					
						else if	(counter_y>= loc_y4 && counter_y< loc_y4 + delta)begin
							if(buffer1_o[6])begin
								case(buffer1_o[8:7])
								2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
								2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
								2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
								2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
								endcase
							end
							else color <= empty[{(counter_x - loc_x1) * 35 + counter_y - loc_y4}];
						end
						
						else if	(counter_y>= loc_y5 && counter_y< loc_y5 + delta)begin
							if(buffer1_o[3])begin
								case(buffer1_o[5:4])
								2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
								2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
								2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
								2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
								endcase
							end
							else color <= empty[{(counter_x - loc_x1) * 35 + counter_y - loc_y5}];
						end
						
						else if	(counter_y>= loc_y6 && counter_y< loc_y6 + delta)begin
							if(buffer1_o[0])begin
								case(buffer1_o[2:1])
								2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
								2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
								2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
								2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
								endcase
							end
							else color <= empty[{(counter_x - loc_x1) * 35 + counter_y - loc_y6}];
						end
						else begin color <=8'h0;
					end
					end
					
				
			/// SECOND BUFFER
			
			else if(counter_x>= loc_x2 && counter_x < loc_x2 + delta)begin
				if	(counter_y >= loc_y1 && counter_y < loc_y1 + delta)begin
					if(buffer2_o[15])begin
						case(buffer2_o[17:16])
						2'b00: color <= blue0[{(counter_x - loc_x2) * delta + counter_y - loc_y1}];
						2'b01: color <= blue1[{(counter_x - loc_x2) * delta + counter_y - loc_y1}];
						2'b10: color <= blue2[{(counter_x - loc_x2) * delta + counter_y - loc_y1}];
						2'b11: color <= blue3[{(counter_x - loc_x2) * delta + counter_y - loc_y1}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x2) * 35 + counter_y - loc_y1}];
				end
				
				else if	(counter_y>= loc_y2 && counter_y< loc_y2 + delta)begin
					if(buffer2_o[12])begin
						case(buffer2_o[14:13])
						2'b00: color <= blue0[{(counter_x - loc_x2) * delta + counter_y - loc_y2}];
						2'b01: color <= blue1[{(counter_x - loc_x2) * delta + counter_y - loc_y2}];
						2'b10: color <= blue2[{(counter_x - loc_x2) * delta + counter_y - loc_y2}];
						2'b11: color <= blue3[{(counter_x - loc_x2) * delta + counter_y - loc_y2}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x2) * 35 + counter_y - loc_y2}];
				end
				
				else if	(counter_y>= loc_y3 && counter_y < loc_y3 + delta)begin
					if(buffer2_o[9])begin
						case(buffer2_o[11:10])
						2'b00: color <= blue0[{(counter_x - loc_x2) * delta + counter_y - loc_y3}];
						2'b01: color <= blue1[{(counter_x - loc_x2) * delta + counter_y - loc_y3}];
						2'b10: color <= blue2[{(counter_x - loc_x2) * delta + counter_y - loc_y3}];
						2'b11: color <= blue3[{(counter_x - loc_x2) * delta + counter_y - loc_y3}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x2) * 35 + counter_y - loc_y3}];
				end
			
				else if	(counter_y>= loc_y4 && counter_y< loc_y4 + delta)begin
					if(buffer2_o[6])begin
						case(buffer2_o[8:7])
						2'b00: color <= blue0[{(counter_x - loc_x2) * delta + counter_y - loc_y4}];
						2'b01: color <= blue1[{(counter_x - loc_x2) * delta + counter_y - loc_y4}];
						2'b10: color <= blue2[{(counter_x - loc_x2) * delta + counter_y - loc_y4}];
						2'b11: color <= blue3[{(counter_x - loc_x2) * delta + counter_y - loc_y4}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x2) * 35 + counter_y - loc_y4}];
				end
				
				else if	(counter_y>= loc_y5 && counter_y< loc_y5 + delta)begin
					if(buffer2_o[3])begin
						case(buffer2_o[5:4])
						2'b00: color <= blue0[{(counter_x - loc_x2) * delta + counter_y - loc_y5}];
						2'b01: color <= blue1[{(counter_x - loc_x2) * delta + counter_y - loc_y5}];
						2'b10: color <= blue2[{(counter_x - loc_x2) * delta + counter_y - loc_y5}];
						2'b11: color <= blue3[{(counter_x - loc_x2) * delta + counter_y - loc_y5}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x2) * 35 + counter_y - loc_y5}];
				end
				
				else if	(counter_y>= loc_y6 && counter_y< loc_y6 + delta)begin
					if(buffer2_o[0])begin
						case(buffer2_o[2:1])
						2'b00: color <= blue0[{(counter_x - loc_x2) * delta + counter_y - loc_y6}];
						2'b01: color <= blue1[{(counter_x - loc_x2) * delta + counter_y - loc_y6}];
						2'b10: color <= blue2[{(counter_x - loc_x2) * delta + counter_y - loc_y6}];
						2'b11: color <= blue3[{(counter_x - loc_x2) * delta + counter_y - loc_y6}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x2) * 35 + counter_y - loc_y6}];
				end
				else begin color <=8'h0;
				end
			end
			
			
			/// THIRD BUFFER
			
			else if(counter_x>= loc_x3 && counter_x < loc_x3 + delta)begin
				if	(counter_y >= loc_y1 && counter_y < loc_y1 + delta)begin
					if(buffer3_o[15])begin
						case(buffer3_o[17:16])
						2'b00: color <= yellow0[{(counter_x - loc_x3) * delta + counter_y - loc_y1}];
						2'b01: color <= yellow1[{(counter_x - loc_x3) * delta + counter_y - loc_y1}];
						2'b10: color <= yellow2[{(counter_x - loc_x3) * delta + counter_y - loc_y1}];
						2'b11: color <= yellow3[{(counter_x - loc_x3) * delta + counter_y - loc_y1}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x3) * 35 + counter_y - loc_y1}];
				end
				
				else if	(counter_y>= loc_y2 && counter_y< loc_y2 + delta)begin
					if(buffer3_o[12])begin
						case(buffer3_o[14:13])
						2'b00: color <= yellow0[{(counter_x - loc_x3) * delta + counter_y - loc_y2}];
						2'b01: color <= yellow1[{(counter_x - loc_x3) * delta + counter_y - loc_y2}];
						2'b10: color <= yellow2[{(counter_x - loc_x3) * delta + counter_y - loc_y2}];
						2'b11: color <= yellow3[{(counter_x - loc_x3) * delta + counter_y - loc_y2}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x3) * 35 + counter_y - loc_y2}];
				end
				
				else if	(counter_y>= loc_y3 && counter_y < loc_y3 + delta)begin
					if(buffer3_o[9])begin
						case(buffer3_o[11:10])
						2'b00: color <= yellow0[{(counter_x - loc_x3) * delta + counter_y - loc_y3}];
						2'b01: color <= yellow1[{(counter_x - loc_x3) * delta + counter_y - loc_y3}];
						2'b10: color <= yellow2[{(counter_x - loc_x3) * delta + counter_y - loc_y3}];
						2'b11: color <= yellow3[{(counter_x - loc_x3) * delta + counter_y - loc_y3}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x3) * 35 + counter_y - loc_y3}];
				end
			
				else if	(counter_y>= loc_y4 && counter_y< loc_y4 + delta)begin
					if(buffer3_o[6])begin
						case(buffer3_o[8:7])
						2'b00: color <= yellow0[{(counter_x - loc_x3) * delta + counter_y - loc_y4}];
						2'b01: color <= yellow1[{(counter_x - loc_x3) * delta + counter_y - loc_y4}];
						2'b10: color <= yellow2[{(counter_x - loc_x3) * delta + counter_y - loc_y4}];
						2'b11: color <= yellow3[{(counter_x - loc_x3) * delta + counter_y - loc_y4}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x3) * 35 + counter_y - loc_y4}];
				end
				
				else if	(counter_y>= loc_y5 && counter_y< loc_y5 + delta)begin
					if(buffer3_o[3])begin
						case(buffer3_o[5:4])
						2'b00: color <= yellow0[{(counter_x - loc_x3) * delta + counter_y - loc_y5}];
						2'b01: color <= yellow1[{(counter_x - loc_x3) * delta + counter_y - loc_y5}];
						2'b10: color <= yellow2[{(counter_x - loc_x3) * delta + counter_y - loc_y5}];
						2'b11: color <= yellow3[{(counter_x - loc_x3) * delta + counter_y - loc_y5}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x3) * 35 + counter_y - loc_y5}];
				end
				
				else if	(counter_y>= loc_y6 && counter_y< loc_y6 + delta)begin
					if(buffer3_o[0])begin
						case(buffer3_o[2:1])
						2'b00: color <= yellow0[{(counter_x - loc_x3) * delta + counter_y - loc_y6}];
						2'b01: color <= yellow1[{(counter_x - loc_x3) * delta + counter_y - loc_y6}];
						2'b10: color <= yellow2[{(counter_x - loc_x3) * delta + counter_y - loc_y6}];
						2'b11: color <= yellow3[{(counter_x - loc_x3) * delta + counter_y - loc_y6}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x3) * 35 + counter_y - loc_y6}];
				end
				else begin color <=8'h0;
				end
			end
			
	//		
			/// FOURTH BUFFER
			
			else if(counter_x>= loc_x4 && counter_x < loc_x4 + delta)begin
				if	(counter_y >= loc_y1 && counter_y < loc_y1 + delta)begin
					if(buffer4_o[15])begin
						case(buffer4_o[17:16])
						2'b00: color <= green0[{(counter_x - loc_x4) * delta + counter_y - loc_y1}];
						2'b01: color <= green1[{(counter_x - loc_x4) * delta + counter_y - loc_y1}];
						2'b10: color <= green2[{(counter_x - loc_x4) * delta + counter_y - loc_y1}];
						2'b11: color <= green3[{(counter_x - loc_x4) * delta + counter_y - loc_y1}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x4) * 35 + counter_y - loc_y1}];
				end
				
				else if	(counter_y>= loc_y2 && counter_y< loc_y2 + delta)begin
					if(buffer4_o[12])begin
						case(buffer4_o[14:13])
						2'b00: color <= green0[{(counter_x - loc_x4) * delta + counter_y - loc_y2}];
						2'b01: color <= green1[{(counter_x - loc_x4) * delta + counter_y - loc_y2}];
						2'b10: color <= green2[{(counter_x - loc_x4) * delta + counter_y - loc_y2}];
						2'b11: color <= green3[{(counter_x - loc_x4) * delta + counter_y - loc_y2}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x4) * 35 + counter_y - loc_y2}];
				end
				
				else if	(counter_y>= loc_y3 && counter_y < loc_y3 + delta)begin
					if(buffer4_o[9])begin
						case(buffer4_o[11:10])
						2'b00: color <= green0[{(counter_x - loc_x4) * delta + counter_y - loc_y3}];
						2'b01: color <= green1[{(counter_x - loc_x4) * delta + counter_y - loc_y3}];
						2'b10: color <= green2[{(counter_x - loc_x4) * delta + counter_y - loc_y3}];
						2'b11: color <= green3[{(counter_x - loc_x4) * delta + counter_y - loc_y3}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x4) * 35 + counter_y - loc_y3}];
				end
			
				else if	(counter_y>= loc_y4 && counter_y< loc_y4 + delta)begin
					if(buffer4_o[6])begin
						case(buffer4_o[8:7])
						2'b00: color <= green0[{(counter_x - loc_x4) * delta + counter_y - loc_y4}];
						2'b01: color <= green1[{(counter_x - loc_x4) * delta + counter_y - loc_y4}];
						2'b10: color <= green2[{(counter_x - loc_x4) * delta + counter_y - loc_y4}];
						2'b11: color <= green3[{(counter_x - loc_x4) * delta + counter_y - loc_y4}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x4) * 35 + counter_y - loc_y4}];
				end
				
				else if	(counter_y>= loc_y5 && counter_y< loc_y5 + delta)begin
					if(buffer4_o[3])begin
						case(buffer4_o[5:4])
						2'b00: color <= green0[{(counter_x - loc_x4) * delta + counter_y - loc_y5}];
						2'b01: color <= green1[{(counter_x - loc_x4) * delta + counter_y - loc_y5}];
						2'b10: color <= green2[{(counter_x - loc_x4) * delta + counter_y - loc_y5}];
						2'b11: color <= green3[{(counter_x - loc_x4) * delta + counter_y - loc_y5}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x4) * 35 + counter_y - loc_y5}];
				end
				
				else if	(counter_y>= loc_y6 && counter_y< loc_y6 + delta)begin
					if(buffer4_o[0])begin
						case(buffer4_o[2:1])
						2'b00: color <= green0[{(counter_x - loc_x4) * delta + counter_y - loc_y6}];
						2'b01: color <= green1[{(counter_x - loc_x4) * delta + counter_y - loc_y6}];
						2'b10: color <= green2[{(counter_x - loc_x4) * delta + counter_y - loc_y6}];
						2'b11: color <= green3[{(counter_x - loc_x4) * delta + counter_y - loc_y6}];
						endcase
					end
					else color <= empty[{(counter_x - loc_x4) * 35 + counter_y - loc_y6}];
				end
			else begin color <=8'h0;
				end
			end
		
	//		
				
			/// RHS WRITINGS
			//TRANSMITTED
		
			else if (counter_x >= 500 && counter_x < 535 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[{(counter_x - 500) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 545 && counter_x < 580 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[{(counter_x - 545) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 590 && counter_x < 625 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[{(counter_x - 590) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 635 && counter_x < 670 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[{(counter_x - 635) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 680 && counter_x < 715 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[{(counter_x - 680) * 35 + counter_y - 165}];
			end
			
			//RECEIVED
			
			else if (counter_x >= 500 && counter_x < 535 && counter_y >= 295 && counter_y < 330)begin
				color <= empty[{(counter_x - 500) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 545 && counter_x < 580 && counter_y >= 295 && counter_y < 330)begin
				color <= empty[{(counter_x - 545) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 590 && counter_x < 625 && counter_y >= 295 && counter_y < 330)begin
				color <= empty[{(counter_x - 590) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 635 && counter_x < 670 && counter_y >= 295 && counter_y < 330)begin
				color <= empty[{(counter_x - 635) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 680 && counter_x < 715 && counter_y >= 295 && counter_y < 330)begin
				color <= empty[{(counter_x - 680) * 35 + counter_y - 295}];
			end
			
			// DROPPED
			
			else if (counter_x >= 500 && counter_x < 535 && counter_y >= 425 && counter_y < 460)begin
				color <= empty[{(counter_x - 500) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 545 && counter_x < 580 && counter_y >= 425 && counter_y < 460)begin
				color <= empty[{(counter_x - 545) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 590 && counter_x < 625 && counter_y >= 425 && counter_y < 460)begin
				color <= empty[{(counter_x - 590) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 635 && counter_x < 670 && counter_y >= 425 && counter_y < 460)begin
				color <= empty[{(counter_x - 635) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 680 && counter_x < 715 && counter_y >= 425 && counter_y < 460)begin
				color <= empty[{(counter_x - 680) * 35 + counter_y - 425}];
			end
			
			else begin color <=8'h0;
			end
	
	end
	assign o_color = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? color : 8'h0;
	
	endmodule

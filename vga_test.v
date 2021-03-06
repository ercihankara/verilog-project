`timescale 1ns / 1ps

module vga_test(
	input clk,           // 50 MHz
	output o_hsync,      // horizontal sync
	output o_vsync,	     // vertical sync
	output wire [7:0] o_color,  
	output reg clk25MHz
);

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

reg [7:0] zero[0:664]; // 36x19
reg [7:0] one[0:664];
reg [7:0] two[0:664];
reg [7:0] three[0:664];
reg [7:0] four[0:664];
reg [7:0] five[0:664];
reg [7:0] six[0:664];
reg [7:0] seven[0:664];
reg [7:0] eight[0:664];
reg [7:0] nine[0:664];

//reg [7:0] b1title [0:224];
//reg [7:0] b2title [0:224];
//reg [7:0] b3title [0:224];
//reg [7:0] b4title [0:224];   	

reg [7:0] trans [0:1874];
reg [7:0] receive [0:1874];
reg [7:0] drop [0:1249];

reg reset = 0;  // for PLL

// TESTING

reg [17:0] buffer1_o = 18'b000000111101011001;
reg [17:0] buffer2_o = 18'b110100010010111001;
reg [17:0] buffer3_o = 18'b000000000000000011;
reg [17:0] buffer4_o = 18'b000000000111101101;
reg [3:0] data = 4'b0011;
reg [3:0] oku = 4'b1010;
	
		always @ (posedge clk) begin
			clk25MHz <= ~clk25MHz;
			end
		
	
	initial begin
	
		$readmemh ("empty.txt", empty);
		$readmemh ("emptys.txt", emptys);
		$readmemh ("drop.txt", drop);
		$readmemh ("receive.txt", receive);
		$readmemh ("trans.txt", trans);
		$readmemh ("read.txt", read);
		$readmemh ("input.txt", inp);
		$readmemh ("keyone.txt", k1);
		$readmemh ("keyzero.txt", k0);
		
		$readmemh ("zero.txt", zero);
		$readmemh ("one.txt", one);
		$readmemh ("two.txt", two);
		$readmemh ("three.txt", three);
		$readmemh ("four.txt", four);
		$readmemh ("five.txt", five);
		$readmemh ("six.txt", six);
		$readmemh ("seven.txt", seven);
		$readmemh ("eight.txt", eight);
		$readmemh ("nine.txt", nine);
		
//		$readmemh ("b1title.txt", b1title);
//		$readmemh ("b2title.txt", b2title);
//		$readmemh ("b3title.txt", b3title);
//		$readmemh ("b4title.txt", b4title);
		
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
					case(oku[3]) 
					1'b1: color <= k1[(counter_x-255)*22 + counter_y-85];
					1'b0: color <= k0[(counter_x-255)*22 + counter_y-85];
					endcase
				end
	//			else begin
	//			color <= emptys[(counter_x-255)*22 + counter_y-85];
	//			end
	//		end
			
			else if(counter_x >= 280 && counter_x <302 && counter_y >= 85 && counter_y < 107)begin
					 
						case(oku[2])
						1'b1: color <= k1[(counter_x-280)*22 + counter_y-85];
						1'b0: color <= k0[(counter_x-280)*22 + counter_y-85];
						endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-280)*22 + counter_y-85];
	//				end
	//		end
			else if(counter_x >= 305 && counter_x <327 && counter_y >= 85 && counter_y < 107)begin
					
					case(oku[1])
					1'b1: color <= k1[(counter_x-305)*22 + counter_y-85];
					1'b0: color <= k0[(counter_x-305)*22 + counter_y-85];
					endcase
					end
	//				else begin
	//				color <= emptys[(counter_x-305)*22 + counter_y-85];
	//				end
	//		end
			
			else if(counter_x >= 330 && counter_x <352 && counter_y >= 85 && counter_y < 107)begin
				 
					case(oku[0]) 
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
			
			else if(counter_x >= 570 && counter_x < 620 && counter_y >= 380 && counter_y < 405)begin
				color<=drop[((counter_x-570)*25 + counter_y-380)];			
			end
			
			else if(counter_x >= 570 && counter_x < 645 && counter_y >= 250 && counter_y < 275)begin
				color<=receive[((counter_x-570)*25 + counter_y-250)];
			end
			
			else if(counter_x >= 570 && counter_x < 645 && counter_y >= 120 && counter_y < 145)begin
				color<=trans[((counter_x-570)*25 + counter_y-120)];
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
			//buffer1
			else if (counter_x >= 500 && counter_x < 519 && counter_y >= 165 && counter_y < 200)begin
				color <= one[{(counter_x - 500) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 519 && counter_x < 538 && counter_y >= 165 && counter_y < 200)begin
				color <= two[{(counter_x - 519) * 35 + counter_y - 165}];
			end
			
			//buffer2
			else if (counter_x >= 545 && counter_x < 564 && counter_y >= 165 && counter_y < 200)begin
				color <= three[{(counter_x - 545) * 35 + counter_y - 165}];
			end
			else if (counter_x >= 564 && counter_x < 583 && counter_y >= 165 && counter_y < 200)begin
				color <= four[{(counter_x - 564) * 35 + counter_y - 165}];
			end
			
			//buffer3
			else if (counter_x >= 590 && counter_x < 619 && counter_y >= 165 && counter_y < 200)begin
				color <= five[{(counter_x - 590) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 619 && counter_x < 638 && counter_y >= 165 && counter_y < 200)begin
				color <= six[{(counter_x - 619) * 35 + counter_y - 165}];
			end
			
			//buffer4
			else if (counter_x >=645 && counter_x < 664 && counter_y >= 165 && counter_y < 200)begin
				color <= seven[{(counter_x - 645) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 664 && counter_x < 683 && counter_y >= 165 && counter_y < 200)begin
				color <= eight[{(counter_x - 664) * 35 + counter_y - 165}];
			end
			
			//total
			else if (counter_x >=690 && counter_x <709 && counter_y >= 165 && counter_y < 200)begin
				color <= zero[{(counter_x - 690) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 709 && counter_x < 728 && counter_y >= 165 && counter_y < 200)begin
				color <= nine[{(counter_x - 709) * 35 + counter_y - 165}];
			end
			
			else if (counter_x >= 728 && counter_x < 747 && counter_y >= 165 && counter_y < 200)begin
				color <= nine[{(counter_x - 728) * 35 + counter_y - 165}];
			end
			
			//RECEIVED
			
			//buffer1
			else if (counter_x >= 500 && counter_x < 519 && counter_y >= 295 && counter_y < 330)begin
				color <= one[{(counter_x - 500) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 519 && counter_x < 538 && counter_y >= 295 && counter_y < 330)begin
				color <= two[{(counter_x - 519) * 35 + counter_y - 295}];
			end
			
			//buffer2
			else if (counter_x >= 545 && counter_x < 564 && counter_y >= 295 && counter_y < 330)begin
				color <= three[{(counter_x - 545) * 35 + counter_y - 295}];
			end
			else if (counter_x >= 564 && counter_x < 583 && counter_y >= 295 && counter_y < 330)begin
				color <= four[{(counter_x - 564) * 35 + counter_y - 295}];
			end
			
			//buffer3
			else if (counter_x >= 590 && counter_x < 619 && counter_y >= 295 && counter_y < 330)begin
				color <= five[{(counter_x - 590) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 619 && counter_x < 638 && counter_y >= 295 && counter_y < 330)begin
				color <= six[{(counter_x - 619) * 35 + counter_y - 295}];
			end
			
			//buffer4
			else if (counter_x >=645 && counter_x < 664 && counter_y >= 295 && counter_y < 330)begin
				color <= seven[{(counter_x - 645) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 664 && counter_x < 683 && counter_y >= 295 && counter_y < 330)begin
				color <= eight[{(counter_x - 664) * 35 + counter_y - 295}];
			end
			
			//total
			else if (counter_x >=690 && counter_x <709 && counter_y >= 295 && counter_y < 330)begin
				color <= zero[{(counter_x - 690) * 35 + counter_y - 295}];
			end
			
			else if (counter_x >= 709 && counter_x < 728 && counter_y >= 295 && counter_y < 330)begin
				color <= nine[{(counter_x - 709) * 35 + counter_y - 295}];
			end
			else if (counter_x >= 728 && counter_x < 747 && counter_y >= 295 && counter_y < 330)begin
				color <= nine[{(counter_x - 728) * 35 + counter_y - 295}];
			end
			
			// DROPPED
			//buffer1
			else if (counter_x >= 500 && counter_x < 519 && counter_y >= 425 && counter_y < 460)begin
				color <= one[{(counter_x - 500) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 519 && counter_x < 538 && counter_y >= 425 && counter_y < 460)begin
				color <= two[{(counter_x - 519) * 35 + counter_y - 425}];
			end
			
			//buffer2
			else if (counter_x >= 545 && counter_x < 564 && counter_y >= 425 && counter_y < 460)begin
				color <= three[{(counter_x - 545) * 35 + counter_y - 425}];
			end
			else if (counter_x >= 564 && counter_x < 583 && counter_y >= 425 && counter_y < 460)begin
				color <= four[{(counter_x - 564) * 35 + counter_y - 425}];
			end
			
			//buffer3
			else if (counter_x >= 590 && counter_x < 619 && counter_y >= 425 && counter_y < 460)begin
				color <= five[{(counter_x - 590) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 619 && counter_x < 638 && counter_y >= 425 && counter_y < 460)begin
				color <= six[{(counter_x - 619) * 35 + counter_y - 425}];
			end
			
			//buffer4
			else if (counter_x >=645 && counter_x < 664 && counter_y >= 425 && counter_y < 460)begin
				color <= seven[{(counter_x - 645) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 664 && counter_x < 683 && counter_y >= 425 && counter_y < 460)begin
				color <= eight[{(counter_x - 664) * 35 + counter_y - 425}];
			end
			
			//total
			else if (counter_x >=690 && counter_x <709 && counter_y >= 425 && counter_y < 460)begin
				color <= zero[{(counter_x - 690) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 709 && counter_x < 728 && counter_y >= 425 && counter_y < 460)begin
				color <= nine[{(counter_x - 709) * 35 + counter_y - 425}];
			end
			
			else if (counter_x >= 728 && counter_x < 747 && counter_y >= 425 && counter_y < 460)begin
				color <= nine[{(counter_x - 728) * 35 + counter_y - 425}];
			end
			
//			/// RHS WRITINGS
//			//TRANSMITTED
//		
//			else if (counter_x >= 500 && counter_x < 535 && counter_y >= 165 && counter_y < 200)begin
//				color <= empty[{(counter_x - 500) * 35 + counter_y - 165}];
//			end
//			
//			else if (counter_x >= 545 && counter_x < 580 && counter_y >= 165 && counter_y < 200)begin
//				color <= empty[{(counter_x - 545) * 35 + counter_y - 165}];
//			end
//			
//			else if (counter_x >= 590 && counter_x < 625 && counter_y >= 165 && counter_y < 200)begin
//				color <= empty[{(counter_x - 590) * 35 + counter_y - 165}];
//			end
//			
//			else if (counter_x >= 635 && counter_x < 670 && counter_y >= 165 && counter_y < 200)begin
//				color <= empty[{(counter_x - 635) * 35 + counter_y - 165}];
//			end
//			
//			else if (counter_x >= 680 && counter_x < 715 && counter_y >= 165 && counter_y < 200)begin
//				color <= empty[{(counter_x - 680) * 35 + counter_y - 165}];
//			end
//			
//			//RECEIVED
//			
//			else if (counter_x >= 500 && counter_x < 535 && counter_y >= 295 && counter_y < 330)begin
//				color <= empty[{(counter_x - 500) * 35 + counter_y - 295}];
//			end
//			
//			else if (counter_x >= 545 && counter_x < 580 && counter_y >= 295 && counter_y < 330)begin
//				color <= empty[{(counter_x - 545) * 35 + counter_y - 295}];
//			end
//			
//			else if (counter_x >= 590 && counter_x < 625 && counter_y >= 295 && counter_y < 330)begin
//				color <= empty[{(counter_x - 590) * 35 + counter_y - 295}];
//			end
//			
//			else if (counter_x >= 635 && counter_x < 670 && counter_y >= 295 && counter_y < 330)begin
//				color <= empty[{(counter_x - 635) * 35 + counter_y - 295}];
//			end
//			
//			else if (counter_x >= 680 && counter_x < 715 && counter_y >= 295 && counter_y < 330)begin
//				color <= empty[{(counter_x - 680) * 35 + counter_y - 295}];
//			end
//			
//			// DROPPED
//			
//			else if (counter_x >= 500 && counter_x < 535 && counter_y >= 425 && counter_y < 460)begin
//				color <= empty[{(counter_x - 500) * 35 + counter_y - 425}];
//			end
//			
//			else if (counter_x >= 545 && counter_x < 580 && counter_y >= 425 && counter_y < 460)begin
//				color <= empty[{(counter_x - 545) * 35 + counter_y - 425}];
//			end
//			
//			else if (counter_x >= 590 && counter_x < 625 && counter_y >= 425 && counter_y < 460)begin
//				color <= empty[{(counter_x - 590) * 35 + counter_y - 425}];
//			end
//			
//			else if (counter_x >= 635 && counter_x < 670 && counter_y >= 425 && counter_y < 460)begin
//				color <= empty[{(counter_x - 635) * 35 + counter_y - 425}];
//			end
//			
//			else if (counter_x >= 680 && counter_x < 715 && counter_y >= 425 && counter_y < 460)begin
//				color <= empty[{(counter_x - 680) * 35 + counter_y - 425}];
//			end
			else begin color <=8'h0;
			end
	
	end
	assign o_color = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? color : 8'h0;
		
	endmodule

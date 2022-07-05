`timescale 1ns / 1ps

module dyn_vga_test(
	input clk,           // 50 MHz
	output o_hsync,      // horizontal sync
	output o_vsync,	     // vertical sync
	output [7:0] o_color,  
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

parameter delta = 35;

	
initial begin

	$readmemh ("empty.txt", empty);
	
	$readmemh ("b1title.txt", b1title);
	$readmemh ("b2title.txt", b2title);
	$readmemh ("b3title.txt", b3title);
	$readmemh ("b4title.txt", b4title);
	
	$readmemh ("red0.txt", read0);
	$readmemh ("red1.txt", read1);
	$readmemh ("red2.txt", read2);
	$readmemh ("red3.txt", read3);
	
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
	reg [9:0] counter_x = 0;  // horizontal counter
	reg [9:0] counter_y = 0;  // vertical counter
	reg [7:0] color = 0;
	reg [7:0] empty [0:1224];
	reg [7:0] red0 [0:1224];
	reg [7:0] red1 [0:1224];
	reg [7:0] red2 [0:1224];
	reg [7:0] red3 [0:1224];
	reg [7:0] blue0 [0:1224];
	reg [7:0] blue1 [0:1224];
	reg [7:0] blue2 [0:1224];
	reg [7:0] blue3 [0:1224];
	reg [7:0] green0 [0:1224];
	reg [7:0] green1 [0:1224];
	reg [7:0] green2 [0:1224];
	reg [7:0] green3 [0:1224];
	reg [7:0] yellow0 [0:1224];
	reg [7:0] yellow1 [0:1224];
	reg [7:0] yellow2 [0:1224];
	reg [7:0] yellow3 [0:1224];
	reg [7:0] emptys [0:483];
	reg [7:0] b1title [0:224];
	reg [7:0] b2title [0:224];
	reg [7:0] b3title [0:224];
	reg [7:0] b4title [0:224];   	
	reg [7:0] trans [0:2808];
	reg [7:0] receive [0:2808];
	reg [7:0] drop [0:2808];
	
	reg reset = 0;  // for PLL

	always @ (posedge clk) begin
		clk25MHz <= ~clk25MHz;
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
	
	
	// hsync and vsync output assignments
	assign o_hsync = (counter_x >= 0 && counter_x < 96) ? 1:0;  // hsync high for 96 counts                                                 
	assign o_vsync = (counter_y >= 0 && counter_y < 2) ? 1:0;   // vsync high for 2 counts
	// end hsync and vsync output assignments


	always @ (posedge clk)
		begin
		
		/// FIRST BUFFER
		
		if(counter_x>= loc_x1 && counter_y< loc_x1 + delta)begin
			if	(counter_y>= loc_y1 && counter_y< loc_y1 + delta)begin
				if(buffer1_o[0])begin
					case(buffer1_o[2:1])
					2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
					2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
					2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
					2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
					endcase
				end
				else color <= empty[{(counter_x - loc_x1) * delta + counter_y - loc_y1}];
			end
			
			else if	(counter_y>= loc_y2 && counter_y< loc_y2 + delta)begin
				if(buffer1_o[3])begin
					case(buffer1_o[5:4])
					2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
					2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
					2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
					2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
					endcase
				end
				else color <= empty[{(counter_x - loc_x1) * delta + counter_y - loc_y2}];
			end
			
			else if	(counter_y>= loc_y3 && counter_y< loc_y3 + delta)begin
				if(buffer1_o[6])begin
					case(buffer1_o[8:7])
					2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
					2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
					2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
					2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
					endcase
				end
				else color <= empty[{(counter_x - loc_x1) * delta + counter_y - loc_y3}];
			end
		
			else if	(counter_y>= loc_y4 && counter_y< loc_y4 + delta)begin
				if(buffer1_o[9])begin
					case(buffer1_o[11:10])
					2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
					2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
					2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
					2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
					endcase
				end
				else color <= empty[{(counter_x - loc_x1) * delta + counter_y - loc_y4}];
			end
			
			else if	(counter_y>= loc_y1 && counter_y< loc_y1 + delta)begin
				if(buffer1_o[12])begin
					case(buffer1_o[14:13])
					2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
					2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
					2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
					2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
					endcase
				end
				else color <= empty[{(counter_x - loc_x1) * delta + counter_y - loc_y5}];
			end
			
			else if	(counter_y>= loc_y6 && counter_y< loc_y6 + delta)begin
				if(buffer1_o[15])begin
					case(buffer1_o[17:16])
					2'b00: color <= red0[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
					2'b01: color <= red1[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
					2'b10: color <= red2[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
					2'b11: color <= red3[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
					endcase
				end
				else color <= empty[{(counter_x - loc_x1) * delta + counter_y - loc_y6}];
			end
		
			// READ DATA 
			else if(counter_x >= 255 && counter_x < 277 && counter_y >= 85 && counter_y < 107)begin
				color <= emptys[(counter_x-255)*22 + counter_y-85];
			end
			
			else if(counter_x >= 280 && counter_x <302 && counter_y >= 85 && counter_y < 107)begin
				color <= emptys[(counter_x-280)*22 + counter_y-85];
			end
			else if(counter_x >= 305 && counter_x <327 && counter_y >= 85 && counter_y < 107)begin
				color <= emptys[(counter_x-305)*22 + counter_y-85];
			end
			
			else if(counter_x >= 330 && counter_x <352 && counter_y >= 85 && counter_y < 107)begin
				color <= emptys[(counter_x-330)*22 + counter_y-85];
			end
			
			/// SECOND BUFFER
			else if(counter_x >= 255 && counter_x < 290 && counter_y >= 120 && counter_y < 155)begin
				color <= empty[(counter_x-255)*35 + counter_y-120];
			end	
			else if(counter_x >= 255 && counter_x < 290 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[(counter_x-255)*35 + counter_y-165];
			end
			else if(counter_x >= 255 && counter_x < 290 && counter_y >= 210 && counter_y < 245)begin
				color <= empty[(counter_x-255)*35 + counter_y-210];
			end
			else if(counter_x >= 255 && counter_x < 290 && counter_y >= 255 && counter_y < 290)begin
				color <= empty[(counter_x-255)*35 + counter_y-255];
			end
			else if(counter_x >= 255 && counter_x < 290 && counter_y >= 300 && counter_y < 335)begin
				color <= empty[(counter_x-255)*35 + counter_y-300];
			end
			else if(counter_x >= 255 && counter_x < 290 && counter_y >= 345 && counter_y < 380)begin
				color <= empty[(counter_x-255)*35 + counter_y-345];
			end
			else if(counter_x >= 255 && counter_x < 270 && counter_y >= 390 && counter_y < 405)begin
				color <= b2title[(counter_x-255)*15 + counter_y-390];
			end
			
			/// THIRD BUFFER
			else if(counter_x >= 315 && counter_x < 350 && counter_y >= 120 && counter_y < 155)begin
				color <= empty[(counter_x-315)*35 + counter_y-120];
			end	
			else if(counter_x >= 315 && counter_x < 350 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[(counter_x-315)*35 + counter_y-165];
			end
			else if(counter_x >= 315 && counter_x < 350 && counter_y >= 210 && counter_y < 245)begin
				color <= empty[(counter_x-315)*35 + counter_y-210];
			end
			else if(counter_x >= 315 && counter_x < 350 && counter_y >= 255 && counter_y < 290)begin
				color <= empty[(counter_x-315)*35 + counter_y-255];
			end
			else if(counter_x >= 315 && counter_x < 350 && counter_y >= 300 && counter_y < 335)begin
				color <= empty[(counter_x-315)*35 + counter_y-300];
			end
			else if(counter_x >= 315 && counter_x < 350 && counter_y >= 345 && counter_y < 380)begin
				color <= empty[(counter_x-315)*35 + counter_y-345];
			end
			else if(counter_x >= 315 && counter_x < 330 && counter_y >= 390 && counter_y < 405)begin
				color <= b3title[(counter_x-315)*15 + counter_y-390];	
			end		
			/// FOURTH BUFFER
			else if(counter_x >= 375 && counter_x < 410 && counter_y >= 120 && counter_y < 155)begin
				color <= empty[(counter_x-375)*35 + counter_y-120];
			end	
			else if(counter_x >= 375 && counter_x < 410 && counter_y >= 165 && counter_y < 200)begin
				color <= empty[(counter_x-375)*35 + counter_y-165];
			end
			else if(counter_x >= 375 && counter_x < 410 && counter_y >= 210 && counter_y < 245)begin
				color <= empty[(counter_x-375)*35 + counter_y-210];
			end
			else if(counter_x >= 375 && counter_x < 410 && counter_y >= 255 && counter_y < 290)begin
				color <= empty[(counter_x-375)*35 + counter_y-255];
			end
			else if(counter_x >= 375 && counter_x < 410 && counter_y >= 300 && counter_y < 335)begin
				color <= empty[(counter_x-375)*35 + counter_y-300];
			end
			else if(counter_x >= 375 && counter_x < 410 && counter_y >= 345 && counter_y < 380)begin
				color <= empty[(counter_x-375)*35 + counter_y-345];
			end
			else if(counter_x >= 375 && counter_x < 390 && counter_y >= 390 && counter_y < 405)begin
				color <= b4title[(counter_x-375)*15 + counter_y-390];
			end
			
				// INPUT DATA 
			else if(counter_x >= 255 && counter_x < 277 && counter_y >= 425 && counter_y < 447)begin
				color <= emptys[(counter_x-255)*22 + counter_y-425];
			end
			
			else if(counter_x >= 280 && counter_x <302 && counter_y >= 425 && counter_y < 447)begin
				color <= emptys[(counter_x-280)*22 + counter_y-425];
			end
			else if(counter_x >= 305 && counter_x <327 && counter_y >= 425 && counter_y < 447)begin
				color <= emptys[(counter_x-305)*22 + counter_y-425];
			end
			
			else if(counter_x >= 330 && counter_x <352 && counter_y >= 425 && counter_y < 447)begin
				color <= emptys[(counter_x-330)*22 + counter_y-425];
			end
			
	//			// RHS WRITINGS
			else if(counter_x >= 640 && counter_x < 680 && counter_y >= 120 && counter_y < 160)begin
				color<=trans[((counter_x-640)*40 + counter_y-120)];
			end
			
			else if(counter_x >= 640 && counter_x < 680 && counter_y >= 250 && counter_y < 290)begin
				color<=receive[((counter_x-640)*40 + counter_y-250)];
			end
			
			else if(counter_x >= 640 && counter_x < 680 && counter_y >= 380 && counter_y < 420)begin
				color<=drop[((counter_x-640)*40 + counter_y-380)];
			end
			
			else color <=8'h0;
			
	
			end 
						

	assign o_color = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? color : 8'h0;

	end 
endmodule
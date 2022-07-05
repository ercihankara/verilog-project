`timescale 1ns / 1ps

module dyn_vga_test(
	input clk,           // 50 MHz
	output o_hsync,      // horizontal sync
	output o_vsync,	     // vertical sync
	output [7:0] o_color,  
	output reg clk25MHz
);

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
	
initial begin
	$readmemh ("empty.txt", empty);
	$readmemh ("emptys.txt", emptys);
	$readmemh ("b1title.txt", b1title);
	$readmemh ("b2title.txt", b2title);
	$readmemh ("b3title.txt", b3title);
	$readmemh ("b4title.txt", b4title);
	$readmemh ("drop.txt", drop);
	$readmemh ("receive.txt", receive);
	$readmemh ("trans.txt", trans);
	
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
	// end counter and sync generation  

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// hsync and vsync output assignments
	assign o_hsync = (counter_x >= 0 && counter_x < 96) ? 1:0;  // hsync high for 96 counts                                                 
	assign o_vsync = (counter_y >= 0 && counter_y < 2) ? 1:0;   // vsync high for 2 counts
	// end hsync and vsync output assignments

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// pattern generate
		always @ (posedge clk)
		begin
		
		/// FIRST BUFFER
		if(counter_x >= 200 && counter_x < 235 && counter_y >= 120 && counter_y < 155)begin
			color <= empty[(counter_x-200)*35 + counter_y-120];
		end	
		else if(counter_x >= 200 && counter_x < 235 && counter_y >= 165 && counter_y < 200)begin
			color <= empty[(counter_x-200)*35 + counter_y-165];
		end
		else if(counter_x >= 200 && counter_x < 235 && counter_y >= 210 && counter_y < 245)begin
			color <= empty[(counter_x-200)*35 + counter_y-210];
		end
		else if(counter_x >= 200 && counter_x < 235 && counter_y >= 255 && counter_y < 290)begin
			color <= empty[(counter_x-200)*35 + counter_y-255];
		end
		else if(counter_x >= 200 && counter_x < 235 && counter_y >= 300 && counter_y < 335)begin
			color <= empty[(counter_x-200)*35 + counter_y-300];
		end
		else if(counter_x >= 200 && counter_x < 235 && counter_y >= 345 && counter_y < 380)begin
			color <= empty[(counter_x-200)*35 + counter_y-345];
		end
		else if(counter_x >= 200 && counter_x < 215 && counter_y >= 390 && counter_y < 405)begin
			color <= b1title[(counter_x-200)*15 + counter_y-390];
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
		else if(counter_x >= 640 && counter_x < 693 && counter_y >= 120 && counter_y < 173)begin
			color<=trans[((counter_x-640)*53 + counter_y-120)];
		end
		
		else if(counter_x >= 640 && counter_x < 693 && counter_y >= 250 && counter_y < 303)begin
			color<=receive[((counter_x-640)*53 + counter_y-250)];
		end
		
		else if(counter_x >= 640 && counter_x < 693 && counter_y >= 380 && counter_y < 433)begin
			color<=drop[((counter_x-640)*53 + counter_y-380)];
		end
		
		else color <=8'h0;
		

		end 
						

	assign o_color = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? color : 8'h0;

	
endmodule
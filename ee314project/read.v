module take_in
(input clk, input start, input key1, input key2);
reg [17:0] buffer1_o;
reg [17:0] buffer2_o; 
reg [17:0] buffer3_o;
reg [17:0] buffer4_o;
reg [2:0] buffer1_r [5:0];
reg [2:0] buffer2_r [5:0];
reg [2:0] buffer3_r [5:0];
reg [2:0] buffer4_r [5:0];
reg mode;
integer i = 0;
integer 	m;
integer j;

wire [2:0] L1, L2, L3, L4;
wire [5:0] rea_sc;
wire [5:0] lat_sc;

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
	
		holder <= 1;
		
	end
	
	initial begin
		
		if (holder == 1) begin
					
				for (h = 0; h < 4; h = h + 1) begin
				
					if (key1)
						data[3 - h] = 1'b1;
					else if (key2)
						data[3 - h] = 1'b0;
						
				end
				holder <= 0;
		end
		
	end


	integer i1 = 0, i2 = 0, i3 = 0, i4 = 0;
	integer f;
// BOB1B2B3
// input is stored from left I guess
	
	always@ (*) begin
	
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
	
	always@ (*) begin
		
			for (f = 0; f < 6; f = f+1) begin
		
				buffer1_o[3*f+2 -:3] <= buffer1[f];
				buffer2_o[3*f+2 -:3] <= buffer2[f];
				buffer3_o[3*f+2 -:3] <= buffer3[f];
				buffer4_o[3*f+2 -:3] <= buffer4[f];

			end		
	end
	
endmodule
// modules: take input, read data, shift and arrange registers

//module read
//#(parameter threshold = 3)
//output reg [1:0] disp, input [17:0] buffer1_o, input [17:0] buffer2_o, input [17:0] buffer3_o, input [17:0] buffer4_o,
//output reg [17:0] buffer1_open, output reg [17:0] buffer2_open,
//output reg [17:0] buffer3_open, output reg [17:0] buffer4_open);
	
// take input bitwise then create the buffers inside the module again

//reg [17:0] buffer1_open;
//reg [17:0] buffer2_open;
//reg [17:0] buffer3_open;
//reg [17:0] buffer4_open;
//	
//	always@ (*) begin
//		buffer1_open <= buffer1_o;
//		buffer2_open <= buffer2_o;
//		buffer3_open <= buffer3_o;
//		buffer4_open <= buffer4_o;
//	
//	end
	


// LSB of one 3-bit data is the validity bit 1-0

//	count counter(.buffer1_o (buffer1_open), .buffer2_o (buffer2_open), .buffer3_o (buffer3_open), .buffer4_o (buffer4_open), .L1 (L1), .L2 (L2), .L3 (L3), .L4 (L4));
//	score scorer(.L1 (L1), .L2 (L2), .L3 (L3), .L4 (L4), .RS (rea_sc), .LS (lat_sc));
//	freqdivider freqdividerer(.clk (clk), .clk_out (clk_divided));
		
//	always@(clk) begin
//	
//		for (i = 0; i < 6; i = i+1) begin
//		
//			buffer1_r[i] <= buffer1_o[3*i+2 -:3];
//			buffer2_r[i] <= buffer2_o[3*i+2 -:3];
//			buffer3_r[i] <= buffer3_o[3*i+2 -:3];
//			buffer4_r[i] <= buffer4_o[3*i+2 -:3];
//			
//		end
//	
//	end

	// divide clock (50Hz) to get 3sec period
	

// counter


	always@ (*) begin

		reg L1 = 0;
		reg L2 = 0;
		reg L3 = 0;
		reg L4 = 0;

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
	end

	

//score
	always @ (*) begin
		reg RS;
		reg LS;

		RS <= 1*L1 + 2*L2 + 3*L3 + 4*L4 ;
		LS <= 4*L1 + 3*L2 + 2*L3 + 1*L4 ;
		
	end


	// freq divider
	
	always@(posedge clk) begin
	
		reg[23:0] counter;
		reg clk_out;
		
		if(counter==24'd75000000) begin
			counter <= 16'd0;
			clk_out <= ~clk_out;
		end
		
		else begin
			counter <= counter +1;
		end
	
	end
	
	always@ (posedge clk_divided) begin
	
		// Reliability Mode (mode 1)
		// Latency Mode (mode 0)
		
		if(rea_sc < lat_sc)
		
			mode <= 0;
			
		else 
		
			mode <= 1;
					
		case(mode)
		
		1'b0: begin
			
			if(L1 > L2 && L1 > L3 && L1 > L4) begin
					//shift1
					for(m = 0; m < 15; m = m + 1) begin
						buffer1_open[m] <= buffer1_open[m+3];
						// new empty space will be initialized to 0
					end
					
					disp <= buffer1_r[0][2:1];
					buffer1_open[0] <= 1'b0;
					
				end
				
				else if(L2 > L1 && L2 > L3 && L2 > L4) begin
					//shift2
					for(m = 0; m < 15; m = m + 1) begin
						buffer2_open[m] <= buffer2_open[m+3];
					end
					
					disp <= buffer2_r[0][2:1];
					buffer2_open[0] <= 1'b0;
					
				end
				
				else if(L3 > L4) begin
					//shift3
					for(m = 0; m < 15; m = m + 1) begin
						buffer3_open[m] <= buffer3_open[m+3];
						buffer3_open[m+3] <= 0;
					end
					
					disp <= buffer3_r[0][2:1];
					buffer3_open[0] <= 1'b0;
					
				end
					
				else begin
					//shift4
					for(m = 0; m < 15; m = m + 1) begin
						buffer4_open[m] <= buffer4_open[m+3];
					end
					
					disp <= buffer4_r[0][2:1];
					buffer4_open[0] <= 1'b0;
					
				end
			end			
		
		1'b1: begin
			
			if(L4 > L1 && L4 > L2 && L4 > L3) begin
					//shift4
					for(m = 0; m < 15; m = m + 1) begin
						buffer4_open[m] <= buffer4_open[m+3];
					end
					
					disp <= buffer4_r[0][2:1];
					buffer4_open[0] <= 1'b0;
					
				end
				
				else if(L3>L1 && L3>L2 && L3>L4) begin
					//shift3
					for(m = 0; m < 15; m = m + 1) begin
						buffer3_open[m] <= buffer3_open[m+3];
					end
				
					disp <= buffer3_r[0][2:1];
					buffer3_open[0] <= 1'b0;
					
				end
				
				else if(L2>L1) begin
					//shift2
					for(m = 0; m < 15; m = m + 1) begin
						buffer2_open[m] <= buffer2_open[m+3];
					end
					
					disp <= buffer2_r[0][2:1];
					buffer2_open[0] <= 1'b0;
					
				end
				
				else begin
					//shift1
					for(m = 0; m < 15; m = m + 1) begin
						buffer1_open[m] <= buffer1_open[m+3];
					end
					
					disp <= buffer1_r[0][2:1];
					buffer1_open[0] <= 1'b0;
					
				end
			end
			
		endcase
	end
	
endmodule
`include "C:/Users/ercih/Desktop/project/count.v"
`include "C:/Users/ercih/Desktop/project/score.v"
`include "C:/Users/ercih/Desktop/project/freqdivider.v"

module read
#(
    parameter threshold = 3
)
(input clk, output reg [1:0] disp, input [17:0] buffer1_o, input [17:0] buffer2_o, input [17:0] buffer3_o, input [17:0] buffer4_o,
output reg [17:0] buffer1_open, output reg [17:0] buffer2_open,
output reg [17:0] buffer3_open, output reg [17:0] buffer4_open);

// take input bitwise then create the buffers inside the module again

//	output reg [17:0] buffer1_open;
//	output reg [17:0] buffer2_open;
//	output reg [17:0] buffer3_open;
//	output reg [17:0] buffer4_open;

	initial begin
		buffer1_open <= buffer1_o;
		buffer2_open <= buffer2_o;
		buffer3_open <= buffer3_o;
		buffer4_open <= buffer4_o;
	end

	reg [2:0] buffer1_r [5:0];
	reg [2:0] buffer2_r [5:0];
	reg [2:0] buffer3_r [5:0];
	reg [2:0] buffer4_r [5:0];
	reg mode;
	
	wire [2:0] L1, L2, L3, L4;
	wire [5:0] rea_sc;
	wire [5:0] lat_sc;
		
	always@ (*) begin
	
		for (i = 0; i < 6; i = i+1) begin
		
			buffer1_r[i] <= buffer1_o[3*i+2 -:3];
			buffer2_r[i] <= buffer2_o[3*i+2 -:3];
			buffer3_r[i] <= buffer3_o[3*i+2 -:3];
			buffer4_r[i] <= buffer4_o[3*i+2 -:3];
			
		end
	end
	// divide clock (50Hz) to get 3sec period
	
		
	integer i = 0, m;
// LSB of one 3-bit data is the validity bit 1-0
	count counter(.buffer1_o (buffer1_o), .buffer2_o (buffer2_o), .buffer3_o (buffer3_o), .buffer4_o (buffer4_o), .L1 (L1), .L2 (L2), .L3 (L3), .L4 (L4));
	score scorer(.L1 (L1), .L2 (L2), .L3 (L3), .L4 (L4), .RS (rea_sc), .LS (lat_sc));
	freqdivider freqdividerer(.clk (clk), .clk_out (clk_divided));
	
	always@ (posedge clk) begin
	
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
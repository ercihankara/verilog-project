`include "C:/Users/ercih/Desktop/project/take_in.v"
`include "C:/Users/ercih/Desktop/project/read.v"
`include "C:/Users/ercih/Desktop/project/VGA_SyncS.v"

module main(CLOCK_50, start, key0, key1, dataaa, drops, received_data, read, disp, buffer1_open, buffer2_o_open, buffer3_o_open, buffer4_o_open,
VGA_HS, VGA_VS, VGA_CLK, color);

	//output reg [7:0] led1;
	output VGA_HS, VGA_VS;
	output reg VGA_CLK=0;
	output wire [7:0] color;

	reg [7:0] color_i;

	wire ready;
	wire[9:0] position_x, position_y;

	reg[7:0] blank[0:899];

	reg[7:0] blue0[0:899];
	reg[7:0] blue1[0:899];
	reg[7:0] blue2[0:899];
	reg[7:0] blue3[0:899];

	reg[7:0] green0[0:899];
	reg[7:0] green1[0:899];
	reg[7:0] green2[0:899];
	reg[7:0] green3[0:899];

	reg[7:0] red0[0:899];
	reg[7:0] red1[0:899];
	reg[7:0] red2[0:899];
	reg[7:0] red3[0:899];

	reg[7:0] purple0[0:899];
	reg[7:0] purple1[0:899];
	reg[7:0] purple2[0:899];
	reg[7:0] purple3[0:899];

	parameter bPosX1 = 200;
	parameter bPosX2 = 260;
	parameter bPosX3 = 320;
	parameter bPosX4 = 380;

	parameter bPosY1 = 150;
	parameter bPosY2 = 190;
	parameter bPosY3 = 230;
	parameter bPosY4 = 270;
	parameter bPosY5 = 310;
	parameter bPosY6 = 350;

	parameter s = 30;

	input CLOCK_50;
	input start;
	input key0;
	input key1;
	
	output wire [3:0] dataaa;
	output wire drops;
	output wire received_data;
	output wire read;
	output wire [1:0] disp;
	
	wire [17:0] buffer1_o;
	wire [17:0] buffer2_o;
	wire [17:0] buffer3_o;
	wire [17:0] buffer4_o;
	
	output wire [17:0] buffer1_open;
	output wire [17:0] buffer2_o_open;
	output wire [17:0] buffer3_o_open;
	output wire [17:0] buffer4_o_open;
	
	initial begin
	
		$readmemh("blank.txt", blank);

		$readmemh("blue0.txt", blue0);
		$readmemh("blue1.txt", blue1);
		$readmemh("blue2.txt", blue2);
		$readmemh("blue3.txt", blue3);

		$readmemh("green0.txt", green0);
		$readmemh("green1.txt", green1);
		$readmemh("green2.txt", green2);
		$readmemh("green3.txt", green3);

		$readmemh("red0.txt", red0);
		$readmemh("red1.txt", red1);
		$readmemh("red2.txt", red2);
		$readmemh("red3.txt", red3);

		$readmemh("purple0.txt", purple0);
		$readmemh("purple1.txt", purple1);
		$readmemh("purple2.txt", purple2);
		$readmemh("purple3.txt", purple3);
		
	end
		
	always @(posedge CLOCK_50) begin 
		VGA_CLK = ~VGA_CLK;
	end

	VGA_SyncS SYNC(.vga_CLK(VGA_CLK), .VSync(VGA_VS), .HSync(VGA_HS), .vga_Ready(ready), .position_x(position_x), .position_y(position_y));
	
	take_in taker(.start (start), .clk (CLOCK_50), .key0 (key0), .key1 (key1), .buffer1_o (buffer1_o), .buffer2_o (buffer2_o), .buffer3_o (buffer3_o),
	.buffer4_o (buffer4_o), .dataaa (dataaa), .drops (drops), .received_data (received_data));
	
	always @(posedge VGA_CLK) begin
	
	// 1st Buffer -> Blue
	if(position_x>=bPosX1 && position_x<bPosX1+s) begin
		if	(position_y>=bPosY1 && position_y<bPosY1+s) begin
		   if(buffer1_o[15]) begin
				case(buffer1_o[17:16])
				2'b00: color_i <= blue0[{(position_x-bPosX1)*s+position_y-bPosY1}];
				2'b01: color_i <= blue1[{(position_x-bPosX1)*s+position_y-bPosY1}];
				2'b10: color_i <= blue2[{(position_x-bPosX1)*s+position_y-bPosY1}];
				2'b11: color_i <= blue3[{(position_x-bPosX1)*s+position_y-bPosY1}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX1)*s+position_y-bPosY1}];
		end
		
		else if	(position_y>=bPosY2 && position_y<bPosY2+s) begin
			if(buffer1_o[12]) begin
				case(buffer1_o[14:13])
				2'b00: color_i <= blue0[{(position_x-bPosX1)*s+position_y-bPosY2}];
				2'b01: color_i <= blue1[{(position_x-bPosX1)*s+position_y-bPosY2}];
				2'b10: color_i <= blue2[{(position_x-bPosX1)*s+position_y-bPosY2}];
				2'b11: color_i <= blue3[{(position_x-bPosX1)*s+position_y-bPosY2}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX1)*s+position_y-bPosY2}];
		end
		
		else if	(position_y>=bPosY3 && position_y<bPosY3+s) begin
			if(buffer1_o[9]) begin
				case(buffer1_o[11:10])
				2'b00: color_i <= blue0[{(position_x-bPosX1)*s+position_y-bPosY3}];
				2'b01: color_i <= blue1[{(position_x-bPosX1)*s+position_y-bPosY3}];
				2'b10: color_i <= blue2[{(position_x-bPosX1)*s+position_y-bPosY3}];
				2'b11: color_i <= blue3[{(position_x-bPosX1)*s+position_y-bPosY3}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX1)*s+position_y-bPosY3}];
		end
		
		else if	(position_y>=bPosY4 && position_y<bPosY4+s) begin
			if(buffer1_o[6]) begin
				case(buffer1_o[8:7])
				2'b00: color_i <= blue0[{(position_x-bPosX1)*s+position_y-bPosY4}];
				2'b01: color_i <= blue1[{(position_x-bPosX1)*s+position_y-bPosY4}];
				2'b10: color_i <= blue2[{(position_x-bPosX1)*s+position_y-bPosY4}];
				2'b11: color_i <= blue3[{(position_x-bPosX1)*s+position_y-bPosY4}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX1)*s+position_y-bPosY4}];
		end
		
		else if	(position_y>=bPosY5 && position_y<bPosY5+s) begin
			if(buffer1_o[3]) begin
				case(buffer1_o[5:4])
				2'b00: color_i <= blue0[{(position_x-bPosX1)*s+position_y-bPosY5}];
				2'b01: color_i <= blue1[{(position_x-bPosX1)*s+position_y-bPosY5}];
				2'b10: color_i <= blue2[{(position_x-bPosX1)*s+position_y-bPosY5}];
				2'b11: color_i <= blue3[{(position_x-bPosX1)*s+position_y-bPosY5}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX1)*s+position_y-bPosY5}];
		end
		
		else if	(position_y>=bPosY6 && position_y<bPosY6+s) begin
			if(buffer1_o[0]) begin
				case(buffer1_o[2:1])
				2'b00: color_i <= blue0[{(position_x-bPosX1)*s+position_y-bPosY6}];
				2'b01: color_i <= blue1[{(position_x-bPosX1)*s+position_y-bPosY6}];
				2'b10: color_i <= blue2[{(position_x-bPosX1)*s+position_y-bPosY6}];
				2'b11: color_i <= blue3[{(position_x-bPosX1)*s+position_y-bPosY6}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX1)*s+position_y-bPosY6}];
		end
		
		else color_i <= 8'h0; // black
	end
	
	// 2nd Buffer -> Green
	else if(position_x>=bPosX2 && position_x<bPosX2+s) begin
		if	(position_y>=bPosY1 && position_y<bPosY1+s) begin
		    if(buffer2_o[15]) begin
				case(buffer2_o[17:16])
				2'b00: color_i <= green0[{(position_x-bPosX2)*s+position_y-bPosY1}];
				2'b01: color_i <= green1[{(position_x-bPosX2)*s+position_y-bPosY1}];
				2'b10: color_i <= green2[{(position_x-bPosX2)*s+position_y-bPosY1}];
				2'b11: color_i <= green3[{(position_x-bPosX2)*s+position_y-bPosY1}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX2)*s+position_y-bPosY1}];
		end
		
		else if	(position_y>=bPosY2 && position_y<bPosY2+s) begin
			if(buffer2_o[12]) begin
				case(buffer2_o[14:13])
				2'b00: color_i <= green0[{(position_x-bPosX2)*s+position_y-bPosY2}];
				2'b01: color_i <= green1[{(position_x-bPosX2)*s+position_y-bPosY2}];
				2'b10: color_i <= green2[{(position_x-bPosX2)*s+position_y-bPosY2}];
				2'b11: color_i <= green3[{(position_x-bPosX2)*s+position_y-bPosY2}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX2)*s+position_y-bPosY2}];
		end
		
		else if	(position_y>=bPosY3 && position_y<bPosY3+s) begin
			if(buffer2_o[9]) begin
				case(buffer2_o[11:10])
				2'b00: color_i <= green0[{(position_x-bPosX2)*s+position_y-bPosY3}];
				2'b01: color_i <= green1[{(position_x-bPosX2)*s+position_y-bPosY3}];
				2'b10: color_i <= green2[{(position_x-bPosX2)*s+position_y-bPosY3}];
				2'b11: color_i <= green3[{(position_x-bPosX2)*s+position_y-bPosY3}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX2)*s+position_y-bPosY3}];
		end
		
		else if	(position_y>=bPosY4 && position_y<bPosY4+s) begin
			if(buffer2_o[6]) begin
				case(buffer2_o[8:7])
				2'b00: color_i <= green0[{(position_x-bPosX2)*s+position_y-bPosY4}];
				2'b01: color_i <= green1[{(position_x-bPosX2)*s+position_y-bPosY4}];
				2'b10: color_i <= green2[{(position_x-bPosX2)*s+position_y-bPosY4}];
				2'b11: color_i <= green3[{(position_x-bPosX2)*s+position_y-bPosY4}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX2)*s+position_y-bPosY4}];
		end
		
		else if	(position_y>=bPosY5 && position_y<bPosY5+s) begin
			if(buffer2_o[3]) begin
				case(buffer2_o[5:4])
				2'b00: color_i <= green0[{(position_x-bPosX2)*s+position_y-bPosY5}];
				2'b01: color_i <= green1[{(position_x-bPosX2)*s+position_y-bPosY5}];
				2'b10: color_i <= green2[{(position_x-bPosX2)*s+position_y-bPosY5}];
				2'b11: color_i <= green3[{(position_x-bPosX2)*s+position_y-bPosY5}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX2)*s+position_y-bPosY5}];
		end
		
		else if	(position_y>=bPosY6 && position_y<bPosY6+s) begin
			if(buffer2_o[0]) begin
				case(buffer2_o[2:1])
				2'b00: color_i <= green0[{(position_x-bPosX2)*s+position_y-bPosY6}];
				2'b01: color_i <= green1[{(position_x-bPosX2)*s+position_y-bPosY6}];
				2'b10: color_i <= green2[{(position_x-bPosX2)*s+position_y-bPosY6}];
				2'b11: color_i <= green3[{(position_x-bPosX2)*s+position_y-bPosY6}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX2)*s+position_y-bPosY6}];
		end
		
		else color_i <= 8'h0; // black
	end
	
	
	// 3rd Buffer -> Red
	else if(position_x>=bPosX3 && position_x<bPosX3+s) begin
		if	(position_y>=bPosY1 && position_y<bPosY1+s) begin
		   if(buffer3_o[15]) begin
				case(buffer3_o[17:16])
				2'b00: color_i <= red0[{(position_x-bPosX3)*s+position_y-bPosY1}];
				2'b01: color_i <= red1[{(position_x-bPosX3)*s+position_y-bPosY1}];
				2'b10: color_i <= red2[{(position_x-bPosX3)*s+position_y-bPosY1}];
				2'b11: color_i <= red3[{(position_x-bPosX3)*s+position_y-bPosY1}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX3)*s+position_y-bPosY1}];
		end
		
		else if	(position_y>=bPosY2 && position_y<bPosY2+s) begin
			if(buffer3_o[12]) begin
				case(buffer3_o[14:13])
				2'b00: color_i <= red0[{(position_x-bPosX3)*s+position_y-bPosY2}];
				2'b01: color_i <= red1[{(position_x-bPosX3)*s+position_y-bPosY2}];
				2'b10: color_i <= red2[{(position_x-bPosX3)*s+position_y-bPosY2}];
				2'b11: color_i <= red3[{(position_x-bPosX3)*s+position_y-bPosY2}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX3)*s+position_y-bPosY2}];
		end
		
		else if	(position_y>=bPosY3 && position_y<bPosY3+s) begin
			if(buffer3_o[9]) begin
				case(buffer3_o[11:10])
				2'b00: color_i <= red0[{(position_x-bPosX3)*s+position_y-bPosY3}];
				2'b01: color_i <= red1[{(position_x-bPosX3)*s+position_y-bPosY3}];
				2'b10: color_i <= red2[{(position_x-bPosX3)*s+position_y-bPosY3}];
				2'b11: color_i <= red3[{(position_x-bPosX3)*s+position_y-bPosY3}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX3)*s+position_y-bPosY3}];
		end
		
		else if	(position_y>=bPosY4 && position_y<bPosY4+s) begin
			if(buffer3_o[6]) begin
				case(buffer3_o[8:7])
				2'b00: color_i <= red0[{(position_x-bPosX3)*s+position_y-bPosY4}];
				2'b01: color_i <= red1[{(position_x-bPosX3)*s+position_y-bPosY4}];
				2'b10: color_i <= red2[{(position_x-bPosX3)*s+position_y-bPosY4}];
				2'b11: color_i <= red3[{(position_x-bPosX3)*s+position_y-bPosY4}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX3)*s+position_y-bPosY4}];
		end
		
		else if	(position_y>=bPosY5 && position_y<bPosY5+s) begin
			if(buffer3_o[3]) begin
				case(buffer3_o[5:4])
				2'b00: color_i <= red0[{(position_x-bPosX3)*s+position_y-bPosY5}];
				2'b01: color_i <= red1[{(position_x-bPosX3)*s+position_y-bPosY5}];
				2'b10: color_i <= red2[{(position_x-bPosX3)*s+position_y-bPosY5}];
				2'b11: color_i <= red3[{(position_x-bPosX3)*s+position_y-bPosY5}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX3)*s+position_y-bPosY5}];
		end
		
		else if	(position_y>=bPosY6 && position_y<bPosY6+s) begin
			if(buffer3_o[0]) begin
				case(buffer3_o[2:1])
				2'b00: color_i <= red0[{(position_x-bPosX3)*s+position_y-bPosY6}];
				2'b01: color_i <= red1[{(position_x-bPosX3)*s+position_y-bPosY6}];
				2'b10: color_i <= red2[{(position_x-bPosX3)*s+position_y-bPosY6}];
				2'b11: color_i <= red3[{(position_x-bPosX3)*s+position_y-bPosY6}];
				endcase
			end
			
			else color_i <= blank[{(position_x-bPosX3)*s+position_y-bPosY6}];
		end
		
		else color_i <= 8'h0; // black
	end
	
	// 4th Buffer -> Purple
	else if(position_x>=bPosX4 && position_x<bPosX4+s) begin
		if	(position_y>=bPosY1 && position_y<bPosY1+s) begin
		  if(buffer4_o[15]) begin
				case({buffer4_o[16],buffer4_o[17]})
				2'b00: color_i <= purple0[{(position_x-bPosX4)*s+position_y-bPosY1}];
				2'b01: color_i <= purple1[{(position_x-bPosX4)*s+position_y-bPosY1}];
				2'b10: color_i <= purple2[{(position_x-bPosX4)*s+position_y-bPosY1}];
				2'b11: color_i <= purple3[{(position_x-bPosX4)*s+position_y-bPosY1}];
				endcase
			end
			else color_i <= blank[{(position_x-bPosX4)*s+position_y-bPosY1}];
		end
		
		else if	(position_y>=bPosY2 && position_y<bPosY2+s) begin
			if(buffer4_o[12]) begin
				case({buffer4_o[13],buffer4_o[14]})
				2'b00: color_i <= purple0[{(position_x-bPosX4)*s+position_y-bPosY2}];
				2'b01: color_i <= purple1[{(position_x-bPosX4)*s+position_y-bPosY2}];
				2'b10: color_i <= purple2[{(position_x-bPosX4)*s+position_y-bPosY2}];
				2'b11: color_i <= purple3[{(position_x-bPosX4)*s+position_y-bPosY2}];
				endcase
			end
			else color_i <= blank[{(position_x-bPosX4)*s+position_y-bPosY2}];
		end
		
		else if	(position_y>=bPosY3 && position_y<bPosY3+s) begin
			if(buffer4_o[9]) begin
				case({buffer4_o[10],buffer4_o[11]})
				2'b00: color_i <= purple0[{(position_x-bPosX4)*s+position_y-bPosY3}];
				2'b01: color_i <= purple1[{(position_x-bPosX4)*s+position_y-bPosY3}];
				2'b10: color_i <= purple2[{(position_x-bPosX4)*s+position_y-bPosY3}];
				2'b11: color_i <= purple3[{(position_x-bPosX4)*s+position_y-bPosY3}];
				endcase
			end
			else color_i <= blank[{(position_x-bPosX4)*s+position_y-bPosY3}];
		end
		
		else if	(position_y>=bPosY4 && position_y<bPosY4+s) begin
			if(buffer4_o[6]) begin
			case({buffer4_o[7],buffer4_o[8]})
				2'b00: color_i <= purple0[{(position_x-bPosX4)*s+position_y-bPosY4}];
				2'b01: color_i <= purple1[{(position_x-bPosX4)*s+position_y-bPosY4}];
				2'b10: color_i <= purple2[{(position_x-bPosX4)*s+position_y-bPosY4}];
				2'b11: color_i <= purple3[{(position_x-bPosX4)*s+position_y-bPosY4}];
				endcase
				end
			else color_i <= blank[{(position_x-bPosX4)*s+position_y-bPosY4}];
		end
		
		else if	(position_y>=bPosY5 && position_y<bPosY5+s) begin
			if(buffer4_o[3]) begin
				case({buffer4_o[4],buffer4_o[5]})
				2'b00: color_i <= purple0[{(position_x-bPosX4)*s+position_y-bPosY5}];
				2'b01: color_i <= purple1[{(position_x-bPosX4)*s+position_y-bPosY5}];
				2'b10: color_i <= purple2[{(position_x-bPosX4)*s+position_y-bPosY5}];
				2'b11: color_i <= purple3[{(position_x-bPosX4)*s+position_y-bPosY5}];
				endcase
			end
			else color_i <= blank[{(position_x-bPosX4)*s+position_y-bPosY5}];
		end
		
		else if	(position_y>=bPosY6 && position_y<bPosY6+s) begin
			if(buffer4_o[0]) begin
				case({buffer4_o[1],buffer4_o[2]})
				2'b00: color_i <= purple0[{(position_x-bPosX4)*s+position_y-bPosY6}];
				2'b01: color_i <= purple1[{(position_x-bPosX4)*s+position_y-bPosY6}];
				2'b10: color_i <= purple2[{(position_x-bPosX4)*s+position_y-bPosY6}];
				2'b11: color_i <= purple3[{(position_x-bPosX4)*s+position_y-bPosY6}];
				endcase
			end
			else color_i <= blank[{(position_x-bPosX4)*s+position_y-bPosY6}];
		end
		
		else color_i <= 8'h0; // black
	end

	end
	
	assign color = ready ? color_i : 8'h0;
	
	read reader(.clk (CLOCK_50), .buffer1_o (buffer1_o), .buffer2_o_o (buffer2_o_o), .buffer3_o_o (buffer3_o_o), .buffer4_o_o (buffer4_o_o),
	.buffer1_open (buffer1_open), .buffer2_o_open (buffer2_o_open), .buffer3_o_open (buffer3_o_open), .buffer4_o_open (buffer4_o_open), .read (read), .disp (disp));

endmodule
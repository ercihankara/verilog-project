module VGA_SyncS(vga_CLK, VSync, HSync, vga_Ready, position_x, position_y);

	input vga_CLK;
	output reg [9:0] position_x, position_y;
	output wire vga_Ready, HSync, VSync;

	parameter H_sync = 96;
	parameter H_back = 48;
	parameter H_front = 16;
	parameter one_line = 799;
	parameter V_sync = 2;
	parameter V_back = 32;
	parameter V_front = 11;
	parameter one_frame = 524; 

	wire vga_ReadyH, vga_ReadyV;

	initial begin
		position_x = 10'd0;
		position_y = 10'd0;
	end

	always @(posedge vga_CLK) begin
		if(position_x == one_line) begin 
			position_x <= 0;
			if(position_y == one_frame) position_y <= 0;
			else position_y <= position_y + 1;
			end
		else position_x <= position_x + 1;
	end

	assign HSync = (position_x < H_sync);
	assign VSync = (position_y < V_sync);
	assign vga_ReadyH = (position_x >= (H_sync+H_back) && position_x <= (one_line-H_front));
	assign vga_ReadyV = (position_y >= (V_sync+V_back) && position_y <= (one_frame-V_front));
	assign vga_Ready = (vga_ReadyH && vga_ReadyV);

endmodule
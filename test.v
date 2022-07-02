`include "C:/Users/ercih/Desktop/project/serial_to_parallel.v"

module test
# (parameter WIDTH = 4)
(input start, input key1, input key2, output reg [3:0] data);

	 input sEEG;
	 input clk;
	 reg [WIDTH-1:0] temp;
	 reg [WIDTH-1:0] temp_reg; //..synchronizer

	integer holder;

	always@ (posedge start) begin
	
		holder <= 1;
		
	end
	
	always@ (*) begin
	
		
		if (holder == 1) begin
				
				
			always@(posedge key1) begin
				  temp[WIDTH-2:0] <= temp[WIDTH-1:1];
				  temp[WIDTH-1]   <= 1;
				  temp_reg <= temp;
				  data   <= temp_reg;
				  
			end
			
			always@(posedge key2) begin
				  temp[WIDTH-2:0] <= temp[WIDTH-1:1];
				  temp[WIDTH-1]   <= 0;
				  temp_reg <= temp;
				  data   <= temp_reg;
				  
			end
				//serial_to_parallel ser1(.sEEG (1), .clk (key1), .eegOut (data));
				//serial_to_parallel ser2(.sEEG (0), .clk (key2), .eegOut (data));
			
		end
			holder <= 0;
	end
	
endmodule

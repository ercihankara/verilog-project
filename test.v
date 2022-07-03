`include "C:/Users/ercih/Desktop/project/serial_to_parallel.v"

module test
#(parameter WIDTH = 4)
(input start, input key1, input key2, output reg [3:0] data);

	integer holder, h = 0;

	always@ (posedge start) begin
	
		holder <= 1;
		h <= 0;
	end

	always@ (posedge key1) begin
	
		data[3 - h] <= 1'b1;
		h <= h + 1;
		holder <= 0;
	end

	always@ (posedge key2) begin
	
		data[3 - h] <= 1'b0;
		h <= h + 1;
		holder <= 0;
	end

endmodule
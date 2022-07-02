module freqdivider(input clk, output reg clk_out);
	
	reg[23:0] counter;
	
	
	always@(posedge clk) begin
	
		if(counter==24'd75000000) begin
			counter <= 16'd0;
			clk_out <= ~clk_out;
		end
		
		else begin
			counter <= counter +1;
		end
	
	end
	
	

endmodule
module clock (output reg clk);
parameter clk_period = 6;


initial begin 
	clk=0;
end

always #(clk_period/2) clk=~clk;
endmodule

module serial_to_parallel
# (parameter WIDTH = 4)
(sEEG, clk, eegOut);

    input sEEG;
    input clk;
    reg [WIDTH-1:0] temp;
    reg [WIDTH-1:0] temp_reg; //..synchronizer
    output reg [WIDTH-1:0] eegOut;
    
//    always @(negedge nclk) begin
//        temp[WIDTH-2:0] <= temp[WIDTH-1:1];
//        temp[WIDTH-1]   <= sEEG;
//    end

    always@ (posedge clk) begin
	 
		temp[WIDTH-2:0] <= temp[WIDTH-1:1];
		temp[WIDTH-1]   <= sEEG;
		temp_reg <= temp;
		eegOut <= temp_reg;
    end
endmodule
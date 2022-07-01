module take_in (input clk);

// start button is clk signal, when 1 take input

	reg [5:0] buffer1[2:0];
	reg [5:0] buffer2[2:0];
	reg [5:0] buffer3[2:0];
	reg [5:0] buffer4[2:0];
	
// third bit for validity, if 1 read; if 0 pass

	input [3:0] data;
	integer  i1 = 0, i2 = 0, i3 = 0, i4 = 0;
// BOB1B2B3
// input is stored from left I guess
	
	always@ (posedge clk) begin
	
		case(data[3:2])
		
			2'b00 : begin
				
						buffer1[i1][] <= {data[1:0], 1'b1};
						if (i1 != 5)
							i1 = i1 + 1;
						else
							i1 = 0;

					  end
					  
			2'b01 : begin
				
						buffer2[i2][] <= {data[1:0], 1'b1};
						if (i2 != 5)
							i2 = i2 + 1;
						else
							i2 = 0;

					  end
			
			2'b10 : begin
				
						buffer3[i3][] <= {data[1:0], 1'b1};
						if (i3 != 5)
							i3 = i3 + 1;
						else
							i3 = 0;

					  end
					  
			2'b11 : begin
				
						buffer4[i4][] <= {data[1:0], 1'b1};
						if (i4 != 5)
							i4 = i4 + 1;
						else
							i4 = 0;

					  end
		
		endcase
	
	end

endmodule
// modules: take input, read data, shift and arrange registers
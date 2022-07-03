module son(clk,start,bin0,bin1,registeredbin);

input clk;
input start;
input bin0;
input bin1;


reg [3:0] dummy;

reg a ;
initial a = 0 ;

reg cnt;
initial cnt = 0;

reg [1:0] isitstart;
initial isitstart = 0;

reg [1:0] fourcyc;
initial fourcyc = 0 ;

output reg [3:0] registeredbin;


always @ (posedge clk) begin

	if (start == 0 && isitstart <3) begin
	isitstart <= isitstart +1 ;
	end
	
	if (isitstart == 3) begin
	
		case ({bin1,bin0,cnt}) 
		
		3'b111 : begin
		cnt <= 0 ;
		end
		
		3'b100 : begin
		dummy[fourcyc] = 0 ;
		cnt <= 1 ;
		fourcyc <= fourcyc +1;
		if(fourcyc == 3) begin
			registeredbin[3] = dummy[0];
			registeredbin[2] = dummy[1];
			registeredbin[1] = dummy[2];
			registeredbin[0] = dummy[3];
			isitstart <= 0 ;
		end
		end
		
		3'b010 :  begin
		dummy[fourcyc] = 1 ;
		cnt <= 1 ;
		fourcyc <= fourcyc +1;
		if(fourcyc == 3) begin
			registeredbin[3] = dummy[0];
			registeredbin[2] = dummy[1];
			registeredbin[1] = dummy[2];
			registeredbin[0] = dummy[3];	
			isitstart <= 0;
		end
		end
		default : a <= 1;
		endcase		
		
end
end
endmodule
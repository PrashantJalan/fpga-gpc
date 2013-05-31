/* This is a 64x8 bit memory module. Read operations take 2 cycles and write takes 3 cycle */

/* Address denotes the address of the register in the memory module hich can have 5 bits at most.
Mode 0 is for read and the read value will be output in out. Mode 1 indicates that the given data
will be written in the specific address. 
*/

module prgm_mem (adrs, erase, mode, data, out, clk);

input [5:0]adrs;
input erase;
input mode, clk;
input [7:0]data;
output reg [7:0]out;

reg [31:0]w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16;
reg [31:0]temp;

wire [3:0]sel1;
wire [1:0]sel2;
assign sel1[3:0]=adrs[5:2];
assign sel2[1:0]=adrs[1:0];


initial begin
/*Insert the program here*/
w1 <= 983576;
end

always @(posedge clk)
begin
	if (erase==1)	begin
		w1 <= 0;
		w2 <= 0;
		w3 <= 0;
		w4 <= 0;
		w5 <= 0;
		w6 <= 0;
		w7 <= 0;
		w8 <= 0;
		w9 <= 0;
		w10 <= 0;
		w11 <= 0;
		w12 <= 0;
		w13 <= 0;
		w14 <= 0;
		w15 <= 0;
		w16 <= 0;		
	end
	else	begin
		case (mode)
			0: begin	
				case (sel1)			// 8x1 MUX
					0: begin
						temp<=w1;
					   end	
					1: begin
						temp<=w2;
					   end
					2: begin
						temp<=w3;
					   end
					3: begin
						temp<=w4;
					   end
					4: begin
						temp<=w5;
					   end
					5: begin
						temp<=w6;
					   end
					6: begin
						temp<=w7;
					   end
					7: begin
						temp<=w8;
					   end
					8: begin
						temp<=w9;
					   end
					9: begin
						temp<=w10;
					   end
					10: begin
						temp<=w11;
					   end
					11: begin
						temp<=w12;
					   end
					12: begin
						temp<=w13;
					   end
					13: begin
						temp<=w14;
					   end
					14: begin
						temp<=w15;
					   end
					15: begin
						temp<=w16;
					   end
				endcase
				case (sel2)
					0:begin
						out <= temp[7:0];	
					   end
					1:begin
						out <= temp[15:8];	
					   end
					2:begin
						out <= temp[23:16];	
					   end
					3:begin
						out <= temp[31:24];	
					   end			
				endcase
			
			   end
			1: begin	
				case (sel1)			// 8x1 MUX
					0: begin
						temp<=w1;
					   end	
					1: begin
						temp<=w2;
					   end
					2: begin
						temp<=w3;
					   end
					3: begin
						temp<=w4;
					   end
					4: begin
						temp<=w5;
					   end
					5: begin
						temp<=w6;
					   end
					6: begin
						temp<=w7;
					   end
					7: begin
						temp<=w8;
					   end
					8: begin
						temp<=w9;
					   end
					9: begin
						temp<=w10;
					   end
					10: begin
						temp<=w11;
					   end
					11: begin
						temp<=w12;
					   end
					12: begin
						temp<=w13;
					   end
					13: begin
						temp<=w14;
					   end
					14: begin
						temp<=w15;
					   end
					15: begin
						temp<=w16;
					   end
				endcase
				case (sel2)
					0:begin
						temp[7:0] <= data;
					  end	
					1:begin
						temp[15:8] <= data;
					  end
					2:begin
						temp[23:16] <= data;
					  end
					3:begin
						temp[31:24] <= data;
					  end					
				endcase
				case (sel1)			
					0: begin
						w1<=temp;
					   end	
					1: begin
						w2<=temp;
					   end
					2: begin
						w3<=temp;
					   end
					3: begin
						w4<=temp;
					   end
					4: begin
						w5<=temp;
					   end
					5: begin
						w6<=temp;
					   end
					6: begin
						w7<=temp;
					   end
					7: begin
						w8<=temp;
					   end
					8: begin
						w9<=temp;
					   end
					9: begin
						w10<=temp;
					   end
					10: begin
						w11<=temp;
					   end
					11: begin
						w12<=temp;
					   end
					12: begin
						w13<=temp;
					   end
					13: begin
						w14<=temp;
					   end
					14: begin
						w15<=temp;
					   end
					15: begin
						w16<=temp;
					   end
				endcase	 
			     end	
		endcase
	end
end
endmodule	

module display (input [7:0] inp,
		input clk,
		input busy, pc_disp,
		output reg [6:0] led,
		output reg [7:0] s_led,
		output reg d1, d2, d3, d4);

reg clk2;
reg [15:0] counter;					//To help synthesis clk2
reg [3:0] count, i, j, k, digit2, digit3, digit4;	//To help display in seven segment
reg [7:0] c1, c2;

always @(posedge clk)					//Frequency divider
begin
	if (counter>16'd1024)	begin
		counter <= 0;
		clk2 <= ~clk2;
	end
	else	begin
		counter <= counter+1;
	end
end


always @(posedge clk2)					//Displaying in the seven segment
	begin

		i = digit2;
		j = digit3;
		k = digit4;
		c1 = inp;
		if(!(c1==c2)) begin
			c2 = c1;
			i = 0; j = 0; k = 0;
			digit2 = 0; digit4 = 0; digit3 = 0;
		end

		if (!((inp - i*100) < 100)) begin
			digit2 = digit2 + 1;
		end
		if(!((inp - i*100- 10*j) < 10)) begin
			digit3 = digit3 + 1;
		end
			digit4 = inp - 100*i - 10*j;
		

		if (busy==1)	begin
			s_led <= 8'b11111111;
		end
		else	begin
			s_led <= 8'b00000000;
		end

		if (pc_disp==1)		begin
			if (count==0)	begin				//Displays P
				led <= 7'b0001100;
				d1 <= 0; d2 <= 1; d3 <= 1; d4 <= 1;
			end
			else if (count==1)   begin			//Displays C
				led <= 7'b1000110;
				d1 <= 1; d2 <= 0; d3 <= 1; d4 <= 1;
			end
			else if (count==2)   begin
				case (digit3)
					4'd0 : led <= 7'b1000000;
					4'd1 : led <= 7'b1111001;
					4'd2 : led <= 7'b0100100;
					4'd3 : led <= 7'b0110000;
					4'd4 : led <= 7'b0011001;
					4'd5 : led <= 7'b0010010;
					4'd6 : led <= 7'b0000010;
					4'd7 : led <= 7'b1011000;
					4'd8 : led <= 7'b0000000;
					4'd9 : led <= 7'b0010000;
				endcase
		 		d1 <= 1; d2 <= 1; d3 <= 0; d4 <= 1;
		 	end
			else if (count==3)   begin
				case (digit4)
					4'd0 : led <= 7'b1000000;
					4'd1 : led <= 7'b1111001;
					4'd2 : led <= 7'b0100100;
					4'd3 : led <= 7'b0110000;
					4'd4 : led <= 7'b0011001;
					4'd5 : led <= 7'b0010010;
					4'd6 : led <= 7'b0000010;
					4'd7 : led <= 7'b1011000;
					4'd8 : led <= 7'b0000000;
					4'd9 : led <= 7'b0010000;
				endcase
		 		d1 <= 1; d2 <= 1; d3 <= 1; d4 <= 0;
		 	end
		end
		else	begin
			if (count==0)	begin
				d1 <= 1; d2 <= 1; d3 <= 1; d4 <= 1;
			end
			else if (count==1)   begin
				case (digit2)
					4'd0 : led <= 7'b1000000;
					4'd1 : led <= 7'b1111001;
					4'd2 : led <= 7'b0100100;
					4'd3 : led <= 7'b0110000;
					4'd4 : led <= 7'b0011001;
					4'd5 : led <= 7'b0010010;
					4'd6 : led <= 7'b0000010;
					4'd7 : led <= 7'b1011000;
					4'd8 : led <= 7'b0000000;
					4'd9 : led <= 7'b0010000;
				endcase
				d1 <= 1; d2 <= 0; d3 <= 1; d4 <= 1;
			end
			else if (count==2)   begin
				case (digit3)
					4'd0 : led <= 7'b1000000;
					4'd1 : led <= 7'b1111001;
					4'd2 : led <= 7'b0100100;
					4'd3 : led <= 7'b0110000;
					4'd4 : led <= 7'b0011001;
					4'd5 : led <= 7'b0010010;
					4'd6 : led <= 7'b0000010;
					4'd7 : led <= 7'b1011000;
					4'd8 : led <= 7'b0000000;
					4'd9 : led <= 7'b0010000;
				endcase
		 		d1 <= 1; d2 <= 1; d3 <= 0; d4 <= 1;
		 	end
			else if (count==3)   begin
				case (digit4)
					4'd0 : led <= 7'b1000000;
					4'd1 : led <= 7'b1111001;
					4'd2 : led <= 7'b0100100;
					4'd3 : led <= 7'b0110000;
					4'd4 : led <= 7'b0011001;
					4'd5 : led <= 7'b0010010;
					4'd6 : led <= 7'b0000010;
					4'd7 : led <= 7'b1011000;
					4'd8 : led <= 7'b0000000;
					4'd9 : led <= 7'b0010000;
				endcase
		 		d1 <= 1; d2 <= 1; d3 <= 1; d4 <= 0;
		 	end
		end
	count = (count+1)%4;

end
endmodule


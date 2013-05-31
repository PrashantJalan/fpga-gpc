module booth (	input clk,
		input ready,
		input [3:0]inp1,
		input [3:0]inp2,
		output wire [7:0]output0,
		output reg [3:0]count);

reg new;
wire [7:0] temp, temp2;
wire [7:0] add_out, add_out2;

reg [11:0] out;
reg old;
wire ground;
wire live;

assign output0 = out;
assign ground = 0;
assign live = 1;
assign temp2[7:0] = out[11:4];
assign temp[3:0] = inp1;
assign temp[4] = 0;
assign temp[5] = 0;
assign temp[6] = 0;
assign temp[7] = 0;


//To optimise later, we should use only one adder
add_sub a1(.clk (clk), .oper(ground), .a(temp), .b(temp2), .out(add_out));
add_sub a2(.clk (clk), .oper(live), .a(temp2), .b(temp), .out(add_out2));


always @(posedge clk)
begin
	if (ready==1)
	begin
		old = 0;
		out = inp2;
		count = 0;
	end
	else
	begin
		new = out[0];

		count = count+1;			//May help to keep blocking

		if (new==0 && old==0)
		begin
			old = new;
		end
		else if (new==0 && old==1)
		begin
			out[11:4] = add_out[7:0];
			old = new;
		end
		else if (new==1 && old==0)
		begin
			out[11:4] = add_out2[7:0];
			old = new;
		end
		else
		begin
			old = new;
		end

		out = out>>1;
	end
end

endmodule

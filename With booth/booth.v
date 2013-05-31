module booth (	input clk,
		input ready,
		input [7:0]inp1,
		input [7:0]inp2,
		output wire [7:0]output0,
		output wire [7:0]output1);

reg [16:0] tmp;
wire ground;
wire live;
wire [7:0] add_out, add_out2;

assign output0 = tmp[16:9];
assign output1 = tmp[8:1];
assign ground = 0;
assign live = 1;


add_sub a1(.clk (clk), .oper(ground), .a(output0), .b(inp2), .out(add_out));
add_sub a2(.clk (clk), .oper(live), .a(output0), .b(inp2), .out(add_out2));


always @(posedge clk)
begin
	if (ready==1)
	begin
		tmp[16:9] = 0;
		tmp[8:1] = inp1;
		tmp[0] = 0;
	end
	else
	begin
		if (tmp[0]==0 && tmp[1]==1)	begin
			tmp[16:9] = add_out2;
		end
		else if (tmp[0]==1 && tmp[1]==0)	begin
			tmp[16:9] = add_out;
		end

		tmp = tmp/2;
	end
end

endmodule

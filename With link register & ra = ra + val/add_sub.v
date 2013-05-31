module add_sub (input clk,
		input oper,
		input [7:0] a,
		input [7:0] b,
		output wire [7:0] out);

wire [3:0]a1, a2, b1, b2;
wire [3:0]out1, out2;
wire cout1, cout2;

CLA c1(a1, b1, oper, out1, cout1);
CLA c2(a2, b2, cout1, out2, cout2);

assign out[0] = out1[0];
assign out[1] = out1[1];
assign out[2] = out1[2];
assign out[3] = out1[3];
assign out[4] = out2[0];
assign out[5] = out2[1];
assign out[6] = out2[2];
assign out[7] = out2[3];
assign a1[0] = a[0];
assign a1[1] = a[1];
assign a1[2] = a[2];
assign a1[3] = a[3];
assign a2[0] = a[4];
assign a2[1] = a[5];
assign a2[2] = a[6]; 
assign a2[3] = a[7];
xor x1(b1[0], b[0], oper);
xor x2(b1[1], b[1], oper);
xor x3(b1[2], b[2], oper);
xor x4(b1[3], b[3], oper);
xor x5(b2[0], b[4], oper);
xor x6(b2[1], b[5], oper);
xor x7(b2[2], b[6], oper);
xor x8(b2[3], b[7], oper);

endmodule

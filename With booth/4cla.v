module CLA(a,b,cin,sum,cout);
input [3:0]a,b;
input cin;
output [3:0]sum;
output cout;
wire [3:0]c;
wire [3:0]p,g;

xor x1(p[0],a[0],b[0]);
xor x2(p[1],a[1],b[1]);
xor x3(p[2],a[2],b[2]);
xor x4(p[3],a[3],b[3]);
and  a1(g[0],a[0],b[0]);
and a2(g[1],a[1],b[1]);
and  a3(g[2],a[2],b[2]);
and  a4(g[3],a[3],b[3]);

assign c[0]=((p[0] & cin) + g[0]);
assign c[1]=((p[0] & p[1] & cin) | (p[1] & g[0]) | g[1]);
assign c[2]=((p[0]  &  p[1] & cin & p[2]) | (p[1] & g[0] & p[2]) | (g[1] & p[2]) | g[2]);
assign c[3]=((p[0] & p[1] & cin & p[2] & p[3]) | (p[1] & g[0] & p[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[2] & p[3]) | g[3]);
assign cout=c[3];

FA f1(a[0],b[0],cin,sum[0]);
FA f2(a[1],b[1],c[0],sum[1]);
FA f3(a[2],b[2],c[1],sum[2]);
FA f4(a[3],b[3],c[2],sum[3]);

endmodule

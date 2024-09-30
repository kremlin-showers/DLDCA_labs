module CLA_4bit(a, b, cin, sum, cout);
input [3:0] a;
input [3:0] b;
input cin;
wire [3:0] a;
wire [3:0] b;
wire cin;

output [3:0] sum;
output cout;
wire [3:0] sum;
wire cout;

// Internal variables
wire P0, P1, P2, P3;
wire G0, G1, G2, G3;
wire C1, C2, C3, C4;

assign P0 = a[0] ^ b[0];
assign P1 = a[1] ^ b[1];
assign P2 = a[2] ^ b[2];
assign P3 = a[3] ^ b[3];

assign G0 = a[0] & b[0];
assign G1 = a[1] & b[1];
assign G2 = a[2] & b[2];
assign G3 = a[3] & b[3];

assign C1 = G0 | (P0 & cin);
assign C2 = G1 | (P1 & G0) | (P1 & P0 & cin);
assign C3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & cin);
assign C4 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & cin);

assign sum[0] = P0 ^ cin;
assign sum[1] = P1 ^ C1;
assign sum[2] = P2 ^ C2;
assign sum[3] = P3 ^ C3;
assign cout = C4;



endmodule


module CLA_4bit_P_G(a, b, cin, sum, P, G);
input [3:0] a;
input [3:0] b;
input cin;
wire [3:0] a;
wire [3:0] b;
wire cin;

output [3:0] sum;
output P, G;
wire [3:0] sum;
wire P, G;
// Internal variables
wire P0, P1, P2, P3;
wire G0, G1, G2, G3;
wire C1, C2, C3;

assign P0 = a[0] ^ b[0];
assign P1 = a[1] ^ b[1];
assign P2 = a[2] ^ b[2];
assign P3 = a[3] ^ b[3];

assign G0 = a[0] & b[0];
assign G1 = a[1] & b[1];
assign G2 = a[2] & b[2];
assign G3 = a[3] & b[3];

assign C1 = G0 | (P0 & cin);
assign C2 = G1 | (P1 & G0) | (P1 & P0 & cin);
assign C3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & cin);
assign G = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & cin);
assign P = P0 & P1 & P2 & P3;

assign sum[0] = P0 ^ cin;
assign sum[1] = P1 ^ C1;
assign sum[2] = P2 ^ C2;
assign sum[3] = P3 ^ C3;

endmodule


module lookahead_carry_unit_16_bit(P0, G0, P1, G1, P2, G2, P3, G3, cin, C4, C8, C12, C16, GF, PF);
input P0, G0, P1, G1, P2, G2, P3, G3, cin;
wire P0, G0, P1, G1, P2, G2, P3, G3, cin;
output C4, C8, C12, C16, GF, PF;
wire C4, C8, C12, C16, GF, PF;

assign PF = P0 & P1 & P2 & P3;

assign C4 = G0 | (P0 & cin);
assign C8 = G1 | (P1 & G0) | (P1 & P0 & cin);
assign C12 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & cin);
assign C16 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & cin);
assign GF = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0);
endmodule


module CLA_16bit(a, b, cin, sum, cout, Pout, Gout);
input [15:0] a;
input [15:0] b;
input cin;
wire [15:0] a;
wire [15:0] b;
wire cin;
output [15:0] sum;
output cout, Pout, Gout;
wire [15:0] sum;
wire cout, Pout, Gout;

// Internal Variables
wire C4, C8, C12, C16;
wire P0, G0, P1, G1, P2, G2, P3, G3;


CLA_4bit_P_G a0(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .P(P0), .G(G0));
CLA_4bit_P_G a1(.a(a[7:4]), .b(b[7:4]), .cin(C4), .sum(sum[7:4]), .P(P1), .G(G1));
CLA_4bit_P_G a2(.a(a[11:8]), .b(b[11:8]), .cin(C8), .sum(sum[11:8]), .P(P2), .G(G2));
CLA_4bit_P_G a3(.a(a[15:12]), .b(b[15:12]), .cin(C12), .sum(sum[15:12]), .P(P3), .G(G3));

lookahead_carry_unit_16_bit unit(.P0(P0), .G0(G0), .P1(P1), .G1(G1), .P2(P2), .G2(G2), .P3(P3), .G3(G3), .cin(cin), .C4(C4), .C8(C8), .C12(C12), .C16(C16), .GF(Gout), .PF(Pout));
assign cout = C16;

endmodule


module CLA_32bit(a, b, cin, sum, cout, Pout, Gout);
input [31:0] a;
input [31:0] b;
input cin;
wire [31:0] a;
wire [31:0] b;
wire cin;
output [31:0] sum;
output cout, Pout, Gout;
wire [31:0] sum;
wire cout, Pout, Gout;

// Internal Variables
wire tC16, tC32;
wire C16, C32;
wire P0, G0;
wire P1, G1;


CLA_16bit a0(.a(a[15:0]), .b(b[15:0]), .cin(cin), .sum(sum[15:0]), .cout(tC16), .Pout(P0), .Gout(G0));
CLA_16bit a1(.a(a[31:16]), .b(b[31:16]), .cin(C16), .sum(sum[31:16]), .cout(tC32), .Pout(P1), .Gout(G1));
lookahead_carry_unit_32_bit unit(.P0(P0), .G0(G0), .P1(P1), .G1(G1), .cin(cin), .C16(C16), .C32(C32), .GF(Gout), .PF(Pout));
assign cout = C32;

endmodule

module lookahead_carry_unit_32_bit (P0, G0, P1, G1, cin, C16, C32, GF, PF);
input P0, G0, P1, G1, cin;
wire P0, G0, P1, G1, cin;
output C16, C32, GF, PF;
wire C16, C32, GF, PF;

assign PF = P0 & P1;
assign C16 = G0 | (P0 & cin);
assign C32 = G1 | (P1 & G0) | (P1 & P0 & cin);
assign GF = G1 | (P1 & G0);

endmodule

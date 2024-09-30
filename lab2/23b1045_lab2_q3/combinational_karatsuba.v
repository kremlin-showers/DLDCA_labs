// module karatsuba_16 (X, Y, Z);
// endmodule



module karatsuba_2(X, Y, Z);
input [1:0] X;
input [1:0] Y;
output [3:0] Z;
wire [1:0] X;
wire [1:0] Y;
wire [3:0] Z;


assign Z[0] = X[0] & Y[0];
assign Z[1] = (X[0] & Y[1]) ^ (X[1] & Y[0]);
// Internal variable
wire carry;
assign carry = (X[0] & Y[1]) & (X[1] & Y[0]);


assign Z[2] = (X[1] & Y[1])^ carry;
assign Z[3] = X[1] & Y[1] & carry;

endmodule


module karatsuba_2_modular(X, Y, C1, C2, Z);
input [1:0] X;
input [1:0] Y;
input C1, C2;
wire [1:0] X;
wire [1:0] Y;
wire C1, C2;
output [5:0] Z;
wire [5:0] Z;


// Internal variables
wire [3:0] XY;
karatsuba_2 mul1(.X(X), .Y(Y), .Z(XY));

wire [4:0] A;
assign A[4] = C1 & C2;
assign A[3] = XY[3];
assign A[2] = XY[2];
assign A[1] = XY[1];
assign A[0] = XY[0];

wire [4:0] B;
wire [1:0] C1Y;
wire [1:0] C2X;
assign C1Y[0] = C1 & Y[0];
assign C1Y[1] = C1 & Y[1];
assign C2X[0] = C2 & X[0];
assign C2X[1] = C2 & X[1];
assign B[0] = C1 ^ C1;
assign B[1] = C1 ^ C1;
wire zero1, zero2;
assign zero1 = C1 ^ C1;
assign zero2 = C1 ^ C1;
rca_Nbit #(.N(2)) sum1 (.a(C1Y), .b(C2X), .cin(zero1), .S(B[3:2]), .cout(B[4]));
rca_Nbit #(.N(5)) sum2 (.a(A), .b(B), .cin(zero2), .S(Z[4:0]), .cout(Z[5]));

endmodule


module karatsuba_4_bit(X, Y, Z);
input [3:0] X;
input [3:0] Y;
output [7:0] Z;
wire [3:0] X;
wire [3:0] Y;
wire [7:0] Z;

wire [1:0]x0;
wire [1:0]x1;
wire [1:0]y0;
wire [1:0]y1;

assign x1 = X[3:2];
assign x0 = X[1:0];
assign y1 = Y[3:2];
assign y0 = Y[1:0];

// Internal var 1
wire [3:0]z0;
wire [3:0]z1;
karatsuba_2 mul0 (.X(x0), .Y(y0), .Z(z0));
karatsuba_2 mul1 (.X(x1), .Y(y1), .Z(z1));
wire zero;
assign zero = 0;


// For z2, the magic step:
wire [2:0] x10;
wire [2:0] y10;
rca_Nbit #(.N(2)) sum0 (.a(x0), .b(x1), .S(x10[1:0]),.cin(zero), .cout(x10[2]));
rca_Nbit #(.N(2)) sum1 (.a(y0), .b(y1), .S(y10[1:0]),.cin(zero), .cout(y10[2]));
wire [5:0] z3;
karatsuba_2_modular mult(.X(x10[1:0]), .Y(y10[1:0]), .C1(x10[2]), .C2(y10[2]), .Z(z3));


// Now from z2 we get to what we need;
wire [5:0] z2;
wire [5:0] sum;
assign sum[5] = 0;
rca_Nbit #(.N(4)) sum2 (.a(z0), .b(z1), .cin(zero), .S(sum[3:0]), .cout(sum[4]));
subtractor #(.N(6)) sub1(.a(z3), .b(sum), .S(z2));


// Now for the sum part

wire [7:0] zerocont;
assign zerocont[3:0] = z0;
assign zerocont[7:4] = z1;

wire [7:0] twocont;
assign twocont[7:2] = z2;
assign twocont[0] = 0;
assign twocont[1] = 0;

// Finally for the n bit adder yay
wire tempout;
rca_Nbit #(.N(8)) summer (.a(zerocont), .b(twocont), .S(Z), .cin(zero), .cout(tempout));
endmodule



module karatsuba_4_modular(X, Y, Z, C1, C2);
input [3:0] X;
input [3:0] Y;
input C1, C2;
wire [3:0] X;
wire [3:0] Y;
wire C1, C2;
output [9:0] Z;
wire [9:0] Z;

// Internal variables
wire [7:0] XY;
karatsuba_4_bit mul1(.X(X), .Y(Y), .Z(XY));

wire [8:0] A;
assign A[8] = C1 & C2;
assign A[7:0] = XY;

wire [8:0] B;

wire [3:0] C1Y;
wire [3:0] C2X;
assign C1Y[0] = Y[0] & C1;
assign C1Y[1] = Y[1] & C1;
assign C1Y[2] = Y[2] & C1;
assign C1Y[3] = Y[3] & C1;
assign C2X[0] = X[0] & C2;
assign C2X[1] = X[1] & C2;
assign C2X[2] = X[2] & C2;
assign C2X[3] = X[3] & C2;

assign B[3] = 0;
assign B[2] = 0;
assign B[1] = 0;
assign B[0] = 0;
wire zero;
assign zero = 0;
rca_Nbit #(.N(4)) sum1 (.a(C1Y), .b(C2X), .cin(zero), .S(B[7:4]), .cout(B[8]));
rca_Nbit #(.N(9)) sum2 (.a(A), .b(B), .cin(zero), .S(Z[8:0]), .cout(Z[9]));
endmodule


module karatsuba_8_bit(X, Y, Z);
input [7:0] X;
input [7:0] Y;
wire [7:0] X;
wire [7:0] Y;
output [15:0] Z;
wire [15:0] Z;

wire [3:0] x0;
wire [3:0] x1;
wire [3:0] y0;
wire [3:0] y1;


assign x1 = X[7:4];
assign x0 = X[3:0];
assign y0 = Y[3:0];
assign y1 = Y[7:4];

// Internal vars
wire [7:0] z0;
wire [7:0] z1;
karatsuba_4_bit mul0(.X(x0), .Y(y0), .Z(z0));
karatsuba_4_bit mul1(.X(x1), .Y(y1), .Z(z1));


wire zero;
assign zero = 0;

// z3 step;
wire [4:0] x10;
wire [4:0] y10;
rca_Nbit #(.N(4)) sum0 (.a(x0), .b(x1), .S(x10[3:0]), .cin(zero), .cout(x10[4]));
rca_Nbit #(.N(4)) sum1 (.a(y0), .b(y1), .S(y10[3:0]), .cin(zero), .cout(y10[4]));
wire [9:0] z3;
karatsuba_4_modular mul2(.X(x10[3:0]), .Y(y10[3:0]), .Z(z3), .C1(x10[4]), .C2(y10[4]));


// Now we get z2
wire [9:0] z2;
wire [9:0] sum;
assign sum[9] = 0;
rca_Nbit #(.N(8)) sum2(.a(z0), .b(z1), .cin(zero), .S(sum[7:0]), .cout(sum[8]));
subtractor #(.N(10)) sub1(.a(z3), .b(sum), .S(z2));

// Sum part
wire [15:0] zerocont;
assign zerocont[7:0] = z0;
assign zerocont[15:8] = z1;

wire [15:0] twocont;
assign twocont[0] = 0;
assign twocont[1] = 0;
assign twocont[2] = 0;
assign twocont[3] = 0;
assign twocont[13:4] = z2;
assign twocont[14] = 0;
assign twocont[15] = 0;

wire tempout;

rca_Nbit #(.N(16)) summer(.a(zerocont), .b(twocont), .S(Z), .cin(zero), .cout(tempout));

endmodule

module karatsuba_8_modular(X, Y, Z, C1, C2);
input [7:0] X;
input [7:0] Y;
input C1, C2;
wire [7:0] X;
wire [7:0] Y;
wire C1, C2;
output [17:0] Z;
wire [17:0] Z;

// Internal variables
wire [15:0] XY;
karatsuba_8_bit mul1(.X(X), .Y(Y), .Z(XY));

wire [16:0] A;
assign A[15:0] = XY;
assign A[16] = C1 & C2;

wire [16:0] B;

wire [7:0] C1Y;
wire [7:0] C2X;
assign C1Y[0] = Y[0] & C1;
assign C1Y[1] = Y[1] & C1;
assign C1Y[2] = Y[2] & C1;
assign C1Y[3] = Y[3] & C1;
assign C1Y[4] = Y[4] & C1;
assign C1Y[5] = Y[5] & C1;
assign C1Y[6] = Y[6] & C1;
assign C1Y[7] = Y[7] & C1;
assign C2X[0] = X[0] & C2;
assign C2X[1] = X[1] & C2;
assign C2X[2] = X[2] & C2;
assign C2X[3] = X[3] & C2;
assign C2X[4] = X[4] & C2;
assign C2X[5] = X[5] & C2;
assign C2X[6] = X[6] & C2;
assign C2X[7] = X[7] & C2;

assign B[7] = 0;
assign B[6] = 0;
assign B[5] = 0;
assign B[4] = 0;
assign B[3] = 0;
assign B[2] = 0;
assign B[1] = 0;
assign B[0] = 0;

wire zero;
assign zero = 0;
rca_Nbit #(.N(8)) sum1 (.a(C1Y), .b(C2X), .cin(zero), .S(B[15:8]), .cout(B[16]));
rca_Nbit #(.N(17)) sum2 (.a(A), .b(B), .cin(zero), .S(Z[16:0]), .cout(Z[17]));
endmodule



module karatsuba_16(X, Y, Z);
input [15:0] X;
input [15:0] Y;
wire [15:0] X;
wire [15:0] Y;
output [31:0] Z;
wire [31:0] Z;

wire [7:0] x0;
wire [7:0] x1;
wire [7:0] y0;
wire [7:0] y1;

assign x1 = X[15:8];
assign x0 = X[7:0];
assign y0 = Y[7:0];
assign y1 = Y[15:8];

// Internal vars
wire [15:0] z0;
wire [15:0] z1;
karatsuba_8_bit mul0(.X(x0), .Y(y0), .Z(z0));
karatsuba_8_bit mul1(.X(x1), .Y(y1), .Z(z1));

wire zero;
assign zero = 0;

// z3 step;
wire [8:0] x10;
wire [8:0] y10;
rca_Nbit #(.N(8)) sum0 (.a(x0), .b(x1), .S(x10[7:0]), .cin(zero), .cout(x10[8]));
rca_Nbit #(.N(8)) sum1 (.a(y0), .b(y1), .S(y10[7:0]), .cin(zero), .cout(y10[8]));

wire [17:0] z3;
karatsuba_8_modular mul2(.X(x10[7:0]), .Y(y10[7:0]), .Z(z3), .C1(x10[8]), .C2(y10[8]));

// Now we get z2
// z2 step;
wire [17:0] z2;
wire [17:0] sum;
assign sum[17] = 0;
rca_Nbit #(.N(16)) sum2(.a(z0), .b(z1), .cin(zero), .S(sum[15:0]), .cout(sum[16]));
subtractor #(.N(18)) sub1(.a(z3), .b(sum), .S(z2));

// Sum part
wire [31:0] zerocont;
assign zerocont[15:0] = z0;
assign zerocont[31:16] = z1;

wire [31:0] twocont;
assign twocont[0] = 0;
assign twocont[1] = 0;
assign twocont[2] = 0;
assign twocont[3] = 0;
assign twocont[4] = 0;
assign twocont[5] = 0;
assign twocont[6] = 0;
assign twocont[7] = 0;
assign twocont[25:8] = z2;
assign twocont[26] = 0;
assign twocont[27] = 0;
assign twocont[28] = 0;
assign twocont[29] = 0;
assign twocont[30] = 0;
assign twocont[31] = 0;

wire tempout;

rca_Nbit #(.N(32)) summer(.a(zerocont), .b(twocont), .S(Z), .cin(zero), .cout(tempout));



endmodule




// Adders used (copied from the rca code), subtractors are new

module half_adder(a, b, S, cout);
input a;
input b;
output S;
output cout;
wire a;
wire b;
wire S;
wire cout;
assign cout = a & b;
assign S = (a & !b) | (!a & b);
endmodule


module full_adder(a, b, cin, S, cout);
input a;
input b;
input cin;
output S;
output cout;
wire a;
wire b;
wire cin;
wire S;
wire cout;

// Internal Variables

wire s1;
wire c1;


half_adder u0(
    .a(a),
    .b(b),
    .S(s1),
    .cout(c1)
);
assign S = (s1 & !cin) | (!s1 & cin);
assign cout = c1 | (cin & a) | (cin & b);

endmodule

module rca_Nbit #(parameter N = 32) (a, b, cin, S, cout);
input [N-1:0] a, b;
input cin;
output [N-1:0] S;
output cout;
wire [N-1:0]a;
wire [N-1:0]b;
wire [N-1:0]S;
wire cout;
wire cin;

// Internal chain of carries
wire [N-1:0] cars;



full_adder init(.a(a[0]), .b(b[0]),.cin(cin), .S(S[0]), .cout(cars[0]));

generate
    genvar i;
    for (i = 1; i < N; i = i + 1) begin
        full_adder addi (.a(a[i]), .b(b[i]), .cin(cars[i-1]), .S(S[i]), .cout(cars[i]));
    end
endgenerate


assign cout = cars[N - 1];

endmodule

// Here we create a subtractor, in our case we only have situations where the
// final answer is positive so we only deal with them

module subtractor #(parameter N = 32) (a, b, S);
input [N-1:0] a, b;
output [N-1:0] S;
wire [N-1:0] a;
wire [N-1:0] b;
wire [N-1:0] S;
// Now we invert the bits of b
wire [N-1:0] b_inv;
assign b_inv = ~b;
wire temp;
wire one = 1;
rca_Nbit #(.N(N)) sub(.a(a), .b(b_inv), .cin(one), .S(S), .cout(temp));

endmodule



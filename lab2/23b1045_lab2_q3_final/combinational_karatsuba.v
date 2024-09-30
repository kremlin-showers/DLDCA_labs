module karatsuba_16 (X, Y, Z);
input [15:0] X, Y;
output [31:0] Z;
wire [15:0] X, Y;
wire [31:0] Z;
wire zero;
assign zero = 0;
wire one;
assign one = 1;

// For internal variables we have
wire [7:0]x0, x1, y0, y1;
assign {x1, x0} = X;
assign {y1, y0} = Y;

// For the z0, z1, z3 we have;
wire [15:0] z0, z1;
karatsuba_8 k1 (x0, y0, z0);
karatsuba_8 k2 (x1, y1, z1);

wire [7:0] x_diff_temp, y_diff_temp;
wire x_diff_sign, y_diff_sign;
adder_subtractor #(.N(8)) sub1 (.a(x0), .b(x1), .S(x_diff_temp), .cout(x_diff_sign), .sign(one));
adder_subtractor #(.N(8)) sub2 (.a(y0), .b(y1), .S(y_diff_temp), .cout(y_diff_sign), .sign(one));

wire [7:0] x_diff, y_diff;
wire [7:0] zeros;
wire throwx, throwy;
assign zeros = 0;
// Using adder_subtractor to take modulus
adder_subtractor #(.N(8)) modulus0 (.a(zeros), .b(x_diff_temp), .S(x_diff), .cout(throwx), .sign(~x_diff_sign));
adder_subtractor #(.N(8)) modulus1 (.a(zeros), .b(y_diff_temp), .S(y_diff), .cout(throwy), .sign(~y_diff_sign));

// Find the product of the differences
wire [16:0] z3;
assign z3[16] = 0;
karatsuba_8 k3 (.X(x_diff), .Y(y_diff), .Z(z3[15:0]));

wire [16:0] sum;
rca_Nbit #(.N(16)) adder (.a(z0), .b(z1), .cin(zero), .S(sum[15:0]), .cout(sum[16]));
wire [16:0] z2;
wire temp;

adder_subtractor #(.N(17)) sub3 (.a(sum), .b(z3), .S(z2), .cout(temp), .sign(~(x_diff_sign ^ y_diff_sign)));

// Now to find the final answer.
wire [31:0] A;
assign A = {z1, z0};
wire [31:0] B;
assign B[7:0] = 0;
assign B[24:8] = z2;
assign B[31:25] = 0;
wire temp1;

rca_Nbit #(.N(32)) final_add(.a(A), .b(B), .cin(zero), .S(Z), .cout(temp1));



endmodule


module karatsuba_8 (X, Y, Z);
input [7:0] X, Y;
output [15:0] Z;
wire [7:0] X, Y;
wire [15:0] Z;
wire zero;
assign zero = 0;
wire one;
assign one = 1;

// For internal variables we have
wire [3:0]x0, x1, y0, y1;
assign {x1, x0} = X;
assign {y1, y0} = Y;

// For the z0, z1, z3 we have;
wire [7:0] z0, z1;
karatsuba_4 k1 (x0, y0, z0);
karatsuba_4 k2 (x1, y1, z1);

wire [3:0] x_diff_temp, y_diff_temp;
wire x_diff_sign, y_diff_sign;
adder_subtractor #(.N(4)) sub1 (.a(x0), .b(x1), .S(x_diff_temp), .cout(x_diff_sign), .sign(one));
adder_subtractor #(.N(4)) sub2 (.a(y0), .b(y1), .S(y_diff_temp), .cout(y_diff_sign), .sign(one));

wire [3:0] x_diff, y_diff;
wire [3:0] zeros;
wire throwx, throwy;
assign zeros = 0;
adder_subtractor #(.N(4)) modulus0 (.a(zeros), .b(x_diff_temp), .S(x_diff), .cout(throwx), .sign(~x_diff_sign));
adder_subtractor #(.N(4)) modulus1 (.a(zeros), .b(y_diff_temp), .S(y_diff), .cout(throwy), .sign(~y_diff_sign));

// Find the product of the differences
wire [8:0] z3;
assign z3[8] = 0;
karatsuba_4 k3 (.X(x_diff), .Y(y_diff), .Z(z3[7:0]));

wire [8:0] sum;
rca_Nbit #(.N(8)) adder (.a(z0), .b(z1), .cin(zero), .S(sum[7:0]), .cout(sum[8]));
wire [8:0] z2;
wire temp;

adder_subtractor #(.N(9)) sub3 (.a(sum), .b(z3), .S(z2), .cout(temp), .sign(~(x_diff_sign ^ y_diff_sign)));

// Now to find the final answer.
wire [15:0] A;
assign A = {z1, z0};
wire [15:0] B;
assign B[3:0] = 0;
assign B[12:4] = z2;
assign B[15:13] = 0;
wire temp1;

rca_Nbit #(.N(16)) final_add(.a(A), .b(B), .cin(zero), .S(Z), .cout(temp1));


endmodule


module karatsuba_4 (X, Y, Z);
input [3:0] X, Y;
output [7:0]Z;
wire [3:0] X, Y;
wire [7:0] Z;
wire zero;
assign zero = 0;
wire one;
assign one = 1;

// For internal variables we have
wire [1:0]x0, x1, y0, y1;
assign {x1, x0} = X;
assign {y1, y0} = Y;

// For the z0, z1, z3 we have;
wire [3:0] z0, z1;
karatsuba_2 k1 (x0, y0, z0);
karatsuba_2 k2 (x1, y1, z1);

wire [1:0] x_diff_temp, y_diff_temp;
wire x_diff_sign, y_diff_sign;
adder_subtractor #(.N(2)) sub1 (.a(x0), .b(x1), .S(x_diff_temp), .cout(x_diff_sign), .sign(one));
adder_subtractor #(.N(2)) sub2 (.a(y0), .b(y1), .S(y_diff_temp), .cout(y_diff_sign), .sign(one));


wire [1:0] x_diff, y_diff;
wire [1:0] zeros;
wire throwx, throwy;
assign zeros = 0;
adder_subtractor #(.N(2)) modulus0 (.a(zeros), .b(x_diff_temp), .S(x_diff), .cout(throwx), .sign(~x_diff_sign));
adder_subtractor #(.N(2)) modulus1 (.a(zeros), .b(y_diff_temp), .S(y_diff), .cout(throwy), .sign(~y_diff_sign));


// Find the product of the differences
wire [4:0] z3;
assign z3[4] = 0;
karatsuba_2 k3 (.X(x_diff), .Y(y_diff), .Z(z3[3:0]));

wire [4:0] sum;
rca_Nbit #(.N(4)) adder (.a(z0), .b(z1), .cin(zero), .S(sum[3:0]), .cout(sum[4]));
wire [4:0] z2;
wire temp;

adder_subtractor #(.N(5)) sub3 (.a(sum), .b(z3), .S(z2), .cout(temp), .sign(~(x_diff_sign ^ y_diff_sign)));
// Now to find the final answer.`
wire [7:0] A;
assign A = {z1, z0};
wire [7:0] B;
assign B[0] = 0;
assign B[1] = 0;
assign B[6:2] = z2;
assign B[7] = 0;
wire temp1;

rca_Nbit #(.N(8)) final_add(.a(A), .b(B), .cin(zero), .S(Z), .cout(temp1));



endmodule

module karatsuba_2 (X, Y, Z);
input [1:0] X, Y;
output [3:0] Z;
wire [1:0] X, Y;
wire [3:0] Z;
wire zero;
assign zero = 0;
wire one;
assign one = 1;

// Now for internal variables we have
wire x0, x1, y0, y1;
assign {x1, x0} = X;
assign {y1, y0} = Y;

// For the z0, z1, z3 we have
karatsuba_1 k1 (x0, y0, z0);
karatsuba_1 k2 (x1, y1, z1);

// Find the difference between x0 and x1 (absolute)
wire x_diff, y_diff;
wire x_diff_sign, y_diff_sign;
adder_subtractor #(.N(1)) sub1 (.a(x0), .b(x1), .S(x_diff), .cout(x_diff_sign), .sign(one));
adder_subtractor #(.N(1)) sub2 (.a(y0), .b(y1), .S(y_diff), .cout(y_diff_sign), .sign(one));
// Here if the sign value is zero then it corresponds to negative. Otherwise it is positive answer.

// Find the product of the differences
wire [1:0]z3;
assign z3[1] = 0;
karatsuba_1 k3 (.X(x_diff), .Y(y_diff), .Z(z3[0]));

// Now we find the middle term using the formula z2 = z0 + z1 - z3;
wire [1:0] sum;
rca_Nbit #(.N(1)) adder (.a(z0), .b(z1), .cin(zero), .S(sum[0]), .cout(sum[1]));
wire [1:0] z2;

adder_subtractor #(.N(2)) sub3 (.a(sum), .b(z3), .S(z2), .cout(temp), .sign(~(x_diff_sign ^ y_diff_sign)));

// Now we find the final answer
wire [2:0] A;
assign A[2] = z1;
assign A[1] = 0;
assign A[0] = z0;
wire [2:0] B;
assign B[0] = 0;
assign B[2:1] = z2;

rca_Nbit #(.N(3)) final_add(.a(A), .b(B), .cin(zero), .S(Z[2:0]), .cout(Z[3]));

endmodule

module karatsuba_1 (X, Y, Z);
input X, Y;
output Z;
wire X, Y, Z;
assign Z = X & Y;
endmodule



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



module adder_subtractor #(parameter N = 32) (a, b, S, cout, sign);
input [N-1:0] a, b;
input sign;
output [N-1:0] S;
output cout;
wire [N-1:0] a, b, S;
wire cout, sign;

// Now we invert the bits of b conditionally
wire [N-1:0] b2;
assign b2 = sign ? ~b : b;
wire cin;
assign cin = sign;

rca_Nbit #(.N(N)) adder(.a(a), .b(b2), .cin(cin), .S(S), .cout(cout));

endmodule

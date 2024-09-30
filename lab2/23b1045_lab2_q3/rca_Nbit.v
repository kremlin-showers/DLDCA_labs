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


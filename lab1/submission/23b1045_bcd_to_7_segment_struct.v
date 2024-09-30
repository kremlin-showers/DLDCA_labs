module struct_segment(x1, x2, x3, x4, A, B, C, D, E, F, G);
input x1, x2, x3, x4;
output A, B, C, D, E, F, G;
wire A;
wire B;
wire C;
wire D;
wire E;
wire F;
wire G;
wire not1;
wire not2;
wire not3;
wire not4;
not (not1, x1);
not (not2, x2);
not (not3, x3);
not (not4, x4);



wire g_1;
wire g_2;
or (g_1, x1, x2, x3);
or (g_2, not2, not3, not4);
and (G, g_1, g_2);


or (C, x1, x2, not3, x4);


wire a_1;
wire a_2;
or (a_1, x1, not2, x4);
or (a_2, x1, x2, x3, not4);
and (A, a_1, a_2);


wire b_1;
wire b_2;
or (b_1, x1, not2, x3, not4);
or (b_2, x1, not2, not3, x4);
and (B, b_1, b_2);


wire d_1;
wire d_2;
wire d_3;
or (d_1, not2, x3, x4);
or (d_2, not2, not3, not4);
or (d_3, x2, x3, not4);
and (D, d_1, d_2, d_3);


wire e_1;
wire e_2;
and (e_1, x3, not4);
and (e_2, not2, not3, not4);
or (E, e_1, e_2);

wire f_1;
wire f_2;
wire f_3;
or (f_1, not3, not4);
or (f_2, not3, x2);
or (f_3, not4, x1, x2);
and (F, f_1, f_2, f_3);


endmodule

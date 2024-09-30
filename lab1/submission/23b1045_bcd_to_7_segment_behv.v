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


assign A = (x1 | ~x2 | x4) & (x1 | x2 | x3 | ~x4);
assign B = (x1 | ~x2 | x3 | ~x4) & (x1 | ~x2 | ~x3 | x4);
assign C = x1 | x2 | ~x3 | x4;
assign D = (~x2 | x3 | x4) & (~x2 | ~x3 | ~x4) & (x2 | x3 | ~x4);
assign E = (x3 & ~x4) | (~x2 & ~x3 & ~x4);
assign F = (~x3 | ~x4) & (~x3 | x2) & (~x4 | x1 | x2);
assign G = (x1 | x2 | x3) & (~x2 | ~x3 | ~x4);




endmodule

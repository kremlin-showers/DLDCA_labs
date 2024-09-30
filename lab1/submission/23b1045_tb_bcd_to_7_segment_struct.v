module tb_struct_segment();
reg x1, x2, x3, x4;
wire A, B, C, D, E, F, G;

struct_segment plz (
    .x1(x1),
    .x2(x2),
    .x3(x3),
    .x4(x4),
    .A(A),
    .B(B),
    .C(C),
    .D(D),
    .E(E),
    .F(F),
    .G(G)
);

initial begin
    $dumpvars();
    $display("Roll No: 23b1045, Name: Niral Charan");
    $monitor ("x1 = %b, x2 = %b, x3 = %b, x4 = %b, A = %b, B = %b, C = %b, D = %b, E = %b, F = %b, G = %b", x1, x2, x3, x4, A, B, C, D, E, F, G);
    x1 = 0;
    x2 = 0;
    x3 = 0;
    x4 = 1;
    #5 x4 = 0;
      x3 = 1;
    #5 x4 = 1;
    #5 x3 = 0;
    x4 = 0;
    x2 = 1;
    #5 x4 = 1;
    #5 x4 = 0;
    x3 = 1;
    #5 x4 = 1;
    #5 x1 = 1;
    x2 = 0;
    x3 = 0;
    x4 = 0;
    #5 x4 = 1;
    #5 x1 = 0;
    x4 = 0;
    #10 $finish;
end

endmodule
`timescale 1ns/1ps

module tb_cla_32bit;


// declare your signals as reg or wire
reg [31:0] a;
reg [31:0] b;
reg cin;
reg [31:0] true_sum;
reg true_cout;

wire [31:0] S;
wire cout;
wire Pout;
wire Gout;

CLA_32bit dut (.a(a), .b(b), .cin(cin), .sum(S), .cout(cout), .Pout(Pout), .Gout(Gout));

initial begin
    repeat(50) begin
        a = $random;
        b = $random;
        cin = $random;
        #50;
        {true_cout, true_sum} = a + b + cin;
        #50;
        if (S !== true_sum || cout !== true_cout) begin
            $display("Error: a=%b, b=%b, cin=%b, S=%b, cout=%b, true_sum=%b, true_cout=%b", a, b, cin, S, cout, true_sum, true_cout);
            $stop;
        end
        else begin
            $display("Success: a=%b, b=%b, cin=%b, S=%b, cout=%b, true_sum=%b, true_cout=%b", a, b, cin, S, cout, true_sum, true_cout);
        end
    end
    $finish;
end



initial begin
    $dumpfile("cla_32bit.vcd");
    $dumpvars(0, tb_cla_32bit);
end

endmodule

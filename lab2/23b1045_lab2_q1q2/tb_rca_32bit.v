`timescale 1ns/1ps

module tb_rca_32_bit();

parameter N = 32;

// declare your signals as reg or wire
reg [31:0] A;
reg [31:0] B;
reg cin;
wire [31:0] S;
wire cout;
reg [31:0] true_S;
reg true_cout;




rca_Nbit #(.N(N)) dut  (.a(A), .b(B), .cin(cin), .S(S), .cout(cout));
initial begin	
// write the stimuli conditions
 repeat(100)
 begin
	 A = $random;
	 B = $random;
	 cin = $random;
	 #5 {true_cout, true_S} = A + B + cin;
	 if (true_cout == cout && true_S == S) begin
		$display("Passed: A = %b, B = %b, cin = %b, cout = %b, S = %b", A, B, cin, cout, S);
	end
	else begin
		$display("Failed!!: A = %b, B = %b, cin = %b, cout = %b, S = %b", A, B, cin, cout, S);
	end

end
$finish;
end


initial begin
    $dumpfile("rca_32bit.vcd");
    $dumpvars(0, tb_rca_32_bit);
end

endmodule

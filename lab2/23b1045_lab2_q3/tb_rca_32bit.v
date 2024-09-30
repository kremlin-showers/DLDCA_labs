`timescale 1ns/1ps

module tb_rca_32_bit();

parameter N = 5;

// declare your signals as reg or wire
reg [4:0] A;
reg [4:0] B;
wire [4:0] S;
reg [4:0] true_S;




subtractor #(.N(N)) dut (.a(A), .b(B), .S(S));
initial begin	
// write the stimuli conditions
 repeat(100)
 begin
	 A = $random;
	 B = $random;
	 #5 true_S = A - B;
	 if (true_S == S) begin
		$display("Passed: A = %b, B = %b, S = %b", A, B, S);
	end
	else begin
		$display("Failed!!: A = %b, B = %b, S = %b", A, B, S);
	end

end
$finish;
end


initial begin
    $dumpfile("rca_32bit.vcd");
    $dumpvars(0, tb_rca_32_bit);
end

endmodule

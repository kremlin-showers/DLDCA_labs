`timescale 1ns/1ps

module tb_rca_32_bit;

parameter N = 32;

// declare your signals as reg or wire

initial begin	

// write the stimuli conditions

end

rca_Nbit dut #(.N(N)) (.a(A), .b(B), .cin(cin), .S(S), .cout(cout));


initial begin
    $dumpfile("rca_32bit.vcd");
    $dumpvars(0, tb_rca_32_bit);
end

endmodule

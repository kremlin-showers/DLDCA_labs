`timescale 1ns/1ps

module tb_combinational_karatsuba;

reg [15:0] X;
reg [15:0] Y;
wire [31:0] Z;
reg [31:0] trueprod;
karatsuba_16 kar(.X(X), .Y(Y), .Z(Z));


initial begin
    repeat(100)
    begin
        X = $random;
        Y = $random;
        #10;
        trueprod = X * Y;
        $display("X = %d, Y = %d, Z = %d, trueprod: %d", X, Y, Z, trueprod);
        if (Z == trueprod)
        begin

        end
        else
        begin
            $display("Failed");
        end

    end
    $finish();

// write the stimuli conditions

end

//karatsuba_16 dut (.X(X), .Y(Y), .Z(Z));

initial begin
    $dumpfile("combinational_karatsuba.vcd");
    $dumpvars(0, tb_combinational_karatsuba);
end

endmodule

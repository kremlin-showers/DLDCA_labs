`timescale 1ns/1ps

module tb_combinational_karatsuba;

// reg [1:0] X;
// reg [1:0] Y;
// wire [3:0] Z;
// reg [3:0] trueprod;
// karatsuba_2 test (.X(X), .Y(Y), .Z(Z));

// reg [3:0] X;
// reg [3:0] Y;
// wire [7:0] Z;
// reg [7:0] trueprod;
// karatsuba_4 test (.X(X), .Y(Y), .Z(Z));

// reg [7:0] X;
// reg [7:0] Y;
// wire [15:0] Z;
// reg [15:0] trueprod;
// karatsuba_8 test (.X(X), .Y(Y), .Z(Z));

reg [15:0] X;
reg [15:0] Y;
wire [31:0] Z;
reg [31:0] trueprod;
karatsuba_16 test (.X(X), .Y(Y), .Z(Z));

initial begin
    repeat(1000)
    begin
        X = $random;
        Y = $random;
        #10;
        trueprod = X * Y;
        $display("X = %d, Y = %d, Z = %d, trueprod: %d", X, Y, Z, trueprod);
        if (Z == trueprod)
        begin

        end
        // Basically we display failed if they are not equal. We see that
        // tthere are no fails for our implementation hence it is correct
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

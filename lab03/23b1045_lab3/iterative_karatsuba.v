/* 32-bit simple karatsuba multiplier */

/*32-bit Karatsuba multipliction using a single 16-bit module*/

module iterative_karatsuba_32_16(clk, rst, enable, A, B, C);
    input clk;
    input rst;
    input [31:0] A;
    input [31:0] B;
    output [63:0] C;
    
    input enable;
    
    
    wire [1:0] sel_x;
    wire [1:0] sel_y;
    
    wire [1:0] sel_z;
    wire [1:0] sel_T;
    
    
    wire done;
    wire en_z;
    wire en_T;
    
    
    wire [31:0] h1;
    wire [31:0] h2;
    wire [63:0] g1;
    wire [63:0] g2;
    
    assign C = g2;
    reg_with_enable #(.N(63)) Z(.clk(clk), .rst(rst), .en(en_z), .X(g1), .O(g2) );  // Fill in the proper size of the register
    reg_with_enable #(.N(31)) T(.clk(clk), .rst(rst), .en(en_T), .X(h1), .O(h2) );  // Fill in the proper size of the register
    
    iterative_karatsuba_datapath dp(.clk(clk), .rst(rst), .X(A), .Y(B), .Z(g2), .T(h2), .sel_x(sel_x), .sel_y(sel_y), .sel_z(sel_z), .sel_T(sel_T), .en_z(en_z), .en_T(en_T), .done(done), .W1(g1), .W2(h1));
    iterative_karatsuba_control control(.clk(clk),.rst(rst), .enable(enable), .sel_x(sel_x), .sel_y(sel_y), .sel_z(sel_z), .sel_T(sel_T), .en_z(en_z), .en_T(en_T), .done(done));
    
endmodule

module iterative_karatsuba_datapath(clk, rst, X, Y, T, Z, sel_x, sel_y, en_z, sel_z, en_T, sel_T, done, W1, W2);
    input clk;
    input rst;
    input [31:0] X;    // input X
    input [31:0] Y;    // Input Y
    input [31:0] T;    // input which sums X_h*Y_h and X_l*Y_l (its also a feedback through the register)
    input [63:0] Z;    // input which calculates the final outcome (its also a feedback through the register)
    output [63:0] W1;  // Signals going to the registers as input
    output [31:0] W2;  // signals hoing to the registers as input
    

    input [1:0] sel_x;  // control signal 
    input [1:0] sel_y;  // control signal 
    
    input en_z;         // control signal 
    input [1:0] sel_z;  // control signal 
    input en_T;         // control signal 
    input [1:0] sel_T;  // control signal 
    
    input done;         // Final done signal
    
   
    
    //-------------------------------------------------------------------------------------------------
    
    // Write your datapath here
    //--------------------------------------------------------
    
    // Firstly we calculate some of the things required anyways
    wire [15:0] x0, y0, x1, y1;
    assign {x1, x0} = X;
    assign {y1, y0} = Y;
    wire one, zero;
    assign one = 1;
    assign zero = 0;

    wire [15:0] x_diff_temp, y_diff_temp;
    wire x_diff_sign, y_diff_sign;
    adder_subtractor #(.N(16)) sub1 (.a(x0), .b(x1), .S(x_diff_temp), .cout(x_diff_sign), .sign(one));
    adder_subtractor #(.N(16)) sub2 (.a(y0), .b(y1), .S(y_diff_temp), .cout(y_diff_sign), .sign(one));

    wire [15:0] x_diff, y_diff;
    wire [15:0] zeros;
    wire throwx, throwy;
    assign zeros = 0;
    // Using adder_subtractor to take modulus
    adder_subtractor #(.N(16)) modulus0 (.a(zeros), .b(x_diff_temp), .S(x_diff), .cout(throwx), .sign(~x_diff_sign));
    adder_subtractor #(.N(16)) modulus1 (.a(zeros), .b(y_diff_temp), .S(y_diff), .cout(throwy), .sign(~y_diff_sign));
    // We also just take the value of sign for the final subtractor
    wire signf;
    assign signf = ~(x_diff_sign ^ y_diff_sign);

    // Hence now we have the precomputed values.
    // Just to prevent shenanigans we let en_T, en_Z indicate that something has been filled in T and  z respectively.
    wire [31:0] T_curr;
    wire [63:0] Z_curr;
    assign T_curr = (sel_T[0] == 0 & sel_T[1] == 1) ? T : 0;
    assign Z_curr = (sel_z[0] == 0) ? 0 : Z;

    // The multiplexer for x;
    wire [15:0] x_mux;
    wire [15:0] y_mux;
    assign x_mux = (sel_x[0] == 0 & sel_x[1] == 0) ? x0 : (sel_x[0] == 1 & sel_x[1] == 0) ? x1 : x_diff;
    assign y_mux = (sel_y[0] == 0 & sel_y[1] == 0) ? y0 : (sel_y[0] == 1 & sel_y[1] == 0) ? y1 : y_diff;

  //  mult_16 multipl(x_mux, y_mux, W2);
    wire [31:0] multiplication;
    assign multiplication = x_mux * y_mux;
    assign W2 = multiplication;

    // Now we have four useful wires for the T multiplexer.
    wire [63:0] T00 = { 32'b0, W2};
    wire [63:0] T01 = {W2, 32'b0};
    wire [63:0] T10;

    wire [32:0] sum;
    wire [32:0] subtracted;
    adder_Nbit #(.N(32)) adder_adder (.a(T_curr), .b(Z_curr[31:0]), .cin(zero), .S(sum[31:0]), .cout(sum[32]));
    wire [32:0] tosubtract;
    assign tosubtract = {1'b0, W2};
    wire cout;
    adder_subtractor #(.N(33)) sub_f(.a(sum), .b(tosubtract), .S(subtracted), .cout(temp), .sign(signf));
    assign T10 = {15'b0, subtracted, 16'b0};

    wire [63:0] Tmux;
    wire tempf;
    assign Tmux = (sel_T[0] == 0 & sel_T[1] == 0) ? T00 : (sel_T[0] == 1 & sel_T[1] == 0) ? T01 : T10;
    wire [63:0] sumnext;
    adder_Nbit #(.N(64)) adder_final_yay(.a(Tmux), .b(Z_curr), .cin(zero),.S(sumnext) ,.cout(tempf));
    assign W1 = (sel_z[0] == 0 & sel_z[1] == 0)? 64'b0 : sumnext;
    

endmodule


module iterative_karatsuba_control(clk,rst, enable, sel_x, sel_y, sel_z, sel_T, en_z, en_T, done);
    input clk;
    input rst;
    input enable;
    
    output reg [1:0] sel_x;
    output reg [1:0] sel_y;
    
    output reg [1:0] sel_z;
    output reg [1:0] sel_T;    
    
    output reg en_z;
    output reg en_T;
    
    
    output reg done;
    
    reg [5:0] state, nxt_state;
    parameter S0 = 6'b000001;   // initial state
    parameter S1 = 6'b000011;
    parameter S2 = 6'b000111;
    parameter S3 = 6'b001111;
    parameter S4 = 6'b011111;
   // <define the rest of the states here>

    always @(posedge clk) begin
        if (rst) begin
            state <= S0;
        end
        else if (enable) begin
            state <= nxt_state;
        end
    end
    

    always@(*) begin
        case(state) 
            S0: 
                begin
					// Write your output and next state equations here
                    sel_x = 2'b00;
                    sel_y = 2'b00;
                    sel_z = 2'b00;
                    sel_T = 2'b00;
                    en_z = 1;
                    en_T = 1;
                    nxt_state <= S1;
                    done = 0;

                end
            S1:
                begin
					// Write your output and next state equations here
                    sel_x = 2'b00;
                    sel_y = 2'b00;
                    sel_z = 2'b01;
                    sel_T = 2'b00;
                    en_z = 1;
                    en_T = 1;
                    nxt_state <= S2;
                    done = 0;
                end
            S2:
                begin
					// Write your output and next state equations here
                    sel_x = 2'b01;
                    sel_y = 2'b01;
                    sel_z = 2'b01;
                    sel_T = 2'b01;
                    en_z = 1;
                    en_T = 1;
                    nxt_state <= S3;
                    done = 0;
                end
            S3:
                begin
					// Write your output and next state equations here
                    sel_x = 2'b10;
                    sel_y = 2'b10;
                    sel_z = 2'b01;
                    sel_T = 2'b10;
                    en_z = 1;
                    en_T = 1;
                    nxt_state <= S4;
                    done = 0;
                end
            S4:
                begin
					// Write your output and next state equations here
                    sel_x = 2'b00;
                    sel_y = 2'b00;
                    sel_z = 2'b01;
                    sel_T = 2'b00;
                    en_z = 0;
                    en_T = 0;
                    done = 1;
                    nxt_state <= S4;
                end

			// Define the rest of the states
            default: 
                begin
                    sel_x <= 2'b00;
                    sel_y <= 2'b00;
                    sel_z <= 2'b00;
                    sel_T <= 2'b00;
                    en_z <= 1;
                    en_T <= 1;
                    nxt_state <= S0;
                    done <= 0;
				// Don't forget the default
                end            
        endcase
        
    end

endmodule


module reg_with_enable #(parameter N = 32) (clk, rst, en, X, O );
    input [N:0] X;
    input clk;
    input rst;
    input en;
    output [N:0] O;
    
    reg [N:0] R;
    
    always@(posedge clk) begin
        if (rst) begin
            R <= {N{1'b0}};
        end
        if (en) begin
            R <= X;
        end
    end
    assign O = R;
endmodule







/*-------------------Supporting Modules--------------------*/
/*------------- Iterative Karatsuba: 32-bit Karatsuba using a single 16-bit Module*/

module mult_16(X, Y, Z);
input [15:0] X;
input [15:0] Y;
output [31:0] Z;

assign Z = X*Y;

endmodule


module mult_17(X, Y, Z);
input [16:0] X;
input [16:0] Y;
output [33:0] Z;

assign Z = X*Y;

endmodule

module full_adder(a, b, cin, S, cout);
input a;
input b;
input cin;
output S;
output cout;

assign S = a ^ b ^ cin;
assign cout = (a&b) ^ (b&cin) ^ (a&cin);

endmodule


module check_subtract (A, B, C);
 input [7:0] A;
 input [7:0] B;
 output [8:0] C;
 
 assign C = A - B; 
endmodule



/* N-bit RCA adder (Unsigned) */
module adder_Nbit #(parameter N = 32) (a, b, cin, S, cout);
input [N-1:0] a;
input [N-1:0] b;
input cin;
output [N-1:0] S;
output cout;

wire [N:0] cr;  

assign cr[0] = cin;


generate
    genvar i;
    for (i = 0; i < N; i = i + 1) begin
        full_adder addi (.a(a[i]), .b(b[i]), .cin(cr[i]), .S(S[i]), .cout(cr[i+1]));
    end
endgenerate    


assign cout = cr[N];

endmodule


module Not_Nbit #(parameter N = 32) (a,c);
input [N-1:0] a;
output [N-1:0] c;

generate
genvar i;
for (i = 0; i < N; i = i+1) begin
    assign c[i] = ~a[i];
end
endgenerate 

endmodule


/* 2's Complement (N-bit) */
module Complement2_Nbit #(parameter N = 32) (a, c, cout_comp);

input [N-1:0] a;
output [N-1:0] c;
output cout_comp;

wire [N-1:0] b;
wire ccomp;

Not_Nbit #(.N(N)) compl(.a(a),.c(b));
adder_Nbit #(.N(N)) addc(.a(b), .b({ {N-1{1'b0}} ,1'b1 }), .cin(1'b0), .S(c), .cout(ccomp));

assign cout_comp = ccomp;

endmodule


/* N-bit Subtract (Unsigned) */
module subtract_Nbit #(parameter N = 32) (a, b, cin, S, ov, cout_sub);

input [N-1:0] a;
input [N-1:0] b;
input cin;
output [N-1:0] S;
output ov;
output cout_sub;

wire [N-1:0] minusb;
wire cout;
wire ccomp;

Complement2_Nbit #(.N(N)) compl(.a(b),.c(minusb), .cout_comp(ccomp));
adder_Nbit #(.N(N)) addc(.a(a), .b(minusb), .cin(1'b0), .S(S), .cout(cout));

assign ov = (~(a[N-1] ^ minusb[N-1])) & (a[N-1] ^ S[N-1]);
assign cout_sub = cout | ccomp;

endmodule



/* n-bit Left-shift */

module Left_barrel_Nbit #(parameter N = 32)(a, n, c);

input [N-1:0] a;
input [$clog2(N)-1:0] n;
output [N-1:0] c;


generate
genvar i;
for (i = 0; i < $clog2(N); i = i + 1 ) begin: stage
    localparam integer t = 2**i;
    wire [N-1:0] si;
    if (i == 0) 
    begin 
        assign si = n[i]? {a[N-t:0], {t{1'b0}}} : a;
    end    
    else begin 
        assign si = n[i]? {stage[i-1].si[N-t:0], {t{1'b0}}} : stage[i-1].si;
    end
end
endgenerate

assign c = stage[$clog2(N)-1].si;

endmodule

// My own module for adder_subtractor, I find it easier to do since I used this in karatsuba.
module adder_subtractor #(parameter N = 32) (a, b, S, cout, sign);
input [N-1:0] a, b;
input sign;
output [N-1:0] S;
output cout;
wire [N-1:0] a, b, S;
wire cout, sign;

// Now we invert the bits of b conditionally
wire [N-1:0] b2;
assign b2 = sign ? ~b : b;
wire cin;
assign cin = sign;

adder_Nbit #(.N(N)) adder(.a(a), .b(b2), .cin(cin), .S(S), .cout(cout));

endmodule



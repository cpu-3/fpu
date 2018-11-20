`default_nettype none

module fadd(
		input wire clk,
		input wire [31:0] x1,
		input wire [31:0] x2,
		output reg [31:0] y);

	wire s1;
	wire s2;
	wire [7:0] e1;
	wire [7:0] e2;
	wire [22:0] m1;
	wire [22:0] m2;
	assign {s1,e1,m1} = x1;
	assign {s2,e2,m2} = x2;

	wire [24:0] m1a;
	wire [24:0] m2a;
	assign m1a = {1'b0, 1'b1, m1};
	assign m2a = {1'b0, 1'b1, m2};

	wire [8:0] ediff;
	wire [7:0] ediffabs;
	wire [4:0] shift;
	wire beq;
	assign ediff = {1'b1,e1} + {1'b0,~e2} + 1; // e1-e2
	assign ediffabs = (ediff[8])? ~(ediff[7:0])+1: ediff[7:0];
	assign shift = (|ediffabs[7:5])? 5'd31 : ediffabs[4:0]; // shiftの量
	assign beq = (|ediff)? ~ediff[8]: m1a > m2a; // x1 >= x2

	// s = sup; i = inf;
	wire [7:0] es;
	wire [7:0] ei;
	wire [24:0] ms;
	wire [24:0] mi;
	wire ss;
	assign ms = beq? m1a: m2a;
	assign mi = beq? m2a: m1a;
	assign es = beq? e1: e2;
	assign ei = beq? e2: e1;
	assign ss = beq? s1: s2;

	wire [55:0] mie;
	wire [55:0] mia;
	assign mie = {mi,31'b0};
	assign mia = mie >> shift;

	wire [26:0] calc;
	assign calc = (s1==s2)? ({ms,2'b0} + mia[55:29]): ({ms,2'b0} - mia[55:29]);

	function [4:0] ENCODER (
		input [26:0] INPUT
	);
	begin
		casez (INPUT)
			27'b1zzzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00000;
			27'b01zzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00001;
			27'b001zzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00010;
			27'b0001zzzzzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00011;
			27'b00001zzzzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00100;
			27'b000001zzzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00101;
			27'b0000001zzzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00110;
			27'b00000001zzzzzzzzzzzzzzzzzzz: ENCODER = 5'b00111;
			27'b000000001zzzzzzzzzzzzzzzzzz: ENCODER = 5'b01000;
			27'b0000000001zzzzzzzzzzzzzzzzz: ENCODER = 5'b01001;
			27'b00000000001zzzzzzzzzzzzzzzz: ENCODER = 5'b01010;
			27'b000000000001zzzzzzzzzzzzzzz: ENCODER = 5'b01011;
			27'b0000000000001zzzzzzzzzzzzzz: ENCODER = 5'b01100;
			27'b00000000000001zzzzzzzzzzzzz: ENCODER = 5'b01101;
			27'b000000000000001zzzzzzzzzzzz: ENCODER = 5'b01110;
			27'b0000000000000001zzzzzzzzzzz: ENCODER = 5'b01111;
			27'b00000000000000001zzzzzzzzzz: ENCODER = 5'b10000;
			27'b000000000000000001zzzzzzzzz: ENCODER = 5'b10001;
			27'b0000000000000000001zzzzzzzz: ENCODER = 5'b10010;
			27'b00000000000000000001zzzzzzz: ENCODER = 5'b10011;
			27'b000000000000000000001zzzzzz: ENCODER = 5'b10100;
			27'b0000000000000000000001zzzzz: ENCODER = 5'b10101;
			27'b00000000000000000000001zzzz: ENCODER = 5'b10110;
			27'b000000000000000000000001zzz: ENCODER = 5'b10111;
			27'b0000000000000000000000001zz: ENCODER = 5'b11000;
			27'b00000000000000000000000001z: ENCODER = 5'b11001;
			27'b000000000000000000000000001: ENCODER = 5'b11010;
			27'b000000000000000000000000000: ENCODER = 5'b11011;
		endcase
	end
	endfunction

	wire [4:0] ketaoti;
	assign ketaoti = ENCODER(calc);
	
	wire [26:0] my;
	assign my = calc << ketaoti;

	wire signed [8:0] ey;
	assign ey = {1'b0,es} - {4'b0,ketaoti} + 1 + &(my[25:2]);

	assign y = {ss,ey[7:0],my[25:3]+my[2]}; //round: 4 sya 5 nyu

endmodule

`default_nettype wire

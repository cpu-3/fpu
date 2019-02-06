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

//stage 1
	wire b;
	assign b = {e1,m1} > {e2,m2};

	// s = sup; i = inf;
	wire [7:0] es;
	wire [7:0] ei;
	wire [22:0] ms;
	wire [22:0] mi;
	assign es = (b)? e1: e2;
	assign ei = (b)? e2: e1;
	assign ms = (b)? m1: m2;
	assign mi = (b)? m2: m1;

	wire [7:0] ediff;
	wire [4:0] shift;
	assign ediff = es - ei;
	assign shift = (|ediff[7:5])? 5'd31 : ediff[4:0];

	wire [26:0] mia;
	assign mia = {2'b1,mi,2'b0} >> shift;

	reg ssr;
	reg [7:0] esr;
	reg [24:0] msr;
	reg [26:0] mir;
	reg inonzero;

	wire [26:0] calc;
	assign calc = {msr,2'b0} + mir;

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
			27'b000000000000000000000000000: ENCODER = 5'b11111;
		endcase
	end
	endfunction

	wire [4:0] ketaoti;
	wire zero;
	assign ketaoti = ENCODER(calc);
	assign zero = &zero;
	
	wire [26:0] my;
	assign my = calc << ketaoti;

	wire [8:0] ey;
	wire [7:0] eya;
	assign ey = {1'b0,es} - {4'b0,ketaoti} + 1 + &(my[25:2]);
	assign eya = (ey[8])? 8'b0: ey[7:0];

	always@(posedge clk) begin
	//stage 1
		ssr <= (b)? s1: s2;
		esr <= es;
		msr <= (|es)? {2'b01,ms}: {2'b00,ms};
		mir <= (s1 == s2)? mia: ~mia + 1;
		inonzero <= |ei;
	//stage 2
		y <= (inonzero)? ((zero)? {ssr,31'b0}: {ssr,eya,my[25:3]+my[2]}): {ssr,esr,msr[22:0]}; //round: 4 sya 5 nyu
	end
endmodule

`default_nettype wire

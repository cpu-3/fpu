`default_nettype none

module fsub(
		input wire clk,
		input wire [31:0] x1,
		input wire [31:0] x2,
		output reg [31:0] y);

//stage 0
	wire s1;
	wire s2;
	wire [7:0] e1;
	wire [7:0] e2;
	wire [22:0] m1;
	wire [22:0] m2;
	assign {s1,e1,m1} = x1;
	assign {s2,e2,m2} = x2;

//stage 1
	wire [8:0] ediff;
	wire [7:0] ediffabs;
	wire [4:0] shift;
	wire beq;
	assign ediff = {1'b1,e1} + {1'b0,~e2} + 1; // e1-e2
	assign ediffabs = (ediff[8])? ~(ediff[7:0])+1: ediff[7:0]; // |e1-e2|
	assign shift = (|ediffabs[7:5])? 5'd31 : ediffabs[4:0]; // shiftの量
	assign beq = (|ediff)? ~ediff[8]: m1 > m2; // x1 >= x2?

	// s = sup; i = inf;
	reg [7:0] es;
	reg [24:0] ms;
	reg [26:0] mia;
	reg ss;
	reg si;

//stage 2
	wire [26:0] calc;
	assign calc = (ss==si)? ({ms,2'b0} + mia): ({ms,2'b0} - mia);

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

	always@(posedge clk) begin
	//stage 1
		if (beq) begin
			ms <= (|e1)? {2'b01,m1}: {2'b00,m1};
			es <= e1;
			ss <= s1;
			si <= ~s2;
			mia <= (|e2)? {2'b01,m2,2'b0} >> shift: {2'b0,m2,2'b0} >> shift;
		end
		else begin
			ms <= (|e2)? {2'b01,m2}: {2'b00,m2};
			es <= e2;
			ss <= ~s2;
			si <= s1;
			mia <= (|e1)? {2'b01,m1,2'b0} >> shift: {2'b0,m2,2'b0} >> shift;
		end
	//stage 2
		y <= {ss,ey[7:0],my[25:3]+my[2]}; //round: 4 sya 5 nyu
	end

endmodule

`default_nettype wire

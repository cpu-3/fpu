`default_nettype none

module finvsqrt(
		input wire [31:0] x,
		output wire [31:0] y);

	wire s;
	wire [7:0] e;
	wire [22:0] m;
	wire [4:0] index;
	assign {s,e,m} = x;
	assign index = {e[0], m[22:19]};

	wire [23:0] ma;
	assign ma = {1'b1, m};

	function [7:0] INVSQRT (
			input [4:0] mh);
	begin
	case (mh)
		5'b10000: INVSQRT = 8'b01111110;
		5'b10001: INVSQRT = 8'b01111010;
		5'b10010: INVSQRT = 8'b01110111;
		5'b10011: INVSQRT = 8'b01110100;
		5'b10100: INVSQRT = 8'b01110001;
		5'b10101: INVSQRT = 8'b01101110;
		5'b10110: INVSQRT = 8'b01101100;
		5'b10111: INVSQRT = 8'b01101010;
		5'b11000: INVSQRT = 8'b01100111;
		5'b11001: INVSQRT = 8'b01100101;
		5'b11010: INVSQRT = 8'b01100011;
		5'b11011: INVSQRT = 8'b01100010;
		5'b11100: INVSQRT = 8'b01100000;
		5'b11101: INVSQRT = 8'b01011110;
		5'b11110: INVSQRT = 8'b01011101;
		5'b11111: INVSQRT = 8'b01011011;
		5'b00000: INVSQRT = 8'b01011010;
		5'b00001: INVSQRT = 8'b01010111;
		5'b00010: INVSQRT = 8'b01010101;
		5'b00011: INVSQRT = 8'b01010011;
		5'b00100: INVSQRT = 8'b01010000;
		5'b00101: INVSQRT = 8'b01001111;
		5'b00110: INVSQRT = 8'b01001101;
		5'b00111: INVSQRT = 8'b01001011;
		5'b01000: INVSQRT = 8'b01001010;
		5'b01001: INVSQRT = 8'b01001000;
		5'b01010: INVSQRT = 8'b01000111;
		5'b01011: INVSQRT = 8'b01000101;
		5'b01100: INVSQRT = 8'b01000100;
		5'b01101: INVSQRT = 8'b01000011;
		5'b01110: INVSQRT = 8'b01000010;
		5'b01111: INVSQRT = 8'b01000001;
		default : INVSQRT = 8'bx;
	endcase
	end
	endfunction

	wire [7:0] init;
	assign init = INVSQRT(index);

	wire [45:0] a;
	wire [45:0] b;
	wire [45:0] calc1;
	assign a = 3*{init,37'b0};
	assign b = (e[0])? init*init*init*ma: init*init*init*ma*2;
	assign calc1 = a-b;
	wire [11:0] x1;
	assign x1 = calc1[45:34]+calc1[33];

	wire [57:0] c;
	wire [57:0] d;
	wire [57:0] calc2;
	assign c = 3*{x1,45'b0};
	assign d = (e[0])? x1*x1*x1*ma: x1*x1*x1*ma*2;
	assign calc2 = c-d;

	wire [7:0] ey;
	wire [22:0] my;

	assign my = (calc2[57])? calc2[56:34]+calc2[33]: calc2[55:33]+calc2[32];
	assign ey = (calc2[57])? ((~(e+1))+130)/2+127: ((~(e+1))+130)/2+126;

	assign y = {s,ey,my};
	
endmodule

`default_nettype wire

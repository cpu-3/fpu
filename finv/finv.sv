`default_nettype none

module finv(
		input wire [31:0] x,
		output wire [31:0] y);

	wire s;
	wire [7:0] e;
	wire [22:0] m;
	assign {s,e,m} = x;

	wire [23:0] ma;
	assign ma = {1'b1, m};

	function [7:0] INV (
			input [4:0] mh);
	begin
	case (mh)
		5'b00000: INV = 8'b01111110;
		5'b00001: INV = 8'b01111010;
		5'b00010: INV = 8'b01110111;
		5'b00011: INV = 8'b01110011;
		5'b00100: INV = 8'b01110000;
		5'b00101: INV = 8'b01101101;
		5'b00110: INV = 8'b01101010;
		5'b00111: INV = 8'b01101000;
		5'b01000: INV = 8'b01100101;
		5'b01001: INV = 8'b01100011;
		5'b01010: INV = 8'b01100000;
		5'b01011: INV = 8'b01011110;
		5'b01100: INV = 8'b01011100;
		5'b01101: INV = 8'b01011010;
		5'b01110: INV = 8'b01011000;
		5'b01111: INV = 8'b01010110;
		5'b10000: INV = 8'b01010100;
		5'b10001: INV = 8'b01010011;
		5'b10010: INV = 8'b01010001;
		5'b10011: INV = 8'b01010000;
		5'b10100: INV = 8'b01001110;
		5'b10101: INV = 8'b01001101;
		5'b10110: INV = 8'b01001011;
		5'b10111: INV = 8'b01001010;
		5'b11000: INV = 8'b01001000;
		5'b11001: INV = 8'b01000111;
		5'b11010: INV = 8'b01000110;
		5'b11011: INV = 8'b01000101;
		5'b11100: INV = 8'b01000100;
		5'b11101: INV = 8'b01000011;
		5'b11110: INV = 8'b01000010;
		5'b11111: INV = 8'b01000001;
		default : INV = 8'bx;
	endcase
	end
	endfunction

	wire [7:0] init;
	assign init = INV(m[22:18]);

	wire [38:0] calc1;
	assign calc1 = {init,31'b0} - init*init*ma; //余裕がないかもしれない
	wire [11:0] x1;	//精度をあげる必要があるかも
	assign x1 = calc1[37:26]+calc1[25];

	wire [46:0] calc2;
	assign calc2 = {x1,35'b0} - x1*x1*ma;

	wire [7:0] ey;
	wire [22:0] my;

	assign my = (calc2[45])? calc2[44:22]+calc2[21]: calc2[43:21]+calc2[20];
	assign ey = (calc2[45])? ~e - 1: ~e - 2;

	assign y = {s,ey,my};
	
endmodule

`default_nettype wire

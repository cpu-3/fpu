`default_nettype none

module itof(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

//stage 0
	reg s;
	reg [30:0] m;

//stage 1
	wire [30:0] mabs;
	assign mabs = (s)? (~m) + 1: m;

	wire nonzero;
	assign nonzero = s || (|m);

	function [30:0] ENCODER (
		input [30:0] INPUT
	);
	begin
		casez (INPUT)
			31'b1zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10011101,INPUT[29:7]};
			31'b01zzzzzzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10011100,INPUT[28:6]};
			31'b001zzzzzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10011011,INPUT[27:5]};
			31'b0001zzzzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10011010,INPUT[26:4]};
			31'b00001zzzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10011001,INPUT[25:3]};
			31'b000001zzzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10011000,INPUT[24:2]};
			31'b0000001zzzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010111,INPUT[23:1]};
			31'b00000001zzzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010110,INPUT[22:0]};
			31'b000000001zzzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010101,INPUT[21:0],1'b0};
			31'b0000000001zzzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010100,INPUT[20:0],2'b0};
			31'b00000000001zzzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010011,INPUT[19:0],3'b0};
			31'b000000000001zzzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010010,INPUT[18:0],4'b0};
			31'b0000000000001zzzzzzzzzzzzzzzzzz: ENCODER = {8'b10010001,INPUT[17:0],5'b0};
			31'b00000000000001zzzzzzzzzzzzzzzzz: ENCODER = {8'b10010000,INPUT[16:0],6'b0};
			31'b000000000000001zzzzzzzzzzzzzzzz: ENCODER = {8'b10001111,INPUT[15:0],7'b0};
			31'b0000000000000001zzzzzzzzzzzzzzz: ENCODER = {8'b10001110,INPUT[14:0],8'b0};
			31'b00000000000000001zzzzzzzzzzzzzz: ENCODER = {8'b10001101,INPUT[13:0],9'b0};
			31'b000000000000000001zzzzzzzzzzzzz: ENCODER = {8'b10001100,INPUT[12:0],10'b0};
			31'b0000000000000000001zzzzzzzzzzzz: ENCODER = {8'b10001011,INPUT[11:0],11'b0};
			31'b00000000000000000001zzzzzzzzzzz: ENCODER = {8'b10001010,INPUT[10:0],12'b0};
			31'b000000000000000000001zzzzzzzzzz: ENCODER = {8'b10001001,INPUT[9:0],13'b0};
			31'b0000000000000000000001zzzzzzzzz: ENCODER = {8'b10001000,INPUT[8:0],14'b0};
			31'b00000000000000000000001zzzzzzzz: ENCODER = {8'b10000111,INPUT[7:0],15'b0};
			31'b000000000000000000000001zzzzzzz: ENCODER = {8'b10000110,INPUT[6:0],16'b0};
			31'b0000000000000000000000001zzzzzz: ENCODER = {8'b10000101,INPUT[5:0],17'b0};
			31'b00000000000000000000000001zzzzz: ENCODER = {8'b10000100,INPUT[4:0],18'b0};
			31'b000000000000000000000000001zzzz: ENCODER = {8'b10000011,INPUT[3:0],19'b0};
			31'b0000000000000000000000000001zzz: ENCODER = {8'b10000010,INPUT[2:0],20'b0};
			31'b00000000000000000000000000001zz: ENCODER = {8'b10000001,INPUT[1:0],21'b0};
			31'b000000000000000000000000000001z: ENCODER = {8'b10000000,INPUT[0],22'b0};
			31'b0000000000000000000000000000001: ENCODER = {8'b01111111,23'b0};
			31'b0000000000000000000000000000000: ENCODER = {8'b10011110,23'b0};
		endcase
	end
	endfunction

	wire [30:0] my;
	assign my = ENCODER(mabs);
	
	always@(posedge clk) begin
	//stage 0 fetch
		{s,m} <= x;
	//stage 1
		y <= (nonzero)? {s,my}: 31'b0;
	end

endmodule

`default_nettype wire

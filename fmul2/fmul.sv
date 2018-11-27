`default_nettype none

module fmul(
		input wire clk,
		input wire [31:0] x1,
		input wire [31:0] x2,
		output reg [31:0] y);

//stage 0
	reg s1;
	reg s2;
	reg [7:0] e1;
	reg [7:0] e2;
	reg [22:0] m1;
	reg [22:0] m2;

//stage 1
	reg sy;
	reg [8:0] esum;
	reg [47:0] calc;
	reg z;

//stage 2
	wire [46:0] keta;
	wire [22:0] my;
	assign keta = (calc[47])? calc[46:0]: {calc[45:0],1'b0};
	assign my = ((~(|keta[22:0])) & keta[23])? keta[46:24] + keta [24]: keta[46:24] + keta[23];
// round to even

	wire [8:0] eketa;
	wire [8:0] ey;
	assign eketa = esum + calc[47] + (&keta[46:23]);
	assign ey = (eketa[8] & eketa[7])? 9'b111111111 :((eketa[8] | eketa[7])? eketa - 9'b001111111: 0);

	always@(posedge clk) begin
	//stage 0
		{s1,e1,m1} <= x1;
		{s2,e2,m2} <= x2;
	//stage 1
		sy <= s1 ^ s2;
		esum <= e1 + e2;
		calc = {1'b1,m1} * {1'b1,m2};
		z <= (|e1) && (|e2);
	//stage 2
		y <= (z)? {sy,ey[7:0],my}: {sy,31'b0};
	end

endmodule

`default_nettype wire

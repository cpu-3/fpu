`default_nettype none

module fmul(
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
	wire [47:0] calc;
	assign calc = {1'b1,m1} * {1'b1,m2};

	reg sy;
	reg [8:0] esum;
	reg [25:0] calcr;
	reg nz;

//stage 2
	wire [23:0] mketa;
	wire [22:0] my;
	assign mketa = (calcr[25])? calcr[24:1]: calcr[23:0];
	assign my = mketa[23:1] + mketa[0];

	wire [8:0] ey;
	assign ey = esum + (calcr[25] | (&calcr[23:0]));

	always@(posedge clk) begin
	//stage 1
		sy <= s1 ^ s2;
		esum <= e1 + e2 - 9'b001111111;
		calcr <= calc[47:22];
		nz <= (|e1) & (|e2);
	//stage 2
		y <= (nz)? {sy,ey[7:0],my}: {sy,31'b0};
	end

endmodule

`default_nettype wire

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

	wire [7:0] init;
	assign init = 8'b01001111;

	wire [38:0] calc1;
	assign calc1 = {init,31'b0} - init*init*ma; //余裕がないかもしれない
	wire [11:0] x1;	//精度をあげる必要があるかも	
	assign x1 = calc1[37:26];

	wire [46:0] calc2;
	assign calc2 = {x1,35'b0} - x1*x1*ma;

	wire [7:0] ey;
	wire [22:0] my;

	assign my = (calc2[45])? calc2[44:22]: calc2[43:21];
	assign ey = (calc2[45])? ~e - 1: ~e - 2;

	assign y = {s,ey,my};
	
endmodule

`default_nettype wire

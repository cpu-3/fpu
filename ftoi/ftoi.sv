`default_nettype none

module ftoi(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

//stage 0
	wire s;
	wire [7:0] e;
	wire [22:0] m;
	assign {s,e,m} = x;

//stage 1
	wire [7:0] shift;
	wire [31:0] ma;
	wire [31:0] mabs;
	wire [31:0] my;
	wire nonzero;
	assign shift = 158 - e;
	assign ma = {1'b1,m,8'b0};
	assign mabs = ma >> shift[4:0];
	assign my = (s)? (~mabs) + 1: mabs;
	assign nonzero = e > 126;
	
	always@(posedge clk) begin
	//stage 1
		y <= (nonzero)? my: 32'b0;
	end

endmodule

`default_nettype wire

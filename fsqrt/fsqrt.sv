`default_nettype none

module fsqrt(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

	wire s;
	wire [6:0] e;
	wire [9:0] i;
	wire [13:0] a;
	assign {s,e,i,a} = x;

	mem_sqrt u1(clk, i, {c, g});

	reg s1;
	reg [6:0] e1;
	reg d1;
	reg [13:0] a1;
	reg [22:0] c;
	reg [12:0] g;
	
	wire [7:0] ey;
	wire [37:0] calc;
	assign ey = {e1[6],~e1[6],e1[5:0]};
	assign calc = (d1)? {c,15'b0} + {1'b1,g,1'b0}*a1: {c,15'b0} + {1'b1,g}*a1;

	always@(posedge clk) begin
		// stage 1
		s1 <= s;
		e1 <= e-(~i[9]);
		d1 <= ~i[9];
		a1 <= a;
		// stage 2
		y <= (ey == 8'b10111111)? {s1,31'b0}: {s1,ey,calc[37:15]+calc[14]};
	end

endmodule

module mem_sqrt(
	input wire clk,
	input wire [9:0] index,
	output reg [35:0] o_data);

	reg [35:0] mem [0:1023];

	initial $readmemb("sqrt_v4.bin", mem);

	always @ (posedge clk) begin
		o_data <= mem[index];
	end
endmodule

`default_nettype wire

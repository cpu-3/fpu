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

	reg [36:0] mem [0:1023];
	initial $readmemb("sqrtinit.bin", mem);

	reg s1;
	reg [7:0] e1;
	reg [13:0] a1;
	reg [22:0] c;
	reg [13:0] g;
	reg nz;
	
	wire [6:0] ea;
	wire [36:0] calc;
	assign ea = e - {6'b0,~i[9]};
	assign calc = {c,14'b0} + g*a1;

	always@(posedge clk) begin
		// stage 1
		{c,g} <= mem[i];
		s1 <= s;
		e1 <= {ea[6],~ea[6],ea[5:0]};
		a1 <= a;
		nz <= (|e || i[9]);
		// stage 2
		y <= (nz)? {s1,e1,calc[36:14]+calc[13]}: {s1,31'b0};
	end
endmodule

`default_nettype wire

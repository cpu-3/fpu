`default_nettype none

module fsqrt(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

	wire s;
	wire [6:0] e;
	wire [9:0] index;
	wire [13:0] a;

	assign {s,e,index,a} = x;
	mem_sqrt u1(clk, index, {c, g});

	reg s1;
	reg [7:0] e1;
	reg [22:0] c;
	reg [12:0] g;
	reg [13:0] ar;
	
	reg s2;
	reg [7:0] e2;
	reg [37:0] calc;

	always@(posedge clk) begin
		// stage 1 fetch
		s1 <= s;
		e1 <= ~(e+1+((|index)||(|a)));
		ar <= a;
		// stage 2 mem
		s2 <= s1;
		e2 <= e1;
		calc <= {c,15'b0} + {1'b1,g}*ar;
		// stage 3
		y <= {s2,e2,calc[37:25]};
	end

endmodule

module mem_sqrt(
	input wire clk,
	input wire [9:0] index,
	output reg [35:0] o_data);

	reg [35:0] mem [0:1023];

	initial $readmemb("init.bin", mem);

	always @ (posedge clk) begin
		o_data <= mem[index];
	end
endmodule

`default_nettype wire

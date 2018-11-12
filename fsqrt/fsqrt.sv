`default_nettype none

module fsqrt(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

	wire s;
	wire [6:0] e;
	wire [9:0] index;
	wire [13:0] a;
	wire d;

	assign {s,e,index,a} = x;
	assign d = ~index[9];
	mem_sqrt u1(clk, index, {c, g});

	reg s1;
	reg [6:0] e1;
	reg [22:0] c;
	reg [12:0] g;
	reg [13:0] ar;
	reg double;
	
	reg s2;
	reg [7:0] e2;
	reg [37:0] calc;

	always@(posedge clk) begin
		// stage 1 fetch
		s1 <= s;
		ar <= a;
		e1 <= e[6:0]-d;
		double <= d;
		// stage 2 mem
		s2 <= s1;
		e2 <= {e1[6],~e1[6],e1[5:0]};
		if (double) begin
			calc <= {c,15'b0} + {1'b1,g}*ar*2;
		end
		else begin
			calc <= {c,15'b0} + {1'b1,g}*ar;
		end
		// stage 3
		y <= {s2,e2,calc[37:15]+calc[14]};
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

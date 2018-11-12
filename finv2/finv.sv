`default_nettype none

module finv(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

	wire s;
	wire [7:0] e;
	wire [9:0] index;
	wire [12:0] a;

	assign {s,e,index,a} = x;
	mem_sqrt u1(clk, index, {c, g});

	reg s1;
	reg [7:0] e1;
	reg [22:0] c;
	reg [12:0] g;
	reg [12:0] ar;
	
	reg s2;
	reg [7:0] e2;
	reg [35:0] calc;

	always@(posedge clk) begin
		// stage 1 fetch
		s1 <= s;
		e1 <= ~(e+1+((|index)||(|a)));
		ar <= a;
		// stage 2 mem
		s2 <= s1;
		e2 <= e1;
		calc <= {1'b1,c,12'b0}  - g*ar;
		// stage 3
		y <= {s2,e2,calc[34:12]};
	end

endmodule

module mem_inv(
	input wire clk,
	input wire [9:0] index,
	output reg [35:0] o_data);

	reg [35:0] mem [0:1023];

	initial $readmemb("finv2.bin", mem);

	always @ (posedge clk) begin
		o_data <= mem[index];
	end
endmodule

`default_nettype wire

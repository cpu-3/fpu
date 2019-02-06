`default_nettype none

module finv(
		input wire clk,
		input wire [31:0] x,
		output reg [31:0] y);

	wire s;
	wire [7:0] e;
	wire [9:0] i;
	wire [12:0] a;
	assign {s,e,i,a} = x;

	reg [35:0] mem [0:1023];
	initial $readmemb("inv_v4.bin", mem);

	reg s1;
	reg [7:0] e1;
	reg [12:0] a1;
	reg [22:0] c;
	reg [12:0] g;
	
	wire [35:0] calc;
	assign calc = {1'b1,c,12'b0} - g*a1;

	always@(posedge clk) begin
		// stage 1
		s1 <= s;
		e1 <= ~(e+1+((|i)||(|a)));
		a1 <= a;
		{c,g} <= mem[i];
		// stage 2
		y <= {s1,e1,calc[34:12]};
	end

endmodule

`default_nettype wire

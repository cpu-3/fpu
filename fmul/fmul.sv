`default_nettype none

module fmul(
		input wire [31:0] x1,
		input wire [31:0] x2,
		output wire [31:0] y,
		output wire ovf);

	wire s1;
	wire s2;
	wire [7:0] e1;
	wire [7:0] e2;
	wire [22:0] m1;
	wire [22:0] m2;

	assign {s1,e1,m1} = x1;
	assign {s2,e2,m2} = x2;

	wire sy;
	assign sy = s1 ^ s2;

	
	wire [23:0] m1a;
	wire [23:0] m2a;

	assign m1a = {1'b1,m1};
	assign m2a = {1'b1,m2};

	wire [47:0] mmul;
	wire [46:0] mketa;
	wire [22:0] my;

	assign mmul = m1a*m2a;
	assign mketa = (mmul[47])? mmul[46:0]: {mmul[45:0],1'b0};
	assign my = ((~(|mketa[22:0])) & mketa[23])? mketa[46:24] + mketa [24]: mketa[46:24] + mketa[23];
// saikinsetu marume

	wire [8:0] eadd;
	wire [8:0] eexp;
	wire [7:0] ey;

	assign eadd = e1 + e2 + mmul[47] + (&mketa[46:23]);
	assign eexp = (eadd[8] & eadd[7])? 9'b111111111 :((eadd[8] | eadd[7])? eadd - 9'b001111111: 0);
	assign ey = eexp[7:0];
	assign ovf = eadd[8] & eadd[7];

	assign y = ((|e1)||(|e2)||(|ey))? {sy,ey,my}: {sy,31'b0};
	
endmodule

`default_nettype wire

`timescale 1ns / 100ps
`default_nettype none

module test_cmp();
   wire [31:0] x,y;
   logic [31:0] xi;
	 int					i;
   bit [22:0]   m;
   int          s,e;

   assign x = xi;
   
   finvsqrt u1(x,y);

   initial begin
	 	s=0;
		for (i=0;i<256;i++) begin
		m = {i[7:0], 14'b0};
		e = 127;

   	xi = {s[0],e[7:0],m};

		#1;

  	$display("%d,%d", x, y);
		end
		for (i=0;i<256;i++) begin
		m = {i[7:0], 14'b0};
		e = 128;

   	xi = {s[0],e[7:0],m};

		#1;

  	$display("%d,%d", x, y);
		end
		$finish;
   end
endmodule

`default_nettype wire

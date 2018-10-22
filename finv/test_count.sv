`timescale 1ns / 100ps
`default_nettype none

module test_count();
   wire [31:0] x,y;
   logic [31:0] xi;
   shortreal    fx,fy;
	 int					i;
   bit [22:0]   m;
	 bit [0:0]		random;
	 bit [30:0]		dum;
   logic [31:0] fybit;
   int          s,e;

   assign x = xi;
   
   finv u1(x,y);

   initial begin
	 	s=0;
		for (i=0;i<8388608;i++) begin
		{random, dum} = $urandom();
		m = i[22:0];
		e = 128;

   	xi = {s[0],e[7:0],m};

   	fx = $bitstoshortreal(xi);
		fy = 1 / fx;

		#1;
  	$display("%d,%d", y, $shortrealtobits(fy));
		end
		$finish;
   end
endmodule

`default_nettype wire

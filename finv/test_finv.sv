`timescale 1ns / 100ps
`default_nettype none

module test_finv();
   wire [31:0] x,y;
   logic [31:0] xi;
   shortreal    fx,fy;
	 int					i;
   bit [22:0]   m;
	 bit [17:0]		random;
	 bit [13:0]		dum;
   logic [31:0] fybit;
   int          s,e;

   assign x = xi;
   
   finv u1(x,y);

   initial begin
	 	s=0;
		for (i=0;i<32;i++) begin
		{random, dum} = $urandom();
		m = {i[4:0], random};
		e = $urandom();

   	xi = {s[0],e[7:0],m};

   	fx = $bitstoshortreal(xi);
		fy = 1 / fx;

		#1;
  	$display("x = %b", x);
  	$display("%e %b", fy, $shortrealtobits(fy));
  	$display("%e %b\n", $bitstoshortreal(y), y);
		end
		for (i=0;i<32;i++) begin
		{random, dum} = $urandom();
		m = {i[4:0], 18'b0};
		e = $urandom();

   	xi = {s[0],e[7:0],m};

   	fx = $bitstoshortreal(xi);
		fy = 1 / fx;
  	fybit = $shortrealtobits(fy);

		#1;

  	$display("x = %b", x);
  	$display("%e %b", fy, $shortrealtobits(fy));
  	$display("%e %b\n", $bitstoshortreal(y), y);
		end
		$finish;
   end
endmodule

`default_nettype wire

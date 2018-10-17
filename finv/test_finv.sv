`timescale 1ns / 100ps
`default_nettype none

module test_finv();
   wire [31:0] x,y;
   logic [31:0] xi;
   shortreal    fx,fy;
	 int					i,j;
   bit [22:0]   m;
	 bit [17:0]		random;
	 bit [13:0]		dum;
   logic [31:0] fybit;
   int          s;

   assign x = xi;
   
   finv u1(x,y);

   initial begin
	 // $dumpfile("test_fadd.vcd");
   // $dumpvars(0);
	 	s=0;
		for (j=0;j<31;j++) begin
		{random, dum} = $urandom();
		m = {j[4:0], random};
		i = $urandom();

   	xi = {s[0],i[7:0],m};

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

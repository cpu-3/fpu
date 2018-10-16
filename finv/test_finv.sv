`timescale 1ns / 100ps
`default_nettype none

module test_finv();
   wire [31:0] x,y;
   logic [31:0] xi;
   shortreal    fx,fy;
	 int					i;
   bit [22:0]   m;
   logic [31:0] fybit;
   int          s;

   assign x = xi;
   
   finv u1(x,y);

   initial begin
	 // $dumpfile("test_fadd.vcd");
   // $dumpvars(0);
	 	s=0;
		i=128;
		m = {1'b1, 22'b1010011101010100010101};

   	xi = {s[0],i[7:0],m};

   	fx = $bitstoshortreal(xi);
		fy = 1 / fx;
  	fybit = $shortrealtobits(fy);

  	$display("x = %b", x);
  	$display("%e %b", fy, $shortrealtobits(fy));
  	$display("%e %b\n", $bitstoshortreal(y), y);
		$finish;
   end
endmodule

`default_nettype wire

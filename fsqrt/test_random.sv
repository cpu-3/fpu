`timescale 1ns / 100ps
`default_nettype none

module test_random();
   wire [31:0] x,y;
   logic [31:0] xi;
   shortreal    fx,fy;
	 int					i;
   bit [22:0]   m;
   logic [31:0] fybit;
   int          s,e;
	 wire					clk;
	 reg					CLK;
	 bit [30:0]		random;
	 bit					dum;

   assign x = xi;
	 assign clk = CLK;
   
   fsqrt u1(clk,x,y);

   initial begin
	 	s=0;
		CLK = 0;
		#1;
		for (i=0;i<1024;i++) begin
			{random,dum} = $urandom();

			xi = {s,random};
 	  	fx = $bitstoshortreal(xi);
			fy = $sqrt(fx);
			fybit = $shortrealtobits(fy);
			CLK = 1;
			#1;
			CLK = 0;
			#1;
			CLK = 1;
			#1;
			CLK = 0;
			#1;
			CLK = 1;
			#1;
			CLK = 0;
			#1;
			CLK = 1;
			#1;
			CLK = 0;
			#1;
 		 	$display("%d,%d", y, fybit);
		end
		$finish;
   end
endmodule

`default_nettype wire

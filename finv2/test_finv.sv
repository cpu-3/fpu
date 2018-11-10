`timescale 1ns / 100ps
`default_nettype none

module test_finv();
   wire [31:0] x,y;
   logic [31:0] xi;
   shortreal    fx,fy;
	 int					i;
   bit [22:0]   m;
   logic [31:0] fybit;
   int          s,e;
	 wire					clk;
	 reg					CLK;
	 bit [22:0]		random;
	 bit [8:0]		dum;

   assign x = xi;
	 assign clk = CLK;
   
   finv u1(clk,x,y);

   initial begin
	 	s=0;
		CLK = 0;
		#1;
		for (i=0;i<8388608;i++) begin
			{random,dum} = $urandom();
			m = random;
			e = 127;

 	  	xi = {s[0],e[7:0],m};

 	  	fx = $bitstoshortreal(xi);
			fy = 1 / fx;
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
			CLK = 1;
			#1;
			CLK = 0;
			#1;
 		 	$display("%d,%d", y, $shortrealtobits(fy));
		end
		$finish;
   end
endmodule

`default_nettype wire

`timescale 1ns / 100ps
`default_nettype none

module test_fdiv();
   wire [31:0] x,y,z,yinv;
   logic [31:0] xi,yi;
   shortreal    fx,fy,fz;
	 int					i,j;
   bit [22:0]   mx,my;
	 bit [17:0]		randomx,randomy;
	 bit [13:0]		dumx,dumy;
   int          sx,sy,ex,ey;

   assign x = xi;
	 assign y = yi;
   
   finv u1(y,yinv);
	 fmul u2(x,yinv,z);

   initial begin
	 // $dumpfile("test_fadd.vcd");
   // $dumpvars(0);
	 	sx=0;
		sy=0;
		for (i=0;i<32;i++) begin
		for (j=0;j<32;j++) begin
		{randomx, dumx} = $urandom();
		mx = {i[4:0], randomx};
		ex = $urandom();

		{randomy, dumy} = $urandom();
		my = {j[4:0], randomy};
		ey = $urandom();

   	xi = {sx[0],ex[7:0],mx};
   	yi = {sy[0],ey[7:0],my};

   	fx = $bitstoshortreal(xi);
		fy = $bitstoshortreal(yi);
		fz = fx/fy;

		#1;

  	$display("x = %b", x);
  	$display("%e %b", fz, $shortrealtobits(fz));
  	$display("%e %b\n", $bitstoshortreal(z), z);
		end
		end
		$finish;
   end
endmodule

`default_nettype wire

`default_nettype none

module fsub(
		input wire [31:0] x1,
		input wire [31:0] x2,
		output wire [31:0] y,
		output wire ovf);

	wire s1;
	wire s2rev;
	wire s2;
	wire [7:0] e1;
	wire [7:0] e2;
	wire [22:0] m1;
	wire [22:0] m2;
	assign {s1,e1,m1} = x1;
	assign {s2rev,e2,m2} = x2;
	assign s2 = ~s2rev;

	wire [24:0] m1a;
	wire [24:0] m2a;
	assign m1a = (e1 == 0)? {2'b0, m1} :{1'b0, 1'b1, m1};
	assign m2a = (e2 == 0)? {2'b0, m2} :{1'b0, 1'b1, m2};

	wire [7:0] e1a;
	wire [7:0] e2a;
	assign e1a = (e1 == 0)? 8'd1: e1;
	assign e2a = (e2 == 0)? 8'd1:	e2;

	wire [8:0] te;
	wire [8:0] tei;
	wire ce;
	wire sel;
	wire [7:0] tde;
	wire [4:0] de;
	assign te = {1'b0,e1a} + {1'b0,~e2a};
	assign ce = ~(te[8]);
	assign tei = te + 9'b1;
	assign tde = ce? ~te[7:0]: tei[7:0];
	assign de = (|tde[7:5])? 5'd31 : tde[4:0];
	assign sel = (de == 0)? ((m1a>m2a)? 0 : 1) : ce;

	wire [7:0] es;
	wire [7:0] ei;
	wire [24:0] ms;
	wire [24:0] mi;
	wire ss;
	assign ms = sel? m2a: m1a;
	assign mi = sel? m1a: m2a;
	assign es = sel? e2a: e1a;
	assign ei = sel? e1a: e2a;
	assign ss = sel? s2: s1;

	wire [55:0] mie;
	wire [55:0] mia;
	assign mie = {mi,31'b0};
	assign mia = mie >> de;

	wire tstck;
	assign tstck = |(mia[28:0]);

	wire [26:0] mye;
	assign mye = (s1==s2)? ({ms,2'b0} + mia[55:29]): ({ms,2'b0} - mia[55:29]);

	wire [7:0] esi;
	wire ovf1;
	assign esi = es+1;
	assign ovf1 = (mye[26] && esi == 8'd255)? 1: 0;

	wire [7:0] eyd;
	wire [26:0] myd;
	wire stck;
	assign eyd = mye[26]? ((esi == 255)? 8'd255: esi): es;
	assign myd = mye[26]? ((esi == 255)? {2'b01,25'b0}: mye >> 1): mye;
	assign stck = mye[26]? tstck || mye[0]: tstck;

	wire [4:0] se;
	assign se = myd[25]? 5'd0 :(
			myd[24]? 5'd1 :(
				myd[23]? 5'd2 :(
					myd[22]? 5'd3 :(
						myd[21]? 5'd4 :(
							myd[20]? 5'd5 :(
								myd[19]? 5'd6 :(
									myd[18]? 5'd7 :(
										myd[17]? 5'd8 :(
											myd[16]? 5'd9 :(
												myd[15]? 5'd10 :(
													myd[14]? 5'd11 :(
														myd[13]? 5'd12 :(
															myd[12]? 5'd13 :(
																myd[11]? 5'd14 :(
																	myd[10]? 5'd15 :(
																		myd[9]? 5'd16 :(
																			myd[8]? 5'd17 :(
																				myd[7]? 5'd18 :(
																					myd[6]? 5'd19 :(
																						myd[5]? 5'd20 :(
																							myd[4]? 5'd21 :(
																								myd[3]? 5'd22 :(
																									myd[2]? 5'd23 :(
																										myd[1]? 5'd24 :(
																											myd[0]? 5'd25 : 5'd26)))))))))))))))))))))))));
	
	wire signed [8:0] eyf;
	assign eyf = {1'b0,eyd} - {4'b0,se};

	wire [7:0] eyr;
	wire [26:0] myf;
	assign eyr = (eyf > 0)? eyf[7:0]: 8'b0;
	assign myf = (eyf > 0)? myd << se: myd << (eyd[4:0]-1);

	wire [26:0] myr;
	assign myr = ((myf[1] == 1 && myf[0] == 0 && stck == 0 && myf[2] == 1)
			|| (myf[1] == 1 && myf[0] == 0 && s1 == s2 && stck ==1)
			|| (myf[1] == 1 && myf[0] == 1))? myf[26:2] + 25'b1: myf[26:2];

	wire [7:0] eyri;
	assign eyri = eyr + 8'b1;

	wire [7:0] ey;
	wire [22:0] my;
	wire ovf2;
	assign ey = myr[24]? eyri: ((|myr[23:0])? eyr: 8'b0);
	assign my = myr[24]? 23'b0: ((|myr[23:0])? myr[22:0]: 23'b0);
	assign ovf2 = (e1 != 255 && e2 != 255 && myr[24] && eyri == 255)? 1: 0; //?

	wire sy;
	assign sy = (ey == 0 && my == 0)? s1 && s2: ss;

	wire nzm1;
	wire nzm2;
	assign nzm1 = |(m1[22:0]);
	assign nzm2 = |(m2[22:0]);

	assign y = (e1 == 255 && e2 != 255)? {s1,8'd255,nzm1,m1[21:0]}:(
	(e2 == 255 && e1 != 255)? {s2,8'd255,nzm2,m2[21:0]}:(
	(e1 == 255 && e2 == 255 && nzm2)? {s2,8'd255,1'b1,m2[21:0]}:(
	(e1 == 255 && e1 == 255 && nzm1)? {s1,8'd255,1'b1,m1[21:0]}:(
	(e1 == 255 && e2 == 255 && s1 == s2)? {s1,8'd255,23'b0}:
	(e1 == 255 && e2 == 255)? {1'b1,8'd255,1'b1,22'b0}: {sy,ey,my}))));
	assign ovf = ovf1 || ovf2;
endmodule

`default_nettype wire

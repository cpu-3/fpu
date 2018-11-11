#include <stdio.h>
#include <math.h>

union intfloat{
	unsigned int i;
	float f;
};

void print_binary(unsigned long x, int len){
	int bin[64]={};
	int i;
	for(i=0;i<len;i++){
		bin[len-1-i]= x & 0x01;
		x = x >> 1;
	}
	for(i=0;i<len;i++)
		printf("%d",bin[i]);
}

int main(){

	int i;
	union intfloat x,y,p,q;
	unsigned long c,g;

	x.f = 1.0;
	p.f = 1.0;

	x.i = x.i + 8192;

	for (i=0;i<1024;i++){
		q.f = sqrt(p.f);
		y.f = 1 / (x.f);
		c = q.i & 0x007fffff;
		g = (y.i & 0x007ffc00)/0x00000400;

		print_binary(c,23);
		print_binary(g,13);
		printf("\n");
		x.i = x.i + 16384;
		p.i = p.i + 16384;
	}

	return 0;
}

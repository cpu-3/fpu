#include <stdio.h>
#include <math.h>

union intfloat{
	int i;
	float f;
};

void print_binary(int x){
	int bin[32];
	int i;
	for(i=0;i<32;i++){
		bin[31-i]= x & 0x01;
		x = x >> 1;
	}
	for(i=0;i<32;i++)
		printf("%d",bin[i]);
	printf("\n");
}

int main(){

	int i;
	int counter[64]={};
	union intfloat x,y;
	int result;

	while(scanf("%d,%d\n", &(x.i), &result)!=EOF){
		y.f = 1/sqrt(x.f);
		counter[result-y.i+32]++;

//		print_binary(x.i);
//		print_binary(result);
//		print_binary(y.i);
//		printf("%d\n", result - y.i);
	}

	for(i=0;i<64;i++)
		if(counter[i]!=0)
			printf("%d = %d\n",i-32,counter[i]);

	return 0;
}

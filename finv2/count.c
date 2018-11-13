#include <stdio.h>

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
	int a;
	int b;
	int i;
	int counter[64]={};

	while(scanf("%d,%d",&a,&b) != EOF){
		if(a-b < -31){
			print_binary(a,32);
			printf("\n");
			print_binary(b,32);
			printf("\n\n");
			counter[0]++;
		}
		else if(a-b > 31){
			print_binary(a,32);
			printf("\n");
			print_binary(b,32);
			printf("\n\n");
			counter[63]++;
		}
		else
			counter[a-b+32]++;
	}

	for(i=0;i<64;i++)
		if(counter[i]!=0)
			printf("%d = %d\n",i-32,counter[i]);

	return 0;
}

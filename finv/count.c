#include <stdio.h>

int main(){
	int a;
	int b;
	int i;
	int counter[64]={};

	while(scanf("%d,%d",&a,&b) != EOF)
		counter[a-b+32]++;

	for(i=0;i<64;i++)
		if(counter[i]!=0)
			printf("%d = %d\n",i-32,counter[i]);

	return 0;
}

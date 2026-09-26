#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int Sieve(int n){unsigned char*f=calloc(n+1,1);int c=0;for(int i=2;i<=n;i++)if(!f[i]){c++;for(long long j=(long long)i*i;j<=n;j+=i)f[j]=1;}free(f);return c;}
int main(){clock_t t=clock();int c=0;for(int k=0;k<20;k++)c=Sieve(10000000);printf("%d %f\n",c,(double)(clock()-t)/CLOCKS_PER_SEC);}

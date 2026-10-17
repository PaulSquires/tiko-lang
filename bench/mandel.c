#include <stdio.h>
#include <time.h>
long long Mandel(int w,int h,int maxit){long long total=0;for(int y=0;y<h;y++)for(int x=0;x<w;x++){double cr=x*3.0/w-2.0,ci=y*2.0/h-1.0,zr=0,zi=0;int i=0;while(i<maxit&&zr*zr+zi*zi<=4.0){double t=zr*zr-zi*zi+cr;zi=(zr+zr)*zi+ci;zr=t;i++;}total+=i;}return total;}
int main(){clock_t c=clock();long long r=Mandel(2000,1500,500);printf("%lld %f\n",r,(double)(clock()-c)/CLOCKS_PER_SEC);}

'' A macro in an argument list is expanded WHILE the list is read, so the commas and
'' parentheses it produces separate and nest like written ones. See
'' tests/pp/macro-arg-expand.test.

#define down >,<
#define PAIR 1,2
#define LP (
#define F(x,y) x+y

#macro M(a,b1,b2,c)
dim as boolean r1 = (a b1 c), r2 = (a b2 c)
#endmacro

M(3,down,4)
dim as long f1 = F(PAIR)
dim as long f2 = F(LP 1),2)
dim as long f3 = __FB_IIF__(PAIR, 5)
dim as long f4 = __FB_ARG_COUNT__(LP 1, 2), 3)
print r1, r2, f1, f2, f3, f4

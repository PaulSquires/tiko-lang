'' '##' deletes two characters and nothing else: the spaces around it stay, a pasted name keeps
'' its case, 'a##_' pastes where 'a ##_' joins a line, and a '##' that begins a line pastes onto
'' nothing.
#define tostr(a)   #a
#define join1(a,b) a##b
#define join2(a,b) a ##b
#define join4(a,b) a ## b
#define join5(a,b) a  ##  b
#define joinu(a,b) a##_##b
#define joinv(a,b) a ##_##b
#define j1(a) a##_
#define j2(a) _##a
#define j3(a) a ##_
#define lead(x) ##x
#macro of ? ( t )
	##t
#endmacro
print tostr(join1(X,Y)); "|"; tostr(join2(X,Y)); "|"; tostr(join4(X,Y)); "|"; tostr(join5(X,Y))
print tostr(joinu(X,Y)); "|"; tostr(joinv(X,Y)); "|"; tostr(j1(X)); "|"; tostr(j2(X))
print tostr(lead(Abc)); "|"; __fb_quote__( of( Bar ) )
dim as long X_ = 5, X = 7
print j1(X)
print j3(X)
+ 1

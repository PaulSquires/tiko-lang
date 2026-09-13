'' A DEFAULTED BYREF PARAMETER OF A CONSTRUCTOR GETS AN ADDRESS, not a value. fbc's C for
'' 'constructor( byref s as string = "" )' called as 'dim as T b' is
''     fb_StrAssign( &TMP, -1ll, "", 1ll, 0 );   _ZN1TC1ER8FBSTRING( &B, &TMP )
'' tiko passed the literal's own bytes where the FBSTRING* belongs, and the constructor's first
'' string operation crashed. AfxNova's BSTRING declares exactly that constructor.
''
'' fbc prints: ok 0 / ok 2 / 7 hi
type BSS
	as wstring * 32 buf
	declare constructor( byref s as string = "" )
end type
constructor BSS( byref s as string = "" )
	buf = s
end constructor
type Pair
	as long n
	as string t
	declare constructor( byref k as long = 7, byref w as string = "hi" )
end type
constructor Pair( byref k as long = 7, byref w as string = "hi" )
	n = k : t = w
end constructor
dim as BSS b
print "ok "; len( b.buf )
dim as BSS b2 = BSS( "xy" )
print "ok "; len( b2.buf )
dim as Pair p
print p.n; " "; p.t

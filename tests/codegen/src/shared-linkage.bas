'' WHO MAY SEE A MODULE-LEVEL OBJECT. Everything here went out with external linkage,
'' so two modules that each wrote 'dim shared e' were
''
''     lld-link: error: duplicate symbol: e
''
'' where fbc compiles both and gives each module its own -- and the same for a
'' 'private sub P' holding a 'static sl', which two modules may each define.
''
'' Measured on fbc's own object file, every shape below:
''
''     dim shared sh             static int32 SH$ = 1      d   internal
''     static shared st          static int32 ST$ = 3      d   internal
''     static sl (in a sub)      static int32 SL$1.1954    d   internal
''     common shared cm          int32 CM$                 C   common
''     static member T.cnt       int32 _ZN1T4CNT$E         C   common
''     extern e : dim e = 5      int32 E$ = 5              D   external
''
'' -- internal unless the object is one OTHER MODULES ARE ENTITLED TO REACH.
dim shared sh as long = 1
common shared cm as long
static shared stsh as long = 3

extern e as long
dim e as long = 5

type T
	x as long
	static cnt as long
	declare sub M( )
end type
dim shared T.cnt as long

sub T.M( )
	cnt += 1
end sub

private sub P( )
	static as long sl = 7
	sl += 1
end sub

P( )
print sh, cm, stsh, e

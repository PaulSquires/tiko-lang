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
''     dim shared sh = 1         static int32 SH$ = 1      d   internal
''     static shared st = 3      static int32 ST$ = 3      d   internal
''     dim shared noinit         static int32 NOINIT$      b   internal, .bss
''     static sl (in a sub)      static int32 SL$1.1954    d   internal
''     common shared cm          int32 CM$                 C   common
''     static member, no init    int32 _ZN1V2A$E           C   common
''     static member = 9         int32 _ZN1V2B$E = 9       D   external
''     extern e : dim e          int32 E$                  C   common
''     extern ei : dim ei = 5    int32 EI$ = 5             D   external
''
'' -- internal unless the object is one OTHER MODULES ARE ENTITLED TO REACH, and of
'' those, COMMON until something gives it a value. That is C's tentative definition,
'' which fbc inherits by emitting C, and it is whether an initializer was WRITTEN that
'' decides rather than what it says: '= 0' is a definition and lands in .bss as an
'' ordinary external symbol, measured as 'B'.
dim shared sh as long = 1
dim shared noinit as long
common shared cm as long
static shared stsh as long = 3

extern e as long
dim e as long

extern ei as long
dim ei as long = 5

type V
	x as long
	static a as long
	static b as long
	declare sub M( )
end type
dim shared V.a as long
dim shared V.b as long = 9

sub V.M( )
	a += 1
end sub

private sub P( )
	static as long sl = 7
	sl += 1
end sub

P( )
print sh, noinit, cm, stsh, e, ei, V.a, V.b

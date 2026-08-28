'' SEVEN SHAPES, one probe. Every line below was measured against fbc first.
''
''   using ..outer1     A LEADING '..' IS THE GLOBAL ROOT. fbc accepts it and prints 7;
''                      here the first token is a DOT, so the path came out EMPTY and
''                      the using imported nothing at all.
''   end( 1 )           the parenthesised END, which parses as a call: 'fb_End( 1 )'.
''   bsave( f, b )      the short form: 'fb_GfxBsave( &F, B, 0u, (void*)0 )' -- the last
''                      two default to zero.
''   __DATE_ISO__       "2026-08-28" where __DATE__ is "08-28-2026". Reordered from
''                      DATE( ) rather than asked of the clock twice, so a run that
''                      straddles midnight cannot put two days in one program.
''   ubound( a, 2 )     A DIMENSION PAST THE RANK IS AN EMPTY ONE: -1 for ubound and 0
''                      for lbound, folded. Dimension ZERO is the DIMENSION COUNT.
''   print using ( f )  parentheses are transparent; the literal test asked the node
''                      KIND, so an N_PAREN fell through and the statement declined.
''   x.constructor( )   the structors, spelled out: '_ZN1TC1Ev( &X )'. The name mapping
''                      existed only on the 'procptr( T.M )' path.
namespace outer1
	dim shared as long v1 = 7
end namespace
namespace n2
	using ..outer1
	sub s( )
		print v1
	end sub
end namespace
n2.s( )

type T
	as long v
	declare constructor( )
	declare destructor( )
end type
constructor T( )
	this.v = 5
end constructor
destructor T( )
end destructor
dim as T x
x.constructor( )
x.destructor( )

dim a( 1 to 3 ) as integer
print ubound( a, 2 ), lbound( a, 2 ), ubound( a, 0 ), lbound( a, 0 )
'' ...and __DATE_ISO__ through an ASSERT rather than a PRINT: printing it would put
'' TODAY'S DATE in the golden, which would then fail tomorrow. Ten characters,
'' 'YYYY-MM-DD'. LEFT( ) inside an #assert is fbc error 11, so the year-first
'' half is measured in the commit message and not asserted here.
#assert len( __DATE_ISO__ ) = 10
print using ( "#.##" ); 1.0

dim as string f = "x"
dim as any ptr b
'' GUARDED, and never run: bsave over a null buffer with no graphics screen faults,
'' and END would take the process with it. This test is about what they LOWER to.
if command( 1 ) = "zzz" then
	bsave( f, b )
	end( 1 )
end if

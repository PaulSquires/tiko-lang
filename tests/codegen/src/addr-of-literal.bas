'' '@' OF A STRING LITERAL is a 'zstring ptr' into the literal pool, whatever surrounds
'' it. Measured, fbc-modern: 'typeof( @"abc" )', 'typeof( @(("abc")) )' and
'' 'typeof( iif( c, @"wb", @"rb" ) )' are all 'ZSTRING * 8 PTR'. tiko typed them
'' 'string ptr' -- TKO0833 at every iif and macro '@(lit)' handed to a 'zstring ptr'
'' parameter (tiko-rt's io/devstd, io/devcomopen, dt/intldrv), 'var v = @"var"' a
'' string ptr that crashed when read, and the zstring overload not picked. And two
'' lowering gaps behind the same shapes: '@("macro")' pointed at a string reading "m",
'' which is how io/devcomopen's CASEEQ compares COM options, and '@"ad" "jacent"' did
'' not compile at all. Output identical to fbc-modern's.

const K = "konst"
namespace NS
    const KN = "nskonst"
end namespace

sub takesz( byval p as zstring ptr )
    print "z:"; *p
end sub
sub takecz( byval p as const zstring ptr )
    print "cz:"; *p
end sub
sub ov overload( byval p as zstring ptr )
    print "ov zstring ptr"
end sub
sub ov overload( byval p as string ptr )
    print "ov string ptr"
end sub

#define CASEEQ( lit ) takesz( @(lit) )

dim as long flag = 1
takecz( iif( flag <> 0, @"wb", @"rb" ) )
takecz( iif( flag = 0, @"wb", @"rb" ) )
CASEEQ( "macro" )
takesz( @K )
takesz( @NS.KN )
takesz( @"ad" "jacent" )
takesz( @("par" "ens") )
var v = @"var"
print "v:"; *v; " len"; len( *v )
ov( @"x" )
dim as zstring ptr zp = @"assign"
print *zp

'' A 'dim shared' initialiser that takes the ADDRESS of a procedure this module only
'' DECLARES. The pointer words of a VAR named the procedure and nothing declared it, so
'' clang refused the module: "use of undefined value '@fb_DevFileClose'" -- tiko-rt's
'' io/devfileencod.bas, devstd.bas, devcomopen.bas and devlptopen.bas, whose device
'' hook tables are exactly this. Vtables were already handled; a variable was not.
'' Each word here is a different way in: an 'extern "c"' declaration with an alias, a
'' plain declaration, a PRIVATE procedure referenced by nothing but the initialiser
'' (it was dropped as unreferenced), and an address among data (a mixed image).
'' Output identical to fbc-modern's.

type HOOKS
    as function( byval x as long ) as long f1
    as function( byval x as long ) as long f2
    as function( byval x as long ) as long f3
end type

type MIXED
    as function( byval x as long ) as long f
    as long k
end type

extern "c"
    declare function hookA alias "gipa_hookA" ( byval x as long ) as long
end extern
declare function hookB( byval x as long ) as long

private function hookP( byval x as long ) as long
    return x - 1
end function

dim shared as HOOKS hk = ( @hookA, @hookB, @hookP )
dim shared as MIXED mx = ( @hookB, 5 )

print "alias "; str( hk.f1( 20 ) )
print "plain "; str( hk.f2( 3 ) )
print "private "; str( hk.f3( 10 ) )
print "mixed "; str( mx.f( mx.k ) )

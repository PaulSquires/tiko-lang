'' error-parity.bas -- differential for the error-context accessors.
''
'' NOTE: the locals are oldM1/oldF1 rather than ma/fa -- FreeBASIC identifiers
'' are case-insensitive, so `ma` collides with the `mA` buffer it reads.
''
'' Accumulates everything and prints at the END. That is not style: a successful
'' PRINT clears the error number, so a test that prints between calls measures
'' its own output statements. The first version of PROBE-25 did exactly that and
'' concluded fb_ErrorSetNum did not work.

extern "rtlib"
    declare function p_SetNum      alias "fb_ErrorSetNum" ( byval n as long ) as long
    declare function p_GetNum      alias "fb_ErrorGetNum" ( ) as long
    declare function p_GetLineNum  alias "fb_ErrorGetLineNum" ( ) as long
    declare function p_SetModName  alias "fb_ErrorSetModName" ( byval s as zstring ptr ) as zstring ptr
    declare function p_GetModName  alias "fb_ErrorGetModName" ( ) as zstring ptr
    declare function p_SetFuncName alias "fb_ErrorSetFuncName" ( byval s as zstring ptr ) as zstring ptr
    declare function p_GetFuncName alias "fb_ErrorGetFuncName" ( ) as zstring ptr
end extern

dim shared as zstring * 16 mA = "modA", mB = "modB", fA = "funcA", fB = "funcB"

'' --- numbers: setter returns the NEW value, getter is non-destructive
dim as long n0 = p_GetNum( )
dim as long r7 = p_SetNum( 7 )
dim as long g1 = p_GetNum( )
dim as long g2 = p_GetNum( )
dim as long r9 = p_SetNum( 9 )
dim as long g3 = p_GetNum( )
dim as long r0 = p_SetNum( 0 )
dim as long g4 = p_GetNum( )
dim as long ln = p_GetLineNum( )

'' --- names: setters return the OLD value
dim as zstring ptr m0 = p_GetModName( )
dim as zstring ptr oldM1 = p_SetModName( @mA )
dim as zstring ptr m1 = p_GetModName( )
dim as zstring ptr oldM2 = p_SetModName( @mB )
dim as zstring ptr m2 = p_GetModName( )
dim as zstring ptr oldM3 = p_SetModName( 0 )
dim as zstring ptr m3 = p_GetModName( )

dim as zstring ptr f0 = p_GetFuncName( )
dim as zstring ptr oldF1 = p_SetFuncName( @fA )
dim as zstring ptr f1 = p_GetFuncName( )
dim as zstring ptr oldF2 = p_SetFuncName( @fB )
dim as zstring ptr f2 = p_GetFuncName( )
dim as zstring ptr oldF3 = p_SetFuncName( 0 )
dim as zstring ptr f3 = p_GetFuncName( )

sub shw( byval tag as zstring ptr, byval p as zstring ptr )
    print *tag; ": "; iif( p = 0, "NULL", *p )
end sub

print "-- error number"
print "  initial      = "; n0
print "  SetNum(7)ret = "; r7
print "  Get #1       = "; g1
print "  Get #2       = "; g2
print "  SetNum(9)ret = "; r9
print "  Get          = "; g3
print "  SetNum(0)ret = "; r0
print "  Get          = "; g4
print "  GetLineNum   = "; ln
print "-- module name (setter returns the OLD value)"
shw( @"  initial       ", m0 )
shw( @"  SetModName(A) ", oldM1 )
shw( @"  Get           ", m1 )
shw( @"  SetModName(B) ", oldM2 )
shw( @"  Get           ", m2 )
shw( @"  SetModName(0) ", oldM3 )
shw( @"  Get           ", m3 )
print "-- function name"
shw( @"  initial       ", f0 )
shw( @"  SetFuncName(A)", oldF1 )
shw( @"  Get           ", f1 )
shw( @"  SetFuncName(B)", oldF2 )
shw( @"  Get           ", f2 )
shw( @"  SetFuncName(0)", oldF3 )
shw( @"  Get           ", f3 )

'' str / chr / asc / instr / instrrev / val -- the rest of the string intrinsics.
''
'' STR'S NARROW TYPES DO NOT GET THEIR OWN ENTRY POINTS the way hex/oct/bin's do, which
'' is the one thing about it that the radix family sitting beside it would have led you
'' to guess wrong: byte, short and long ALL widen to int32 and go through fb_IntToStr,
'' and only 64-bit, the two floats and BOOLEAN have their own. BOOLEAN matters -- it is
'' a byte in MIR, and fb_BoolToStr writes 'true'/'false' where fb_IntToStr would write
'' -1 and 0 -- so the entry point comes off the BUILTIN and never off the MIR type.
''
'' INTEGER is 64-bit on win64 and 32-bit on win32, so it is the one type whose entry
'' point is target-dependent.
''
'' The argument ORDER is not consistent and neither is the default start position:
''
''   instr( s, t )     fb_StrInstr( 1ll, &S, &T )      start FIRST, default 1
''   instrrev( s, t )  fb_StrInstrRev( &S, &T, -1ll )  start LAST, default -1
''
'' 'val( s )' returns a DOUBLE whatever it is assigned to, and fbc's fb_D2I is a macro
'' over __builtin_nearbyint -- so a val into an integer ROUNDS TO NEAREST rather than
'' truncating. M_NEARBYINT is what Coerce already emits for that narrowing.

sub P( )
    dim as string s, t
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint q : dim as ulongint uq
    dim as single f : dim as double dd : dim as boolean bo
    dim as long n = 3
    s = str( b ) : s = str( ub ) : s = str( sh ) : s = str( ush )
    s = str( l ) : s = str( ul ) : s = str( q ) : s = str( uq )
    s = str( f ) : s = str( dd ) : s = str( bo )
    n = asc( s ) : n = asc( s, n )
    n = instr( s, t ) : n = instr( n, s, t ) : n = instr( s, any t )
    n = instrrev( s, t )
    b = val( s ) : l = val( s ) : q = vallng( s ) : uq = valulng( s )
    dd = val( s ) : f = val( s ) : n = valint( s ) : uq = valuint( s )
end sub

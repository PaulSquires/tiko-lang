'' LOBYTE / HIBYTE / LOWORD / HIWORD ARE PREDEFINED MACROS, not keywords and not
'' compiler intrinsics. Measured three ways:
''
''   'dim lobyte as integer'   error 4, "Duplicated definition, lobyte" -- the SYMBOL
''                             wording, where a real keyword gives "found 'sgn'"
''   'lobyte( 1, 2 )'          error 1, "Argument count mismatch, EXPANDING: LOBYTE"
''   'fbc -pp'                 prints the bodies verbatim
''
'' They were nothing at all in tiko-lang, so every use of one was an unresolved call
'' that lowered to no code. numbers/hiword.bas alone declined 20 statements.
''
'' HIWORD is the one that differs by target: on win32 the &hFFFF0000 mask is redundant
'' once the shift has run, and fbc's own body omits it there.

dim i8  as ubyte    =               &h88u
dim i16 as ushort   =             &h7788u
dim i32 as ulong    =         &h55667788u
dim i64 as ulongint = &h1122334455667788u

'' The result is UINTEGER whatever went in -- the bodies open with 'cuint'.
#assert( typeof( lobyte( i8  ) ) = typeof( uinteger ) )
#assert( typeof( hibyte( i16 ) ) = typeof( uinteger ) )
#assert( typeof( loword( i32 ) ) = typeof( uinteger ) )
#assert( typeof( hiword( i64 ) ) = typeof( uinteger ) )

'' Run under fbc, both of these print '136 119 30600 21862'.
print lobyte( i8  ); " "; hibyte( i16 ); " "; loword( i32 ); " "; hiword( i32 )
print lobyte( i64 ); " "; hibyte( i64 ); " "; loword( i64 ); " "; hiword( i64 )

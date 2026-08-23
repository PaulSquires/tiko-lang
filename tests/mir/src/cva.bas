'' THE VARARG CURSOR. fbc emits gcc BUILTINS for all four, not runtime calls, so they
'' are MIR opcodes -- putting them in the runtime inventory would also have broken
'' check-rtl, which compares against what fbc DECLARES, and a builtin is declared
'' nowhere.
''
'' Measured from fbc, win64:
''
''     __builtin_va_list ARGS$1;
''     __builtin_memset( &ARGS$1, 0, 8ll );
''     __builtin_va_start( *(__builtin_va_list*)&ARGS$1, N$1 );
''     A$1 = __builtin_va_arg( *(__builtin_va_list*)&ARGS$1, int64 );
''     __builtin_va_copy( *(__builtin_va_list*)&COPY_$1, *(__builtin_va_list*)&ARGS$1 );
''     __builtin_va_end( *(__builtin_va_list*)&ARGS$1 );
''
'' EVERY ONE TAKES THE ADDRESS, never the value -- which is what lets a 24-byte Linux
'' va_list and an 8-byte Windows one share one lowering with no target case in it.
sub Sum cdecl ( byval n as integer, ... )
    dim as cva_list args, copy_
    cva_start( args, n )
    dim as integer a = cva_arg( args, integer )
    dim as double d = cva_arg( args, double )
    dim as any ptr p = cva_arg( args, any ptr )
    cva_copy( copy_, args )
    dim as integer b = cva_arg( copy_, integer )
    cva_end( copy_ )
    cva_end( args )
    print a, d, b
end sub

'' A cva_list RESULT gets the same named result local a UDT return does. It is a
'' BUILTIN rather than a UDT, and testing the type KIND alone missed it -- four
'' declines in one corpus file, all of them this line.
function Opened cdecl ( byval n as integer, ... ) as cva_list
    dim as cva_list args
    cva_start( args, n )
    function = args
end function

'' A cva_list travels BYREF into a helper, which is how the corpus factors its
'' walkers. The parameter is a reference and every cva_* operation goes through it.
sub Walk( byref args as cva_list )
    dim as integer x = cva_arg( args, integer )
    print x
end sub

Sum( 3, 1, 2.5, 0 )

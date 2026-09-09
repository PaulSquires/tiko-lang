'' '__FB_EVAL__' WHOSE RESULT CONTAINS A QUOTE EMITS THAT QUOTE RAW.
''
'' The corpus's own idiom for assigning through a macro is pp/macro-eval.bas:
''
''     #macro assign( sym, expr )
''     #define tmp __FB_EVAL__( expr )
''     __FB_UNQUOTE__( __FB_EVAL__( "#undef " + sym ) )
''     __FB_UNQUOTE__( __FB_EVAL__( "#define " + sym + " " + __FB_QUOTE__( tmp ) ) )
''     #undef tmp
''     #endmacro
''
'' With a NUMERIC value every intermediate string is quote-free and it worked. With a
'' STRING value it did not, and the failure surfaced two passes later: 'x' reached MIR
'' lowering as a bare identifier and the enclosing call declined at lowercall.bas:875
'' -- 'assign( "x", "hello" )' followed by 'CU_ASSERT_EQUAL( x, "hello" )'.
''
'' MEASURED WITH 'fbc64 -pp', one step at a time:
''
''     __FB_EVAL__( "hello" )                              $"hello"
''     __FB_QUOTE__( tmp )                                 $"$""hello"""
''     __FB_EVAL__( "#define x " + that )                  $"#define x $"hello""
''
'' -- the last result holds two INNER quotes and fbc writes them RAW, unescaped. tiko
'' declined instead, on the grounds that raw quotes produce source that will not re-lex.
'' They do not re-lex as one literal, and that is fbc's behaviour too: measured, 'dim s
'' as string = __FB_EVAL__( "A" + chr(34) + "B" )' is error 3 plus warning 12 in fbc.
'' But where the result feeds '__FB_UNQUOTE__' -- which is exactly what the idiom does
'' -- the tokens it relexes into rejoin into the text UNQUOTE wanted, so declining threw
'' away the one case that has to work.
''
'' A NEWLINE IN THE RESULT STILL DECLINES. fbc emits CR/LF raw as well ('__FB_EVAL__(
'' "A" + chr(10) + "B" )' is two warning 12s and error 42), so both compilers reject
'' that program and only the diagnostic differs.
''
'' fbc, run: 'print x' below is 'print $"hello"', and the program prints 'hello'.
#macro assign( sym, expr )
#define tmp __FB_EVAL__( expr )
__FB_UNQUOTE__( __FB_EVAL__( "#undef " + sym ) )
__FB_UNQUOTE__( __FB_EVAL__( "#define " + sym + " " + __FB_QUOTE__( tmp ) ) )
#undef tmp
#endmacro

assign( "x", "hello" )

sub s1( )
    dim as string s = x
    print s
    print x
end sub

s1( )

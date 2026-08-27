'' '__FB_EVAL__( expr )' -- FOLD THE ARGUMENT AND RE-EMIT IT AS A CANONICAL LITERAL.
''
'' It was not implemented at all: the name survived the preprocessor as an ordinary
'' identifier, bound to nothing, and every statement containing one declined.
''
'' Measured against fbc, and several of the things that were written down about it were
'' wrong. There is NO '#__FB_EVAL__' directive form -- fbc answers error 17 for one -- so
'' it is an expression builtin taking exactly one argument, and the argument is
'' MACRO-EXPANDED first.
''
'' The result renders in exactly three ways:
''
''     a WIDE result                  !"\uXXXX" per character, four uppercase hex digits
''     a narrow result WITH a NUL     !"\xNN" per byte
''     any other narrow result        $"..." with the bytes VERBATIM, nothing escaped
''
'' Only the third is produced here. The other two need the literal's escapes DECODED and
'' its narrow/wide flavour known, and the preprocessor reads a RAW SOURCE SPAN: it has
'' neither. They decline, which leaves the statement exactly as unlowered as it was --
'' rather than emitting undecoded bytes that are a different string.
''
'' Two things had to be taught to the '#if' evaluator on the way, and both are what fbc
'' does: '+' and '&' over two STRINGS concatenate (they folded to 0, because both
'' operands went through the numeric field), and ADJACENT string literals are ONE string.
''
'' An integer comes out in plain DECIMAL whatever radix it was written in.
''
'' '__FB_UNQUOTE__' expands its argument too, which is what makes the corpus's own idiom
'' work -- fold a directive's text, then let it BE a directive.
#define NN 3
#define DEFZZ "#define ZZ 7"

__FB_UNQUOTE__( DEFZZ )

sub s1( )
    dim as long a = __FB_EVAL__( 1 + 2 )
    dim as long b = __FB_EVAL__( NN + 1 )
    dim as long c = __FB_EVAL__( &hFF )
    dim as longint d = __FB_EVAL__( 1 shl 40 )
    dim as long e = __FB_EVAL__( 7 \ 2 )
    dim as long f = ZZ
    dim as string s = __FB_EVAL__( "A" + "B" )
    dim as string t = __FB_EVAL__( "a" & "b" )
    dim as string u = __FB_EVAL__( "#define " "X" " 1" )
    print a, b, c, d, e, f, s, t, u
end sub

s1( )

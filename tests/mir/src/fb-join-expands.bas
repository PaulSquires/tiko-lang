'' '__FB_JOIN__' EXPANDS ITS ARGUMENTS BEFORE PASTING THEM, which is where it parts
'' company with C's '##'. Pasting the RAW text produced the identifier 'AB', which is
'' undeclared, so every join over macro arguments declined while '__FB_JOIN__( 1, 2 )'
'' beside it worked. pp/macro-join.bas is twelve of them.
''
'' MEASURED, and the case that settles it is the one the three possible rules disagree
'' about:
''
''   #define A 1 : #define B 2 : #define AB 99
''   __FB_JOIN__( A, B )   ->   12
''
'' -- 12 is expand-then-paste. 99 would be paste-then-rescan, which is what C's '##'
'' does, and 'AB' would be paste-with-no-rescan. fbc prints 12.
''
'' STRINGIFY GOES THE SAME WAY, which is also the opposite of C -- measured, and the
'' probe had to be built carefully because 'print #x' reads the '#' as a FILE NUMBER:
''
''   #define A 1 : #define B A+A
''   dim as string t = #x  over A     ->  [1]
''   ... over B                       ->  [1+1]
''   ... over 'A B'                   ->  [1 1+1]
''
'' -- FULLY expanded, not one level. tiko stringified the RAW text and gave [A], [B]
'' and [A B]. '__FB_QUOTE__( B )' is "1+1" for the same reason.
''
'' AND THE SPACING IS PART OF THE ANSWER. The first token an expansion produces takes
'' the spacing of the NAME that triggered it, not its own: a macro's body begins after
'' the space separating it from the name in the '#define', so that space rides on the
'' first body token and came out as [1+ 1] where fbc has [1+1]. '#define B A + A' is
'' [1 + 1] in both, which is what says the surviving space is the one at the USE.
''
'' ONE DIVERGENCE REMAINS AND IS NOT FIXED HERE: the '$' PREFIX SURVIVES A NESTED
'' STRINGIFY IN FBC AND NOT HERE. '#e' over 'm( 5 ) = "5"', where m is
'' '__FB_QUOTE__( a )', is '$"5" = "5"' in fbc and '"5" = "5"' here -- the inner
'' quote's raw-string marker is lost when its own text is stringified again. Stringised_
'' emits the marker correctly at one level; it is the re-lex that drops it. Both
'' spellings denote the same STRING, so nothing computes a different value from it, and
'' it only reaches diagnostic label text -- which is why it is recorded rather than
'' guessed at. Three pp goldens carry it.
#define A 1
#define B 2
#define AB 99

print __FB_JOIN__( 1, 2 )
print __FB_JOIN__( A, B )
print __FB_JOIN__( __FB_JOIN__( 1, 2 ), 3 )

'' ...and the stringify beside it, which expands the same way. Written with an
'' explicit variable rather than 'print #x', because PRINT reads a leading '#' as a
'' FILE NUMBER and the probe then measures something else entirely.
#define C   A+A
#macro SHOW(x)
    scope
        dim as string t = #x
        print "["; t; "]"
    end scope
#endmacro
SHOW( A )
SHOW( C )
SHOW( A B )

scope
    dim as string q = __FB_QUOTE__( C )
    print "["; q; "]"
end scope

'' contextual.bas -- RFC 0019 R1, R6 and R9: every name the record adds keeps today's meaning.
''
'' 'derive' is contextual (R1): it starts a derive line only at the start of a line in a TYPE
'' body with an identifier after it. 'enumname', 'enumcount', 'enumvalue' and 'hashvalue' are
'' intrinsics that a user symbol shadows (R5, R9). A hand-written ToText( ) on a type with no
'' derive line is an ordinary member (R6). This program uses all of them as plain FreeBASIC
'' names, and its output must never change, in any phase.
''
'' Plain FreeBASIC, so fbc 1.20 runs it too.

type HasDerive
    derive as long                          '' a FIELD named derive: 'derive as', not a derive line
    as long hashvalue
    as long enumcount
    declare function ToText( ) as string    '' its own ToText, no derive line
end type

function HasDerive.ToText( ) as string
    return "HasDerive(" & derive & "," & hashvalue & "," & enumcount & ")"
end function

enum Words explicit
    derive
    equal
    order
    hash
    text
end enum

function enumname( byval v as long ) as string
    return "user enumname " & v
end function

function enumcount( ) as long
    return 42
end function

dim shared as long called

sub derive( byval x as long )
    called += x
end sub

dim as HasDerive h
h.derive = 1 : h.hashvalue = 2 : h.enumcount = 3
print h.ToText( )

dim as long equal = 3
derive equal                                '' outside a type body: a paren-less call
derive( 4 )
print "called = "; called

dim as long enumvalue = 7
dim as long hashvalue = enumvalue * 2
print enumname( 5 ); " / "; enumcount( ); " / "; enumvalue; " / "; hashvalue
print "Words.text = "; Words.text; ", Words.derive = "; Words.derive

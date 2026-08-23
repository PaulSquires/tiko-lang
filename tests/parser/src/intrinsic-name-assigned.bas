'' A statement intrinsic whose name is being ASSIGNED to is not the statement -- it is a
'' variable or a field that happens to share the spelling.
''
'' fb/tuibuffer.bi has a field called 'width' and assigns it unqualified from inside a
'' method:
''
''     width = cast( ubyte, TuiCharWidth( cp ) )
''
'' which tiko-lang routed to the WIDTH statement and then failed on the '='. Nine corpus files.
''
'' Measured: fbc accepts a FIELD named 'width' and REJECTS a variable of that name
'' outright ('dim width as ubyte' is error 4, a duplicated definition), so the field case
'' is the one that matters.
''
'' No statement intrinsic takes an '=' where its first argument goes, so the token
'' settles it without the symbol table -- and what comes out is the ordinary
'' call-or-assign ambiguity, which Resolve decides.

type TuiCell
	as ubyte width
	declare sub SetChar( byval n as ubyte )
end type

sub TuiCell.SetChar( byval n as ubyte )
	width = n
end sub

dim c as TuiCell
c.SetChar( 3 )

'' The WIDTH statement is untouched.
width 80, 25

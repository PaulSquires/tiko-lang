'' '?' IS PRINT. FreeBASIC's oldest synonym, and not a keyword at all.
dim as long n = 5
dim a(0 to 1) as integer

? n
print n
? "hi"

sub t( array() as integer )
	'' A BYDESC array named without '()' -- read from ARRAY's descriptor.
	? lbound( array )
	? ubound( array )
end sub
t( a() )

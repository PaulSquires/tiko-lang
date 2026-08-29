'' A '#macro' HEADER ENDS AT THE PHYSICAL NEWLINE, whatever it ends WITH. A trailing '_'
'' is not a continuation into the body: SkipToEol stops at an EOL and a continuation
'' REMOVES the EOL, so the first body line went into the header and vanished. Every
'' expansion then produced the body MINUS its first line -- here, the assert with no
'' CASE in front of it, which is 'expected end SELECT' and then a parse desync that
'' unbound the enclosing procedure's name. fbc runs this and prints the two hits.
#macro case_T(T) _
case sizeof(T)
	print "hit"; sizeof(T)
#endmacro

dim as integer n = 2
select case n
	case_T(byte)
	case_T(short)
end select

'' A CONTINUATION INSIDE THE PARAMETER LIST is untouched -- those tokens are already
'' consumed by the time the header is skipped, and fbc accepts this spelling.
#macro m2( a, _
           b )
	print a; b
#endmacro
m2( 1, 2 )

'' ...and the one-line body after a trailing '_', which prints under fbc and so cannot
'' have been swallowed into the header there either.
#macro m3( a ) _
	print a
#endmacro
m3( 5 )

'' A STRING OPERAND TO A C* CONVERSION IS PARSED, NOT COERCED. There was no case for one
'' at all, so 'm = cuint( x )' over a string LOADED THE DESCRIPTOR'S FIRST EIGHT BYTES --
'' the char* data pointer -- and zero-extended THAT into the integer. A heap address
'' where 37 belonged, verifier clean, 0 statements not lowered. A string TEMPORARY --
'' 'cuint( left( x, 1 ) )' -- has no value to load, so that one DECLINED instead: the
'' same hole showing on two sides. tests/mir/prop-indexed's golden had recorded the
'' first, over 'cint( index )' with a string index.
''
'' The entry point is chosen by the RESULT'S width and signedness, not by the
'' intrinsic's name. Measured, all thirteen:
''
''     cbyte/cubyte/cshort/cushort/clng/culng   fb_VALINT  / fb_VALUINT
''     cint/clngint  and their unsigned twins   fb_VALLNG  / fb_VALULNG
''     csng/cdbl                                fb_VAL
dim as string x = "37"
print cbyte(x); cubyte(x); cshort(x); cushort(x); clng(x); culng(x)
print cint(x); cuint(x); clngint(x); culngint(x); csng(x); cdbl(x)
print cuint( left( x, 1 ) )
print val( x )

'' 'cast( string, s )' CONVERTS NOTHING. Measured, fbc emits the ordinary byval-string
'' temporary and nothing else. Left in place it looked like a conversion term and took
'' the transcoding path, which has nothing to convert; four shapes declined. The target
'' type comes from the TYPEREF, because Check computes none for the call itself.
sub takes( byval s as string )
	print s
end sub

sub caller_( byref s as const string )
	takes( cast(string, s) )
end sub

dim as string s = "hi"
takes( cast(string, s) )
dim as string t = cast(string, s)
print t
print cast(string, s)
caller_( s )

dim cx as const string = "test"
dim cy as string
cy = cast(string, cx)
print cy

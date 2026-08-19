'' BASIC's result assignment written with the KEYWORD. Measured against fbc:
''
''   function = expr      legal
''   operator = expr      legal
''   property = expr      legal
''   function += 1        fbc error 61 -- assignment only, never compound
''   print function       fbc error 6  -- a WRITE-only target
''   function = inside a SUB   fbc error 17
''
'' The '=' is the whole disambiguator. Without it 'function' starts a nested procedure
'' definition, which is why these files reported 'expected end FUNCTION' at EOF.

function F( ) as integer
	function = 7
	if 1 then
		scope
			function = 8
		end scope
	end if
end function

'' The name form, which resolves to the same thing.
function G( ) as integer
	G = 9
end function

type T
	as integer x
	declare operator cast( ) as integer
	declare property v( ) as integer
end type

operator T.cast( ) as integer
	operator = this.x
end operator

property T.v( ) as integer
	property = this.x
end property

print F( ), G( )

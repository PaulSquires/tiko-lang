'' 'T.foo( )' where T is the TYPE, not a variable of it: a STATIC member, qualified by
'' its type exactly as a namespace member is by its namespace. The base being the UDT
'' SYMBOL is what tells this from 'obj.foo( )', whose base is a VARIABLE.
''
'' It worked in EXPRESSION position already -- 'print T.bar( 2 )' -- and failed as a
'' STATEMENT, where the ambiguous-statement resolver took the head symbol, found a type,
'' and reported "'t' is a type, not a procedure". 27 corpus files, led by
'' 'DateTime.TryParseIso( s, r )'.
''
'' Bound ONLY when the member is actually static. fbc rejects a non-static one --
'' error 214, "Member isn't static" -- and binding it would lower a member call with NO
'' RECEIVER, silently. Leaving it unbound keeps the existing diagnostic: the wrong
'' message for the right outcome.
''
'' The emitted name is measured against fbc's own C: _ZN1T3FOOEv, no receiver parameter.

type T
	i as integer
	declare static sub foo( )
	declare static function bar( byval n as long ) as long
end type

sub T.foo( )
end sub

function T.bar( byval n as long ) as long
	return n + 1
end function

T.foo( )
print T.bar( 2 )

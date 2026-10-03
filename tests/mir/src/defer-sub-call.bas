'' A PROCEDURE, AN ARRAY AND A UDT NAMED 'defer' -- see defer-sub-call.test.
type U
	as long field_
end type

'' The array and the UDT come BEFORE 'sub defer': a local named like a procedure declared
'' earlier in the same scope is fbc's error 4 (TKO0945), and one declared later is not.
sub ArrayNamedDefer( )
	dim as long defer( 0 to 2 )
	defer( 1 ) = 3              '' an element: '(' begins no statement
	print defer( 1 )
end sub

sub UdtNamedDefer( )
	dim as U defer
	defer.field_ = 4            '' a member: '.' begins no statement
	print defer.field_
end sub

sub defer( byval n as long )
	print "called"; n
end sub

sub Calls( )
	defer( 5 )                  '' a call: '(' begins no statement
	defer 6                     '' a call: a literal begins no statement
	defer -7                    '' a call: '-' begins no statement
	defer print "deferred"      '' THE KEYWORD: a statement follows
	print "body"
end sub

Calls( )
ArrayNamedDefer( )
UdtNamedDefer( )

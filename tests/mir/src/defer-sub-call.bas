'' A PROCEDURE, AN ARRAY AND A UDT NAMED 'defer' -- see defer-sub-call.test.
sub defer( byval n as long )
	print "called"; n
end sub

type U
	as long field_
end type

sub Calls( )
	defer( 5 )                  '' a call: '(' begins no statement
	defer 6                     '' a call: a literal begins no statement
	defer -7                    '' a call: '-' begins no statement
	defer print "deferred"      '' THE KEYWORD: a statement follows
	print "body"
end sub

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

Calls( )
ArrayNamedDefer( )
UdtNamedDefer( )

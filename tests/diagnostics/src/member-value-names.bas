type B extends object
	declare sub inherited( )
end type
sub B.inherited( )
end sub

type T extends B
	fld as long
	static as long stat
	const K1 = 3
	enum E1
		e1a
	end enum
	declare sub foo( byval foo as long )                 '' a declare: accepted
	declare sub m1( byval bar as long )
	declare sub bar( )
	declare function f2( byval v as long ) as long
	declare property P( byval p as long )
	declare property Q( byval i as long, byval v as long )
	declare sub ok1( byval fld as long, byval stat as long, byval E1 as long, byval inherited as long )
	declare sub m3( byval K1 as long )
end type
dim as long T.stat

sub T.foo( byval foo as long )                           '' REFUSED: its own name
end sub
sub T.m1( byval BAR as long )                            '' REFUSED: another method, any case
end sub
sub T.bar( )
	dim as long m1                                       '' REFUSED: a dim
	scope
		dim as long f2                                   '' REFUSED: a dim in a SCOPE
	end scope
	for P as long = 1 to 2                               '' REFUSED: a 'for' variable
	next
end sub
function T.f2( byval v as long ) as long
	return v
end function
property T.P( byval p as long )                          '' REFUSED: the property's own name
end property
property T.Q( byval i as long, byval v as long )
	dim as long q                                        '' REFUSED
end property
sub T.ok1( byval fld as long, byval stat as long, byval E1 as long, byval inherited as long )
	dim as long x = fld + stat
end sub
sub T.m3( byval K1 as long )                             '' REFUSED: a const of T
end sub
sub other( byval bar as long, byval m1 as long )         '' not a method of T: accepted
end sub

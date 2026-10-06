'' a body of a const method links -- it mangles with K like its declaration
type foo
	as integer x
	declare const sub bar( )
end type
sub foo.bar( )
	print x
end sub
dim as foo baz = (3)
baz.bar( )

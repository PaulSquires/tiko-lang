'' A PROPERTY OVERLOAD SET'S HEAD MAY BE THE SETTER, and a setter has no result type --
'' so 'f.bar' READ came out untyped and the statement declined. It is ORDER-DEPENDENT
'' and nothing else: declaring the getter first made the same file lower. fbc builds it
'' either way and prints hi.
type foo
	as string s
	declare property bar( byref index as string )
	declare property bar( ) as string
end type

property foo.bar( byref index as string )
	this.s = index
end property

property foo.bar( ) as string
	return this.s
end property

dim as foo f
f.s = "hi"
print f.bar

'' The other order, which always worked.
type baz
	as string s
	declare property qux( ) as string
	declare property qux( byref index as string )
end type

property baz.qux( ) as string
	return this.s
end property

property baz.qux( byref index as string )
	this.s = index
end property

dim as baz b
b.s = "ho"
print b.qux

'' ...AND ONLY A PROPERTY. An overloaded METHOD may pair a SUB with a FUNCTION, and
'' walking past the sub because it has no result type bound the ZERO-argument 'g.bar'
'' to the one-argument function, which then had no argument to pass. fbc calls
'' '_ZN3FOO3BAREv( &F$0 )' and prints 'sub'.
type meth
	as integer pad
	declare sub bar( )
	declare function bar( byval i as integer ) as integer
end type

sub meth.bar( )
	print "sub"
end sub

function meth.bar( byval i as integer ) as integer
	print "fn"; i
	return i
end function

dim as meth g
g.bar
g.bar( 3 )

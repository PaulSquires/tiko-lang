'' A value inside a GENERIC procedure may take the name of a type with members. See
'' tests/codegen/generic-local-class-name-run.test.
namespace N
type Sink extends object
	declare abstract sub W( )
	declare virtual destructor( )
end type
private destructor Sink( )
end destructor

'' fb/select.bi's shape: a local, in a namespace that declares the type
function Drop( of T )( byval v as T ) as boolean
	dim as T ptr sink = new T
	*sink = v
	dim as boolean r = (*sink = v)
	delete sink
	return r
end function

'' never instantiated
function Unused( of T )( byval v as T ) as boolean
	dim as T sink = v
	return true
end function
end namespace

using N

'' a parameter, and a local in a nested block
function Param( of T )( byval sink as T ) as boolean
	return sink = 5
end function

sub Nested( of T )( byval v as T )
	if v then
		dim as T sink = v
		print "nested"; sink
	end if
end sub

print "drop "; N.Drop( 7 )
print "param "; Param( 5 )
Nested( 3 )

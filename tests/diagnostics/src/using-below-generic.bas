namespace ns
  function Foo( ) as long
    return 1
  end function
end namespace
type Box( of T )
  as T v
end type
print Foo( )
using ns
print Foo( )
dim as Box( of long ) b
b.v = Foo( )

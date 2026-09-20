'' 'a.NoSuchThing( )' OVER AN INSTANTIATION -- fbc error 18, "Element not defined".
''
'' The late sweep that answers this for a plain UDT skipped any type whose name holds a
'' '<', which is every instantiation there is: the structural key is 'BOX<6>'. So the
'' call passed Check unbound, lowered to nothing, and printed an empty line -- as a
'' local and as a field alike -- while fbc refused the program.
''
'' The name in the message is the GENERIC's, not the key: 'BOX<6>' is not what anyone
'' wrote.

type Box( of T )
    as T value
    declare function Get( ) as T
end type

function Box( of T ).Get( ) as T
    return this.value
end function

type Holder
    b as Box( of long )
end type

sub P( )
    dim as Box( of long ) a
    a.value = 1
    print a.Get( )
    print a.NoSuchThing( )

    dim as Holder h
    h.b.value = 2
    print h.b.Get( )
    print h.b.NoSuchThing( )
end sub

'' AND THE MEMBER THAT IS DECLARED BUT NOT DEFINED HERE. InstantiateMembers_ re-parses
'' only the definitions this unit can see, so 'Later_' has no symbol in the
'' instantiation's scope -- and it is still a member, so it must NOT be reported. This
'' is the false positive the check is guarded against.
type Decl_( of T )
    as T v
    declare function Later_( ) as T
end type

sub Q( )
    dim as Decl_( of long ) d
    d.v = 3
    print d.Later_( )
end sub

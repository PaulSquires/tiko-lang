'' A STRUCTOR OR PROPERTY OF A NAMESPACED TYPE, defined at module level through the
'' namespace, is accepted when the type DECLARED it and is fbc error 168 ("Parent is not a
'' class or UDT") when it did not: 'constructor ns.Bare( )' over a type with no
'' constructor -- and a DESTRUCTOR and a PROPERTY measure the same way in isolation, which
'' is what the three reports below are; fbc stops after the first one for a given type.
''
'' A REDIM OF A MEMBER THE NAMESPACE ALREADY HAS is NOT one of these. 'redim shared
'' ns.arr( 4 to 5 ) as integer' over the 'dim shared arr( )' inside ns adds no name and fbc
'' accepts it -- this file's own last line, which an earlier version of this test wrongly
'' expected to be refused. Only a redim naming a member the namespace does not have is.
namespace ns
    type Declared
        dummy as integer
        declare constructor( )
        declare property foo( ) as integer
    end type
    type Bare
        dummy as integer
    end type
    dim shared arr() as integer
end namespace

constructor ns.Declared( )
end constructor
property ns.Declared.foo( ) as integer
    return 0
end property

constructor ns.Bare( )
end constructor
destructor ns.Bare( )
end destructor
property ns.Bare.foo( ) as integer
    return 0
end property
redim shared ns.arr(4 to 5) as integer

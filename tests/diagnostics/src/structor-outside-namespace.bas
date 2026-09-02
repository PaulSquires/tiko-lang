'' A STRUCTOR OR PROPERTY OF A NAMESPACED TYPE, defined at module level through the
'' namespace, is accepted when the type DECLARED it and is fbc error 168 ("Parent is not a
'' class or UDT") when it did not: 'constructor ns.Bare( )' over a type with no
'' constructor. And 'redim shared ns.arr( ) as integer' from outside is error 158 like any
'' other outside declaration.
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

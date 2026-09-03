'' A STRUCTOR OR PROPERTY OF A NAMESPACED TYPE, defined at module level through the
'' namespace, is accepted when the type DECLARED it and is fbc error 168 ("Parent is not a
'' class or UDT") when it did not: 'constructor ns.Bare( )' over a type with no
'' constructor -- and a DESTRUCTOR and a PROPERTY measure the same way in isolation, which
'' is what the three reports below are; fbc stops after the first one for a given type.
''
'' A REDIM OF A MEMBER THE NAMESPACE ALREADY HAS is NOT one of these -- but only without
'' SHARED. Measured in ISOLATION, which matters here:
''
''     redim ns.arr( 4 to 5 ) as integer          accepted -- it re-dimensions
''     redim SHARED ns.arr( 4 to 5 ) as integer   error 158 -- SHARED re-declares
''
'' An earlier version of this test read the second line as accepted, because it measured it
'' INSIDE THIS FILE and fbc had already stopped at the 168 above: **fbc's first error can
'' mask every later one, so a line measured inside a file that already fails is not
'' measured at all.** The last line below is the SHARED form and is refused.
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

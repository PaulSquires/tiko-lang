'' 'P( 3 ).v' -- A MEMBER ON A CONSTRUCTOR TEMPORARY.
''
'' A member on a FUNCTION's returned temporary already worked; the same member on a
'' CONSTRUCTOR temporary declined, and the two differ only in what the callee is bound
'' to. Two things were missing and both are about the CALL, not the member:
''
''   'P( 3 )' IS AN OBJECT OF TYPE P. The callee binds to the UDT rather than to a
''   procedure, so overload resolution had nothing to work with and the expression came
''   out UNTYPED -- and an untyped base has no field offset to look up.
''
''   AND IT NEEDS STORAGE. The value form loads the aggregate; a member access needs
''   the temporary it was built in, so the address path builds one and constructs into
''   it.
''
'' fb/chrono.bi writes most of its assertions this way --
'' 'DateTime( 2025, 1, 31 ).AddMonths( 0 ).Ticks' -- and chrono/calendar.bas went from
'' 11 declines to none.
type P
    as long v
    '' A DEFAULT CONSTRUCTOR TOO: declaring any constructor removes the implicit one,
    '' and 'dim as P r' inside Twice needs it. fbc's error 183 says so.
    declare constructor( )
    declare constructor( byval n as long )
    declare function Twice( ) as P
    declare property Half( ) as long
end type

constructor P( )
    this.v = 0
end constructor

constructor P( byval n as long )
    this.v = n
end constructor

function P.Twice( ) as P
    dim as P r
    r.v = this.v * 2
    return r
end function

property P.Half( ) as long
    return this.v \ 2
end property

'' A FIELD, a METHOD, a PROPERTY, and a CHAIN of two temporaries.
dim as long a = P( 3 ).v
dim as long b = P( 3 ).Twice( ).v
dim as long c = P( 4 ).Half
dim as long d = P( 5 ).Twice( ).Twice( ).v

'' A CONSTRUCTOR CALL IS NOT A COPY SOURCE. Now that the initialiser has the type P,
'' this reached the copy path, which built a TEMPORARY, constructed into that, and then
'' copy-constructed 'e' from it. fbc constructs 'e' directly.
dim as P e = P( 6 )
print a, b, c, d, e.v

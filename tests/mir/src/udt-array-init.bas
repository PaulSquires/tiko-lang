'' A BRACE INITIALISER OVER AN ARRAY OF UDT, which was dropped whole.
''
'' An element of UDT type lowers as an AGGREGATE, and the array-initialiser path
'' rejected aggregates outright -- so 'dim as Decimal d(0 to 4) = { D( "-1000" ), ... }'
'' allocated the array, initialised none of it, and every element read back as whatever
'' the stack held. It is the whole of finance/flows.bas's twenty-two declines.
''
'' Two rows, and they differ by more than emphasis -- measured:
''
''   POD              *(struct $1U*)A$0 = vr$2;
''   with structors   _ZN1CC1ERKS_( (struct $1C*)A$0, vr$3 );
''
'' -- a COPY CONSTRUCTOR for the second, and NO default construction before it: fbc
'' constructs each element exactly once, from its initialiser. A type holding a string
'' is what notices, because an aggregate store there would leave two objects owning one
'' buffer and both would release it.
type U
    as long x
end type

type C
    declare constructor( )
    declare constructor( byref as const C )
    declare destructor( )
    as string s
end type
constructor C( ) : end constructor
constructor C( byref o as const C ) : this.s = o.s : end constructor
destructor C( ) : end destructor

function mkU( byval v as long ) as U
    dim r as U
    r.x = v
    return r
end function

function mkC( byval v as long ) as C
    dim r as C
    r.s = str( v )
    return r
end function

scope
    dim as U a(0 to 1) = { mkU( 1 ), mkU( 2 ) }
    print a(0).x, a(1).x
end scope

scope
    dim as C b(0 to 1) = { mkC( 1 ), mkC( 2 ) }
    print b(0).s, b(1).s
end scope

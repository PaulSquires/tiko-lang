'' CONST IS TRANSPARENT TO A FIELD ACCESS, and it was transparent to nothing.
''
'' 'byref x as const T' gives x a QUALIFIED type. The UDT store is keyed by the
'' UNQUALIFIED one, so 'x.n' looked its field up under a type the store has never heard
'' of, found nothing, and declined -- while the identical line without the const
'' worked. EVERY COPY CONSTRUCTOR IN THE CORPUS is written 'byref x as const T'.
''
'' Two more places had to learn the same thing, and the second is a type-system bug
'' rather than a missing case: TypeContext.Qualify and .Unqualify identified a UDT by
'' KIND, INNER, FLAGS and RANK -- none of which tells two UDTs apart -- so qualifying
'' one returned whichever UDT sat first in the table, or manufactured a NAMELESS one.
'' Nothing said so: the caller got a type back, asked it for a field, and found none.
type Rec
    as long n
    declare constructor( )
    declare constructor( byref x as const Rec )
end type

constructor Rec( )
    n = 1
end constructor

'' The copy constructor: an implicit member on the left, a const reference on the right.
constructor Rec( byref x as const Rec )
    n = x.n + 1
end constructor

sub ByrefConst( byref x as const Rec )
    dim as long v = x.n
    print v
end sub

sub PtrToConst( byval p as const Rec ptr )
    dim as long v = p->n
    print v
end sub

'' The unqualified spellings beside them, which already worked and must keep working.
sub ByrefPlain( byref x as Rec )
    dim as long v = x.n
    print v
end sub

sub PtrPlain( byval p as Rec ptr )
    dim as long v = p->n
    print v
end sub

dim a as Rec
dim b as Rec = a
ByrefConst( a )
PtrToConst( @a )
ByrefPlain( a )
PtrPlain( @a )
print b.n

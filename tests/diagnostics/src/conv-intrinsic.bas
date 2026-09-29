'' A conversion intrinsic over a pointer or a UDT it has no cast for -- fbc's error 20 on the
'' refused lines (64-bit).
type foo
    declare operator cast( ) as single
    dummy as integer
end type
operator foo.cast( ) as single
    return 1
end operator
dim f as foo
dim as any ptr p
print cint( f )                                '' 20: only 'as single'
print clng( p )                                '' 20
print cdbl( p )                                '' 20
print csng( f )                                '' fine
print cint( p ), clngint( p )                  '' fine

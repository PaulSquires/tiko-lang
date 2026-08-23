'' AN OPERATOR'S NAME CAN BE A TOKEN RATHER THAN A WORD, and in a GENERIC the qualifier
'' comes after the type arguments -- 'operator Arr( of T ).[]' -- which is a second
'' qualifier loop in the parser. Only the first one read an operator's punctuation, so
'' the generic form lost its NAME, its PARAMETER LIST and its RETURN TYPE: fbc's own
'' Array( of T ) subscript operator instantiated as a no-argument sub returning nothing.
namespace FB
type Arr( of T )
    items(any) as T
    declare operator [] ( byval i as long ) byref as T
    declare sub Reserve( byval n as long )
end type

operator Arr( of T ).[] ( byval i as long ) byref as T
    return this.items( i )
end operator

'' NOT ONLY A LOCAL, exactly as ERASE is not: 'redim preserve this.items( ... )' names
'' a FIELD, and so does the unqualified form inside a method -- the parser records both
'' as the bare name. Requiring a local slot declined every container that grows its own
'' storage, which is what a container IS.
sub Arr( of T ).Reserve( byval n as long )
    redim preserve this.items( 0 to n-1 )
    redim items( 0 to n-1 )
    erase this.items
end sub
end namespace

dim v as FB.Arr( of long )
v.Reserve( 4 )

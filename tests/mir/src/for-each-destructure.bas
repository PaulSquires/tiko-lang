'' 'for each (k, v) in c' -- THE DESTRUCTURING FORM, over an RFC-0002 collection whose
'' Value( ) yields a tuple.
''
'' It is a PARSE REWRITE and nothing else: the loop binds one hidden element, '$fe<n>',
'' exactly as the ordinary form binds one name, and a 'var' at the top of the body
'' declares each written name from one field of it --
''
''     for each $fe1 in c : var k = $fe1._1, v = $fe1._2 : BODY : next
''
'' -- so every later pass sees a shape it already handles completely. Each name gets its
'' OWN element's type (k is a long, v is a STRING), the element is evaluated once
'' however many names are on the left, and the names are declared INSIDE the body, which
'' is what gives them per-iteration lifetime.
''
'' 'exit for' and 'continue for' still land where the ordinary form puts them, because
'' the loop they belong to is the ordinary one.
type PairIter
    as long i
    declare function IsValid( ) as boolean
    declare function Value( ) as (long, string)
    declare sub MoveNext( )
end type

type PairColl
    as long n
    declare function GetIterator( ) as PairIter
end type

function PairIter.IsValid( ) as boolean
    return this.i < 3
end function

function PairIter.Value( ) as (long, string)
    return ( this.i, "v" & this.i )
end function

sub PairIter.MoveNext( )
    this.i += 1
end sub

function PairColl.GetIterator( ) as PairIter
    dim it as PairIter
    it.i = 0
    return it
end function

sub s1( )
    dim c as PairColl
    dim keys as long = 0
    dim vals as string = ""

    for each (k, v) in c
        keys += k
        vals &= v
    next

    dim seen as long = 0
    for each (k2, v2) in c
        if k2 = 0 then continue for
        if k2 = 2 then exit for
        seen += 1
    next

    print keys, vals, seen
end sub

s1( )

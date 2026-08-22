'' FOR EACH over a USER COLLECTION -- the RFC-0002 iterator protocol.
''
'' STRUCTURAL, not nominal: a collection is anything with GetIterator( ), and an
'' iterator is anything with IsValid( ), Value( ) and MoveNext( ). Nothing is declared
'' to implement anything.
''
'' The desugaring is the one fbc emits:
''
''     __it = c.GetIterator( )
''     goto test
''   body:  x = __it.Value( ) : BODY
''   cont:  __it.MoveNext( )              <-- CONTINUE FOR lands here
''   test:  if __it.IsValid( ) goto body
''   exit:
''
'' TEST LAST, reached by a jump over the body, so an empty collection runs the body no
'' times and MoveNext is not called before the first element.

type Iter
    i as long
    n as long
    declare function IsValid( ) as boolean
    declare function Value( ) as long
    declare sub MoveNext( )
end type

function Iter.IsValid( ) as boolean
    return i < n
end function

function Iter.Value( ) as long
    return i * 10
end function

sub Iter.MoveNext( )
    i += 1
end sub

type Coll
    n as long
    declare function GetIterator( ) as Iter
end type

function Coll.GetIterator( ) as Iter
    dim as Iter t
    t.n = n
    return t
end function

sub P( )
    dim c as Coll
    dim as long total

    for each x in c
        total += x
    next

    '' EXIT FOR and CONTINUE FOR need nothing new: this shares the FOR stack entry, and
    '' CONTINUE lands on the MoveNext block rather than the test, so it advances the
    '' iterator instead of spinning on the same element.
    for each y in c
        if y = 20 then continue for
        if y = 40 then exit for
        total += y
    next
end sub

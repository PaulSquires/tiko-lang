'' A GENERIC IN A NAMESPACE, and a generic whose member returns another generic.
''
'' Every container in the runtime headers lives in a namespace, and none of them
'' instantiated. Four separate bugs, each of which hid the next:
''
''   - THE GENERIC WAS LOOKED UP UNQUALIFIED, from the use site's scope. 'FB.Array( of
''     long )' found nothing, instantiated nothing, and bound to the GENERIC. The lookup
''     is now done once, by the caller, and the resolved symbol passed in.
''   - THE CACHE KEY CAME FROM THE SPELLING. 'N.It( of long )' at a use site and
''     'It( of long )' written inside N are the same type and produced TWO -- so a
''     member returning its own sibling returned something no caller could name.
''   - THE INSTANTIATION'S SCOPE HAD SCOPE_GLOBAL AS ITS PARENT, so a member body could
''     not see the generic's siblings: 'function Coll( of T ).A( ) as Plain' resolved to
''     nothing and the member came out with NO RETURN TYPE, which reads at every call
''     site as 'call void'. It now lives in the generic's own scope -- which also gives
''     its mangled name the namespace from the scope chain, like any other member's, and
''     makes two same-named generics in different namespaces distinct for free.
''   - THE FRESH MEMBER NODE KEPT PF_GENERIC_PROC. Every out-of-line member of a generic
''     is spelled 'function Array( of T ).Count( )', so the parser marks it a template
''     and lowering skips it: the instantiated bodies were declared, called, and never
''     emitted.

namespace N

type Plain
    v as long
end type

type It( of T )
    idx as long
    declare function IsValid( ) as boolean
    declare function Value( ) byref as T
    declare sub MoveNext( )
end type

type Coll( of T )
    n as long
    declare function GetIterator( ) as It( of T )
    declare function A( ) as Plain
end type

function It( of T ).IsValid( ) as boolean
    return this.idx < 4
end function

function It( of T ).Value( ) byref as T
    static as T z
    return z
end function

sub It( of T ).MoveNext( )
    this.idx += 1
end sub

'' RETURNS ITS OWN SIBLING, unqualified, from inside the namespace both live in.
function Coll( of T ).GetIterator( ) as It( of T )
    dim it as It( of T )
    it.idx = 0
    return it
end function

'' RETURNS A PLAIN TYPE declared beside the generic -- the case that proved the scope
'' parent was wrong, because it needs no substitution at all and still failed.
function Coll( of T ).A( ) as Plain
    dim as Plain p
    return p
end function

end namespace

sub P( )
    dim as N.Coll( of long ) c
    '' QUALIFIED HERE, unqualified inside N: the same instantiation either way.
    dim as N.It( of long ) i = c.GetIterator( )
    dim as N.Plain q = c.A( )
end sub

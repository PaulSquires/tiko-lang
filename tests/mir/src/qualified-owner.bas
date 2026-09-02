'' A QUALIFIED OWNER, in both places one can appear.
''
'' A member DEFINED OUTSIDE its namespace opens its body under the wrong scope if the
'' owner is read as the component BEFORE the last one. 'constructor ns.UDT( )' has
'' ownerName 'ns' and name 'UDT': the type is UDT and the namespace is only how to
'' reach it. An ordinary member is the other way round -- 'sub Widget.Draw( )' has
'' owner Widget and name Draw.
''
'' Getting it wrong opened the constructor body under the NAMESPACE, so no enclosing
'' type scope existed, 'this' stayed untyped, and its receiver store went into a void
'' slot.

namespace a.b.c
    type Deep
        i as integer
    end type
end namespace

namespace ns
    type UDT
        dummy as integer
        declare sub Touch( )
        '' DECLARED HERE: fbc refuses 'constructor ns.UDT( )' for a type that never
        '' declared one (error 158), so the definitions below need these.
        declare constructor( )
        declare destructor( )
    end type
end namespace

constructor ns.UDT( )
end constructor

destructor ns.UDT( )
end destructor

sub ns.UDT.Touch( )
end sub

'' A TYPE REFERENCE may be a path too. Only the FIRST component is visible from here;
'' each later one is looked up inside what the previous opened. Keeping only the last
'' made 'a.b.c.Deep' resolve as if it were 'c.Deep', which is not visible at all, so
'' the variable's slot lowered to VOID.
dim as a.b.c.Deep d
dim as ns.UDT u

'' AN UNQUALIFIED FIELD inside a method is 'this->field'. It used to get a LOCAL SLOT
'' -- a fresh variable shadowing the field for the whole procedure -- so the two
'' assignments below wrote to DIFFERENT PLACES and the read came back uninitialised.
type Two
    v as integer
    declare sub Both( )
    declare function Get( ) as integer
end type

sub Two.Both( )
    v = 1
    this.v = 2
end sub

function Two.Get( ) as integer
    return v
end function

'' A THREE-COMPONENT qualified name. The proc-name loop kept only the LAST TWO
'' components, so 'constructor a.b.UDT( )' arrived with owner 'b' and no way to reach
'' it -- 'this' stayed untyped AND the procedure mangled as plain 'UDT', which links
'' wrong rather than merely typing wrong.
namespace outer
    namespace inner
        type Deep2
            k as integer
            declare constructor( )
            declare sub Poke( )
        end type
    end namespace
end namespace

constructor outer.inner.Deep2( )
    k = 4
end constructor

sub outer.inner.Deep2.Poke( )
    k = 5
end sub

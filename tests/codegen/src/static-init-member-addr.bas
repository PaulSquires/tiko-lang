' Static initialisers holding procedure ADDRESSES named through a type -- '@Dog.speak',
' and 'cast( any ptr, @C.Get )' -- in a static member array and a static local UDT.
type Dog
    as integer dummy
    declare static function speak() as string
    declare function name_() as string
    static as any ptr tbl(0 to 1)
end type
static function Dog.speak() as string
    return "woof"
end function
function Dog.name_() as string
    return "rex"
end function
static as any ptr Dog.tbl(0 to 1) = {@Dog.speak, @Dog.name_}
type VT
    as any ptr f1
end type
type C
    as integer n
    declare constructor()
    declare function Get() as integer
end type
function C.Get() as integer
    return n
end function
constructor C()
    static as VT vtbl = (cast(any ptr, @C.Get))
    n = iif(vtbl.f1 = cast(any ptr, @C.Get), 5, -1)
end constructor
dim as C x
dim as function() as string sp = Dog.tbl(0)
print sp(); (Dog.tbl(1) = @Dog.name_); x.n

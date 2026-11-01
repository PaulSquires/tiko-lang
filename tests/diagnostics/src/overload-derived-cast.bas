' A derived wrapper whose own cast hides its base's, passed to an overload set that only the
' hidden cast would reach.
type IG extends object
    declare virtual function id () as long
end type
function IG.id () as long : return 1 : end function
type IE extends IG
    declare virtual function id () as long override
end type
function IE.id () as long : return 2 : end function

type CG
    pg as IG ptr
    declare operator cast () as IG ptr
end type
operator CG.cast () as IG ptr : return pg : end operator
type CE extends CG
    pe as IE ptr
    declare operator cast () as IE ptr
end type
operator CE.cast () as IE ptr : return pe : end operator

function Compare overload (byval g as IG ptr, byval m as long) as long
    return g->id( ) + m
end function
function Compare overload (byval g as IG ptr, byval m as long ptr) as long
    return 100
end function

dim w as CE
dim b as CG
print Compare( b, 10 )
print Compare( w, 10 )

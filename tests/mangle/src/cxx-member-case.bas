'' Members of an extern "C++" type keep their written case; so does a namespaced procedure in extern "C".
extern "C++"
    type Widget
        v as long
        declare sub doThing( byval a as long )
        declare function getValue( ) as long
    end type
    namespace lib1
        type Gizmo
            w as long
            declare sub spin( byval r as double )
        end type
    end namespace
end extern
extern "C"
    namespace cns
        declare sub cfun( byval a as long )
    end namespace
end extern
sub Widget.doThing( byval a as long )
end sub
function Widget.getValue( ) as long
    return v
end function
sub lib1.Gizmo.spin( byval r as double )
end sub
sub cns.cfun( byval a as long )
end sub

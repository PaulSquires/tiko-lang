'' An anonymous UNION or TYPE inside an aggregate: its members belong to the
'' ENCLOSING type, which is the whole point of writing one.
type T
    union
        type
            as boolean b0 : 1
            as boolean b1 : 1
        end type
        as long w
    end union
    as long tail
end type

type Named
    union U
        as long a
        as byte b
    end union
end type

sub F( )
end sub

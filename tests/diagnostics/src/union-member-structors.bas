'' WHAT A UNION CANNOT HOLD -- fbc's errors 161, 162, 163 and 164 on the refused lines.
'' The rest are fine.
type DOnly
    i as long
    declare destructor( )
end type
destructor DOnly( )
end destructor
type FInit
    i as long = 3
end type
type HasStr
    s as string
end type
type HasArr
    a( any ) as long
end type
type Obj extends object
    i as long
end type
type Nest
    h as HasStr
end type
type Plain
    i as long
end type
union U
    s as string                     '' 161
    us as ustring                   '' 161
    sa( 2 ) as string               '' 161
    da( any ) as long               '' 162
    f as FInit                      '' 163
    h as HasStr                     '' 163
    a as HasArr                     '' 163
    o as Obj                        '' 163
    nn as Nest                      '' 163
    ha( 1 ) as HasStr               '' 163
    d as DOnly                      '' 164
    p as Plain
    z as zstring * 8
    w as wstring * 8
    sp as string ptr
    hp as HasStr ptr
end union
type T
    union
        type
            h2 as HasStr            '' 163
            k as long
        end type
        s2 as string                '' 161
        n as long
    end union
    s3 as string
end type
'' A generic union and a union local to a generic procedure, judged per instantiation.
union Pun( of X )
    v as X                          '' 161 for Pun( of string )
    b as byte
end union
dim as Pun( of long ) pl
dim as Pun( of string ) ps
function Probe( of X )( byref x as X ) as long
    type L
        union
            v as X                  '' 163 for Probe( of HasArr )
            b as byte
        end union
    end type
    dim as L l
    return sizeof( l )
end function
dim as HasArr harr
print Probe( 3 ), Probe( harr )

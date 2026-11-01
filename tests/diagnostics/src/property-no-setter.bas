' Assigning a property with no setter of that shape.
type TT
    m as long
    declare property G () as long
    declare property Q (byval i as long, byval v as long)
    declare property S (byval v as long)
    declare property IG (byval i as long) as long
    declare property Flag () as boolean
    declare property Flag (byval v as boolean) as long
end type
property TT.G () as long : return m : end property
property TT.Q (byval i as long, byval v as long) : m = i + v : end property
property TT.S (byval v as long) : m = v : end property
property TT.IG (byval i as long) as long : return m + i : end property
property TT.Flag () as boolean : return m <> 0 : end property
property TT.Flag (byval v as boolean) as long : return 1 : end property

sub t (byref x as TT, byval p as TT ptr)
    x.G = 5
    x.Q = 5
    x.S( 1 ) = 5
    x.IG( 1 ) = 5
    x.Q( 1, 2 ) = 5
    x.Flag = true
    print x.Flag
    p->G = 5
    with x
        .G = 5
    end with
    ' fine: a setter of the shape
    x.S = 1
    x.Q( 1 ) = 2
end sub

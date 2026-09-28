'' AN ANONYMOUS UNION DIRECTLY IN A UNION, OR TYPE DIRECTLY IN A TYPE -- fbc's error 17 on
'' lines 7, 16, 23 and 35 (fbc-modern 1.20), and its 19 at each one's 'end'. They must
'' alternate. tiko laid each out. The TYPE from line 40 alternates at every level, and a
'' NAMED nested type is fbc's too; both are accepted.
union U1
    a as long
    union
        x as long
        y as short
    end union
end union
union U2
    a as long
    type
        x as long
        type
            p as short
        end type
    end type
end union
type T2
    a as long
    type
        x as long
        y as long
    end type
end type
type T3
    a as long
    union
        x as long
        type
            p as short
            q as short
            type
                r as long
            end type
        end type
    end union
end type
type T4
    a as long
    union
        x as long
        type
            p as short
            union
                q as long
                r as short
            end union
        end type
    end union
    type N4
        z as long
    end type
end type
print "end"

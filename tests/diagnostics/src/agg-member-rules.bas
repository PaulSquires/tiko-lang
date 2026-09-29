'' A dynamic array field's initializer (fbc's 75) and a static member of an anonymous union or
'' type (fbc's 156).
type A
    d1(any) as integer => 1               '' 75
    as integer d2(any) = { 1, 2 }         '' 75
    d3(any, any) as integer = any         '' fine
    f(0 to 1) as integer = { 1, 2 }       '' fine
    static s as integer                   '' fine: a named type's
    union
        i as integer
        static x as integer               '' 156
    end union
end type
union B
    type
        j as integer
        static y as integer               '' 156
    end type
end union

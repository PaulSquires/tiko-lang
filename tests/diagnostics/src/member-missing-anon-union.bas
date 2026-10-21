'' A missing member of a type holding an anonymous UNION, an anonymous TYPE, or a field
'' whose type is named '_X' -- winnt.bi's CONTEXT has all three.
type _U
    as long q
end type
type T
    as long a
    union
        as long b
        type
            as short lo, hi
        end type
    end union
    as _U u
end type
union V
    as long a
    as single f
end union
dim t as T
dim v as V
t.hi = 2 : t.b = 1 : t.u.q = 3 : v.a = 4
print t.lo; t.hi; t.u.q; v.a
print t.Nope( )
t.Gone = 1
print v.Missing

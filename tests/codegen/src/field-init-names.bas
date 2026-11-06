'' Names in a field's '= value' (docs/tiko-properties D11). See field-init-names-run.test.
const K = 40
const B = 7
const C = 2
type T1
    as long k = K                   '' the field's own name is not declared yet: the const
    as long a = B + 1               '' a LATER field's name is not either
    as long b = 5
    static as long s
    as long t = s + 1               '' a static member may be read
    const C = 9
    as long u = C                   '' a member const shadows the module's
end type
dim as long T1.s = 7
type Box( of T )
    as long k = K
    as T v = 3
end type
dim as T1 x
print x.k; x.a; x.b; x.t; x.u
dim as Box( of long ) y
dim as Box( of double ) z
print y.k; y.v; z.k; z.v

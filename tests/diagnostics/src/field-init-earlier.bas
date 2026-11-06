'' docs/tiko-properties D11: an earlier field read in a field's '= value'. See field-init-earlier.test.
type T1
    as long a = 5
    as long b = a + 1
end type
type Box( of T )
    as long n
    as T v = n
end type
dim as T1 x
dim as Box( of long ) y
print x.b; y.v

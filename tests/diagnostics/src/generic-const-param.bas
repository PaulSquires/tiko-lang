'' 'byref k as const T' in a generic keeps its CONST at instantiation: the write is an error,
'' as it is to fbc (error 119), where it used to compile and mutate the caller.
type Box( of T )
    as T v
    declare sub Rf( byref k as const T )
end type
sub Box( of T ).Rf( byref k as const T )
    k = this.v
end sub
dim as Box( of long ) b
b.v = 42
dim as long n = 1
b.Rf( n )
print n

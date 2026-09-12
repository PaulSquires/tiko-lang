#lang "fb"

'' A 'dim shared ... = <init>' inside a NAMESPACE or an EXTERN block.
dim shared as long top = 7

namespace o
    dim shared as long a = 7
    dim shared as double d = 1.5
    namespace inner
        dim shared as long deep = 9
    end namespace
end namespace

extern "C"
    dim shared as long ex = 5
end extern

print top
print o.a
print o.d
print o.inner.deep
print ex

'' 'using a, b, c.d' imports each namespace in order, as three USING statements would.
'' fbc-modern 1.20 prints "list 1 2 3" and "scoped 1 2" for this file (measured 2026-09-30).
namespace a
    dim as integer x = 1
end namespace
namespace b
    dim as integer y = 2
end namespace
namespace c
    namespace d
        dim as integer z = 3
    end namespace
end namespace
scope
    using a, b
    print "scoped"; x; y
end scope
using a, b, c.d
print "list"; x; y; z

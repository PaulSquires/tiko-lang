'' A qualified declaration inside a namespace -- fbc's error 131 on the refused lines.
namespace a
    extern i1 as integer
    dim shared a.i1 as integer             '' 131: the namespace itself
    namespace b
        extern j as integer
    end namespace
    dim shared b.j as integer              '' fine: b is nested in a
end namespace
namespace c
    dim shared a.i1 as integer             '' 131: a sibling
end namespace
namespace ns
    namespace d
        extern k as integer
        dim shared d.k as integer          '' 131
    end namespace
end namespace

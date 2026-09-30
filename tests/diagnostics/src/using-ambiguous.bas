'' A name two usings both reach -- fbc's error 255 on the refused lines.
namespace a
    dim as integer foo = 1
end namespace
namespace b
    dim as integer foo = 2
end namespace
scope
    using a
    print foo                                       '' fine: only a
    using b
    print foo                                       '' 255
    dim as integer foo = 3
    print foo                                       '' fine: the local
end scope

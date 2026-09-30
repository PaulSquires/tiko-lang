'' A comma list after USING: a trailing comma (fbc's 14) and two of its namespaces declaring
'' one name (fbc's 255).
namespace a
    dim as integer foo = 1
end namespace
namespace b
    dim as integer foo = 2
end namespace
scope
    using a, b
    print foo                                       '' 255
end scope
using a,                                            '' 14

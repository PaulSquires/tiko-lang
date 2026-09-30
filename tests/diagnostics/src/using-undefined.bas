'' A USING of what is no namespace declared above it -- fbc's error 8 (3 for a bad later
'' component) on the refused lines.
using later                                         '' 8: declared below
namespace a
    dim as integer x = 1
    namespace inner
        dim as integer y = 2
    end namespace
end namespace
namespace later
    dim as integer z = 3
end namespace
type T
    i as integer
end type
using nosuch                                        '' 8
using a, nosuch2                                    '' 8
using a.nosuch3                                     '' 3
using T                                             '' 8: a type
using inner                                         '' fine: 'using a' above reaches it
using a.inner                                       '' fine
using later                                         '' fine: declared above by now

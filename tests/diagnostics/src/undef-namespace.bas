'' '#undef' MAY NOT REMOVE WHAT A NAMESPACE DECLARED -- fbc's error 123, "Symbols defined
'' inside namespaces cannot be removed", measured 2026-09-18 on fbc-modern 1.20 and
'' 1.10.1: from inside the namespace, from a nested one, through a 'using', and spelled
'' 'ns.name'. Before, the dotted form reached Collect as '#undef UnDot' and removed the
'' NAMESPACE. redeclare-allowed.bas holds the '#undef's fbc accepts.
namespace UnNs
    declare sub inner( )
    dim shared as long v
    type T
        x as long
    end type
    const K = 1
    #undef inner
    #undef v
    #undef T
    #undef K
    namespace Deeper
        declare sub d( )
        #undef d
    end namespace
end namespace

namespace UnUsed
    declare sub viaUsing( )
end namespace
using UnUsed
#undef viaUsing

namespace UnDot
    declare sub dotted( )
end namespace
#undef UnDot.dotted

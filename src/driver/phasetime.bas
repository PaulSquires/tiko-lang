'' phasetime.bas -- see the header.

#include once "driver/phasetime.bi"

namespace Tko

sub PhaseTimes.Add( byval ph as PhaseId, byval t0 as double )
    this.secs(ph) += timer - t0
    this.hits(ph) += 1
end sub

private function PhaseName_( byval ph as PhaseId ) as string
    select case ph
    case PH_LOAD    : return "load"
    case PH_FRONT   : return "pp+lex+parse"
    case PH_COLLECT : return "collect"
    case PH_RESOLVE : return "resolve"
    case PH_CHECK   : return "check"
    case PH_SEMA    : return "layout+rules"
    case PH_LOWER   : return "lower"
    case PH_ABI     : return "abi"
    case PH_VERIFY  : return "verify"
    case PH_EMIT    : return "emit llvm"
    case PH_WRITEIR : return "write .ll"
    case PH_SPAWN   : return "start clang"
    case PH_CLANG   : return "clang -c"
    case PH_LINK    : return "link"
    end select
    return "?"
end function

'' STDERR, because under '--emit-ir' stdout is the module itself.
sub ReportPhaseTimes( byref pt as PhaseTimes, byval total as double )
    dim as long eh = freefile
    open err for output as #eh
    dim as double counted = 0
    for ph as long = 0 to PH_COUNT - 1
        counted += pt.secs(ph)
    next
    print #eh, using "time-passes: total ###.### s"; total
    for ph as long = 0 to PH_COUNT - 1
        if pt.hits(ph) = 0 then continue for
        dim as double pc = iif( total > 0, 100 * pt.secs(ph) / total, 0 )
        print #eh, using "  \           \ ###.### s  ###.#%  #####x"; _
            PhaseName_( cast( PhaseId, ph ) ); pt.secs(ph); pc; pt.hits(ph)
    next
    print #eh, using "  \           \ ###.### s  ###.#%"; "other"; total - counted; _
        iif( total > 0, 100 * (total - counted) / total, 0 )
    if pt.importSecs > 0 then
        print #eh, using "  of which the module build ###.### s"; pt.importSecs
    end if
    if pt.clangJobs > 0 then
        print #eh, using "  clang ran #####x, ###.### s of process time"; pt.clangJobs; pt.clangBusy
    end if
    close #eh
end sub

end namespace

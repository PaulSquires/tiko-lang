'' visrungen.bas -- WHICH VISIBILITY RUN THIS IS. #included from visibility.bas, ahead of every
'' per-tree cache.
''
'' A cache keyed only on the AST's ADDRESS and NODE COUNT went stale across units: each unit's arena
'' can sit at the same address, and two units with the same node count -- fbcunit's tests.bas at
'' 131 statements beside compound/for_UDT_counter2.bas -- shared one cache, so the second unit's
'' statement calls were judged as values (TKO0873 on fbcunit's own macros). Run bumps this once per
'' unit (bump = true) and every such cache keys on it as well. A static, not 'dim shared' (D12).
function VisRunGen_( byval bump as boolean = false ) as ulong
    static as ulong g = 0
    if bump then g += 1
    return g
end function

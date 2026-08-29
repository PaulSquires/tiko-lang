'' resolvearr.bas -- ARRAY BOUNDS and INITIALIZER COUNTS, at Resolve time.
''
'' Split out of resolve.bas at the 1500-line cap and included from it in the same
'' place, exactly as resolvedot.bas is.

'' How many elements the initializer has at nesting level 'depth'. N_INITIALIZER is a
'' LIST node, so its children come from the list pool -- reading a statement payload
'' here would land on an unrelated node, which is the mistake this codebase has made
'' six times.
function InitCountAt _
    ( byref c as Ctx, byval init as Tko.NodeId, byval depth as long ) as long

    dim as Tko.NodeId n = init
    for level as long = 0 to depth
        if n = Tko.NODE_NONE then return -1
        if c.ast->Kind( n ) <> Tko.N_INITIALIZER then return -1
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if level = depth then return lp->count
        if lp->count = 0 then return -1
        n = cast( Tko.NodeId, c.ast->children[lp->first] )
    next
    return -1
end function




'' N_FIELD: flat (lo, hi) children.
function ArrayFromBounds _
    ( byref c as Ctx, byval base_ as Tko.TypeId, byval first as long, _
      byval count as long, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_NONE ) as Tko.TypeId

    dim as FB.Array( of ulong ) los, his
    dim as long i = 0
    while i + 1 < count + 1 andalso i + 1 <= count - 1
        los.Push( c.ast->children[first + i] )
        his.Push( c.ast->children[first + i + 1] )
        i += 2
    wend
    return ArrayFromPairs( c, base_, los, his, Tko.NODE_NONE, false, scope_ )
end function

'' resolveinfo.bas -- SemanticInfo, the per-node side tables. Moved out of resolve.bas at
'' the 1500-line cap, included from it in the same place, inside namespace Tko; nothing
'' about the code changed in the move.

'' -------------------------------------------------------------- side tables

sub SemanticInfo.Resize( byval nodeCount as long )
    dim as long want = nodeCount + 1
    while this.refSymbol.Count < want
        this.refSymbol.Push( 0 )
        this.nodeType.Push( 0 )
        this.nodeScope.Push( 0 )
        this.ambiguous.Push( 0 )
        this.instFrame.Push( 0 )
    wend
end sub

sub SemanticInfo.SetRef( byval n as NodeId, byval s as SymbolId )
    if cast( long, n ) < this.refSymbol.Count then
        if this.refSymbol[cast( long, n )] <> cast( ulong, s ) then this.version += 1
    end if
    if cast( long, n ) < this.refSymbol.Count then
        this.refSymbol[cast( long, n )] = cast( ulong, s )
    end if
end sub

function SemanticInfo.RefOf( byval n as NodeId ) as SymbolId
    if cast( long, n ) >= this.refSymbol.Count then return SYMBOL_NONE
    return cast( SymbolId, this.refSymbol[cast( long, n )] )
end function

sub SemanticInfo.SetType( byval n as NodeId, byval t as TypeId )
    if cast( long, n ) < this.nodeType.Count then
        if this.nodeType[cast( long, n )] <> cast( ulong, t ) then this.version += 1
        this.nodeType[cast( long, n )] = cast( ulong, t )
    end if
end sub

function SemanticInfo.TypeOf_( byval n as NodeId ) as TypeId
    if cast( long, n ) >= this.nodeType.Count then return TYPE_NONE
    return cast( TypeId, this.nodeType[cast( long, n )] )
end function

sub SemanticInfo.SetScope( byval n as NodeId, byval s as ScopeId )
    if cast( long, n ) < this.nodeScope.Count then
        this.nodeScope[cast( long, n )] = cast( ulong, s )
    end if
end sub

function SemanticInfo.ScopeOf( byval n as NodeId ) as ScopeId
    if cast( long, n ) >= this.nodeScope.Count then return SCOPE_NONE
    return cast( ScopeId, this.nodeScope[cast( long, n )] )
end function

sub SemanticInfo.SetAmbiguous( byval n as NodeId, byval a as AmbiguousResolution )
    if cast( long, n ) < this.ambiguous.Count then
        this.ambiguous[cast( long, n )] = cast( ubyte, a )
    end if
end sub

function SemanticInfo.AmbiguousOf( byval n as NodeId ) as AmbiguousResolution
    if cast( long, n ) >= this.ambiguous.Count then return AMB_UNRESOLVED
    return cast( AmbiguousResolution, this.ambiguous[cast( long, n )] )
end function

sub SemanticInfo.SetInstFrame( byval n as NodeId, byval f as long )
    if cast( long, n ) < this.instFrame.Count then
        this.instFrame[cast( long, n )] = cast( ulong, f )
    end if
end sub

function SemanticInfo.InstFrameOf( byval n as NodeId ) as long
    if cast( long, n ) >= this.instFrame.Count then return 0
    return cast( long, this.instFrame[cast( long, n )] )
end function

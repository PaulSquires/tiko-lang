'' checkdecide.bas -- THE OVERLOAD DECISIONS CHECK RECORDS FOR LOWERING (audit Phase 4).
''
'' Included from check.bas below overload.bas and above intrinsics.bas, which asks it. Each function here makes a choice the MIR
'' layer used to make again by itself, with its own copy of the rule; the answer goes on
'' the node -- RefOf, or SemanticInfo.decision for a choice the node implies without
'' naming it -- and lowering reads it (TKO_PICK_AUDIT=1 reports where the two differ).

'' 'x[ i ]' OVER A UDT: WHICH 'operator []'. By conversion cost over the written index,
'' uniquely; on a tie, or with nothing viable or no typed index, the chain HEAD. That is the
'' rule LowerUdtIndexOp_ applied, while Check typed the node by the HEAD: with 'operator []'
'' overloaded on integer and on string (overload/op-ptrindex.bas), the node's type and the
'' procedure lowering called could be two different overloads.
private function IndexOperatorFor_ _
    ( byref c as Ctx, byval ut as Tko.TypeId, byval ie0 as Tko.NodeId ) as Tko.SymbolId

    dim as Tko.SymbolId ixs = UdtOperatorNamed_( c, ut, "[]" )
    if (ixs = Tko.SYMBOL_NONE) orelse (ie0 = Tko.NODE_NONE) then return ixs
    dim as Tko.TypeId at0 = c.types->Unqualify( TypeOf_( c, ie0 ) )
    if at0 = Tko.TYPE_NONE then return ixs
    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = CONV_NONE, ties = 0
    dim as Tko.SymbolId cur = ixs
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId cpt = ProcParamTypeAt_( c, cur, 0 )
        if cpt <> Tko.TYPE_NONE then
            dim as Tko.TypeId cpu = c.types->Unqualify( cpt )
            if c.types->Kind( cpu ) = Tko.TK_REFERENCE then cpu = c.types->Unqualify( c.types->Inner( cpu ) )
            dim as long cst = ConversionCost( at0, cpu, *c.types )
            if cst < CONV_NONE then
                if cst < bestCost then
                    bestCost = cst : best = cur : ties = 0
                elseif cst = bestCost then
                    ties += 1
                end if
            end if
        end if
        cur = cs->nextOverload
    wend
    if (best <> Tko.SYMBOL_NONE) andalso (ties = 0) then return best
    return ixs
end function

'' 'len( u )' OVER A UDT: THE 'operator len' DECLARED FOR ITS TYPE, or nothing (the intrinsic).
'' Looked up from the TYPE'S DECLARING SCOPE, which is where a type's operators live -- an
'' imported module's 'sys2.Meter' finds sys2's -- and only an exact parameter match counts.
'' Check walked from the name bound at the call and missed the module's; lowering found it,
'' and with no exact match called the chain HEAD -- 'len( b1 )' over a type without one ran
'' another type's operator: fbc prints 12 (the size), tiko printed 77.
function LenOperatorFor_( byref c as Ctx, byval lat as Tko.TypeId ) as Tko.SymbolId
    lat = c.types->Unqualify( lat )
    if c.types->Kind( lat ) = Tko.TK_REFERENCE then lat = c.types->Unqualify( c.types->Inner( lat ) )
    if c.types->Kind( lat ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId lsc = cast( Tko.ScopeId, c.types->DeclScopeOf( lat ) )
    if lsc = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId lop = c.syms->Lookup( lsc, c.names->Fold( c.names->GetString( "len" ) ) )
    dim as long guard = 0
    while (lop <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr lsy = c.syms->SymbolAt( lop )
        if lsy = 0 then exit while
        if lsy->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.TypeId lpu = c.types->Unqualify( ProcParamTypeAt_( c, lop, 0 ) )
        if c.types->Kind( lpu ) = Tko.TK_REFERENCE then lpu = c.types->Unqualify( c.types->Inner( lpu ) )
        if (lpu = lat) andalso (lsy->type_ <> Tko.TYPE_NONE) then return lop
        lop = lsy->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

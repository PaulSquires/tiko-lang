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

'' WHERE A CALL'S OVERLOAD WALK STARTS: a PROPERTY's chain HEAD. Typing 't.P' binds the member
'' to its no-index getter (PropertyReadAccessor_), which need not be first -- and a chain is
'' singly linked, so 't.P( 7 )' resolved from there could not see an indexed getter declared
'' before it: TKO0632 where fbc calls it. Anything else starts where Resolve bound it.
function CallChainStart_( byref c as Ctx, byval callee as Tko.SymbolId ) as Tko.SymbolId
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( callee )
    if s = 0 then return callee
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return callee
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if (pn = Tko.NODE_NONE) orelse (c.ast->Kind( pn ) <> Tko.N_PROC) then return callee
    if StmtOf( c, pn )->op <> cast( ushort, Tko.KW_PROPERTY ) then return callee
    dim as Tko.SymbolId h = c.syms->LookupLocal( s->parent, s->name )
    if h = Tko.SYMBOL_NONE then return callee
    return h
end function

declare function ProcTypeOfSymbol_( byref c as Ctx, byval sid as Tko.SymbolId ) as Tko.TypeId   '' intrinsics.bas

'' ONE PARAMETER'S BYREF FLAG off a procedure symbol, counting N_PARAMs (lowering's ParamIsByref).
private function ProcParamByref_( byref c as Ctx, byval proc_ as Tko.SymbolId, byval idx as long ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( proc_ )
    if s = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if (pn = Tko.NODE_NONE) orelse (c.ast->Kind( pn ) <> Tko.N_PROC) then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then return ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        seen += 1
    next
    return false
end function

'' A RESULT TYPE: a SUB spells its absence as TYPE_NONE on a declaration and VOID on a type.
private function SameResult_( byref c as Ctx, byval a as Tko.TypeId, byval b as Tko.TypeId ) as boolean
    dim as boolean av = (a = Tko.TYPE_NONE), bv = (b = Tko.TYPE_NONE)
    if av = false then
        if c.types->Kind( a ) = Tko.TK_BUILTIN then av = (c.types->BuiltinOf( a ) = Tko.TY_VOID)
    end if
    if bv = false then
        if c.types->Kind( b ) = Tko.TK_BUILTIN then bv = (c.types->BuiltinOf( b ) = Tko.TY_VOID)
    end if
    if av andalso bv then return true
    if av orelse bv then return false
    return (c.types->Unqualify( a ) = c.types->Unqualify( b ))
end function

'' '@f' OR 'procptr( f )' WITH A TARGET TYPE, over an overload set: the overload whose
'' signature the target names -- parameter count, result, and each parameter's type and
'' byref-ness exactly. Measured, fbc takes it for a store, an initialiser and an argument
'' ('_Z1Fd' for 'dim p as sub( byval as double ) = @f'). Lowering chose it alone
'' (lowerprocptr.bas ProcPtrByType_) while Check typed '@f' from the overload Resolve bound;
'' now the choice is recorded on 'f' and '@f' is typed by it (overload re-pick refactor).
private sub DecideProcAddr_( byref c as Ctx, byval v as Tko.NodeId, byval wantT as Tko.TypeId )
    if (v = Tko.NODE_NONE) orelse (wantT = Tko.TYPE_NONE) then return
    dim as Tko.NodeId fnE = Tko.NODE_NONE
    select case c.ast->Kind( v )
    case Tko.N_ADDROF
        fnE = c.ast->unaries[cast( long, c.ast->nodes[cast( long, v )].data )].operand
    case Tko.N_CALL
        dim as Tko.ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, v )].data )]
        if (lp->count <> 1) orelse (lp->target = Tko.NODE_NONE) then return
        fnE = cast( Tko.NodeId, c.ast->children[lp->first] )
    case else
        return
    end select
    if fnE = Tko.NODE_NONE then return
    dim as Tko.SymbolId first_ = c.info->RefOf( fnE )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( first_ )
    if s = 0 then return
    if (s->kind <> cast( ubyte, Tko.SYM_PROC )) orelse (s->nextOverload = Tko.SYMBOL_NONE) then return
    dim as Tko.TypeId st = c.types->Unqualify( wantT )
    if c.types->Kind( st ) = Tko.TK_POINTER then st = c.types->Unqualify( c.types->Inner( st ) )
    if c.types->Kind( st ) <> Tko.TK_PROC then return
    dim as long want = c.types->ProcParamCount( st )
    dim as Tko.TypeId wantRet = c.types->Inner( st )
    dim as Tko.SymbolId cur = first_
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        if cs->kind = cast( ubyte, Tko.SYM_PROC ) then
            dim as boolean ok = (ProcParamCount_( c, cur ) = want)
            if ok then ok = SameResult_( c, cs->type_, wantRet )
            for i as long = 0 to want - 1
                if ok = false then exit for
                dim as Tko.TypeId wp = c.types->ProcParam( st, i )
                if wp = Tko.TYPE_NONE then
                    ok = false
                    exit for
                end if
                dim as boolean wRef = (c.types->Kind( wp ) = Tko.TK_REFERENCE)
                if wRef then wp = c.types->Inner( wp )
                dim as Tko.TypeId gp = ProcParamTypeAt_( c, cur, i )
                if gp = Tko.TYPE_NONE then
                    ok = false
                    exit for
                end if
                if c.types->Kind( gp ) = Tko.TK_REFERENCE then gp = c.types->Inner( gp )
                if c.types->Unqualify( gp ) <> c.types->Unqualify( wp ) then ok = false
                if ok then ok = (ProcParamByref_( c, cur, i ) = wRef)
            next
            if ok then
                c.info->SetDecision( fnE, cur )
                if c.ast->Kind( v ) = Tko.N_ADDROF then
                    if c.info->TypeOf_( v ) = ProcTypeOfSymbol_( c, first_ ) then c.info->SetType( v, ProcTypeOfSymbol_( c, cur ) )
                end if
                return
            end if
        end if
        cur = cs->nextOverload
    wend
end sub

'' EVERY CONTEXT THAT GIVES A VALUE A TARGET TYPE, as lowering's LowerExprWant_ callers do: an
'' initialiser (the variable's type), an assignment (the target's), and a call's arguments
'' (each parameter's). Run once the whole unit is typed.
private sub DecideProcAddrs_( byref c as Ctx )
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        select case c.ast->Kind( n )
        case Tko.N_VAR
            '' Each declarator's VARIABLE, found as lowering finds it: by name in the statement's
            '' scope (a qualified 'T.x' static member is not a procedure pointer's shape).
            dim as Tko.StmtPayload ptr vp = StmtOf( c, n )
            for k as long = 0 to vp->count - 1
                dim as Tko.NodeId item = cast( Tko.NodeId, c.ast->children[vp->first + k] )
                if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
                dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
                if ip->b = Tko.NODE_NONE then continue for
                if (c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) <> 0 then continue for
                dim as Tko.Symbol ptr vs = c.syms->SymbolAt( c.syms->LookupLocalTyped( c.info->ScopeOf( n ), ip->name, false ) )
                if vs <> 0 then DecideProcAddr_( c, ip->b, vs->type_ )
            next
        case Tko.N_AMBIGUOUS
            dim as Tko.StmtPayload ptr ap = StmtOf( c, n )
            if c.info->AmbiguousOf( n ) = Tko.AMB_ASSIGN then
                if (ap->a <> Tko.NODE_NONE) andalso (ap->b <> Tko.NODE_NONE) then DecideProcAddr_( c, ap->b, c.info->TypeOf_( ap->a ) )
            elseif c.info->AmbiguousOf( n ) = Tko.AMB_CALL then
                if ap->a <> Tko.NODE_NONE then
                    dim as Tko.SymbolId cal = c.info->RefOf( ap->a )
                    for k as long = 0 to ap->count - 1
                        DecideProcAddr_( c, cast( Tko.NodeId, c.ast->children[ap->first + k] ), ProcParamTypeAt_( c, cal, k ) )
                    next
                end if
            end if
        case Tko.N_CALL
            dim as Tko.ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
            dim as Tko.SymbolId cal = c.info->RefOf( n )
            if (cal = Tko.SYMBOL_NONE) andalso (lp->target <> Tko.NODE_NONE) then cal = c.info->RefOf( lp->target )
            dim as Tko.Symbol ptr cls = c.syms->SymbolAt( cal )
            if cls <> 0 then
                if cls->kind = cast( ubyte, Tko.SYM_PROC ) then
                    for k as long = 0 to lp->count - 1
                        DecideProcAddr_( c, cast( Tko.NodeId, c.ast->children[lp->first + k] ), ProcParamTypeAt_( c, cal, k ) )
                    next
                end if
            end if
        end select
    next
end sub

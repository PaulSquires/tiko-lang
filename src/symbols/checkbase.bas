'' checkbase.bas -- COPYING EACH UDT'S BASE INTO THE TYPE TABLE.
''
'' Split out of check.bas at the 1500-line cap and included from it in the same place,
'' before ConversionCost, whose derived-to-base tier is the only reason this exists.
'' Nothing in it changed in the move.

'' COPY EACH UDT'S BASE INTO THE TYPE TABLE, once, before anything is typed.
''
'' 'extends T' is a field named 'base' in the type's own scope, which is where the fact
'' belongs and where every other pass reads it. ConversionCost cannot: it is handed a
'' TypeContext and nothing else, on purpose, and asking it to carry a SymbolTable so it
'' could answer one question would give it a reason to ask others.
private sub RecordUdtBases_( byref c as Ctx )
    dim as Tko.InternId baseNm = c.names->GetString( "base" )
    for i as long = 1 to c.types->Count( )
        dim as Tko.TypeId t = cast( Tko.TypeId, i )
        if c.types->Kind( t ) <> Tko.TK_UDT then continue for
        dim as Tko.InternId tn = c.types->NameOf( t )
        if tn = 0 then continue for
        dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
        dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
        if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
        if s = 0 then continue for
        if s->inner = Tko.SCOPE_NONE then continue for
        dim as Tko.SymbolId bf = c.syms->LookupLocal( s->inner, baseNm )
        if bf = Tko.SYMBOL_NONE then continue for
        dim as Tko.Symbol ptr b = c.syms->SymbolAt( bf )
        if b = 0 then continue for
        if b->type_ = Tko.TYPE_NONE then continue for
        '' A type is never its own base; a cycle here would be a parse error upstream,
        '' but BaseDistance's depth cap does not depend on that being true.
        if c.types->Unqualify( b->type_ ) = t then continue for
        c.types->SetBase( t, c.types->Unqualify( b->type_ ) )
    next
end sub

'' WHAT A DERIVED-TO-BASE ARGUMENT COSTS, or CONV_NONE when the two are unrelated.
''
'' A UDT reached NOTHING but its own type in the conversion table, so passing a T2 to a
'' 'byref x as T1' scored CONV_NONE -- and with one candidate as with several, that is
'' not a diagnostic: the callee still binds, the call is emitted with a VOID result, and
'' whatever consumed it declines.
''
'' Measured from fbc: the exact type wins, then the NEAREST base. Offered
'' { object, T1, T2 } a T3 argument takes T2, and offered { object, T1 } it takes T1.
private function UdtBaseCost_ _
    ( byval from_ as Tko.TypeId, byval to_ as Tko.TypeId, _
      byref types as Tko.TypeContext ) as long

    dim as long ud = types.BaseDistance( from_, to_ )
    if ud > 0 then return CONV_UDT_BASE + (ud - 1) * CONV_UDT_LINK
    return CONV_NONE
end function

'' '@x' IS A POINTER TO x -- EXCEPT '@this', which is the receiver's own address. 'this'
'' is typed as the pointer it is held as, so wrapping it again made '@this' inside a
'' method a 'T ptr ptr': overload resolution found no candidate for 'g.DrawImage( @this,
'' @rc )' (TKO0632, where fbc calls the GpRect one), 'cast( CGpImage ptr, @this )' was
'' refused, and lowering -- which always passed the right address -- was never asked.
'' AfxNova's CGpBitmap.MakeTransparent is the shape, and PsCalendar reached it.
private function AddrOfType_ _
    ( byref c as Ctx, byval operand as Tko.NodeId, byval inner as Tko.TypeId ) as Tko.TypeId

    if c.ast->Kind( operand ) = Tko.N_IDENT then
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( operand ) )
        if s <> 0 then
            if s->kind = cast( ubyte, Tko.SYM_PARAMETER ) then
                if s->name = c.names->Fold( c.names->GetString( "this" ) ) then
                    if c.types->Kind( c.types->Unqualify( inner ) ) = Tko.TK_POINTER then return inner
                end if
            end if
        end if
    end if
    return c.types->Pointer_( inner )
end function

'' A METHOD NAMED WITHOUT PARENTHESES OVER AN OVERLOAD SET IS A CALL OF THE ONE OVERLOAD
'' THAT NEEDS NO ARGUMENT -- none, or a default for every parameter -- not of the chain's
'' head. Measured on fbc-modern, over 'GetX( byval p as GD ptr ) as long' declared before
'' 'GetX( ) as GD': 'this.GetX', 'GetX' inside a method, 't1.GetX', 'TakeGD( this.GetX )'
'' and the static 'T.SX' all call the zero-parameter one, and over 'GetY( byval q as
'' integer )' beside 'GetY( byval k as long = 5 )' the defaulted one. tiko typed the member
'' from the head: AfxNova's 'dim rguid as GUID = this.GetRawFormat' was a GpStatus, TKO0738.
''
'' A name that is CALLED, addressed or assigned is left alone (NF_CALL_TARGET): overload
'' resolution picks for a call, and the reference it is handed must stay the chain head.
'' Nothing changes unless exactly ONE overload qualifies. The pick is recorded on the node,
'' which is what lowering reads to make the call.
private function ParenlessMethodOf_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval id as Tko.NodeId ) as Tko.SymbolId

    if sid = Tko.SYMBOL_NONE then return sid
    if (c.ast->nodes[cast( long, id )].flags and Tko.NF_CALL_TARGET) <> 0 then return sid
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return sid
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return sid
    if s->nextOverload = Tko.SYMBOL_NONE then return sid

    dim as Tko.SymbolId pick = Tko.SYMBOL_NONE
    dim as long found = 0
    dim as Tko.SymbolId cur = sid
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
        if pn = Tko.NODE_NONE then return sid
        if c.ast->Kind( pn ) <> Tko.N_PROC then return sid
        dim as Tko.StmtPayload ptr pp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )]
        '' A SUB OR A FUNCTION; a property already has PropertyReadAccessor_.
        select case cast( Tko.TokenKind, pp->op )
        case Tko.KW_SUB, Tko.KW_FUNCTION
        case else
            return sid
        end select
        dim as boolean callable = true
        for i as long = 0 to pp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.StmtPayload ptr prp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
            if prp->op = cast( ushort, Tko.TK_ELLIPSIS ) then continue for
            if prp->b = Tko.NODE_NONE then
                callable = false
                exit for
            end if
        next
        if callable then
            found += 1
            pick = cur
        end if
        cur = cs->nextOverload
    wend
    if found <> 1 then return sid
    if pick = sid then return sid
    c.info->SetRef( id, pick )
    if c.ast->Kind( id ) = Tko.N_MEMBER then
        c.info->SetRef( c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )].rhs, pick )
    end if
    return pick
end function

'' A TYPE OF THE PROGRAM'S OWN IS NOT THE INTRINSIC IT IS SPELLED LIKE, and unlike a
'' procedure (see IntrinsicCallType_) there is no builtin-argument exception. Measured on
'' fbc-modern beside 'type Str' with a zstring constructor: 'str( 42 )' is error 58 against
'' that constructor, and '#print typeof' of 'Str( "abc" )', 'str( "abc" )' and 'str( 42 )'
'' is STR for all three. tiko typed the call STRING, so 'a.s = Str( "abc" )' over 'operator
'' let( byref o as Str )' missed the same-type let, reached the converting-let path, and
'' passed the temporary's LOADED bytes where the reference belonged -- clang: "defined with
'' type '[8 x i8]' but expected 'ptr'" -- and nothing destroyed the temporary.
private function UdtShadowsIntrinsic_ _
    ( byref c as Ctx, byval bsym as Tko.Symbol ptr ) as boolean

    if bsym = 0 then return false
    if bsym->kind <> cast( ubyte, Tko.SYM_UDT ) then return false
    if bsym->type_ = Tko.TYPE_NONE then return false
    return (c.types->Kind( c.types->Unqualify( bsym->type_ ) ) = Tko.TK_UDT)
end function

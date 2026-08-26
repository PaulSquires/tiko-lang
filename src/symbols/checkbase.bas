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

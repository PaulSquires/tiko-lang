'' resolvedot.bas -- A DOTTED TYPE NAME, resolved through its qualifiers.
''
'' Split out of resolve.bas at the 1500-line cap and included from it in the same place.
'' Nothing in it changed in the move.

'' A possibly-dotted NAMESPACE path -- 'a', 'a.b', 'a.b.c' -- resolved to its symbol.
''
'' The same walk LookupDottedType_ does, and separate from it for one reason: a
'' NAMESPACE is not a type name, so the LookupLocalTyped that walk uses for every
'' component after the first would not find one.
private function LookupDottedNamespace_ _
    ( byref c as Ctx, byval scope_ as Tko.ScopeId, _
      byval path as Tko.InternId ) as Tko.SymbolId

    dim as string qpath = c.names->Spelling( path )
    dim as Tko.ScopeId sc = scope_
    dim as boolean first_ = true
    dim as long at = 0
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    dim as long guard = 0

    while (at <= len( qpath )) andalso (guard < 64)
        guard += 1
        dim as long dot = instr( at + 1, qpath, "." )
        dim as long stop_ = dot
        if stop_ = 0 then stop_ = len( qpath ) + 1
        dim as string comp = mid( qpath, at + 1, stop_ - at - 1 )
        if len( comp ) = 0 then return Tko.SYMBOL_NONE
        dim as Tko.InternId cid = c.names->GetString( comp )

        dim as Tko.SymbolId sid
        if first_ then
            sid = c.syms->Lookup( sc, cid )
        else
            sid = c.syms->LookupLocal( sc, cid )
        end if
        dim as Tko.Symbol ptr sym = c.syms->SymbolAt( sid )
        if sym = 0 then return Tko.SYMBOL_NONE
        found = sid
        first_ = false

        if dot = 0 then exit while
        if sym->kind <> cast( ubyte, Tko.SYM_NAMESPACE ) then return Tko.SYMBOL_NONE
        if sym->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
        sc = cast( Tko.ScopeId, sym->inner )
        at = dot
    wend
    return found
end function

'' A possibly-dotted name -- 'UDT', 'ns.UDT', 'a.b.UDT' -- resolved to its symbol.
''
'' Only the FIRST component is visible from the starting scope; each later one is looked
'' up INSIDE what the previous opened. Shared by qualified type references and by
'' BindThis, which needs the same walk for a structor defined outside its namespace.
private function LookupDottedType_ _
    ( byref c as Ctx, byval scope_ as Tko.ScopeId, _
      byval path as Tko.InternId ) as Tko.SymbolId

    dim as string qpath = c.names->Spelling( path )
    dim as Tko.ScopeId sc = scope_
    dim as boolean first_ = true
    dim as long at = 0
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE

    while at <= len( qpath )
        dim as long dot = instr( at + 1, qpath, "." )
        dim as long stop_ = dot
        if stop_ = 0 then stop_ = len( qpath ) + 1
        dim as string comp = mid( qpath, at + 1, stop_ - at - 1 )
        if len( comp ) = 0 then return Tko.SYMBOL_NONE
        dim as Tko.InternId cid = c.names->GetString( comp )

        dim as Tko.SymbolId sid
        if first_ then
            sid = c.syms->Lookup( sc, cid )
        else
            sid = c.syms->LookupLocalTyped( sc, cid, true )
        end if
        dim as Tko.Symbol ptr sym = c.syms->SymbolAt( sid )
        if sym = 0 then return Tko.SYMBOL_NONE
        found = sid
        first_ = false

        if dot = 0 then exit while
        '' Only a NAMESPACE or a UDT opens a scope to descend into.
        dim as boolean opens = _
            (sym->kind = cast( ubyte, Tko.SYM_NAMESPACE )) orelse _
            (sym->kind = cast( ubyte, Tko.SYM_UDT ))
        if (opens = false) orelse (sym->inner = Tko.SCOPE_NONE) then
            return Tko.SYMBOL_NONE
        end if
        sc = sym->inner
        at = dot
    wend
    return found
end function

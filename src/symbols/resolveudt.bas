'' resolveudt.bas -- A TYPE DECLARED INSIDE A PROCEDURE MAY NOT HAVE METHODS.
''
'' Included from resolve.bas, inside its namespace, and run ONCE OVER THE SYMBOL TABLE
'' after the walk rather than at the declaration. fbc's error 263, in its own words:
'' "Objects with default [con|de]structors or methods are only allowed in the module
'' level". The reason is in the corpus test's own comment -- a method would need a
'' NESTED PROCEDURE, and FreeBASIC has none.
''
'' EVERY WAY OF ACQUIRING ONE COUNTS, which is why this cannot live in Collect. Measured,
'' one probe each, all error 263:
''
''     declare sub / constructor / destructor / property / operator let   direct
''     x as UDT1        where UDT1 has a constructor or a destructor      by FIELD
''     extends UDT1     where UDT1 has one                                by BASE
''     extends object                                                     by BASE
''     s as string      the var-len string carries its own destructor     by FIELD
''
'' The last four need the field's TYPE, and at Collect a field's type is still a
'' reference. 'extends' needs no case of its own: fbc spells the base as a FIELD NAMED
'' 'base', so it is walked with the rest.
''
'' A SCOPE BLOCK INSIDE A PROCEDURE IS STILL INSIDE IT, so the whole scope chain is
'' walked rather than the immediate parent tested.

'' The UDT's own symbol, from its type -- the same lookup resolvesize.bas makes.
private function UdtSymOfT_ _
    ( byref c as Ctx, byval u as Tko.TypeId ) as Tko.SymbolId

    dim as Tko.InternId tn = c.types->NameOf( u )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( u ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    return ts
end function

declare function UdtHasProcs_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval depth as long ) as boolean

'' True when this member's type brings a constructor or destructor with it.
private function TypeBringsProcs_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval depth as long ) as boolean

    if t = Tko.TYPE_NONE then return false
    if depth > 16 then return false
    dim as Tko.TypeId u = c.types->Unqualify( t )
    '' A VAR-LEN STRING FIELD IS NOT COUNTED, though fbc counts it: it carries its own
    '' destructor, so 'type U { s as string }' inside a sub IS error 263. It is left out
    '' because tiko-lang cannot yet tell one from a FIXED string whose length did not
    '' fold. 'fstr as string * len( K )' in quirk/len-sizeof.bas is fbc's 7 bytes and
    '' tiko-lang's 24-byte DESCRIPTOR -- ConstOf does not fold 'len' of a string
    '' constant -- and with the string test in place that accepted file became an error.
    '' The layout bug is the one to fix; this test comes back with it. Arrays are not
    '' unwrapped for the same reason.
    select case c.types->Kind( u )
    case Tko.TK_UDT
        return UdtHasProcs_( c, UdtSymOfT_( c, u ), depth + 1 )
    end select
    return false
end function

function UdtHasProcs_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval depth as long ) as boolean

    if sid = Tko.SYMBOL_NONE then return false
    if depth > 16 then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->inner = Tko.SCOPE_NONE then return false
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false

    dim as Tko.SymbolId m = sc->firstSym
    dim as long guard = 0
    while (m <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr ms = c.syms->SymbolAt( m )
        if ms = 0 then exit while
        if ms->kind = cast( ubyte, Tko.SYM_PROC ) then return true
        if ms->kind = cast( ubyte, Tko.SYM_FIELD ) then
            if TypeBringsProcs_( c, ms->type_, depth ) then return true
        end if
        m = ms->nextInScope
    wend
    return false
end function

private function ScopeIsInProc_ _
    ( byref c as Ctx, byval scope_ as Tko.ScopeId ) as boolean

    dim as Tko.ScopeId cur = scope_
    dim as long guard = 0
    while (cur <> Tko.SCOPE_NONE) andalso (guard < 1000)
        guard += 1
        dim as Tko.SymScope ptr sc = c.syms->ScopeAt( cur )
        if sc = 0 then return false
        if sc->kind = cast( ubyte, Tko.SCOPEK_PROC ) then return true
        cur = sc->parent
    wend
    return false
end function

private sub CheckNoMethodsInProc_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Tko.Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, Tko.SYM_UDT ) then continue for
        if ScopeIsInProc_( c, s->parent ) = false then continue for
        if UdtHasProcs_( c, cast( Tko.SymbolId, i ), 0 ) = false then continue for
        c.diags->Report( Tko.TKO0619, Tko.PointRange( s->loc ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' collectdecl.bas -- declaring a name, and the collision a slot cannot see.
''
'' Split out of collect.bas at the 1500-line cap and INCLUDED by it, inside the same
'' namespace, so it sees the Walker. Declare_ moved unchanged apart from the call to
'' ClassNameTaken_ at its end.

'' A VALUE MAY NOT TAKE THE NAME OF A TYPE WITH MEMBERS. A plain-data TYPE shares its
'' spelling with a value -- see Symbol.altClass -- but once the type has anything but
'' fields, fbc calls the name taken. Measured on fbc-modern 1.20.0, 'type C' followed by
'' 'dim as integer c':
''
''     C has only fields, 'private:' or not              accepted
''     C has a method, constructor, destructor,          error 4, Duplicated definition
''       operator, property, static sub, const
''       member or nested enum, or EXTENDS anything
''     C has a static member variable                    error 120, Expected period
''     C is a GENERIC, with methods or without           accepted
''     'type CA as C' and then 'dim as integer ca'       accepted -- an alias is not asked
''
'' and, with C a type that has a method:
''
''     dim, redim, var, static, extern, common, const,   error 4
''       'for c as integer'
''     the same in a SUB, or in any block inside one     error 4 -- a scope does not shadow
''     a parameter of a procedure DEFINITION             error 4
''     a parameter of a DECLARE                          accepted
''     a local or a parameter in ANY type's method       accepted
''     a value in a namespace with C outside it, or      accepted
''       C in a namespace with the value outside it
''     the value declared BEFORE the type                accepted
''     a field, or an enum member, called c              accepted
''     'sub c( )' after the type                         error 120 -- not asked here
''
'' So the walk goes outward through procedure and block scopes and stops at the first
'' module, namespace or type scope -- a method's body opens inside its type's scope,
'' which is why a method never collides. It runs when the VALUE is declared, which is
'' what keeps the value-first order legal: by then the type's body has been collected,
'' and a type that comes later is never asked.

'' Anything but fields in the type's own scope, or a base. A generic is never one.
private function IsClassLikeUdt_ _
    ( byref w as Walker, byval id as Tko.SymbolId ) as boolean

    dim as Tko.Symbol ptr u = w.syms->SymbolAt( id )
    if u = 0 then return false
    if u->kind <> cast( ubyte, Tko.SYM_UDT ) then return false
    if (u->flags and Tko.SYMF_GENERIC_INST) <> 0 then return false
    if w.src->IsBuiltin( u->loc ) then return false
    '' The payload is the N_TYPE node: 'b' holds a generic's parameters, 'c' the base.
    dim as Tko.NodeId node = cast( Tko.NodeId, u->payload )
    dim as boolean isTypeNode = (node <> Tko.NODE_NONE)
    if isTypeNode then isTypeNode = (cast( long, node ) < w.ast->nodes.Count)
    if isTypeNode then isTypeNode = (w.ast->Kind( node ) = Tko.N_TYPE)
    if isTypeNode then
        dim as Tko.StmtPayload ptr tp = StmtOf( w, node )
        if tp->b <> Tko.NODE_NONE then return false
        if tp->c <> Tko.NODE_NONE then return true
    end if
    dim as Tko.SymScope ptr ts = w.syms->ScopeAt( u->inner )
    if ts = 0 then return false
    dim as Tko.SymbolId m = ts->firstSym
    while m <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr ms = w.syms->SymbolAt( m )
        if ms = 0 then exit while
        select case cast( Tko.SymbolKind, ms->kind )
        case Tko.SYM_PROC, Tko.SYM_CONSTANT, Tko.SYM_VARIABLE, _
             Tko.SYM_ENUM, Tko.SYM_ENUMCONST
            return true
        end select
        m = ms->nextInScope
    wend
    return false
end function

'' The type with members whose name a value declaration takes, or SYMBOL_NONE.
private function ClassNameTaken_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval k as Tko.SymbolKind, byval loc as Tko.SourceLoc ) as Tko.SymbolId

    select case k
    case Tko.SYM_VARIABLE, Tko.SYM_CONSTANT
    case Tko.SYM_PARAMETER
        if w.inProcDecl then return Tko.SYMBOL_NONE
    case else
        return Tko.SYMBOL_NONE
    end select
    '' A generic instantiation collects with no source manager, and was not measured.
    if w.src = 0 then return Tko.SYMBOL_NONE
    if w.src->IsBuiltin( loc ) then return Tko.SYMBOL_NONE

    dim as Tko.ScopeId sc = scope_
    dim as long guard = 0
    while (sc <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.SymScope ptr ss = w.syms->ScopeAt( sc )
        if ss = 0 then exit while
        dim as Tko.SymbolId uid = w.syms->LookupLocalTyped( sc, nm, true )
        if IsClassLikeUdt_( w, uid ) then return uid
        select case cast( Tko.ScopeKind, ss->kind )
        case Tko.SCOPEK_PROC, Tko.SCOPEK_BLOCK
            sc = ss->parent
        case else
            exit while
        end select
    wend
    return Tko.SYMBOL_NONE
end function

private function Declare_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval k as Tko.SymbolKind, byval loc as Tko.SourceLoc ) as Tko.SymbolId

    if nm = Tko.INTERN_NONE then return Tko.SYMBOL_NONE
    dim as boolean dup = false
    dim as Tko.SymbolId id = w.syms->DeclareSym( scope_, nm, k, loc, dup )
    if dup then
        '' A USER DECLARATION SHADOWS A PRELUDE ONE. fbc's graphics statements are
        '' QUIRK KEYWORDS and a user declaration of the same name simply replaces
        '' them: measured, 'type IMAGEINFO as _II' compiles and the type wins, and
        '' win/commctrl.bi writes exactly that. tiko declares the same names from a
        '' real prelude buffer, so the header collided with the intrinsic -- two
        '' errors, and every file that reaches commctrl.bi through windows.bi.
        ''
        '' The overload chain goes with it: the prelude declares IMAGEINFO twice,
        '' 32-bit and 64-bit, and a shadowing declaration replaces the whole name.
        '' EITHER ORDER. The prelude is a VIRTUAL FILE appended to the unit, so its
        '' declarations are usually collected AFTER the user's includes -- the
        '' diagnostic pointed at '<builtin>' and named the header's type as the one
        '' already declared. Whichever side is the prelude's loses.
        dim as Tko.Symbol ptr old = w.syms->SymbolAt( id )
        if (old <> 0) andalso (w.src <> 0) then
            dim as boolean oldIsPrelude = w.src->IsBuiltin( old->loc )
            dim as boolean newIsPrelude = w.src->IsBuiltin( loc )
            if newIsPrelude andalso (oldIsPrelude = false) then
                '' THE WHOLE DECLARATION IS DISCARDED, not just its symbol: returning
                '' the existing one let the prelude's 'declare function imageinfo'
                '' carry on configuring the header's TYPE, which answered with
                '' 'calling convention does not match'. SYMBOL_NONE is what every
                '' caller already reads as 'nothing was declared'.
                return Tko.SYMBOL_NONE
            end if
            if oldIsPrelude andalso (newIsPrelude = false) then
                old->kind = cast( ubyte, k )
                old->loc = loc
                old->payload = 0
                old->type_ = Tko.TYPE_NONE
                old->inner = Tko.SCOPE_NONE
                old->nextOverload = Tko.SYMBOL_NONE
                old->flags = 0
                return id
            end if
        end if
        w.duplicates += 1
        dim as Tko.SourceRange r = Tko.PointRange( loc )
        w.diags->Report( Tko.TKO0600, r, w.names->Spelling( nm ) )
        dim as Tko.Symbol ptr prev = w.syms->SymbolAt( id )
        if prev <> 0 then
            w.diags->AddNote( Tko.TKO0901, Tko.PointRange( prev->loc ) )
        end if
    else
        '' Only when the slot raised nothing, so one declaration is refused once. The
        '' value is still declared: every later use binds to it rather than cascading.
        dim as Tko.SymbolId classSym = ClassNameTaken_( w, scope_, nm, k, loc )
        dim as Tko.Symbol ptr cs = w.syms->SymbolAt( classSym )
        if cs <> 0 then
            w.duplicates += 1
            w.diags->Report( Tko.TKO0777, Tko.PointRange( loc ), w.names->Spelling( nm ) )
            w.diags->AddNote( Tko.TKO0901, Tko.PointRange( cs->loc ) )
        end if
    end if
    return id
end function

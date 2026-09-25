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

'' A LOCAL THAT SHADOWS AN OUTER VALUE, and where its visibility starts.
''
'' A 'dim' inside a block does NOT reach the statements above it. Measured on
'' fbc-modern, with 'dim as long v = 11' outside:
''
''     print v : dim as long v = 22 : print v     inside a SELECT CASE arm, an IF, a
''       SCOPE, a FOR body, a SUB over its own parameter, and with STATIC in place of
''       DIM -- prints 11 then 22, every time
''     dim as long v = v + 1                      prints 1, so the initializer sees the
''       NEW v: visibility starts AT the declaration, not after it
''
'' tiko-lang bound every one of those to the inner variable, because Collect declares a
'' whole block before Resolve walks any of it, so the name is already in the scope by
'' the time anything above it is bound. That is not a cosmetic difference -- the
'' statements above the 'dim' read a slot nothing has written yet, which is how
'' tiko-editor came to dereference an uninitialised document pointer eight lines above
'' the shadowing declaration that produced it.
''
'' ONLY WHEN IT SHADOWS. With no outer name of the same spelling there is nothing for a
'' use above the 'dim' to fall through to, and hiding the declaration would turn it into
'' an undeclared-variable error instead. fbc reports exactly that error, but it is a
'' second change and not what this one is for.
'' WHERE A WRITTEN DECLARATION STARTS -- Symbol.declAt, for the rule that a name used
'' above its declaration is undeclared (Resolve's DeclaredBelow_). The FIRST sighting
'' only: a procedure declared and then defined starts at its DECLARE, a namespace at its
'' first block. A generic INSTANCE (w.src = 0) is collected long after the code that
'' names it, so its node ids say nothing about order, and the prelude is no one's source.
private sub NoteDeclAt_ _
    ( byref w as Walker, byval sid as Tko.SymbolId, byval at as Tko.NodeId )
    if (sid = Tko.SYMBOL_NONE) orelse (at = Tko.NODE_NONE) then return
    if w.src = 0 then return
    dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
    if s = 0 then return
    if s->declAt <> 0 then return
    if w.src->IsBuiltin( w.ast->Loc( at ) ) then return
    s->declAt = cast( ulong, at )
end sub

private sub MarkShadow_ _
    ( byref w as Walker, byval sid as Tko.SymbolId, byval scope_ as Tko.ScopeId, _
      byval nm as Tko.InternId, byval k as Tko.SymbolKind, byval dflags as ushort, _
      byval item as Tko.NodeId, byval ip as Tko.StmtPayload ptr )

    if sid = Tko.SYMBOL_NONE then return
    '' THE LOWEST NODE THIS DECLARATION OWNS, not the statement that holds it -- see the
    '' ShadowFrom call below for why.
    dim as Tko.NodeId lo = item
    if ip <> 0 then
        if (ip->a <> Tko.NODE_NONE) andalso (ip->a < lo) then lo = ip->a
        if (ip->b <> Tko.NODE_NONE) andalso (ip->b < lo) then lo = ip->b
        if (ip->c <> Tko.NODE_NONE) andalso (ip->c < lo) then lo = ip->c
    end if
    '' Where it starts, for 'x = 1 : dim as integer x' -- fbc's error 42. A CONST is
    '' always written; a variable only when NF_DECL_WRITTEN says so (below).
    if (k = Tko.SYM_CONSTANT) orelse ((dflags and Tko.NF_DECL_WRITTEN) <> 0) then
        NoteDeclAt_( w, sid, lo )
    end if
    if k <> Tko.SYM_VARIABLE then return
    '' ONLY A DECLARATION THAT WAS WRITTEN -- see NF_DECL_WRITTEN. A lambda's capture
    '' prologue is a 'var' per captured name, built after the body and prepended to
    '' it, and every one of them shadows the outer variable it captures: judged by
    '' node id they are born after the body that reads them, which hid all four
    '' closure tests' captures behind fresh implicit locals.
    if (dflags and Tko.NF_DECL_WRITTEN) = 0 then return
    dim as Tko.SymScope ptr ss = w.syms->ScopeAt( scope_ )
    if ss = 0 then return
    select case cast( Tko.ScopeKind, ss->kind )
    case Tko.SCOPEK_PROC, Tko.SCOPEK_BLOCK
    case else
        return
    end select

    '' FROM THE PARENT, so the declaration just made does not find itself.
    dim as Tko.Symbol ptr os = w.syms->SymbolAt( w.syms->Lookup( ss->parent, nm ) )
    if os = 0 then return
    select case cast( Tko.SymbolKind, os->kind )
    case Tko.SYM_VARIABLE, Tko.SYM_PARAMETER, Tko.SYM_CONSTANT, Tko.SYM_ENUMCONST
        '' THE LOWEST NODE THIS DECLARATION OWNS, not the statement that holds it.
        '' An arena is filled bottom-up, so a declaration's own parts all sit BELOW it:
        '' Resolve walks an initializer as a statement in its own right and drops
        '' 'usePos' to it, and against the statement's id that read as 'not yet born',
        '' which sent 'dim as long v = v + 1' to the OUTER v and printed 12 where fbc
        '' prints 1. Everything parsed for the previous statement is lower still, so
        '' the two sides do not overlap.
        w.syms->ShadowFrom( sid, cast( ulong, lo ) )
    end select
end sub

'' THE KEY A LABEL IS DECLARED UNDER, which no ordinary name can spell.
function LabelKey_( byref names as Tko.Interner, byval nm as Tko.InternId ) as Tko.InternId
    return names.GetString( "$label:" & names.Spelling( names.Fold( nm ) ) )
end function

'' A LABEL IS IN A NAMESPACE OF ITS OWN. Measured on fbc-modern 1.20, 2026-09-25: a label
'' may share its name with a local, a parameter, a shared variable, a constant or a type,
'' in the same procedure or around it, and the name still means the variable -- only a
'' SECOND LABEL of the name is error 4. tiko declared labels as ordinary names, so
''
''     dim zz as long : zz : print "now"          TKO0600 where fbc prints now
''     sub u( byval prm as long ) : prm:          TKO0600
''     dim shared kk as long -- in a sub, 'kk:' then 'kk = 5'
''                                                the LABEL took the assignment and the
''                                                program printed 0 where fbc prints 5
''     const CC = 3 -- in a sub, 'CC:' then 'print CC'   left out of the program
''
'' It is declared under LabelKey_ instead, which no lookup of a written name can reach.
'' 'goto' never looked it up: labels are matched by name when lowered.
''
'' AND IN THE PROCEDURE, not the block it is written in: fbc's labels are procedure-wide,
'' so 'dd:' in one 'scope' block and 'dd:' in another is error 4 (measured). Every lookup
'' walks outward, so a use inside any block of the procedure still finds it.
sub DeclareLabel_( byref w as Walker, byval scope_ as Tko.ScopeId, byval id as Tko.NodeId )
    dim as Tko.InternId nm = StmtOf( w, id )->name
    if nm = Tko.INTERN_NONE then return
    dim as Tko.SourceLoc loc = w.ast->Loc( id )
    for guard as long = 0 to 4095
        dim as Tko.SymScope ptr ss = w.syms->ScopeAt( scope_ )
        if ss = 0 then exit for
        if ss->kind <> Tko.SCOPEK_BLOCK then exit for
        if ss->parent = Tko.SCOPE_NONE then exit for
        scope_ = ss->parent
    next
    dim as boolean dup = false
    dim as Tko.SymbolId sid = w.syms->DeclareSym( scope_, LabelKey_( *w.names, nm ), _
                                                   Tko.SYM_LABEL, loc, dup )
    if dup = false then return
    w.duplicates += 1
    w.diags->Report( Tko.TKO0600, Tko.PointRange( loc ), w.names->Spelling( nm ) )
    dim as Tko.Symbol ptr prev = w.syms->SymbolAt( sid )
    if prev <> 0 then w.diags->AddNote( Tko.TKO0901, Tko.PointRange( prev->loc ) )
end sub

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

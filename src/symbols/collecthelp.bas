'' collecthelp.bas -- Collect's helpers after WalkNode: arity, overload spreading, member
'' definitions, call conventions, and the builtin declarations Run makes. Moved out of
'' collect.bas verbatim on 2026-09-27 for the 1500-line cap. #included by collect.bas IN
'' PLACE, where the block stood, inside the same namespace.

'' How many parameters a procedure declaration writes.
private function ProcArity _
    ( byref w as Walker, byval sp as Tko.StmtPayload ptr ) as long

    dim as long n = 0
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, w.ast->children[sp->first + i] )
        if w.ast->Kind( prm ) = Tko.N_PARAM then n += 1
    next
    return n
end function


'' Give every declaration of this name the OVERLOAD flag if any of them has it.
''
'' The flag decides how the name MANGLES, and fbc mangles them all alike: the keyword
'' is written once, usually on the header's declaration, and the definition in the
'' implementation file does not repeat it.
private sub SpreadOverloadFlag_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval id as Tko.NodeId )

    if nm = 0 then return
    dim as boolean any_ = ((StmtOf( w, id )->extra and Tko.PF_OVERLOAD) <> 0)
    dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (pn <> 0) then
            if w.ast->Kind( pn ) = Tko.N_PROC then
                if (StmtOf( w, pn )->extra and Tko.PF_OVERLOAD) <> 0 then any_ = true
            end if
        end if
        cur = s->nextOverload
    wend
    if any_ = false then return

    StmtOf( w, id )->extra or= Tko.PF_OVERLOAD
    cur = w.syms->LookupLocal( scope_, nm )
    guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (pn <> 0) then
            if w.ast->Kind( pn ) = Tko.N_PROC then
                StmtOf( w, pn )->extra or= Tko.PF_OVERLOAD
            end if
        end if
        cur = s->nextOverload
    wend
end sub

'' The DECLARATION a member DEFINITION belongs to, chosen out of the overload set by
'' signature rather than taken from the head of the chain.
''
'' Collect runs before types exist, so the only thing there is to compare is what was
'' WRITTEN: the arity, and the return type reference. That separates the two cast
'' operators that motivated this, and every overload set it cannot separate falls back
'' to the head -- which is what it did for all of them before.
''
'' UNIQUELY OR NOT AT ALL. Two declarations of the same arity and the same return type
'' differ only in their parameter types, which cannot be compared here, so picking
'' either would be a guess and the guess would move a body onto the wrong symbol.
private function MemberDeclForDef_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr ) as Tko.SymbolId

    dim as Tko.SymbolId head = w.syms->LookupLocal( scope_, nm )
    if head = Tko.SYMBOL_NONE then return head
    dim as long want = ProcArity( w, sp )
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    dim as long hits = 0
    dim as Tko.SymbolId cur = head
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (w.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr dp = StmtOf( w, pn )
            if ProcArity( w, dp ) = want then
                if SameSignature_( w, dp, sp, scope_ ) then
                    found = cur
                    hits += 1
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if hits = 1 then return found
    return head
end function

'' The one DECLARED-but-not-yet-defined overload of this name with the definition's
'' arity, or SYMBOL_NONE when there is not exactly one.
''
'' Arity, not the full signature: Collect runs before any type is resolved, so it cannot
'' compare parameter TYPES. Requiring exactly one candidate is what keeps that
'' approximation safe -- two same-arity overloads leave the definition to declare itself,
'' which is the behaviour this replaces rather than a new way to be wrong.
'' ...AND IN AN OVERLOAD SET, not one it certainly differs from (CertainlyDifferentParams_):
'' there fbc takes the definition as a NEW overload. 'declare sub g overload( byval a as
'' long )' then 'sub g( byval a as double )' runs under fbc; joined, the body took g(long)'s
'' name and the call to g( 1.5 ) linked to a G(int) nothing defined.
private function UndefinedProcWithArity _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr ) as Tko.SymbolId

    dim as long want = ProcArity( w, sp )
    dim as boolean ovl = ((sp->extra and Tko.PF_OVERLOAD) <> 0) orelse _
                         (sp->op = cast( ushort, Tko.KW_OPERATOR ))
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    dim as long hits = 0
    dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        dim as boolean isProc = (pn <> Tko.NODE_NONE) andalso (pn <> 0)
        if isProc then isProc = (w.ast->Kind( pn ) = Tko.N_PROC)
        if isProc then
            if (StmtOf( w, pn )->extra and Tko.PF_OVERLOAD) <> 0 then ovl = true
            if (s->flags and Tko.SYMF_DEFINED) = 0 then
                if ProcArity( w, StmtOf( w, pn ) ) = want then
                    found = cur
                    hits += 1
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if hits <> 1 then return Tko.SYMBOL_NONE
    if ovl then
        dim as Tko.NodeId fn = cast( Tko.NodeId, w.syms->SymbolAt( found )->payload )
        if CertainlyDifferentParams_( w, StmtOf( w, fn ), sp ) then return Tko.SYMBOL_NONE
    end if
    return found
end function

'' The calling convention across a DECLARE and its definition. The rule is ASYMMETRIC,
'' and measured on both targets rather than reasoned about:
''
''   declare cdecl  + definition (none)     inherits cdecl, emits '_A' on win32
''   declare (none) + definition stdcall    accepted -- ABSENT MEANS STDCALL
''   declare (none) + definition cdecl      error 41
''   declare (none) + definition pascal     error 41
''
'' So absence on the DEFINITION inherits, while absence on the DECLARATION is stdcall
'' and anything else contradicts it. fbc reports the same error on win64, where the
'' convention has no effect on any emitted name at all, so this is a syntactic rule and
'' not a target one.
private function Effective_( byval c as Tko.CallConv ) as Tko.CallConv
    if c = Tko.CC_NONE then return Tko.CC_STDCALL
    return c
end function

private sub BindCallConv _
    ( byref w as Walker, byval s as Tko.Symbol ptr, _
      byval sp as Tko.StmtPayload ptr, byval id as Tko.NodeId, _
      byval firstSighting as boolean )

    dim as Tko.CallConv here = Tko.CallConvOf( sp->extra )
    if here = Tko.CC_NONE then return
    if firstSighting then
        s->callConv = cast( ubyte, here )
        return
    end if
    dim as Tko.CallConv had = cast( Tko.CallConv, s->callConv )
    if Effective_( had ) = here then
        s->callConv = cast( ubyte, here )
        return
    end if
    '' A header whose '...' the parser refused has had its one error (ParserRefused_).
    if ParserRefused_( w, sp ) then return
    dim as Tko.SourceRange r = Tko.PointRange( w.ast->Loc( id ) )
    w.diags->Report( Tko.TKO0603, r, w.names->Spelling( s->name ) )
    w.diags->AddNote( Tko.TKO0901, Tko.PointRange( s->loc ) )
end sub

'' __FB_ARGC__ AND __FB_ARGV__ (T80) are fbc's MAIN PROCEDURE'S OWN PARAMETERS --
'' fb-main.bas adds them with symbAddProcParam -- so they are visible to the module's
'' top-level code and to nothing else: inside a SUB, fbc reports error 42. Declared
'' as variables of the MODULE scope, which is exactly that visibility here: a
'' module-scope variable is hidden from procedures (resolveunbound.bas). Lowering
'' reads main's parameters for them (lowerexpr.bas, LowerMainArg_); they have no slot.
private sub DeclareMainArg_ _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byval moduleScope as Tko.ScopeId, byval spelling as string, _
      byval t as Tko.TypeId )

    dim as boolean dup = false
    dim as Tko.SymbolId sid = syms.DeclareSym( moduleScope, _
        names.Fold( names.GetString( spelling ) ), Tko.SYM_VARIABLE, Tko.LOC_NONE, dup )
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s <> 0 then s->type_ = t
end sub

private function DeclareGlobal _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref diags as Tko.DiagnosticEngine, byval spelling as string ) as Tko.SymbolId

    dim as boolean dup = false
    return syms.DeclareSym( Tko.SCOPE_GLOBAL, _
                            names.Fold( names.GetString( spelling ) ), _
                            Tko.SYM_CONSTANT, Tko.LOC_NONE, dup )
end function

'' 'true' and 'false' are predeclared CONSTANTS carrying a built-in value: BOOLEAN,
'' and -1 and 0. Every part of that is measured -- 'typeof( true )' is BOOLEAN,
'' 'cint( true )' is -1 and 'sizeof( true )' is 1 -- because a language where a true
'' comparison is -1 is not one where 'true' can be assumed to be 1.
'' __FUNCTION__, whose value depends on WHERE it is used. Collect cannot know that, so
'' it only plants the marker; Check fills in the name and the type.
private sub DeclareFuncName _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref diags as Tko.DiagnosticEngine, byval spelling as string )

    dim as Tko.SymbolId sid = DeclareGlobal( syms, names, diags, spelling )
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s <> 0 then s->flags or= Tko.SYMF_FUNCNAME
end sub

private sub DeclareBuiltinConst _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref types as Tko.TypeContext, byref diags as Tko.DiagnosticEngine, _
      byval spelling as string, byval value as long )

    dim as Tko.SymbolId sid = DeclareGlobal( syms, names, diags, spelling )
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s = 0 then return
    s->flags or= Tko.SYMF_BUILTIN
    s->type_ = types.Builtin( Tko.TY_BOOLEAN )
    s->payload = value
end sub

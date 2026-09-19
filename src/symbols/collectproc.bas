'' collectproc.bas -- MAY THIS PROCEDURE BE DECLARED HERE, AND MAY THIS NAME BE REMOVED?
''
'' Included from collect.bas, inside its own namespace, for the reason collectshape.bas
'' is: the 1500-line lint cap. SameWrittenType_ and SameSignature_ moved here unchanged.
'' The rules are fbc's error 4 for a second declaration (ProcRedeclared_) and a second
'' member body (RefuseSecondBody_), and its error 123 for an '#undef' (UndefKeeps_).

'' Defined in collect.bas, below the include of this file.
declare function LookupDottedOwner_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, _
      byval path as Tko.InternId ) as Tko.SymbolId

'' ONE WRITTEN TYPE REFERENCE AGAINST ANOTHER, strictly.
''
'' NOT SameTypeRef_, which exists to decide whether a RESTATEMENT is legal and answers
'' 'same' whenever it cannot tell -- a named type may be a typedef for the builtin on
'' the other side, and refusing that pair rejects four corpus files. Discriminating an
'' OVERLOAD is the opposite question: 'the same as far as I can see' is not an answer,
'' because acting on it moves a body onto the wrong declaration. So a builtin matches
'' only the same builtin and a name only the same name, and anything it cannot decide
'' is reported as DIFFERENT. A TYPEDEF is not undecidable: its name is its target
'' (UnaliasWritten_), or '_TV' against 'TV' fell back to the head of the chain.
private function SameWrittenType_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId, _
      byval scope_ as Tko.ScopeId ) as boolean

    a = UnaliasWritten_( w, scope_, a )
    b = UnaliasWritten_( w, scope_, b )
    if (a = Tko.NODE_NONE) andalso (b = Tko.NODE_NONE) then return true
    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return false
    if w.ast->Kind( a ) <> Tko.N_TYPEREF then return false
    if w.ast->Kind( b ) <> Tko.N_TYPEREF then return false
    dim as ushort af = w.ast->nodes[cast( long, a )].flags
    dim as ushort bf = w.ast->nodes[cast( long, b )].flags
    dim as ushort mask = Tko.NF_PTR or Tko.NF_CONST or Tko.NF_PROC_TYPE
    if (af and mask) <> (bf and mask) then return false
    dim as Tko.StmtPayload ptr ap = StmtOf( w, a )
    dim as Tko.StmtPayload ptr bp = StmtOf( w, b )
    if ap->op <> bp->op then return false
    if ap->op = cast( ushort, Tko.TK_IDENT ) then
        if ap->name <> bp->name then return false
    end if
    '' PTR nests another N_TYPEREF in 'a', so recursing compares the pointed-to type
    '' and, by arriving at different depths, the pointer depth with it.
    return SameWrittenType_( w, ap->a, bp->a, scope_ )
end function

'' The RETURN TYPE and every PARAMETER TYPE, as written, on two N_PROC payloads whose
'' arities already agree.
private function SameSignature_ _
    ( byref w as Walker, byval a as Tko.StmtPayload ptr, _
      byval b as Tko.StmtPayload ptr, byval scope_ as Tko.ScopeId ) as boolean

    if SameWrittenType_( w, a->a, b->a, scope_ ) = false then return false
    if a->count <> b->count then return false
    for i as long = 0 to a->count - 1
        dim as Tko.NodeId an = cast( Tko.NodeId, w.ast->children[a->first + i] )
        dim as Tko.NodeId bn = cast( Tko.NodeId, w.ast->children[b->first + i] )
        if (w.ast->Kind( an ) <> Tko.N_PARAM) orelse _
           (w.ast->Kind( bn ) <> Tko.N_PARAM) then return false
        if SameWrittenType_( w, StmtOf( w, an )->a, StmtOf( w, bn )->a, scope_ ) = false then
            return false
        end if
    next
    return true
end function

'' A WRITTEN TYPE SameWrittenType_ CANNOT JUDGE, anywhere down its pointer chain: a
'' PROCEDURE type, whose own parameters and result it never compares, and a type with
'' GENERIC arguments, whose arguments it never reads -- 'Box( of long )' and 'Box( of
'' double )' would come out the same. Both are real overload sets in the suite
'' (tests/mangle/extern-cxx, procptr-param-byref, type-shadow-order), and the last adds a
'' third reason: one name spelling two different types either side of a nested TYPE.
private function Undecidable_ _
    ( byref w as Walker, byval t as Tko.NodeId, byval scope_ as Tko.ScopeId ) as boolean

    dim as long guard = 0
    while (t <> Tko.NODE_NONE) andalso (guard < 64)
        guard += 1
        t = UnaliasWritten_( w, scope_, t )
        if t = Tko.NODE_NONE then exit while
        if w.ast->Kind( t ) <> Tko.N_TYPEREF then exit while
        if (w.ast->nodes[cast( long, t )].flags and Tko.NF_PROC_TYPE) <> 0 then return true
        dim as Tko.StmtPayload ptr tp = StmtOf( w, t )
        if tp->count > 0 then return true
        t = tp->a
    wend
    return false
end function

'' ARE TWO DECLARATIONS ONE OVERLOAD, as fbc decides it? Measured 2026-09-18, fbc-modern
'' 1.20 and 1.10.1 answering identically:
''
''     byval a as long    against  byref a as long        the same     error 4
''     a as long          against  byval a as long        the same     error 4
''     a( ) as long       against  b( ) as long           the same     error 4
''     a( any ) as long   against  a( ) as long           the same     error 4
''     a( any ) as long   against  a( any, any ) as long  different
''     a( ) as long       against  byval a as long        different
''     a( ) as long       against  a( ) as double         different
''     byval a as long    against  byval a as long ptr    different
''     ... as long        against  ... as double          the same     error 4
''     operator cast( ) as long   against  ... as string  different
''     property p( byval x as long )  against  property p( byval i as long ) as long
''                                                        different -- setter, getter
''
'' So the passing MODE never distinguishes, an array descriptor always does, and the
'' RESULT only does on a CAST or a PROPERTY: a cast overloads on nothing else, and an
'' indexed getter has exactly a plain setter's parameters. An array's RANK does, but
'' '( )' is an UNKNOWN rank and collides with any: two known ranks differ only when
'' they are unequal. The types go through SameWrittenType_, which says DIFFERENT
'' whenever it cannot tell -- so a CONST-only pair is left to the late sweep, which has
'' the passing mode resolved (ByvalConstTwin_). Missing a duplicate here costs fbc's
'' error message; inventing one costs a program fbc compiles.
private function SameOverloadIdentity_ _
    ( byref w as Walker, byval a as Tko.StmtPayload ptr, _
      byval b as Tko.StmtPayload ptr, byval scope_ as Tko.ScopeId, _
      byval byResult as boolean ) as boolean

    if byResult then
        if Undecidable_( w, a->a, scope_ ) orelse Undecidable_( w, b->a, scope_ ) then return false
        if SameWrittenType_( w, a->a, b->a, scope_ ) = false then return false
    end if
    if a->count <> b->count then return false
    for i as long = 0 to a->count - 1
        dim as Tko.NodeId an = cast( Tko.NodeId, w.ast->children[a->first + i] )
        dim as Tko.NodeId bn = cast( Tko.NodeId, w.ast->children[b->first + i] )
        if (w.ast->Kind( an ) <> Tko.N_PARAM) orelse _
           (w.ast->Kind( bn ) <> Tko.N_PARAM) then return false
        dim as Tko.StmtPayload ptr ap = StmtOf( w, an )
        dim as Tko.StmtPayload ptr bp = StmtOf( w, bn )
        '' An ELLIPSIS is a parameter marked in 'op', with no type of its own.
        dim as boolean aEll = (ap->op = cast( ushort, Tko.TK_ELLIPSIS ))
        dim as boolean bEll = (bp->op = cast( ushort, Tko.TK_ELLIPSIS ))
        if aEll <> bEll then return false
        dim as boolean aArr = ((w.ast->nodes[cast( long, an )].flags and Tko.NF_ARRAY) <> 0)
        dim as boolean bArr = ((w.ast->nodes[cast( long, bn )].flags and Tko.NF_ARRAY) <> 0)
        if aArr <> bArr then return false
        '' The RANK an array parameter spelled, 0 for 'a( )' -- see ParseParam. Unknown
        '' collides with any rank; two known ranks only with each other.
        if (ap->extra <> 0) andalso (bp->extra <> 0) then
            if ap->extra <> bp->extra then return false
        end if
        if Undecidable_( w, ap->a, scope_ ) orelse Undecidable_( w, bp->a, scope_ ) then return false
        if SameWrittenType_( w, ap->a, bp->a, scope_ ) = false then return false
    next
    return true
end function

'' A PROCEDURE NAME IS DECLARED ONCE PER SCOPE, and fbc holds to it: error 4,
'' "Duplicated definition", on ANY second DECLARE of a name already declared or defined
'' in the same scope. Measured 2026-09-18 on fbc-modern 1.20 and 1.10.1, 34 shapes, the
'' two agreeing on every one: byte-identical or not; differing in parameters, result,
'' ALIAS, LIB or calling convention; SUB against FUNCTION; inside one EXTERN block, or
'' one inside and one out; and a NAMESPACE reopened. tiko-lang accepted all of them and
'' chained the second as an overload -- which is how AfxNova's AfxExt.bi compiled here
'' while fbc refused it on 25 user32 declarations win/winuser.bi had already made.
''
'' WHAT IS ALLOWED, all measured:
''   - an OVERLOAD set takes a new signature (SameOverloadIdentity_). The keyword has to
''     be on the FIRST declaration: 'declare f' then 'declare f overload( ... )' is
''     error 4, while the reverse needs no second keyword.
''   - a TYPE'S MEMBERS and an OPERATOR overload by signature, with no keyword at all --
''     constructors, properties and 'operator let' included.
''   - a DEFINITION after its DECLARATION is the join, not a second declaration; only a
''     second BODY collides. Finding the declaration is UndefinedProcWithArity's job, and
''     this is asked only when it found none.
''   - '#undef' removes a declared procedure -- ONE overload each, the first declared,
''     measured with a two-overload set -- and a name so removed may be declared again.
''     UndefSym stamps 'diedAt', so a symbol that carries one is not here any more.
''   - the PRELUDE's declarations are Declare_'s to reconcile: a header may replace one.
''
'' AND WHERE IT IS NOT ASKED: GENERICS. A generic template shares its name with ordinary
'' overloads in fbc-modern's own headers -- fb/array.bi's 'Contains( of T )' beside
'' fb/string.bi's 'Contains overload' -- and that pairing has not been measured, so a name
'' with a template anywhere in play is left alone. An INSTANTIATION arrives through
'' Collect.One, the only walk with no source manager, and may be collected more than once
'' for one key; it is a copy of something already judged.
''
'' The earlier symbol this collides with, or SYMBOL_NONE. 'asOverload' says whether the
'' name was an overload set, which decides how the collision is worded.
private function ProcRedeclared_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr, byval loc as Tko.SourceLoc, _
      byref asOverload as boolean ) as Tko.SymbolId

    asOverload = false
    if nm = Tko.INTERN_NONE then return Tko.SYMBOL_NONE
    if w.src = 0 then return Tko.SYMBOL_NONE
    if w.src->IsBuiltin( loc ) then return Tko.SYMBOL_NONE
    if (sp->extra and Tko.PF_GENERIC_PROC) <> 0 then return Tko.SYMBOL_NONE
    '' ONLY A HEADER THAT PARSED. One the parser recovered from after a syntax error --
    '' 'declare virtual const sub b1( )' -- carries the stray modifier where the procedure
    '' keyword belongs and names itself 'sub', and fbc's syntax error is the message there:
    '' two of them are not a redeclaration (tests/diagnostics/virtual-placement).
    dim as boolean isProcKw = false
    select case cast( Tko.TokenKind, sp->op )
    case Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_PROPERTY, Tko.KW_OPERATOR, _
         Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
        isProcKw = true
    end select
    if isProcKw = false then return Tko.SYMBOL_NONE

    '' THE LIVE GENERATION, whatever position a walk last set: a declaration is always
    '' the newest thing so far. Same judgement as DeclareSym's.
    dim as ulong savePos = w.syms->usePos
    w.syms->usePos = Tko.USEPOS_LATEST
    dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    w.syms->usePos = savePos
    dim as Tko.Symbol ptr hs = w.syms->SymbolAt( cur )
    if hs = 0 then return Tko.SYMBOL_NONE
    '' A TYPE may share the spelling; its procedures are then its partner.
    if hs->kind <> cast( ubyte, Tko.SYM_PROC ) then cur = hs->altClass

    '' A TEMPLATE ANYWHERE in the set, and the name is not judged at all -- see above.
    dim as long guard = 0
    dim as Tko.SymbolId scan = cur
    while (scan <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr g = w.syms->SymbolAt( scan )
        if g = 0 then exit while
        if g->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId gn = cast( Tko.NodeId, g->payload )
        if (gn <> Tko.NODE_NONE) andalso (gn <> 0) then
            if w.ast->Kind( gn ) = Tko.N_PROC then
                if (StmtOf( w, gn )->extra and Tko.PF_GENERIC_PROC) <> 0 then return Tko.SYMBOL_NONE
            end if
        end if
        scan = g->nextOverload
    wend

    dim as Tko.SymScope ptr sc = w.syms->ScopeAt( scope_ )
    dim as boolean isMember = false
    if sc <> 0 then isMember = (sc->kind = cast( ubyte, Tko.SCOPEK_TYPE ))
    dim as boolean isOperator = (sp->op = cast( ushort, Tko.KW_OPERATOR ))
    dim as boolean byResult = (sp->op = cast( ushort, Tko.KW_PROPERTY ))
    if isOperator then byResult = (lcase( w.names->Spelling( nm ) ) = "cast")
    dim as boolean isDef = (sp->b <> Tko.NODE_NONE)
    dim as boolean overloadable = isMember orelse isOperator
    dim as boolean sawFirst = false

    guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        dim as boolean here_ = (s->diedAt = 0) andalso (s->parent = scope_)
        dim as boolean hasDecl = (pn <> Tko.NODE_NONE) andalso (pn <> 0)
        if hasDecl then hasDecl = (w.ast->Kind( pn ) = Tko.N_PROC)
        dim as boolean candidate = here_ andalso hasDecl
        if w.src->IsBuiltin( s->loc ) then candidate = false
        if candidate then
            dim as Tko.StmtPayload ptr dp = StmtOf( w, pn )
            '' The FIRST declaration decides -- before the keyword can have spread.
            if sawFirst = false then
                sawFirst = true
                if (dp->extra and Tko.PF_OVERLOAD) <> 0 then overloadable = true
            end if
            dim as boolean same = true
            if overloadable then same = SameOverloadIdentity_( w, dp, sp, scope_, byResult )
            '' A DECLARE collides with either; a DEFINITION only with another body.
            dim as boolean collides = ((s->flags and Tko.SYMF_DEFINED) <> 0)
            if isDef = false then collides = true
            if same andalso collides then
                asOverload = overloadable
                return cur
            end if
        end if
        cur = s->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' THE STATEMENT HAS HAD ITS ERROR when the parser refused its '...' -- fbc's 312, see
'' PARAM_VARARG_REFUSED -- because fbc reports one error per statement. Measured: 'declare
'' sub f stdcall overload( byval a as long, ... )' is 312 alone, and so is the second of
'' two identical non-cdecl variadic declarations. What the refusals below DO still
'' happens -- a variadic OVERLOAD is still forgotten, a variadic member alone still
'' blocks the member after it (fbc: 312, then 4 on the next line) -- only the report goes.
private function ParserRefused_ _
    ( byref w as Walker, byval sp as Tko.StmtPayload ptr ) as boolean
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId pn = cast( Tko.NodeId, w.ast->children[sp->first + i] )
        if w.ast->Kind( pn ) = Tko.N_PARAM then
            dim as Tko.StmtPayload ptr pp = StmtOf( w, pn )
            if pp->op = cast( ushort, Tko.TK_ELLIPSIS ) then
                return (pp->extra = Tko.PARAM_VARARG_REFUSED)
            end if
        end if
    next
    return false
end function

'' ProcRedeclared_, REPORTED. The caller binds the refused declaration to the symbol this
'' returns rather than chaining a twin beside it, so no call site becomes ambiguous
'' behind the one error fbc would have given.
private function RefuseRedeclaration_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr, byval loc as Tko.SourceLoc ) as Tko.SymbolId

    dim as boolean asOverload = false
    dim as Tko.SymbolId prev = ProcRedeclared_( w, scope_, nm, sp, loc, asOverload )
    dim as Tko.Symbol ptr ps = w.syms->SymbolAt( prev )
    if ps = 0 then return Tko.SYMBOL_NONE
    w.duplicates += 1
    if ParserRefused_( w, sp ) then return prev
    '' A structor is declared under a synthetic name ('__ctor'); the message says what
    '' was written.
    dim as string shown = w.names->Spelling( nm )
    if sp->op = cast( ushort, Tko.KW_CONSTRUCTOR ) then shown = "constructor"
    if sp->op = cast( ushort, Tko.KW_DESTRUCTOR ) then shown = "destructor"
    if asOverload then
        w.diags->Report( Tko.TKO0677, Tko.PointRange( loc ), shown )
    else
        w.diags->Report( Tko.TKO0600, Tko.PointRange( loc ), shown )
    end if
    w.diags->AddNote( Tko.TKO0901, Tko.PointRange( ps->loc ) )
    return prev
end function

'' A PROCEDURE WITH '...' IS NEVER AN OVERLOAD -- fbc's error 143, "Vararg parameters are
'' not allowed in overloaded functions", which it reports as error 4 for anything but a
'' constructor. Measured 2026-09-18, 1.20 and 1.10.1 agreeing on twenty shapes:
''
''     'declare sub f cdecl overload( byval a as long, ... )', ALONE      refused, there
''     ...a definition, a member, in a namespace, in 'extern "C"'        refused, there
''     a variadic joining an overload set, keyword or not                refused, there
''     a set member declared beside a variadic MEMBER                     refused, there
''     any variadic CONSTRUCTOR -- constructors are always overloads      refused, there
''     a variadic declared plainly, a member one alone                    accepted
''     its definition, even written 'overload'                           accepted: a join
''
'' And fbc forgets the refused one: a set declared after a refused variadic OVERLOAD is
'' not refused in turn. So a refused DECLARATION declares nothing -- the caller reads
'' SYMBOL_NONE as that, as for the prelude. A refused DEFINITION keeps its symbol, because
'' a body has to belong to something.
''
'' Asked only of a procedure that is not a redeclaration and not joining its declaration.
'' True when refused, reported.
private function RefuseVariadicOverload_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr, byval loc as Tko.SourceLoc ) as boolean

    if nm = Tko.INTERN_NONE then return false
    if w.src = 0 then return false
    if w.src->IsBuiltin( loc ) then return false
    if (sp->extra and Tko.PF_GENERIC_PROC) <> 0 then return false

    '' Does a declaration take '...'? The ellipsis is a parameter marked in 'op'.
    #macro VARIADIC_( _p_, _out_ )
        _out_ = false
        for vi as long = 0 to (_p_)->count - 1
            dim as Tko.NodeId vn = cast( Tko.NodeId, w.ast->children[(_p_)->first + vi] )
            if w.ast->Kind( vn ) = Tko.N_PARAM then
                if StmtOf( w, vn )->op = cast( ushort, Tko.TK_ELLIPSIS ) then _out_ = true
            end if
        next
    #endmacro

    dim as boolean isVar
    VARIADIC_( sp, isVar )
    dim as boolean isCtor = (sp->op = cast( ushort, Tko.KW_CONSTRUCTOR ))
    dim as boolean refuse = isVar andalso isCtor

    if refuse = false then
        '' The live set this would join, as ProcRedeclared_ reads it.
        dim as long members = 0
        dim as boolean anyVar = false
        dim as ulong savePos = w.syms->usePos
        w.syms->usePos = Tko.USEPOS_LATEST
        dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
        w.syms->usePos = savePos
        dim as Tko.Symbol ptr hs = w.syms->SymbolAt( cur )
        if hs <> 0 then
            if hs->kind <> cast( ubyte, Tko.SYM_PROC ) then cur = hs->altClass
        end if
        dim as long guard = 0
        while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
            guard += 1
            dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
            if s = 0 then exit while
            if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            dim as boolean live = (s->diedAt = 0) andalso (s->parent = scope_)
            dim as boolean hasDecl = (pn <> Tko.NODE_NONE) andalso (pn <> 0)
            if hasDecl then hasDecl = (w.ast->Kind( pn ) = Tko.N_PROC)
            if w.src->IsBuiltin( s->loc ) then live = false
            if live andalso hasDecl then
                dim as Tko.StmtPayload ptr dp = StmtOf( w, pn )
                '' A template in the set and the name is not judged -- see ProcRedeclared_.
                if (dp->extra and Tko.PF_GENERIC_PROC) <> 0 then return false
                members += 1
                dim as boolean dv
                VARIADIC_( dp, dv )
                if dv then anyVar = true
            end if
            cur = s->nextOverload
        wend
        if members = 0 then
            '' Alone: refused only when the keyword is written on it.
            if isVar then refuse = ((sp->extra and Tko.PF_OVERLOAD) <> 0)
        else
            '' Joining a set: refused when either side takes '...'.
            refuse = isVar orelse anyVar
        end if
    end if
    #undef VARIADIC_

    if refuse = false then return false
    w.duplicates += 1
    if ParserRefused_( w, sp ) then return true
    dim as string shown = w.names->Spelling( nm )
    if isCtor then shown = "constructor"
    w.diags->Report( Tko.TKO0780, Tko.PointRange( loc ), shown )
    return true
end function

'' A MEMBER'S BODY IS WRITTEN ONCE. 'sub T.m( )' twice is fbc's error 4 at the second --
'' and so is a constructor, a destructor, a property, an 'operator let', a static
'' member and 'sub ns.T.m( )' written twice: measured 2026-09-18 on 1.20 and 1.10.1.
'' tiko-lang gave both bodies to the one declaration and left clang to refuse the
'' duplicate symbol. Each overload written once, a getter beside its setter, and two
'' same-arity overloads of different types all compile, and must.
''
'' The declaration has to be found UNIQUELY -- arity and every written type, as
'' SameSignature_ compares them -- because MemberDeclForDef_ falls back to the head of the
'' chain when it cannot choose. That fallback is right for binding a scope and wrong for a
'' verdict: two definitions of two different overloads would both land on the head.
''
'' True when this definition is a second body, reported.
private function RefuseSecondBody_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr, byval loc as Tko.SourceLoc ) as boolean

    if nm = Tko.INTERN_NONE then return false
    '' An instantiation, as in ProcRedeclared_: a copy of something already judged.
    if w.src = 0 then return false
    if sp->b = Tko.NODE_NONE then return false
    if (sp->extra and Tko.PF_GENERIC_PROC) <> 0 then return false

    dim as long want = ProcArity( w, sp )
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    dim as long hits = 0
    dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        dim as boolean hasDecl = (pn <> Tko.NODE_NONE) andalso (pn <> 0)
        if hasDecl then hasDecl = (w.ast->Kind( pn ) = Tko.N_PROC)
        if hasDecl then
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
    if hits <> 1 then return false

    dim as Tko.Symbol ptr fs = w.syms->SymbolAt( found )
    if (fs->flags and Tko.SYMF_MEMBER_BODY) = 0 then
        fs->flags or= Tko.SYMF_MEMBER_BODY
        return false
    end if
    w.duplicates += 1
    dim as string shown = w.names->Spelling( nm )
    if sp->op = cast( ushort, Tko.KW_CONSTRUCTOR ) then shown = "constructor"
    if sp->op = cast( ushort, Tko.KW_DESTRUCTOR ) then shown = "destructor"
    w.diags->Report( Tko.TKO0600, Tko.PointRange( loc ), shown )
    w.diags->AddNote( Tko.TKO0901, Tko.PointRange( fs->loc ) )
    return true
end function

'' AN '#undef' MAY NOT REMOVE WHAT A NAMESPACE DECLARED -- fbc's error 123, "Symbols
'' defined inside namespaces cannot be removed". Measured 2026-09-18, 1.20 and 1.10.1
'' agreeing:
''
''     inside the namespace: a sub, a variable, a type, a const        error 123
''     inside a NESTED namespace                                       error 123
''     '#undef ns.name'                                                error 123
''     at module level, the name reached through 'using ns'           error 123
''     inside a namespace, of a GLOBAL name                            accepted
''     of the namespace itself, of a macro, of a name nothing declared  accepted
''
'' The 'using' row is Resolve's, which is where a USING is registered: when the lookup
'' here finds nothing, 'extra' = 1 on the node says so, and Resolve asks the usings.
''
'' True when this '#undef' must remove nothing: refused and reported, or a DOTTED name,
'' which never removes anything -- only its first component used to arrive, and
'' '#undef ns.name' removed the NAMESPACE.
private function UndefKeeps_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval up as Tko.StmtPayload ptr, _
      byval loc as Tko.SourceLoc ) as boolean

    dim as Tko.SymbolId hit = Tko.SYMBOL_NONE
    dim as boolean dotted = (up->ownerName <> 0)
    dim as string shown = w.names->Spelling( up->name )
    if dotted then
        shown = w.names->Spelling( up->ownerName ) & "." & shown
        dim as Tko.Symbol ptr os = _
            w.syms->SymbolAt( LookupDottedOwner_( w, scope_, up->ownerName ) )
        if os <> 0 then
            if os->kind = cast( ubyte, Tko.SYM_NAMESPACE ) then
                if os->inner <> Tko.SCOPE_NONE then
                    hit = w.syms->LookupInNamespace( os->inner, up->name )
                end if
            end if
        end if
    else
        '' The first symbol a lookup from here finds, as UndefSym takes it.
        dim as ulong savePos = w.syms->usePos
        w.syms->usePos = Tko.USEPOS_LATEST
        dim as Tko.ScopeId sc = scope_
        dim as long guard = 0
        while (sc <> Tko.SCOPE_NONE) andalso (guard < 1024)
            guard += 1
            hit = w.syms->LookupLocal( sc, up->name )
            if hit <> Tko.SYMBOL_NONE then exit while
            dim as Tko.SymScope ptr s_ = w.syms->ScopeAt( sc )
            if s_ = 0 then exit while
            sc = s_->parent
        wend
        w.syms->usePos = savePos
        if hit = Tko.SYMBOL_NONE then up->extra = 1
    end if

    dim as Tko.Symbol ptr hs = w.syms->SymbolAt( hit )
    if hs = 0 then return dotted
    dim as Tko.SymScope ptr ps = w.syms->ScopeAt( hs->parent )
    dim as boolean inNs = false
    if ps <> 0 then inNs = (ps->kind = cast( ubyte, Tko.SCOPEK_NAMESPACE ))
    if inNs = false then return dotted
    w.diags->Report( Tko.TKO0779, Tko.PointRange( loc ), shown )
    w.diags->AddNote( Tko.TKO0901, Tko.PointRange( hs->loc ) )
    return true
end function

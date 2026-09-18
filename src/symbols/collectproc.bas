'' collectproc.bas -- MAY THIS PROCEDURE BE DECLARED HERE?
''
'' Included from collect.bas, inside its own namespace, for the reason collectshape.bas
'' is: the 1500-line lint cap. SameWrittenType_ and SameSignature_ moved here unchanged;
'' the redeclaration rule below is new.

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
'' indexed getter has exactly a plain setter's parameters. Rank is compared too,
'' unmeasured, because answering DIFFERENT is the safe side here: the types go through
'' SameWrittenType_, which says DIFFERENT whenever it cannot tell -- so 'byval a as
'' const long' against 'byval a as long', a duplicate to fbc, is let through. Missing a
'' duplicate costs fbc's error message; inventing one costs a program fbc compiles.
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
        '' The RANK an array parameter spelled, 0 for 'a( )' -- see ParseParam.
        if ap->extra <> bp->extra then return false
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

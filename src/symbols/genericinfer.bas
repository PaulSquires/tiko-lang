'' genericinfer.bas -- INFERRING A TYPE ARGUMENT FROM A CALL'S OWN ARGUMENTS.
''
'' Split out of generic.bas at the 1500-line cap and included from it in the same
'' place. Nothing in it changed in the move.

'' THE TYPE OF ONE ARGUMENT, well enough to infer a type parameter from it -- which is
'' much less than typing an expression. Check does that, and Check has not run.
''
'' A NAME and a LITERAL are the two shapes worth knowing, because they are the two the
'' runtime headers pass: 'Some( r )' over a local, and 'Some( 3 )' over a literal. A
'' REFERENCE is transparent -- 'byval v as T' called with a byref parameter binds T to
'' the referent, not to a reference. Anything else returns TYPE_NONE, and the call then
'' declines rather than instantiating at a guessed type.
'' THE PROCEDURE-POINTER TYPE OF A NAME, built from the procedure's own
'' declaration. Check has a routine for this and it is in another namespace with
'' another Ctx; this one resolves the typerefs itself, which is what Resolve is
'' for and what makes it usable BEFORE Check has typed anything.
''
'' AN OVERLOADED NAME IS REFUSED. Choosing between overloads is overload
'' resolution, which runs later and with the parameter type in hand; picking one
'' here would be a guess, and a wrong instantiation is worse than none.
private function ProcPtrTypeOfName_ _
    ( byref c as Ctx, byval n as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.TypeId

    if n = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( n ) <> Tko.N_IDENT then return Tko.TYPE_NONE
    dim as Tko.InternId nm = IdentNameOf( c, n )
    if nm = 0 then return Tko.TYPE_NONE
    dim as Tko.SymbolId sid = c.syms->Lookup( scope_, nm )
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( sid )
    if sy = 0 then return Tko.TYPE_NONE
    if sy->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.TYPE_NONE
    if sy->nextOverload <> Tko.SYMBOL_NONE then return Tko.TYPE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, sy->payload )
    if pn = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    '' A GENERIC PROCEDURE HAS NO ONE TYPE. Its parameters name type parameters,
    '' so resolving them here would bind whatever those names happen to mean.
    if (pp->extra and Tko.PF_GENERIC_PROC) <> 0 then return Tko.TYPE_NONE

    dim as Tko.ScopeId psc = sy->parent
    if psc = Tko.SCOPE_NONE then psc = scope_
    dim as Tko.TypeId ret = c.types->Builtin( Tko.TY_VOID )
    if pp->a <> Tko.NODE_NONE then
        ret = ResolveTypeRef( c, pp->a, psc )
        if ret = Tko.TYPE_NONE then return Tko.TYPE_NONE
    end if
    dim as Tko.TypeIdVec2 ps
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        dim as Tko.TypeId pt = ResolveTypeRef( c, StmtOf( c, prm )->a, psc )
        if pt = Tko.TYPE_NONE then return Tko.TYPE_NONE
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then
            pt = c.types->Reference( pt )
        end if
        ps.Push( cast( ulong, pt ) )
    next
    '' A PROCEDURE TYPE IS ALREADY A POINTER in FreeBASIC -- 'sub( ) ptr' is PPFvvE,
    '' one P for the type and one for the written 'ptr' -- so the pointer is built
    '' in here, exactly as ResolveTypeRef does for a written signature.
    return c.types->Pointer_( c.types->ProcType( ret, ps ) )
end function

private function InferArgType_ _
    ( byref c as Ctx, byval a as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.TypeId

    if a = Tko.NODE_NONE then return Tko.TYPE_NONE
    select case c.ast->Kind( a )
    case Tko.N_PAREN
        dim as Tko.ListPayload ptr lp = ListOf( c, a )
        if lp->count <> 1 then return Tko.TYPE_NONE
        return InferArgType_( c, cast( Tko.NodeId, c.ast->children[lp->first] ), scope_ )
    case Tko.N_IDENT
        dim as Tko.InternId nm = IdentNameOf( c, a )
        if nm = 0 then return Tko.TYPE_NONE
        dim as Tko.Symbol ptr sy = c.syms->SymbolAt( c.syms->Lookup( scope_, nm ) )
        if sy = 0 then return Tko.TYPE_NONE
        '' A PARAMETER too. Inside a macro-expanded 'AbsChecked( byval a as T )' the
        '' argument to 'Some( a )' IS the parameter, which is most of what the checked
        '' arithmetic family passes.
        if (sy->kind <> cast( ubyte, Tko.SYM_VARIABLE )) andalso _
           (sy->kind <> cast( ubyte, Tko.SYM_PARAMETER )) then return Tko.TYPE_NONE
        dim as Tko.TypeId t = sy->type_
        if t = Tko.TYPE_NONE then return Tko.TYPE_NONE
        if c.types->Kind( t ) = Tko.TK_REFERENCE then t = c.types->Inner( t )
        return t
    case Tko.N_CALL
        '' 'Some( cast( T, a \ b ) )' -- A CONVERSION NAMES ITS OWN TYPE, which is
        '' the whole answer and needs no expression typing at all. The corpus writes it
        '' more often than it writes a bare name: every narrowing result in the checked
        '' arithmetic family is a cast.
        dim as Tko.ListPayload ptr cp = ListOf( c, a )
        if cp->target = Tko.NODE_NONE then return Tko.TYPE_NONE

        '' A QUALIFIED CALLEE IS STILL A CALLEE, here as in InstantiateGenericProc_:
        '' 'Some( FB.CurrencyFromRaw( r ) )' names the inner procedure through its
        '' NAMESPACE, so the target is an N_MEMBER and this answered nothing -- which
        '' made the OUTER generic uninferrable and declined the whole statement.
        dim as Tko.NodeId ctgt = cp->target
        dim as Tko.ScopeId cscope = scope_
        dim as boolean cqual = false
        if c.ast->Kind( ctgt ) = Tko.N_MEMBER then
            dim as Tko.BinaryPayload ptr cqb = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, ctgt )].data )]
            if c.ast->Kind( cqb->lhs ) <> Tko.N_IDENT then return Tko.TYPE_NONE
            dim as Tko.SymbolId cnsid = c.info->RefOf( cqb->lhs )
            if cnsid = Tko.SYMBOL_NONE then
                cnsid = c.syms->Lookup( scope_, IdentNameOf( c, cqb->lhs ) )
            end if
            dim as Tko.Symbol ptr cnss = c.syms->SymbolAt( cnsid )
            if cnss = 0 then return Tko.TYPE_NONE
            if cnss->kind <> cast( ubyte, Tko.SYM_NAMESPACE ) then return Tko.TYPE_NONE
            cscope = cast( Tko.ScopeId, cnss->inner )
            ctgt = cqb->rhs
            cqual = true
        end if
        if c.ast->Kind( ctgt ) <> Tko.N_IDENT then return Tko.TYPE_NONE
        dim as Tko.InternId cn = IdentNameOf( c, ctgt )
        if cn = 0 then return Tko.TYPE_NONE
        '' A CONVERSION INTRINSIC IS ITS OWN TYPE. 'csng( x )' parses as a CALL over an
        '' N_IDENT that has no symbol at all -- it is a builtin -- so the ordinary-call
        '' lookup below answered nothing and the type argument was never inferred:
        '' 'function = Some( csng( dd ) )' declined while 'Some( cast( single, dd ) )'
        '' and 'dim s as single = csng( dd ) : Some( s )' beside it both worked. fbc
        '' infers T = single and instantiates. Four lines of fb/mathtext.bi are written
        '' this way.
        ''
        '' 'csign' and 'cunsg' are NOT here: their result depends on the OPERAND's type,
        '' which this pass runs too early to know.
        dim as string cnm = Tko.Text.LowerAscii( c.names->Spelling( cn ) )
        if cp->count >= 1 then
            dim as Tko.BuiltinType cb = Tko.TY_NONE
            select case cnm
            case "cbyte"    : cb = Tko.TY_BYTE
            case "cubyte"   : cb = Tko.TY_UBYTE
            case "cshort"   : cb = Tko.TY_SHORT
            case "cushort"  : cb = Tko.TY_USHORT
            case "clng"     : cb = Tko.TY_LONG
            case "culng"    : cb = Tko.TY_ULONG
            case "cint"     : cb = Tko.TY_INTEGER
            case "cuint"    : cb = Tko.TY_UINTEGER
            case "clngint"  : cb = Tko.TY_LONGINT
            case "culngint" : cb = Tko.TY_ULONGINT
            case "csng"     : cb = Tko.TY_SINGLE
            case "cdbl"     : cb = Tko.TY_DOUBLE
            case "cbool"    : cb = Tko.TY_BOOLEAN
            end select
            if cb <> Tko.TY_NONE then return c.types->Builtin( cb )
        end if

        if (cnm <> "cast") orelse (cp->count < 1) then
            '' AN ORDINARY CALL IS ITS CALLEE'S RESULT TYPE, which the symbol table
            '' already knows -- 'function = Some( CurrencyFromRaw( r ) )' is how
            '' fb/currency.bi and fb/decimal.bi return every Option they build, and
            '' with nothing to infer from, the generic was not instantiated and the
            '' whole 'function =' declined.
            ''
            '' ONLY AN UNAMBIGUOUS NAME. An overload set has one return type per
            '' candidate and picking the chain head would be picking one at random;
            '' Check resolves those later and this pass cannot.
            dim as Tko.SymbolId psid
            if cqual then
                psid = c.syms->LookupLocal( cscope, cn )
            else
                psid = c.syms->Lookup( cscope, cn )
            end if
            dim as Tko.Symbol ptr psy = c.syms->SymbolAt( psid )
            if psy = 0 then return Tko.TYPE_NONE
            if psy->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.TYPE_NONE
            if psy->nextOverload <> Tko.SYMBOL_NONE then
                '' AN OVERLOAD SET WITH AN EXACT MATCH IS NOT A GUESS. Where one
                '' candidate's first parameter is EXACTLY the first argument's type,
                '' that is the candidate overload resolution picks -- an exact match
                '' beats every conversion -- and if that candidate RETURNS that same
                '' type, the call's type is the argument's type whatever else is in
                '' the set.
                ''
                '' 'return Some( IPow( base_, expo ) )' inside 'IPowChecked( of T )'
                '' is this shape and nothing else in the corpus is: fb/mathint.bi
                '' expands one ordinary 'IPow( byval as T, byval as T ) as T' per
                '' integer type from a MACRO, so the set is four concrete overloads
                '' rather than a generic -- which is what an earlier note here got
                '' wrong.
                ''
                '' Still refused where NO candidate matches exactly: picking the
                '' cheapest conversion is overload resolution, which is Check's and
                '' runs later.
                if cp->count < 1 then return Tko.TYPE_NONE
                dim as Tko.TypeId a0t = InferArgType_( c, _
                    cast( Tko.NodeId, c.ast->children[cp->first] ), scope_ )
                if a0t = Tko.TYPE_NONE then return Tko.TYPE_NONE
                dim as Tko.TypeId a0u = c.types->Unqualify( a0t )
                dim as Tko.SymbolId ocur = psid
                while ocur <> Tko.SYMBOL_NONE
                    dim as Tko.Symbol ptr osy = c.syms->SymbolAt( ocur )
                    if osy = 0 then exit while
                    dim as Tko.NodeId opn = cast( Tko.NodeId, osy->payload )
                    if (opn <> Tko.NODE_NONE) andalso (c.ast->Kind( opn ) = Tko.N_PROC) then
                        dim as Tko.StmtPayload ptr opp = StmtOf( c, opn )
                        dim as Tko.NodeId p0 = Tko.NODE_NONE
                        for oi as long = 0 to opp->count - 1
                            dim as Tko.NodeId oprm = _
                                cast( Tko.NodeId, c.ast->children[opp->first + oi] )
                            if c.ast->Kind( oprm ) = Tko.N_PARAM then
                                p0 = oprm
                                exit for
                            end if
                        next
                        if p0 <> Tko.NODE_NONE then
                            dim as Tko.TypeId pt0 = _
                                ResolveTypeRef( c, StmtOf( c, p0 )->a, scope_ )
                            if pt0 <> Tko.TYPE_NONE then
                                if c.types->Unqualify( pt0 ) = a0u then
                                    dim as Tko.TypeId ort = osy->type_
                                    if ort <> Tko.TYPE_NONE then
                                        if c.types->Kind( ort ) = Tko.TK_REFERENCE then
                                            ort = c.types->Inner( ort )
                                        end if
                                        if c.types->Unqualify( ort ) = a0u then return a0u
                                    end if
                                end if
                            end if
                        end if
                    end if
                    ocur = osy->nextOverload
                wend
                return Tko.TYPE_NONE
            end if
            dim as Tko.TypeId rt = psy->type_
            if rt = Tko.TYPE_NONE then return Tko.TYPE_NONE
            if c.types->Kind( rt ) = Tko.TK_REFERENCE then rt = c.types->Inner( rt )
            return rt
        end if
        dim as Tko.NodeId tn = cast( Tko.NodeId, c.ast->children[cp->first] )
        if c.ast->Kind( tn ) <> Tko.N_TYPEREF then return Tko.TYPE_NONE
        return ResolveTypeRef( c, tn, scope_ )
    case Tko.N_BINARY
        '' 'Some( a + b )' -- AN ARITHMETIC EXPRESSION HAS A TYPE, and it is the
        '' one BinaryResult already computes for every operator, gated at
        '' 3596/3596 against fbc by check-promo. This pass runs before Check, so
        '' it computes the operands' types itself and asks the same table; without
        '' it any generic called with an expression -- 'Some( a + b )',
        '' 'Some( x \ 2 )' -- inferred nothing and the whole statement declined,
        '' while the same call over a NAME one line up instantiated.
        dim as Tko.BinaryPayload ptr bip = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, a )].data )]
        dim as Tko.TypeId blt = InferArgType_( c, bip->lhs, scope_ )
        if blt = Tko.TYPE_NONE then return Tko.TYPE_NONE
        dim as Tko.TypeId brt = InferArgType_( c, bip->rhs, scope_ )
        if brt = Tko.TYPE_NONE then return Tko.TYPE_NONE
        return Tko.Check.BinaryResult( _
            cast( Tko.TokenKind, bip->op ), blt, brt, *c.types )
    case Tko.N_INT_LIT
        return c.types->Builtin( Tko.TY_INTEGER )
    case Tko.N_FLOAT_LIT
        return c.types->Builtin( Tko.TY_DOUBLE )
    case Tko.N_STRING_LIT
        return c.types->Builtin( Tko.TY_STRING )

    case Tko.N_ADDROF
        '' '@cmp' AND A LAMBDA, which is '@' over its generated name. There was no
        '' case for either, so 'SortBy( a, function( ... ) ... end function )'
        '' inferred nothing, instantiated nothing, and the call declined --
        '' generics/container-sort.bas writes eighteen of them and fb/sort.bi
        '' declares the comparer as a type PARAMETER precisely so any callable
        '' fits.
        dim as Tko.UnaryPayload ptr aup = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a )].data )]
        dim as Tko.TypeId pp2 = ProcPtrTypeOfName_( c, aup->operand, scope_ )
        if pp2 <> Tko.TYPE_NONE then return pp2
        '' ...AND '@v' OVER A VARIABLE IS A POINTER TO ITS TYPE, which is how every
        '' 'T ptr' parameter is called: 'Deref( @v )' over
        '' 'function Deref( of T )( byval p as T ptr )'. Answered only for a
        '' PROCEDURE, the argument had no type, T was inferred from nothing, the
        '' generic never instantiated, and the call went out as 'declare void DEREF()'
        '' -- a name with no body and no result -- with no decline to say so.
        dim as Tko.TypeId vinner = InferArgType_( c, aup->operand, scope_ )
        if vinner = Tko.TYPE_NONE then return Tko.TYPE_NONE
        return c.types->Pointer_( vinner )
    end select
    return Tko.TYPE_NONE
end function

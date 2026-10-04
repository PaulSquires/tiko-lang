'' defcheck.bas -- A DEFINITION MUST SAY WHAT ITS DECLARATION SAID.
''
'' Included from visibility.bas, inside its namespace, beside byrefcheck.bas.
''
'' Measured 2026-09-19, fbc-modern 1.20 and fbc 1.10.1 agreeing on every shape, over a
'' definition of a name DECLAREd earlier in its scope:
''
''   'declare function g( ... ) as long', defined '... as double'         error 40
''   ...a SUB for a FUNCTION, 'integer' for 'longint', 'const long'       error 40
''   'declare sub g( byval a as long )', defined 'sub g( )'                error 1
''   ...defined 'sub g( byval a as double )'                              error 58
''   ...BYREF for byval, 'const long' for long, 'a( )' for a scalar,
''      'long ptr' for 'integer ptr', one UDT for another                 error 58
''   a default value that differs, or a parameter renamed                 accepted
''
'' The RESULT is asked first, then the COUNT, then each parameter in order: 'declare
'' function g( byval a as long ) as long' defined 'function g( ) as double' is 40.
''
'' A MEMBER of a type is found by its SIGNATURE -- the types, CONST and array-ness, not
'' the passing mode -- and a definition no overload has is error 158, "Declaration
'' outside the original namespace or class": a changed parameter type or count, a
'' property setter's value, 'operator let' or '+=', a cast's RESULT (a cast overloads on
'' nothing else), a constructor. The overload found is then held to its result (40) and
'' to each parameter's mode (58). A name declared OVERLOAD at module level is the other
'' way about: a definition matching none of it is a NEW overload and accepted -- unless
'' it is qualified with a namespace, 'sub N.h( ... )', which is 158 again.
''
'' tiko-lang accepted all of it. A non-member definition joins its declaration by ARITY,
'' because Collect runs before any type exists, so 'sub g( byval a as double )' ran under
'' 'declare sub g( byval a as long )''s signature; a member one fell back to the first
'' overload. Every call site then passed the declaration's types to the other's body.
''
'' WHAT IS NOT JUDGED: '...' on ONE side, or in an overload set -- TKO0780 and TKO0781
'' own those statements; both sides variadic is held to the rules above -- a generic, a
'' BYREF RESULT that differs (TKO0651, fbc's 20), and any type that cannot be compared by
'' identity: a procedure type, whose table entry is patched after the fact
'' (SetProcResult), and a name not yet resolved to a type. Those answer 'the same'.

private function DefStmt_ ( byref c as Ctx, byval id as NodeId ) as StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

'' Can a TypeId be compared by IDENTITY? Pointers and references down to a builtin, a
'' UDT or an enum -- the table interns each of those, so equal means the same type.
private function DefTypeComparable_ ( byref c as Ctx, byval t as TypeId ) as boolean
    dim as long guard = 0
    while (t <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        select case c.types->Kind( t )
        case TK_POINTER, TK_REFERENCE
            t = c.types->Inner( t )
        case TK_BUILTIN, TK_UDT, TK_ENUM
            return true
        case else
            return false
        end select
    wend
    return false
end function

'' The SAME SPELLING, pointer for pointer: one name, one builtin keyword, the same CONST
'' and PTR at every level. That is one type in any program fbc accepts, so it is never
'' re-judged by what Resolve bound: in the corpus's udt-ops files a preprocessor gap
'' declares 'TX' five times, the DECLARE and the body bind different generations of it,
'' and fbc accepts both as the one TX they are.
private function DefSameSpelling_ _
    ( byref c as Ctx, byval a as NodeId, byval b as NodeId ) as boolean

    dim as long guard = 0
    while guard < 64
        guard += 1
        if (a = NODE_NONE) orelse (b = NODE_NONE) then return (a = b)
        if (c.ast->Kind( a ) <> N_TYPEREF) orelse (c.ast->Kind( b ) <> N_TYPEREF) then return false
        dim as ushort mask = NF_PTR or NF_CONST or NF_PROC_TYPE
        dim as ushort af = c.ast->nodes[cast( long, a )].flags and mask
        if af <> (c.ast->nodes[cast( long, b )].flags and mask) then return false
        if (af and NF_PROC_TYPE) <> 0 then return false
        dim as StmtPayload ptr ap = DefStmt_( c, a )
        dim as StmtPayload ptr bp = DefStmt_( c, b )
        if ap->op <> bp->op then return false
        if (ap->count <> 0) orelse (bp->count <> 0) then return false
        if ap->op = cast( ushort, TK_IDENT ) then
            if ap->name <> bp->name then return false
            '' ...AND THE SAME QUALIFIER: 'A.T' and 'B.T' are two types, and comparing only
            '' the last name let 'declare sub f( byref q as A.T )' take a body over B.T --
            '' which then read 16 bytes out of a 4-byte object. A different qualifier is
            '' left to the resolved types below, so 'T' and 'B.T' naming one type agree.
            if ap->ownerName <> bp->ownerName then return false
        end if
        a = ap->a : b = bp->a
    wend
    return false
end function

'' Two written TYPE REFERENCES, NODE_NONE for none: the same type, or one this cannot
'' judge. A SUB against a FUNCTION -- one result written, one not -- is different.
private function DefSameType_ _
    ( byref c as Ctx, byval a as NodeId, byval b as NodeId ) as boolean

    if (a = NODE_NONE) andalso (b = NODE_NONE) then return true
    if (a = NODE_NONE) orelse (b = NODE_NONE) then return false
    if DefSameSpelling_( c, a, b ) then return true
    dim as TypeId ta = c.info->TypeOf_( a )
    dim as TypeId tb = c.info->TypeOf_( b )
    if ta = tb then return true
    if DefTypeComparable_( c, ta ) = false then return true
    if DefTypeComparable_( c, tb ) = false then return true
    return false
end function

'' How many parameters, and whether one of them is '...'.
private function DefParamCount_ _
    ( byref c as Ctx, byval sp as StmtPayload ptr, byref variadic as boolean ) as long

    variadic = false
    dim as long n = 0
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        if DefStmt_( c, prm )->op = cast( ushort, TK_ELLIPSIS ) then variadic = true
        n += 1
    next
    return n
end function

private function DefParamAt_ _
    ( byref c as Ctx, byval sp as StmtPayload ptr, byval idx as long ) as NodeId

    dim as long seen = 0
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        if seen = idx then return prm
        seen += 1
    next
    return NODE_NONE
end function

'' One parameter against another: 0 the same, 1 the TYPE or array-ness differs, 2 only
'' the passing MODE does. The mode is read after Resolve, which writes the implicit
'' BYREF of a UDT or string parameter onto the node (BindParamType_).
private function DefParamDiffers_ _
    ( byref c as Ctx, byval a as NodeId, byval b as NodeId ) as long

    if (a = NODE_NONE) orelse (b = NODE_NONE) then return 1
    dim as ushort af = c.ast->nodes[cast( long, a )].flags
    dim as ushort bf = c.ast->nodes[cast( long, b )].flags
    if (af and NF_ARRAY) <> (bf and NF_ARRAY) then return 1
    '' 'byref p as ANY' in the DECLARATION takes any type in the definition -- the corpus's
    '' functions/void_param defines three that way -- but not any MODE: 'byval p as long'
    '' against it is still 58. 'any ptr' is an ordinary type.
    dim as boolean declAny = false
    dim as TypeId dt = c.info->TypeOf_( DefStmt_( c, a )->a )
    if dt <> TYPE_NONE then
        if c.types->Kind( dt ) = TK_BUILTIN then declAny = (c.types->BuiltinOf( dt ) = TY_ANY)
    end if
    if declAny = false then
        if DefSameType_( c, DefStmt_( c, a )->a, DefStmt_( c, b )->a ) = false then return 1
    end if
    if (af and NF_ARRAY) <> 0 then return 0
    if (af and NF_BYREF) <> (bf and NF_BYREF) then return 2
    return 0
end function

'' The SIGNATURE an overload is found by: the count, and every parameter's type and
'' array-ness. A cast's result too, because a cast overloads on nothing else -- and a
'' PROPERTY's getter-or-setter, because an indexed getter has exactly a plain setter's
'' parameters (tests/mir/indexed-property). Only WHETHER it has a result, not the
'' type: a getter defined 'as double' against 'as long' is fbc's 40, not 158.
private function DefSameSignature_ _
    ( byref c as Ctx, byval dp as StmtPayload ptr, byval sp as StmtPayload ptr, _
      byval byResult as boolean ) as boolean

    dim as boolean v1 = false, v2 = false
    dim as long n = DefParamCount_( c, dp, v1 )
    if n <> DefParamCount_( c, sp, v2 ) then return false
    if byResult then
        if DefSameType_( c, dp->a, sp->a ) = false then return false
    end if
    if sp->op = cast( ushort, KW_PROPERTY ) then
        if (dp->a = NODE_NONE) <> (sp->a = NODE_NONE) then return false
    end if
    for i as long = 0 to n - 1
        if DefParamDiffers_( c, DefParamAt_( c, dp, i ), DefParamAt_( c, sp, i ) ) = 1 then
            return false
        end if
    next
    return true
end function

'' How the messages name it: a structor by its keyword, an operator with it.
private function DefName_ ( byref c as Ctx, byval sp as StmtPayload ptr ) as string
    select case cast( TokenKind, sp->op )
    case KW_CONSTRUCTOR : return "constructor"
    case KW_DESTRUCTOR  : return "destructor"
    case KW_OPERATOR    : return "operator " & c.names->Spelling( sp->name )
    end select
    return c.names->Spelling( sp->name )
end function

private sub CheckDefinitionAgrees_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = DefStmt_( c, id )
    if sp->b = NODE_NONE then return
    if (sp->extra and PF_GENERIC_PROC) <> 0 then return
    dim as SymbolId sid = c.info->RefOf( id )
    dim as Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return
    if s->kind <> cast( ubyte, SYM_PROC ) then return
    dim as boolean variadic = false
    dim as long nDef = DefParamCount_( c, sp, variadic )
    '' A PROPERTY the parser already refused the shape of (TKO0786, TKO0787).
    if sp->op = cast( ushort, KW_PROPERTY ) then
        if (sp->a <> NODE_NONE) andalso (nDef > 1) then return
        if (sp->a = NODE_NONE) andalso ((nDef < 1) orelse (nDef > 2)) then return
    end if

    dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
    dim as boolean isMember = false
    if sc <> 0 then isMember = (sc->kind = cast( ubyte, SCOPEK_TYPE ))
    dim as boolean qualified = isMember orelse (sp->ownerName <> 0)
    dim as boolean isOp = (sp->op = cast( ushort, KW_OPERATOR ))
    dim as boolean byResult = false
    if isOp then byResult = (Text.LowerAscii( c.names->Spelling( sp->name ) ) = "cast")
    dim as boolean overloadSet = isMember orelse isOp orelse ((sp->extra and PF_OVERLOAD) <> 0)
    '' '...' is judged only where it cannot be an overload: TKO0780 has the rest.
    if variadic andalso overloadSet then return

    '' Every DECLARATION of the name in this scope. The newest generation of it, the same
    '' judgement Collect made: a declaration is always the newest thing so far.
    dim as ulong savePos = c.syms->usePos
    c.syms->usePos = USEPOS_LATEST
    dim as SymbolId cur = c.syms->LookupLocal( s->parent, s->name )
    c.syms->usePos = savePos
    dim as Symbol ptr hs = c.syms->SymbolAt( cur )
    if hs = 0 then return
    if hs->kind <> cast( ubyte, SYM_PROC ) then cur = hs->altClass

    '' SOME OVERLOAD MUST OWN THIS BODY -- the one whose scope is this definition's. When
    '' none does, the collector refused it as a second body (TKO0600, fbc's 4) and it has
    '' had its error. Not RefOf: Resolve binds a constructor's definition to the HEAD of
    '' the chain, whichever overload it defines.
    dim as ScopeId ownScope = c.info->ScopeOf( id )
    dim as boolean owned = (ownScope = SCOPE_NONE)
    dim as long guard = 0
    dim as SymbolId scan = cur
    while (scan <> SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Symbol ptr ss = c.syms->SymbolAt( scan )
        if ss = 0 then exit while
        if ss->kind <> cast( ubyte, SYM_PROC ) then exit while
        if (ownScope <> SCOPE_NONE) andalso (ss->inner = ownScope) then
            owned = true
            exit while
        end if
        scan = ss->nextOverload
    wend
    if owned = false then return

    dim as long nCand = 0
    dim as NodeId first_ = NODE_NONE
    dim as NodeId match_ = NODE_NONE
    guard = 0
    while (cur <> SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        if cs->kind <> cast( ubyte, SYM_PROC ) then exit while
        dim as NodeId dn = cast( NodeId, cs->payload )
        dim as boolean usable = (cs->diedAt = 0) andalso (cs->parent = s->parent)
        if usable then usable = (dn <> NODE_NONE) andalso (dn <> 0) andalso (dn <> id)
        if usable then usable = (c.ast->Kind( dn ) = N_PROC)
        '' A DECLARATION, not another body. Not filtered on SYMF_DEFINED: the constructor
        '' branch of Collect sets it on a declaration too, and a second body never gets
        '' this far (above).
        if usable then usable = (DefStmt_( c, dn )->b = NODE_NONE)
        if usable then
            dim as StmtPayload ptr dp = DefStmt_( c, dn )
            if (dp->extra and PF_GENERIC_PROC) <> 0 then return
            dim as boolean dv = false
            DefParamCount_( c, dp, dv )
            if dv <> variadic then return
            if (dp->extra and PF_OVERLOAD) <> 0 then overloadSet = true
            if variadic andalso overloadSet then return
            nCand += 1
            if first_ = NODE_NONE then first_ = dn
            if match_ = NODE_NONE then
                if DefSameSignature_( c, dp, sp, byResult ) then match_ = dn
            end if
        end if
        cur = cs->nextOverload
    wend
    if nCand = 0 then return

    dim as NodeId decl = first_
    if overloadSet then
        if match_ = NODE_NONE then
            '' A NEW OVERLOAD at module level; nothing to define in a type or namespace.
            if qualified then
                c.diags->Report( TKO0796, PointRange( c.ast->Loc( id ) ), _
                                 DefName_( c, sp ) )
                c.diags->AddNote( TKO0901, PointRange( c.ast->Loc( first_ ) ) )
            end if
            return
        end if
        decl = match_
    end if

    dim as StmtPayload ptr dp = DefStmt_( c, decl )
    '' A BYREF RESULT that differs has its own error (TKO0651); one per statement.
    dim as ushort rd = c.ast->nodes[cast( long, decl )].flags and NF_BYREF
    dim as ushort rf = c.ast->nodes[cast( long, id )].flags and NF_BYREF
    if rd <> rf then return
    if (DefSameType_( c, dp->a, sp->a ) = false) orelse (((dp->extra xor sp->extra) and PF_ARRAY_RESULT) <> 0) then   '' 'as T( )' on one and not the other
        c.diags->Report( TKO0793, PointRange( c.ast->Loc( id ) ), _
                         DefName_( c, sp ) )
        c.diags->AddNote( TKO0901, PointRange( c.ast->Loc( decl ) ) )
        return
    end if
    dim as boolean dv2 = false
    dim as long nDecl = DefParamCount_( c, dp, dv2 )
    if nDecl <> nDef then
        c.diags->Report( TKO0794, PointRange( c.ast->Loc( id ) ), _
                         DefName_( c, sp ), str( nDecl ) )
        c.diags->AddNote( TKO0901, PointRange( c.ast->Loc( decl ) ) )
        return
    end if
    for i as long = 0 to nDef - 1
        if DefParamDiffers_( c, DefParamAt_( c, dp, i ), DefParamAt_( c, sp, i ) ) <> 0 then
            c.diags->Report( TKO0795, PointRange( c.ast->Loc( id ) ), _
                             str( i + 1 ), DefName_( c, sp ) )
            c.diags->AddNote( TKO0901, PointRange( c.ast->Loc( decl ) ) )
            return
        end if
    next
end sub

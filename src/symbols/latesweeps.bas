'' latesweeps.bas -- THE AST SWEEPS OF THE POST-CHECK PASS THAT RUN AFTER THE WALK.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' namespace: these are ordinary members of that pass and share its Ctx. What they have in
'' common is that each sweeps the WHOLE AST once rather than being hooked into Walk_,
'' because each asks about a declaration whose answer is not in the node the walk reaches.

'' A NAMESPACE CANNOT BE ADDED TO FROM OUTSIDE IT -- fbc error 158, "Declaration outside
'' the original namespace or class". DEFINING something the namespace already declared is
'' the ordinary and accepted use; introducing a NEW name is not.
''
'' MEASURED, and the accepted half is what makes the rule narrow enough to be safe:
''     namespace a : declare sub f1( ) : end namespace
''     sub a.f1( ) : end sub                              OK    -- a DEFINITION
''     namespace a : extern s as string : end namespace
''     dim a.s as string                                  OK    -- likewise
''     namespace a : end namespace
''     sub a.f1( ) : end sub                              error 158
''     dim a.s as integer                                 error 131
''
'' So the test is "does that namespace already have this name", and nothing finer. fbc
'' separates a re-DECLARATION from a definition and gives 158 for the former even when the
'' name is there; that distinction is not modelled, and missing it costs an accepted file,
'' not a wrong one.
private function NamespaceScopeOf_ _
    ( byref c as Ctx, byval path as InternId ) as ScopeId

    if path = 0 then return SCOPE_NONE
    dim as string qp = c.names->Spelling( path )
    '' THE FIRST COMPONENT IS FOUND IN THE SYMBOL TABLE, not from SCOPE_GLOBAL: a
    '' file's namespaces live in the MODULE scope, which is a child of the global one and
    '' which nothing here holds a handle to. Only an UNAMBIGUOUS match counts -- two
    '' namespaces of one name under different parents would make the wrong scope the
    '' answer, and a wrong scope here means refusing a file fbc accepts.
    dim as long firstDot = instr( qp, "." )
    dim as long firstEnd = firstDot
    if firstEnd = 0 then firstEnd = len( qp ) + 1
    dim as InternId head = c.names->GetString( left( qp, firstEnd - 1 ) )
    dim as ScopeId sc = SCOPE_NONE
    dim as long hits = 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr ns = @c.syms->symbols[i]
        if ns->kind <> cast( ubyte, SYM_NAMESPACE ) then continue for
        if c.names->Fold( ns->name ) <> c.names->Fold( head ) then continue for
        hits += 1
        sc = ns->inner
    next
    if (hits <> 1) orelse (sc = SCOPE_NONE) then return SCOPE_NONE
    if firstDot = 0 then return sc
    dim as long at = firstDot
    dim as long guard = 0
    while (at <= len( qp )) andalso (guard < 64)
        guard += 1
        dim as long dot = instr( at + 1, qp, "." )
        dim as long stop_ = dot
        if stop_ = 0 then stop_ = len( qp ) + 1
        dim as string comp = mid( qp, at + 1, stop_ - at - 1 )
        if len( comp ) = 0 then return SCOPE_NONE
        dim as SymbolId sid = _
            c.syms->LookupLocal( sc, c.names->Fold( c.names->GetString( comp ) ) )
        dim as Symbol ptr sym = c.syms->SymbolAt( sid )
        if sym = 0 then return SCOPE_NONE
        '' ONLY A NAMESPACE. A TYPE's members are a different rule with a different error,
        '' and answering for one here would report the other's shape.
        if sym->kind <> cast( ubyte, SYM_NAMESPACE ) then return SCOPE_NONE
        if sym->inner = SCOPE_NONE then return SCOPE_NONE
        sc = sym->inner
        if dot = 0 then return sc
        at = dot
    wend
    return SCOPE_NONE
end function

'' Does the FIRST component of a dotted owner path name a namespace or a type anywhere?
private function OwnerHeadExists_ ( byref c as Ctx, byval path as InternId ) as boolean
    if path = 0 then return true
    dim as string qp = c.names->Spelling( path )
    dim as long dot = instr( qp, "." )
    if dot > 0 then qp = left( qp, dot - 1 )
    dim as InternId head = c.names->Fold( c.names->GetString( qp ) )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if (s->kind <> cast( ubyte, SYM_NAMESPACE )) andalso _
           (s->kind <> cast( ubyte, SYM_UDT )) andalso _
           (s->kind <> cast( ubyte, SYM_TYPEDEF )) then continue for
        if c.names->Fold( s->name ) = head then return true
    next
    return false
end function

'' The scope of a TYPE named by a plain (undotted, non-generic) owner path, or SCOPE_NONE.
private function TypeScopeOf_ ( byref c as Ctx, byval path as InternId ) as ScopeId
    if path = 0 then return SCOPE_NONE
    dim as string qp = c.names->Spelling( path )
    if (instr( qp, "." ) > 0) orelse (instr( qp, "(" ) > 0) then return SCOPE_NONE
    dim as InternId head = c.names->Fold( c.names->GetString( qp ) )
    dim as ScopeId found = SCOPE_NONE
    dim as long hits = 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_UDT ) then continue for
        if c.names->Fold( s->name ) <> head then continue for
        if s->inner = SCOPE_NONE then continue for
        hits += 1
        found = s->inner
    next
    if hits <> 1 then return SCOPE_NONE
    return found
end function

'' A STRUCTOR OR PROPERTY OF A NAMESPACED TYPE IS DEFINED INSIDE THE NAMESPACE -- fbc
'' error 168, "Parent is not a class or UDT", for 'constructor ns.UDT( )', 'destructor
'' ns.UDT( )' and 'property ns.UDT.foo( )' written at module level. The dotted owner path
'' is the tell: a structor names its type in 'name' and its namespace in 'ownerName', a
'' property its type in 'ownerName' -- and when that path leads through a NAMESPACE the
'' definition has been written outside it.
private sub CheckStructorOutsideNamespace_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        '' A DEFINITION, not a declare. A structor keeps its body among its CHILDREN
        '' rather than in 'b' -- testing 'b' alone skipped every constructor.
        dim as boolean hasBody = (sp->b <> NODE_NONE)
        for bi as long = 0 to sp->count - 1
            dim as NodeId ch = cast( NodeId, c.ast->children[sp->first + bi] )
            if (ch <> NODE_NONE) andalso (c.ast->Kind( ch ) = N_BLOCK) then hasBody = true
        next
        if hasBody = false then continue for
        if sp->ownerName = 0 then continue for
        dim as string path = c.names->Spelling( sp->ownerName )
        dim as string head = path
        dim as long dot = instr( head, "." )
        if dot > 0 then head = left( head, dot - 1 )
        '' MEASURED MORE CLOSELY: when the type DID declare the structor or property, the
        '' module-level definition through the namespace is accepted. So the question is
        '' the one the type-owner rule asks -- did the type declare it -- with fbc's 168
        '' as the answer when it did not.
        dim as string nsPath = path
        dim as string typeName = ""
        dim as string want = ""
        '' THE PARSER FOLDS A STRUCTOR'S OWNER INTO ONE DOTTED PATH -- 'constructor
        '' ns.Bare( )' arrives with ownerName 'ns.bare' -- so for every one of the three
        '' the type is the LAST component and the namespace what precedes it.
        select case cast( TokenKind, sp->op )
        case KW_CONSTRUCTOR, KW_DESTRUCTOR
            '' 'constructor ns.Bare( )': the parser leaves 'ns' in ownerName and the TYPE
            '' in 'name'.
            typeName = c.names->Spelling( sp->name )
            if cast( TokenKind, sp->op ) = KW_CONSTRUCTOR then want = "__ctor" else want = "__dtor"
        case KW_PROPERTY
            '' 'property ns.Bare.foo( )': the type is the last component of the path.
            if dot = 0 then continue for
            dim as long lastDot = instrrev( path, "." )
            nsPath = left( path, lastDot - 1 )
            typeName = mid( path, lastDot + 1 )
            want = c.names->Spelling( sp->name )
        case else
            continue for
        end select
        dim as ScopeId nsc = NamespaceScopeOf_( c, c.names->GetString( nsPath ) )
        if nsc = SCOPE_NONE then continue for
        dim as Symbol ptr ts = c.syms->SymbolAt( c.syms->LookupLocalTyped( nsc, _
            c.names->GetString( typeName ), true ) )
        if ts = 0 then continue for
        if ts->kind <> cast( ubyte, SYM_UDT ) then continue for
        if ts->inner = SCOPE_NONE then continue for
        '' THE DEFINITION ITSELF PUTS A SYMBOL IN THE TYPE'S SCOPE -- Collect declares
        '' 'constructor ns.Bare( )' into Bare as it would any member -- so "is there a
        '' symbol" always says yes. What is asked is whether one was DECLARED: a symbol
        '' in the chain whose node is a declare, with no body.
        dim as Symbol ptr ms = c.syms->SymbolAt( _
            c.syms->LookupLocal( ts->inner, c.names->Fold( c.names->GetString( want ) ) ) )
        dim as boolean declared = false
        dim as long guard = 0
        while (ms <> 0) andalso (guard < 1000)
            guard += 1
            dim as NodeId md = cast( NodeId, ms->payload )
            if (md <> NODE_NONE) andalso (md <> id) andalso (c.ast->Kind( md ) = N_PROC) then
                dim as StmtPayload ptr mp = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, md )].data )]
                dim as boolean body = (mp->b <> NODE_NONE)
                for bj as long = 0 to mp->count - 1
                    dim as NodeId ch2 = cast( NodeId, c.ast->children[mp->first + bj] )
                    if (ch2 <> NODE_NONE) andalso (c.ast->Kind( ch2 ) = N_BLOCK) then body = true
                next
                if body = false then declared = true
            end if
            ms = c.syms->SymbolAt( ms->nextOverload )
        wend
        if declared then continue for
        c.diags->Report( TKO0722, PointRange( c.ast->Loc( id ) ), path )
    next
end sub

private sub CheckOutsideNamespace_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        dim as NodeKind k = c.ast->Kind( id )
        if (k <> N_PROC) andalso (k <> N_VAR_ITEM) then continue for
        if (c.ast->nodes[n].flags and NF_QUALIFIED) = 0 then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        '' 'redim x.arr( 0 to 9 )' NAMES ITS ARRAY THROUGH AN OBJECT -- 'x' is a variable,
        '' or 'this' -- and declares nothing into anything. The parser marks such an item
        '' with the REDIM keyword in 'extra'; five of this suite's own MIR tests write it,
        '' and the owner test read 'x' as a namespace that did not exist.
        dim as ScopeId ns = NamespaceScopeOf_( c, sp->ownerName )
        '' ...UNLESS THE OWNER IS A NAMESPACE, in which case 'redim shared ns1.array1( )
        '' as integer' from outside is fbc's 158 like any other outside declaration.
        '' A plain 'redim ns.arr( 4 to 5 )' with no 'as' declares nothing and is accepted.
        if (k = N_VAR_ITEM) andalso (sp->extra = cast( ushort, KW_REDIM )) then
            if (ns = SCOPE_NONE) orelse (sp->a = NODE_NONE) then continue for
        end if
        if (ns = SCOPE_NONE) andalso (k = N_PROC) then
            '' THE OWNER MAY BE A TYPE, and the rule is the same one fbc gives a
            '' namespace, with the same error 158: 'declare sub U.bbb( )' when the type
            '' never declared bbb is refused, and so is a DEFINITION of one; a second
            '' 'declare' of a declared member is refused too, while the definition of a
            '' declared member is the ordinary use. A GENERIC's owner path carries its
            '' type arguments and is not judged.
            dim as ScopeId ts = TypeScopeOf_( c, sp->ownerName )
            if ts <> SCOPE_NONE then
                dim as SymbolId have2 = c.syms->LookupLocal( ts, c.names->Fold( sp->name ) )
                dim as boolean bad2 = (have2 = SYMBOL_NONE)
                if bad2 = false then bad2 = (sp->b = NODE_NONE)
                if bad2 then
                    c.diags->Report( TKO0669, PointRange( c.ast->Loc( id ) ), _
                                     c.names->Spelling( sp->ownerName ) & "." & _
                                     c.names->Spelling( sp->name ) )
                end if
                continue for
            end if
        end if
        if ns = SCOPE_NONE then
            '' AN OWNER THAT NAMES NOTHING AT ALL. 'dim shared a.i1 as integer' with no
            '' 'a' anywhere is fbc's error 147, and 'declare sub a.f1( )' its error 3;
            '' Collect meanwhile read 'a' as a TYPE and gave f1 an implicit THIS. Only
            '' when neither a namespace nor a type of that head name exists -- a type is
            '' the other legitimate owner, and is somebody else's question.
            if OwnerHeadExists_( c, sp->ownerName ) then continue for
            c.diags->Report( TKO0694, PointRange( c.ast->Loc( id ) ), _
                             c.names->Spelling( sp->ownerName ) )
            continue for
        end if
        dim as SymbolId have = c.syms->LookupLocal( ns, c.names->Fold( sp->name ) )
        dim as boolean bad = (have = SYMBOL_NONE)
        if bad = false then
            '' THE NAME EXISTS -- but only a DEFINITION of something DECLARED may come
            '' from outside. Measured: a second 'declare' of a declared procedure is
            '' error 158, and so is 'dim shared a.i1' or 'redim shared ns1.array1( )'
            '' over a member that was a plain dim rather than an extern.
            dim as Symbol ptr hs = c.syms->SymbolAt( have )
            if k = N_PROC then
                bad = (sp->b = NODE_NONE)
            elseif hs <> 0 then
                bad = ((hs->flags and SYMF_EXTERN) = 0)
            end if
        end if
        if bad = false then continue for
        c.diags->Report( TKO0669, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( sp->ownerName ) & "." & _
                         c.names->Spelling( sp->name ) )
    next
end sub

'' 'const N = lbound( a )' OVER A DYNAMIC ARRAY -- fbc error 11, "Expected constant". A
'' fixed array's bounds are known and fold; a dynamic one has none until it is
'' redimensioned, and a BYDESC parameter's arrive with the descriptor at run time, which
'' is the same thing here and is why one is typed as a dynamic array.
''
'' HERE AND NOT IN RESOLVE, where the sibling test on the DIMENSION argument lives: that
'' walk is what gives a declaration its type, so during it the array's symbol has none
'' yet and IsDynArray said no to every one of them.
''
'' IT REPORTS ONLY WHAT IT CAN POSITIVELY ESTABLISH. Asking "did the fold succeed" instead
'' measured THIS compiler's folder against fbc's: tiko-lang does not fold lbound of a
'' FIXED array either, and that refused three lines fbc accepts.
private sub CheckConstBounds_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_CONST then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            if ip->b = NODE_NONE then continue for
            if c.ast->Kind( ip->b ) <> N_CALL then continue for
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->b )].data )]
            if lp->target = NODE_NONE then continue for
            if c.ast->Kind( lp->target ) <> N_IDENT then continue for
            '' A USER SYMBOL OF THAT NAME IS NOT THE INTRINSIC.
            if c.info->RefOf( lp->target ) <> SYMBOL_NONE then continue for
            dim as string spell = c.names->Spelling( _
                c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name )
            if (spell <> "lbound") andalso (spell <> "ubound") then continue for
            if lp->count < 1 then continue for
            dim as NodeId arr = cast( NodeId, c.ast->children[lp->first] )
            dim as Symbol ptr asym = c.syms->SymbolAt( c.info->RefOf( arr ) )
            if asym = 0 then continue for
            if c.types->IsDynArray( asym->type_ ) = false then continue for
            c.diags->Report( TKO0674, PointRange( c.ast->Loc( ip->b ) ) )
        next
    next
end sub


'' RETURN AND 'FUNCTION =' CANNOT BE MIXED when the result is a UDT WITH CONSTRUCTORS --
'' fbc errors 178 and 179. The two styles construct the result differently, and fbc says
'' outright that using both together is unsupported for such a type.
''
'' MEASURED, and the type is half the rule:
''     return x  ... function = x     error 179
''     function = x ... return x      error 178
''     exit function ... return x     error 178   -- EXIT counts as the other style
''     return x only                  OK
''     function = x only              OK
''     the same mix over an INTEGER result          OK
''
'' ONE ERROR PER PROCEDURE, on the procedure, because the two spellings may be anywhere in
'' the body and fbc's line number is whichever came second -- which is not worth modelling
'' when the fact being reported is about the procedure as a whole.
private sub ScanReturnStyles_ _
    ( byref c as Ctx, byval id as NodeId, byref sawReturn as boolean, _
      byref sawAssign as boolean )

    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    '' A NESTED PROCEDURE IS ITS OWN QUESTION -- and in FreeBASIC there are none inside a
    '' body, so this is a guard rather than a case that arises.
    if k = N_PROC then return
    if k = N_RETURN then sawReturn = true
    if k = N_EXIT then
        dim as StmtPayload ptr xp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' 'exit operator' AND 'exit property' COUNT TOO -- the corpus writes the same
        '' pair of files for each of the three, and fbc gives all three error 178.
        select case cast( TokenKind, xp->op )
        case KW_FUNCTION, KW_OPERATOR, KW_PROPERTY
            sawAssign = true
        end select
    end if
    if k = N_AMBIGUOUS then
        if c.info->AmbiguousOf( id ) = AMB_RESULT then sawAssign = true
    end if

    if NodeKindCategory( k ) = NCAT_EXPR then return
    if NodeKindCategory( k ) = NCAT_TYPE then return
    if (k = N_MODULE) orelse (k = N_BLOCK) then
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            ScanReturnStyles_( c, cast( NodeId, c.ast->children[lp->first + i] ), _
                               sawReturn, sawAssign )
        next
        return
    end if
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    ScanReturnStyles_( c, sp->b, sawReturn, sawAssign )
    ScanReturnStyles_( c, sp->c, sawReturn, sawAssign )
    for i as long = 0 to sp->count - 1
        ScanReturnStyles_( c, cast( NodeId, c.ast->children[sp->first + i] ), _
                           sawReturn, sawAssign )
    next
end sub

'' A BYREF FUNCTION MUST SET ITS RESULT SOMEWHERE -- fbc error 316, "Byref function
'' result not set". Measured: a body with neither 'function =' nor 'return' is refused;
'' one that assigns in a single branch, or returns, is accepted -- fbc asks whether the
'' result is set at all, not on every path. The same body scan the return-style rule
'' uses.
private sub CheckByrefResultSet_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_PROC then continue for
        if (c.ast->nodes[n].flags and NF_BYREF) = 0 then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if sp->b = NODE_NONE then continue for
        dim as boolean sawReturn = false
        dim as boolean sawAssign = false
        ScanReturnStyles_( c, sp->b, sawReturn, sawAssign )
        if sawReturn orelse sawAssign then continue for
        c.diags->Report( TKO0710, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( sp->name ) )
    next
end sub

'' THE ALIAS ON A DEFINITION MUST MATCH THE DECLARATION'S -- fbc error 311. Measured:
'' 'declare sub f alias "foo"( )' then 'sub f alias "bar"( )' is refused; the same alias
'' twice, or an alias on the declare alone, is accepted.
private sub CheckAliasAgrees_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if sp->b = NODE_NONE then continue for
        if sp->aliasName = 0 then continue for
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
        if s = 0 then continue for
        dim as NodeId decl = cast( NodeId, s->payload )
        if (decl = NODE_NONE) orelse (decl = id) then continue for
        if c.ast->Kind( decl ) <> N_PROC then continue for
        dim as StmtPayload ptr dp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
        if dp->aliasName = 0 then continue for
        if c.names->Spelling( dp->aliasName ) = c.names->Spelling( sp->aliasName ) then continue for
        c.diags->Report( TKO0712, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( sp->name ) )
    next
end sub

private sub CheckReturnStyles_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_PROC then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if sp->a = NODE_NONE then continue for
        '' A UDT RESULT WITH A CONSTRUCTOR, and nothing else.
        dim as TypeId rt = c.types->Unqualify( c.info->TypeOf_( sp->a ) )
        if rt = TYPE_NONE then continue for
        if c.types->Kind( rt ) <> TK_UDT then continue for
        if StructorOf_( c, rt, "__ctor" ) = 0 then continue for

        dim as boolean sawReturn = false
        dim as boolean sawAssign = false
        for i as long = 0 to sp->count - 1
            ScanReturnStyles_( c, cast( NodeId, c.ast->children[sp->first + i] ), _
                               sawReturn, sawAssign )
        next
        ScanReturnStyles_( c, sp->b, sawReturn, sawAssign )
        if (sawReturn andalso sawAssign) = false then continue for
        c.diags->Report( TKO0676, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( sp->name ) )
    next
end sub

'' TWO OVERLOADS WITH THE SAME SIGNATURE ARE A DUPLICATE DEFINITION -- fbc error 4.
'' tiko-lang did not detect one at all, of any shape.
''
'' MEASURED, and the ARRAY RANK is the interesting part:
''     f( byval a as integer ) twice                error 4
''     f( a(any) as integer ) twice                 error 4
''     f( a(any) ... ) and f( a() ... )             error 4   -- () is UNKNOWN rank and
''                                                               collides with any rank
''     f( a(any,any) ... ) and f( a(any) ... )      OK        -- two KNOWN ranks differ
''     f( byval a as integer ) and f( ... as single )  OK
''
'' TYPES ARE COMPARED AS WRITTEN, qualifiers included. fbc's own rule for when a const
'' difference collides is not measured here, so a pair that differs only in one is left
'' alone -- a miss rather than a wrong answer.
private function ParamTypeAt_ _
    ( byref c as Ctx, byval decl as NodeId, byval want as long, _
      byref rank as long ) as TypeId

    rank = -1
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long seen = 0
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        if seen = want then
            dim as StmtPayload ptr pp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
            '' THE RANK AS WRITTEN, which the parser recorded in 'extra' as the comma
            '' count plus one -- 0 for 'a()', 1 for 'a(any)', 2 for 'a(any,any)'. The
            '' TYPEREF's own type is the ELEMENT type and says nothing about the rank,
            '' so reading the rank from it made 'a(any,any)' and 'a(any)' compare equal
            '' and refused a pair fbc accepts.
            if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) <> 0 then
                rank = cast( long, pp->extra )
            end if
            return c.info->TypeOf_( pp->a )
        end if
        seen += 1
    next
    return TYPE_NONE
end function


'' The N-th N_PARAM node of a declaration, or NODE_NONE.
private function ParamNodeAt_ _
    ( byref c as Ctx, byval decl as NodeId, byval want as long ) as NodeId
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long seen = 0
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        if seen = want then return prm
        seen += 1
    next
    return NODE_NONE
end function

'' TWO TYPES THAT MANGLE ALIKE: a top-level CONST on a BYVAL parameter is not part of the
'' name -- 'byval as integer' and 'byval as const integer' are one signature, and so are
'' 'integer ptr' and 'integer const ptr' -- while a const on the POINTEE ('const integer
'' ptr') and every BYREF qualifier are. The same question is asked of every parameter of
'' a procedure-pointer parameter, which is where the corpus writes it (six files).
private function MangleEq_ _
    ( byref c as Ctx, byval ta as TypeId, byval tb as TypeId ) as boolean
    if ta = tb then return true
    if (ta = TYPE_NONE) orelse (tb = TYPE_NONE) then return false
    if (c.types->Kind( ta ) = TK_REFERENCE) orelse (c.types->Kind( tb ) = TK_REFERENCE) then
        return false
    end if
    dim as TypeId ua = c.types->Unqualify( ta )
    dim as TypeId ub = c.types->Unqualify( tb )
    if ua = ub then return true
    if (c.types->Kind( ua ) = TK_POINTER) andalso (c.types->Kind( ub ) = TK_POINTER) then
        dim as TypeId ia = c.types->Inner( ua )
        dim as TypeId ib = c.types->Inner( ub )
        if (c.types->Kind( ia ) = TK_PROC) andalso (c.types->Kind( ib ) = TK_PROC) then
            return MangleEq_( c, ia, ib )
        end if
        return false
    end if
    if (c.types->Kind( ua ) <> TK_PROC) orelse (c.types->Kind( ub ) <> TK_PROC) then
        return false
    end if
    if c.types->ProcParamCount( ua ) <> c.types->ProcParamCount( ub ) then return false
    if c.types->Inner( ua ) <> c.types->Inner( ub ) then return false
    for i as long = 0 to c.types->ProcParamCount( ua ) - 1
        if MangleEq_( c, c.types->ProcParam( ua, i ), c.types->ProcParam( ub, i ) ) = false then
            return false
        end if
    next
    return true
end function

'' Two declarations whose parameters are NOT identical but mangle alike -- fbc error 4,
'' "Duplicated definition". Identical pairs are not this test's (see SameSignature_).
private function ByvalConstTwin_ _
    ( byref c as Ctx, byval a as NodeId, byval b as NodeId, byval n as long ) as boolean
    dim as boolean sawTwin = false
    for i as long = 0 to n - 1
        dim as NodeId pa = ParamNodeAt_( c, a, i )
        dim as NodeId pb = ParamNodeAt_( c, b, i )
        if (pa = NODE_NONE) orelse (pb = NODE_NONE) then return false
        dim as ushort flA = c.ast->nodes[cast( long, pa )].flags
        dim as ushort flB = c.ast->nodes[cast( long, pb )].flags
        if ((flA or flB) and (NF_BYREF or NF_ARRAY)) <> 0 then return false
        dim as long ra, rb
        dim as TypeId ta = ParamTypeAt_( c, a, i, ra )
        dim as TypeId tb = ParamTypeAt_( c, b, i, rb )
        if (ta = TYPE_NONE) orelse (tb = TYPE_NONE) then return false
        if ta = tb then continue for
        if MangleEq_( c, ta, tb ) = false then return false
        sawTwin = true
    next
    return sawTwin
end function

private function SameSignature_ _
    ( byref c as Ctx, byval a as NodeId, byval b as NodeId ) as boolean

    dim as long na = ParamCount_( c, a )
    dim as long nb = ParamCount_( c, b )
    if (na < 0) orelse (nb < 0) then return false
    if na <> nb then return false

    '' THE RESULT TYPE COUNTS TOO. 'declare operator cast( ) as byte' and 'as double'
    '' take no parameters and differ only in what they return, which FreeBASIC allows for
    '' a conversion operator -- comparing parameters alone called them duplicates and
    '' broke three of this suite's own MIR tests. A SUB has no result and both sides
    '' report TYPE_NONE, which compares equal as it should.
    dim as StmtPayload ptr sa = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, a )].data )]
    dim as StmtPayload ptr sb = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, b )].data )]
    if c.info->TypeOf_( sa->a ) <> c.info->TypeOf_( sb->a ) then return false
    '' ONLY A PAIR WITH A BYDESC PARAMETER IS JUDGED, which is the whole of what was
    '' measured and the whole of what the corpus asks for. The general scalar case looks
    '' identical and is not: run over all 1222 fbc-accepted files it produced THIRTEEN
    '' false rejections, from two causes this pass cannot tell apart from a duplicate --
    '' the same name declared in two NAMESPACES whose overload chain links across them,
    '' and the CRT headers' '_rotl' family. Both are shapes where "same name, same
    '' parameter types" is not the question fbc is actually asking.
    dim as boolean anyBydesc = false
    for i as long = 0 to na - 1
        dim as long rx, ry
        ParamTypeAt_( c, a, i, rx )
        ParamTypeAt_( c, b, i, ry )
        if (rx >= 0) orelse (ry >= 0) then
            anyBydesc = true
            exit for
        end if
    next
    '' ...EXCEPT a pair that differs only by a BYVAL CONST, which mangles to one name.
    if anyBydesc = false then return ByvalConstTwin_( c, a, b, na )

    for i as long = 0 to na - 1
        dim as long ra, rb
        dim as TypeId ta = ParamTypeAt_( c, a, i, ra )
        dim as TypeId tb = ParamTypeAt_( c, b, i, rb )
        '' AN UNTYPED PARAMETER MEANS SOMETHING EARLIER DECLINED, and two of them are
        '' not evidence of anything.
        if (ta = TYPE_NONE) orelse (tb = TYPE_NONE) then return false
        if (ra >= 0) andalso (rb >= 0) then
            '' BOTH BYDESC: rank 0 is 'unknown' and collides with any; two known ranks
            '' collide only when equal. The ELEMENT type still has to match.
            if (ra > 0) andalso (rb > 0) andalso (ra <> rb) then return false
            '' The ELEMENT type is what the TYPEREF carries for a bydesc parameter.
            if ta <> tb then return false
        else
            if ta <> tb then return false
        end if
    next
    return true
end function

private sub CheckDuplicateOverloads_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_PROC ) then continue for
        if s->nextOverload = SYMBOL_NONE then continue for
        dim as NodeId da = cast( NodeId, s->payload )
        if da = NODE_NONE then continue for
        if c.ast->Kind( da ) <> N_PROC then continue for

        dim as Symbol ptr o = c.syms->SymbolAt( s->nextOverload )
        dim as long guard = 0
        while (o <> 0) andalso (guard < 1000)
            guard += 1
            '' THE SAME SCOPE ONLY. Two namespaces may each hold an 'f'.
            if o->parent = s->parent then
                dim as NodeId db = cast( NodeId, o->payload )
                if (db <> NODE_NONE) andalso (db <> da) then
                    if c.ast->Kind( db ) = N_PROC then
                        '' A DEFINITION OF AN ALREADY-DECLARED OVERLOAD IS NOT A SECOND
                        '' ONE. 'declare function pr overload( byval p as long )' and the
                        '' 'function pr( byval p as long )' that follows are the same
                        '' procedure -- and because OVERLOAD belongs to the NAME rather
                        '' than to the declaration that spelled it, they are two symbols
                        '' in the chain with one signature. Reporting that broke seven of
                        '' this suite's own MIR tests at once.
                        ''
                        '' So the pair must AGREE about having a body: two declarations
                        '' collide, and so do two definitions; a declaration and its
                        '' definition do not.
                        dim as StmtPayload ptr pa = _
                            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, da )].data )]
                        dim as StmtPayload ptr pb = _
                            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, db )].data )]
                        dim as boolean bodyA = (pa->b <> NODE_NONE)
                        dim as boolean bodyB = (pb->b <> NODE_NONE)
                        if bodyA <> bodyB then
                            o = c.syms->SymbolAt( o->nextOverload )
                            continue while
                        end if
                        if SameSignature_( c, da, db ) then
                            c.diags->Report( TKO0677, PointRange( c.ast->Loc( db ) ), _
                                             c.names->Spelling( s->name ) )
                        end if
                    end if
                end if
            end if
            o = c.syms->SymbolAt( o->nextOverload )
        wend
    next
end sub

'' A BITFIELD CANNOT BE WIDER THAN ITS TYPE -- fbc error 78, "Invalid bitfield". MEASURED
'' at the boundary for every width the corpus uses: ':8 as byte' is accepted and ':9' is
'' not, ':16 as short' yes and ':17' no, ':32 as long' yes and ':33' no.
''
'' HERE AND NOT IN THE PARSER, which has the width but not the TYPE: the field's type is a
'' typeref that nothing has resolved yet when the ':' is read.
private sub CheckBitfieldWidths_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_FIELD then continue for
        dim as StmtPayload ptr fp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if fp->b = NODE_NONE then continue for
        '' THE WIDTH AS WRITTEN. Only a plain integer literal is judged: anything else
        '' would need the folder, which this pass does not carry, and a width that does
        '' not fold is somebody else's diagnostic.
        if c.ast->Kind( fp->b ) <> N_INT_LIT then continue for
        dim as longint w = cast( longint, c.ast->literals[cast( long, c.ast->nodes[cast( long, fp->b )].data )].intValue )
        if w <= 0 then continue for
        dim as TypeId ft = c.types->Unqualify( c.info->TypeOf_( fp->a ) )
        if ft = TYPE_NONE then continue for
        if c.types->Kind( ft ) <> TK_BUILTIN then continue for
        dim as long bits = c.types->Layout( ft ).size * 8
        if bits <= 0 then continue for
        if w <= bits then continue for
        c.diags->Report( TKO0685, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( fp->name ) )
    next
end sub


'' A REDIM WRITES AS MANY DIMENSIONS AS THE ARRAY HAS -- fbc error 36 -- when the array
'' was declared with 'any' and so has a KNOWN rank. Measured: 'redim a(0 to 1, 0 to 1)'
'' over 'a(any)' is refused, over a field too, while 'redim a(0 to 1)' is the ordinary
'' use. A plain 'a()' has rank 0 and takes any shape.
''
'' THE RANK WRITTEN is the number of ranges in the bounds block.
'' A UNION IS INITIALISED WITH ONE VALUE, NOT A GROUP -- fbc error 7, "Expected ')'",
'' for 'dim as U x = ( ( 1, 2 ) )' and for '( ( 1, 2 ), 3 )' and '( 1, ( 2, 3 ) )' alike:
'' any nested parenthesised group inside a union's initializer is refused, whatever the
'' union holds. Eleven corpus files, all over a declared UNION.
private sub CheckUnionInitGroups_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        if c.types->Kind( u ) <> TK_UDT then continue for
        dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( u ) )
        dim as SymbolId tsid = c.syms->LookupLocalTyped( ds, c.types->NameOf( u ), true )
        if tsid = SYMBOL_NONE then tsid = c.syms->LookupTyped( ds, c.types->NameOf( u ), true )
        dim as Symbol ptr ts = c.syms->SymbolAt( tsid )
        if ts = 0 then continue for
        if (ts->flags and SYMF_UNION_KIND) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        dim as NodeKind bk = c.ast->Kind( ip->b )
        if (bk <> N_TUPLE) andalso (bk <> N_PAREN) andalso (bk <> N_INITIALIZER) then continue for
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->b )].data )]
        for j as long = 0 to lp->count - 1
            dim as NodeId el = cast( NodeId, c.ast->children[lp->first + j] )
            if el = NODE_NONE then continue for
            select case c.ast->Kind( el )
            case N_TUPLE, N_PAREN, N_INITIALIZER
                c.diags->Report( TKO0724, PointRange( c.ast->Loc( el ) ) )
                exit for
            end select
        next
    next
end sub

private sub CheckRedimRank_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_VAR then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if sp->op <> cast( ushort, KW_REDIM ) then continue for
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            '' THE BOUNDS ARE AN N_BLOCK OF RANGES in 'c', one per dimension -- not the
            '' item's own children, which is where a DIM's initialiser list goes.
            dim as long written = 0
            if ip->c <> NODE_NONE then
                if c.ast->Kind( ip->c ) = N_BLOCK then
                    written = c.ast->lists[cast( long, _
                        c.ast->nodes[cast( long, ip->c )].data )].count
                end if
            end if
            '' The array: a QUALIFIED target sits in 'b' as an expression; a bare one
            '' is the item's own name, bound on the item.
            dim as NodeId tgt = item
            if (ip->b <> NODE_NONE) andalso (ip->extra = cast( ushort, KW_REDIM )) then
                tgt = ip->b
            end if
            dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( tgt ) )
            dim as TypeId u = TYPE_NONE
            dim as string nm = ""
            if s <> 0 then
                if s->type_ = TYPE_NONE then continue for
                u = c.types->Unqualify( s->type_ )
                nm = c.names->Spelling( s->name )
            elseif (tgt <> item) andalso (c.ast->Kind( tgt ) <> N_IDENT) then
                '' 'redim ( 1 )( 0 to 0 )', 'redim ( a + b )( ... )', 'redim ( *pi )( ... )'
                '' -- an EXPRESSION in the target slot that binds no symbol. Its type is
                '' what is judged: fbc's error 54 for every one that is not a var-len
                '' array. Eight corpus files write one.
                u = c.types->Unqualify( c.info->TypeOf_( tgt ) )
                if u = TYPE_NONE then continue for
                if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
            else
                continue for
            end if
            '' 'redim a' OVER SOMETHING THAT IS NOT AN ARRAY -- fbc error 63 ("Expected
            '' array"), and 147 when bounds are written. Measured over an extern scalar.
            if c.types->Kind( u ) <> TK_ARRAY then
                if s <> 0 then
                    c.diags->Report( TKO0695, PointRange( c.ast->Loc( item ) ), nm )
                else
                    c.diags->Report( TKO0723, PointRange( c.ast->Loc( item ) ) )
                end if
                continue for
            end if
            '' ...AND A FIXED-SIZE ARRAY CANNOT BE REDIMENSIONED EITHER -- fbc error 54,
            '' "Expected var-len array": a variable, a field, 'this.array', the WITH
            '' shorthand and a parenthesised name all measure the same. Thirteen files.
            '' A FIXED STRING is an array of a character builtin and is not this.
            if c.types->IsDynArray( u ) = false then
                dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
                dim as boolean fixstr = false
                if c.types->Kind( el ) = TK_BUILTIN then
                    select case c.types->BuiltinOf( el )
                    case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                        fixstr = true
                    end select
                end if
                if fixstr = false then
                    c.diags->Report( TKO0723, PointRange( c.ast->Loc( item ) ) )
                end if
                continue for
            end if
            dim as long rank = c.types->DynRank( u )
            if rank <= 0 then
                '' A RANK-0 ARRAY TAKES ITS RANK FROM ITS FIRST REDIM; that redim itself is
                '' not judged, every later one is.
                dim as boolean isFirst = false
                for ri as long = 0 to c.redimItem.Count - 1
                    if c.redimItem[ri] = cast( ulong, item ) then isFirst = true
                next
                if isFirst then continue for
                if s <> 0 then rank = RecordedRank_( c, c.info->RefOf( tgt ) )
            end if
            if rank <= 0 then continue for
            if written <= 0 then continue for
            if written = rank then continue for
            c.diags->Report( TKO0658, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( s->name ) )
        next
    next
end sub

'' THREE THINGS AN ARRAY DECLARATION MAY NOT SAY, each measured against fbc:
''
''     type U : a(any) as const integer : end type     error 275  -- a DYNAMIC array
''     type U : a(0 to 3) as const integer : end type  OK         -- field cannot be const
''     dim a(any) as const integer                      error 237  -- a VARIABLE cannot be
''     dim a(0 to 3) as const integer                   error 237     const either way
''     type U : a(0 to ...) as integer : end type      error 77   -- '...' on a FIELD
''     dim a(0 to ...) as integer = { 1, 2 }            OK         -- fine on a variable
''
'' The ellipsis is read off the bounds block, where the parser leaves an N_ELLIPSIS node;
'' the const off the element type.
private function BoundsHaveEllipsis_ ( byref c as Ctx, byval bounds as NodeId ) as boolean
    if bounds = NODE_NONE then return false
    if c.ast->Kind( bounds ) <> N_BLOCK then return false
    dim as ListPayload ptr bl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, bounds )].data )]
    for i as long = 0 to bl->count - 1
        dim as NodeId r = cast( NodeId, c.ast->children[bl->first + i] )
        if r = NODE_NONE then continue for
        if c.ast->Kind( r ) = N_ELLIPSIS then return true
        if c.ast->Kind( r ) <> N_CASE_RANGE then continue for
        dim as BinaryPayload ptr rp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, r )].data )]
        if (rp->lhs <> NODE_NONE) andalso (c.ast->Kind( rp->lhs ) = N_ELLIPSIS) then return true
        if (rp->rhs <> NODE_NONE) andalso (c.ast->Kind( rp->rhs ) = N_ELLIPSIS) then return true
    next
    return false
end function

private sub CheckArrayDeclShapes_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        dim as SymbolKind k = cast( SymbolKind, s->kind )
        if (k <> SYM_FIELD) andalso (k <> SYM_VARIABLE) then continue for
        if s->type_ = TYPE_NONE then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        dim as NodeKind ik = c.ast->Kind( item )
        if (ik <> N_FIELD) andalso (ik <> N_VAR_ITEM) then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        if c.types->Kind( u ) <> TK_ARRAY then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        '' A FIXED STRING is an array of a character builtin and is none of this.
        dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        if c.types->Kind( el ) = TK_BUILTIN then
            select case c.types->BuiltinOf( el )
            case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                continue for
            end select
        end if
        dim as boolean constEl = c.types->IsConst( c.types->Inner( u ) )
        if ik = N_FIELD then
            '' A DYNAMIC ARRAY FIELD WRITES ITS RANK: 'array(any) as integer' is the form,
            '' and 'array() as integer' is fbc error 9, "Expected expression".
            if c.types->IsDynArray( u ) andalso (c.types->DynRank( u ) = 0) then
                c.diags->Report( TKO0721, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( s->name ) )
            end if
            if constEl andalso c.types->IsDynArray( u ) then
                c.diags->Report( TKO0690, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( s->name ) )
            end if
            '' A FIELD'S BOUNDS ARE ITS OWN CHILDREN, not a block in 'c' the way a
            '' variable's are -- the parser stores them flat, one node per bound.
            dim as boolean ell = BoundsHaveEllipsis_( c, ip->c )
            for b as long = 0 to ip->count - 1
                dim as NodeId bn = cast( NodeId, c.ast->children[ip->first + b] )
                if bn = NODE_NONE then continue for
                if c.ast->Kind( bn ) = N_ELLIPSIS then ell = true
            next
            if ell then
                c.diags->Report( TKO0691, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( s->name ) )
            end if
        else
            '' A PARAMETER IS NOT A VARIABLE HERE, and neither is a bydesc one.
            if (c.ast->nodes[cast( long, item )].flags and NF_ARRAY) = 0 then continue for
            '' ...UNLESS IT IS INITIALISED. 'dim x(0 to 2) as const integer = { 1, 2, 3 }'
            '' is accepted by fbc with a warning -- warnings/const-discard.bas writes it --
            '' and the corpus scan caught that. A const element with nothing to set it
            '' from is what is refused.
            if ip->b <> NODE_NONE then continue for
            if constEl then
                c.diags->Report( TKO0692, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( s->name ) )
            end if
        end if
    next
end sub

'' A STATIC-STORAGE SCALAR IS INITIALISED FROM A CONSTANT -- fbc error 11, "Expected
'' constant", for 'dim shared i as integer = x' over another shared variable, for 'static
'' i as integer = x' inside a sub, and for 'dim shared z as zstring * 32 = a' from a
'' string variable. A literal, a constant and an ADDRESS ('= @x') are accepted, and so is
'' a plain 'dim' from anything, and a BYREF from a shared. Only a bare NAMED variable on
'' the right is judged.
private sub CheckStaticInitFromVar_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and (SYMF_SHARED or SYMF_STATIC)) = 0 then continue for
        if (s->flags and SYMF_EXTERN) <> 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        if (c.ast->nodes[cast( long, item )].flags and NF_BYREF) <> 0 then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        if c.ast->Kind( ip->b ) <> N_IDENT then continue for
        dim as Symbol ptr src = c.syms->SymbolAt( c.info->RefOf( ip->b ) )
        if src = 0 then continue for
        if src->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        '' A type-level static MEMBER ('var UDT.i = ...') is another rule; the type must
        '' be a scalar builtin or a fixed string here, which is what was measured.
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId u = c.types->Unqualify( s->type_ )
        if c.types->Kind( u ) = TK_ARRAY then u = c.types->Unqualify( c.types->Inner( u ) )
        if c.types->Kind( u ) <> TK_BUILTIN then continue for
        c.diags->Report( TKO0725, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' 'dim shared' INSIDE A SCOPE BLOCK OR A PROCEDURE -- fbc error 96 in a scope and 61 in
'' a sub: shared storage is a module-level thing. 'static' inside a scope is fine.
private sub CheckSharedInBlock_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_SHARED) = 0 then continue for
        dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
        if sc = 0 then continue for
        if (sc->kind <> cast( ubyte, SCOPEK_BLOCK )) andalso _
           (sc->kind <> cast( ubyte, SCOPEK_PROC )) then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        c.diags->Report( TKO0726, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

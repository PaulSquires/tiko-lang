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

private sub CheckOutsideNamespace_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        dim as NodeKind k = c.ast->Kind( id )
        if (k <> N_PROC) andalso (k <> N_VAR_ITEM) then continue for
        if (c.ast->nodes[n].flags and NF_QUALIFIED) = 0 then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        dim as ScopeId ns = NamespaceScopeOf_( c, sp->ownerName )
        if ns = SCOPE_NONE then continue for
        dim as SymbolId have = c.syms->LookupLocal( ns, c.names->Fold( sp->name ) )
        if have <> SYMBOL_NONE then continue for
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

private function ParamCount_ ( byref c as Ctx, byval decl as NodeId ) as long
    if decl = NODE_NONE then return -1
    if c.ast->Kind( decl ) <> N_PROC then return -1
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long n = 0
    for i as long = 0 to sp->count - 1
        if c.ast->Kind( cast( NodeId, c.ast->children[sp->first + i] ) ) = N_PARAM then
            n += 1
        end if
    next
    return n
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
    if anyBydesc = false then return false

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

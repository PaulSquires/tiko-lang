'' latesweeps3.bas -- THE REST OF THE POST-CHECK SWEEPS.
''
'' Split out of latesweeps2.bas at the 1500-line lint cap and included from it, at the
'' exact spot these subs stood, inside the same namespace. Nothing in them changed in
'' the move. They are the later rules -- const writes, a constant's type, REDIM shape,
'' THREADCALL, a byref default, a cast's string size and what an aggregate initializer
'' may fill -- and every helper from latesweeps2.bas above the include is in scope.

'' The name an expression carries, for the diagnostic's '%0'.
private function SpellOf_ ( byref c as Ctx, byval n as NodeId ) as string
    if n = NODE_NONE then return ""
    if c.ast->Kind( n ) <> N_IDENT then return ""
    return c.names->Spelling( _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name )
end function

'' NOTHING CONST MAY BE WRITTEN -- fbc error 119, "Cannot modify a constant". The simple
'' case, an assignment straight to a const VARIABLE, is CheckAssignTarget_'s; these are the
'' spellings that reach const storage through an expression, and every one was measured:
''
''     *p = 1          p as const integer ptr          error 119
''     *p = 1          p as integer const ptr          ACCEPTED -- the POINTEE is writable
''     cast( const integer, i ) = 1                    error 24
''     *cptr( const integer ptr, pci ) = 123           error 119
''     swap a, b       either one const                error 119
''     let( i ) = x    i a const                       error 119
''     *p = 0          p from 'var p = @( x.n )', n a const FIELD    error 119
''     (*strptr( s ))[0] = c    s a const string       error 119
''
'' ALL OF THEM ASK ONE QUESTION -- is the type this expression designates CONST -- so the
'' target's own type answers it, and a const POINTER answers 'no' because its POINTEE is
'' what a dereference designates. That is the distinction the const-pointer parser fix
'' made expressible; before it every one of these was a coin toss.
private function ConstDesignated_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    dim as TypeId t = c.info->TypeOf_( n )
    if t = TYPE_NONE then return false
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Inner( t )
    return c.types->IsConst( t )
end function

'' The assignment targets CheckAssignTarget_ does not reach: a DEREFERENCE and a CAST.
'' A plain N_IDENT is left to it so nothing is reported twice.
private sub CheckConstWriteTarget_ ( byref c as Ctx, byval id as NodeId )
    if c.info->AmbiguousOf( id ) <> AMB_ASSIGN then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( sp->a )
    dim as boolean judged = (k = N_DEREF) orelse (k = N_INDEX)
    if k = N_CALL then
        '' 'cast( const T, x ) = ...' -- a CAST is not a call, and its result type is
        '' what is being written. A real call on the left is a property or an array
        '' subscript and is somebody else's question.
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
        if lp->target <> NODE_NONE then
            if c.ast->Kind( lp->target ) = N_IDENT then
                if c.info->RefOf( lp->target ) = SYMBOL_NONE then
                    dim as string cn = lcase( c.names->Spelling( _
                        c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name ) )
                    judged = (cn = "cast") orelse (cn = "cptr")
                    '' 'mid( s, i, n ) = v' WRITES INTO s, so a const string there is
                    '' fbc's 119 -- while a const INDEX argument is fine. The call's own
                    '' type is the string it returns, so argument 0 is what is judged.
                    if cn = "mid" then
                        if lp->count >= 1 then
                            dim as NodeId m0 = cast( NodeId, c.ast->children[lp->first] )
                            if ConstDesignated_( c, m0 ) then
                                c.diags->Report( TKO0617, _
                                    PointRange( c.ast->Loc( m0 ) ), SpellOf_( c, m0 ) )
                            end if
                        end if
                        return
                    end if
                end if
            end if
        end if
    end if
    if judged = false then return
    if ConstDesignated_( c, sp->a ) = false then return
    c.diags->Report( TKO0617, PointRange( c.ast->Loc( sp->a ) ), "" )
end sub

'' SWAP WRITES BOTH OPERANDS, so a const on either side is fbc's 119. Measured both ways.
'' SWAP EXCHANGES STORAGE AND CONVERTS NOTHING, so its two operands must be of the same
'' KIND -- fbc error 20. Measured across the whole grid, and the kinds are broad:
''
''     string  <-> integer          error 20      integer <-> long      accepted
''     UDT     <-> any ptr          error 20      integer <-> double    accepted
''     Parent  <-> Child            error 20      integer <-> boolean   accepted
''     string  <-> any ptr          error 20      zstring * 8 <-> string   accepted
''                                                integer ptr <-> any ptr  accepted
''                                                two of the SAME udt      accepted
''
'' So NUMBER, STRING, POINTER and each UDT are the four kinds, a fixed string counts as a
'' STRING (it is an array of a character builtin), and two UDTs must be the same type.
'' Anything else -- an array that is not a fixed string, a procedure -- is declined.
private function SwapKindOf_ _
    ( byref c as Ctx, byval t as TypeId, byref udt as TypeId ) as long
    udt = TYPE_NONE
    dim as TypeId u = ValueType_( c, t )
    if u = TYPE_NONE then return 0
    if c.types->Kind( u ) = TK_ARRAY then
        dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        if c.types->Kind( el ) = TK_BUILTIN then
            select case c.types->BuiltinOf( el )
            case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                return 2
            end select
        end if
        return 0
    end if
    if c.types->Kind( u ) = TK_POINTER then return 3
    if c.types->Kind( u ) = TK_UDT then
        udt = u
        return 4
    end if
    if c.types->Kind( u ) <> TK_BUILTIN then return 0
    select case c.types->BuiltinOf( u )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return 2
    case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG, _
         TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT, TY_SINGLE, TY_DOUBLE, _
         TY_BOOLEAN
        return 1
    end select
    return 0
end function

'' EIGHT LEVELS OF POINTER IS THE LIMIT -- fbc error 274, "Too many levels of pointer
'' indirection". Measured exactly at the boundary, and it counts THROUGH TYPEDEFS:
''
''     dim p as integer ptr x8                                  accepted
''     dim p as integer ptr x9                                  error 274
''     type t as integer ptr x4 : dim p as t ptr x4             accepted
''     type t as integer ptr x4 : dim p as t ptr x5             error 274
''     type t as integer ptr x4 : type u as t ptr x4 : dim p as u ptr   error 274
''
'' The RESOLVED type is what carries the answer, so the count is a walk down Inner( ) --
'' a typedef has already been substituted by the time this runs.
private function PointerDepth_ ( byref c as Ctx, byval t as TypeId ) as long
    dim as long n = 0
    dim as TypeId u = c.types->Unqualify( t )
    while (u <> TYPE_NONE) andalso (n < 64)
        if c.types->Kind( u ) <> TK_POINTER then exit while
        n += 1
        u = c.types->Unqualify( c.types->Inner( u ) )
    wend
    return n
end function

'' TWO WAYS TO GET fbc's 158 FROM OUTSIDE, both measured with their accepted twins:
''
''     namespace ns { dim shared arr( ) }
''       redim ns.arr( 4 to 5 ) as integer            accepted
''       redim SHARED ns.arr( 4 to 5 ) as integer     error 158 -- SHARED re-declares
''     namespace ns { extern i as integer }
''       dim ns.i as integer                          accepted -- defines the extern
''       ...a SECOND 'dim ns.i as integer'            error 158
''     namespace ns { extern arr( ) as integer }
''       redim ns.arr( ) as integer  (once)           accepted
''       ...a SECOND 'redim ns.arr( )'                error 158
''       redim ns.arr( ) then redim ns.arr( 0 to 2 )  accepted -- the second RE-DIMENSIONS
''     type U { static i( ) as integer }
''       redim U.i( ) as integer  (once)              accepted
''       ...a SECOND one                              error 158
''
'' The second half turns on the same distinction TKO0751 needed: EMPTY parens declare and
'' written BOUNDS re-dimension, so only a bounds-less qualified declaration is a
'' DEFINITION, and only a second definition of one name is the error.
'' Is this qualified item a DEFINITION -- a type written and no bounds?
private function IsOutsideDefinition_ ( byref c as Ctx, byval item as NodeId ) as boolean
    if c.ast->Kind( item ) <> N_VAR_ITEM then return false
    if (c.ast->nodes[cast( long, item )].flags and NF_QUALIFIED) = 0 then return false
    dim as StmtPayload ptr ip = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
    if ip->ownerName = 0 then return false
    if ip->a = NODE_NONE then return false
    if ip->c <> NODE_NONE then
        if c.ast->Kind( ip->c ) = N_BLOCK then
            if c.ast->lists[cast( long, _
                c.ast->nodes[cast( long, ip->c )].data )].count > 0 then return false
        end if
    end if
    return true
end function

'' ONE STATEMENT LIST AT A TIME. Comparing qualified definitions across the WHOLE file
'' called two independent ones a duplicate: dim/member-var.bas declares a 'type UDT' with
'' a static member inside SEVERAL test blocks and defines 'UDT.a' in each, and
'' namespace/outside.bas does the same with 'varB.i2'. Two definitions collide only when
'' they sit in the SAME list, which is what fbc means by a redefinition here.
private sub CheckOutsideRange_ ( byref c as Ctx, byval blk as NodeId )
    if blk = NODE_NONE then return
    dim as NodeKind bk = c.ast->Kind( blk )
    if (bk <> N_BLOCK) andalso (bk <> N_MODULE) then return
    dim as ListPayload ptr bl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, blk )].data )]
    for i as long = 0 to bl->count - 1
        dim as NodeId st = cast( NodeId, c.ast->children[bl->first + i] )
        if st = NODE_NONE then continue for
        dim as NodeKind sk = c.ast->Kind( st )
        '' Descend into everything that carries a statement list of its own.
        if sk = N_NAMESPACE then
            dim as StmtPayload ptr np = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st )].data )]
            CheckOutsideRange_( c, np->b )
            continue for
        end if
        if sk = N_PROC then
            dim as StmtPayload ptr pp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st )].data )]
            CheckOutsideRange_( c, pp->b )
            continue for
        end if
        if sk = N_SCOPE then
            dim as StmtPayload ptr cp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st )].data )]
            CheckOutsideRange_( c, cp->b )
            continue for
        end if
        if sk <> N_VAR then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, st )].data )]
        dim as boolean isShared = _
            ((c.ast->nodes[cast( long, st )].flags and NF_SHARED) <> 0)
        for k as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + k] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            if (c.ast->nodes[cast( long, item )].flags and NF_QUALIFIED) = 0 then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            if ip->ownerName = 0 then continue for
            if isShared then
                if NamespaceScopeOf_( c, ip->ownerName ) <> SCOPE_NONE then
                    c.diags->Report( TKO0761, PointRange( c.ast->Loc( item ) ), _
                                     c.names->Spelling( ip->ownerName ) & "." & _
                                     c.names->Spelling( ip->name ) )
                    continue for
                end if
            end if
            if IsOutsideDefinition_( c, item ) = false then continue for
            dim as InternId wo = c.names->Fold( ip->ownerName )
            dim as InternId wn = c.names->Fold( ip->name )
            dim as boolean seen = false
            for m as long = 0 to i - 1
                dim as NodeId ps = cast( NodeId, c.ast->children[bl->first + m] )
                if ps = NODE_NONE then continue for
                if c.ast->Kind( ps ) <> N_VAR then continue for
                dim as StmtPayload ptr pv = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, ps )].data )]
                for j as long = 0 to pv->count - 1
                    dim as NodeId pit = cast( NodeId, c.ast->children[pv->first + j] )
                    if IsOutsideDefinition_( c, pit ) = false then continue for
                    dim as StmtPayload ptr pip = _
                        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pit )].data )]
                    if c.names->Fold( pip->ownerName ) <> wo then continue for
                    if c.names->Fold( pip->name ) <> wn then continue for
                    seen = true
                next
            next
            if seen = false then continue for
            c.diags->Report( TKO0762, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( ip->ownerName ) & "." & _
                             c.names->Spelling( ip->name ) )
        next
    next
end sub

private sub CheckOutsideDefinitions_( byref c as Ctx )
    CheckOutsideRange_( c, c.root )
end sub

'' AN ARRAY DECLARATION IS ALL 'any' OR ALL WRITTEN BOUNDS -- fbc's error 9 with the
'' bounds first and 94 with 'any' first, but one refusal either way. Measured:
''
''     dim a( 0 to 0, any )    error 9      dim a( any, any )        accepted
''     dim a( any, 0 to 0 )    error 94     dim a( 0 to 0, 0 to 1 )  accepted
''                                          dim a( any )             accepted
''
'' The two spellings sit side by side in the bounds block: a written range is an
'' N_CASE_RANGE and an 'any' is a bare N_IDENT, so the mix is visible without resolving
'' anything.
''
'' ...AND A TYPE'S ARRAY FIELD IS DECLARED WITH 'dim', NOT 'redim' -- 'type UDT { redim
'' array( ) as integer }' is fbc's 9 as well, while 'array( any ) as integer' is the form.
private sub CheckArrayBoundKinds_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if ip->c = NODE_NONE then continue for
        if c.ast->Kind( ip->c ) <> N_BLOCK then continue for
        dim as ListPayload ptr bl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->c )].data )]
        if bl->count < 2 then continue for
        dim as boolean sawAny = false
        dim as boolean sawBounds = false
        for i as long = 0 to bl->count - 1
            dim as NodeId b = cast( NodeId, c.ast->children[bl->first + i] )
            if b = NODE_NONE then continue for
            if c.ast->Kind( b ) = N_CASE_RANGE then
                sawBounds = true
            elseif c.ast->Kind( b ) = N_IDENT then
                dim as string bn = lcase( c.names->Spelling( _
                    c.ast->idents[cast( long, c.ast->nodes[cast( long, b )].data )].name ) )
                if bn = "any" then sawAny = true
            end if
        next
        if (sawAny andalso sawBounds) = false then continue for
        c.diags->Report( TKO0765, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( ip->name ) )
    next
end sub

private sub CheckRedimInType_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_TYPE then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        for i as long = 0 to sp->count - 1
            dim as NodeId m = cast( NodeId, c.ast->children[sp->first + i] )
            if m = NODE_NONE then continue for
            if c.ast->Kind( m ) <> N_VAR then continue for
            dim as StmtPayload ptr mp = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, m )].data )]
            if mp->op <> cast( ushort, KW_REDIM ) then continue for
            '' ...ONLY WITH EMPTY PARENS. 'redim a( 0 to 0 )' and 'redim a( any )' inside a
            '' type are both accepted -- structs/dynamic-array-fields.bas says in a comment
            '' that REDIM makes a dynamic array there even with constant bounds, and
            '' structs/udt-array-ops-1.bas writes the 'any' form. Only a field with NOTHING
            '' between the parentheses is fbc's 9, which is the same empty-parens-versus-
            '' bounds distinction TKO0751 and TKO0762 turn on.
            for k as long = 0 to mp->count - 1
                dim as NodeId it = cast( NodeId, c.ast->children[mp->first + k] )
                if c.ast->Kind( it ) <> N_VAR_ITEM then continue for
                dim as StmtPayload ptr ipp = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, it )].data )]
                if ipp->c <> NODE_NONE then
                    if c.ast->Kind( ipp->c ) = N_BLOCK then
                        if c.ast->lists[cast( long, _
                            c.ast->nodes[cast( long, ipp->c )].data )].count > 0 then continue for
                    end if
                end if
                c.diags->Report( TKO0766, PointRange( c.ast->Loc( m ) ) )
                exit for
            next
            continue for
        next
    next
end sub

private sub CheckPointerDepth_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_TYPEREF then continue for
        '' ONLY THE OUTERMOST typeref of a chain is judged: the inner ones are the same
        '' type one level shallower, and reporting each would give nine diagnostics for
        '' one declaration. A typeref whose PARENT is another typeref is an inner one --
        '' which is what a pointer wrapper is, so the test is on the node's own flags.
        if (c.ast->nodes[n].flags and NF_PTR) = 0 then continue for
        dim as long depth = PointerDepth_( c, c.info->TypeOf_( id ) )
        if depth <= 8 then continue for
        c.diags->Report( TKO0760, PointRange( c.ast->Loc( id ) ) )
        return
    next
end sub

private sub CheckSwapTypes_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_SWAP then return
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    dim as TypeId au, bu
    dim as long ak = SwapKindOf_( c, c.info->TypeOf_( sp->a ), au )
    dim as long bk = SwapKindOf_( c, c.info->TypeOf_( sp->b ), bu )
    if (ak = 0) orelse (bk = 0) then return
    '' A UDT WITH A CONVERSION OPERATOR IS NOT THIS QUESTION. 'swap str( u1 ), u2' over a
    '' type that casts to a zstring is accepted by fbc, and this suite's own
    '' swap-udt-zstring test writes exactly that mixed spelling -- which overload runs is
    '' not modelled here, so any 'cast' at all declines.
    if au <> TYPE_NONE then
        if DeclaresAnywhere_( c, au, "cast" ) then return
    end if
    if bu <> TYPE_NONE then
        if DeclaresAnywhere_( c, bu, "cast" ) then return
    end if
    dim as boolean bad = (ak <> bk)
    if (bad = false) andalso (ak = 4) then bad = (au <> bu)
    if bad = false then return
    c.diags->Report( TKO0759, PointRange( c.ast->Loc( id ) ) )
end sub

private sub CheckSwapConst_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_SWAP then return
    for pass_ as long = 0 to 1
        dim as NodeId v = sp->a
        if pass_ = 1 then v = sp->b
        if v = NODE_NONE then continue for
        '' A LITERAL and a NAMED CONSTANT are TKO0642's, not this rule's -- reporting them
        '' here too put two diagnostics on one 'swap K, b'. What TKO0642 does not see is a
        '' variable whose TYPE is const, which is what rtl-swap.bas writes.
        dim as boolean bad = ConstDesignated_( c, v )
        if bad then
            c.diags->Report( TKO0617, PointRange( c.ast->Loc( v ) ), _
                             SpellOf_( c, v ) )
            return
        end if
    next
end sub

'' A CONSTANT'S TYPE MUST BE ONE A VALUE CAN BE FOLDED INTO -- fbc error 24. Measured
'' across the whole set, and the accepted side is wide:
''
''     integer  double  single  longint  ubyte  boolean       accepted
''     string (plain)   any pointer      an enum              accepted
''     any              string * 20      zstring * 20         error 24
''     wstring * 20     a UDT            a UDT with no '='    error 24
''
'' A FIXED STRING IS AN ARRAY of a character builtin in this type model, which is what the
'' TK_ARRAY test below is reading; a const ARRAY is not a thing FreeBASIC has.
private sub CheckConstDeclTypes2_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_CONST then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            '' WITHOUT AN EXPLICIT TYPE there is nothing to judge: 'const k = 1' infers.
            if ip->a = NODE_NONE then continue for
            dim as TypeId t = c.types->Unqualify( c.info->TypeOf_( ip->a ) )
            if t = TYPE_NONE then continue for
            dim as boolean bad = false
            select case c.types->Kind( t )
            case TK_UDT, TK_ARRAY
                bad = true
            case TK_BUILTIN
                bad = (c.types->BuiltinOf( t ) = TY_ANY)
            end select
            if bad = false then continue for
            c.diags->Report( TKO0748, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( ip->name ) )
        next
    next
end sub

'' WHAT 'threadcall' CAN RUN. Two fbc errors, both measured over the whole threads/
'' family, and the accepted side of each measured beside it:
''
''     threadcall goodSub( )                 accepted
''     threadcall someFunction( )            error 289 -- a FUNCTION is not a sub
''     threadcall bc.BadMember( )            error 289 -- and neither is a qualified call
''     threadcall pascalSub( )               error 288 -- the calling convention
''     threadcall cdeclSub( ) / stdcallSub( )  accepted
''     threadcall f( u )  u a BYVAL UDT holding an ARRAY, STRING or BITFIELD   error 288
''     threadcall f( u )  u a byval UNION, or a UDT with an anonymous one   error 288
''     threadcall f( u )  u a byval UDT holding a BITFIELD        error 288
''     threadcall f( u )  u a byval PLAIN UDT                     accepted
''
'' The 288 cases are all the same shape: the thread trampoline copies each byval argument,
'' and fbc will not copy an aggregate whose layout it cannot pass through one pointer.
private function ThreadUnsupportedUdt_ _
    ( byref c as Ctx, byval t as TypeId, byref why as string, byval depth as long ) as boolean

    if depth > 8 then return false
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> TK_UDT then return false
    dim as Symbol ptr ts = UdtSymbolOf_( c, u )
    if ts = 0 then return false
    if (ts->flags and SYMF_UNION_KIND) <> 0 then
        why = "a union cannot be passed to a thread"
        return true
    end if
    if ts->inner = SCOPE_NONE then return false
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr f = @c.syms->symbols[i]
        if f->parent <> ts->inner then continue for
        if f->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if (f->flags and SYMF_UNION) <> 0 then
            why = "a union field cannot be passed to a thread"
            return true
        end if
        if (f->flags and SYMF_BITFIELD) <> 0 then
            why = "a bitfield cannot be passed to a thread"
            return true
        end if
        if f->type_ = TYPE_NONE then continue for
        dim as TypeId ft = c.types->Unqualify( f->type_ )
        if c.types->Kind( ft ) = TK_BUILTIN then
            if c.types->BuiltinOf( ft ) = TY_STRING then
                why = "a string field cannot be passed byval to a thread"
                return true
            end if
        end if
        if c.types->Kind( ft ) = TK_ARRAY then
            '' A FIXED STRING is an array of a character builtin and is not this.
            dim as TypeId el = c.types->Unqualify( c.types->Inner( ft ) )
            dim as boolean fixstr = false
            if c.types->Kind( el ) = TK_BUILTIN then
                select case c.types->BuiltinOf( el )
                case TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
                    fixstr = true
                end select
            end if
            if fixstr = false then
                why = "an array field cannot be passed to a thread"
                return true
            end if
        end if
        if c.types->Kind( ft ) = TK_UDT then
            if ThreadUnsupportedUdt_( c, ft, why, depth + 1 ) then return true
        end if
    next
    return false
end function

private sub CheckThreadCall_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_THREADCALL then return
    '' THE CALL IS THE ONE CHILD, not 'a': the parser pushes it into the child list.
    if sp->count < 1 then return
    dim as NodeId tcall = cast( NodeId, c.ast->children[sp->first] )
    if tcall = NODE_NONE then return
    if c.ast->Kind( tcall ) <> N_CALL then return
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, tcall )].data )]
    if lp->target = NODE_NONE then return

    '' A QUALIFIED CALL is not a plain sub either -- 'bc.BadMember( )' is fbc's 289.
    if c.ast->Kind( lp->target ) = N_MEMBER then
        c.diags->Report( TKO0749, PointRange( c.ast->Loc( tcall ) ), "this member call" )
        return
    end if
    dim as Symbol ptr callee = c.syms->SymbolAt( c.info->RefOf( tcall ) )
    if callee = 0 then callee = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if callee = 0 then return
    if callee->kind <> cast( ubyte, SYM_PROC ) then return
    dim as NodeId decl = cast( NodeId, callee->payload )
    if decl = NODE_NONE then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as StmtPayload ptr pp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]

    '' A FUNCTION IS NOT A SUB. The result type is what says so: a SUB has none.
    if cast( TokenKind, pp->op ) = KW_FUNCTION then
        c.diags->Report( TKO0749, PointRange( c.ast->Loc( tcall ) ), _
                         c.names->Spelling( pp->name ) )
        return
    end if
    if (pp->extra and PF_PASCAL) <> 0 then
        c.diags->Report( TKO0750, PointRange( c.ast->Loc( tcall ) ), _
                         c.names->Spelling( pp->name ), _
                         "the PASCAL calling convention is not supported" )
        return
    end if
    for i as long = 0 to pp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        '' BYVAL ONLY. The byval side is consistent and was measured whole: a UDT holding
        '' an ARRAY, a STRING or a BITFIELD, and a UNION, are each fbc's 288, while a plain
        '' UDT, an integer and a string PARAMETER are all accepted.
        ''
        '' THE BYREF SIDE IS NOT MODELLED, because it does not reduce to "contains X" and
        '' guessing it refused threads/threadcall.bas, which fbc compiles:
        ''
        ''     byref, UDT holding an array only          error 288
        ''     byref, that UDT plus a STRING field       ACCEPTED
        ''     byref, that UDT plus a BITFIELD           ACCEPTED
        ''     byref, a UNION                            error 288
        ''
        '' Whatever decides that, it is not the field list alone, so the whole byref half
        '' is declined rather than half-modelled.
        if (c.ast->nodes[cast( long, prm )].flags and NF_BYREF) <> 0 then continue for
        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) <> 0 then continue for
        dim as StmtPayload ptr prp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if prp->a = NODE_NONE then continue for
        dim as string why = ""
        if ThreadUnsupportedUdt_( c, c.info->TypeOf_( prp->a ), why, 0 ) then
            c.diags->Report( TKO0750, PointRange( c.ast->Loc( tcall ) ), _
                             c.names->Spelling( pp->name ), why )
            return
        end if
    next
end sub

'' TWO THINGS EVERY REDIM MUST HAVE. Measured, with the accepted line beside each:
''
''     redim array( 1 to 2 )                     error 147 -- it DECLARES, with no type
''     redim shared a( 0 to 1 )                  error 147
''     redim a$( 0 to 1 )                        error 147 -- a suffix is not a type
''     extern a( ) as integer : redim a( )       error 147 -- still declares nothing typed
''     redim array( 1 to 2 ) as integer          accepted
''     dim a( ) as integer : redim a( 0 to 2 )   accepted -- the DIM gave it a type
''     redim a( 0 to 2 ) as integer : redim a( 0 to 3 )    accepted -- so did the first
''     sub s( a( ) as integer ) : redim a( 0 to 2 )        accepted -- so did the parameter
''
''     redim array as integer                    error 63 -- no bounds at all
''     redim a$                                  error 63
''     dim a( ) as integer : redim a as integer  error 63
''
'' The first rule is about a redim that DECLARES: the ordinary re-dimensioning of an array
'' something else already declared needs no type, which is the commonest spelling there is.
'' The symbol's own declaration item is what says which this is -- when the redim item IS
'' the declaration, nothing else typed the array.
private sub CheckRedimDeclShape_( byref c as Ctx )
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

            '' BOUNDS FIRST: without them there is no array to re-dimension at all, and
            '' that is the error whether or not a type was written.
            '' NO PARENTHESES AT ALL is the 63: there is no array here to re-dimension.
            '' EMPTY parens 'a( )' are a different thing and are read below.
            dim as boolean hasParens = false
            dim as long bounds = 0
            if ip->c <> NODE_NONE then
                if c.ast->Kind( ip->c ) = N_BLOCK then
                    hasParens = true
                    bounds = c.ast->lists[cast( long, _
                        c.ast->nodes[cast( long, ip->c )].data )].count
                end if
            end if
            if hasParens = false then
                '' ...UNLESS THE TARGET IS NOT AN ARRAY AT ALL, which is TKO0695's. 'redim
                '' scalar' over an 'extern scalar as integer' is one fbc error, and putting
                '' both on it made two -- caught by this suite's outside-namespace-2 test.
                dim as Symbol ptr ns = c.syms->SymbolAt( c.info->RefOf( item ) )
                if ns <> 0 then
                    if ns->type_ <> TYPE_NONE then
                        if c.types->Kind( c.types->Unqualify( ns->type_ ) ) <> TK_ARRAY then
                            continue for
                        end if
                    end if
                end if
                c.diags->Report( TKO0752, PointRange( c.ast->Loc( item ) ), _
                                 c.names->Spelling( ip->name ) )
                continue for
            end if

            if ip->a <> NODE_NONE then continue for
            '' A QUALIFIED or object-target redim names something declared elsewhere.
            if (c.ast->nodes[cast( long, item )].flags and NF_QUALIFIED) <> 0 then continue for
            if (ip->b <> NODE_NONE) andalso (ip->extra = cast( ushort, KW_REDIM )) then continue for
            '' WITHOUT A TYPE the redim must be RE-dimensioning something already declared,
            '' and it must actually write bounds. Measured, and both halves are needed:
            ''
            ''     dim a( ) as integer : redim a( 0 to 2 )   accepted
            ''     dim a( ) as integer : redim a( )          error 147 -- empty parens
            ''     redim array( 1 to 2 )                     error 147 -- nothing declared it
            ''     redim a( ) as integer                     accepted
            dim as boolean declaredElsewhere = _
                (c.info->RefOf( item ) <> SYMBOL_NONE)
            if declaredElsewhere andalso (bounds > 0) then continue for
            c.diags->Report( TKO0751, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( ip->name ) )
        next
    next
end sub

'' A BYREF PARAMETER WITH A DEFAULT NEEDS A COMPLETE TYPE -- fbc error 71. The default
'' has to be materialised somewhere for the reference to point at, and neither 'any' nor a
'' forward declaration says how big that is. Measured, and the DEFAULT is what makes the
'' difference:
''
''     declare sub f( byref x as any = 0 )               error 71
''     declare sub f( byref x as any )                   accepted
''     type td as forward : declare sub f( byref x as td = 0 )   error 71
''     type td as forward : declare sub f( byref x as td )       accepted
private sub CheckByrefParamDefault_ ( byref c as Ctx, byval id as NodeId )
    if (c.ast->nodes[cast( long, id )].flags and NF_BYREF) = 0 then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    if sp->a = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    dim as boolean incomplete = false
    if t = TYPE_NONE then
        incomplete = true
    else
        dim as TypeId u = c.types->Unqualify( t )
        select case c.types->Kind( u )
        case TK_FORWARD
            incomplete = true
        case TK_BUILTIN
            incomplete = (c.types->BuiltinOf( u ) = TY_ANY)
        end select
    end if
    if incomplete = false then return
    c.diags->Report( TKO0755, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( sp->name ) )
end sub

'' A CAST TO A STRING TYPE NEEDS A SIZE -- fbc error 28. 'cast( zstring, "a" )' and
'' 'cast( wstring, wstr( "a" ) )' name a type with no storage to cast into, while
'' 'cast( zstring * 4, z )' and 'cast( zstring ptr, @z )' are both fine. A cast to a plain
'' STRING is fbc's error 20 and a different question, so only the character types are read.
private sub CheckCastStringSize_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    if c.ast->Kind( lp->target ) <> N_IDENT then return
    if c.info->RefOf( lp->target ) <> SYMBOL_NONE then return
    dim as string cn = lcase( c.names->Spelling( _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name ) )
    if (cn <> "cast") andalso (cn <> "cptr") then return
    if lp->count < 1 then return
    dim as NodeId tref = cast( NodeId, c.ast->children[lp->first] )
    if tref = NODE_NONE then return
    if c.ast->Kind( tref ) <> N_TYPEREF then return
    dim as TypeId t = c.types->Unqualify( c.info->TypeOf_( tref ) )
    if t = TYPE_NONE then return
    '' A SIZED string is an ARRAY of the character type and a POINTER is a pointer; only
    '' the bare builtin has nothing to cast into.
    if c.types->Kind( t ) <> TK_BUILTIN then return
    select case c.types->BuiltinOf( t )
    case TY_ZSTRING, TY_WSTRING, TY_USTRING
        c.diags->Report( TKO0756, PointRange( c.ast->Loc( id ) ) )
    end select
end sub

'' WHAT AN AGGREGATE INITIALIZER CANNOT FILL -- both fbc's error 24, and the two halves
'' differ in exactly one way, which was measured:
''
''     type U { s as string } : dim shared x as U = ( "123" )   error 24
''     ...the same from a VARIABLE                              error 24
''     ...the same declared LOCAL, inside a sub                 error 24  -- any storage
''     ...the same with NO initializer                          accepted
''     type U { a:1 as integer } : dim shared x as U = ( 1 )    error 24
''     ...as 'var shared x = type<U>( 1 )'                      error 24
''     ...the same declared LOCAL, inside a sub                 ACCEPTED  -- static only
''     type U { i as integer } : dim shared x as U = ( 1 )      accepted
''     dim as (long, string) s = ( 1, "hello" )                 accepted -- a TUPLE
''     ...and any type with a CONSTRUCTOR                        accepted -- a ctor CALL
''
'' So a VAR-LEN STRING field is refused wherever the variable lives, and a BITFIELD only
'' when the storage is static: a local one is filled by generated code rather than by the
'' loader, and fbc will do that for a bitfield but not for a string.
private function UdtHoldsKind_ _
    ( byref c as Ctx, byval t as TypeId, byval wantString as boolean, _
      byval depth as long ) as Symbol ptr

    if depth > 8 then return 0
    dim as TypeId u = ValueType_( c, t )
    if u = TYPE_NONE then return 0
    if c.types->Kind( u ) <> TK_UDT then return 0
    '' A TUPLE IS NOT A UDT FOR THIS RULE, even though it is synthesised as one:
    '' 'dim as (long, string) s = ( 1, "hello" )' is accepted by fbc and is what this
    '' suite's own tuple-compare and tuple-destructure tests write, while the identical
    '' shape over a NAMED type holding a string is error 24.
    if TupleLike_( c, u ) then return 0
    dim as Symbol ptr ts = UdtSymbolOf_( c, u )
    if ts = 0 then return 0
    if ts->inner = SCOPE_NONE then return 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr f = @c.syms->symbols[i]
        if f->parent <> ts->inner then continue for
        if f->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if wantString then
            if f->type_ <> TYPE_NONE then
                dim as TypeId ft = c.types->Unqualify( f->type_ )
                if c.types->Kind( ft ) = TK_BUILTIN then
                    if c.types->BuiltinOf( ft ) = TY_STRING then return f
                end if
            end if
        else
            if (f->flags and SYMF_BITFIELD) <> 0 then return f
        end if
        if f->type_ <> TYPE_NONE then
            dim as TypeId ft2 = c.types->Unqualify( f->type_ )
            if c.types->Kind( ft2 ) = TK_UDT then
                dim as Symbol ptr deeper = UdtHoldsKind_( c, ft2, wantString, depth + 1 )
                if deeper <> 0 then return deeper
            end if
        end if
    next
    return 0
end function

private sub CheckAggregateInitFields_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if s->type_ = TYPE_NONE then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        select case c.ast->Kind( ip->b )
        case N_TUPLE, N_PAREN, N_INITIALIZER
        case else
            continue for
        end select
        '' A CONSTRUCTOR MAKES THE PARENTHESES A CALL, not an aggregate, and then no field
        '' is filled by a list at all: 'dim d as BBDerived = ( 5678 )' over a type with a
        '' constructor is accepted by fbc even though the type inherits a string field.
        '' structs/derived-ptr-assign.bas writes exactly that, and the differential scan
        '' caught this rule refusing it -- the same distinction TKO0746 needed.
        if DeclaresAnywhere_( c, ValueType_( c, s->type_ ), "__ctor" ) then continue for
        dim as Symbol ptr sf = UdtHoldsKind_( c, s->type_, true, 0 )
        if sf <> 0 then
            c.diags->Report( TKO0757, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( s->name ) )
            continue for
        end if
        '' THE BITFIELD HALF IS STATIC-STORAGE ONLY.
        dim as boolean isStatic = _
            ((s->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or SYMF_COMMON)) <> 0)
        if isStatic = false then
            '' MODULE LEVEL IS STATIC STORAGE TOO. ScopeIsStatic_ answers this in
            '' visibility.bas, but it is defined AFTER this include, so the same walk is
            '' spelled here: a PROC scope means the variable is on the stack, anything
            '' else -- module, namespace, type -- means it is not.
            dim as ScopeId cur = s->parent
            dim as long guard = 0
            dim as boolean onStack = false
            while (cur <> SCOPE_NONE) andalso (guard < 1000)
                guard += 1
                dim as SymScope ptr sc = c.syms->ScopeAt( cur )
                if sc = 0 then exit while
                if sc->kind = cast( ubyte, SCOPEK_PROC ) then
                    onStack = true
                    exit while
                end if
                if sc->kind = cast( ubyte, SCOPEK_NAMESPACE ) then exit while
                if sc->kind = cast( ubyte, SCOPEK_TYPE ) then exit while
                cur = sc->parent
            wend
            if onStack then continue for
        end if
        dim as Symbol ptr bf = UdtHoldsKind_( c, s->type_, false, 0 )
        if bf = 0 then continue for
        c.diags->Report( TKO0758, PointRange( c.ast->Loc( item ) ), _
                         c.names->Spelling( s->name ) )
    next
end sub

'' lowerinit.bas -- THE SMALL PREDICATES AND HELPERS THE ASSIGNMENT AND DECLARATION
'' PATHS ASK: a copy constructor by shape, a result field list, and 'any' as an
'' initialiser.
''
'' Split out of lower.bas at the 1500-line cap and included from it in the same place.
'' Nothing in them changed in the move.

'' THE COPY CONSTRUCTOR of a UDT: the one-argument constructor whose parameter is that
'' same type. StructorWithArity answers any one-argument constructor at all, which is
'' not the same question -- a type whose only constructor takes a long had that one
'' chosen to copy it with.
private function CopyCtorOf_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    dim as Tko.SymbolId s = StructorWithArity( c, StructorOf( c, t, "__ctor" ), 1 )
    if s = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId pt = ParamTypeAt( c, s, 0 )
    if pt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Inner( pt )
    if c.types->Unqualify( pt ) <> c.types->Unqualify( t ) then return Tko.SYMBOL_NONE
    return s
end function

'' A FIELD LIST ASSIGNED TO THE RESULT -- 'function = ( 1, 2 )' and 'function =
'' type( 1, 2 )'. The result slot IS the object, so this is the declaration
'' initialiser with the result's type standing in for the declared one.
private function ResultFieldListInit_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as boolean

    if c.resultSlot < 0 then return false
    if c.resultType = Tko.TYPE_NONE then return false
    if e = Tko.NODE_NONE then return false
    '' ONLY THE 'type( ... )' SPELLING. Measured: fbc accepts 'function = type( 5, 6 )'
    '' and rejects 'function = ( 5, 6 )' with error 7, expecting ')' where the comma
    '' is. The two build the same node, so the parser marks which was written.
    if c.ast->Kind( e ) <> Tko.N_TUPLE then return false
    '' ...UNLESS THE RESULT IS A TUPLE, where the bare spelling is the ONLY one:
    '' 'function = ( a \ b, a mod b )' out of a '(quotient as T, remainder as T)' is
    '' what fb/mathint.bi's DivMod is, and fbc-modern accepts it. It is still error 7
    '' over a plain UDT, which is what the rule above was measured on.
    if (c.ast->nodes[cast( long, e )].flags and Tko.NF_TYPE_LITERAL) = 0 then
        if IsTupleType_( c, c.resultType ) = false then return false
    end if
    return LowerUdtParenInit_( c, c.resultSlot, c.resultType, e )
end function

'' 'dim x as T = ANY' -- the explicit request for an UNINITIALISED variable, which
'' emits no store. 'any' is a keyword, so no variable can be spelled that way and
'' matching the name alone is safe.
private function IsAnyInit_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if id = Tko.NODE_NONE then return false
    if c.ast->Kind( id ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, id )].data )]
    return (Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) = "any")
end function

'' The single argument of a type literal that is a COPY of the target -- 'type<T>( y )'
'' where y is already a T -- or NODE_NONE. Parentheses on either side make no
'' difference and are looked through.
function TypeLitCopySource_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as Tko.NodeId

    if value = Tko.NODE_NONE then return Tko.NODE_NONE
    dim as Tko.NodeId v = Unparen_( c, value )
    if v = Tko.NODE_NONE then return Tko.NODE_NONE
    if c.ast->Kind( v ) <> Tko.N_TUPLE then return Tko.NODE_NONE
    if (c.ast->nodes[cast( long, v )].flags and Tko.NF_TYPE_LITERAL) = 0 then
        return Tko.NODE_NONE
    end if
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, v )].data )]
    if lp->count <> 1 then return Tko.NODE_NONE

    dim as Tko.TypeId tt = c.types->Unqualify( c.info->TypeOf_( target ) )
    if tt = Tko.TYPE_NONE then return Tko.NODE_NONE
    if c.types->Kind( tt ) <> Tko.TK_UDT then return Tko.NODE_NONE
    dim as Tko.NodeId arg = cast( Tko.NodeId, c.ast->children[lp->first] )
    if c.types->Unqualify( c.info->TypeOf_( arg ) ) <> tt then return Tko.NODE_NONE
    return arg
end function


'' An expression lowered as a CONDITION -- see Ctx.rawCmpNode.
function LowerCondition( byref c as Ctx, byval e as Tko.NodeId ) as MirValue
    dim as Tko.NodeId saved = c.rawCmpNode
    '' THROUGH THE PARENTHESES, which is how the condition is usually written:
    '' 'if (a < b) then' is the same branch as 'if a < b then', and taking the PAREN
    '' node as the raw one left the comparison inside it negated and then branched on.
    c.rawCmpNode = Unparen_( c, e )
    dim as MirValue r = LowerExpr( c, e )
    c.rawCmpNode = saved
    return r
end function

'' A BYREF RESULT IS AN ADDRESS. 'function = g' stores '&G$', and
'' 'function = *strptr( s )' stores the pointer the deref is of -- which is what makes
'' a 'byref as zstring' function work at all: it returns somebody else's data pointer
'' and owns nothing.
function LowerByrefResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean

    if c.resultSlot < 0 then return false
    dim as MirValue bav = LowerAddr( c, valueE )
    if bav.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue bra
    bra.kind = cast( ubyte, MV_LOCAL )
    bra.ty = cast( ubyte, MT_PTR )
    bra.id = c.resultSlot
    StoreThrough( c, bra, Coerce( c, bav, MT_PTR, false ) )
    return true
end function






'' Is this opcode a COMPARISON -- one that yields 0 or 1 rather than a number?
function IsCmpOp_( byval op as MirOp ) as boolean
    select case op
    case M_ICMP_EQ, M_ICMP_NE, M_ICMP_SLT, M_ICMP_SGT, M_ICMP_SLE, M_ICMP_SGE, _
         M_ICMP_ULT, M_ICMP_UGT, _
         M_FCMP_EQ, M_FCMP_NE, M_FCMP_LT, M_FCMP_GT, M_FCMP_LE, M_FCMP_GE
        return true
    end select
    return false
end function

'' 'return T( args )' OUT OF A UDT-RETURNING FUNCTION: the object is built where it
'' belongs rather than in a temporary that is then copied in -- one copy earlier than
'' fbc, which materialises a temporary and memcpys it. LowerCtorInit knows both
'' spellings, 'T( args )' and 'type<T>( args )', and takes a slot.
function LowerCtorReturn_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    if c.resultSlot < 0 then return false
    if LowerCtorInit( c, c.resultSlot, c.resultType, e ) = false then return false
    EmitCleanupsTo( c, 0 )
    dim as MirValue urc
    urc.kind = cast( ubyte, MV_LOCAL )
    urc.ty = cast( ubyte, MT_PTR )
    urc.id = c.resultSlot
    Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, urc, MT_AGG ) )
    '' A DEAD CURSOR, not a fresh block: this is a RETURN and nothing follows it in
    '' the same block. Opening an "after" block instead left one unreachable block --
    '' and one unreachable 'ret' the epilogue put in it -- per return in the corpus,
    '' 1,488 of them.
    c.curBlock = -1
    return true
end function

'' 'return ( 20, 22 )' -- A BARE TUPLE LITERAL HAS NO TYPE OF ITS OWN, so it is built
'' straight into the result slot from the FUNCTION'S result type. fbc builds a
'' temporary and copies it in; this is the same object one copy earlier, and without
'' it every tuple-returning function declined its return.
function LowerTupleReturn_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    if c.resultSlot < 0 then return false
    if (c.ast->Kind( e ) <> Tko.N_TUPLE) andalso (c.ast->Kind( e ) <> Tko.N_PAREN) then
        return false
    end if
    if c.info->TypeOf_( e ) <> Tko.TYPE_NONE then return false
    if LowerUdtParenInit_( c, c.resultSlot, c.resultType, e ) = false then return false
    EmitCleanupsTo( c, 0 )
    dim as MirValue ura0
    ura0.kind = cast( ubyte, MV_LOCAL )
    ura0.ty = cast( ubyte, MT_PTR )
    ura0.id = c.resultSlot
    Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, ura0, MT_AGG ) )
    c.curBlock = NewBlock( c, "after" )
    return true
end function

'' THE CHARACTER TYPE OF '*p' over a STRING POINTER, or MT_VOID when it is not one.
''
'' A 'zstring ptr' dereferences to one unsigned BYTE and a 'wstring ptr' to one
'' unsigned wide character -- measured, '(uint8)*PZ$0' and a load out of a uint16*.
'' Only the UNSIZED pointee: 'zstring * N' is an array and its deref is the array.
function DerefCharTy_( byref c as Ctx, byval id as Tko.NodeId ) as MirType
    dim as Tko.UnaryPayload ptr dp = _
        @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as Tko.TypeId pt = c.types->Unqualify( c.info->TypeOf_( dp->operand ) )
    if pt = Tko.TYPE_NONE then return MT_VOID
    if c.types->Kind( pt ) <> Tko.TK_POINTER then return MT_VOID
    dim as Tko.TypeId inner = c.types->Unqualify( c.types->Inner( pt ) )
    if inner = Tko.TYPE_NONE then return MT_VOID
    if c.types->Kind( inner ) <> Tko.TK_BUILTIN then return MT_VOID
    select case c.types->BuiltinOf( inner )
    case Tko.TY_ZSTRING : return MT_I8
    case Tko.TY_WSTRING
        if c.types->target.wcharBytes = 4 then return MT_I32
        return MT_I16
    end select
    return MT_VOID
end function

'' THE STATIC MEMBER a qualified DIM defines -- 'dim shared as integer T.counter'.
''
'' The declaration inside the type is the symbol; this statement is its DEFINITION, and
'' fbc emits the storage here: 'int64 _ZN1T8COUNTER$E;'. Collect deliberately declares
'' nothing for it, so lowering used to look the last component up in the enclosing
'' scope, find nothing and decline -- while the storage got made by whichever
'' expression first read it.
''
'' The owner may be a PATH -- 'NS.U.val' -- so it is walked a component at a time.
''
'' AND IT IS ASKED FIRST, before the unqualified lookup. Falling back to it was worse
'' than not having it: with a module-level 'x' beside the type, the LAST COMPONENT
'' alone found THAT one, and the definition of T.x quietly became a second initialiser
'' for the shared x. Measured -- fbc gives 'dim shared x as integer = 1' the value 1
'' and '_ZN1T2X$E' the value 2, and tiko-lang gave x the 2.
function StaticMemberSym_ _
    ( byref c as Ctx, byval stmt as Tko.NodeId, byval item as Tko.NodeId ) as Tko.SymbolId

    if (c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) = 0 then
        return Tko.SYMBOL_NONE
    end if
    dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
    if ip->ownerName = 0 then return Tko.SYMBOL_NONE

    dim as Tko.ScopeId sc = c.info->ScopeOf( stmt )
    dim as string path = c.names->Spelling( ip->ownerName )
    dim as long pos = 1
    dim as boolean first = true
    do
        dim as long dot = instr( pos, path, "." )
        dim as string part
        if dot = 0 then
            part = mid( path, pos )
        else
            part = mid( path, pos, dot - pos )
        end if
        if len( part ) = 0 then return Tko.SYMBOL_NONE
        dim as Tko.InternId pn = c.names->Fold( c.names->GetString( part ) )
        dim as Tko.SymbolId osid = Tko.SYMBOL_NONE
        if first then
            osid = c.syms->Lookup( sc, pn )
        else
            osid = c.syms->LookupLocal( sc, pn )
        end if
        first = false
        dim as Tko.Symbol ptr os = c.syms->SymbolAt( osid )
        if os = 0 then return Tko.SYMBOL_NONE
        if os->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
        sc = os->inner
        if dot = 0 then exit do
        pos = dot + 1
    loop

    return c.syms->LookupLocalTyped( sc, ip->name, false )
end function

sub LowerBlock( byref c as Ctx, byval id as Tko.NodeId )
    if id = Tko.NODE_NONE then return
    if c.ast->Kind( id ) <> Tko.N_BLOCK then
        LowerStmt( c, id )
        return
    end if
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to lp->count - 1
        LowerStmt( c, cast( Tko.NodeId, c.ast->children[lp->first + i] ) )
    next
end sub

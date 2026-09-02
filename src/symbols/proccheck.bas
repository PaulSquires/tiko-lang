'' proccheck.bas -- WHAT A PROCEDURE DEFINITION AND AN INDEX EXPRESSION MAY NOT SAY.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' namespace, after the helpers it calls and before Walk_.

'' CONST AND STATIC ON A DEFINITION MUST AGREE WITH THE DECLARATION -- fbc errors 218 and
'' 217, "CONST used here" / "STATIC used here". MEASURED, all six ways: a modifier the
'' declaration did not have is refused; one it did have may be repeated or left off.
'' The same shape as the byref-result agreement below, and read the same way: the symbol
'' the definition bound points at the declaration node.
private sub CheckModifierAgrees_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return
    dim as NodeId decl = cast( NodeId, s->payload )
    if (decl = NODE_NONE) orelse (decl = id) then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as StmtPayload ptr dp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    if ((sp->extra and PF_STATIC) <> 0) andalso ((dp->extra and PF_STATIC) = 0) then
        c.diags->Report( TKO0696, PointRange( c.ast->Loc( id ) ), "STATIC" )
    end if
    if ((sp->extra and PF_CONST) <> 0) andalso ((dp->extra and PF_CONST) = 0) then
        c.diags->Report( TKO0696, PointRange( c.ast->Loc( id ) ), "CONST" )
    end if
end sub

'' SOME OPERATORS ARE MEMBERS OR NOTHING -- fbc error 152, "Operator must be a member
'' function". MEASURED at module level: 'let', 'cast', '[]' and the compound assignments
'' are refused, while a binary '+' is the ordinary free operator and is accepted.
private sub CheckMemberOnlyOperator_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_OPERATOR then return
    if (c.ast->nodes[cast( long, id )].flags and NF_QUALIFIED) <> 0 then return
    if ProcOwner_( c, id ) <> TYPE_NONE then return
    dim as string nm = Text.LowerAscii( c.names->Spelling( sp->name ) )
    dim as boolean memberOnly = false
    select case nm
    '' NOT '->': a GLOBAL 'operator ->' is legal, and fb/comptr.bi, fb/sharedptr.bi and
    '' four of this suite's own MIR tests define one. Listing it refused all fourteen
    '' corpus files that include those headers.
    case "let", "cast", "[]", "+=", "-=", "*=", "/=", "\=", "^=", "&=", _
         "mod=", "shl=", "shr=", "and=", "or=", "xor=", "eqv=", "imp="
        memberOnly = true
    end select
    if memberOnly = false then return
    c.diags->Report( TKO0697, PointRange( c.ast->Loc( id ) ), nm )
end sub

'' '[ ]' IS POINTER INDEXING, and needs a pointer -- fbc error 28, "Expected pointer".
'' Measured: 'n[0]' over an integer and 'x[0]' over a UDT with no 'operator []' are
'' refused; 'p[0]' over a pointer and 's[0]' over a STRING are the ordinary uses. A UDT
'' that declares 'operator []' is left alone: that is the other ordinary use.
private sub CheckIndexNeedsPointer_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    if lp->count = 0 then return
    dim as TypeId t = c.info->TypeOf_( lp->target )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    select case c.types->Kind( u )
    case TK_POINTER, TK_ARRAY
        return
    case TK_UDT
        if StructorOf_( c, u, "[]" ) <> 0 then return
    case TK_BUILTIN
        select case c.types->BuiltinOf( u )
        case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
            return
        end select
    case else
        return
    end select
    c.diags->Report( TKO0700, PointRange( c.ast->Loc( id ) ) )
end sub


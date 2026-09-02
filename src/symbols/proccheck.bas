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


'' 'new zstring' AND 'new wstring' HAVE NOTHING TO ALLOCATE -- fbc error 28, "Expected
'' pointer" -- and so do their vector forms 'new zstring[10]'; a FIXED one, 'new zstring
'' * 10' or 'new string * 10', is error 201, "The NEW operator cannot be used with
'' fixed-length strings". 'new string' and 'new integer' are the ordinary uses.
private sub CheckNewString_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( lp->target )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_ARRAY then
        '' A fixed-length string is an array of a character builtin.
        dim as TypeId el = c.types->Unqualify( c.types->Inner( u ) )
        if c.types->Kind( el ) <> TK_BUILTIN then return
        select case c.types->BuiltinOf( el )
        case TY_ZSTRING, TY_WSTRING, TY_FIXSTR, TY_FIXUSTR
            c.diags->Report( TKO0706, PointRange( c.ast->Loc( id ) ) )
        end select
        return
    end if
    if c.types->Kind( u ) <> TK_BUILTIN then return
    select case c.types->BuiltinOf( u )
    case TY_ZSTRING, TY_WSTRING
        c.diags->Report( TKO0705, PointRange( c.ast->Loc( id ) ) )
    end select
end sub

'' 'not p' OVER A POINTER -- fbc error 20, "Type mismatch". A pointer is compared, not
'' negated: 'if p = 0' is the spelling. Measured against 'not n' over an integer, which is
'' the ordinary bitwise use.
private sub CheckNotPointer_ ( byref c as Ctx, byval id as NodeId )
    dim as UnaryPayload ptr up = _
        @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, up->op ) <> KW_NOT then return
    if up->operand = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( up->operand )
    if t = TYPE_NONE then return
    if c.types->Kind( c.types->Unqualify( t ) ) <> TK_POINTER then return
    c.diags->Report( TKO0707, PointRange( c.ast->Loc( id ) ) )
end sub

'' 'p += 1' OVER A PROCEDURE POINTER -- fbc error 20. The binary '+' was already refused
'' (TKO0646); the compound spelling reached lowering. 'ip += 1' over a data pointer is
'' the ordinary use.
private sub CheckProcPtrCompound_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    select case cast( TokenKind, sp->op )
    case TK_PLUSEQ, TK_MINUSEQ
    case else
        return
    end select
    if sp->a = NODE_NONE then return
    if IsProcPtr_( c, c.info->TypeOf_( sp->a ) ) = false then return
    c.diags->Report( TKO0646, PointRange( c.ast->Loc( id ) ) )
end sub

'' A GRAPHICS STATEMENT'S IMAGE TARGET IS A POINTER -- 'line img, (0,0)-(1,1), c' draws
'' into what 'img' points at. MEASURED: an 'any ptr' or 'ubyte ptr' target is accepted,
'' an integer, a string or any other non-pointer builtin is fbc error 28 ("Expected
'' pointer"), and a UDT is accepted only when it declares 'operator cast( ) as any ptr'
'' (otherwise error 99). PSET, PUT and CIRCLE measure the same as LINE.
''
'' The parser marks a written target with GFX_HASTARGET in 'extra' and keeps it in 'a';
'' the flag is read here under its own name because gfx.bas is not visible from this pass.
const VIS_GFX_HASTARGET as ushort = &h0200

private sub CheckGfxTarget_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    select case cast( TokenKind, sp->op )
    case KW_LINE, KW_PSET, KW_CIRCLE, KW_PAINT, KW_GET, KW_PUT, KW_DRAW
    case else
        return
    end select
    if (sp->extra and VIS_GFX_HASTARGET) = 0 then return
    if sp->a = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    select case c.types->Kind( u )
    case TK_POINTER
        return
    case TK_UDT
        '' A CONVERSION OPERATOR MAY SUPPLY THE POINTER, and which one is a question of
        '' overload choice this pass does not model -- any 'cast' at all is enough to
        '' decline.
        if StructorOf_( c, u, "cast" ) <> 0 then return
        c.diags->Report( TKO0709, PointRange( c.ast->Loc( sp->a ) ) )
    case TK_BUILTIN, TK_ARRAY
        c.diags->Report( TKO0708, PointRange( c.ast->Loc( sp->a ) ) )
    end select
end sub

'' A CASE VALUE MUST BE THE SUBJECT'S KIND -- fbc error 24, "Invalid data types". Measured:
'' 'select case s' over a string with 'case 0' is refused, and so is 'select case 0' with
'' 'case "a"' or 'case wstr( "a" )'; a fixed wstring subject measures the same as a
'' string. Only the string/number divide is asked -- an integer subject with a double
'' case is a conversion, not this.
private sub CaseValueKind_ _
    ( byref c as Ctx, byval v as NodeId, byval subjStr as boolean )
    if v = NODE_NONE then return
    dim as NodeKind vk = c.ast->Kind( v )
    if vk = N_CASE_RANGE then
        '' A STATEMENT NODE, not a binary: 'a TO b' and 'IS < a' keep their operands in
        '' the stmt payload's 'a' and 'b'. Reading it as a binary indexed the wrong pool
        '' and took the compiler down on every SELECT -- the ninth time this codebase
        '' has made the payload-pool mistake.
        dim as StmtPayload ptr rp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, v )].data )]
        CaseValueKind_( c, rp->a, subjStr )
        CaseValueKind_( c, rp->b, subjStr )
        return
    end if
    dim as TypeId t = c.info->TypeOf_( v )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) = TK_ARRAY then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) <> TK_BUILTIN then return
    dim as boolean vStr = IsStringyType_( c, u )
    if vStr = subjStr then return
    if vStr = false then
        select case c.types->BuiltinOf( u )
        case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG, _
             TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT, TY_SINGLE, TY_DOUBLE
        case else
            return
        end select
    end if
    c.diags->Report( TKO0714, PointRange( c.ast->Loc( v ) ) )
end sub

private sub CheckSelectCaseKinds_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    if c.ast->Kind( sp->b ) <> N_BLOCK then return
    dim as TypeId st = c.info->TypeOf_( sp->a )
    if st = TYPE_NONE then return
    dim as TypeId su = c.types->Unqualify( st )
    if c.types->Kind( su ) = TK_REFERENCE then su = c.types->Unqualify( c.types->Inner( su ) )
    if c.types->Kind( su ) = TK_ARRAY then su = c.types->Unqualify( c.types->Inner( su ) )
    if c.types->Kind( su ) <> TK_BUILTIN then return
    dim as boolean subjStr = IsStringyType_( c, su )
    if subjStr = false then
        select case c.types->BuiltinOf( su )
        case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG, _
             TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT, TY_SINGLE, TY_DOUBLE
        case else
            return
        end select
    end if
    dim as ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
    for i as long = 0 to lp->count - 1
        dim as NodeId cs = cast( NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( cs ) <> N_CASE then continue for
        dim as StmtPayload ptr csp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, cs )].data )]
        for j as long = 0 to csp->count - 1
            CaseValueKind_( c, cast( NodeId, c.ast->children[csp->first + j] ), subjStr )
        next
    next
end sub

'' 'with' TAKES A UDT VALUE -- fbc error 24 for 'with 0', 'with @x' (a POINTER, even to a
'' UDT) and 'with cptr( UDT ptr, 0 )'. A dereference, a field or a variable of UDT type
'' are the ordinary subjects.
private sub CheckWithSubject_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->a = NODE_NONE then return
    '' 'with this' IS THE COMMONEST WITH IN ANY METHOD, and tiko-lang types 'this' as a
    '' POINTER because that is what the ABI passes -- the same exemption the dot rule
    '' makes. Judging its type refused this suite's own const-method test.
    if IsThisBase_( c, sp->a ) then return
    dim as TypeId t = c.info->TypeOf_( sp->a )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    select case c.types->Kind( u )
    case TK_UDT
        return
    case TK_POINTER, TK_BUILTIN
        c.diags->Report( TKO0715, PointRange( c.ast->Loc( sp->a ) ) )
    end select
end sub

'' AN ARROW THROUGH A UDT VALUE -- fbc error 28, "Expected pointer", for '(*p)->i' and
'' '(**pp)->i' where the left side is the object itself. CheckDeref_ leaves a UDT alone
'' because a type may overload 'operator ->'; when it declares none, the arrow has
'' nothing to go through.
private function ArrowOperatorAnywhere_ ( byref c as Ctx ) as boolean
    dim as InternId nm = c.names->Fold( c.names->GetString( "->" ) )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_PROC ) then continue for
        if c.names->Fold( s->name ) = nm then return true
    next
    return false
end function

private sub CheckArrowOnValue_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, mp->op ) <> TK_ARROW then return
    if mp->lhs = NODE_NONE then return
    dim as TypeId t = c.info->TypeOf_( mp->lhs )
    if t = TYPE_NONE then return
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) <> TK_UDT then return
    if StructorOf_( c, u, "->" ) <> 0 then return
    '' A GLOBAL 'operator ->( byref x as UDT )' MAKES THE ARROW LEGAL TOO, and which one
    '' applies is overload choice this pass does not model -- so any procedure of that
    '' name anywhere is enough to decline. Four of this suite's MIR tests define one.
    if ArrowOperatorAnywhere_( c ) then return
    c.diags->Report( TKO0716, PointRange( c.ast->Loc( id ) ) )
end sub

'' 'base.f( )' TO AN ABSTRACT METHOD -- fbc error 307, "Non-virtual call to ABSTRACT
'' method". An explicit base call binds statically, and there is no body to bind to.
private sub CheckBaseCallAbstract_ ( byref c as Ctx, byval id as NodeId )
    dim as BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    if mp->lhs = NODE_NONE then return
    if c.ast->Kind( mp->lhs ) <> N_IDENT then return
    dim as InternId bn = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->lhs )].data )].name
    if c.names->Fold( bn ) <> c.names->Fold( c.baseName ) then return
    dim as Symbol ptr ps = c.syms->SymbolAt( c.info->RefOf( id ) )
    if ps = 0 then return
    if ps->kind <> cast( ubyte, SYM_PROC ) then return
    dim as NodeId decl = cast( NodeId, ps->payload )
    if (decl = NODE_NONE) orelse (c.ast->Kind( decl ) <> N_PROC) then return
    dim as StmtPayload ptr dp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    if (dp->extra and PF_ABSTRACT) = 0 then return
    c.diags->Report( TKO0717, PointRange( c.ast->Loc( id ) ), c.names->Spelling( ps->name ) )
end sub

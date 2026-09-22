'' latesweeps4.bas -- WHAT 'cast( string, x )' TAKES: the helpers CheckCastStringSize_ asks.
''
'' Split out of latesweeps3.bas at the 1500-line lint cap and included from it, just above
'' CheckCastStringSize_, in the same namespace and over the same Ctx.

'' THE SINGLE CHILD OF A PARENTHESIS, or the node itself.
private function Unparen3_ ( byref c as Ctx, byval id as NodeId ) as NodeId
    for guard as long = 0 to 15
        if id = NODE_NONE then return id
        if c.ast->Kind( id ) <> N_PAREN then return id
        dim as ListPayload ptr pp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if pp->count <> 1 then return id
        id = cast( NodeId, c.ast->children[pp->first] )
    next
    return id
end function

'' THE BUILTIN A STRING TERM IS MADE OF: a 'wstring * N' answers WSTRING, a reference its
'' referent. TY_NONE for anything that is not a builtin.
private function StrTermBt_ ( byref c as Ctx, byval id as NodeId ) as BuiltinType
    dim as TypeId t = c.info->TypeOf_( id )
    if t = TYPE_NONE then return TY_NONE
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Unqualify( c.types->Inner( t ) )
    dim as TypeId fe = Tko.Check.FixedStringElem( t, *c.types )
    if fe <> TYPE_NONE then t = fe
    if c.types->Kind( t ) <> TK_BUILTIN then return TY_NONE
    return c.types->BuiltinOf( t )
end function

'' DOES THIS STRING EXPRESSION HOLD A WIDE TERM -- or, with 'wide' false, a USTRING one? A
'' CONCATENATION holding one is typed STRING by Check whatever its terms are
'' (binresult.bas), so its terms are asked. A '+' is looked into only when it is a string
'' operation: '*pw + 0' is arithmetic and answers INTEGER.
private function ExprHasStrKind_ _
    ( byref c as Ctx, byval id as NodeId, byval wide as boolean ) as boolean
    id = Unparen3_( c, id )
    if id = NODE_NONE then return false
    dim as BuiltinType bt = StrTermBt_( c, id )
    if wide then
        if bt = TY_WSTRING then return true
    else
        if (bt = TY_USTRING) orelse (bt = TY_FIXUSTR) then return true
    end if
    if bt <> TY_STRING then return false
    if c.ast->Kind( id ) <> N_BINARY then return false
    dim as BinaryPayload ptr bp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind op = cast( TokenKind, bp->op )
    if (op <> TK_AMP) andalso (op <> TK_PLUS) then return false
    if ExprHasStrKind_( c, bp->lhs, wide ) then return true
    return ExprHasStrKind_( c, bp->rhs, wide )
end function

private function ExprIsWide_ ( byref c as Ctx, byval id as NodeId ) as boolean
    return ExprHasStrKind_( c, id, true )
end function

declare function ExprIsConstStr_ ( byref c as Ctx, byval id as NodeId ) as boolean

'' IS THIS A NUMERIC CONSTANT, as fbc's folder sees one? A literal, a named constant that is
'' not a string, 'true', and unary and binary arithmetic over them -- and 'asc' or 'len' of
'' a constant string, which fbc folds to a number: 'asc( "a" ) & ""' is a folded literal.
private function ExprIsConstNum_ ( byref c as Ctx, byval id as NodeId ) as boolean
    id = Unparen3_( c, id )
    if id = NODE_NONE then return false
    select case c.ast->Kind( id )
    case N_INT_LIT, N_FLOAT_LIT
        return true
    case N_UNARY
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as TokenKind uop = cast( TokenKind, up->op )
        if (uop <> TK_MINUS) andalso (uop <> TK_PLUS) andalso (uop <> KW_NOT) then return false
        return ExprIsConstNum_( c, up->operand )
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        if cast( TokenKind, bp->op ) = TK_AMP then return false
        if ExprIsConstNum_( c, bp->lhs ) = false then return false
        return ExprIsConstNum_( c, bp->rhs )
    case N_IDENT
        dim as Symbol ptr sy = c.syms->SymbolAt( c.info->RefOf( id ) )
        if sy = 0 then return false
        if sy->kind <> cast( ubyte, SYM_CONSTANT ) then return false
        select case StrTermBt_( c, id )
        case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_NONE
            return false
        end select
        return true
    case N_CALL
        dim as ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if cp->target = NODE_NONE then return false
        if c.ast->Kind( cp->target ) <> N_IDENT then return false
        if c.info->RefOf( cp->target ) <> SYMBOL_NONE then return false
        if cp->count <> 1 then return false
        select case lcase( c.names->Spelling( _
            c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )].name ) )
        case "asc", "len"
            return ExprIsConstStr_( c, cast( NodeId, c.ast->children[cp->first] ) )
        end select
    end select
    return false
end function

'' IS THIS A CONSTANT STRING, as fbc's folder sees one -- which it turns into a LITERAL, a
'' ZSTRING and not a STRING? Measured one shape at a time, each 'cast( string, ... )':
''
''     "lit", !"a\n", $"raw", "a" "b", ( "a" )     error 20   a literal
''     KS, __FUNCTION__, __FILE__                  error 20   a named constant
''     "a" & "b", "a" & KS, "a" & 5, 5 & ""        error 20   '&' of two constants
''     "a" + "b", chr( 65 ) + "x"                  error 20   '+' of two constant strings
''     chr( 65 ), chr( 64 + 1 ), str( 5 ), str( 1.5 ), str( true )       error 20
''     iif( true, "a", "b" )                       error 20
''     "a" & i, KS & s, chr( i ), str( i ), iif( b, "a", "b" )           accepted
''     ucase( "lit" ), left( "abc", 1 ), hex( 255 ), bin( 5 ), string( 3, 65 )  accepted
''
'' -- so 'chr', 'str' and 'iif' fold over constants and the rest of the family does not.
function ExprIsConstStr_ ( byref c as Ctx, byval id as NodeId ) as boolean
    id = Unparen3_( c, id )
    if id = NODE_NONE then return false
    select case c.ast->Kind( id )
    case N_STRING_LIT, N_STRCAT
        return true
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as TokenKind op = cast( TokenKind, bp->op )
        if op = TK_AMP then
            dim as boolean lk = ExprIsConstStr_( c, bp->lhs ) orelse ExprIsConstNum_( c, bp->lhs )
            if lk = false then return false
            return ExprIsConstStr_( c, bp->rhs ) orelse ExprIsConstNum_( c, bp->rhs )
        end if
        if op <> TK_PLUS then return false
        if ExprIsConstStr_( c, bp->lhs ) = false then return false
        return ExprIsConstStr_( c, bp->rhs )
    case N_IDENT
        dim as Symbol ptr sy = c.syms->SymbolAt( c.info->RefOf( id ) )
        if sy = 0 then return false
        if (sy->flags and SYMF_FUNCNAME) <> 0 then return true
        if sy->kind <> cast( ubyte, SYM_CONSTANT ) then return false
        select case StrTermBt_( c, id )
        case TY_STRING, TY_ZSTRING
            return true
        end select
    case N_CALL
        dim as ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if cp->target = NODE_NONE then return false
        if c.ast->Kind( cp->target ) <> N_IDENT then return false
        if c.info->RefOf( cp->target ) <> SYMBOL_NONE then return false
        if cp->count < 1 then return false
        select case lcase( c.names->Spelling( _
            c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )].name ) )
        case "chr"
            for i as long = 0 to cp->count - 1
                if ExprIsConstNum_( c, cast( NodeId, c.ast->children[cp->first + i] ) ) = false then return false
            next
            return true
        case "str"
            if cp->count <> 1 then return false
            return ExprIsConstNum_( c, cast( NodeId, c.ast->children[cp->first] ) )
        case "iif"
            if cp->count <> 3 then return false
            if ExprIsConstNum_( c, cast( NodeId, c.ast->children[cp->first] ) ) = false then return false
            if ExprIsConstStr_( c, cast( NodeId, c.ast->children[cp->first + 1] ) ) = false then return false
            return ExprIsConstStr_( c, cast( NodeId, c.ast->children[cp->first + 2] ) )
        end select
    end select
    return false
end function

'' DOES THIS UDT HAVE AN 'operator cast' TO A NARROW STRING? That is the one UDT fbc takes
'' in 'cast( string, x )' -- measured: a cast to STRING is accepted, one returning a
'' 'wstring ptr' and a type with no cast are error 20. A type this cannot see into -- one
'' with a BASE, whose cast may be inherited -- answers yes, so nothing valid is refused.
private function UdtHasNarrowStrCast_ ( byref c as Ctx, byval t as TypeId ) as boolean
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> TK_UDT then return false
    if c.types->BaseOf( u ) <> TYPE_NONE then return true
    dim as InternId tn = c.types->NameOf( u )
    if tn = 0 then return true
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( u ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Symbol ptr sy = c.syms->SymbolAt( ts )
    if sy = 0 then return true
    if sy->inner = SCOPE_NONE then return true
    dim as SymbolId cs = c.syms->LookupLocal( sy->inner, c.names->Fold( c.names->GetString( "cast" ) ) )
    while cs <> SYMBOL_NONE
        dim as Symbol ptr cse = c.syms->SymbolAt( cs )
        if cse = 0 then exit while
        if cse->type_ <> TYPE_NONE then
            dim as TypeId ru = c.types->Unqualify( cse->type_ )
            if c.types->Kind( ru ) = TK_REFERENCE then ru = c.types->Unqualify( c.types->Inner( ru ) )
            if c.types->Kind( ru ) = TK_BUILTIN then
                select case c.types->BuiltinOf( ru )
                case TY_STRING, TY_ZSTRING
                    return true
                end select
            end if
        end if
        cs = cse->nextOverload
    wend
    return false
end function

'' IS THIS A POINTER-SIZED INTEGER -- the one non-pointer type a cast may pair with a
'' pointer? Measured on win64: 'cptr( any ptr, ii )' over an INTEGER and 'cptr( integer,
'' pa )' are both accepted, while LONG, SHORT, BYTE, SINGLE, DOUBLE and BOOLEAN on either
'' side are fbc's error 28. tiko-lang targets 64-bit only, so the four 8-byte integers and
'' an ENUM, which folds to one, are the whole list.
private function IsPtrSizedInt_ ( byref c as Ctx, byval t as TypeId ) as boolean
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) = TK_ENUM then return true
    if c.types->Kind( u ) <> TK_BUILTIN then return false
    select case c.types->BuiltinOf( u )
    case TY_INTEGER, TY_UINTEGER, TY_LONGINT, TY_ULONGINT
        return true
    end select
    return false
end function

'' A SHORT PHRASE FOR THE SIDE THAT IS WRONG, for TKO0804 and TKO0805.
private function DescribeNonPtr_ ( byref c as Ctx, byval t as TypeId ) as string
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if Tko.Check.FixedStringElem( u, *c.types ) <> TYPE_NONE then return "a fixed-length string"
    if c.types->Kind( u ) = TK_UDT then return "a user-defined type"
    if c.types->Kind( u ) <> TK_BUILTIN then return "not one"
    select case c.types->BuiltinOf( u )
    case TY_BYTE, TY_UBYTE, TY_SHORT, TY_USHORT, TY_LONG, TY_ULONG
        return "a narrower integer"
    case TY_SINGLE, TY_DOUBLE
        return "a floating-point value"
    case TY_BOOLEAN
        return "a boolean"
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING
        return "a string"
    end select
    return "not one"
end function

'' MIGHT THIS UDT CONVERT ITSELF? True when it declares an 'operator cast' or a
'' constructor, when it has a BASE whose members this does not walk, or when its own scope
'' cannot be found. A UDT that converts is not this rule's business: vendor
'' overload/op_to_ptr.bas casts one to an 'integer ptr' through 'operator cast( ) as
'' integer ptr', which fbc compiles, and reading it as a plain UDT refused the file.
private function UdtMayConvert_ ( byref c as Ctx, byval t as TypeId ) as boolean
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> TK_UDT then return false
    if c.types->BaseOf( u ) <> TYPE_NONE then return true
    dim as InternId tn = c.types->NameOf( u )
    if tn = 0 then return true
    dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( u ) )
    dim as SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Symbol ptr sy = c.syms->SymbolAt( ts )
    if sy = 0 then return true
    if sy->inner = SCOPE_NONE then return true
    if c.syms->LookupLocal( sy->inner, c.names->Fold( c.names->GetString( "cast" ) ) ) <> SYMBOL_NONE then return true
    return (c.syms->LookupLocal( sy->inner, c.names->Fold( c.names->GetString( "__ctor" ) ) ) <> SYMBOL_NONE)
end function

'' A CAST BETWEEN A POINTER AND SOMETHING THAT IS NOT ONE -- fbc's error 28, and it reads
'' the PAIR rather than either side alone. Measured, 'cast' and 'cptr' alike:
''
''     cptr( any ptr, ii ), cptr( integer, pa ), cptr( long ptr, li ), cptr( any ptr, 0 ),
''     cptr( any ptr, @i ), cptr( any ptr, strptr( s ) ), cptr( integer, pp )   accepted
''     cptr( any ptr, i ) over a LONG, and sh, d, b, s, z, w, u, ud, 1.5, true  error 28
''     cptr( long, pa ), cptr( double, pa ), cptr( boolean, pa ), cptr( UD, pa ),
''     cptr( zstring * 4, pa ), cast( long, pa ), cast( any ptr, i )            error 28
''
'' -- and a pair with NO pointer in it is an ordinary conversion: 'cptr( long, i )' and
'' 'cptr( double, d )' are accepted. TRUE when it reported.
function CheckCastPtrPair_ _
    ( byref c as Ctx, byval id as NodeId, byref cn as string, _
      byval tgt as TypeId, byval op as NodeId ) as boolean

    dim as TypeId ot = c.info->TypeOf_( op )
    if ot = TYPE_NONE then return false
    ot = c.types->Unqualify( ot )
    if c.types->Kind( ot ) = TK_REFERENCE then ot = c.types->Unqualify( c.types->Inner( ot ) )
    '' 'this' IS A POINTER IN THE SYMBOL TABLE AND THE OBJECT IN THE SOURCE, which is what
    '' the BASE SLICE 'cast( BaseT, this ) = u' casts -- fbc takes it, and takes
    '' 'cast( Base, *p )' over a derived object, while 'cast( Base, p )' over the POINTER
    '' is its error 20. Read as a pointer here, the slice became a pointer-to-UDT cast and
    '' was refused: tests/mir/base-slice-assign is exactly that line.
    if c.ast->Kind( op ) = N_IDENT then
        dim as InternId tnm = c.names->Fold( c.names->GetString( "this" ) )
        if c.ast->idents[cast( long, c.ast->nodes[cast( long, op )].data )].name = tnm then
            if c.types->Kind( ot ) = TK_POINTER then ot = c.types->Unqualify( c.types->Inner( ot ) )
        end if
    end if
    dim as boolean tgtPtr = (c.types->Kind( tgt ) = TK_POINTER)
    dim as boolean opPtr = (c.types->Kind( ot ) = TK_POINTER)
    if tgtPtr andalso opPtr then return false
    '' A UDT THAT CONVERTS ITSELF is neither side's business -- see UdtMayConvert_.
    if UdtMayConvert_( c, ot ) then return false
    if UdtMayConvert_( c, tgt ) then return false
    if tgtPtr then
        if IsPtrSizedInt_( c, ot ) then return false
        c.diags->Report( TKO0804, PointRange( c.ast->Loc( id ) ), cn, DescribeNonPtr_( c, ot ) )
        return true
    end if
    if opPtr = false then return false
    if IsPtrSizedInt_( c, tgt ) then return false
    c.diags->Report( TKO0805, PointRange( c.ast->Loc( id ) ), cn, DescribeNonPtr_( c, tgt ) )
    return true
end function

'' WHY 'cast( string, x )' REFUSES x, or "" when it takes it. fbc takes a var-len STRING
'' that is not a constant, and a UDT casting to one -- see the table above ExprIsConstStr_
'' and CheckCastStringSize_ -- and nothing else. An operand with no type is taken, so a
'' shape Check does not model is never refused.
private function CastStrOperandWhy_ ( byref c as Ctx, byval op as NodeId ) as string
    if ExprIsConstStr_( c, op ) then return "a constant, which fbc folds to a literal"
    dim as TypeId t = c.info->TypeOf_( op )
    if t = TYPE_NONE then return ""
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Unqualify( c.types->Inner( t ) )
    if c.types->Kind( t ) = TK_UDT then
        if UdtHasNarrowStrCast_( c, t ) then return ""
        return "a type with no 'operator cast' to STRING"
    end if
    if Tko.Check.FixedStringElem( t, *c.types ) <> TYPE_NONE then return "a fixed-length string"
    if c.types->Kind( t ) <> TK_BUILTIN then return "not a string"
    select case c.types->BuiltinOf( t )
    case TY_STRING
        if ExprHasStrKind_( c, op, false ) then return "a USTRING concatenation"
        return ""
    case TY_ZSTRING
        return "a zstring"
    case TY_USTRING, TY_FIXUSTR
        return "a ustring"
    end select
    return "not a string"
end function

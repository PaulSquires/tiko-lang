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

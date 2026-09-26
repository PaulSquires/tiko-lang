'' ptrwarn.bas -- fbc's WARNING 4, "Suspicious pointer assignment".
''
'' Included from assigncheck.bas, which is included from visibility.bas, inside its
'' namespace, after BaseOf_ and DerivesFrom_.
''
'' fbc warns where the pointer check it makes of an assignment (astPtrCheck, ast-misc.bas)
'' fails and the conversion would still succeed -- a failing UDT downcast is error 181
'' instead (TKO0686). Read from fbc's source to learn the rule, and then measured on
'' fbc-modern 1.20, 2026-09-25, one shape at a time:
''
''   WARNED                                      NOT WARNED
''   long ptr = double ptr, = @double            long ptr = any ptr, any ptr = double ptr
''   long ptr = 5, = an integer variable         long ptr = 0
''   long ptr ptr = long ptr, and back           byte ptr = ubyte ptr, zstring ptr = ubyte ptr
''   single ptr = long ptr                       long ptr = ulong ptr, short ptr = ushort ptr
''   double ptr = longint ptr                    longint ptr = integer ptr (same size)
''   integer ptr = long ptr (a different size)   wstring ptr = ushort ptr (on Windows)
''   an enum pointee against long, both ways     boolean ptr = byte ptr
''   string ptr = zstring ptr                    base ptr = derived ptr, and derived = base
''   udt ptr = long ptr, unrelated udt ptrs      adding or dropping a pointee's const
''   a procedure pointer of another signature:   cdecl = stdcall of one signature
''     a parameter's type or byref-ness, the     a parameter ulong against long
''     result's size, sub against function,      a procedure pointer = any ptr, and back
''     the arity, pascal against the rest
''   'return @d' and 'function = @d' from a function 'as long ptr'
''
'' So: 'any' is compatible unless it has MORE levels of pointer than the other side; below
'' equal levels, two integers of one size match whatever their sign -- zstring, wstring
'' and boolean count as the integer of their size -- two UDTs match along the hierarchy,
'' and two procedure types match when their parameters and result do. Anything else,
'' an enum included, does not. tiko warned about none of it.

'' The size of a builtin that compares as an INTEGER here, or 0.
private function PwIntSize_ ( byref c as Ctx, byval t as TypeId ) as long
    if c.types->Kind( t ) <> TK_BUILTIN then return 0
    select case c.types->BuiltinOf( t )
    case TY_BYTE, TY_UBYTE, TY_ZSTRING, TY_BOOLEAN : return 1
    case TY_SHORT, TY_USHORT : return 2
    case TY_LONG, TY_ULONG : return 4
    case TY_LONGINT, TY_ULONGINT : return 8
    case TY_INTEGER, TY_UINTEGER : return c.types->target.pointerBits \ 8
    case TY_WSTRING : return c.types->target.wcharBytes
    end select
    return 0
end function

declare function PwMatch_ ( byref c as Ctx, byval a as TypeId, byval b as TypeId, byval depth as long ) as boolean

'' A FIXED-LENGTH STRING IS ITS CHARACTER: '@z' over a 'zstring * 8' is a 'zstring ptr' to
'' fbc, and tiko spells the type as an array of the character.
private function PwNorm_ ( byref c as Ctx, byval t as TypeId ) as TypeId
    dim as TypeId u = c.types->Unqualify( t )
    dim as TypeId el = u
    if c.types->Kind( u ) = TK_ARRAY then el = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( el ) = TK_BUILTIN then
        select case c.types->BuiltinOf( el )
        case TY_FIXSTR : return c.types->Builtin( TY_ZSTRING )
        case TY_ZSTRING, TY_WSTRING : if el <> u then return el
        end select
    end if
    return u
end function

'' Two RESULTS: a byref result is compared by its referent -- tiko's '@f' does not carry a
'' byref result the way a written 'function( ) byref as long' does.
private function PwResult_ ( byref c as Ctx, byval t as TypeId ) as TypeId
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then return c.types->Inner( u )
    return u
end function

private function PwProcMatch_ ( byref c as Ctx, byval a as TypeId, byval b as TypeId, byval depth as long ) as boolean
    if c.types->IsPascal( a ) <> c.types->IsPascal( b ) then return false
    if c.types->IsVariadic( a ) <> c.types->IsVariadic( b ) then return false
    dim as long n = c.types->ProcParamCount( a )
    if n <> c.types->ProcParamCount( b ) then return false
    if PwMatch_( c, PwResult_( c, c.types->Inner( a ) ), PwResult_( c, c.types->Inner( b ) ), depth + 1 ) = false then return false
    for i as long = 0 to n - 1
        if PwMatch_( c, c.types->ProcParam( a, i ), c.types->ProcParam( b, i ), depth + 1 ) = false then return false
    next
    return true
end function

'' Do two types match, as fbc's typeCalcMatch sees them for a pointer assignment?
function PwMatch_ ( byref c as Ctx, byval a as TypeId, byval b as TypeId, byval depth as long ) as boolean
    if depth > 32 then return true
    a = PwNorm_( c, a ) : b = PwNorm_( c, b )
    if a = b then return true
    '' A TYPE tiko could not work out is not evidence of anything -- 'typeof( x ) ptr' over
    '' a name it did not resolve.
    if (a = TYPE_NONE) orelse (b = TYPE_NONE) then return true
    dim as TypeKind ka = c.types->Kind( a ), kb = c.types->Kind( b )
    if (ka = TK_ERROR) orelse (kb = TK_ERROR) orelse (ka = TK_FORWARD) orelse (kb = TK_FORWARD) then return true
    '' A byref parameter against a byval one is two signatures; two byref ones compare
    '' their referents.
    if (ka = TK_REFERENCE) orelse (kb = TK_REFERENCE) then
        if ka <> kb then return false
        return PwMatch_( c, c.types->Inner( a ), c.types->Inner( b ), depth + 1 )
    end if
    if (ka = TK_POINTER) andalso (kb = TK_POINTER) then
        return PwMatch_( c, c.types->Inner( a ), c.types->Inner( b ), depth + 1 )
    end if
    if (ka = TK_POINTER) orelse (kb = TK_POINTER) then return false
    if (ka = TK_BUILTIN) andalso (kb = TK_BUILTIN) then
        dim as long sa = PwIntSize_( c, a )
        return (sa > 0) andalso (sa = PwIntSize_( c, b ))
    end if
    if (ka = TK_UDT) andalso (kb = TK_UDT) then
        return DerivesFrom_( c, a, b ) orelse DerivesFrom_( c, b, a )
    end if
    '' A BYDESC ARRAY PARAMETER: its element and its written rank. 'array( )' and
    '' 'array( any )' are two (warnings/ptr-bydescdimensions.bas).
    if (ka = TK_ARRAY) andalso (kb = TK_ARRAY) then
        if c.types->IsDynArray( a ) <> c.types->IsDynArray( b ) then return false
        if c.types->DynRank( a ) <> c.types->DynRank( b ) then return false
        return PwMatch_( c, c.types->Inner( a ), c.types->Inner( b ), depth + 1 )
    end if
    if (ka = TK_PROC) andalso (kb = TK_PROC) then return PwProcMatch_( c, a, b, depth )
    return false
end function

'' Is 'n' the constant zero? A literal, in parentheses or signed, or a constant naming one.
private function PwZero_ ( byref c as Ctx, byval n as NodeId, byval depth as long ) as boolean
    if (n = NODE_NONE) orelse (depth > 16) then return false
    select case c.ast->Kind( n )
    case N_INT_LIT
        return (c.ast->literals[cast( long, c.ast->nodes[cast( long, n )].data )].intValue = 0)
    case N_PAREN
        dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if pp->count <> 1 then return false
        return PwZero_( c, cast( NodeId, c.ast->children[pp->first] ), depth + 1 )
    case N_UNARY
        dim as UnaryPayload ptr up = @c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        dim as TokenKind uop = cast( TokenKind, up->op )
        if (uop <> TK_MINUS) andalso (uop <> TK_PLUS) then return false
        return PwZero_( c, up->operand, depth + 1 )
    case N_IDENT
        dim as Symbol ptr sy = c.syms->SymbolAt( c.info->RefOf( n ) )
        if sy = 0 then return false
        if sy->kind <> cast( ubyte, SYM_CONSTANT ) then return false
        dim as NodeId item = cast( NodeId, sy->payload )
        if item = NODE_NONE then return false
        if c.ast->Kind( item ) <> N_VAR_ITEM then return false
        return PwZero_( c, c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )].b, depth + 1 )
    case N_CALL
        '' A CONVERSION OF ZERO folds to zero: 'p = cbyte( 0 )', 'p = cast( long, 0 )' --
        '' numbers/cast-nullptr.bas writes every one and fbc warns about none.
        dim as ListPayload ptr cp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if cp->target = NODE_NONE then return false
        if c.ast->Kind( cp->target ) <> N_IDENT then return false
        if c.info->RefOf( cp->target ) <> SYMBOL_NONE then return false
        dim as string fn = lcase( c.names->Spelling( c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )].name ) )
        select case fn
        case "cbyte", "cubyte", "cshort", "cushort", "clng", "culng", "cint", "cuint", _
             "clngint", "culngint", "cbool"
            if cp->count <> 1 then return false
            return PwZero_( c, cast( NodeId, c.ast->children[cp->first] ), depth + 1 )
        case "cast"
            if cp->count <> 2 then return false
            return PwZero_( c, cast( NodeId, c.ast->children[cp->first + 1] ), depth + 1 )
        end select
    end select
    return false
end function

'' '@f' OF AN OVERLOADED PROCEDURE takes the overload the TARGET's type names -- fbc picks
'' it (overload/addressof.bas, pointers/funptr_fwdbyref.bas) -- and the type tiko gave
'' the '@' is only one of them, so it is not judged.
private function PwOverloadedAddr_ ( byref c as Ctx, byval n as NodeId ) as boolean
    for guard as long = 0 to 15
        if n = NODE_NONE then return false
        if c.ast->Kind( n ) <> N_PAREN then exit for
        dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if pp->count <> 1 then return false
        n = cast( NodeId, c.ast->children[pp->first] )
    next
    if n = NODE_NONE then return false
    dim as NodeId o = NODE_NONE
    if c.ast->Kind( n ) = N_ADDROF then
        o = c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )].operand
    elseif c.ast->Kind( n ) = N_CALL then
        '' 'procptr( f )' is the same question as '@f'.
        dim as ListPayload ptr cp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if (cp->target = NODE_NONE) orelse (cp->count <> 1) then return false
        if c.ast->Kind( cp->target ) <> N_IDENT then return false
        if lcase( c.names->Spelling( c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )].name ) ) <> "procptr" then return false
        o = cast( NodeId, c.ast->children[cp->first] )
    end if
    if o = NODE_NONE then return false
    dim as SymbolId sid = c.info->RefOf( o )
    dim as Symbol ptr sy = c.syms->SymbolAt( sid )
    if sy = 0 then return false
    if sy->kind <> cast( ubyte, SYM_PROC ) then return false
    if sy->nextOverload <> SYMBOL_NONE then return true
    '' A RUNTIME PROCEDURE tiko declares in its prelude carries tiko's approximation of
    '' fbc's prototype -- 'getmouse' over long where fbc's are integer -- and judging the
    '' user's pointer against it would be judging the prelude (warnings/rtl-prototypes.bas).
    if c.diags->sources <> 0 then
        if c.diags->sources->IsBuiltin( sy->loc ) then return true
    end if
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s = sy then continue for
        if s->kind <> cast( ubyte, SYM_PROC ) then continue for
        if (s->name = sy->name) andalso (s->parent = sy->parent) then return true
    next
    return false
end function

'' '@' of a string literal, a concatenation of them, or a constant naming one.
private function PwLitAddr_ ( byref c as Ctx, byval n as NodeId ) as boolean
    for guard as long = 0 to 15
        if n = NODE_NONE then return false
        if c.ast->Kind( n ) <> N_PAREN then exit for
        dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if pp->count <> 1 then return false
        n = cast( NodeId, c.ast->children[pp->first] )
    next
    if n = NODE_NONE then return false
    if c.ast->Kind( n ) <> N_ADDROF then return false
    dim as NodeId o = c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )].operand
    if o = NODE_NONE then return false
    select case c.ast->Kind( o )
    case N_STRING_LIT, N_STRCAT
        return true
    case N_IDENT, N_MEMBER
        '' 'NS.K', a constant qualified by its namespace, is the same thing.
        dim as Symbol ptr sy = c.syms->SymbolAt( c.info->RefOf( o ) )
        if sy = 0 then return false
        return (sy->kind = cast( ubyte, SYM_CONSTANT ))
    end select
    return false
end function

'' A TYPE WITH AN UNRESOLVED PART -- a generic TEMPLATE's body, where T has no type yet
'' and a lambda's is only approximate (fb/sort.bi) -- is not judged.
private function PwHasNone_ ( byref c as Ctx, byval t as TypeId, byval depth as long ) as boolean
    if depth > 32 then return false
    t = c.types->Unqualify( t )
    if t = TYPE_NONE then return true
    select case c.types->Kind( t )
    case TK_POINTER, TK_REFERENCE, TK_ARRAY
        return PwHasNone_( c, c.types->Inner( t ), depth + 1 )
    case TK_PROC
        if c.types->Inner( t ) = TYPE_NONE then return false  '' a SUB
        if PwHasNone_( c, c.types->Inner( t ), depth + 1 ) then return true
        for i as long = 0 to c.types->ProcParamCount( t ) - 1
            if PwHasNone_( c, c.types->ProcParam( t, i ), depth + 1 ) then return true
        next
    end select
    return false
end function

'' '@' OF AN INDEX OR A CALL whose type claims to point at a PROCEDURE: 'lp = @c.ast->lists[ i ]'
'' through an overloaded 'operator []' is typed with the operator's own procedure type by
'' Check, where the value is the element's address. fbc-modern compiles tiko-lang with no
'' warning 4, and this was 898 of them. Not judged.
private function PwAddrOfCall_ ( byref c as Ctx, byval n as NodeId ) as boolean
    for guard as long = 0 to 15
        if n = NODE_NONE then return false
        if c.ast->Kind( n ) <> N_PAREN then exit for
        dim as ListPayload ptr pp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if pp->count <> 1 then return false
        n = cast( NodeId, c.ast->children[pp->first] )
    next
    if n = NODE_NONE then return false
    if c.ast->Kind( n ) <> N_ADDROF then return false
    dim as NodeId o = c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )].operand
    if o = NODE_NONE then return false
    return (c.ast->Kind( o ) = N_INDEX) orelse (c.ast->Kind( o ) = N_CALL)
end function

'' Would fbc warn 4 for 'lt = rt', the value being 'rn'?
private function PtrSuspicious_ _
    ( byref c as Ctx, byval lt as TypeId, byval rt as TypeId, byval rn as NodeId ) as boolean

    dim as TypeId lu = c.types->Unqualify( lt ), ru = c.types->Unqualify( rt )
    if c.types->Kind( lu ) <> TK_POINTER then return false
    if PwHasNone_( c, lu, 0 ) orelse PwHasNone_( c, ru, 0 ) then return false
    if c.types->Kind( ru ) <> TK_POINTER then
        '' An INTEGER becomes a pointer with a warning -- a zero constant without one. A
        '' float is error 181 elsewhere, and anything else no conversion at all.
        dim as boolean isInt = (PwIntSize_( c, ru ) > 0) orelse (c.types->Kind( ru ) = TK_ENUM)
        if isInt = false then return false
        return (PwZero_( c, rn, 0 ) = false)
    end if
    '' '@"lit"' AND '@' OF A STRING CONSTANT are a 'zstring ptr' to fbc -- a literal is a
    '' zstring -- where tiko types them 'string ptr'.
    if PwLitAddr_( c, rn ) then ru = c.types->Pointer_( c.types->Builtin( TY_ZSTRING ) )
    if c.types->Kind( c.types->Unqualify( c.types->Inner( ru ) ) ) = TK_PROC then
        if PwAddrOfCall_( c, rn ) then return false
    end if
    '' 'any' at the bottom of either side: compatible unless it has MORE levels.
    dim as long ln = 0, rnn = 0
    dim as TypeId lb = lu, rb = ru
    while (c.types->Kind( lb ) = TK_POINTER) andalso (ln < 32)
        lb = c.types->Unqualify( c.types->Inner( lb ) ) : ln += 1
    wend
    while (c.types->Kind( rb ) = TK_POINTER) andalso (rnn < 32)
        rb = c.types->Unqualify( c.types->Inner( rb ) ) : rnn += 1
    wend
    dim as boolean lAny = (c.types->Kind( lb ) = TK_BUILTIN) andalso (c.types->BuiltinOf( lb ) = TY_ANY)
    dim as boolean rAny = (c.types->Kind( rb ) = TK_BUILTIN) andalso (c.types->BuiltinOf( rb ) = TY_ANY)
    if lAny then
        if rAny then return false
        return (ln > rnn)
    end if
    if rAny then return (ln < rnn)
    return (PwMatch_( c, lu, ru, 0 ) = false)
end function

private sub PtrWarn_ _
    ( byref c as Ctx, byval at_ as NodeId, byval lt as TypeId, byval rt as TypeId, byval rn as NodeId )
    if (lt = TYPE_NONE) orelse (rt = TYPE_NONE) then return
    if PtrSuspicious_( c, lt, rt, rn ) = false then return
    if PwOverloadedAddr_( c, rn ) then return
    c.diags->Report( TKO0830, PointRange( c.ast->Loc( at_ ) ), c.types->Name( lt ), c.types->Name( rt ) )
end sub

'' 'return expr' in a function declared 'as T ptr'. A byref result returns an address and
'' is not this question.
private sub CheckPtrReturn_ ( byref c as Ctx, byval id as NodeId, byval resultType as TypeId )
    if resultType = TYPE_NONE then return
    if c.types->Kind( resultType ) = TK_REFERENCE then return
    dim as NodeId e = c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )].a
    if e = NODE_NONE then return
    if TupleConvBad_( c, resultType, e, 0 ) then return  '' tupleconv.bas
    PtrWarn_( c, id, resultType, c.info->TypeOf_( e ), e )
end sub

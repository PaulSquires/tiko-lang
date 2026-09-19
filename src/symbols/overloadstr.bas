'' overloadstr.bas -- A CONSTANT STRING ARGUMENT, COSTED AS THE LITERAL IT IS.
''
'' Included from overload.bas, just above ResolveCall_, for the 1500-line lint cap: the
'' width of a constant string argument, which string parameters that width is asked of,
'' and what a CONST string costs against a byval one.

'' A CONSTANT STRING ARGUMENT, and its width: 1 narrow, 2 wide, 3 a numeric literal (a
'' constant with no width, which '&' may join to a string), 0 anything else.
''
'' fbc folds a constant string into a LITERAL, and a literal is a ZSTRING -- a WSTRING when
'' any term has a unicode escape -- not a STRING. Measured 2026-09-19, one probe per pair
'' over { string, byval string, zstring ptr, byref zstring, wstring ptr }: "zz", '"z" "z"',
'' '"z" & "z"', '"z" + "z"', '"z" & 1', '( "zz" )', 'const C = "zz"', 'const C as string
'' = "zz"' and 'C1 & "z"' all choose exactly as a 'zstring * 8' variable does, and a
'' literal with a unicode escape, a wide CONST and a wide-and-narrow concatenation exactly
'' as a 'wstring * 8' one. A string VARIABLE, or 'sv & "z"', is a STRING and is not this.
private function ConstStrArgWidth_ _
    ( byref c as Ctx, byval a as Tko.NodeId, byval depth as long = 0 ) as long

    if (a = Tko.NODE_NONE) orelse (depth > 16) then return 0
    select case c.ast->Kind( a )
    case Tko.N_STRING_LIT
        if c.ast->literals[cast( long, c.ast->nodes[cast( long, a )].data )].strWide <> 0 then
            return 2
        end if
        return 1
    case Tko.N_INT_LIT, Tko.N_FLOAT_LIT
        return 3
    case Tko.N_STRCAT, Tko.N_PAREN
        '' Adjacent literals are one; a parenthesis holds one expression.
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, a )].data )]
        dim as boolean isCat = (c.ast->Kind( a ) = Tko.N_STRCAT)
        if lp->count < 1 then return 0
        if (isCat = false) andalso (lp->count <> 1) then return 0
        dim as long w = 0
        for i as long = 0 to lp->count - 1
            dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
            dim as long wi = ConstStrArgWidth_( c, e, depth + 1 )
            if wi = 0 then return 0
            if isCat then
                if wi = 3 then return 0
            end if
            if wi > w then w = wi
        next
        return w
    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, a )].data )]
        dim as Tko.TokenKind op = cast( Tko.TokenKind, bp->op )
        if (op <> Tko.TK_AMP) andalso (op <> Tko.TK_PLUS) then return 0
        dim as long lw = ConstStrArgWidth_( c, bp->lhs, depth + 1 )
        dim as long rw = ConstStrArgWidth_( c, bp->rhs, depth + 1 )
        if (lw = 0) orelse (rw = 0) then return 0
        '' '&' takes a number on either side and '+' does not; one side must be a string.
        if (lw = 3) andalso (rw = 3) then return 0
        if (op = Tko.TK_PLUS) andalso ((lw = 3) orelse (rw = 3)) then return 0
        if (lw = 2) orelse (rw = 2) then return 2
        return 1
    case Tko.N_IDENT
        dim as Tko.Symbol ptr ks = c.syms->SymbolAt( c.info->RefOf( a ) )
        if ks = 0 then return 0
        if ks->kind <> cast( ubyte, Tko.SYM_CONSTANT ) then return 0
        '' A PREDECLARED constant -- 'true', 'false' -- carries a VALUE here, not a node.
        if (ks->payload <= 0) orelse (ks->payload >= c.ast->nodes.Count) then return 0
        dim as Tko.NodeId item = cast( Tko.NodeId, ks->payload )
        if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then return 0
        return ConstStrArgWidth_( c, StmtOf( c, item )->b, depth + 1 )
    end select
    return 0
end function

'' Is this parameter type one of the string family, or a pointer to a zstring or wstring --
'' the parameters the widths above were measured against, and the only ones they change.
private function StrFamilyParam_ _
    ( byref c as Ctx, byval pt as Tko.TypeId ) as boolean

    if pt = Tko.TYPE_NONE then return false
    pt = c.types->Unqualify( pt )
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Unqualify( c.types->Inner( pt ) )
    dim as boolean isPtr = (c.types->Kind( pt ) = Tko.TK_POINTER)
    if isPtr then pt = c.types->Unqualify( c.types->Inner( pt ) )
    if c.types->Kind( pt ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( pt )
    case Tko.TY_ZSTRING, Tko.TY_WSTRING
        return true
    case Tko.TY_STRING, Tko.TY_USTRING
        return (isPtr = false)
    end select
    return false
end function

'' Is this the builtin STRING, const or not?
private function IsVarStrType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return false
    return (c.types->BuiltinOf( t ) = Tko.TY_STRING)
end function

'' A CONST STRING TO A NON-CONST BYVAL STRING, and a NON-CONST string to a CONST one:
'' fbc scores a same-type match whose CONST differs one tier down, below every full-tier
'' string conversion and above the half tier -- CONV_STR_CONST_COPY and the tiers around
'' it are in check.bi. Measured, a 'dim as const string' argument offered { byval string,
'' zstring ptr } takes zstring ptr, and offered { byval string, wstring ptr } takes string.

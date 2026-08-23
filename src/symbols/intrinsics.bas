'' intrinsics.bas -- the keywords that are EXPRESSIONS, and what they return.
''
'' CBYTE through CPTR, PROCPTR, and the 48 IFORM_EXPR keywords -- LEN, ASC, LBOUND,
'' STR and the rest. None of them binds a symbol, so overload resolution has nothing to
'' say and the whole answer is a table measured from fbc:
''
''   tests/types/expected/fbc-conv.txt     the conversion family, exact
''   tests/types/expected/fbc-intrin.txt   the expression family, NOT exact -- see
''                                         tools/gen/check-intrin.sh for the shortfall
''
'' Included by check.bas, which owns the Ctx these read.

'' ------------------------------------------------- the conversion intrinsics

'' CSIGN / CUNSG. Measured in tests/types/expected/fbc-conv.txt, and not guessable: the
'' result is the argument's signed or unsigned COUNTERPART, and the argument itself
'' where there is none -- with a fixed-length string an asymmetric case, since 'cunsg'
'' of a ZSTRING * n is that same type while 'csign' of it is BYTE.
private function SignedFlip_ _
    ( byval t as Fbx.TypeId, byval wantUnsigned as boolean, _
      byref types as Fbx.TypeContext ) as Fbx.TypeId

    if t = Fbx.TYPE_NONE then return Fbx.TYPE_NONE

    '' A POINTER becomes the FIXED-WIDTH integer of the pointer's size, with the
    '' requested signedness -- LONGINT on win64 and LONG on win32, not INTEGER either
    '' time, although INTEGER is the same width as both.
    if types.Kind( t ) = Fbx.TK_POINTER then
        if types.target.pointerBits = 32 then
            return types.Builtin( iif( wantUnsigned, Fbx.TY_ULONG, Fbx.TY_LONG ) )
        end if
        return types.Builtin( iif( wantUnsigned, Fbx.TY_ULONGINT, Fbx.TY_LONGINT ) )
    end if

    dim as Fbx.TypeId fs = FixedStringElem( t, types )
    if fs <> Fbx.TYPE_NONE then
        if wantUnsigned then return t
        select case types.BuiltinOf( fs )
        case Fbx.TY_ZSTRING : return types.Builtin( Fbx.TY_BYTE )
        case Fbx.TY_WSTRING : return types.Builtin( Fbx.TY_SHORT )
        end select
        return t
    end if

    if types.Kind( t ) <> Fbx.TK_BUILTIN then return t
    dim as Fbx.BuiltinType b = types.BuiltinOf( t )
    if wantUnsigned then
        select case b
        case Fbx.TY_BYTE,    Fbx.TY_UBYTE    : return types.Builtin( Fbx.TY_UBYTE )
        case Fbx.TY_SHORT,   Fbx.TY_USHORT   : return types.Builtin( Fbx.TY_USHORT )
        case Fbx.TY_LONG,    Fbx.TY_ULONG    : return types.Builtin( Fbx.TY_ULONG )
        case Fbx.TY_INTEGER, Fbx.TY_UINTEGER : return types.Builtin( Fbx.TY_UINTEGER )
        case Fbx.TY_LONGINT, Fbx.TY_ULONGINT : return types.Builtin( Fbx.TY_ULONGINT )
        end select
        return t
    end if
    select case b
    case Fbx.TY_BYTE,    Fbx.TY_UBYTE    : return types.Builtin( Fbx.TY_BYTE )
    case Fbx.TY_SHORT,   Fbx.TY_USHORT   : return types.Builtin( Fbx.TY_SHORT )
    case Fbx.TY_LONG,    Fbx.TY_ULONG    : return types.Builtin( Fbx.TY_LONG )
    case Fbx.TY_INTEGER, Fbx.TY_UINTEGER : return types.Builtin( Fbx.TY_INTEGER )
    case Fbx.TY_LONGINT, Fbx.TY_ULONGINT : return types.Builtin( Fbx.TY_LONGINT )
    end select
    return t
end function

'' The result of an EXPRESSION intrinsic, or TYPE_NONE when this is not one.
''
'' Measured, and the surprises are the reason: ASC is ULONG rather than any character
'' type, PEEK is UBYTE, SGN is LONG whatever it is handed, and the math functions are
'' SINGLE for a single argument and DOUBLE for everything else. ABS keeps its argument's
'' PROMOTED type -- INTEGER for any integer, the float type for a float -- which is the
'' one rule here that could not have been read off a name.
''
'' Not covered, and named rather than faked: fbc CONSTANT-FOLDS several of these, so
'' 'chr( 1 )' is a ZSTRING * 2 and 'str( 1 )' a ZSTRING * n where the same call on a
'' variable is STRING. Those rows are the gate's shortfall.
private function ExprIntrinsicType_ _
    ( byref c as Ctx, byref nm as string, byval cp as Fbx.ListPayload ptr ) as Fbx.TypeId

    dim as Fbx.TypeId a0 = Fbx.TYPE_NONE
    if cp->count > 0 then
        a0 = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ) )
    end if
    dim as Fbx.BuiltinType ab = Fbx.TY_NONE
    if a0 <> Fbx.TYPE_NONE then
        dim as Fbx.TypeId fs = FixedStringElem( a0, *c.types )
        if fs <> Fbx.TYPE_NONE then
            ab = c.types->BuiltinOf( fs )
        elseif c.types->Kind( a0 ) = Fbx.TK_BUILTIN then
            ab = c.types->BuiltinOf( a0 )
        end if
    end if

    '' ACCEPTANCE is measured too, and is most of the table: fbc REFUSES 'asc( v_byte )'
    '' and 'chr( v_string )', where a rule built only from result types would happily
    '' answer both. Each family names the argument class it takes.
    dim as boolean isStr = IsStringy_( ab )
    dim as boolean isNum = IsInt_( ab ) orelse IsFloat_( ab ) orelse (ab = Fbx.TY_BOOLEAN)
    '' An ARRAY or a POINTER counts as numeric for these: measured, fbc takes
    '' 'chr( v_ptr )' and 'abs( v_arr )' and answers as if given a number.
    if a0 <> Fbx.TYPE_NONE then
        select case c.types->Kind( a0 )
        case Fbx.TK_POINTER : isNum = true
        case Fbx.TK_ARRAY
            if FixedStringElem( a0, *c.types ) = Fbx.TYPE_NONE then isNum = true
        end select
    end if
    dim as boolean isPtr = false
    if a0 <> Fbx.TYPE_NONE then isPtr = (c.types->Kind( a0 ) = Fbx.TK_POINTER)
    dim as boolean isArr = false
    if a0 <> Fbx.TYPE_NONE then
        isArr = (c.types->Kind( a0 ) = Fbx.TK_ARRAY) andalso _
                (FixedStringElem( a0, *c.types ) = Fbx.TYPE_NONE)
    end if

    select case nm
    '' LEN and SIZEOF measure ANYTHING, which is the exception rather than the rule.
    case "len", "sizeof"
        return c.types->Builtin( Fbx.TY_INTEGER )
    case "lbound", "ubound"
        if isArr = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_INTEGER )
    case "instr", "instrrev"
        if isStr = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_INTEGER )
    case "asc"
        if isStr = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_ULONG )
    case "peek"
        if (isNum orelse isPtr) = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_UBYTE )
    case "sgn"
        if isNum = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_LONG )
    case "chr", "mki", "mkl", "mks", "mkd", "mkshort", "mklongint"
        if isNum = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_STRING )
    case "cvi", "cvl", "cvs", "cvd", "cvshort", "cvlongint"
        if isStr = false then return Fbx.TYPE_NONE
        select case nm
        case "cvi"       : return c.types->Builtin( Fbx.TY_INTEGER )
        case "cvl"       : return c.types->Builtin( Fbx.TY_LONG )
        case "cvs"       : return c.types->Builtin( Fbx.TY_SINGLE )
        case "cvd"       : return c.types->Builtin( Fbx.TY_DOUBLE )
        case "cvshort"   : return c.types->Builtin( Fbx.TY_SHORT )
        end select
        return c.types->Builtin( Fbx.TY_LONGINT )
    case "strptr"
        if isStr = false then return Fbx.TYPE_NONE
        return c.types->Pointer_( c.types->Builtin( Fbx.TY_ZSTRING ) )
    case "varptr"
        if a0 = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        return c.types->Pointer_( a0 )

    '' SINGLE in, SINGLE out; everything else DOUBLE.
    case "sin", "cos", "tan", "atn", "asin", "acos", "exp", "log", "sqr"
        if isNum = false then return Fbx.TYPE_NONE
        if ab = Fbx.TY_SINGLE then return c.types->Builtin( Fbx.TY_SINGLE )
        return c.types->Builtin( Fbx.TY_DOUBLE )

    '' The argument's PROMOTED type: any integer gives INTEGER, a float gives itself.
    case "abs", "int", "fix"
        if ab = Fbx.TY_NONE then return Fbx.TYPE_NONE
        if IsFloat_( ab ) then return c.types->Builtin( ab )
        if IsInt_( ab ) then return c.types->Builtin( Fbx.TY_INTEGER )
        return Fbx.TYPE_NONE

    '' A string function keeps the string KIND it was given.
    '' STR is always a var-length STRING, even for a WSTRING argument -- unlike TRIM and
    '' the rest, which keep the kind they were handed.
    case "str"
        if (isNum orelse isStr) = false then return Fbx.TYPE_NONE
        return c.types->Builtin( Fbx.TY_STRING )
    case "trim", "ltrim", "rtrim", "ucase", "lcase", "mid", "left", "right"
        if isStr = false then return Fbx.TYPE_NONE
        if ab = Fbx.TY_WSTRING then return c.types->Builtin( Fbx.TY_WSTRING )
        return c.types->Builtin( Fbx.TY_STRING )

    '' The two GRAPHICS expressions. Their result types are measured from what fbc
    '' declares -- 'void* fb_GfxImageCreate( ... )' and 'uint32 fb_GfxPoint( ... )' --
    '' and neither was typed at all, so 'dim as any ptr a = imagecreate( 16, 16 )'
    '' declined with no idea what it was declining.
    case "imagecreate"
        return c.types->Pointer_( c.types->Builtin( Fbx.TY_ANY ) )
    case "point"
        return c.types->Builtin( Fbx.TY_ULONG )
    end select
    return Fbx.TYPE_NONE
end function

'' The name at an untyped leaf: the identifier itself, or a call's or member's callee.
'' Nothing is recorded for a leaf that has no name to record.
private sub NoteUntypedName_( byref c as Ctx, byval id as Fbx.NodeId )
    if c.st->argUntypedNames.Count >= 200000 then return
    dim as Fbx.NodeId n = id
    if c.ast->Kind( n ) = Fbx.N_CALL then
        dim as Fbx.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        n = cp->target
    end if
    if n = Fbx.NODE_NONE then return
    if c.ast->Kind( n ) = Fbx.N_MEMBER then
        dim as Fbx.BinaryPayload ptr mb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        n = mb->rhs
    end if
    if n = Fbx.NODE_NONE then return
    if c.ast->Kind( n ) <> Fbx.N_IDENT then return
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )]
    c.st->argUntypedNames.Push( cast( ulong, ip->name ) )
end sub

'' The deepest node that is still untyped, following the single path a wrapper takes.
''
'' An argument's own kind is usually N_PAREN or N_BINARY, which says only "something
'' inside is missing". Descending to the leaf turns the count into the list of expression
'' forms actually not implemented -- which is the difference between "1,995 parentheses"
'' and a name to go and write.
private function UntypedLeaf_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.NodeId

    dim as Fbx.NodeId cur = id
    for guard as long = 0 to 63
        select case c.ast->Kind( cur )
        case Fbx.N_PAREN
            dim as Fbx.ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, cur )].data )]
            if lp->count <> 1 then return cur
            cur = cast( Fbx.NodeId, c.ast->children[lp->first] )
        case Fbx.N_UNARY
            dim as Fbx.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, cur )].data )]
            cur = up->operand
        case Fbx.N_BINARY
            '' Whichever side is the untyped one; if both are, the left is reported and
            '' the right will be counted on its own the next time round.
            dim as Fbx.BinaryPayload ptr bp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, cur )].data )]
            if TypeOf_( c, bp->lhs ) = Fbx.TYPE_NONE then
                cur = bp->lhs
            elseif TypeOf_( c, bp->rhs ) = Fbx.TYPE_NONE then
                cur = bp->rhs
            else
                return cur
            end if
        case else
            return cur
        end select
    next
    return cur
end function

'' The TYPE of a procedure symbol -- 'sub cdecl ( byval x as long )' -- as opposed to its
'' return type, which is what Symbol.type_ holds. A procedure type is already a pointer in
'' FreeBASIC, so this wraps one: 'sub( ) ptr' is PPFvvE, two Ps for that reason.
private function ProcTypeOfSymbol_ _
    ( byref c as Ctx, byval sid as Fbx.SymbolId ) as Fbx.TypeId

    if sid = Fbx.SYMBOL_NONE then return Fbx.TYPE_NONE
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return Fbx.TYPE_NONE
    if s->kind <> cast( ubyte, Fbx.SYM_PROC ) then return Fbx.TYPE_NONE
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
    if pn = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return Fbx.TYPE_NONE

    dim as Fbx.StmtPayload ptr pp = StmtOf( c, pn )
    dim as Fbx.TypeId ret = s->type_
    if ret = Fbx.TYPE_NONE then ret = c.types->Builtin( Fbx.TY_VOID )
    dim as Fbx.TypeIdVec2 ps
    for i as long = 0 to pp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
        dim as Fbx.StmtPayload ptr sp2 = StmtOf( c, prm )
        dim as Fbx.TypeId pt = c.info->TypeOf_( sp2->a )
        if pt = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        if (c.ast->nodes[cast( long, prm )].flags and Fbx.NF_BYREF) <> 0 then
            pt = c.types->Reference( pt )
        end if
        ps.Push( cast( ulong, pt ) )
    next
    return c.types->Pointer_( c.types->ProcType( ret, ps ) )
end function

'' The result type of a conversion intrinsic, or TYPE_NONE when this is not one.
''
'' These are KEYWORDS in expression position, so no symbol is ever bound and the callee
'' lookup finds nothing: the whole answer is a table, measured in
'' tests/types/expected/fbc-conv.txt. Their acceptance is WIDER than assignment's --
'' 'cbyte( a_string )' is a BYTE to fbc while 'dim as byte b = a_string' is refused --
'' so ConversionCost is not the viability test here and is not used as one.
private function IntrinsicCallType_ _
    ( byref c as Ctx, byval cp as Fbx.ListPayload ptr ) as Fbx.TypeId

    if cp->target = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return Fbx.TYPE_NONE
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' CAST and CPTR name their result outright, as a TYPE argument.
    if ((nm = "cast") orelse (nm = "cptr")) andalso (cp->count = 2) then
        dim as Fbx.NodeId ta = cast( Fbx.NodeId, c.ast->children[cp->first] )
        if c.ast->Kind( ta ) <> Fbx.N_TYPEREF then return Fbx.TYPE_NONE
        dim as Fbx.TypeId rt = c.info->TypeOf_( ta )
        if rt = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        dim as Fbx.TypeId st = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first + 1] ) )
        if st = Fbx.TYPE_NONE then return rt
        '' Measured acceptance. CPTR reaches a pointer only FROM one, or from a
        '' pointer-width integer; CAST follows the destination's class -- a pointer
        '' destination takes the same two, a numeric one takes anything but a pointer,
        '' and a STRING destination takes a var-length string and nothing else, not even
        '' a ZSTRING * n.
        dim as boolean srcPtr = (c.types->Kind( st ) = Fbx.TK_POINTER)
        dim as boolean srcPtrInt = false
        if c.types->Kind( st ) = Fbx.TK_BUILTIN then
            srcPtrInt = IsPointerSized_( c.types->BuiltinOf( st ), *c.types )
        end if
        if c.types->Kind( rt ) = Fbx.TK_POINTER then
            if (srcPtr orelse srcPtrInt) = false then return Fbx.TYPE_NONE
            return rt
        end if
        if nm = "cptr" then return Fbx.TYPE_NONE
        if c.types->Kind( rt ) = Fbx.TK_BUILTIN then
            if IsStringy_( c.types->BuiltinOf( rt ) ) then
                if st <> rt then return Fbx.TYPE_NONE
                return rt
            end if
        end if
        '' A pointer reaches a numeric destination only when that destination is
        '' POINTER-WIDTH: 'cast( long, p )' is refused on win64 and accepted on win32,
        '' where a long is four bytes like the pointer.
        if srcPtr then
            if c.types->Kind( rt ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE
            if IsPointerSized_( c.types->BuiltinOf( rt ), *c.types ) = false then
                return Fbx.TYPE_NONE
            end if
        end if
        return rt
    end if

    '' The EXPRESSION intrinsics -- LEN, ASC, LBOUND, STR and the rest of the 48
    '' IFORM_EXPR keywords. Measured in tests/types/expected/fbc-intrin.txt; several are
    '' not guessable, which is why the whole family is a table rather than a rule.
    dim as Fbx.TypeId et = ExprIntrinsicType_( c, nm, cp )
    if et <> Fbx.TYPE_NONE then return et

    '' IIF( cond, a, b ) -- the result is the two ARMS' common type, and Check computed
    '' NOTHING for it. That is not just a missing row: it propagates. '(iif( c, a, b
    '' )).i' had an untyped base so the member never resolved, 'print iif( c, 1, 2 )'
    '' could not choose an entry point, and 'var v = iif( ... )' inferred nothing and
    '' got a VOID slot.
    ''
    '' Measured: 'iif( c, u1, u2 )' over a UDT is that UDT, two strings give STRING,
    '' and 1 with 2.5 gives DOUBLE -- the ordinary binary promotion. Identical arms are
    '' answered directly so a UDT, a string and a pointer all work without asking the
    '' numeric table about them.
    if nm = "iif" then
        if cp->count <> 3 then return Fbx.TYPE_NONE
        dim as Fbx.TypeId ta = _
            TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first + 1] ) )
        dim as Fbx.TypeId tb = _
            TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first + 2] ) )
        if ta = tb then return ta
        if ta = Fbx.TYPE_NONE then return tb
        if tb = Fbx.TYPE_NONE then return ta
        return BinaryResult( Fbx.TK_PLUS, ta, tb, *c.types )
    end if

    '' 'procptr( T.m, virtual )' takes a SECOND argument naming which override to
    '' point at. It does not change the result type, so one or two are both accepted
    '' here and everything else is not one of these intrinsics.
    if cp->count < 1 then return Fbx.TYPE_NONE
    if (cp->count > 1) andalso (nm <> "procptr") then return Fbx.TYPE_NONE
    if cp->count > 2 then return Fbx.TYPE_NONE

    '' PROCPTR( F ) is the procedure's own type, which in FreeBASIC is already a pointer.
    '' Measured: 'typeof( procptr( F ) )' is 'SUB CDECL(AS LONG)'.
    ''
    '' It matters far past printing a type. ResolveCall_ treats an untyped ARGUMENT as
    '' making the whole call undecidable, so one of these left fbcunit's
    '' 'fbcu.add_test( ..., procptr( test_name ), ... )' unbound -- and an unbound callee
    '' is a declined statement. 2,444 of them across the corpus, from this one gap.
    if nm = "procptr" then
        '' A MEMBER, not just a bare name: 'procptr( T.proc1 )' is an N_MEMBER, and
        '' rejecting it left the whole expression untyped -- so 'var fp = procptr(
        '' T.proc1 )' gave fp a VOID slot and the store into it was malformed. Both
        '' shapes are bound to their procedure symbol by then, so the type comes from
        '' the same place.
        dim as Fbx.NodeId pa = cast( Fbx.NodeId, c.ast->children[cp->first] )
        dim as Fbx.NodeKind pk = c.ast->Kind( pa )
        if (pk <> Fbx.N_IDENT) andalso (pk <> Fbx.N_MEMBER) then return Fbx.TYPE_NONE
        return ProcTypeOfSymbol_( c, c.info->RefOf( pa ) )
    end if

    dim as Fbx.BuiltinType b = Fbx.TY_NONE
    select case nm
    case "cbyte"    : b = Fbx.TY_BYTE
    case "cubyte"   : b = Fbx.TY_UBYTE
    case "cshort"   : b = Fbx.TY_SHORT
    case "cushort"  : b = Fbx.TY_USHORT
    case "clng"     : b = Fbx.TY_LONG
    case "culng"    : b = Fbx.TY_ULONG
    case "cint"     : b = Fbx.TY_INTEGER
    case "cuint"    : b = Fbx.TY_UINTEGER
    case "clngint"  : b = Fbx.TY_LONGINT
    case "culngint" : b = Fbx.TY_ULONGINT
    case "csng"     : b = Fbx.TY_SINGLE
    case "cdbl"     : b = Fbx.TY_DOUBLE
    case "cbool"    : b = Fbx.TY_BOOLEAN
    case "csign", "cunsg"
        return SignedFlip_( TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ) ), _
                            (nm = "cunsg"), *c.types )
    end select
    if b = Fbx.TY_NONE then return Fbx.TYPE_NONE

    '' A POINTER argument reaches only the pointer-width conversions. For every other
    '' one -- cbyte, csng, cbool -- fbc refuses a pointer outright.
    dim as Fbx.TypeId at = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ) )
    if at <> Fbx.TYPE_NONE then
        if c.types->Kind( at ) = Fbx.TK_POINTER then
            if IsPointerSized_( b, *c.types ) = false then return Fbx.TYPE_NONE
        end if
    end if
    return c.types->Builtin( b )
end function
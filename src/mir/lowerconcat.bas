'' lowerconcat.bas -- concatenation assignment, and the small string helpers beside it.
''
'' Split out of lowerstr.bas at the 1500-line cap and included from it in the same place.



'' 'a &= b' AND 'a += b' OVER A STRING, which is the same statement: measured, fbc
'' emits 'fb_StrConcatAssign( &S, -1ll, src, len, 0 )' for both spellings.
''
'' The operator was recorded on the statement and then thrown away for '&=': the
'' dispatch treated it as PLAIN, so 's &= "b"' lowered to fb_StrAssign -- an
'' assignment, not an append. It verified, it emitted code, it counted as fully
'' lowered, and it was wrong every time. '+=' declined instead, because the compound
'' path works in the target's MIR type and a string is an aggregate.
''
'' Only the shapes fbc reaches with ONE call are lowered. A fixed 'zstring * N' or
'' 'string * N' destination builds a temporary first -- 'fb_StrConcat( &TMP, Z, 10,
'' "f", 2 )' then 'fb_StrAssign( Z, 10, vr, -1, 0 )' -- and a narrow source appended
'' to a WIDE destination needs a temporary's lifetime as well. Those decline, which
'' is the honest answer where half of the model would be a wrong one.
function LowerConcatAssignStmt _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind ) as boolean

    if (op <> Tko.TK_AMPEQ) andalso (op <> Tko.TK_PLUSEQ) then return false
    dim as Tko.TypeId tt = c.info->TypeOf_( target )
    if tt = Tko.TYPE_NONE then return false

    if IsStringType( c, tt ) then
        dim as MirValue dst = LowerAddr( c, target )
        if dst.kind = cast( ubyte, MV_NONE ) then return false
        dim as boolean isU = IsUStringType( c, tt )
        '' 'u &= q' over a narrow source is fb_UStrConcatUA into a TEMPORARY and then an
        '' assign, not one concat-assign -- measured. Appending the narrow bytes through
        '' the UTF-16 entry point is what this used to do.
        '' 'u &= q' over a narrow source is fb_UStrConcatUA into a TEMPORARY and then
        '' an assign, not one concat-assign -- measured. It is the two-term chain
        '' 'u = u + q', so it goes through the same fold.
        dim as long vf = StrTermFlavour_( c, value )

        '' A WIDE SOURCE APPENDED TO A USTRING IS A CONVERSION, not a concat: a
        '' wstring is a bare uint16* and a ustring a DESCRIPTOR, and no entry point
        '' takes one and appends to the other. See WideAppendToU_.
        if isU andalso (vf = STF_WIDE) then
            if WideAppendToU_( c, dst, value ) then return true
        end if

        dim as boolean mism = false
        if vf <> STF_NEUTRAL then
            if isU then
                mism = (vf <> STF_UTF16)
            else
                mism = (vf = STF_UTF16)
            end if
        end if
        if mism then
            dim as FB.Array( of ulong ) two
            two.Push( cast( ulong, target ) )
            two.Push( cast( ulong, value ) )
            if LowerUStrChain( c, dst, isU, two, false ) then return true
            if isU then return LowerNarrowChainToU_( c, dst, two, false )
            return false
        end if
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, value, isU ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        EmitRtl( c, iif( isU, RTL_USTR_CONCAT_ASSIGN, RTL_STR_CONCAT_ASSIGN ), args )
        return true
    end if

    '' A FIXED WIDE STRING with a wide source: 'fb_WstrConcatAssign( W, 50ll, W2 )'.
    if IsWideString_( c, tt ) then
        return LowerWideConcatAssign( c, target, WideStringElems( c, tt ), value )
    end if
    return false
end function

'' Flatten a left-leaning '+' chain into its terms, in source order.
sub FlattenConcat _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outp as FB.Array( of ulong ) )

    if id = Tko.NODE_NONE then return
    if c.ast->Kind( id ) = Tko.N_BINARY then
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' '&' AND '+' ARE THE SAME OPERATION on strings -- measured: fbc emits
        '' fb_StrAssign followed by fb_StrConcatAssign for both, instruction for
        '' instruction. Only '+' was flattened, so 'b = a & p' declined outright while
        '' 'b = a + p' beside it lowered. ('and' is FreeBASIC's bitwise operator, so
        '' '&' is never ambiguous here.)
        dim as Tko.TokenKind bop = cast( Tko.TokenKind, bp->op )
        if (bop = Tko.TK_PLUS) orelse (bop = Tko.TK_AMP) then
            FlattenConcat( c, bp->lhs, outp )
            FlattenConcat( c, bp->rhs, outp )
            return
        end if
    end if
    outp.Push( cast( ulong, id ) )
end sub

'' Whether two expressions name the same storage. Only the simple cases are needed:
'' anything else falls back to the general path rather than guessing.
function SameLValue _
    ( byref c as Ctx, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Tko.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function

'' 'offsetof( T, field )' -- A COMPILE-TIME INTEGER, folded from the measured layout.
''
'' Measured: over a type whose first two fields are INTEGERs, 'offsetof( E, i )' is 16
'' and 'typeof' of it is INTEGER. It takes a TYPE and a FIELD NAME rather than two
'' expressions -- neither argument has a type of its own, and the field name never
'' resolves to anything, which is why nothing else here recognises the shape.
''
'' It was not implemented at all, so every use declined. structs/padding.bas is written
'' almost entirely in terms of it.
function LowerOffsetOf _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 2 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "offsetof" then return false

    '' THE TYPE. Written as a bare name, so Resolve bound it to the UDT's own symbol
    '' rather than typing the node.
    dim as Tko.NodeId tn = cast( Tko.NodeId, c.ast->children[lp->first] )
    dim as Tko.TypeId ut = c.info->TypeOf_( tn )
    if ut = Tko.TYPE_NONE then
        dim as Tko.SymbolId ts = c.info->RefOf( tn )
        dim as Tko.Symbol ptr tsy = c.syms->SymbolAt( ts )
        if tsy = 0 then return false
        ut = tsy->type_
    end if
    if ut = Tko.TYPE_NONE then return false
    ut = c.types->Unqualify( ut )
    if c.types->Kind( ut ) <> Tko.TK_UDT then return false

    '' THE FIELD, by name. It is not an expression and resolves to nothing, so the
    '' spelling is all there is to go on -- which is what the layout store keys on too.
    dim as Tko.NodeId fn = cast( Tko.NodeId, c.ast->children[lp->first + 1] )
    if c.ast->Kind( fn ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr fip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, fn )].data )]

    dim as boolean found = false
    dim as long off = c.udts->FieldOffset( ut, fip->name, found )
    if found = false then return false
    outv = ConstInt( c, off, MT_I64 )
    return true
end function

end namespace

'' lowerstrcmp.bas -- comparing strings, in every width.
''
'' Split out of lowersub.bas at the 1500-line cap and included from it in the same place.



'' A string relational operator.
''
'' MEASURED from fbc: one fb_StrCompare, then the operator applied against ZERO.
''
''     int32 vr$5 = fb_StrCompare( &A$1, -1ll, &B$1, -1ll );
''     if( (int64)vr$5 != 0ll ) goto ...          ' for 'a = b'
''
'' so '=' becomes 'cmp == 0', '<' becomes 'cmp < 0', and so on -- the same operator,
'' with the second operand replaced by 0. The (pointer, length) pairs follow the
'' fb_StrAssign convention, where a literal's length INCLUDES the terminator: fbc passes
'' 4 for "lit" here, not the 3 fb_StrAllocTempDescZEx takes.
function LowerStrCompare _
    ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
      byval tk as Tko.TokenKind ) as MirValue

    dim as MirValue none_
    select case tk
    case Tko.TK_EQ, Tko.TK_NE, Tko.TK_LT, Tko.TK_GT, Tko.TK_LE, Tko.TK_GE
    case else
        '' Concatenation and the rest are not comparisons and do not belong here.
        return none_
    end select

    dim as FB.Array( of ulong ) args
    dim as MirValue cmp

    '' A WIDE COMPARISON is a DIFFERENT function with a different shape: two bare
    '' pointers, no lengths at all, where the narrow one takes (ptr, len) per side.
    '' One entry point covers all six operators, exactly as the narrow one does.
    '' WIDE if EITHER side is, for the same reason the caller's guard asks both: an
    '' intrinsic call has no type of its own, so 'trim( w ) = b' looks wide only from
    '' the right.
    '' TermIsWide_ rather than the type alone: 'wbin( b ) = wstr( "10000000" )' is two
    '' calls, neither of which Check types, so both sides looked NARROW and the whole
    '' comparison declined -- 228 statements in one corpus file, every one of them
    '' inside a CU_ASSERT that then declined with it.
    '' ...AND A CONCATENATION IS WIDE WHEN ITS TERMS ARE. It is an N_BINARY with no
    '' type of its own, so TermIsWide_ said no to it and '(w & 42) = "n=42"' took the
    '' NARROW branch, where EmitStrTerm then declined on the wide operand and the whole
    '' comparison went with it. It worked only when the OTHER side was directly wide,
    '' which is why some corpus lines lowered and their neighbours did not:
    ''
    ''     (w & w) = wstr( "n=n=" )   lowered      (w & w) = "n=n="    declined
    ''     (w & w) = w                lowered      (w & w) = (w & w)   declined
    ''
    '' Measured, fbc takes the wide path and renders the integer as a wide literal:
    '' 'fb_WstrConcat( W$0, L"42" )' then 'fb_WstrCompare( TMP$8$0, L"n=42" )'.
    ''
    '' Asked HERE rather than inside TermIsWide_, which ConcatHasWideTerm_ itself calls
    '' on every term.
    '' UNPARENED: '( w & w ) = "x"' arrives as an N_PAREN, and ConcatHasWideTerm_
    '' answers false for anything that is not itself the N_BINARY.
    dim as Tko.NodeId cl = Unparen_( c, bp->lhs )
    dim as Tko.NodeId cr = Unparen_( c, bp->rhs )
    dim as boolean lw = TermIsWide_( c, bp->lhs ) orelse ConcatHasWideTerm_( c, cl )
    dim as boolean rw = TermIsWide_( c, bp->rhs ) orelse ConcatHasWideTerm_( c, cr )
    dim as boolean isWide = lw orelse rw
    '' ...UNLESS THE OTHER SIDE IS A USTRING, in which case it is a UTF-16 comparison
    '' and the WIDE operand is the one converted -- 'fb_WstrToUStr' then fb_UStrCompare,
    '' measured. Taken as a wide comparison it converted the ustring to a wstring
    '' instead, which reads a descriptor as a bare uint16*.
    if IsUStringType( c, c.info->TypeOf_( bp->lhs ) ) orelse _
       IsUStringType( c, c.info->TypeOf_( bp->rhs ) ) then
        isWide = false
    end if
    if isWide then
        '' EITHER SIDE MAY BE AN RVALUE. LowerAddr alone accepted only an addressable
        '' wide variable, so 'trim( a ) = b' and 'a = wstr( 1 )' produced no comparison
        '' -- and the IF around them went out as a conditional branch with NOTHING to
        '' branch on, silently, for as long as that was tolerated. WideOperand_ already
        '' knows all three spellings; it was simply not asked.
        '' A MIXED COMPARISON CONVERTS THE NARROW SIDE. Measured: 'rt = ru' over a
        '' 'zstring * 50' and a 'wstring * 50' is 'fb_StrToWstr( RT )' into a temporary
        '' and then fb_WstrCompare, with the temporary deleted afterwards. Requiring
        '' both sides to be wide declined the comparison outright.
        dim as MirValue la, ra
        if WideOperand_( c, bp->lhs, la ) = false then
            if NarrowToWideTemp_( c, bp->lhs, la ) = false then return none_
        end if
        if WideOperand_( c, bp->rhs, ra ) = false then
            if NarrowToWideTemp_( c, bp->rhs, ra ) = false then return none_
        end if
        if (la.kind = cast( ubyte, MV_NONE )) orelse _
           (ra.kind = cast( ubyte, MV_NONE )) then return none_
        args.Push( cast( ulong, la.kind ) ) : args.Push( cast( ulong, la.id ) )
        args.Push( cast( ulong, ra.kind ) ) : args.Push( cast( ulong, ra.id ) )
        cmp = EmitRtl( c, RTL_WSTR_COMPARE, args )
    else
        '' EITHER SIDE MAKES IT A USTRING COMPARISON, and the literal on the other
        '' side follows: 'a = "x"' over a ustring is fb_UStrCompare with a UTF-16
        '' literal, where fb_StrCompare would read the descriptor as narrow.
        dim as boolean isU = IsUStringType( c, c.info->TypeOf_( bp->lhs ) ) orelse _
                             IsUStringType( c, c.info->TypeOf_( bp->rhs ) )
        '' ...BUT A REAL STRING ON THE OTHER SIDE IS CONVERTED, not reinterpreted.
        '' Measured: 'u = q' over a narrow string is 'fb_StrToUStr( q, -1 )' into a
        '' temporary and only then fb_UStrCompare, and a wide operand goes through
        '' fb_WstrToUStr the same way. Pushing the narrow bytes straight into the
        '' UTF-16 comparison is what this did, and it compared UTF-8 against UTF-16.
        if isU then
            if UStrCmpOperand_( c, args, bp->lhs ) = false then return none_
            if UStrCmpOperand_( c, args, bp->rhs ) = false then return none_
            cmp = EmitRtl( c, RTL_USTR_COMPARE, args )
        else
            if EmitStrTerm( c, args, bp->lhs, false ) = false then return none_
            if EmitStrTerm( c, args, bp->rhs, false ) = false then return none_
            cmp = EmitRtl( c, RTL_STR_COMPARE, args )
        end if
    end if
    if cmp.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirValue zero_
    zero_.kind = cast( ubyte, MV_CONST_INT )
    zero_.ty = cast( ubyte, MT_I32 )
    zero_.id = 0
    dim as MirInst ins
    ins.op = cast( ushort, BinOpFor( tk, MT_I32, false ) )
    ins.ty = cast( ubyte, MT_I8 )
    ins.a = cmp
    ins.b = zero_
    if ins.op = cast( ushort, M_NONE ) then return none_
    dim as MirValue res = Emit( c, ins )

    '' A STRING COMPARISON IS NEGATED IN VALUE POSITION exactly as a numeric one is:
    '' measured, 'R = -( fb_StrCompare( ... ) == 0 )'. Not for the node being lowered
    '' as a CONDITION, which is a branch and asks only whether it is nonzero.
    if id <> c.rawCmpNode then
        dim as MirInst neg
        neg.op = cast( ushort, M_NEG )
        neg.ty = cast( ubyte, MT_I8 )
        neg.a = res
        return Emit( c, neg )
    end if
    return res
end function

'' Tuple equality, in its own file at the 1500-line cap.

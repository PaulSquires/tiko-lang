'' lowerusing.bas -- PRINT USING, and the SPC/TAB print items.
''
'' Split out of lowerstr.bas, which is at its size limit. PRINT proper stays there;
'' this file is only the USING bracket and the two positioning items.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

declare function UsingRtlFor _
    ( byref c as Ctx, byval t as Tko.TypeId, byref isWide as boolean ) as RtlId
declare function UsingOne_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean


'' PRINT USING.
''
'' Measured, and the shape is NOT the same as PRINT's:
''
''     vr = fb_StrAllocTempDescZEx( "###.##", 6 )
''     fb_PrintUsingInit( vr )                    <-- NO CHANNEL
''     fb_PrintUsingDouble( 0, d, 0 )
''     fb_PrintUsingSingle( 0, f, -2147483647 )
''     fb_PrintUsingEnd( 0 )
''
'' Init takes only the format descriptor. Every item call and End take the channel
'' first. Init and End are per statement and always paired, so a zero-item
'' 'print using f;' still emits both -- and emits no newline at all, because the
'' newline lives in an ITEM's mask and there is no item to carry it.
''
'' Unlike PRINT there is no per-width entry point: every integral type widens to 64
'' bits. There is no fb_PrintUsingByte.
''
'' THE MASK. Only two values are ever emitted, 0 and 0x80000001. Bit 0 is 'emit a
'' newline after this item' -- measured by calling the runtime directly with hand-chosen
'' masks. BIT 31 PRODUCED NO OBSERVABLE DIFFERENCE FROM 0 in any probe; fbc sets it
'' together with bit 0 on the last item and it is presumably an 'is last' flag. It is
'' emitted here because fbc emits it, and no behaviour is implemented for it.
function LowerPrintUsing( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->c = Tko.NODE_NONE then return false

    '' The channel, lowered ONCE and reused -- fbc hoists any non-literal channel
    '' expression into a temporary evaluated before Init, so a channel with a side
    '' effect runs once. The console is the immediate 0, not an instruction.
    dim as MirValue chan
    chan.kind = cast( ubyte, MV_CONST_INT )
    chan.ty = cast( ubyte, MT_I32 )
    chan.id = 0
    if sp->a <> Tko.NODE_NONE then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    end if

    '' The format is an FBSTRING DESCRIPTOR. A literal has none, so it borrows a
    '' temporary one exactly as PRINT does with a literal item.
    dim as MirValue fmt
    '' The slot a WIDE format was converted into, or -1. It is released after Init.
    dim as long fmtTmp = -1
    if c.ast->Kind( sp->c ) = Tko.N_STRING_LIT then
        dim as string litText = StringLitText_( c, sp->c )
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, MV_GLOBAL ) )
        ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
        ta.Push( cast( ulong, MV_CONST_INT ) )
        ta.Push( cast( ulong, len( litText ) ) )
        fmt = EmitRtl( c, RTL_STR_TEMPZ, ta )
    else
        '' A WSTRING FORMAT IS CONVERTED TO A NARROW TEMPORARY, and this used to be
        '' refused with a note calling fbc's shape a bug. It is not one -- the note had
        '' the direction of the assignment backwards. Measured:
        ''
        ''     fb_WstrAssignToA( &TMP4, -1, L"###", 0 );
        ''     fb_PrintUsingInit( &TMP4 );
        ''     fb_StrDelete( &TMP4 );
        ''     fb_PrintUsingLongint( 0, N, -2147483647 );
        ''
        '' -- the narrow temporary is the DESTINATION, Init copies the format out of it,
        '' and the temp is released before the items run. wstring/print_using.bas is
        '' written entirely in wide formats.
        '' WIDE BY TYPE OR BY SHAPE. The corpus writes the format as a wide
        '' CONCATENATION -- 'using ( QT(fmt) & ", " & QT("&") )' -- which types as the
        '' WSTRING builtin rather than a sized one, so counting elements missed it.
        dim as boolean fmtWide = (WideStringElems( c, c.info->TypeOf_( sp->c ) ) > 0)
        if fmtWide = false then fmtWide = IsWideString_( c, c.info->TypeOf_( sp->c ) )
        if fmtWide = false then fmtWide = TermIsWide_( c, Unparen_( c, sp->c ) )
        '' ...and a CONCATENATION is wide when any TERM of it is. The parenthesised
        '' form carries no type of its own, so neither of the tests above sees one:
        '' 'using ( QT(fmt) & ", " & QT("&") )' is the whole of wstring/print_using's
        '' harness and every line of it declined here.
        if fmtWide = false then
            fmtWide = ConcatHasWideTerm_( c, Unparen_( c, sp->c ) )
        end if
        if fmtWide then
            fmtTmp = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
            if fmtTmp < 0 then return false
            dim as MirValue fdst
            fdst.kind = cast( ubyte, MV_LOCAL )
            fdst.ty = cast( ubyte, MT_PTR )
            fdst.id = fmtTmp
            ZeroStrDescriptor( c, fdst )
            if LowerWideToNarrowSlot( c, fmtTmp, _
                   c.types->Builtin( Tko.TY_STRING ), _
                   Unparen_( c, sp->c ) ) = false then return false
            fmt = fdst
        elseif IsStringType( c, c.info->TypeOf_( sp->c ) ) = false then
            return false
        else
        '' A CONCATENATION IS A STRING WITH NO ADDRESS. The corpus writes the format
        '' as one more often than it writes a variable -- 'using ( QT(fmt) & ", " &
        '' QT("&") )' is the whole of one file's harness -- and asking a value for an
        '' address it has not got declined the statement. Built into a temporary
        '' descriptor, which is what every other string argument with no lvalue does.
        fmt = LowerAddr( c, Unparen_( c, sp->c ) )
        if fmt.kind = cast( ubyte, MV_NONE ) then
            if ConcatToTempDesc_( c, Unparen_( c, sp->c ), fmt ) = false then
                return false
            end if
        end if
        end if
    end if
    if fmt.kind = cast( ubyte, MV_NONE ) then return false

    '' Every item is lowered into a scratch list FIRST, so that a type this does not
    '' handle declines BEFORE Init is emitted. Emitting Init and then giving up would
    '' leave the runtime holding a format string with no End to close it.
    dim as FB.Array( of ulong ) itemNode
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Tko.N_PRINT_SEP then continue for
        dim as boolean isWide
        if UsingRtlFor( c, c.info->TypeOf_( it ), isWide ) = RTL_NONE then return false
        itemNode.Push( cast( ulong, it ) )
    next

    dim as FB.Array( of ulong ) ia
    ia.Push( cast( ulong, fmt.kind ) ) : ia.Push( cast( ulong, fmt.id ) )
    EmitRtl( c, RTL_USING_INIT, ia )
    '' ...and the wide format's temporary is released right after Init, which is where
    '' fbc releases it: Init has copied the format out by then.
    if fmtTmp >= 0 then
        dim as MirValue fd
        fd.kind = cast( ubyte, MV_LOCAL )
        fd.ty = cast( ubyte, MT_PTR )
        fd.id = fmtTmp
        dim as FB.Array( of ulong ) da
        da.Push( cast( ulong, fd.kind ) ) : da.Push( cast( ulong, fd.id ) )
        EmitRtl( c, RTL_STR_DELETE, da )
    end if

    for i as long = 0 to itemNode.Count - 1
        '' The last item carries 0x80000001; every earlier one carries 0. A TRAILING
        '' ';' suppresses the newline, and then the last item carries 0 as well.
        dim as long mask = 0
        if i = itemNode.Count - 1 then
            if UsingEndsLine_( c, sp ) then mask = -2147483647
        end if
        if UsingOne_( c, cast( Tko.NodeId, itemNode[i] ), mask, chan ) = false then
            '' Init is already out. Closing the bracket is the least wrong thing
            '' available, and the statement is still counted as skipped.
            dim as FB.Array( of ulong ) ea
            ea.Push( cast( ulong, chan.kind ) ) : ea.Push( cast( ulong, chan.id ) )
            EmitRtl( c, RTL_USING_END, ea )
            SkipHere( c )
            return true
        end if
    next

    dim as FB.Array( of ulong ) ea
    ea.Push( cast( ulong, chan.kind ) ) : ea.Push( cast( ulong, chan.id ) )
    EmitRtl( c, RTL_USING_END, ea )
    return true
end function

'' Whether the statement ends with a newline -- that is, whether its LAST child is an
'' item rather than a trailing ';'. 'print using f; a; b' newlines; 'print using f; a;'
'' does not. A ',' cannot appear here at all: fbc rejects it with error 47.
function UsingEndsLine_( byref c as Ctx, byval sp as Tko.StmtPayload ptr ) as boolean
    if sp->count = 0 then return false
    dim as Tko.NodeId last = cast( Tko.NodeId, c.ast->children[sp->first + sp->count - 1] )
    return (c.ast->Kind( last ) <> Tko.N_PRINT_SEP)
end function

'' One USING item.
private function UsingOne_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    dim as Tko.TypeId t = c.info->TypeOf_( it )
    dim as boolean isWide
    dim as RtlId which = UsingRtlFor( c, t, isWide )
    if which = RTL_NONE then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )

    if isWide then
        '' A wide item passes the POINTER; a wide string has no descriptor.
        ''
        '' AND AN RVALUE HAS NO ADDRESS. 'print using "&"; wstr( cmp )' is how
        '' wstring/print_using writes every item, and asking a CALL for an address gave
        '' nothing -- so the format was emitted, the item declined, and the statement
        '' closed its bracket and gave up. WideOperand_ knows all three spellings of a
        '' wide operand, which is exactly what this argument is.
        dim as MirValue wa = LowerAddr( c, it )
        if wa.kind = cast( ubyte, MV_NONE ) then
            if WideOperand_( c, Unparen_( c, it ), wa ) = false then return false
        end if
        if wa.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, wa.kind ) ) : args.Push( cast( ulong, wa.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_USING_WSTR, args )
        return true
    end if

    if which = RTL_USING_STR then
        dim as MirValue desc
        if c.ast->Kind( it ) = Tko.N_STRING_LIT then
            dim as string litText = StringLitText_( c, it )
            dim as FB.Array( of ulong ) ta
            ta.Push( cast( ulong, MV_GLOBAL ) )
            ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
            ta.Push( cast( ulong, MV_CONST_INT ) )
            ta.Push( cast( ulong, len( litText ) ) )
            desc = EmitRtl( c, RTL_STR_TEMPZ, ta )
        else
            '' Same as the FORMAT above: a concatenation is a string with no address,
            '' and it is what the corpus passes -- 'PRINT_USING_N( fmt, num, cmp )'
            '' expands cmp to a QT() concat at every one of its 20 call sites.
            desc = LowerAddr( c, Unparen_( c, it ) )
            if desc.kind = cast( ubyte, MV_NONE ) then
                if ConcatToTempDesc_( c, Unparen_( c, it ), desc ) = false then
                    return false
                end if
            end if
        end if
        if desc.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_USING_STR, args )
        return true
    end if

    '' Everything else widens. The target MirType comes from the ENTRY POINT, not from
    '' the source type: a LONG goes to fb_PrintUsingLongint and must arrive as an i64.
    dim as MirType want = MT_I64
    select case which
    case RTL_USING_SINGLE  : want = MT_F32
    case RTL_USING_DOUBLE  : want = MT_F64
    case RTL_USING_BOOLEAN : want = MT_I8
    end select

    dim as MirValue v = LowerExpr( c, it )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    v = Coerce( c, v, want, IsUnsignedType( c, t ) )
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    PushConst( args, mask )
    EmitRtl( c, which, args )
    return true
end function

'' The USING entry point for a type. Flatter than PrintRtlFor: there is no per-width
'' family, so every signed integral collapses to Longint and every unsigned to
'' ULongint. A POINTER is rejected by fbc outright (error 24) and is rejected here.
private function UsingRtlFor _
    ( byref c as Ctx, byval t as Tko.TypeId, byref isWide as boolean ) as RtlId

    isWide = false
    if t = Tko.TYPE_NONE then return RTL_NONE
    if WideStringElems( c, t ) > 0 then
        isWide = true
        return RTL_USING_WSTR
    end if
    if IsStringType( c, t ) then return RTL_USING_STR

    select case c.types->Kind( t )
    case Tko.TK_ENUM
        '' fbc sends an enum through fb_PrintUsingDouble, with its own warning 5.
        return RTL_USING_DOUBLE
    case Tko.TK_BUILTIN
        select case c.types->BuiltinOf( t )
        case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG, Tko.TY_LONGINT, Tko.TY_INTEGER
            return RTL_USING_LONGINT
        case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG, Tko.TY_ULONGINT, Tko.TY_UINTEGER
            return RTL_USING_ULONGINT
        case Tko.TY_SINGLE   : return RTL_USING_SINGLE
        case Tko.TY_DOUBLE   : return RTL_USING_DOUBLE
        case Tko.TY_BOOLEAN  : return RTL_USING_BOOLEAN
        end select
    end select
    return RTL_NONE
end function


'' 'spc( n )' and 'tab( n )' as PRINT items.
''
'' They take NO MASK, so 'print spc(n);' emits exactly one call -- no newline, no
'' fb_PrintVoid. They are not items for mask purposes and never absorb the
'' end-of-statement newline, which lands on the neighbouring real item instead.
''
'' The argument widths are NOT the same, and this is measured rather than tidied:
'' fb_PrintSPC's count is ssize -- int64 on win64, int32 on win32 -- and fb_PrintTab's
'' is int32 on BOTH.
function LowerPrintPos _
    ( byref c as Ctx, byval it as Tko.NodeId, byref chan as MirValue ) as boolean

    if c.ast->Kind( it ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, it )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    if cp->count <> 1 then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    if nm = "spc" then
        r = RTL_PRINT_SPC
        want = MT_I64
        if c.types->target.pointerBits = 32 then want = MT_I32
    elseif nm = "tab" then
        r = RTL_PRINT_TAB
    else
        return false
    end if

    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as MirValue n = LowerExpr( c, a0 )
    if n.kind = cast( ubyte, MV_NONE ) then return false
    n = Coerce( c, n, want, IsUnsignedType( c, c.info->TypeOf_( a0 ) ) )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )
    args.Push( cast( ulong, n.kind ) ) : args.Push( cast( ulong, n.id ) )
    EmitRtl( c, r, args )
    return true
end function

end namespace

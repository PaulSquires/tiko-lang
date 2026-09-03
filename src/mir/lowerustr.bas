'' lowerustr.bas -- the USTRING intrinsic family.
''
'' The narrow set lives in lowersub.bas and the wide set in lowerwstr.bas; this is the
'' third, and it exists because a ustring reaching either of the other two is a
'' MISCOMPILE rather than a decline. 'ucase( u )' over a ustring used to emit
''
''     fb_StrUcase2( &U$0, 0 )
''
'' -- the NARROW entry point handed an FBUSTRING, read as a byte string. Verifier
'' clean, "0 statements not lowered", and the answer was whatever the UTF-16 bytes
'' happened to spell. The same for trim, ltrim, rtrim, mid, left, right, instr and
'' instrrev: eight names, all silently wrong.
''
'' EVERY ARGUMENT IS A (POINTER, LENGTH) PAIR where the narrow twin passes a bare
'' descriptor, because a ustring may be fixed-length and the length is what says so.
'' PushStrArg pushes the pair with -1, which is 'as declared'.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' One 'ucase( u )' / 'mid( u, 2, 3 )' / 'instr( u, v )' and the rest, over a USTRING
'' first argument. Returns false for anything that is not one, so the narrow path keeps
'' every case it already had.
function LowerUStrIntrin_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 3) then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' THE FIRST ARGUMENT DECIDES, exactly as it does for the wide family.
    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    if IsUStringType( c, c.info->TypeOf_( a0 ) ) = false then return false

    dim as Tko.NodeId a1 = Tko.NODE_NONE
    if cp->count >= 2 then a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )

    '' WHICH ENTRY POINT, decided before anything is emitted: StrDescriptorOf_ may emit
    '' a call of its own, and a decline afterwards would leave it behind.
    dim as RtlId r = RTL_NONE
    '' THE THREE ARGUMENT SHAPES, and they are not one shape with options. Measured by
    '' reading what fbc emits for 'ucase( u )', 'left( u, 2 )' and 'mid( u, 2 )':
    ''
    ''   fb_UStrUcase( (void*)&U$0, -1ll )              ptr + LENGTH TAG
    ''   fb_UStrTrim ( (void*)&U$0, -1ll )              ptr + LENGTH TAG
    ''   fb_UStrMid  ( (void*)&U$0, -1ll, 2ll, -1ll )   ptr + LENGTH TAG + start + len
    ''   fb_UStrLeftD( (FBUSTRING*)&U$0, 2ll )          ptr + COUNT, no length tag
    ''
    '' left and right take the DESCRIPTOR and a count -- note fbc even spells the
    '' pointer 'FBUSTRING*' there and 'void*' everywhere else -- so passing them the
    '' (pointer, -1) pair every other entry point takes handed them -1 as the COUNT.
    dim as boolean takesLenTag = true
    select case nm
    '' NO 'any' FORM HERE. fbc has no fb_UStrTrimAny and the two- argument trim over a
    '' ustring is not modelled, so those decline rather than reach a narrow entry point.
    case "trim"
        if cp->count <> 1 then return false
        r = RTL_USTR_TRIM
    case "ltrim"
        if cp->count <> 1 then return false
        r = RTL_USTR_LTRIM
    case "rtrim"
        if cp->count <> 1 then return false
        r = RTL_USTR_RTRIM
    case "left"
        if cp->count <> 2 then return false
        takesLenTag = false
        r = RTL_USTR_LEFT
    case "right"
        if cp->count <> 2 then return false
        takesLenTag = false
        r = RTL_USTR_RIGHT
    case "mid"
        if (cp->count < 2) orelse (cp->count > 3) then return false
        r = RTL_USTR_MID
    '' THERE IS NO CASE MODE HERE. The narrow twin takes one; the ustring entry point
    '' does not, and fbc DROPS the argument rather than passing it -- 'ucase( u, 1 )'
    '' and 'ucase( u )' both emit 'fb_UStrUcase( (void*)&U$0, -1ll )', where the -1 is
    '' the length tag every other entry point also takes and not a mode. Read as a
    '' mode it produced a third argument to a two-parameter function.
    case "ucase"
        if (cp->count < 1) orelse (cp->count > 2) then return false
        r = RTL_USTR_UCASE
    case "lcase"
        if (cp->count < 1) orelse (cp->count > 2) then return false
        r = RTL_USTR_LCASE
    case else
        return false
    end select

    dim as MirValue s0
    if StrDescriptorOf_( c, a0, s0 ) = false then return false

    dim as FB.Array( of ulong ) args

    if takesLenTag then
        PushStrArg( args, s0 )
    else
        args.Push( cast( ulong, s0.kind ) ) : args.Push( cast( ulong, s0.id ) )
    end if

    '' The COUNT for left and right, and the START for mid. ucase and lcase take
    '' nothing further, so a second written argument is dropped exactly as fbc drops
    '' it -- see the case labels above.
    dim as boolean wantsSecond = _
        (r = RTL_USTR_LEFT) orelse (r = RTL_USTR_RIGHT) orelse (r = RTL_USTR_MID)
    if wantsSecond andalso (a1 <> Tko.NODE_NONE) then
        dim as MirValue n1 = LowerExpr( c, a1 )
        if n1.kind = cast( ubyte, MV_NONE ) then return false
        n1 = Coerce( c, n1, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
        args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
    end if

    if r = RTL_USTR_MID then
        '' A 'mid' WITHOUT a length passes -1, not 0 -- 0 would silently produce an
        '' empty string instead of the rest of the source. Same rule as the narrow one.
        if cp->count = 3 then
            dim as Tko.NodeId a2 = cast( Tko.NodeId, c.ast->children[cp->first + 2] )
            dim as MirValue n2 = LowerExpr( c, a2 )
            if n2.kind = cast( ubyte, MV_NONE ) then return false
            n2 = Coerce( c, n2, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a2 ) ) )
            args.Push( cast( ulong, n2.kind ) ) : args.Push( cast( ulong, n2.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
    end if

    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function
end namespace

'' lowersub.bas -- the NARROW substring and trim family.
''
'' Split out of lowerstr.bas, which is at its size limit. The wide counterparts live
'' in lowerwstr.bas; what makes these two families different is lifetime, not shape --
'' see the comment on LowerStrRvalue.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' THE NARROW SUBSTRING AND TRIM FAMILY, as an rvalue.
''
'' Each returns an FBSTRING* the runtime owns, and fbc emits NO fb_StrDelete for it --
'' unlike the wide family, there is no lifetime to model here at all. The result is
'' just a descriptor pointer, which is what fb_StrAssign and fb_PrintString both want.
''
'' The spellings are NOT consistent and were read off fbc one at a time:
''
''     trim( a )          fb_TRIM( &A )                shouted
''     trim( a, p )       fb_TrimEx( &A, &P )          mixed case, strip that SUBSTRING
''     trim( a, any p )   fb_TrimAny( &A, &P )         strip any of those CHARACTERS
''     left( a, n )       fb_LEFT( &A, n )             shouted
''     mid( a, n )        fb_StrMid( &A, n, -1 )       different prefix; no length is -1
''     ucase( a )         fb_StrUcase2( &A, 0 )        trailing arg is the mode
''
'' Guessing 'fb_TrimEx' from 'fb_TRIM', or 'fb_Mid' from 'fb_LEFT', would have been
'' wrong in both directions. check-rtl proves all twelve against fbc.
function LowerStrRvalue _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    '' THE RADIX FAMILY shares this entry point: every caller that wants a descriptor
    '' reaches LowerStrRvalue, and putting the test only in StrDescriptorOf_ missed
    '' EmitStrTerm, which calls this one directly -- so 's = hex( n )' still declined
    '' with the implementation sitting right beside it.
    if LowerRadixCall_( c, id, outv ) then return true
    if LowerStrOf_( c, id, outv ) then return true

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 3) then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' The FIRST argument decides. These names are overloaded on wide strings too, and
    '' the wide overload belongs to LowerWideRvalue.
    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    if IsWideString_( c, c.info->TypeOf_( a0 ) ) then return false

    '' The second argument, unwrapped from 'any' if it carries one.
    dim as Tko.NodeId a1 = Tko.NODE_NONE
    dim as boolean isAny = false
    if cp->count >= 2 then
        a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
        if c.ast->Kind( a1 ) = Tko.N_UNARY then
            dim as Tko.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a1 )].data )]
            if cast( Tko.TokenKind, up->op ) = Tko.KW_ANY then
                isAny = true
                a1 = up->operand
            end if
        end if
    end if

    '' WHICH ENTRY POINT, decided before anything is emitted: StrDescriptorOf_ may
    '' emit a call of its own, and a decline afterwards would leave it behind.
    dim as RtlId r = RTL_NONE
    dim as boolean secondIsMode = false      '' the trailing int32 case mode
    dim as boolean secondIsStr = false
    select case nm
    case "trim", "ltrim", "rtrim"
        secondIsStr = true
        if cp->count = 1 then
            select case nm
            case "trim"  : r = RTL_STR_TRIM
            case "ltrim" : r = RTL_STR_LTRIM
            case else    : r = RTL_STR_RTRIM
            end select
        elseif cp->count = 2 then
            if isAny then
                select case nm
                case "trim"  : r = RTL_STR_TRIM_ANY
                case "ltrim" : r = RTL_STR_LTRIM_ANY
                case else    : r = RTL_STR_RTRIM_ANY
                end select
            else
                select case nm
                case "trim"  : r = RTL_STR_TRIM_EX
                case "ltrim" : r = RTL_STR_LTRIM_EX
                case else    : r = RTL_STR_RTRIM_EX
                end select
            end if
        else
            return false
        end if
    case "left"
        if cp->count <> 2 then return false
        r = RTL_STR_LEFT
    case "right"
        if cp->count <> 2 then return false
        r = RTL_STR_RIGHT
    case "mid"
        if (cp->count < 2) orelse (cp->count > 3) then return false
        r = RTL_STR_MID
    '' THE SECOND ARGUMENT IS THE CASE MODE, and it is written: 'ucase( s, 1 )' is
    '' 'fb_StrUcase2( &S$0, 1 )'. Accepting only the one-argument form declined every
    '' call that names it, and string/case.bas names it in all of them.
    case "ucase"
        if (cp->count < 1) orelse (cp->count > 2) then return false
        secondIsMode = true
        r = RTL_STR_UCASE
    case "lcase"
        if (cp->count < 1) orelse (cp->count > 2) then return false
        secondIsMode = true
        r = RTL_STR_LCASE
    case else
        return false
    end select
    if isAny andalso (secondIsStr = false) then return false

    dim as MirValue s0
    if StrDescriptorOf_( c, a0, s0 ) = false then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, s0.kind ) ) : args.Push( cast( ulong, s0.id ) )

    if a1 <> Tko.NODE_NONE then
        if secondIsStr then
            dim as MirValue s1
            if StrDescriptorOf_( c, a1, s1 ) = false then return false
            args.Push( cast( ulong, s1.kind ) ) : args.Push( cast( ulong, s1.id ) )
        else
            dim as MirValue n1 = LowerExpr( c, a1 )
            if n1.kind = cast( ubyte, MV_NONE ) then return false
            '' A COUNT is 64-bit; the case MODE is the int32 fbc declares.
            dim as MirType nw = MT_I64
            if secondIsMode then nw = MT_I32
            n1 = Coerce( c, n1, nw, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
        end if
    end if

    if r = RTL_STR_MID then
        '' A 'mid' WITHOUT a length passes -1, not 0 -- 0 would silently produce an
        '' empty string instead of the rest of the source.
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
    elseif secondIsMode andalso (a1 = Tko.NODE_NONE) then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if

    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' hex / oct / bin / space / string -- the NUMBER-TO-STRING family.
''
'' None of these existed, and their absence was SILENT: 'dim as string h = hex( 123 )'
'' allocated h, called nothing, and reported "0 statements not lowered". Most of
'' iif.bas's remaining declines were waiting on this one name.
''
'' Measured from fbc, and none of it is guessable:
''
''   hex( b )          fb_HEX_b( (uint8)B )        FOUR WIDTHS, by the argument's SIZE
''   hex( sh )         fb_HEX_s( (uint16)SH )
''   hex( l )          fb_HEX_i( (uint32)L )       LONG is 32-bit, so _i and not _l
''   hex( q )          fb_HEX_l( (uint64)Q )
''   hex( l, 4 )       fb_HEXEx_i( (uint32)L, 4 )  a DIFFERENT ENTRY POINT, mixed case
''   space( n )        fb_SPACE( n )
''   string( n, 65 )   fb_StrFill1( n, 65 )        a CHARACTER CODE
''   string( n, "x" )  fb_StrFill2( n, vr )        a DESCRIPTOR -- two entry points
''
'' The SIGNED-TO-UNSIGNED CAST is not cosmetic: it is what makes 'hex( -1 )' on a LONG
'' come out FFFFFFFF rather than sign-extending to sixteen digits. INTEGER is 64-bit on
'' win64 and 32-bit on win32, so the width is decided from the type's own SIZE here
'' rather than from its spelling.
'' 'wantWide' SELECTS WHICH HALF OF THE FAMILY THE CALLER WILL ACCEPT. The narrow
'' names yield an FBSTRING descriptor and the wide ones a bare uint16*, so a caller in
'' a wide context must not be handed a descriptor and vice versa -- and both halves are
'' spelled as an ordinary call, so only the NAME says which this is.
function LowerRadixCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
      byval wantWide as boolean = false ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 2) then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as Tko.NodeId a1 = Tko.NODE_NONE
    if cp->count = 2 then a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )

    '' SPACE and STRING first: their argument is a COUNT, not a value to render, and
    '' neither takes a width.
    if nm = "space" then
        if cp->count <> 1 then return false
        dim as MirValue n0 = LowerExpr( c, a0 )
        if n0.kind = cast( ubyte, MV_NONE ) then return false
        n0 = Coerce( c, n0, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a0 ) ) )
        dim as FB.Array( of ulong ) sa
        sa.Push( cast( ulong, n0.kind ) ) : sa.Push( cast( ulong, n0.id ) )
        outv = EmitRtl( c, RTL_STR_SPACE, sa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' 'wstring( n, ch )' IS THE WIDE HALF, with its own two entry points -- measured,
    '' fb_WstrFill1 and fb_WstrFill2, returning a bare uint16* rather than a
    '' descriptor. Only the narrow name was recognised, so every wide one declined.
    if (nm = "string") orelse (nm = "wstring") then
        if cp->count <> 2 then return false
        dim as boolean fillWide = (nm = "wstring")
        dim as MirValue n0 = LowerExpr( c, a0 )
        if n0.kind = cast( ubyte, MV_NONE ) then return false
        n0 = Coerce( c, n0, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a0 ) ) )
        dim as FB.Array( of ulong ) sa
        sa.Push( cast( ulong, n0.kind ) ) : sa.Push( cast( ulong, n0.id ) )

        '' A STRING SECOND ARGUMENT is a descriptor and a NUMERIC one a character
        '' code -- two entry points, not one with a converted argument.
        dim as boolean isStr = (c.ast->Kind( a1 ) = Tko.N_STRING_LIT)
        if isStr = false then isStr = IsStringType( c, c.info->TypeOf_( a1 ) )
        if fillWide then isStr = IsWideString_( c, c.info->TypeOf_( a1 ) )
        if isStr then
            dim as MirValue dv
            if fillWide then
                if WideOperand_( c, a1, dv ) = false then return false
            elseif StrDescriptorOf_( c, a1, dv ) = false then
                return false
            end if
            sa.Push( cast( ulong, dv.kind ) ) : sa.Push( cast( ulong, dv.id ) )
            outv = EmitRtl( c, iif( fillWide, RTL_WSTR_FILL2, RTL_STR_FILL2 ), sa )
        else
            dim as MirValue cv = LowerExpr( c, a1 )
            if cv.kind = cast( ubyte, MV_NONE ) then return false
            cv = Coerce( c, cv, MT_I32, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            sa.Push( cast( ulong, cv.kind ) ) : sa.Push( cast( ulong, cv.id ) )
            outv = EmitRtl( c, iif( fillWide, RTL_WSTR_FILL1, RTL_STR_FILL1 ), sa )
        end if
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' EACH OF THE THREE HAS A WIDE TWIN, and its runtime name is not the narrow one
    '' with a letter changed: 'whex( b )' is fb_WstrHex_b, mixed case, where the narrow
    '' one is the shouted fb_HEX_b. The result is a uint16*, so the callers that want a
    '' descriptor cannot have one -- which is why the wide family is recognised here
    '' and its result handed back as the bare pointer it is.
    dim as long fam = -1
    dim as boolean wide = false
    select case nm
    case "hex" : fam = 0
    case "oct" : fam = 1
    case "bin" : fam = 2
    case "whex" : fam = 0 : wide = true
    case "woct" : fam = 1 : wide = true
    case "wbin" : fam = 2 : wide = true
    case else  : return false
    end select
    if wide <> wantWide then return false

    '' THE WIDTH, from the argument's own size. A type tiko-lang cannot size at all would
    '' otherwise silently become a 64-bit render.
    dim as Tko.TypeId at = c.info->TypeOf_( a0 )
    if at = Tko.TYPE_NONE then return false
    dim as MirType amt = LowerType( at, *c.types )
    dim as long w = -1
    select case amt
    case MT_I8  : w = 0
    case MT_I16 : w = 1
    case MT_I32 : w = 2
    case MT_I64 : w = 3
    '' A POINTER IS ITS OWN CASE, not a 64-bit integer that happens to be the same
    '' size: fbc calls fb_HEX_p, which takes the pointer. Without it every
    '' 'hex( p )' declined -- and inside a CU_ASSERT that took the whole call with it.
    case MT_PTR : w = 4
    case else   : return false
    end select

    '' FIVE widths per family, not four: the POINTER is one of them, so the stride
    '' changed with it. Leaving it at four made 'hex( p )' collide with 'oct( byte )'.
    dim as RtlId r = RTL_NONE
    if wide then
        if a1 = Tko.NODE_NONE then
            select case fam * 5 + w
            case 0 : r = RTL_WHEX_B
            case 1 : r = RTL_WHEX_S
            case 2 : r = RTL_WHEX_I
            case 3 : r = RTL_WHEX_L
            case 4 : r = RTL_WHEX_P
            case 5 : r = RTL_WOCT_B
            case 6 : r = RTL_WOCT_S
            case 7 : r = RTL_WOCT_I
            case 8 : r = RTL_WOCT_L
            case 9 : r = RTL_WOCT_P
            case 10 : r = RTL_WBIN_B
            case 11 : r = RTL_WBIN_S
            case 12 : r = RTL_WBIN_I
            case 13 : r = RTL_WBIN_L
            case else : r = RTL_WBIN_P
            end select
        else
            select case fam * 5 + w
            case 0 : r = RTL_WHEXEX_B
            case 1 : r = RTL_WHEXEX_S
            case 2 : r = RTL_WHEXEX_I
            case 3 : r = RTL_WHEXEX_L
            case 4 : r = RTL_WHEXEX_P
            case 5 : r = RTL_WOCTEX_B
            case 6 : r = RTL_WOCTEX_S
            case 7 : r = RTL_WOCTEX_I
            case 8 : r = RTL_WOCTEX_L
            case 9 : r = RTL_WOCTEX_P
            case 10 : r = RTL_WBINEX_B
            case 11 : r = RTL_WBINEX_S
            case 12 : r = RTL_WBINEX_I
            case 13 : r = RTL_WBINEX_L
            case else : r = RTL_WBINEX_P
            end select
        end if
    elseif a1 = Tko.NODE_NONE then
        select case fam * 5 + w
        case 0 : r = RTL_HEX_B
        case 1 : r = RTL_HEX_S
        case 2 : r = RTL_HEX_I
        case 3 : r = RTL_HEX_L
        case 4 : r = RTL_HEX_P
        case 5 : r = RTL_OCT_B
        case 6 : r = RTL_OCT_S
        case 7 : r = RTL_OCT_I
        case 8 : r = RTL_OCT_L
        case 9 : r = RTL_OCT_P
        case 10 : r = RTL_BIN_B
        case 11 : r = RTL_BIN_S
        case 12 : r = RTL_BIN_I
        case 13 : r = RTL_BIN_L
        case else : r = RTL_BIN_P
        end select
    else
        select case fam * 5 + w
        case 0 : r = RTL_HEXEX_B
        case 1 : r = RTL_HEXEX_S
        case 2 : r = RTL_HEXEX_I
        case 3 : r = RTL_HEXEX_L
        case 4 : r = RTL_HEXEX_P
        case 5 : r = RTL_OCTEX_B
        case 6 : r = RTL_OCTEX_S
        case 7 : r = RTL_OCTEX_I
        case 8 : r = RTL_OCTEX_L
        case 9 : r = RTL_OCTEX_P
        case 10 : r = RTL_BINEX_B
        case 11 : r = RTL_BINEX_S
        case 12 : r = RTL_BINEX_I
        case 13 : r = RTL_BINEX_L
        case else : r = RTL_BINEX_P
        end select
    end if

    dim as MirValue v0 = LowerExpr( c, a0 )
    if v0.kind = cast( ubyte, MV_NONE ) then return false
    '' UNSIGNED OF THE SAME WIDTH. Coercing to the SAME MIR type with the unsigned flag
    '' set is the reinterpretation fbc's '(uint32)L' is; widening it would change the
    '' answer, which is the whole reason the width was worked out first.
    v0 = Coerce( c, v0, amt, true )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, v0.kind ) ) : args.Push( cast( ulong, v0.id ) )

    if a1 <> Tko.NODE_NONE then
        dim as MirValue n1 = LowerExpr( c, a1 )
        if n1.kind = cast( ubyte, MV_NONE ) then return false
        n1 = Coerce( c, n1, MT_I32, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
        args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
    end if

    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'str( x )' -- a number rendered as a string.
''
'' NARROW TYPES DO NOT GET THEIR OWN ENTRY POINT the way the radix family does, which is
'' the one thing about this that cannot be guessed from hex/oct/bin sitting beside it:
''
''   str( b )   fb_IntToStr( (int32)B )       byte, short and long ALL widen to int32
''   str( ub )  fb_UIntToStr( (uint32)UB )    and the unsigned three to uint32
''   str( q )   fb_LongintToStr( Q )          only 64-bit has its own
''   str( f )   fb_FloatToStr( F )
''   str( bo )  fb_BoolToStr( BO )            BOOLEAN is its own type here, not a byte
''
'' INTEGER is 64-bit on win64, so 'str( i )' is fb_LongintToStr there and fb_IntToStr on
'' win32. Decided from the type's own size rather than its spelling, as everywhere else.
function LowerStrOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' CHR first: same family, but variadic and with a COUNT in front.
    if nm = "chr" then
        if cp->count < 1 then return false
        dim as FB.Array( of ulong ) ca
        ca.Push( cast( ulong, MV_CONST_INT ) ) : ca.Push( cast( ulong, cp->count ) )
        for i as long = 0 to cp->count - 1
            dim as Tko.NodeId ai = cast( Tko.NodeId, c.ast->children[cp->first + i] )
            dim as MirValue av = LowerExpr( c, ai )
            if av.kind = cast( ubyte, MV_NONE ) then return false
            av = Coerce( c, av, MT_I64, IsUnsignedType( c, c.info->TypeOf_( ai ) ) )
            ca.Push( cast( ulong, av.kind ) ) : ca.Push( cast( ulong, av.id ) )
        next
        outv = EmitRtl( c, RTL_STR_CHR, ca )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' THE MKx FAMILY -- a number's BYTES as a string. One number in, a descriptor
    '' out, so it belongs beside CHR rather than with the renderers: MKI writes the
    '' eight bytes of an INTEGER, it does not write "1".
    dim as RtlId mr = RTL_NONE
    dim as MirType mt2 = MT_I32
    select case nm
    case "mkd"      : mr = RTL_MKD       : mt2 = MT_F64
    case "mks"      : mr = RTL_MKS       : mt2 = MT_F32
    case "mkshort"  : mr = RTL_MKSHORT   : mt2 = MT_I16
    case "mkl"      : mr = RTL_MKL       : mt2 = MT_I32
    case "mklongint": mr = RTL_MKLONGINT : mt2 = MT_I64
    case "mki"
        mr = RTL_MKI
        mt2 = MT_I64
        if c.types->target.pointerBits = 32 then mt2 = MT_I32
    end select
    if mr <> RTL_NONE then
        if cp->count <> 1 then return false
        dim as Tko.NodeId ma = cast( Tko.NodeId, c.ast->children[cp->first] )
        dim as MirValue mv = LowerExpr( c, ma )
        if mv.kind = cast( ubyte, MV_NONE ) then return false
        mv = Coerce( c, mv, mt2, IsUnsignedType( c, c.info->TypeOf_( ma ) ) )
        dim as FB.Array( of ulong ) ma2
        ma2.Push( cast( ulong, mv.kind ) ) : ma2.Push( cast( ulong, mv.id ) )
        outv = EmitRtl( c, mr, ma2 )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    if nm <> "str" then return false
    if cp->count <> 1 then return false
    dim as Tko.NodeId sa = cast( Tko.NodeId, c.ast->children[cp->first] )

    '' STR OF A STRING IS THE IDENTITY and fbc emits no conversion for it -- but it is
    '' not a no-op either: 'str( z )' over a 'zstring * N' is
    '' 'fb_StrAllocTempDescZ( (char*)Z )', the descriptor that flavour has to borrow.
    '' StrDescriptorOf_ knows every spelling; without this the whole call declined.
    '' ...and so is STR of a UDT with 'operator cast' to one, which is the same
    '' question asked of a different type kind.
    dim as longint sn
    if IsStringType( c, c.info->TypeOf_( sa ) ) orelse _
       (StrSwapKind_( c, c.info->TypeOf_( sa ), sn ) >= 0) orelse _
       (c.types->Kind( c.info->TypeOf_( sa ) ) = Tko.TK_UDT) then
        return StrDescriptorOf_( c, sa, outv )
    end if
    return NumberToStrDesc_( c, sa, outv )
end function

'' A NUMBER AS A STRING DESCRIPTOR: the body of STR( ), reached from the CONCATENATION
'' path as well. 'x & ", "' over a byte is 'fb_IntToStr( (int32)X )' and then an
'' ordinary narrow concat of the result -- so the renderer is the same one and the only
'' difference is who asks for it.
''
'' Split out when every 'number & string' in the corpus was declining: the conversion
'' existed, and only STR( ) could reach it.
function NumberToStrDesc_ _
    ( byref c as Ctx, byval a0 as Tko.NodeId, byref outv as MirValue ) as boolean

    if a0 = Tko.NODE_NONE then return false
    dim as Tko.TypeId at = c.info->TypeOf_( a0 )
    if at = Tko.TYPE_NONE then return false

    '' A STRING ARGUMENT is the identity and fbc emits no call for it at all.
    if IsStringType( c, at ) then return false

    '' THE ENTRY POINT COMES OFF THE BUILTIN, not off the MIR type: BOOLEAN and BYTE
    '' are both i8 in MIR and take different renderers -- fb_BoolToStr writes
    '' 'true'/'false' where fb_IntToStr would write -1 and 0.
    dim as boolean uns = IsUnsignedType( c, at )
    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    select case c.types->Kind( at )
    case Tko.TK_ENUM
        r = RTL_STR_INTTOSTR
    case Tko.TK_BUILTIN
        select case c.types->BuiltinOf( at )
        case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG    : r = RTL_STR_INTTOSTR
        case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG : r = RTL_STR_UINTTOSTR
        case Tko.TY_LONGINT  : r = RTL_STR_LONGTOSTR  : want = MT_I64
        case Tko.TY_ULONGINT : r = RTL_STR_ULONGTOSTR : want = MT_I64
        case Tko.TY_SINGLE   : r = RTL_STR_FLOATTOSTR : want = MT_F32
        case Tko.TY_DOUBLE   : r = RTL_STR_DBLTOSTR   : want = MT_F64
        case Tko.TY_BOOLEAN  : r = RTL_STR_BOOLTOSTR  : want = MT_I8
        '' INTEGER is 64-bit on win64 and 32-bit on win32, so it is the one type whose
        '' entry point is target-dependent.
        case Tko.TY_INTEGER
            if c.types->target.pointerBits = 32 then
                r = RTL_STR_INTTOSTR
            else
                r = RTL_STR_LONGTOSTR : want = MT_I64
            end if
        case Tko.TY_UINTEGER
            if c.types->target.pointerBits = 32 then
                r = RTL_STR_UINTTOSTR
            else
                r = RTL_STR_ULONGTOSTR : want = MT_I64
            end if
        case else : return false
        end select
    case else
        return false
    end select
    if r = RTL_NONE then return false

    dim as MirValue v0 = LowerExpr( c, a0 )
    if v0.kind = cast( ubyte, MV_NONE ) then return false
    v0 = Coerce( c, v0, want, uns )
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, v0.kind ) ) : args.Push( cast( ulong, v0.id ) )
    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' asc / instr / instrrev / val and its four typed siblings -- the string intrinsics
'' whose result is a NUMBER, so they reach lowering through the expression path rather
'' than the descriptor one.
''
''   asc( s )          fb_ASC( &S, 1ll )              the default position is PASSED
''   asc( s, n )       fb_ASC( &S, (int64)N )
''   instr( s, t )     fb_StrInstr( 1ll, &S, &T )     the start comes FIRST
''   instr( n, s, t )  fb_StrInstr( (int64)N, &S, &T )
''   instr( s, any t ) fb_StrInstrAny( 1ll, &S, &T )
''   instrrev( s, t )  fb_StrInstrRev( &S, &T, -1ll ) the start comes LAST, and is -1
''   val( s )          fb_VAL( &S )                   a DOUBLE, whatever it is assigned
''   vallng/valulng/valint/valuint                    the four typed entry points
''
'' The argument ORDER is not consistent between instr and instrrev, and the default
'' start is 1 for one and -1 for the other. Both were read off fbc, not inferred.
function LowerStrNumCall_ _
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

    dim as RtlId vr = RTL_NONE
    select case nm
    case "val"     : vr = RTL_VAL
    case "vallng"  : vr = RTL_VALLNG
    case "valulng" : vr = RTL_VALULNG
    case "valint"  : vr = RTL_VALINT
    case "valuint" : vr = RTL_VALUINT
    '' THE CVx FAMILY -- a string's BYTES read back as a number. Same shape as VAL:
    '' one descriptor in, a number out. 'cvi' has NO ENTRY POINT OF ITS OWN and
    '' follows the INTEGER width instead, which is fb_CVLONGINT on win64 and fb_CVL
    '' on win32 -- measured on both, and not guessable from the family, which has a
    '' separate fb_MKI on the other side.
    case "cvd"      : vr = RTL_CVD
    case "cvs"      : vr = RTL_CVS
    case "cvshort"  : vr = RTL_CVSHORT
    case "cvl"      : vr = RTL_CVL
    case "cvlongint": vr = RTL_CVLONGINT
    case "cvi"
        vr = RTL_CVLONGINT
        if c.types->target.pointerBits = 32 then vr = RTL_CVL
    end select
    if vr <> RTL_NONE then
        if cp->count <> 1 then return false
        dim as Tko.NodeId v0 = cast( Tko.NodeId, c.ast->children[cp->first] )
        '' A WIDE OPERAND HAS ITS OWN FIVE ENTRY POINTS, taking a bare uint16* rather
        '' than a descriptor. Without them 'valint( w )' declined -- and string/val.bas
        '' asks every one of the five of a wstring beside its narrow twin.
        dim as MirValue sd
        if IsWideString_( c, c.info->TypeOf_( v0 ) ) then
            select case vr
            case RTL_VAL      : vr = RTL_WSTR_VAL
            case RTL_VALLNG   : vr = RTL_WSTR_VALLNG
            case RTL_VALULNG  : vr = RTL_WSTR_VALULNG
            case RTL_VALINT   : vr = RTL_WSTR_VALINT
            case RTL_VALUINT  : vr = RTL_WSTR_VALUINT
            end select
            if WideOperand_( c, v0, sd ) = false then return false
        elseif StrDescriptorOf_( c, v0, sd ) = false then
            return false
        end if
        dim as FB.Array( of ulong ) va
        va.Push( cast( ulong, sd.kind ) ) : va.Push( cast( ulong, sd.id ) )
        outv = EmitRtl( c, vr, va )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    if nm = "asc" then
        if (cp->count < 1) orelse (cp->count > 2) then return false
        dim as Tko.NodeId a0asc = cast( Tko.NodeId, c.ast->children[cp->first] )
        '' A WIDE OPERAND HAS ITS OWN ENTRY POINT, as the val family above does:
        '' 'fb_WstrAsc( (uint16*)W$0, 1ll )'. Asked for a DESCRIPTOR, a wstring had
        '' none and every 'asc( w, n )' declined -- string/asc.bas and
        '' string/asc-utf16le.bas ask it of a wstring beside every narrow one.
        dim as RtlId ascR = RTL_STR_ASC
        dim as MirValue sd
        if IsWideString_( c, c.info->TypeOf_( a0asc ) ) then
            ascR = RTL_WSTR_ASC
            if WideOperand_( c, a0asc, sd ) = false then return false
        elseif StrDescriptorOf_( c, a0asc, sd ) = false then
            return false
        end if
        dim as FB.Array( of ulong ) aa
        aa.Push( cast( ulong, sd.kind ) ) : aa.Push( cast( ulong, sd.id ) )
        if cp->count = 2 then
            dim as Tko.NodeId a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
            dim as MirValue nv = LowerExpr( c, a1 )
            if nv.kind = cast( ubyte, MV_NONE ) then return false
            '' The POSITION follows the pointer -- int64 on win64 and int32 on
            '' win32, measured on both halves of the family.
            dim as MirType pw = MT_I64
            if c.types->target.pointerBits = 32 then pw = MT_I32
            nv = Coerce( c, nv, pw, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            aa.Push( cast( ulong, nv.kind ) ) : aa.Push( cast( ulong, nv.id ) )
        else
            aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( 1 )
        end if
        outv = EmitRtl( c, ascR, aa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    dim as boolean isRev = (nm = "instrrev")
    if (nm <> "instr") andalso (isRev = false) then return false
    if cp->count < 2 then return false

    '' WHERE THE START POSITION SITS IS NOT THE SAME FOR THE TWO OF THEM.
    ''
    ''   instr( start, text, pattern )      first, and passed first
    ''   instrrev( text, pattern, start )   THIRD, and passed last
    ''
    '' Measured on both. Taking the first argument for INSTRREV made 'instrrev( s, p,
    '' 3 )' read the TEXT as a start and the INDEX as a pattern, so the second
    '' descriptor could not be built and the whole call was dropped -- 448 statements
    '' in udt-zstring/instrrev.bas alone, and the call statement did not count them.
    dim as Tko.NodeId startE = Tko.NODE_NONE
    dim as long si = cp->first
    if cp->count = 3 then
        if isRev then
            startE = cast( Tko.NodeId, c.ast->children[cp->first + 2] )
        else
            startE = cast( Tko.NodeId, c.ast->children[cp->first] )
            si += 1
        end if
    end if
    dim as Tko.NodeId sE = cast( Tko.NodeId, c.ast->children[si] )
    dim as Tko.NodeId tE = cast( Tko.NodeId, c.ast->children[si + 1] )

    '' 'instr( s, any t )' strips any of those CHARACTERS and is a different entry
    '' point. The ANY sits on the SECOND string, not on the start.
    dim as boolean isAny = false
    if c.ast->Kind( tE ) = Tko.N_UNARY then
        dim as Tko.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, tE )].data )]
        if cast( Tko.TokenKind, up->op ) = Tko.KW_ANY then
            isAny = true
            tE = up->operand
        end if
    end if
    '' 'instrrev( s, any p )' IS ITS OWN ENTRY POINT, fb_StrInstrRevAny, and not a
    '' shape INSTRREV lacks: it was declined here for want of one.

    '' A WIDE OPERAND TAKES THE WIDE ENTRY POINTS, and there is no descriptor
    '' anywhere in them: a wstring is a bare uint16*. The argument ORDER is the same
    '' on both sides, which is why the wide half belongs here rather than in a
    '' lowering of its own -- and INSTRREV's start sits differently from INSTR's
    '' whichever half it is.
    '' EITHER OPERAND DECIDES. 'instr( ut, sp )' over a UDT with a cast to wstring has
    '' no wide TYPE on the first operand at all -- it is the UDT's -- so asking only
    '' that one sent the whole call down the narrow path, where the descriptor cannot
    '' be built and the call was dropped.
    dim as boolean isWide = IsWideString_( c, c.info->TypeOf_( sE ) )
    isWide = isWide orelse IsWideString_( c, c.info->TypeOf_( tE ) )
    '' ...and a UDT decides by its 'operator cast'. 'instr( ut, up )' has a UDT on
    '' BOTH sides and no wide type anywhere in the expression, so nothing but the cast
    '' overload can say which family the call belongs to.
    isWide = isWide orelse _
        (WideCastOverload_( c, c.info->TypeOf_( sE ) ) <> Tko.SYMBOL_NONE)
    isWide = isWide orelse _
        (WideCastOverload_( c, c.info->TypeOf_( tE ) ) <> Tko.SYMBOL_NONE)

    '' EVERY OPERAND BEFORE ANYTHING IS EMITTED. StrDescriptorOf_ may emit a call of
    '' its own, and declining afterwards would leave it behind with nothing using it.
    dim as MirValue sd, td
    if isWide then
        if WideOperand_( c, sE, sd ) = false then return false
        if WideOperand_( c, tE, td ) = false then return false
    else
        if StrDescriptorOf_( c, sE, sd ) = false then return false
        if StrDescriptorOf_( c, tE, td ) = false then return false
    end if
    dim as MirValue stv
    if startE <> Tko.NODE_NONE then
        stv = LowerExpr( c, startE )
        if stv.kind = cast( ubyte, MV_NONE ) then return false
        stv = Coerce( c, stv, MT_I64, IsUnsignedType( c, c.info->TypeOf_( startE ) ) )
    end if

    dim as FB.Array( of ulong ) args
    if isRev then
        args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) )
        args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) )
        if startE <> Tko.NODE_NONE then
            args.Push( cast( ulong, stv.kind ) ) : args.Push( cast( ulong, stv.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
        dim as RtlId rr = RTL_STR_INSTR_REV
        if isAny then rr = RTL_STR_INSTR_REV_ANY
        if isWide then
            rr = RTL_WSTR_INSTR_REV
            if isAny then rr = RTL_WSTR_INSTR_REV_ANY
        end if
        outv = EmitRtl( c, rr, args )
    else
        if startE <> Tko.NODE_NONE then
            args.Push( cast( ulong, stv.kind ) ) : args.Push( cast( ulong, stv.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 1 )
        end if
        args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) )
        args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) )
        dim as RtlId fr = RTL_STR_INSTR
        if isAny then fr = RTL_STR_INSTR_ANY
        if isWide then
            fr = RTL_WSTR_INSTR
            if isAny then fr = RTL_WSTR_INSTR_ANY
        end if
        outv = EmitRtl( c, fr, args )
    end if
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' A CONCATENATION as a string OPERAND -- 'left( a + b, 4 )', 'len( a + b )',
'' 'a + b = c', an arm of an iif. fbc builds it into a temporary descriptor and uses
'' what fb_StrConcat gives back:
''
''     FBSTRING* vr$8 = fb_StrConcat( &TMP$4, (void*)&A, -1ll, (void*)&B, -1ll );
''     FBSTRING* vr$9 = fb_LEFT( (FBSTRING*)vr$8, 4ll );
''
'' THE TEMPORARY IS NEITHER ZEROED NOR DELETED -- measured: fbc declares it and does
'' nothing else to it, in every one of these shapes. Registering it for cleanup, which
'' is what an iif's own temporary needs, would emit a delete fbc does not.
''
'' Only the TWO-TERM form, because fb_StrConcat takes exactly two operands. A longer
'' chain declines rather than being nested into something fbc does not emit.
function ConcatToTemp_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    '' ANY NUMBER OF TERMS, not two. This read 'terms.Count <> 2' and gave up on the
    '' rest, so 'r = d + t + d' declined where 'r = d + t' beside it lowered -- and a
    '' comparison against a three-term concatenation is most of what one corpus file
    '' does. ConcatTermsToTempDesc_ builds the chain the same way the PRINT path does.
    if e = Tko.NODE_NONE then return false
    if c.ast->Kind( e ) <> Tko.N_BINARY then return false
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, e, terms )
    return ConcatTermsToTempDesc_( c, terms, outv )
end function

'' THE MATH INTRINSICS -- int, fix, frac, abs, sgn, sqr and the transcendentals.
''
'' None of them were lowered, so every one declined. 'ctr1 = 1 + int( (b - a) / s )' is
'' the shape the corpus writes and it was 280 declines in one file.
''
'' THREE DIFFERENT MECHANISMS, and which is which is not guessable -- each was read off
'' fbc's own C:
''
''   sqr sin cos tan asin acos atn log exp   gcc BUILTINS: '__builtin_sqrt( X )'
''   abs                                     a builtin, and a DIFFERENT one per width:
''                                           __builtin_fabs / fabsf / llabs
''   fix frac sgn                            RUNTIME CALLS: fb_FIXDouble, fb_FRACd,
''                                           fb_SGNl -- and SGN returns int32 from all
''                                           three, including the longint form
''   atan2                                   a plain libc call, no builtin prefix
''   int                                     a FLOOR, then the ordinary float-to-integer
''                                           coercion: 'fb_D2L( __builtin_floor( X ) )'
''                                           looks like a fourth case, but fb_D2L is a
''                                           MACRO over nearbyint and that coercion is
''                                           already what Coerce emits
''
'' The builtins are OPCODES rather than runtime entries, because a builtin is declared
'' nowhere -- putting them in the inventory would fail check-rtl, which reads what fbc
'' declares.
function LowerMathCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 2) then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as Tko.TypeId at = c.info->TypeOf_( a0 )
    if at = Tko.TYPE_NONE then return false
    dim as MirType amt = LowerType( at, *c.types )
    dim as boolean isFlt = (amt = MT_F32) orelse (amt = MT_F64)
    dim as boolean uns = IsUnsignedType( c, at )

    '' ATAN2 takes two and is the only one that does.
    if nm = "atan2" then
        if cp->count <> 2 then return false
        dim as Tko.NodeId a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
        dim as MirValue v0 = LowerExpr( c, a0 )
        if v0.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue v1 = LowerExpr( c, a1 )
        if v1.kind = cast( ubyte, MV_NONE ) then return false
        v0 = Coerce( c, v0, MT_F64, uns )
        v1 = Coerce( c, v1, MT_F64, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
        dim as FB.Array( of ulong ) aa
        aa.Push( cast( ulong, v0.kind ) ) : aa.Push( cast( ulong, v0.id ) )
        aa.Push( cast( ulong, v1.kind ) ) : aa.Push( cast( ulong, v1.id ) )
        outv = EmitRtl( c, RTL_ATAN2, aa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if cp->count <> 1 then return false

    '' FIX / FRAC / SGN -- the runtime three. SGN is the odd one out twice over: it
    '' accepts integers as well as floats, and its result is int32 whatever went in.
    dim as RtlId r = RTL_NONE
    dim as MirType want = amt
    select case nm
    case "fix"
        if isFlt = false then return false
        r = iif( amt = MT_F32, RTL_FIX_SINGLE, RTL_FIX_DOUBLE )
    case "frac"
        if isFlt = false then return false
        r = iif( amt = MT_F32, RTL_FRAC_SINGLE, RTL_FRAC_DOUBLE )
    case "sgn"
        if amt = MT_F32 then
            r = RTL_SGN_SINGLE
        elseif amt = MT_F64 then
            r = RTL_SGN_DOUBLE
        else
            r = RTL_SGN_LONGINT
            want = MT_I64
        end if
    end select
    if r <> RTL_NONE then
        dim as MirValue v0 = LowerExpr( c, a0 )
        if v0.kind = cast( ubyte, MV_NONE ) then return false
        v0 = Coerce( c, v0, want, uns )
        dim as FB.Array( of ulong ) aa
        aa.Push( cast( ulong, v0.kind ) ) : aa.Push( cast( ulong, v0.id ) )
        outv = EmitRtl( c, r, aa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' The BUILTINS. Every one but abs and int takes a DOUBLE and gives one back --
    '' fbc widens a single argument rather than reaching for the 'f' variant, except
    '' for abs and floor, which have per-width builtins of their own.
    dim as MirOp op = M_NONE
    dim as MirType rty = MT_F64
    select case nm
    case "sqr"  : op = M_SQRT
    case "sin"  : op = M_SIN
    case "cos"  : op = M_COS
    case "tan"  : op = M_TAN
    case "asin" : op = M_ASIN
    case "acos" : op = M_ACOS
    case "atn"  : op = M_ATAN
    case "log"  : op = M_LOG
    case "exp"  : op = M_EXP
    case "abs"
        '' PER WIDTH, and the integer form widens to int64: '__builtin_llabs(
        '' (int64)N )'. An unsigned argument has nothing to do and is left to the
        '' ordinary path rather than given a signed absolute value.
        if uns andalso (isFlt = false) then return false
        if amt = MT_F32 then
            op = M_FABS : rty = MT_F32
        elseif amt = MT_F64 then
            op = M_FABS : rty = MT_F64
        else
            op = M_IABS : rty = MT_I64
        end if
    case "int"
        '' A FLOOR, and then whatever the surrounding expression wants. 'int' over an
        '' INTEGER is the identity and fbc emits nothing for it.
        if isFlt = false then return false
        op = M_FLOOR : rty = amt
    case else
        return false
    end select

    dim as MirValue v0 = LowerExpr( c, a0 )
    if v0.kind = cast( ubyte, MV_NONE ) then return false
    v0 = Coerce( c, v0, rty, uns )
    dim as MirInst ins
    ins.op = cast( ushort, op )
    ins.ty = cast( ubyte, rty )
    ins.a = v0
    outv = Emit( c, ins )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function




'' A UDT WITH 'operator cast' TO A STRING, converted implicitly.
''
'' 'trim( u )' where u is a UDT is not an error and not a decline: fbc calls the
'' conversion operator and passes what it gives back. Measured, for
'' 'declare operator cast( ) byref as zstring':
''
''     char* vr$4 = _ZN1UcvcEv( &UV$1 );
''     FBSTRING* vr$5 = fb_StrAllocTempDescZ( (char*)vr$4 );
''     FBSTRING* vr$6 = fb_TRIM( (FBSTRING*)vr$5 );
''
'' A BYREF ZSTRING RESULT IS A BARE char*, not a descriptor, so it borrows a temporary
'' one from the no-length entry point -- the same thing a 'zstring * N' variable does.
'' An operator returning a real STRING gives a descriptor and needs no wrapper.
''
'' Only the STRING direction is done here. Implicit user conversion to a NUMBER is the
'' same idea and a different set of call sites, and is still missing.
''
'' Returns the character-data pointer in 'raw' when the operator's result was a bare
'' char*, so a caller that wants (pointer, length) rather than a descriptor -- an
'' assignment, where fbc passes length 0 -- can use it directly.
function UserCastToStr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
      byref raw as boolean ) as boolean

    raw = false
    dim as Tko.TypeId t = c.info->TypeOf_( id )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false

    dim as Tko.SymbolId cs = UdtMemberNamed_( c, t, "cast" )
    if cs = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( cs )
    if s = 0 then return false

    '' THE OVERLOAD THAT YIELDS A STRING. 'operator cast' can be declared several
    '' times over different targets -- as long, as string, as zstring -- and they hang
    '' off one symbol as a chain, so the first is not necessarily the right one.
    dim as Tko.SymbolId cur = cs
    dim as Tko.SymbolId want = Tko.SYMBOL_NONE
    dim as boolean wantRaw = false
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
        if cse = 0 then exit while
        dim as Tko.TypeId rt = cse->type_
        if rt <> Tko.TYPE_NONE then
            dim as longint zn
            if IsStringType( c, rt ) then
                want = cur
                wantRaw = false
                exit while
            elseif StrSwapKind_( c, rt, zn ) = 1 then
                want = cur
                wantRaw = true
                exit while
            else
                '' A BARE 'zstring' -- no length -- which is what a BYREF conversion
                '' operator returns: 'operator cast( ) byref as zstring', and fbc's own
                '' C says the result is a plain 'char*'. It is neither the TK_ARRAY a
                '' 'zstring * N' variable is nor IsStringType, so both tests above miss
                '' it, and byref makes it a POINTER to that -- which is why both
                '' spellings are accepted here.
                dim as Tko.TypeId inner = rt
                if c.types->Kind( inner ) = Tko.TK_POINTER then
                    inner = c.types->Inner( inner )
                end if
                if inner <> Tko.TYPE_NONE then
                    if c.types->Kind( inner ) = Tko.TK_BUILTIN then
                        if c.types->BuiltinOf( inner ) = Tko.TY_ZSTRING then
                            want = cur
                            wantRaw = true
                            exit while
                        end if
                    end if
                end if
            end if
        end if
        cur = cse->nextOverload
    wend
    if want = Tko.SYMBOL_NONE then return false

    dim as MirValue self_ = LowerAddr( c, id )
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue r = EmitMemberCall( c, want, self_, MT_PTR )
    if r.kind = cast( ubyte, MV_NONE ) then return false

    if wantRaw = false then
        outv = r
        return true
    end if

    raw = true
    outv = r
    return true
end function

'' A member of a UDT by name, folded. Nothing when the type has no such member.
function UdtMemberNamed_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Tko.SYMBOL_NONE
    if s->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, c.names->Fold( c.names->GetString( nm ) ) )
end function

'' A narrow string operand as an FBSTRING DESCRIPTOR pointer, however it is spelled:
'' an addressable string, a literal (which borrows a temporary descriptor from the
'' runtime), a string 'iif', or another member of this family.
function StrDescriptorOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    id = Unparen_( c, id )

    '' A STRING CONSTANT IS ITS TEXT. Recognised here rather than left to the type
    '' test below, which would claim it and then ask a constant for an address.
    dim as string constText
    if c.ast->Kind( id ) = Tko.N_IDENT then
        if ConstStringTextOf_( c, id, constText ) then
            dim as FB.Array( of ulong ) ca
            ca.Push( cast( ulong, MV_GLOBAL ) )
            ca.Push( cast( ulong, c.m->AddStringLiteral( constText, *c.names ) ) )
            ca.Push( cast( ulong, MV_CONST_INT ) )
            ca.Push( cast( ulong, len( constText ) ) )
            outv = EmitRtl( c, RTL_STR_TEMPZ, ca )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
    end if

    if c.ast->Kind( id ) = Tko.N_STRING_LIT then
        dim as string litText = StringLitText_( c, id )
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, MV_GLOBAL ) )
        ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
        ta.Push( cast( ulong, MV_CONST_INT ) )
        ta.Push( cast( ulong, len( litText ) ) )
        outv = EmitRtl( c, RTL_STR_TEMPZ, ta )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    '' A CALL TO A STRING-RETURNING FUNCTION, before the type test claims it: an N_CALL
    '' is string-typed and has no address, so 'print f( 2 )' declined outright.
    ''
    '' Typed MT_PTR, not left to the expression's own type. A string is an AGGREGATE to
    '' LowerType, so the descriptor pointer would come back sign-extended and bitcast.
    if c.ast->Kind( id ) = Tko.N_CALL then
        if IsStringType( c, c.info->TypeOf_( id ) ) then
            dim as Tko.ListPayload ptr scp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            dim as Tko.SymbolId scallee = c.info->RefOf( id )
            if scallee = Tko.SYMBOL_NONE then scallee = c.info->RefOf( scp->target )
            if scallee <> Tko.SYMBOL_NONE then
                dim as MirValue scv = LowerCallParts( c, scp->target, scallee, _
                                                      scp->first, scp->count, MT_PTR )
                if scv.kind <> cast( ubyte, MV_NONE ) then
                    outv = scv
                    return true
                end if
            end if
        end if
    end if

    '' A BARE STRING-RETURNING FUNCTION NAME, BEFORE THE TYPE TEST. 's = curdir' names
    '' a function whose TYPE is string, so the branch below claims it and asks for its
    '' ADDRESS -- and the address of a function is a well-typed pointer, so the whole
    '' thing verified with fb_CurDir's entry point handed to fb_StrAssign as a
    '' descriptor.
    ''
    '' The same ordering trap the narrow and wide concat paths set: a recogniser placed
    '' AFTER the type test that would swallow it. Fifth occurrence.
    ''
    '' The call's RESULT IS the descriptor pointer -- fbc writes 'FBSTRING* vr =
    '' fb_CurDir( ); fb_StrAssign( &S, -1, vr, -1, 0 )'.
    dim as MirValue bpv
    if LowerBareProcCall_( c, id, MT_PTR, bpv ) then
        outv = bpv
        return true
    end if

    if IsStringType( c, c.info->TypeOf_( id ) ) then
        outv = LowerAddr( c, id )
        if outv.kind <> cast( ubyte, MV_NONE ) then return true
    end if

    '' A STRING RVALUE FROM THE INTRINSIC FAMILY -- 'mid( s, 1 )', 'trim', 'ucase',
    '' 'hex', 'space' -- whose callee is no symbol at all, so the branch above types it
    '' as a string and then asks a CALL for an address. Its result already IS a
    '' descriptor pointer, which is what every caller here wants.
    dim as MirValue srv2
    if LowerStrRvalue( c, id, srv2 ) then
        outv = srv2
        return true
    end if

    '' A 'string * N' BORROWS A DESCRIPTOR FROM ITS OWN ENTRY POINT, taking the TAGGED
    '' length -- 'fb_StrAllocTempDescF( A, -9223372036854775776ll )'. It is not the Z
    '' form, which strlen's a NUL-terminated buffer a fixed string does not have.
    dim as longint fdn
    if StrSwapKind_( c, c.info->TypeOf_( id ), fdn ) = 3 then
        dim as MirValue fa = LowerAddr( c, id )
        if fa.kind <> cast( ubyte, MV_NONE ) then
            dim as FB.Array( of ulong ) fta
            fta.Push( cast( ulong, fa.kind ) ) : fta.Push( cast( ulong, fa.id ) )
            PushStrLen_( c, fta, fdn )
            outv = EmitRtl( c, RTL_STR_TEMPF, fta )
            if outv.kind <> cast( ubyte, MV_NONE ) then return true
        end if
    end if

    '' A ZSTRING * N has no descriptor -- it is a char array -- so it borrows a
    '' temporary one over its own bytes, from the NO-LENGTH variant that works the
    '' length out from the terminator. That is what fbc emits for 'trim( z )':
    '' 'vr = fb_StrAllocTempDescZ( Z )' and then the trim on vr.
    dim as longint zn
    if StrSwapKind_( c, c.info->TypeOf_( id ), zn ) = 1 then
        dim as MirValue za = LowerAddr( c, id )
        if za.kind <> cast( ubyte, MV_NONE ) then
            dim as FB.Array( of ulong ) ta
            ta.Push( cast( ulong, za.kind ) ) : ta.Push( cast( ulong, za.id ) )
            outv = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
            if outv.kind <> cast( ubyte, MV_NONE ) then return true
        end if
    end if
    '' A CONCATENATION, before any type test: a concat IS string-typed, so the
    '' IsStringType branch above would claim it and ask for an address it has not got.
    dim as MirValue ccv
    if ConcatToTemp_( c, id, ccv ) then
        outv = ccv
        return true
    end if

    '' A UDT WITH 'operator cast' TO A STRING. Tried before the general fallback: the
    '' conversion is what makes the operand a string at all, and without it 'trim( u )'
    '' declined outright.
    dim as boolean ucRaw = false
    dim as MirValue ucv
    if UserCastToStr_( c, id, ucv, ucRaw ) then
        if ucRaw = false then
            outv = ucv
            return true
        end if
        '' A BARE char* borrows a temporary descriptor, exactly as a 'zstring * N'
        '' variable does -- and from the NO-LENGTH entry point, because a converted
        '' result carries no declared length to pass.
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, ucv.kind ) ) : ta.Push( cast( ulong, ucv.id ) )
        outv = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, ta )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' AN IIF, whatever its arms look like: everything that asks for a descriptor is
    '' already in a string context, and the arm types cannot answer it -- Check
    '' computes no type for an intrinsic call, so 'iif( c, hex( 1 ), hex( 2 ) )' looks
    '' like an iif over nothing and declined the statement around it.
    dim as Tko.NodeId iC, iT, iE
    if IsIifCall_( c, id, iC, iT, iE ) then
        return LowerStringIif_( c, iC, iT, iE, outv )
    end if
    return LowerStrRvalue( c, id, outv )
end function


'' Assigning INTO a fixed-length narrow string -- 'dim t as zstring * 50 = <expr>'.
''
'' A ZSTRING * N has no descriptor: it is a char array. Measured, and the LENGTH
'' ARGUMENTS are the whole story --
''
''     dim t  as zstring * 50 = "  ab  "   fb_StrAssign( T,  50, "  ab  ", 7, 0 )
''     dim r2 as zstring * 50 = t          fb_StrAssign( R2, 50, T,       50, 0 )
''     dim rt as zstring * 50 = trim( t )  vr = fb_StrAllocTempDescZ( T )
''                                         vr2 = fb_TRIM( vr )
''                                         fb_StrInit( RT, 50, vr2, -1, 0 )
''
'' The destination passes its ELEMENT COUNT, never -1 -- passing -1 for a fixed-length
'' operand tells the runtime to read a descriptor out of character data. The source
'' passes its own: a literal's byte length INCLUDING the terminator, a zstring's element
'' count, and -1 for anything that is a descriptor.
''
'' StrINIT rather than StrAssign for a descriptor source, which is what fbc emits and
'' is not guessable from the other two rows.
'' 'dim as UDT x = ( 1, 2, 3 )' -- THE PAREN INITIALISER LIST.
''
'' Measured, and none of the shape is what symmetry would suggest:
''
''   - A LOCAL NEVER GETS A STATIC AGGREGATE INITIALISER. fbc declares the struct
''     uninitialised and emits one store per supplied value. The static form
''     ('static T X = { 1, 2, 3 }') comes from the STORAGE CLASS -- 'dim shared' or
''     'static' -- and never from the initialiser syntax. A module-level 'dim' is a
''     local of the module constructor and behaves exactly like one in a SUB.
''   - THE VALUES ARE FLATTENED. A nested 'dim as Outer x = ( ( 1, 2 ), 3 )' emits the
''     same three stores at offsets 0, 4, 8 as a flat type would: nesting exists in the
''     parser and nowhere else.
''   - A PARTIAL LIST ZEROES THE TAIL, AFTER THE STORES, not the whole struct before
''     them: '__builtin_memset( (void*)((uint8*)&X + 4ll), 0, 8ll )' -- addressed at
''     the first field with no value and sized to the remainder.
''   - A UNION GETS NO MEMSET AT ALL. Asymmetric with the struct case above.
''
'' Two forms the parser hands over: N_TUPLE when a comma was written and N_PAREN when
'' one value was. Both are list nodes and both mean the same thing here.
''
'' NOT HANDLED, because fbc REJECTS it: a UDT with a 'string' or 'string * N' field
'' cannot be initialised this way at all -- 'error 24: Invalid data types', or 'error 7'
'' at the first comma. A 'zstring * N' field IS allowed and goes through the string
'' path, so it is the one field type here that is not a plain store.
declare function FlattenUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval base_ as long, _
      byref offs as FB.Array( of ulong ), byref tys as FB.Array( of ulong ), _
      byval depth as long ) as boolean

function LowerZstrAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as longint, _
      byval value as Tko.NodeId, byval isInit as boolean, _
      byval isU as boolean = false ) as boolean

    '' THE TRAILING ARGUMENT DEPENDS ONLY ON THE DESTINATION, and it is -1 for a
    '' FIXED-LENGTH string and 0 for everything else -- measured across all three
    '' flavours, and it is the source that never affects it. A negative 'n' is what
    '' says the destination is a fixed one: the sign bit IS the tag.
    dim as long tail = iif( n < 0, -1, 0 )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    PushStrLen_( c, args, n )

    if c.ast->Kind( value ) = Tko.N_STRING_LIT then
        dim as string lit = StringLitText_( c, value )
        '' A USTRING DESTINATION TAKES A UTF-16 LITERAL, and its length is the tagged
        '' CHARACTER COUNT rather than the narrow family's len+1.
        if isU then
            PushUStrLiteralArg( c, args, _
                c.m->AddWideStringLiteral( lit, *c.names ), len( lit ) )
        else
            args.Push( cast( ulong, MV_GLOBAL ) )
            args.Push( cast( ulong, c.m->AddStringLiteral( lit, *c.names ) ) )
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, len( lit ) + 1 ) )
        end if
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, tail ) )
        EmitRtl( c, iif( isU, RTL_USTR_ASSIGN, RTL_STR_ASSIGN ), args )
        return true
    end if

    '' A ZSTRING or a var-len STRING source, both addressable.
    dim as Tko.TypeId st = c.info->TypeOf_( value )
    dim as longint zn
    dim as long sk = StrSwapKind_( c, st, zn )
    '' A FIXED-LENGTH SOURCE is addressable like the other two and carries its own
    '' encoded length -- kind 3, which this test used to exclude, so 'a = b' over two
    '' 'string * 32's fell through to the descriptor path and then declined.
    '' Kind 4 is a fixed USTRING source, addressable and encoded the same way.
    if (sk = 0) orelse (sk = 1) orelse (sk = 3) orelse (sk = 4) then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind <> cast( ubyte, MV_NONE ) then
            args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
            PushStrLen_( c, args, zn )
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, tail ) )
            EmitRtl( c, iif( isU, RTL_USTR_ASSIGN, RTL_STR_ASSIGN ), args )
            return true
        end if
    end if

    '' A UDT CONVERTED BY 'operator cast'. A byref-zstring result is a bare char* and
    '' passes LENGTH 0 -- measured, 'z = u' is 'fb_StrAssign( Z, 50ll, vr, 0ll, 0 )'.
    '' Falling through to the descriptor path below would wrap it in
    '' fb_StrAllocTempDescZ first: the same answer at runtime, not the same code.
    dim as boolean ucRaw = false
    dim as MirValue ucv
    if UserCastToStr_( c, value, ucv, ucRaw ) then
        args.Push( cast( ulong, ucv.kind ) ) : args.Push( cast( ulong, ucv.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, iif( ucRaw, 0, cast( longint, -1 ) ) ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, tail ) )
        EmitRtl( c, iif( isInit, RTL_STR_INIT, RTL_STR_ASSIGN ), args )
        return true
    end if

    '' Anything that yields a DESCRIPTOR -- 'trim( t )', a string iif, a literal-backed
    '' temporary. HERE ALONE the two contexts differ, and measurably:
    ''
    ''     dim as zstring * 8 z1 = trim( a )   fb_StrInit  ( Z1, 8, vr, -1, 0 )
    ''     z2 = trim( a )                      fb_StrAssign( Z2, 8, vr, -1, 0 )
    ''
    '' The literal and addressable branches above use fb_StrAssign in BOTH contexts --
    '' also measured, not assumed from the symmetry.
    dim as MirValue rv
    if StrDescriptorOf_( c, value, rv ) = false then return false
    args.Push( cast( ulong, rv.kind ) ) : args.Push( cast( ulong, rv.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( ulongint, -1 ) ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, tail ) )
    EmitRtl( c, iif( isInit, RTL_STR_INIT, RTL_STR_ASSIGN ), args )
    return true
end function


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
    dim as boolean isWide = TermIsWide_( c, bp->lhs ) orelse TermIsWide_( c, bp->rhs )
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
#include once "mir/lowertup.bas"

end namespace

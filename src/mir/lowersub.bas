'' lowersub.bas -- the NARROW substring and trim family.
''
'' Split out of lowerstr.bas, which is at its size limit. The wide counterparts live
'' in lowerwstr.bas; what makes these two families different is lifetime, not shape --
'' see the comment on LowerStrRvalue.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx

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
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 3) then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' The FIRST argument decides. These names are overloaded on wide strings too, and
    '' the wide overload belongs to LowerWideRvalue.
    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, c.ast->children[cp->first] )
    if WideStringElems( c, c.info->TypeOf_( a0 ) ) > 0 then return false

    '' The second argument, unwrapped from 'any' if it carries one.
    dim as Fbx.NodeId a1 = Fbx.NODE_NONE
    dim as boolean isAny = false
    if cp->count >= 2 then
        a1 = cast( Fbx.NodeId, c.ast->children[cp->first + 1] )
        if c.ast->Kind( a1 ) = Fbx.N_UNARY then
            dim as Fbx.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a1 )].data )]
            if cast( Fbx.TokenKind, up->op ) = Fbx.KW_ANY then
                isAny = true
                a1 = up->operand
            end if
        end if
    end if

    '' WHICH ENTRY POINT, decided before anything is emitted: StrDescriptorOf_ may
    '' emit a call of its own, and a decline afterwards would leave it behind.
    dim as RtlId r = RTL_NONE
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
    case "ucase"
        if cp->count <> 1 then return false
        r = RTL_STR_UCASE
    case "lcase"
        if cp->count <> 1 then return false
        r = RTL_STR_LCASE
    case else
        return false
    end select
    if isAny andalso (secondIsStr = false) then return false

    dim as MirValue s0
    if StrDescriptorOf_( c, a0, s0 ) = false then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, s0.kind ) ) : args.Push( cast( ulong, s0.id ) )

    if a1 <> Fbx.NODE_NONE then
        if secondIsStr then
            dim as MirValue s1
            if StrDescriptorOf_( c, a1, s1 ) = false then return false
            args.Push( cast( ulong, s1.kind ) ) : args.Push( cast( ulong, s1.id ) )
        else
            dim as MirValue n1 = LowerExpr( c, a1 )
            if n1.kind = cast( ubyte, MV_NONE ) then return false
            n1 = Coerce( c, n1, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
        end if
    end if

    if r = RTL_STR_MID then
        '' A 'mid' WITHOUT a length passes -1, not 0 -- 0 would silently produce an
        '' empty string instead of the rest of the source.
        if cp->count = 3 then
            dim as Fbx.NodeId a2 = cast( Fbx.NodeId, c.ast->children[cp->first + 2] )
            dim as MirValue n2 = LowerExpr( c, a2 )
            if n2.kind = cast( ubyte, MV_NONE ) then return false
            n2 = Coerce( c, n2, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a2 ) ) )
            args.Push( cast( ulong, n2.kind ) ) : args.Push( cast( ulong, n2.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
    elseif (r = RTL_STR_UCASE) orelse (r = RTL_STR_LCASE) then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if

    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' A narrow string operand as an FBSTRING DESCRIPTOR pointer, however it is spelled:
'' an addressable string, a literal (which borrows a temporary descriptor from the
'' runtime), a string 'iif', or another member of this family.
function StrDescriptorOf_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) = Fbx.N_STRING_LIT then
        dim as string litText = StringLitText_( c, id )
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, MV_GLOBAL ) )
        ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
        ta.Push( cast( ulong, MV_CONST_INT ) )
        ta.Push( cast( ulong, len( litText ) ) )
        outv = EmitRtl( c, RTL_STR_TEMPZ, ta )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if IsStringType( c, c.info->TypeOf_( id ) ) then
        outv = LowerAddr( c, id )
        if outv.kind <> cast( ubyte, MV_NONE ) then return true
    end if
    if IsStringIif_( c, id ) then return LowerIif( c, id, MT_VOID, outv )
    return LowerStrRvalue( c, id, outv )
end function

end namespace

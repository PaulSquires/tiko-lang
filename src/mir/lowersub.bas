'' lowersub.bas -- the NARROW substring and trim family.
''
'' Split out of lowerstr.bas, which is at its size limit. The wide counterparts live
'' in lowerwstr.bas; what makes these two families different is lifetime, not shape --
'' see the comment on LowerStrRvalue.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

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

    '' THE RADIX FAMILY shares this entry point: every caller that wants a descriptor
    '' reaches LowerStrRvalue, and putting the test only in StrDescriptorOf_ missed
    '' EmitStrTerm, which calls this one directly -- so 's = hex( n )' still declined
    '' with the implementation sitting right beside it.
    if LowerRadixCall_( c, id, outv ) then return true

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
function LowerRadixCall_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 2) then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, c.ast->children[cp->first] )
    dim as Fbx.NodeId a1 = Fbx.NODE_NONE
    if cp->count = 2 then a1 = cast( Fbx.NodeId, c.ast->children[cp->first + 1] )

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

    if nm = "string" then
        if cp->count <> 2 then return false
        dim as MirValue n0 = LowerExpr( c, a0 )
        if n0.kind = cast( ubyte, MV_NONE ) then return false
        n0 = Coerce( c, n0, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a0 ) ) )
        dim as FB.Array( of ulong ) sa
        sa.Push( cast( ulong, n0.kind ) ) : sa.Push( cast( ulong, n0.id ) )

        '' A STRING SECOND ARGUMENT is a descriptor and a NUMERIC one a character
        '' code -- two entry points, not one with a converted argument.
        dim as boolean isStr = (c.ast->Kind( a1 ) = Fbx.N_STRING_LIT)
        if isStr = false then isStr = IsStringType( c, c.info->TypeOf_( a1 ) )
        if isStr then
            dim as MirValue dv
            if StrDescriptorOf_( c, a1, dv ) = false then return false
            sa.Push( cast( ulong, dv.kind ) ) : sa.Push( cast( ulong, dv.id ) )
            outv = EmitRtl( c, RTL_STR_FILL2, sa )
        else
            dim as MirValue cv = LowerExpr( c, a1 )
            if cv.kind = cast( ubyte, MV_NONE ) then return false
            cv = Coerce( c, cv, MT_I32, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            sa.Push( cast( ulong, cv.kind ) ) : sa.Push( cast( ulong, cv.id ) )
            outv = EmitRtl( c, RTL_STR_FILL1, sa )
        end if
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    dim as long fam = -1
    select case nm
    case "hex" : fam = 0
    case "oct" : fam = 1
    case "bin" : fam = 2
    case else  : return false
    end select

    '' THE WIDTH, from the argument's own size. A type fbx cannot size at all would
    '' otherwise silently become a 64-bit render.
    dim as Fbx.TypeId at = c.info->TypeOf_( a0 )
    if at = Fbx.TYPE_NONE then return false
    dim as MirType amt = LowerType( at, *c.types )
    dim as long w = -1
    select case amt
    case MT_I8  : w = 0
    case MT_I16 : w = 1
    case MT_I32 : w = 2
    case MT_I64 : w = 3
    case else   : return false
    end select

    dim as RtlId r = RTL_NONE
    if a1 = Fbx.NODE_NONE then
        select case fam * 4 + w
        case 0 : r = RTL_HEX_B
        case 1 : r = RTL_HEX_S
        case 2 : r = RTL_HEX_I
        case 3 : r = RTL_HEX_L
        case 4 : r = RTL_OCT_B
        case 5 : r = RTL_OCT_S
        case 6 : r = RTL_OCT_I
        case 7 : r = RTL_OCT_L
        case 8 : r = RTL_BIN_B
        case 9 : r = RTL_BIN_S
        case 10 : r = RTL_BIN_I
        case else : r = RTL_BIN_L
        end select
    else
        select case fam * 4 + w
        case 0 : r = RTL_HEXEX_B
        case 1 : r = RTL_HEXEX_S
        case 2 : r = RTL_HEXEX_I
        case 3 : r = RTL_HEXEX_L
        case 4 : r = RTL_OCTEX_B
        case 5 : r = RTL_OCTEX_S
        case 6 : r = RTL_OCTEX_I
        case 7 : r = RTL_OCTEX_L
        case 8 : r = RTL_BINEX_B
        case 9 : r = RTL_BINEX_S
        case 10 : r = RTL_BINEX_I
        case else : r = RTL_BINEX_L
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

    if a1 <> Fbx.NODE_NONE then
        dim as MirValue n1 = LowerExpr( c, a1 )
        if n1.kind = cast( ubyte, MV_NONE ) then return false
        n1 = Coerce( c, n1, MT_I32, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
        args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
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
    '' AN IIF, whatever its arms look like: everything that asks for a descriptor is
    '' already in a string context, and the arm types cannot answer it -- Check
    '' computes no type for an intrinsic call, so 'iif( c, hex( 1 ), hex( 2 ) )' looks
    '' like an iif over nothing and declined the statement around it.
    dim as Fbx.NodeId iC, iT, iE
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
function LowerZstrAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as longint, _
      byval value as Fbx.NodeId, byval isInit as boolean ) as boolean

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, n ) )

    if c.ast->Kind( value ) = Fbx.N_STRING_LIT then
        dim as string lit = StringLitText_( c, value )
        args.Push( cast( ulong, MV_GLOBAL ) )
        args.Push( cast( ulong, c.m->AddStringLiteral( lit, *c.names ) ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, len( lit ) + 1 ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        EmitRtl( c, RTL_STR_ASSIGN, args )
        return true
    end if

    '' A ZSTRING or a var-len STRING source, both addressable.
    dim as Fbx.TypeId st = c.info->TypeOf_( value )
    dim as longint zn
    dim as long sk = StrSwapKind_( c, st, zn )
    if (sk = 0) orelse (sk = 1) then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind <> cast( ubyte, MV_NONE ) then
            args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, zn ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
            EmitRtl( c, RTL_STR_ASSIGN, args )
            return true
        end if
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
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, iif( isInit, RTL_STR_INIT, RTL_STR_ASSIGN ), args )
    return true
end function


end namespace

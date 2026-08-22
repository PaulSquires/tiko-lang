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
    if LowerStrOf_( c, id, outv ) then return true

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
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' CHR first: same family, but variadic and with a COUNT in front.
    if nm = "chr" then
        if cp->count < 1 then return false
        dim as FB.Array( of ulong ) ca
        ca.Push( cast( ulong, MV_CONST_INT ) ) : ca.Push( cast( ulong, cp->count ) )
        for i as long = 0 to cp->count - 1
            dim as Fbx.NodeId ai = cast( Fbx.NodeId, c.ast->children[cp->first + i] )
            dim as MirValue av = LowerExpr( c, ai )
            if av.kind = cast( ubyte, MV_NONE ) then return false
            av = Coerce( c, av, MT_I64, IsUnsignedType( c, c.info->TypeOf_( ai ) ) )
            ca.Push( cast( ulong, av.kind ) ) : ca.Push( cast( ulong, av.id ) )
        next
        outv = EmitRtl( c, RTL_STR_CHR, ca )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    if nm <> "str" then return false
    if cp->count <> 1 then return false
    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, c.ast->children[cp->first] )
    dim as Fbx.TypeId at = c.info->TypeOf_( a0 )
    if at = Fbx.TYPE_NONE then return false

    '' A STRING ARGUMENT is the identity and fbc emits no call for it at all.
    if IsStringType( c, at ) then return false

    '' THE ENTRY POINT COMES OFF THE BUILTIN, not off the MIR type: BOOLEAN and BYTE
    '' are both i8 in MIR and take different renderers -- fb_BoolToStr writes
    '' 'true'/'false' where fb_IntToStr would write -1 and 0.
    dim as boolean uns = IsUnsignedType( c, at )
    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    select case c.types->Kind( at )
    case Fbx.TK_ENUM
        r = RTL_STR_INTTOSTR
    case Fbx.TK_BUILTIN
        select case c.types->BuiltinOf( at )
        case Fbx.TY_BYTE, Fbx.TY_SHORT, Fbx.TY_LONG    : r = RTL_STR_INTTOSTR
        case Fbx.TY_UBYTE, Fbx.TY_USHORT, Fbx.TY_ULONG : r = RTL_STR_UINTTOSTR
        case Fbx.TY_LONGINT  : r = RTL_STR_LONGTOSTR  : want = MT_I64
        case Fbx.TY_ULONGINT : r = RTL_STR_ULONGTOSTR : want = MT_I64
        case Fbx.TY_SINGLE   : r = RTL_STR_FLOATTOSTR : want = MT_F32
        case Fbx.TY_DOUBLE   : r = RTL_STR_DBLTOSTR   : want = MT_F64
        case Fbx.TY_BOOLEAN  : r = RTL_STR_BOOLTOSTR  : want = MT_I8
        '' INTEGER is 64-bit on win64 and 32-bit on win32, so it is the one type whose
        '' entry point is target-dependent.
        case Fbx.TY_INTEGER
            if c.types->target.pointerBits = 32 then
                r = RTL_STR_INTTOSTR
            else
                r = RTL_STR_LONGTOSTR : want = MT_I64
            end if
        case Fbx.TY_UINTEGER
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

    dim as RtlId vr = RTL_NONE
    select case nm
    case "val"     : vr = RTL_VAL
    case "vallng"  : vr = RTL_VALLNG
    case "valulng" : vr = RTL_VALULNG
    case "valint"  : vr = RTL_VALINT
    case "valuint" : vr = RTL_VALUINT
    end select
    if vr <> RTL_NONE then
        if cp->count <> 1 then return false
        dim as MirValue sd
        if StrDescriptorOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ), sd ) = false then
            return false
        end if
        dim as FB.Array( of ulong ) va
        va.Push( cast( ulong, sd.kind ) ) : va.Push( cast( ulong, sd.id ) )
        outv = EmitRtl( c, vr, va )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    if nm = "asc" then
        if (cp->count < 1) orelse (cp->count > 2) then return false
        dim as MirValue sd
        if StrDescriptorOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ), sd ) = false then
            return false
        end if
        dim as FB.Array( of ulong ) aa
        aa.Push( cast( ulong, sd.kind ) ) : aa.Push( cast( ulong, sd.id ) )
        if cp->count = 2 then
            dim as Fbx.NodeId a1 = cast( Fbx.NodeId, c.ast->children[cp->first + 1] )
            dim as MirValue nv = LowerExpr( c, a1 )
            if nv.kind = cast( ubyte, MV_NONE ) then return false
            nv = Coerce( c, nv, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            aa.Push( cast( ulong, nv.kind ) ) : aa.Push( cast( ulong, nv.id ) )
        else
            aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( 1 )
        end if
        outv = EmitRtl( c, RTL_STR_ASC, aa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    dim as boolean isRev = (nm = "instrrev")
    if (nm <> "instr") andalso (isRev = false) then return false
    if cp->count < 2 then return false

    '' THE START POSITION IS THE FIRST ARGUMENT WHEN THERE ARE THREE, and the two
    '' strings follow. With two arguments there is no start and the default is used.
    dim as Fbx.NodeId startE = Fbx.NODE_NONE
    dim as long si = cp->first
    if cp->count = 3 then
        startE = cast( Fbx.NodeId, c.ast->children[cp->first] )
        si += 1
    end if
    dim as Fbx.NodeId sE = cast( Fbx.NodeId, c.ast->children[si] )
    dim as Fbx.NodeId tE = cast( Fbx.NodeId, c.ast->children[si + 1] )

    '' 'instr( s, any t )' strips any of those CHARACTERS and is a different entry
    '' point. The ANY sits on the SECOND string, not on the start.
    dim as boolean isAny = false
    if c.ast->Kind( tE ) = Fbx.N_UNARY then
        dim as Fbx.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, tE )].data )]
        if cast( Fbx.TokenKind, up->op ) = Fbx.KW_ANY then
            isAny = true
            tE = up->operand
        end if
    end if
    if isAny andalso isRev then return false

    '' EVERY OPERAND BEFORE ANYTHING IS EMITTED. StrDescriptorOf_ may emit a call of
    '' its own, and declining afterwards would leave it behind with nothing using it.
    dim as MirValue sd, td
    if StrDescriptorOf_( c, sE, sd ) = false then return false
    if StrDescriptorOf_( c, tE, td ) = false then return false
    dim as MirValue stv
    if startE <> Fbx.NODE_NONE then
        stv = LowerExpr( c, startE )
        if stv.kind = cast( ubyte, MV_NONE ) then return false
        stv = Coerce( c, stv, MT_I64, IsUnsignedType( c, c.info->TypeOf_( startE ) ) )
    end if

    dim as FB.Array( of ulong ) args
    if isRev then
        args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) )
        args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) )
        if startE <> Fbx.NODE_NONE then
            args.Push( cast( ulong, stv.kind ) ) : args.Push( cast( ulong, stv.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
        outv = EmitRtl( c, RTL_STR_INSTR_REV, args )
    else
        if startE <> Fbx.NODE_NONE then
            args.Push( cast( ulong, stv.kind ) ) : args.Push( cast( ulong, stv.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 1 )
        end if
        args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) )
        args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) )
        outv = EmitRtl( c, iif( isAny, RTL_STR_INSTR_ANY, RTL_STR_INSTR ), args )
    end if
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

declare function UdtMemberNamed_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref nm as string ) as Fbx.SymbolId

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
    dim as Fbx.TypeId at = c.info->TypeOf_( a0 )
    if at = Fbx.TYPE_NONE then return false
    dim as MirType amt = LowerType( at, *c.types )
    dim as boolean isFlt = (amt = MT_F32) orelse (amt = MT_F64)
    dim as boolean uns = IsUnsignedType( c, at )

    '' ATAN2 takes two and is the only one that does.
    if nm = "atan2" then
        if cp->count <> 2 then return false
        dim as Fbx.NodeId a1 = cast( Fbx.NodeId, c.ast->children[cp->first + 1] )
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
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue, _
      byref raw as boolean ) as boolean

    raw = false
    dim as Fbx.TypeId t = c.info->TypeOf_( id )
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false

    dim as Fbx.SymbolId cs = UdtMemberNamed_( c, t, "cast" )
    if cs = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( cs )
    if s = 0 then return false

    '' THE OVERLOAD THAT YIELDS A STRING. 'operator cast' can be declared several
    '' times over different targets -- as long, as string, as zstring -- and they hang
    '' off one symbol as a chain, so the first is not necessarily the right one.
    dim as Fbx.SymbolId cur = cs
    dim as Fbx.SymbolId want = Fbx.SYMBOL_NONE
    dim as boolean wantRaw = false
    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr cse = c.syms->SymbolAt( cur )
        if cse = 0 then exit while
        dim as Fbx.TypeId rt = cse->type_
        if rt <> Fbx.TYPE_NONE then
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
                dim as Fbx.TypeId inner = rt
                if c.types->Kind( inner ) = Fbx.TK_POINTER then
                    inner = c.types->Inner( inner )
                end if
                if inner <> Fbx.TYPE_NONE then
                    if c.types->Kind( inner ) = Fbx.TK_BUILTIN then
                        if c.types->BuiltinOf( inner ) = Fbx.TY_ZSTRING then
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
    if want = Fbx.SYMBOL_NONE then return false

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
private function UdtMemberNamed_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref nm as string ) as Fbx.SymbolId

    if t = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
    dim as Fbx.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Fbx.SYMBOL_NONE
    dim as Fbx.ScopeId ds = cast( Fbx.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Fbx.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Fbx.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Fbx.SYMBOL_NONE
    if s->inner = Fbx.SCOPE_NONE then return Fbx.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, c.names->Fold( c.names->GetString( nm ) ) )
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
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
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
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, iif( isInit, RTL_STR_INIT, RTL_STR_ASSIGN ), args )
    return true
end function


end namespace

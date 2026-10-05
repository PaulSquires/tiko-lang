'' lowersub.bas -- the NARROW substring and trim family.
''
'' Split out of lowerstr.bas, which is at its size limit. The wide counterparts live
'' in lowerwstr.bas; what makes these two families different is lifetime, not shape --
'' see the comment on LowerStrRvalue.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

'' Defined in lowerwstr.bas. A WIDE result is an allocation the caller owns, and
'' this is what parks it in a temporary and registers that for its fb_WstrDelete.
declare function WideConcatStep_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), byval r as RtlId, _
      byref acc as MirValue ) as boolean

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

    '' THE RADIX FAMILY shares this entry point: every caller wanting a descriptor reaches it,
    '' and the test only in StrDescriptorOf_ missed EmitStrTerm, which calls this directly --
    '' so 's = hex( n )' declined. A program's own 'hex' is not it: CallsUserProcNamedLikeBuiltin.
    if CallsUserProcNamedLikeBuiltin( c, id ) then return false
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

    '' ...AND A USTRING BELONGS TO lowerustr.bas. Falling through to the narrow rows
    '' below handed an FBUSTRING to fb_StrUcase2, fb_TRIM, fb_StrMid and fb_StrInstr --
    '' the byte-string entry points -- which lowered, verified, and answered with
    '' whatever the UTF-16 bytes happened to spell.
    if LowerUStrIntrin_( c, id, outv ) then return true
    if IsUStringType( c, c.info->TypeOf_( a0 ) ) then return false
    '' ...AND SO DOES A WIDE CHAIN, which Check types STRING: see IntrinOverWideConcat_.
    if IntrinOverWideConcat_( c, id ) then return false

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

    '' OPERANDS RIGHT TO LEFT, pushed in position order. Measured, over operands that
    '' record their own evaluation: mid( s, a, b ) is 321 to fbc, left and right 21,
    '' trim( s, t ) and trim( s, any t ) 21, ucase( s, mode ) 01. tiko went left to
    '' right -- the rule LowerCallParts follows for an ordinary call applies here too.
    dim as MirValue v2
    if (r = RTL_STR_MID) andalso (cp->count = 3) then
        dim as Tko.NodeId a2 = cast( Tko.NodeId, c.ast->children[cp->first + 2] )
        v2 = LowerExpr( c, a2 )
        if v2.kind = cast( ubyte, MV_NONE ) then return false
        v2 = CoerceTy( c, v2, MT_I64, c.info->TypeOf_( a2 ))
    end if
    dim as MirValue v1
    if a1 <> Tko.NODE_NONE then
        if secondIsStr then
            if StrDescriptorOf_( c, a1, v1 ) = false then return false
        else
            v1 = LowerExpr( c, a1 )
            if v1.kind = cast( ubyte, MV_NONE ) then return false
            dim as MirType nw = MT_I64
            if secondIsMode then nw = MT_I32
            v1 = CoerceTy( c, v1, nw, c.info->TypeOf_( a1 ))
        end if
    end if
    dim as MirValue s0
    if StrDescriptorOf_( c, a0, s0 ) = false then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, s0.kind ) ) : args.Push( cast( ulong, s0.id ) )
    if a1 <> Tko.NODE_NONE then
        args.Push( cast( ulong, v1.kind ) ) : args.Push( cast( ulong, v1.id ) )
    end if

    if r = RTL_STR_MID then
        if cp->count = 3 then
            args.Push( cast( ulong, v2.kind ) ) : args.Push( cast( ulong, v2.id ) )
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

'' hex / oct / bin / space / string -- the NUMBER-TO-STRING family, in its own file.
#include once "mir/lowerradix.bas"

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
            av = CoerceTy( c, av, MT_I64, c.info->TypeOf_( ai ))
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
        mv = CoerceTy( c, mv, mt2, c.info->TypeOf_( ma ))
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
    '' 'str( w )' OVER A WIDE OPERAND IS A CONVERSION, not the identity: it answers a
    '' NARROW descriptor. Measured -- 'fb_WstrToStr( (uint16*)vr )', and the entry point
    '' was in the runtime table with no caller at all, so every wide 'str' declined. The
    '' operand may be a wstring, a 'wstring * N' or a UDT that CASTS to one, which is
    '' exactly the set TermIsWide_ answers for.
    '' ...and OVER A USTRING it converts too -- see UStrOperandToNarrow_.
    '' ...BUT OVER A UDT WHOSE CAST IS A USTRING IT IS THAT CAST, unconverted (T50): measured,
    '' '#print typeof( str( v ) )' is USTRING and fbc emits the cast then fb_UStrAssign.
    if UdtCastIsUStr_( c, sa ) then return StrDescriptorOf_( c, sa, outv )
    dim as boolean nconv = false
    if NarrowConvOf_( c, sa, outv, nconv ) then return true
    if nconv then return false
    dim as longint sn
    if IsStringType( c, c.info->TypeOf_( sa ) ) orelse _
       (StrSwapKind_( c, c.info->TypeOf_( sa ), sn ) >= 0) orelse _
       (c.types->Kind( c.info->TypeOf_( sa ) ) = Tko.TK_UDT) then
        return StrDescriptorOf_( c, sa, outv )
    end if
    return NumberToStrDesc_( c, sa, outv )
end function

'' A WIDE OR UTF-16 VALUE AS A NARROW DESCRIPTOR: the conversion 'str( e )' makes, and
'' 'type<string>( e )' with it -- see NarrowingTypeLitOperand_. A WIDE CHAIN is one too:
'' TermIsWide_ answers for no chain, so 'str( "a" & w ) & "b"' declined and printed
'' nothing. Measured, fbc: fb_WstrConcatAW, then 'fb_WstrToStr( TMP )'.
''
'' 'isConv' says whether e needed a conversion at all; TRUE is returned only when one
'' was made, so a caller tells "not mine" (isConv false) from "mine, and declined".
function NarrowConvOf_ _
    ( byref c as Ctx, byval sa as Tko.NodeId, byref outv as MirValue, _
      byref isConv as boolean ) as boolean

    isConv = false
    if TermIsWide_( c, sa ) orelse IsWideChain_( c, sa ) then
        isConv = true
        dim as MirValue wsv
        if WideOperand_( c, sa, wsv ) = false then return false
        dim as FB.Array( of ulong ) wsa
        wsa.Push( cast( ulong, wsv.kind ) ) : wsa.Push( cast( ulong, wsv.id ) )
        outv = EmitRtl( c, RTL_WSTR_TO_STR, wsa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if UStrOperandToNarrow_( c, sa, outv ) then
        isConv = true
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    return false
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
    '' A POINTER RENDERS AS ITS ADDRESS, unsigned. Measured -- 'str( p )' over a
    '' 'wstring ptr' and over an 'any ptr' alike is 'fb_ULongintToStr( (uint64)P$0 )',
    '' and the wide half is fb_ULongintToWstr. Refusing it left the call untyped, and
    '' an untyped argument takes the enclosing statement with it.
    case Tko.TK_POINTER
        r = RTL_STR_ULONGTOSTR : want = MT_I64 : uns = true
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

        '' A NON-STRING OPERAND IS THE OTHER HALF OF THE FAMILY. 'cvi( 1.58e40 )' does
        '' not read a string's bytes -- there is no string -- it REINTERPRETS a
        '' number's bits, and fbc has a separate entry point for each pairing:
        ''
        ''   cvi( d ) / cvlongint( d )   fb_CVLONGINTFROMD( D$0 )
        ''   cvl( f )                    fb_CVLFROMS( F$0 )
        ''   cvd( q ) / cvd( i )         fb_CVDFROMLONGINT( Q$0 )
        ''   cvs( l )                    fb_CVSFROML( L$0 )
        ''
        '' -- measured, and fbc REJECTS every other pairing (its error 58), so there is
        '' no fifth row to invent. Asked for a descriptor, a number had none and every
        '' one of these declined; string/mkcv.bas writes eight of them.
        dim as Tko.TypeId v0t = c.info->TypeOf_( v0 )
        dim as boolean v0str = IsStringType( c, v0t ) orelse _
                               IsWideString_( c, v0t )
        '' 'zstring * N' and 'wstring * N' are ARRAYS of the char builtin, which
        '' neither string test above claims; CharElemSize_ is what tells one from an
        '' ordinary array.
        if v0str = false then
            if CharElemSize_( c, v0t ) > 0 then v0str = true
        end if
        '' A UDT IS A STRING OPERAND WHEN IT CASTS TO ONE, and only the descriptor
        '' branch below can find that out -- UserCastToStr_ EMITS the call, so it
        '' cannot be asked here as a question. A UDT with no such cast reaches it and
        '' returns false, which is the decline there was before.
        if v0str = false then
            if c.types->Kind( c.types->Unqualify( v0t ) ) = Tko.TK_UDT then
                v0str = true
            end if
        end if
        if (v0str = false) andalso (v0t <> Tko.TYPE_NONE) then
            dim as RtlId fr = RTL_NONE
            dim as MirType want = MT_VOID
            select case vr
            case RTL_CVLONGINT : fr = RTL_CVLONGINT_FROM_D : want = MT_F64
            case RTL_CVL       : fr = RTL_CVL_FROM_S       : want = MT_F32
            case RTL_CVD       : fr = RTL_CVD_FROM_LONGINT : want = MT_I64
            case RTL_CVS       : fr = RTL_CVS_FROM_L       : want = MT_I32
            end select
            if fr = RTL_NONE then return false
            dim as MirValue nv = LowerExpr( c, v0 )
            if nv.kind = cast( ubyte, MV_NONE ) then return false
            nv = CoerceTy( c, nv, want, v0t)
            dim as FB.Array( of ulong ) fa
            fa.Push( cast( ulong, nv.kind ) ) : fa.Push( cast( ulong, nv.id ) )
            outv = EmitRtl( c, fr, fa )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
        '' A WIDE OPERAND HAS ITS OWN FIVE ENTRY POINTS, taking a bare uint16* rather
        '' than a descriptor. Without them 'valint( w )' declined -- and string/val.bas
        '' asks every one of the five of a wstring beside its narrow twin.
        dim as MirValue sd
        '' ...AND A UDT WITH 'operator cast( ) as wstring' IS A WIDE OPERAND (TermIsWide_, as
        '' asc below): AfxNova's DWSTRING asked for a narrow descriptor, had none, and
        '' 'val( left( dws, 4 ) )' was dropped from the build unreported. VAL family only.
        dim as boolean valFam = (vr = RTL_VAL) orelse (vr = RTL_VALLNG) orelse _
            (vr = RTL_VALULNG) orelse (vr = RTL_VALINT) orelse (vr = RTL_VALUINT)
        if valFam andalso UStrValOperand_( c, v0, v0t, sd ) then   '' a ustring converts first
        elseif IsWideString_( c, c.info->TypeOf_( v0 ) ) orelse (valFam andalso TermIsWide_( c, v0 )) then
            select case vr
            case RTL_VAL      : vr = RTL_WSTR_VAL
            case RTL_VALLNG   : vr = RTL_WSTR_VALLNG
            case RTL_VALULNG  : vr = RTL_WSTR_VALULNG
            case RTL_VALINT   : vr = RTL_WSTR_VALINT
            case RTL_VALUINT  : vr = RTL_WSTR_VALUINT
            end select
            if WideOperand_( c, v0, sd ) = false then return false
        elseif valFam andalso UStrToStrTemp_( c, v0, sd ) then   '' see UStrToStrTemp_
        elseif StrDescriptorOf_( c, v0, sd ) = false then
            '' A UDT WITH 'operator cast' TO A ZSTRING HAS NO DESCRIPTOR, and
            '' StrDescriptorOf_ answers no for it -- so 'valint( u )' declined while
            '' 's = u' beside it lowered. Measured, fbc calls the operator and wraps
            '' the char* it returns:
            ''
            ''     vr = _ZN2UZcvRcEv( &U$0 );
            ''     vr2 = fb_StrAllocTempDescZ( (char*)vr );
            ''     fb_VALINT( (FBSTRING*)vr2 )
            ''
            '' -- the same borrow the LSET and MID paths already make. 'asc( u )' was
            '' given the wide half of this treatment when it was written; this is the
            '' narrow half, for the val and cv families.
            dim as MirValue ucv
            dim as boolean uRaw = false
            if UserCastToStr_( c, v0, ucv, uRaw ) = false then return false
            if uRaw = false then return false
            dim as FB.Array( of ulong ) uta
            uta.Push( cast( ulong, ucv.kind ) ) : uta.Push( cast( ulong, ucv.id ) )
            sd = EmitRtl( c, RTL_STR_TEMPZ_NOLEN, uta )
            if sd.kind = cast( ubyte, MV_NONE ) then return false
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
        '' TermIsWide_, not IsWideString_ on the TYPE: a UDT that declares
        '' 'operator cast( ) as wstring' IS a wide operand, and its type is a UDT. So
        '' 'asc( u )' asked for a narrow descriptor, a UDT has none, and it declined --
        '' while 'w = u' and 'dim w as wstring * 10 = u' beside it both lowered, because
        '' WideOperand_ has known about the cast all along.
        dim as boolean ascU = IsUStringType( c, c.info->TypeOf_( a0asc ) )  '' fb_UStrAsc( u, -1, n )
        if ascU = false then ascU = UdtCastIsUStr_( c, a0asc )   '' a UDT casting to a ustring (T50)
        dim as RtlId ascR = RTL_STR_ASC : if ascU then ascR = RTL_USTR_ASC
        dim as MirValue sd
        dim as FB.Array( of ulong ) aa
        '' A 'ustring * N' HAS NO DESCRIPTOR: fbc passes its buffer and TAGGED length,
        '' 'fb_UStrAsc( LF$0, &h8000000000000005, 1 )', the pair EmitStrTerm pushes.
        dim as longint ascTag
        if TermIsWide_( c, a0asc ) then
            ascR = RTL_WSTR_ASC
            if WideOperand_( c, a0asc, sd ) = false then return false
            aa.Push( cast( ulong, sd.kind ) ) : aa.Push( cast( ulong, sd.id ) )
        elseif ascU andalso (StrSwapKind_( c, c.info->TypeOf_( a0asc ), ascTag ) = 4) then
            if EmitStrTerm( c, aa, a0asc, true ) = false then return false
        else
            if StrDescriptorOf_( c, a0asc, sd ) = false then return false
            aa.Push( cast( ulong, sd.kind ) ) : aa.Push( cast( ulong, sd.id ) )
            if ascR = RTL_USTR_ASC then PushStrLen_( c, aa, -1 )
        end if
        if cp->count = 2 then
            dim as Tko.NodeId a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
            dim as MirValue nv = LowerExpr( c, a1 )
            if nv.kind = cast( ubyte, MV_NONE ) then return false
            '' The POSITION follows the pointer -- int64 on win64 and int32 on
            '' win32, measured on both halves of the family.
            dim as MirType pw = MT_I64
            if c.types->target.pointerBits = 32 then pw = MT_I32
            nv = CoerceTy( c, nv, pw, c.info->TypeOf_( a1 ))
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
    '' A USTRING TAKES ITS OWN PAIR, and the operand shape differs from both
    '' others: fb_UStrInstr( start, haystack, hlen, needle, nlen ) passes each
    '' descriptor WITH A LENGTH, where the narrow twin passes a bare one.
    '' Without this a ustring went down the NARROW half and handed an FBUSTRING
    '' to fb_StrInstr, which read it as a byte string.
    dim as boolean isU = IsUStringType( c, c.info->TypeOf_( sE ) )
    isU = isU orelse IsUStringType( c, c.info->TypeOf_( tE ) )
    '' ...AND A CONCATENATION WITH A USTRING TERM, which Check types STRING: 'instr( 1, u &
    '' "x", "x" )' went to the NARROW fb_StrInstr over the UTF-16 temporary and answered 0.
    '' Measured, fbc concatenates with fb_UStrConcat and calls fb_UStrInstr: 7.
    isU = isU orelse IsUStrChain_( c, sE ) orelse IsUStrChain_( c, tE )
    isU = isU orelse UdtCastIsUStr_( c, sE ) orelse UdtCastIsUStr_( c, tE )   '' a ustring cast (T50)
    '' ...AND A WIDE OPERAND BESIDE ONE IS CONVERTED, not refused. This declined, so
    '' 'print instr( u, wchr( c ) )' printed nothing and 'return instr( s, wchr( c ) ) <> 0'
    '' returned no value at all -- clang's "value doesn't match function result type",
    '' in every fbx MaskedEdit example. Measured, fbc takes the ustring pair and converts
    '' the wide side: 'vr = fb_WstrToUStr( W ); fb_UStrInstr( 1, &U, -1, vr, -1 )'.
    if isU andalso isWide then isWide = false

    '' OPERANDS RIGHT TO LEFT IN SOURCE ORDER. Measured: instr( G( 1 ), GStr( 2 ),
    '' GStr( 3 ) ) is 321 to fbc, instr( s, t ) and instr( s, any t ) 21, instrrev( s,
    '' t, G( 3 ) ) 321. The start is the FIRST source operand of instr and the LAST of
    '' instrrev, so it is lowered last for one and first for the other.
    dim as MirValue sd, td, stv
    dim as longint sTag = -1, tTag = -1
    dim as boolean startFirst = isRev andalso (startE <> Tko.NODE_NONE)
    dim as boolean startLast = (isRev = false) andalso (startE <> Tko.NODE_NONE)
    if startFirst then
        stv = LowerExpr( c, startE )
        if stv.kind = cast( ubyte, MV_NONE ) then return false
        stv = CoerceTy( c, stv, MT_I64, c.info->TypeOf_( startE ))
    end if
    if isWide then
        if WideOperand_( c, tE, td ) = false then return false
        if WideOperand_( c, sE, sd ) = false then return false
    else
        '' A NARROW OPERAND BESIDE A USTRING IS CONVERTED -- UStrParamArgTemp_. Measured,
        '' fbc passes 'instr( u, "cd" )' a UTF-16 literal and 'instr( u, nar )' a converted
        '' temporary; tiko handed fb_UStrInstr the narrow descriptor, and every narrow
        '' needle answered 0 -- ASCII or not (scratchpad uni/ui.bas).
        dim as Tko.TypeId ust = c.types->Builtin( Tko.TY_USTRING )
        '' A 'ustring * N' IS ITS BUFFER AND TAGGED LENGTH, as fbc passes it --
        '' 'fb_UStrInstr( 1, LF$0, &h8000000000000005, ... )'. It has no descriptor to
        '' ask for, and the statement declined.
        dim as longint ifk
        if isU andalso (StrTermFlavour_( c, tE ) = STF_WIDE) then
            if WideTermAsUStr_( c, tE, td ) = false then return false
        elseif isU andalso (StrSwapKind_( c, c.info->TypeOf_( tE ), ifk ) = 4) then
            td = LowerAddr( c, tE ) : tTag = ifk
            if td.kind = cast( ubyte, MV_NONE ) then return false
        elseif (isU = false) orelse (UStrParamArgTemp_( c, tE, ust, td ) = false) then
            if StrDescriptorOf_( c, tE, td ) = false then return false
        end if
        if isU andalso (StrTermFlavour_( c, sE ) = STF_WIDE) then
            if WideTermAsUStr_( c, sE, sd ) = false then return false
        elseif isU andalso (StrSwapKind_( c, c.info->TypeOf_( sE ), ifk ) = 4) then
            sd = LowerAddr( c, sE ) : sTag = ifk
            if sd.kind = cast( ubyte, MV_NONE ) then return false
        elseif (isU = false) orelse (UStrParamArgTemp_( c, sE, ust, sd ) = false) then
            if StrDescriptorOf_( c, sE, sd ) = false then return false
        end if
    end if
    if startLast then
        stv = LowerExpr( c, startE )
        if stv.kind = cast( ubyte, MV_NONE ) then return false
        stv = CoerceTy( c, stv, MT_I64, c.info->TypeOf_( startE ))
    end if

    dim as FB.Array( of ulong ) args
    if isRev then
        if isU then
            args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) ) : PushStrLen_( c, args, sTag )
            args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) ) : PushStrLen_( c, args, tTag )
        else
            args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) )
            args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) )
        end if
        if startE <> Tko.NODE_NONE then
            args.Push( cast( ulong, stv.kind ) ) : args.Push( cast( ulong, stv.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
        dim as RtlId rr = RTL_STR_INSTR_REV
        if isAny then rr = RTL_STR_INSTR_REV_ANY
        '' The 'any' forms over a ustring are fb_UStrInstrAny / fb_UStrInstrRevAny -- see rtl.bi.
        if isU then
            rr = iif( isAny, RTL_USTR_INSTR_REV_ANY, RTL_USTR_INSTR_REV )
        end if
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
        if isU then
            args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) ) : PushStrLen_( c, args, sTag )
            args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) ) : PushStrLen_( c, args, tTag )
        else
            args.Push( cast( ulong, sd.kind ) ) : args.Push( cast( ulong, sd.id ) )
            args.Push( cast( ulong, td.kind ) ) : args.Push( cast( ulong, td.id ) )
        end if
        dim as RtlId fr = RTL_STR_INSTR
        if isAny then fr = RTL_STR_INSTR_ANY
        if isU then
            fr = iif( isAny, RTL_USTR_INSTR_ANY, RTL_USTR_INSTR )
        end if
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
'' THE ADDRESS OF A UDT OPERAND, even when it has none.
''
'' An 'operator cast' is a MEMBER call and needs a receiver, so every caller here
'' asked LowerAddr -- which answers for a VARIABLE and not for an RVALUE. 'print
'' l - r' over a type declaring 'operator cast( ) as string', where 'operator -'
'' returns that type, had no address to take, the cast was never found, and the
'' PRINT DECLINED SILENTLY: fbc prints '-1' and a quoted 3 for the two statements
'' overload/tostring.bas writes, and tiko printed neither and said nothing.
''
'' The value goes into a temporary of the type's own size, which is what has to
'' happen to any UDT rvalue that must be addressed.
function UdtSelfAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    outv = LowerAddr( c, id )
    if outv.kind <> cast( ubyte, MV_NONE ) then return true
    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as long sz = SizeOfType( c, t )
    if sz <= 0 then return false
    dim as MirValue rv = LowerExpr( c, id )
    if rv.kind = cast( ubyte, MV_NONE ) then return false
    '' A HIDDEN RESULT IS ALREADY ADDRESSED: a user operator whose type has a destructor
    '' hands back its temporary's address, not the object -- see LowerUserBinaryOp_ --
    '' and a UDT value is never a pointer, so a pointer here is that address.
    if rv.ty = cast( ubyte, MT_PTR ) then
        outv = rv
        return true
    end if
    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot
    StoreThrough( c, tmp, rv )
    outv = tmp
    return true
end function

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
    dim as Tko.SymbolId cur
    dim as Tko.SymbolId want = Tko.SYMBOL_NONE
    dim as boolean wantRaw = false
    for pass as long = 0 to 1
        cur = cs
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
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
        if want <> Tko.SYMBOL_NONE then exit for
    next
    if want = Tko.SYMBOL_NONE then return false

    dim as MirValue self_
    if UdtSelfAddr_( c, id, self_ ) = false then return false
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

'' WHETHER THE STRING 'operator cast' UserCastToStr_ PICKS RETURNS A USTRING (T39). Its
'' result is then a UTF-16 descriptor, and every consumer that keyed on the ITEM's type
'' -- a UDT, so "narrow" -- printed its bytes as narrow text: an 'operator cast( ) as
'' ustring' returning "(4, 6)" printed '(', NUL, '4', NUL, ',', NUL and stopped, where
'' assigning it to a ustring first gave "(4, 6)". The same overload, chosen the same way.
function UdtCastIsUStr_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur
    for pass as long = 0 to 1
        cur = UdtMemberNamed_( c, t, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = cse->type_
            if rt <> Tko.TYPE_NONE then
                dim as longint zn
                if IsStringType( c, rt ) then return IsUStringType( c, rt )
                if StrSwapKind_( c, rt, zn ) = 1 then return false
            end if
            cur = cse->nextOverload
        wend
    next
    return false
end function

'' THE SAME QUESTION ON THE WIDE SIDE: the 'operator cast' that yields a WSTRING.
''
'' UserCastToStr_ answers for 'string' and 'zstring' only, and the wide half of the
'' rule was simply absent. Measured, fbc accepts
''
''     type B extends wstring
''         declare operator cast( ) byref as const wstring
''     end type
''     print cint( bv )        -- 123, through the cast
''
'' and tiko compared the OBJECT to zero instead: 'icmp ne [34 x i8] %t7, 0', which is
'' not an instruction, so the module was refused.
''
'' A BYREF WIDE RESULT IS ALREADY A 'uint16*', which is exactly what the wide VAL
'' entry points take -- there is no descriptor to borrow, and so no raw/temp
'' distinction of the kind the narrow path needs.
function UserCastToWstr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur
    for pass as long = 0 to 1
        cur = UdtMemberNamed_( c, t, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = c.types->Unqualify( cse->type_ )
            '' Through a REFERENCE or a POINTER: 'byref as wstring' is either spelling
            '' by the time it reaches here, and both mean the same buffer.
            if c.types->Kind( rt ) = Tko.TK_REFERENCE then
                rt = c.types->Unqualify( c.types->Inner( rt ) )
            elseif c.types->Kind( rt ) = Tko.TK_POINTER then
                rt = c.types->Unqualify( c.types->Inner( rt ) )
            end if
            if rt <> Tko.TYPE_NONE then
                if c.types->Kind( rt ) = Tko.TK_BUILTIN then
                    if c.types->BuiltinOf( rt ) = Tko.TY_WSTRING then
                        dim as MirValue self_
                        if UdtSelfAddr_( c, id, self_ ) = false then return false
                        outv = EmitMemberCall( c, cur, self_, MT_PTR )
                        return (outv.kind <> cast( ubyte, MV_NONE ))
                    end if
                end if
            end if
            cur = cse->nextOverload
        wend
    next
    return false
end function

'' A UDT OPERAND IN A NUMERIC EXPRESSION, through its own 'operator cast'.
''
'' Measured: 'result = u <> 0' over a type that declares 'operator cast( ) as integer'
'' and nothing else is
''
''     int64 vr$3 = _ZN3UDTcvu7INTEGEREv( &U$0 );
''     RESULT$0 = (boolean)((int64)-(vr$3 != 0ll) != 0ll);
''
'' -- the operator is called and the RESULT is compared. There is no 'operator <>' in
'' the type at all; the conversion is what makes the comparison legal. Every one of
'' them declined, because the arithmetic path asked the UDT for a value and a UDT has
'' none: structs/udt-comp-ops-1.bas and -2.bas are written entirely in this shape.
''
'' A POINTER-RETURNING 'operator cast'. UserCastToNum_ looks for a NUMERIC result,
'' because its other callers need a width to convert to; a CONDITION only has to
'' test the value, and an ARGUMENT whose parameter is a pointer wants exactly this
'' overload. Without it the pointer half of structs/bool_expr_cast emitted
'' 'icmp ne [8 x i8] %t9, 0' over the loaded aggregate, and structs/udt-ops-4
'' passed a TV to a 'TU ptr' parameter with no operand at all -- 'emit: ICE: an
'' operand with no kind'.
'' WHICH ONE is the shared rule, by the destination WANT -- symbols/structpick.bas PtrCastPick.
function UserCastToPtr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
      byval want as Tko.TypeId = Tko.TYPE_NONE ) as boolean

    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur = Tko.Check.PtrCastPick( *c.syms, *c.types, *c.names, t, want )
    if cur = Tko.SYMBOL_NONE then return false
    dim as MirValue self_
    if UdtSelfAddr_( c, id, self_ ) = false then return false
    outv = EmitMemberCall( c, cur, self_, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' THE OVERLOAD THAT YIELDS A NUMBER, exactly as UserCastToStr_ picks the one that
'' yields a string: 'operator cast' may be declared several times over different
'' targets and they hang off one symbol as a chain.
'' A UDT VALUE FLOWING INTO A SCALAR DESTINATION IS A CALL to its 'operator cast'.
''
'' Measured: 'dim as integer a = q' over a type declaring only 'operator cast( ) as
'' integer' emits '_ZN1Scvu7INTEGEREv( &Q )' and stores the RESULT. tiko-lang loaded the
'' AGGREGATE and sign-extended it -- the object's first eight bytes reinterpreted as the
'' number -- and that lowered, verified, and counted as a statement successfully
'' compiled. The STRING half of the same thing already worked, which is why it went
'' unnoticed.
''
'' Not for a UDT DESTINATION: that is a copy, or a conversion constructor, and neither
'' is this.
function UserConvToScalar_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval dstT as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if dstT = Tko.TYPE_NONE then return false
    dim as Tko.TypeId d = c.types->Unqualify( dstT )
    if c.types->Kind( d ) = Tko.TK_REFERENCE then
        d = c.types->Unqualify( c.types->Inner( d ) )
    end if
    if c.types->Kind( d ) = Tko.TK_UDT then return false
    dim as Tko.TypeId st = c.types->Unqualify( c.info->TypeOf_( id ) )
    if c.types->Kind( st ) <> Tko.TK_UDT then return false
    dim as MirType dm = LowerType( d, *c.types )
    if (dm = MT_VOID) orelse (dm = MT_AGG) then return false
    '' A POINTER DESTINATION WANTS THE POINTER-RETURNING OVERLOAD. UserCastToNum_
    '' takes only a BUILTIN or an ENUM result, so a type declaring 'operator cast(  )
    '' as TU ptr' matched nothing, this returned false, and the caller lowered the
    '' UDT itself -- which has no value -- and handed the call an operand with no
    '' kind. structs/udt-ops-4.bas passes exactly that, and the ICE names the
    '' enclosing procedure rather than the argument.
    if c.types->Kind( d ) = Tko.TK_POINTER then
        if UserCastToPtr_( c, id, outv, d ) then return true
    end if
    return UserCastToNum_( c, id, outv, d )
end function

'' THE 'operator cast' OVERLOAD THAT YIELDS A NUMBER, as a symbol. Split out of
'' UserCastToNum_ so that a caller which needs the RESULT TYPE -- WRITE, to pick its
'' per-width entry point -- asks the same question rather than repeating the rule
'' and drifting from it.
'' THE NUMERIC 'operator cast' -- the shared rule (symbols/structpick.bas NumericCastPick),
'' by what the value meets, which UserCastToNum_ calls too: the two used to be a first-match
'' walk and a ranked walk, so a caller called one overload and typed it as the other.
function UserCastNumOverload_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval want as Tko.TypeId = Tko.TYPE_NONE ) as Tko.SymbolId
    dim as Tko.SymbolId pick = Tko.Check.NumericCastPick( *c.syms, *c.types, *c.names, t, want )
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return Tko.SYMBOL_NONE
    dim as MirType m2 = LowerType( c.types->Unqualify( ps->type_ ), *c.types )
    if (m2 = MT_VOID) orelse (m2 = MT_AGG) then return Tko.SYMBOL_NONE
    return pick
end function

function UserCastToNum_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
      byval want as Tko.TypeId = Tko.TYPE_NONE ) as boolean

    dim as Tko.TypeId t = c.types->Unqualify( c.info->TypeOf_( id ) )
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId pick = UserCastNumOverload_( c, t, want )
    if pick = Tko.SYMBOL_NONE then return false
    dim as MirValue self_
    if UdtSelfAddr_( c, id, self_ ) = false then return false
    outv = EmitMemberCall( c, pick, self_, LowerType( c.types->Unqualify( c.syms->SymbolAt( pick )->type_ ), *c.types ) )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' A CAST THAT YIELDS A POINTER -- 'as zstring ptr', 'as wstring ptr' -- and not 'byref as', which is
'' the string itself. Measured on fbc-modern: beside 'as string' or 'byref as wstring', in either
'' order, print, an initialiser and '&' take the non-pointer cast; tiko took the first declared.
'' The string-cast walks look at pointer ones only when no other matched.
function CastYieldsPtr_( byref c as Ctx, byval sym as Tko.SymbolId ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if (s = 0) orelse (s->type_ = Tko.TYPE_NONE) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
        if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then return false
    end if
    return (c.types->Kind( c.types->Unqualify( s->type_ ) ) = Tko.TK_POINTER)
end function

'' (Moved from lowerwstr.bas at its 1500-line cap.)
'' THE 'operator cast' OVERLOAD THAT YIELDS A WSTRING, or nothing. Split out because
'' the CONCATENATION and COMPARISON paths have to know whether a term is wide BEFORE
'' anything is emitted for it, and the only way to find out is this walk: 'operator
'' cast' may be declared several times over different targets, so the chain is walked
'' rather than its head taken.
function WideCastOverload_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur
    for pass as long = 0 to 1
        cur = UdtMemberNamed_( c, t, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
            if cse = 0 then exit while
            if (pass = 0) andalso CastYieldsPtr_( c, cur ) then cur = cse->nextOverload : continue while   '' a pointer last
            dim as Tko.TypeId rt = cse->type_
            if rt <> Tko.TYPE_NONE then
                '' BYREF makes it a POINTER to the wstring, so both spellings count -- and a
                '' REFERENCE is the third, which 'byref as const wstring' resolves to. CONST
                '' is stripped with it: 'const wstring' is the same wstring.
                dim as Tko.TypeId inner = c.types->Unqualify( rt )
                if c.types->Kind( inner ) = Tko.TK_REFERENCE then
                    inner = c.types->Unqualify( c.types->Inner( inner ) )
                end if
                if c.types->Kind( inner ) = Tko.TK_POINTER then
                    inner = c.types->Unqualify( c.types->Inner( inner ) )
                end if
                if IsWideString_( c, inner ) then return cur
                if inner <> Tko.TYPE_NONE then
                    if c.types->Kind( inner ) = Tko.TK_BUILTIN then
                        if c.types->BuiltinOf( inner ) = Tko.TY_WSTRING then return cur
                    end if
                end if
            end if
            cur = cse->nextOverload
        wend
    next
    return Tko.SYMBOL_NONE
end function

'' WHETHER A UDT HAS A NARROW STRING CAST -- to string, zstring (byref or a pointer) or ustring. A
'' narrow context takes it over a wide one: measured, fbc's 'dim as string s = x' and 'ucase( x )'
'' over a type casting to string and to wstring call the STRING cast, in either declaration
'' order; tiko called the wstring one and transcoded it (TermIsWide_, lowerwstr.bas).
function HasNarrowStrCast_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur = UdtMemberNamed_( c, t, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = c.types->Unqualify( cs->type_ )
        if c.types->Kind( rt ) = Tko.TK_REFERENCE then rt = c.types->Unqualify( c.types->Inner( rt ) )
        if c.types->Kind( rt ) = Tko.TK_POINTER then rt = c.types->Unqualify( c.types->Inner( rt ) )
        if c.types->Kind( rt ) = Tko.TK_BUILTIN then
            select case c.types->BuiltinOf( rt )
            case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_USTRING : return true
            end select
        end if
        cur = cs->nextOverload
    wend
    return false
end function

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

    '' A LITERAL, or ADJACENT LITERALS, which are one literal: '"a" "1"' is folded
    '' before it reaches any call. The kind test alone missed the second spelling.
    dim as string lit
    dim as boolean isLit = false
    if c.ast->Kind( value ) = Tko.N_STRING_LIT then
        lit = StringLitText_( c, value )
        isLit = true
    elseif c.ast->Kind( value ) = Tko.N_STRCAT then
        isLit = StrCatText_( c, value, lit )
    end if
    if isLit then
        '' A USTRING DESTINATION TAKES A UTF-16 LITERAL, and its length is the tagged
        '' CHARACTER COUNT rather than the narrow family's len+1.
        if isU then
            '' Decoded from a UTF-8 source -- see PushSourceUnit_.
            dim as long lch = 0
            dim as long lgi = -1
            '' ...BUT A LITERAL IS READ FROM ITS SOURCE, as every other wide site reads one
            '' (WideLitGlobal_): the byte text above has its escapes applied, and
            '' WideFoldedText_ will not decode an ESCAPED literal's text, so the raw UTF-8 of
            '' '!"a<e-acute><CJK>b"' went in a byte per unit -- seven units where fbc has four,
            '' in a 'ustring * 16' only; a var-len ustring's route already read the source.
            if c.ast->Kind( value ) = Tko.N_STRING_LIT then lgi = WideLitGlobal_( c, value, lch )
            if lgi < 0 then lgi = WideFoldedText_( c, value, lit, lch )
            PushUStrLiteralArg( c, args, lgi, lch )
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

    '' A UTF-16 SOURCE INTO A NARROW DESTINATION TRANSCODES, through fb_UStrAssignToA: the
    '' destination's fill flag and then an INIT flag, -1 at a declaration. Measured:
    ''
    ''     dim z1 as zstring * 20 = u   fb_UStrAssignToA( Z1, 20, &U, -1, 0, -1 )
    ''     dim f1 as string * 8 = u     fb_UStrAssignToA( F1, <tagged 8>, &U, -1, -1, -1 )
    ''     z2 = u                       fb_UStrAssignToA( Z2, 20, &U, -1, 0, 0 )
    ''     z4 = u & "k"                 ... vr, -1 ...  (the chain's fb_UStrConcat result)
    ''     dim z5 as zstring * 20 = uf  ... UF, <tagged 7> ...  (a 'ustring * 8')
    ''
    '' fb_StrAssign copied the UTF-16 bytes as narrow ones and stopped at the first NUL:
    '' "UVW" came out "U", and a 'string * 8' kept "U", a NUL and "V". A ustring CHAIN is
    '' one too, though Check types it STRING -- see IsUStrChain_.
    if isU = false then
        dim as Tko.TypeId ust = c.info->TypeOf_( value )
        dim as boolean srcChainU = IsUStrChain_( c, value )
        if IsUStringType( c, ust ) orelse srcChainU then
            dim as longint usn
            dim as long usk = StrSwapKind_( c, ust, usn )
            dim as MirValue usv
            dim as longint usl = -1
            '' ADDRESSABLE ONLY: a chain or a call builds a descriptor instead, and a
            '' paren-less call's "address" is its code -- see NamesProc_.
            dim as boolean usAddr = (usk = 0)
            if usk = 4 then usAddr = true
            if srcChainU orelse NamesProc_( c, value ) then usAddr = false
            if usAddr then
                usv = LowerAddr( c, value )
                if usk = 4 then usl = usn
            end if
            if usv.kind = cast( ubyte, MV_NONE ) then
                if StrDescriptorOf_( c, value, usv ) = false then return false
                usl = -1
            end if
            args.Push( cast( ulong, usv.kind ) ) : args.Push( cast( ulong, usv.id ) )
            PushStrLen_( c, args, usl )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, tail ) )
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, iif( isInit, -1, 0 ) ) )
            return (EmitRtl( c, RTL_USTR_TO_A, args ).kind <> cast( ubyte, MV_NONE ))
        end if
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
#include once "mir/lowerstrcmp.bas"
#include once "mir/lowermath.bas"
#include once "mir/lowertup.bas"

end namespace

'' lowerwstr.bas -- WIDE STRINGS.
''
'' Split out of lowerstr.bas when that file passed the 1500-line lint cap, by subject:
'' the wide runtime is a separate family from the narrow one and shares none of its
'' shapes. A wstring VALUE is always a bare uint16* -- there is no descriptor type, and
'' no var-length wide string exists at all ('dim as wstring w' is fbc error 28) -- so
'' none of this needs a wide fb_StrInit and no wide local registers a scope cleanup.
''
'' The whole ABI was measured out of fbc's own C; tools/gen/check-rtl.sh holds every
'' signature.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Defined in lowerstr.bas; the narrow classifier the wide code needs for a mixed
'' operand.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

'' A WIDE STRING, and how many elements it holds. Returns 0 when the type is not one.
''
'' A 'wstring * N' is modelled as an ARRAY of the WSTRING builtin -- which is what it
'' is -- so the count comes off the array. There is no var-length wide string to
'' consider: 'dim as wstring w' is fbc error 28, so a wide value is always a bare
'' pointer to N elements and never a descriptor.
function WideStringElems( byref c as Ctx, byval t as Fbx.TypeId ) as long
    if t = Fbx.TYPE_NONE then return 0
    if c.types->Kind( t ) <> Fbx.TK_ARRAY then return 0
    dim as Fbx.TypeId el = c.types->Inner( t )
    if el = Fbx.TYPE_NONE then return 0
    if c.types->Kind( el ) <> Fbx.TK_BUILTIN then return 0
    if c.types->BuiltinOf( el ) <> Fbx.TY_WSTRING then return 0
    dim as long n = c.types->ElemCount( t )
    if n <= 0 then return 0
    return n
end function

'' Assignment INTO a wide string. Returns false when the target is not one.
''
'' Measured from fbc's own C, and the entry point depends on what the SOURCE is:
''
''     w = w2       fb_WstrAssign( (uint16*)W, 50ll, (uint16*)W2 )
''     w = "abc"    fb_WstrAssignFromA( (uint16*)W, 50ll, (void*)"abc", 4ll )
''     w = s        fb_WstrAssignFromA( (uint16*)W, 50ll, (void*)&S, -1ll )
''
'' The length is the declared ELEMENT COUNT, not bytes, and a narrow literal passes its
'' byte length INCLUDING the NUL while a descriptor passes -1. A plain "abc" is NOT
'' widened at compile time in a bare assignment -- that only happens where the target is
'' already a uint16*.
function LowerWideAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    dim as long n = WideStringElems( c, c.info->TypeOf_( target ) )
    if n = 0 then return false

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerWideAssignTo( c, dst, n, value )
end function

'' The same lowering addressed by DESTINATION rather than by target node, so that a
'' DIM INITIALISER -- which has a slot and no target expression -- reaches it too.
'' 'dim rt as wstring * 50 = trim( t )' was otherwise declining in a corpus file that
'' does it 814 times.
function LowerWideAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval value as Fbx.NodeId ) as boolean

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, n ) )

    '' 'w = w1 & w2' INTO A FIXED WSTRING is not one call: fbc assigns the first term
    '' and CONCAT-ASSIGNS the rest, because the destination already has storage.
    ''
    ''     fb_WstrAssign( W, 64ll, W1 )
    ''     fb_WstrConcatAssign( W, 64ll, W2 )
    ''
    '' fb_WstrConcat proper is only for a genuine rvalue, which needs a temporary
    '' whose lifetime fbx does not model yet.
    if c.ast->Kind( value ) = Fbx.N_BINARY then
        dim as Fbx.BinaryPayload ptr vb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, value )].data )]
        dim as Fbx.TokenKind vop = cast( Fbx.TokenKind, vb->op )
        if (vop = Fbx.TK_AMP) orelse (vop = Fbx.TK_PLUS) then
            if LowerWideAssignTo( c, dst, n, vb->lhs ) then
                if LowerWideConcatAssignTo( c, dst, n, vb->rhs ) then return true
                '' The first half is already emitted; declining now would leave the
                '' target holding only the left term, which is worse than saying so.
                SkipHere( c )
                return true
            end if
        end if
    end if

    '' A wide RVALUE -- trim( w ), mid( w, n ) -- is tried BEFORE the type test rather
    '' than inside it: these callees are unbound, so TypeOf_ on the call is empty and a
    '' type-first test would never reach them. The recogniser keys off the shape and
    '' the FIRST ARGUMENT's type instead.
    '' A WIDE source goes through fb_WstrAssign, whether it is a variable, a
    '' 'wstr( x )' temporary or a 'trim( ... )' result. This is tried BEFORE the type
    '' tests: those callees are unbound, so TypeOf_ on the call is empty and a
    '' type-first test would never reach them.
    dim as MirValue rv
    if WideOperand_( c, value, rv ) then
        args.Push( cast( ulong, rv.kind ) ) : args.Push( cast( ulong, rv.id ) )
        EmitRtl( c, RTL_WSTR_ASSIGN, args )
        return true
    end if

    dim as Fbx.TypeId st = c.info->TypeOf_( value )

    if c.ast->Kind( value ) = Fbx.N_STRING_LIT then
        dim as string lit = StringLitText_( c, value )
        args.Push( cast( ulong, MV_GLOBAL ) )
        args.Push( cast( ulong, c.m->AddStringLiteral( lit, *c.names ) ) )
        '' The literal's byte length INCLUDING its NUL, which is what fbc passes.
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, len( lit ) + 1 ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    if IsStringType( c, st ) then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    '' A ZSTRING * N source passes its own element count rather than -1.
    dim as longint zn
    if StrSwapKind_( c, st, zn ) = 1 then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, zn ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    return false
end function

'' 'w &= x' -- append to a fixed wide string in place. The entry point depends on
'' whether the source is wide or narrow, exactly as assignment does:
''
''     w &= w2      fb_WstrConcatAssign( W, 64ll, W2 )
''     w &= "lit"   fb_WstrConcatWA( W, (void*)"lit", 4ll ) then assign the temp
''
'' Only the WIDE source is lowered here; a narrow one needs the temporary's lifetime.
function LowerWideConcatAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval n as long, _
      byval value as Fbx.NodeId ) as boolean

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerWideConcatAssignTo( c, dst, n, value )
end function

'' As above, addressed by destination.
function LowerWideConcatAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval value as Fbx.NodeId ) as boolean

    if WideStringElems( c, c.info->TypeOf_( value ) ) = 0 then return false
    dim as MirValue src = LowerAddr( c, value )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, n ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    EmitRtl( c, RTL_WSTR_CONCAT_ASSIGN, args )
    return true
end function

'' Assignment FROM a wide string into a narrow one: 's = w' and 'z = w'.
''
''     fb_WstrAssignToA( (void*)&S, -1ll, (uint16*)W, 0 )
''     fb_WstrAssignToA( (void*)Z, 64ll, (uint16*)W, 0 )
''
'' The trailing int32 was 0 in every probe.
function LowerWideToNarrow _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    if WideStringElems( c, c.info->TypeOf_( value ) ) = 0 then return false

    dim as Fbx.TypeId dt = c.info->TypeOf_( target )
    dim as longint dn = -1
    if IsStringType( c, dt ) = false then
        if StrSwapKind_( c, dt, dn ) <> 1 then return false
    end if

    dim as MirValue dst = LowerAddr( c, target )
    dim as MirValue src = LowerAddr( c, value )
    if (dst.kind = cast( ubyte, MV_NONE )) orelse (src.kind = cast( ubyte, MV_NONE )) then
        return false
    end if

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_WSTR_ASSIGN_TOA, args )
    return true
end function



'' A WIDE OPERAND as a bare uint16* value, however it is spelled.
''
'' Three shapes, tried in order, because a wide string has no descriptor and every one
'' of them ends as the same kind of pointer:
''
''     an addressable wide variable      @w
''     'wstr( x )'                       the temporary it builds
''     'trim( ... )' and its family      the temporary the runtime returns
''
'' Only the first was accepted before, so 'dim wr as wstring * 50 = trim( wstr(t) )'
'' declined -- 2,496 statements across four corpus files, all of them this one shape.
function WideOperand_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if WideStringElems( c, c.info->TypeOf_( id ) ) > 0 then
        outv = LowerAddr( c, id )
        if outv.kind <> cast( ubyte, MV_NONE ) then return true
    end if
    if LowerWstrOf( c, id, outv ) then return true
    if LowerWideRvalue( c, id, outv ) then return true
    return false
end function


'' THE WIDE SUBSTRING AND TRIM FAMILY, as an RVALUE.
''
'' Each of these returns a bare uint16* -- there is no descriptor, which is what makes
'' them lowerable now while their narrow counterparts still are not. fbc releases the
'' result with fb_WstrDelete; fbx does not model that lifetime yet, so EVERY CALL HERE
'' LEAKS ONE TEMPORARY. That is a real defect, recorded rather than hidden, and the
'' alternative is emitting nothing at all for 2,442 corpus statements.
''
'' The mapping was read off fbc's C, not assumed from the narrow forms, and the shapes
'' are NOT uniform:
''
''     trim( w )          fb_WstrTrim( W )
''     trim( w, w2 )      fb_WstrTrimEx( W, W2 )        strip that SUBSTRING
''     trim( w, any w2 )  fb_WstrTrimAny( W, W2 )       strip any of those CHARACTERS
''     mid( w, n )        fb_WstrMid( W, N, -1ll )      no length is -1, not 0
''     ucase( w )         fb_WstrUcase2( W, 0 )         trailing arg is the mode
''
'' 'any' reaches here as a unary KW_ANY wrapper around the second argument.
function LowerWideRvalue _
    ( byref c as Ctx, byval value as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( value ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, value )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )
    if (cp->count < 1) orelse (cp->count > 3) then return false

    '' The FIRST argument decides: these names are all overloaded on narrow strings
    '' too, and only the wide overload is lowered here.
    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, c.ast->children[cp->first] )
    dim as MirValue s0
    if WideOperand_( c, a0, s0 ) = false then return false

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

    dim as RtlId r = RTL_NONE
    dim as boolean secondIsWide = false      '' else it is a count
    select case nm
    case "trim", "ltrim", "rtrim"
        secondIsWide = true
        if cp->count = 1 then
            select case nm
            case "trim"  : r = RTL_WSTR_TRIM
            case "ltrim" : r = RTL_WSTR_LTRIM
            case else    : r = RTL_WSTR_RTRIM
            end select
        elseif cp->count = 2 then
            if isAny then
                select case nm
                case "trim"  : r = RTL_WSTR_TRIM_ANY
                case "ltrim" : r = RTL_WSTR_LTRIM_ANY
                case else    : r = RTL_WSTR_RTRIM_ANY
                end select
            else
                select case nm
                case "trim"  : r = RTL_WSTR_TRIM_EX
                case "ltrim" : r = RTL_WSTR_LTRIM_EX
                case else    : r = RTL_WSTR_RTRIM_EX
                end select
            end if
        else
            return false
        end if
    case "left"
        if cp->count <> 2 then return false
        r = RTL_WSTR_LEFT
    case "right"
        if cp->count <> 2 then return false
        r = RTL_WSTR_RIGHT
    case "mid"
        if (cp->count < 2) orelse (cp->count > 3) then return false
        r = RTL_WSTR_MID
    case "ucase"
        if cp->count <> 1 then return false
        r = RTL_WSTR_UCASE
    case "lcase"
        if cp->count <> 1 then return false
        r = RTL_WSTR_LCASE
    case else
        return false
    end select
    if isAny andalso (secondIsWide = false) then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, s0.kind ) ) : args.Push( cast( ulong, s0.id ) )

    if a1 <> Fbx.NODE_NONE then
        if secondIsWide then
            dim as MirValue s1
            if WideOperand_( c, a1, s1 ) = false then return false
            args.Push( cast( ulong, s1.kind ) ) : args.Push( cast( ulong, s1.id ) )
        else
            '' left/right/mid take a 64-bit COUNT; the source expression is whatever
            '' integer width the program used, so it is widened here.
            dim as MirValue n1 = LowerExpr( c, a1 )
            if n1.kind = cast( ubyte, MV_NONE ) then return false
            n1 = Coerce( c, n1, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
        end if
    end if

    if nm = "mid" then
        '' A 'mid' WITHOUT a length passes -1, not 0 -- measured, and 0 would silently
        '' produce an empty string instead of the rest of the source.
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
    elseif (r = RTL_WSTR_UCASE) orelse (r = RTL_WSTR_LCASE) then
        '' The trailing int32 is the case-mode; fbc passed 0 in every probe.
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if

    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


end namespace

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
            if LowerWideAssign( c, target, vb->lhs ) then
                if LowerWideConcatAssign( c, target, n, vb->rhs ) then return true
                '' The first half is already emitted; declining now would leave the
                '' target holding only the left term, which is worse than saying so.
                SkipHere( c )
                return true
            end if
        end if
    end if

    '' A WIDE source goes through fb_WstrAssign; anything narrow through FromA.
    dim as Fbx.TypeId st = c.info->TypeOf_( value )
    if WideStringElems( c, st ) > 0 then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
        EmitRtl( c, RTL_WSTR_ASSIGN, args )
        return true
    end if

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

    if WideStringElems( c, c.info->TypeOf_( value ) ) = 0 then return false
    dim as MirValue dst = LowerAddr( c, target )
    dim as MirValue src = LowerAddr( c, value )
    if (dst.kind = cast( ubyte, MV_NONE )) orelse (src.kind = cast( ubyte, MV_NONE )) then
        return false
    end if
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


end namespace

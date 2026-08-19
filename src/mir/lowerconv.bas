'' lowerconv.bas -- the conversion intrinsics.
''
'' CBYTE, CUBYTE, CSHORT, CUSHORT, CLNG, CULNG, CINT, CUINT, CLNGINT, CULNGINT, CSNG,
'' CDBL, CBOOL, CSIGN, CUNSG, CAST and CPTR. They are KEYWORDS, not procedures, so
'' nothing is called: each one lowers to the coercion its result type asks for.
''
'' Check has already computed that result type, measured against fbc in
'' tests/types/expected/fbc-conv.txt, so this file decides only HOW the value gets
'' there and never WHAT it becomes.
''
'' Without this the intrinsics typed and then lowered to nothing, while the call around
'' them still emitted -- 'call void P(_)', an undef where a boolean belonged, with the
'' statement counted as fully lowered. That is the third time this shape has appeared;
'' see docs/internals/phase-6-pointers.md.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' The intrinsic's spelling, or "" when this call is not one of them.
private function ConvName_ _
    ( byref c as Ctx, byval cp as Fbx.ListPayload ptr ) as string

    if cp->target = Fbx.NODE_NONE then return ""
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return ""
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )
    select case nm
    case "cbyte", "cubyte", "cshort", "cushort", "clng", "culng", "cint", "cuint", _
         "clngint", "culngint", "csng", "cdbl", "cbool", "csign", "cunsg", _
         "cast", "cptr"
        return nm
    end select
    return ""
end function

function IsConvIntrinsic _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as boolean

    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    return len( ConvName_( c, cp ) ) > 0
end function

function LowerConvIntrinsic _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue

    dim as MirValue v
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as string nm = ConvName_( c, cp )
    if len( nm ) = 0 then return v

    '' CAST and CPTR take the TYPE first, so the value is the second argument.
    dim as long vi = 0
    if (nm = "cast") orelse (nm = "cptr") then
        if cp->count <> 2 then return v
        vi = 1
    else
        if cp->count <> 1 then return v
    end if

    dim as Fbx.NodeId arg = cast( Fbx.NodeId, c.ast->children[cp->first + vi] )
    dim as MirValue x = LowerExpr( c, arg )
    if x.kind = cast( ubyte, MV_NONE ) then return v

    '' CBOOL is a COMPARISON, not a narrowing: fbc emits '(boolean)(V != 0)', so
    '' cbool( 256 ) is true where a truncation to one byte would make it false.
    if nm = "cbool" then
        dim as MirInst ins
        ins.op = cast( ushort, iif( IsFloatTy( cast( MirType, x.ty ) ), _
                                    M_FCMP_NE, M_ICMP_NE ) )
        ins.ty = cast( ubyte, MT_I8 )
        ins.a = x
        if IsFloatTy( cast( MirType, x.ty ) ) then
            ins.b = ConstFloat( c, 0.0, cast( MirType, x.ty ) )
        else
            ins.b = ConstInt( c, 0, cast( MirType, x.ty ) )
        end if
        return Emit( c, ins )
    end if

    '' Everything else is the coercion its result type asks for. A pointer result and a
    '' pointer argument differ only in what the type system calls them.
    dim as MirType want = mt
    if want = MT_VOID then want = cast( MirType, x.ty )
    if want = cast( MirType, x.ty ) then return x
    if (want = MT_PTR) orelse (x.ty = cast( ubyte, MT_PTR )) then
        dim as MirInst bc
        bc.op = cast( ushort, M_BITCAST )
        bc.ty = cast( ubyte, want )
        bc.a = x
        return Emit( c, bc )
    end if
    return Coerce( c, x, want )
end function

end namespace

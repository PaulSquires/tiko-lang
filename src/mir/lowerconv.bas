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

namespace Tko.Mir

'' The intrinsic's spelling, or "" when this call is not one of them.
private function ConvName_ _
    ( byref c as Ctx, byval cp as Tko.ListPayload ptr ) as string

    if cp->target = Tko.NODE_NONE then return ""
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return ""
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    select case nm
    case "cbyte", "cubyte", "cshort", "cushort", "clng", "culng", "cint", "cuint", _
         "clngint", "culngint", "csng", "cdbl", "cbool", "csign", "cunsg", _
         "cast", "cptr"
        return nm
    end select
    return ""
end function

function IsConvIntrinsic _
    ( byref c as Ctx, byval id as Tko.NodeId ) as boolean

    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    return len( ConvName_( c, cp ) ) > 0
end function

'' THE OPERAND OF A STRING-TO-STRING 'cast' OR 'cptr', or NODE_NONE.
''
'' 'cast( string, s )' converts nothing -- measured, fbc emits the ordinary byval-string
'' temporary and nothing else: 'fb_StrAssign( &TMP$2$1, -1ll, S$1, -1ll, 0 );
'' CONST_CAST_STRING1( &TMP$2$1 );'. So every string path can look straight through it,
'' and without that 'takes( cast(string, s) )', 'dim t = cast(string, s)',
'' 'y = cast(string, x)' and 'print cast(string, s)' all declined.
''
'' A byref parameter's type is a REFERENCE and a reference is transparent to this too.
function StrIdentityConvOperand_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.NodeId

    if id = Tko.NODE_NONE then return Tko.NODE_NONE
    if c.ast->Kind( id ) <> Tko.N_CALL then return Tko.NODE_NONE
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as string nm = ConvName_( c, cp )
    if (nm <> "cast") andalso (nm <> "cptr") then return Tko.NODE_NONE
    if cp->count <> 2 then return Tko.NODE_NONE
    dim as Tko.NodeId op = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
    '' UNQUALIFIED on both sides. IsStringType tests the BUILTIN kind and a 'const
    '' string' is a distinct qualified entry, so 'cast( string, x )' over a
    '' 'dim x as const string' answered 'not a string' and the identity was missed --
    '' which is the whole of what const-discard.bas writes.
    '' THE TARGET TYPE COMES FROM THE TYPEREF, not from the call's own type: Check
    '' computes none for 'cast( string, x )' -- a string result is not a value it
    '' models here -- so testing the call answered TYPE_NONE and the identity was never
    '' recognised at all.
    dim as Tko.TypeId rt2 = c.info->TypeOf_( id )
    if rt2 = Tko.TYPE_NONE then
        dim as Tko.NodeId tn2 = cast( Tko.NodeId, c.ast->children[cp->first] )
        if c.ast->Kind( tn2 ) = Tko.N_TYPEREF then rt2 = c.info->TypeOf_( tn2 )
    end if
    if IsStringType( c, c.types->Unqualify( rt2 ) ) = false then
        return Tko.NODE_NONE
    end if
    dim as Tko.TypeId ot = c.types->Unqualify( c.info->TypeOf_( op ) )
    if c.types->Kind( ot ) = Tko.TK_REFERENCE then
        ot = c.types->Unqualify( c.types->Inner( ot ) )
    end if
    if IsStringType( c, ot ) = false then return Tko.NODE_NONE
    return op
end function
function LowerConvIntrinsic _
    ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType ) as MirValue

    dim as MirValue v
    dim as Tko.ListPayload ptr cp = _
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

    dim as Tko.NodeId arg = cast( Tko.NodeId, c.ast->children[cp->first + vi] )

    '' A STRING OPERAND IS PARSED, NOT COERCED. There was no case for one at all, so
    '' 'm = cuint( x )' over a string LOADED THE DESCRIPTOR'S FIRST EIGHT BYTES -- the
    '' char* data pointer -- and zero-extended THAT into the integer. A heap address
    '' where 37 belonged, verifier clean, 0 statements not lowered. A string TEMPORARY
    '' -- 'cuint( left( x, 1 ) )' -- has no value to load, so that one declined instead:
    '' the same hole, showing on two sides.
    ''
    '' Measured, and the entry point is chosen by the RESULT'S width and signedness
    '' rather than by the intrinsic's name:
    ''
    ''     cbyte/cubyte/cshort/cushort/clng/culng   fb_VALINT  / fb_VALUINT
    ''     cint/clngint  and their unsigned twins   fb_VALLNG  / fb_VALULNG
    ''     csng/cdbl                                fb_VAL
    ''
    '' -- so 'clng( x )' is 'int32 vr = fb_VALINT( &X$0 )' and 'cint( x )' is
    '' 'int64 vr = fb_VALLNG( &X$0 )'. Run, all thirteen print 37.
    ''
    '' CAST and CPTR are NOT in this: 'cast( string, s )' is the identity on a string
    '' and has nothing to parse.
    dim as boolean isCastLike = (nm = "cast") orelse (nm = "cptr")
    if isCastLike = false then
        dim as Tko.TypeId at2 = c.info->TypeOf_( arg )

        '' A WIDE OPERAND HAS ITS OWN FIVE ENTRY POINTS, taking a bare uint16* rather
        '' than a descriptor -- the same five 'valint( w )' already uses, and chosen by
        '' the RESULT's width and signedness exactly as the narrow rows below are.
        '' Measured, over a 'wstring * 8' holding "789":
        ''
        ''     cbyte/cshort/clng      fb_WstrValInt      cubyte/cushort/culng  ...UInt
        ''     cint/clngint           fb_WstrValLng      cuint/culngint        ...ULng
        ''     csng/cdbl              fb_WstrVal
        ''
        '' Without them a wide argument fell past this whole block to the ordinary
        '' coercion, which read the STRING AS A NUMBER: 'cdbl( w )' emitted a bare
        '' 'sitofp' over the buffer and 'cdbl( wstr( "789" ) )' a 'bitcast' of the
        '' literal's ADDRESS. Verifier clean, 0 statements not lowered, and the answer
        '' was a pointer. This is the same hole the narrow rows below were written to
        '' close, left open on the wide side.
        if IsWideString_( c, at2 ) then
            dim as MirValue wd
            if WideOperand_( c, arg, wd ) = false then return v
            if wd.kind = cast( ubyte, MV_NONE ) then return v
            dim as FB.Array( of ulong ) wargs
            wargs.Push( cast( ulong, wd.kind ) ) : wargs.Push( cast( ulong, wd.id ) )
            dim as long ww = RTL_WSTR_VALINT
            dim as MirType wmt = MT_I32
            select case nm
            '' CBOOL PARSES THE WORD, not a number: fbc has an entry point of its own
            '' for it and 'cbool( "true" )' is TRUE through it. Reaching VALINT
            '' instead parsed "true" as a NUMBER, got 0, and answered false.
            case "cbool"
                ww = RTL_WSTR_VAL_BOOL : wmt = MT_I8
            case "csng", "cdbl"
                ww = RTL_WSTR_VAL : wmt = MT_F64
            case "cint", "clngint"
                ww = RTL_WSTR_VALLNG : wmt = MT_I64
            case "cuint", "culngint"
                ww = RTL_WSTR_VALULNG : wmt = MT_I64
            case "cubyte", "cushort", "culng"
                ww = RTL_WSTR_VALUINT : wmt = MT_I32
            case else
                ww = RTL_WSTR_VALINT : wmt = MT_I32
            end select
            dim as MirValue wr = EmitRtl( c, ww, wargs )
            if wr.kind = cast( ubyte, MV_NONE ) then return v
            dim as MirType wwant = mt
            if wwant = MT_VOID then wwant = wmt
            dim as boolean wU = (ww = RTL_WSTR_VALULNG) orelse (ww = RTL_WSTR_VALUINT)
            return Coerce( c, wr, wwant, wU, _
                           IsUnsignedType( c, c.info->TypeOf_( id ) ) )
        end if

        dim as boolean argIsStr = IsStringType( c, at2 )
        if argIsStr then
            dim as MirValue sd
            if StrDescriptorOf_( c, arg, sd ) = false then return v
            if sd.kind = cast( ubyte, MV_NONE ) then return v
            dim as FB.Array( of ulong ) vargs
            vargs.Push( cast( ulong, sd.kind ) ) : vargs.Push( cast( ulong, sd.id ) )
            dim as long vw = RTL_VAL
            dim as MirType vmt = MT_F64
            select case nm
            '' The narrow twin of the same rule -- see the wide row above.
            case "cbool"
                vw = RTL_VAL_BOOL : vmt = MT_I8
            case "csng", "cdbl"
                vw = RTL_VAL : vmt = MT_F64
            case "cint", "clngint"
                vw = RTL_VALLNG : vmt = MT_I64
            case "cuint", "culngint"
                vw = RTL_VALULNG : vmt = MT_I64
            case "cubyte", "cushort", "culng"
                vw = RTL_VALUINT : vmt = MT_I32
            case else
                vw = RTL_VALINT : vmt = MT_I32
            end select
            dim as MirValue vr2 = EmitRtl( c, vw, vargs )
            if vr2.kind = cast( ubyte, MV_NONE ) then return v
            dim as MirType vwant = mt
            if vwant = MT_VOID then vwant = vmt
            dim as boolean vU = (vw = RTL_VALULNG) orelse (vw = RTL_VALUINT)
            return Coerce( c, vr2, vwant, vU, IsUnsignedType( c, c.info->TypeOf_( id ) ) )
        end if
    end if

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
    '' THE CONVERSION'S OWN SIGNEDNESS. Only CUINT and CULNGINT name an unsigned
    '' 64-bit target, and only there does fbc call fb_D2UL rather than the signed
    '' helper.
    dim as boolean dstU = (nm = "cuint") orelse (nm = "culngint") orelse _
                          (nm = "culng") orelse (nm = "cushort") orelse _
                          (nm = "cubyte")
    if (nm = "cast") orelse (nm = "cptr") then
        dstU = IsUnsignedType( c, c.info->TypeOf_( id ) )
    end if
    return Coerce( c, x, want, IsUnsignedType( c, c.info->TypeOf_( arg ) ), dstU )
end function

end namespace

'' lowerstr.bas -- string lowering and the runtime call helper.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The division
'' is by subject rather than by size: everything here is about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Local to this file: the two halves of concatenation lowering call each other.
declare function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Fbx.NodeId ) as boolean
declare sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
declare sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
declare function StringLitText_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as string
declare function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean
declare sub FlattenConcat _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )


'' 'a = b + a'. The chain is built in an anonymous FBSTRING slot and then assigned.
''
'' The temporary is NEVER deleted here, and that is measured rather than assumed: fbc
'' emits a plain 'FBSTRING TMP;' local and no fb_StrDelete for it. The runtime frees
'' the temp descriptor when it is handed to fb_StrAssign, so deleting it as well would
'' be a double free.
private function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean

    if terms.Count < 2 then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    '' fb_StrConcat takes the destination descriptor first, then the two operands.
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) )
    args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[0] ) ) = false then return false
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[1] ) ) = false then return false
    dim as MirValue acc = EmitRtl( c, RTL_STR_CONCAT, args )

    '' Any further terms concatenate onto the temporary in place.
    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Fbx.NodeId, terms[i] ) ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) )
        more.Push( 0 )
        EmitRtl( c, RTL_STR_CONCAT_ASSIGN, more )
    next

    dim as FB.Array( of ulong ) fin
    PushStrArg( fin, dst )
    PushStrArg( fin, tmp )
    fin.Push( cast( ulong, MV_CONST_INT ) )
    fin.Push( 0 )
    EmitRtl( c, RTL_STR_ASSIGN, fin )
    return true
end function

'' The text of a string literal. The parser records the span rather than the decoded
'' bytes, so it is read back out of the source buffer here.
function StringLitText_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as string

    if c.ast->Kind( id ) <> Fbx.N_STRING_LIT then return ""
    dim as Fbx.LiteralPayload ptr lp = _
        @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->strLength <= 0 then return ""
    dim as Fbx.DecodedLoc d = c.srcMgr->Decode( c.ast->Loc( id ) )
    dim as Fbx.SourceFile ptr f = c.srcMgr->FileAt( d.file )
    if f = 0 then return ""
    if (lp->strOffset + lp->strLength) > f->text.Count then return ""
    dim as string r = space( lp->strLength )
    for i as long = 0 to lp->strLength - 1
        r[i] = f->text[lp->strOffset + i]
    next
    return r
end function

'' ------------------------------------------------------------------ runtime

'' A call to a runtime function, by table id. Nothing here spells a runtime name: the
'' inventory is the only place that does (docs/plan/11 section 3).
function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue

    dim as MirValue v
    dim as Fbx.InternId nm = c.names->GetString( RtlSymbol( r ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, RtlReturn( r ) )
        decl->isDefinition = false
        decl->paramCount = RtlArity( r )
        fidx = c.m->functions.Count - 1
    end if

    dim as long first = c.m->argPool.Count \ 2
    for i as long = 0 to args.Count - 1
        c.m->argPool.Push( args[i] )
    next

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL_RTL )
    ins.ty = cast( ubyte, RtlReturn( r ) )
    ins.first = first
    ins.count = args.Count \ 2
    ins.callee = fidx
    return Emit( c, ins )
end function

'' The (pointer, length) pair the string runtime takes. A var-length string is its
'' DESCRIPTOR's address with a length of -1; the runtime reads the length from the
'' descriptor itself.
'' A LITERAL is passed as its own bytes with a real length -- strlen PLUS ONE, for
'' the terminator: fbc emits 2 for "x" and 6 for "hello". Getting that off by one
'' truncates or overruns, and neither shows up near the cause.
sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
    args.Push( cast( ulong, MV_GLOBAL ) )
    args.Push( cast( ulong, gidx ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, nbytes + 1 ) )
end sub

sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
    args.Push( cast( ulong, addr.kind ) )
    args.Push( cast( ulong, addr.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( ulongint, -1 ) ) )
end sub


function IsStringType _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    dim as Fbx.BuiltinType b = c.types->BuiltinOf( t )
    return (b = Fbx.TY_STRING) orelse (b = Fbx.TY_USTRING)
end function

'' 'a = b' and 'a = a + b' between var-length strings. Returns false when this is not
'' a string assignment, so the caller falls back to an ordinary store.
function LowerStringAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    if IsStringType( c, c.info->TypeOf_( target ) ) = false then return false
    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    '' A '+' chain is flattened and emitted as ONE assign followed by concat-assigns,
    '' which is exactly what fbc does: 'a = b + c' is fb_StrAssign(a,b) then
    '' fb_StrConcatAssign(a,c), with no temporary at all. A temporary is needed only
    '' when the DESTINATION appears on the right -- 'a = b + a' -- because building in
    '' place would overwrite the source before it is read. That shape is not lowered.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )

    '' If the destination is read AFTER it would be written, the chain cannot be built
    '' in place: 'a = b + a' would overwrite a before reading it. fbc builds such a
    '' chain in a temporary and assigns from that.
    dim as boolean needsTemp = false
    for i as long = 1 to terms.Count - 1
        if SameLValue( c, target, cast( Fbx.NodeId, terms[i] ) ) then needsTemp = true
    next
    if needsTemp then return LowerConcatViaTemp( c, dst, terms )

    '' The first term is assigned, every later one concatenated onto it. When the
    '' destination IS the first term, the assign is a self-assignment and is skipped.
    for i as long = 0 to terms.Count - 1
        dim as Fbx.NodeId term = cast( Fbx.NodeId, terms[i] )
        if (i = 0) andalso SameLValue( c, target, term ) then continue for
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, term ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        if i = 0 then
            EmitRtl( c, RTL_STR_ASSIGN, args )
        else
            EmitRtl( c, RTL_STR_CONCAT_ASSIGN, args )
        end if
    next
    return true
end function

'' The (pointer, length) pair for one term of a concatenation.
function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Fbx.NodeId ) as boolean

    if c.ast->Kind( term ) = Fbx.N_STRING_LIT then
        '' Named litText, not text: 'Text' is a namespace and FreeBASIC is
        '' case-insensitive, so a local called text shadows it.
        dim as string litText = StringLitText_( c, term )
        PushStrLiteralArg( args, c.m->AddStringLiteral( litText, *c.names ), _
                           len( litText ) )
        return true
    end if
    if IsStringType( c, c.info->TypeOf_( term ) ) = false then return false
    dim as MirValue src = LowerAddr( c, term )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    PushStrArg( args, src )
    return true
end function

'' Flatten a left-leaning '+' chain into its terms, in source order.
sub FlattenConcat _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )

    if id = Fbx.NODE_NONE then return
    if c.ast->Kind( id ) = Fbx.N_BINARY then
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        if cast( Fbx.TokenKind, bp->op ) = Fbx.TK_PLUS then
            FlattenConcat( c, bp->lhs, outp )
            FlattenConcat( c, bp->rhs, outp )
            return
        end if
    end if
    outp.Push( cast( ulong, id ) )
end sub

'' Whether two expressions name the same storage. Only the simple cases are needed:
'' anything else falls back to the general path rather than guessing.
function SameLValue _
    ( byref c as Ctx, byval a as Fbx.NodeId, byval b as Fbx.NodeId ) as boolean
    if (a = Fbx.NODE_NONE) orelse (b = Fbx.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Fbx.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function


end namespace

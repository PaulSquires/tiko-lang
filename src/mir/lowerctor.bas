'' lowerctor.bas -- constructor selection for a DIM initialiser.
''
'' Split out of lower.bas, which is at its size limit.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx


'' 'dim as T x = T( 5 )'. The initialiser parses as a CALL on the type's name, so it
'' is recognised by the callee naming the variable's own UDT rather than by any
'' special syntax. Returns false when this is not a constructor call.
function LowerCtorInit _
    ( byref c as Ctx, byval slot as long, byval t as Fbx.TypeId, _
      byval init_ as Fbx.NodeId ) as boolean

    if init_ = Fbx.NODE_NONE then return false
    if c.ast->Kind( init_ ) <> Fbx.N_CALL then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false

    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init_ )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if ip->name <> c.types->NameOf( t ) then return false

    dim as Fbx.SymbolId ctors = StructorOf( c, t, "__ctor" )
    if ctors = Fbx.SYMBOL_NONE then return false

    '' Argument VALUES first, then the pick: the types are needed to choose, and the
    '' values must be evaluated in source order regardless of which overload wins.
    dim as FB.Array( of ulong ) argT
    dim as FB.Array( of ulong ) argKind
    dim as FB.Array( of ulong ) argId
    for i as long = 0 to cp->count - 1
        dim as Fbx.NodeId a = cast( Fbx.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue av = LowerExpr( c, a )
        argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
        argKind.Push( cast( ulong, av.kind ) )
        argId.Push( cast( ulong, av.id ) )
    next

    dim as Fbx.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, ps->payload )
    if pn = Fbx.NODE_NONE then return false

    '' Arguments are coerced to the chosen overload's PARAMETER types: MIR has no
    '' implicit conversions, and the overload was selected knowing a conversion would
    '' be needed, so it has to be written down.
    dim as Fbx.StmtPayload ptr cpp = StmtOf( c, pn )
    dim as long ai2 = 0
    for i as long = 0 to cpp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
        if ai2 >= argT.Count then exit for
        dim as MirValue av
        av.kind = cast( ubyte, argKind[ai2] )
        av.ty = cast( ubyte, LowerType( cast( Fbx.TypeId, argT[ai2] ), *c.types ) )
        av.id = argId[ai2]
        dim as Fbx.StmtPayload ptr sp3 = StmtOf( c, prm )
        dim as MirValue cv = Coerce( c, av, _
            LowerType( c.info->TypeOf_( sp3->a ), *c.types ) )
        argKind[ai2] = cv.kind
        argId[ai2] = cv.id
        ai2 += 1
    next

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, MV_LOCAL ) )
    c.m->argPool.Push( cast( ulong, slot ) )
    for i as long = 0 to argT.Count - 1
        c.m->argPool.Push( argKind[i] )
        c.m->argPool.Push( argId[i] )
    next

    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, MT_VOID )
        decl->isDefinition = false
        decl->paramCount = argT.Count + 1
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = argT.Count + 1
    ins.callee = fidx
    Emit( c, ins )
    return true
end function

end namespace

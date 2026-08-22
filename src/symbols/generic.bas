'' generic.bas -- instantiating a generic TYPE.
''
'' Split out of resolve.bas, which is at its size limit.

#include once "symbols/resolvectx.bi"
#include once "symbols/check.bi"

namespace Fbx.Resolve

'' INSTANTIATE A GENERIC TYPE -- 'Box( of long )'.
''
'' Monomorphisation, the same thing fbc does: one concrete UDT per (generic, argument
'' list), built in the GLOBAL scope and cached under a structural key. fbc emits every
'' instantiation 'static' into the module that needs it, so there is nothing to share
'' across translation units and nothing lost by doing it per-module.
''
'' This is the TYPE half only. Members are not instantiated -- their bodies need a
'' token replay, which is a separate job -- so a method call on one still declines.
'' What this fixes is the FIELDS: every instantiation used to resolve to the generic's
'' own fieldless UDT of SIZE ZERO, so 'b.value = 1' had nowhere to store and 'dim as
'' Array( of Decimal ) a' reserved nothing.
''
'' Built on the same three steps as the TUPLE desugaring above -- declare a symbol in
'' SCOPE_GLOBAL under a structural name, open its TYPE scope, declare the fields with
'' resolved types -- because it is the same problem: a type that the source names
'' structurally rather than by a declaration of its own.
function InstantiateGeneric_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr, _
      byval scope_ as Fbx.ScopeId ) as Fbx.TypeId

    '' The generic itself. Not through LookupTyped's type filter alone: it has to be a
    '' UDT whose declaration carries a parameter list, or 'Foo( 3 )' on an ordinary
    '' type would be read as an instantiation.
    dim as Fbx.SymbolId gsid = c.syms->LookupTyped( scope_, sp->name, true )
    dim as Fbx.Symbol ptr gs = c.syms->SymbolAt( gsid )
    if gs = 0 then return Fbx.TYPE_NONE
    if gs->kind <> cast( ubyte, Fbx.SYM_UDT ) then return Fbx.TYPE_NONE
    dim as Fbx.NodeId gn = cast( Fbx.NodeId, gs->payload )
    if gn = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( gn ) <> Fbx.N_TYPE then return Fbx.TYPE_NONE
    dim as Fbx.StmtPayload ptr gp = StmtOf( c, gn )
    if gp->b = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( gp->b ) <> Fbx.N_BLOCK then return Fbx.TYPE_NONE
    dim as Fbx.ListPayload ptr plist = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->b )].data )]
    if plist->count <> sp->count then return Fbx.TYPE_NONE

    '' The ARGUMENTS, resolved in the scope that wrote them. One that does not resolve
    '' means no instantiation rather than a wrong one -- every use then declines, which
    '' is the honest outcome and the same rule the tuple path uses.
    dim as string key = c.names->Spelling( sp->name ) & "<"
    dim as FB.Array( of ulong ) argTypes
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId an = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        dim as Fbx.TypeId at = ResolveTypeRef( c, an, scope_ )
        if at = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        argTypes.Push( cast( ulong, at ) )
        if i > 0 then key += ","
        key += str( cast( long, at ) )
    next
    key += ">"

    '' CACHED. 'b2 = b' over two spellings of one instantiation has to be the same
    '' type, so a miss here would break assignment as well as duplicate the work.
    dim as Fbx.InternId inm = c.names->Fold( c.names->GetString( key ) )
    dim as Fbx.SymbolId prev = c.syms->LookupLocalTyped( Fbx.SCOPE_GLOBAL, inm, true )
    dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( prev )
    if ps <> 0 then return ps->type_

    dim as boolean dup = false
    dim as Fbx.SymbolId isid = c.syms->DeclareSym( Fbx.SCOPE_GLOBAL, inm, _
        Fbx.SYM_UDT, c.ast->Loc( id ), dup )
    dim as Fbx.Symbol ptr isym = c.syms->SymbolAt( isid )
    if isym = 0 then return Fbx.TYPE_NONE
    dim as Fbx.ScopeId iin = c.syms->OpenScope( Fbx.SCOPEK_TYPE, Fbx.SCOPE_GLOBAL, isid )
    isym->inner = iin
    isym->type_ = c.types->NamedType( Fbx.TK_UDT, inm, cast( ulong, Fbx.SCOPE_GLOBAL ) )
    '' The symbol is published BEFORE the fields are walked, so a generic that refers
    '' to itself behind a pointer -- 'as Node( of T ) ptr nxt' -- finds the cache
    '' rather than recursing for ever.
    isym->payload = cast( long, gn )

    '' The parameters bind for as long as the fields are being resolved.
    dim as long gmark = c.gparamName.Count
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId pn = cast( Fbx.NodeId, c.ast->children[plist->first + i] )
        if c.ast->Kind( pn ) <> Fbx.N_IDENT then continue for
        dim as Fbx.IdentPayload ptr pip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
        c.gparamName.Push( cast( ulong, pip->name ) )
        c.gparamType.Push( argTypes[i] )
    next

    for i as long = 0 to gp->count - 1
        dim as Fbx.NodeId m = cast( Fbx.NodeId, c.ast->children[gp->first + i] )
        if c.ast->Kind( m ) <> Fbx.N_FIELD then continue for
        dim as Fbx.StmtPayload ptr fp = StmtOf( c, m )
        if fp->name = 0 then continue for
        dim as Fbx.TypeId ft = ResolveTypeRef( c, fp->a, iin )
        ft = ArrayFromBounds( c, ft, fp->first, fp->count )
        dim as boolean fdup = false
        dim as Fbx.SymbolId fsid = c.syms->DeclareSym( iin, fp->name, Fbx.SYM_FIELD, _
            c.ast->Loc( m ), fdup )
        dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsid )
        if fs <> 0 then fs->type_ = ft
    next

    while c.gparamName.Count > gmark
        c.gparamName.Pop( )
        c.gparamType.Pop( )
    wend

    return isym->type_
end function

end namespace

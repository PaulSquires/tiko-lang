'' lowerparam.bas -- reading a declared PARAMETER back off its N_PARAM node.
''
'' Split out of lowerstore.bas at the 1500-line lint cap. These four answer the same
'' kind of question -- what did the DECLARATION say about parameter n -- and none of
'' them is about storage, which is what the rest of that file is.

#import "std/containers"
#include once "mir/lowerctx.bi"

namespace Tko.Mir


'' The DEFAULT VALUE expression of parameter 'idx', or nothing. Parsed onto the
'' N_PARAM as 'b' and, until now, never read.
function ParamDefaultAt _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as Tko.NodeId

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return Tko.NODE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return Tko.NODE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.NODE_NONE
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then return StmtOf( c, prm )->b
        seen += 1
    next
    return Tko.NODE_NONE
end function

#include once "symbols/procptrdecl.bas"

'' A CALL THROUGH A PROCEDURE POINTER: its parameter count comes off the SIGNATURE and
'' its defaults off the pointer's DECLARATION -- see symbols/procptrdecl.bas. Before
'' this the count came off the callee SYMBOL, which for a pointer is the variable and
'' has no parameters, so 'pf2()' went out with no argument where fbc passes the
'' default. Answers the declaration or NODE_NONE, and leaves 'nparams' alone for any
'' other call.
function PtrCallDecl_ _
    ( byref c as Ctx, byval viaPointer as boolean, byval sigT as Tko.TypeId, _
      byval calleeNode as Tko.NodeId, byref nparams as long ) as Tko.NodeId

    if viaPointer = false then return Tko.NODE_NONE
    if sigT = Tko.TYPE_NONE then return Tko.NODE_NONE
    if c.types->Kind( sigT ) <> Tko.TK_PROC then return Tko.NODE_NONE
    nparams = c.types->ProcParamCount( sigT )
    return ProcPtrDeclOf_( c.ast, c.syms, c.types, c.info, c.names, calleeNode )
end function

'' The default of parameter 'idx': off the pointer's declaration when the call goes
'' through one, off the callee's otherwise. A pointer whose declaration was not found
'' has none, and the call declines rather than go out short.
function CallDefaultAt_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval ptrDecl as Tko.NodeId, _
      byval viaPointer as boolean, byval idx as long ) as Tko.NodeId

    if viaPointer = false then return ParamDefaultAt( c, callee, idx )
    dim as Tko.NodeId prm = ProcDeclParam_( c.ast, ptrDecl, idx )
    if prm = Tko.NODE_NONE then return Tko.NODE_NONE
    return StmtOf( c, prm )->b
end function

function ParamTypeAt _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as Tko.TypeId

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return Tko.TYPE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then return c.info->TypeOf_( StmtOf( c, prm )->a )
        seen += 1
    next
    return Tko.TYPE_NONE
end function

function ParamIsByref _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    '' COUNTING PARAMETERS, not children. An N_PROC's children are not all
    '' N_PARAM -- a BLOCK sits among them -- so indexing straight by 'idx' read
    '' whatever was in that slot and answered NO for a byref parameter whenever
    '' the list did not start at child zero. ParamTypeAt and ParamIsArray beside
    '' this one both walk; this one did not.
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then
            return ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        end if
        seen += 1
    next
    return false
end function

'' Is parameter 'idx' declared as an ARRAY -- 'sub Q( a( ) as long )'? Its TYPE is the
'' ELEMENT's, so the type cannot answer this; the empty subscript is a FLAG on the
'' N_PARAM and that is the only record of it.
function ParamIsArray _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    dim as long seen = 0
    for i as long = 0 to psp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[psp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then
            return ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0)
        end if
        seen += 1
    next
    return false
end function


'' A BARE TYPE NAME AS AN ARGUMENT -- 'byref param as foo = foo', the default written as the type --
'' is a DEFAULT-CONSTRUCTED TEMPORARY of that type, destroyed with the statement's others. Lowered as
'' an expression the name became a fresh variable called 'foo', never constructed, and the callee read
'' 0 where fbc reads the constructor's default (structs/obj_default_param.bas). False, emitting
'' nothing, for anything else.
function BareTypeNameTemp_( byref c as Ctx, byval e as Tko.NodeId, byref outa as MirValue ) as boolean
    e = Unparen_( c, e )
    if (e = Tko.NODE_NONE) orelse (c.ast->Kind( e ) <> Tko.N_IDENT) then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( e ) )
    if (s = 0) orelse (s->kind <> cast( ubyte, Tko.SYM_UDT )) then return false
    dim as Tko.TypeId t = c.types->Unqualify( s->type_ )
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as long sz = SizeOfType( c, t )
    if sz <= 0 then return false
    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    outa.kind = cast( ubyte, MV_LOCAL ) : outa.ty = cast( ubyte, MT_PTR ) : outa.id = slot
    dim as Tko.SymbolId dc = StructorWithArity( c, StructorOf( c, t, "__ctor" ), 0 )
    if dc <> Tko.SYMBOL_NONE then
        EmitStructorCall( c, dc, slot )
    elseif TypeNeedsInit_( c, t ) then
        CallImplicitCtor_( c, t, outa )
    else
        dim as containers.Array( of ulong ) za
        za.Push( cast( ulong, outa.kind ) ) : za.Push( cast( ulong, outa.id ) )
        za.Push( cast( ulong, MV_CONST_INT ) ) : za.Push( 0 )
        za.Push( cast( ulong, MV_CONST_INT ) ) : za.Push( cast( ulong, sz ) )
        EmitRtl( c, RTL_MEMSET, za )
    end if
    if TypeNeedsDtor_( c, t ) then c.udtTemps.Push( cast( ulong, slot ) ) : c.udtTempTypes.Push( cast( ulong, t ) )
    return true
end function

end namespace

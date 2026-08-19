'' lowerstore.bas -- where a variable's storage lives.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The subject is
'' one question -- frame slot or module storage -- and getting it wrong is not a
'' performance matter: a DIM SHARED that lands in a frame gives every procedure its own
'' private copy, and assignments to it are silently invisible to everyone else.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

function LocalFor _
    ( byref c as Ctx, byval sid as Fbx.SymbolId ) as long

    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1
    '' payload doubles as the slot index once assigned; -1 means not yet.
    for i as long = 0 to c.f->locals.Count - 1
        if c.f->locals[i].name = s->name then return i
    next
    dim as MirLocal l
    l.name = s->name
    l.frontendType = s->type_
    l.ty = cast( ubyte, LowerType( s->type_, *c.types ) )
    '' An aggregate slot needs its SIZE: 'agg' says nothing about how many bytes to
    '' reserve, and the layout pass is the only thing that knows.
    dim as long ui = c.udts->Find( s->type_ )
    if ui >= 0 then
        l.size = c.udts->udts[ui].size
    else
        l.size = c.types->Layout( s->type_ ).size
    end if
    c.f->locals.Push( l )

    '' The alloca goes in the ENTRY block, which is a verifier rule and also what
    '' lets LLVM's mem2reg promote the slot.
    dim as long saved = c.curBlock
    c.curBlock = 0
    dim as MirInst ins
    ins.op = cast( ushort, M_ALLOCA )
    ins.ty = cast( ubyte, MT_PTR )
    ins.imm = c.f->locals.Count - 1
    Emit( c, ins )
    c.curBlock = saved
    return c.f->locals.Count - 1
end function

'' Whether a symbol is DIM SHARED, and so lives in module storage rather than a frame.
function IsSharedVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    return ((s->flags and Fbx.SYMF_SHARED) <> 0)
end function

'' A STATIC local: procedure scope, but MODULE lifetime.
''
'' fbc emits it as a function-scoped C static, so it keeps its value across calls and is
'' initialised once rather than on entry:
''
''     void P( void ) { static int32 N$1 = 5;  N$1 = N$1 + 1; }
''
'' As a frame slot it would be reinitialised every call, which is the entire behaviour
'' the keyword exists to provide.
function IsStaticLocal( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if (s->flags and Fbx.SYMF_SHARED) <> 0 then return false
    return ((s->flags and Fbx.SYMF_STATIC) <> 0)
end function

'' The storage name for a static local, which must be unique PER PROCEDURE.
''
'' fbc names both of these N$1 and relies on C function scoping to keep them apart:
''
''     void P( void ) { static int32 N$1; ... }
''     void Q( void ) { static int32 N$1; ... }
''
'' MIR globals are one flat table with no such scoping, so the two would silently merge
'' into one variable -- P and Q sharing a counter, which is exactly the class of bug
'' DIM SHARED had in reverse. The procedure name is therefore part of the storage name.
private function StaticName( byref c as Ctx, byval sid as Fbx.SymbolId ) as Fbx.InternId
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    dim as string owner = "?"
    if c.f <> 0 then owner = c.names->Spelling( c.f->name )
    return c.names->GetString( owner & "$" & c.names->Spelling( s->name ) )
end function

'' The global slot for a DIM SHARED variable, created on first reference.
''
'' This exists because LocalFor matches by NAME WITHIN THE CURRENT FUNCTION, so a shared
'' variable used by two procedures got two unrelated frame slots, and a SUB assigning it
'' updated nothing anyone else could see. Storage has to be per MODULE, not per frame.
declare function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Fbx.InternId ) as Fbx.InternId

function GlobalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1

    '' Keyed by SYMBOL, not by spelling. Two statics called 'n' in sibling scopes of one
    '' procedure are two declarations and therefore two symbols; keying on the name
    '' merged them into a single variable that both scopes incremented.
    for i as long = 0 to c.gvarSym.Count - 1
        if c.gvarSym[i] = cast( ulong, sid ) then return c.gvarSlot[i]
    next

    dim as Fbx.InternId nm = s->name
    if IsStaticLocal( c, sid ) then nm = StaticName( c, sid )
    dim as long sz
    dim as long ui = c.udts->Find( s->type_ )
    if ui >= 0 then
        sz = c.udts->udts[ui].size
    else
        sz = c.types->Layout( s->type_ ).size
    end if
    '' The storage NAME must still be unique, because it is what a linker and a golden
    '' diff see. A collision here means two distinct symbols wanted the same spelling,
    '' so the later one is suffixed rather than silently sharing.
    nm = UniqueGlobalName( c, nm )

    dim as long g = c.m->AddVarGlobal( nm, LowerType( s->type_, *c.types ), s->type_, sz )
    c.gvarSym.Push( cast( ulong, sid ) )
    c.gvarSlot.Push( g )
    return g
end function

'' A module-global name not already taken by a DIFFERENT symbol.
private function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Fbx.InternId ) as Fbx.InternId

    dim as boolean taken = false
    for i as long = 0 to c.m->globals.Count - 1
        if c.m->globals[i].isVar andalso (c.m->globals[i].name = nm) then taken = true
    next
    if taken = false then return nm

    dim as string base_ = c.names->Spelling( nm )
    for n as long = 2 to 1000
        dim as Fbx.InternId cand = c.names->GetString( base_ & "$" & str( n ) )
        dim as boolean used = false
        for i as long = 0 to c.m->globals.Count - 1
            if c.m->globals[i].isVar andalso (c.m->globals[i].name = cand) then used = true
        next
        if used = false then return cand
    next
    return nm
end function

'' The ADDRESS of a variable, wherever its storage lives.
'' A DIM SHARED or STATIC initialiser, which is a compile-time value rather than a store
'' on entry. A non-constant one cannot become a static one and declines.
sub InitSharedGlobal _
    ( byref c as Ctx, byval sid as Fbx.SymbolId, byval init as Fbx.NodeId )

    dim as long g = GlobalFor( c, sid )
    if (g < 0) orelse (init = Fbx.NODE_NONE) then return
    dim as Fbx.Check.ConstVal cv = Fbx.Check.ConstOf( _
        *c.ast, init, *c.srcMgr, *c.names, c.types->target.pointerBits )
    if cv.known = false then
        SkipHere( c )
        return
    end if
    c.m->globals[g].initInt = cv.value
    c.m->globals[g].hasInit = true
end sub

function AddrOfVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as MirValue
    dim as MirValue v

    '' A CONSTANT HAS NO ADDRESS. 'const PI = 3.5' emits no variable, so asking for one
    '' invented a slot and loaded it uninitialised -- 'd = PI' stored garbage, silently
    '' and without declining. Constants fold in LowerPredeclared; one that will not fold
    '' has to decline here rather than be given storage it never had.
    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( sid )
    if cs <> 0 then
        if cs->kind = cast( ubyte, Fbx.SYM_CONSTANT ) then return v
    end if
    dim as boolean inModule = IsSharedVar( c, sid )
    if IsStaticLocal( c, sid ) then inModule = true
    if inModule then
        dim as long g = GlobalFor( c, sid )
        if g < 0 then return v
        v.kind = cast( ubyte, MV_GLOBAL )
        v.ty = cast( ubyte, MT_PTR )
        v.id = g
        return v
    end if
    dim as long lslot = LocalFor( c, sid )
    if lslot < 0 then return v
    v.kind = cast( ubyte, MV_LOCAL )
    v.ty = cast( ubyte, MT_PTR )
    v.id = lslot
    return v
end function

end namespace

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

'' The global slot for a DIM SHARED variable, created on first reference.
''
'' This exists because LocalFor matches by NAME WITHIN THE CURRENT FUNCTION, so a shared
'' variable used by two procedures got two unrelated frame slots, and a SUB assigning it
'' updated nothing anyone else could see. Storage has to be per MODULE, not per frame.
function GlobalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1
    dim as long sz
    dim as long ui = c.udts->Find( s->type_ )
    if ui >= 0 then
        sz = c.udts->udts[ui].size
    else
        sz = c.types->Layout( s->type_ ).size
    end if
    return c.m->AddVarGlobal( s->name, LowerType( s->type_, *c.types ), s->type_, sz )
end function

'' The ADDRESS of a variable, wherever its storage lives.
function AddrOfVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as MirValue
    dim as MirValue v
    if IsSharedVar( c, sid ) then
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

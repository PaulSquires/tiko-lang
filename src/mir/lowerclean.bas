'' lowerclean.bas -- the cleanup model: what runs when a scope ends.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The design is
'' docs/plan/08 section 6 and the comments below; nothing moved with it changed.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' -------------------------------------------------------------- cleanup model

sub PushScope( byref c as Ctx )
    c.scopeMark.Push( c.cleanupNode.Count )
end sub

'' Emit one scope's actions, innermost registration LAST, without popping: an EXIT or
'' RETURN leaving several scopes needs to run them all and then keep going.
private sub EmitScopeCleanup( byref c as Ctx, byval depth as long )
    if (depth < 0) orelse (depth >= c.scopeMark.Count) then return
    dim as long from_ = c.scopeMark[depth]
    dim as long upto = c.cleanupNode.Count
    if depth + 1 < c.scopeMark.Count then upto = c.scopeMark[depth + 1]
    for i as long = upto - 1 to from_ step -1
        if c.cleanupSlot[i] < 0 then
            LowerStmt( c, cast( Fbx.NodeId, c.cleanupNode[i] ) )
        elseif c.cleanupNode[i] = CLEANUP_DTOR_EPILOGUE then
            '' A DESTRUCTOR'S OWN EPILOGUE -- the fields in reverse, then the base.
            '' Registered as a cleanup action rather than appended after the body,
            '' because a 'return' inside a destructor leaves through here and would
            '' otherwise release nothing. It is registered FIRST, so reverse order runs
            '' it LAST: after every local the body declared.
            ''
            '' The slot holds THIS, which is a POINTER, so it is loaded rather than
            '' having its address taken.
            dim as MirValue ta
            ta.kind = cast( ubyte, MV_LOCAL )
            ta.ty = cast( ubyte, MT_PTR )
            ta.id = c.cleanupSlot[i]
            dim as MirValue tv = LowerExprLoad( c, ta, MT_PTR )
            if tv.kind <> cast( ubyte, MV_NONE ) then
                EmitDtorEpilogue_( c, cast( Fbx.TypeId, c.cleanupType[i] ), tv )
            end if
        elseif c.cleanupNode[i] = CLEANUP_DESTROY_ARRAY then
            '' AN ARRAY OF T IS N OBJECTS. The entry names the ARRAY type, which is
            '' where both the element type and the count come from.
            EmitArrayElems_( c, c.cleanupSlot[i], _
                             cast( Fbx.TypeId, c.cleanupType[i] ), false )
        elseif c.cleanupNode[i] = CLEANUP_IMPLICIT_DTOR then
            '' THE DESTRUCTOR FBC WRITES FOR YOU. It has no symbol -- there is no
            '' declaration anywhere -- so the entry names the TYPE and the emitted name
            '' comes from that.
            dim as MirValue ia
            ia.kind = cast( ubyte, MV_LOCAL )
            ia.ty = cast( ubyte, MT_PTR )
            ia.id = c.cleanupSlot[i]
            CallImplicitDtor_( c, cast( Fbx.TypeId, c.cleanupType[i] ), ia )
        elseif c.cleanupNode[i] = CLEANUP_ERASE_ARRAY then
            '' A local DYNAMIC array is erased at scope exit whatever its element
            '' type -- measured; fbc emits fb_ArrayErase / fb_ArrayStrErase /
            '' fb_ArrayEraseObj for every one of them.
            ''
            '' The marker is an IMPOSSIBLE SymbolId rather than a small number.
            '' Cleanup entries are otherwise symbol ids, and 1 is a perfectly valid
            '' one -- using it as a sentinel would have destructed whatever symbol 1
            '' happened to be. That is the pool-confusion mistake this project has
            '' made seven times; not an eighth.
            EmitEraseDynLocal( c, c.cleanupSlot[i] )
        elseif c.cleanupNode[i] = 0 then
            '' A string local is released with fb_StrDelete. This is the
            '' DestroyLocal action the cleanup model was built for and has had
            '' nothing to register until now.
            dim as MirValue addr
            addr.kind = cast( ubyte, MV_LOCAL )
            addr.ty = cast( ubyte, MT_PTR )
            addr.id = c.cleanupSlot[i]
            dim as FB.Array( of ulong ) args
            args.Push( cast( ulong, addr.kind ) )
            args.Push( cast( ulong, addr.id ) )
            EmitRtl( c, RTL_STR_DELETE, args )
        else
            EmitDtorCall( c, cast( Fbx.SymbolId, c.cleanupNode[i] ), c.cleanupSlot[i] )
        end if
    next
end sub

'' Every action of every scope from the innermost out to 'outermost', in that order.
'' This is what a RETURN through three scopes needs, and rule 5 of docs/plan/08: a
'' GOTO out of N scopes runs N scopes' cleanups, innermost first.
sub EmitCleanupsTo( byref c as Ctx, byval outermost as long )
    for d as long = c.scopeMark.Count - 1 to outermost step -1
        EmitScopeCleanup( c, d )
    next
end sub

private sub PopScope( byref c as Ctx )
    if c.scopeMark.Count = 0 then return
    dim as long mark = c.scopeMark[c.scopeMark.Count - 1]
    c.scopeMark.Pop( )
    '' ALL THREE COLUMNS. The type column was added later and was not popped here, so
    '' it grew for the life of the compilation while the other two shrank -- and every
    '' entry after the first scope read a type belonging to some earlier, unrelated
    '' variable. A local of one type was destroyed by another type's destructor.
    while c.cleanupNode.Count > mark
        c.cleanupNode.Pop( )
        c.cleanupSlot.Pop( )
        if c.cleanupType.Count > mark then c.cleanupType.Pop( )
    wend
end sub

'' A scope that ends by falling out of the bottom runs its own actions and nothing
'' else; the enclosing scopes have not ended.
sub CloseScope( byref c as Ctx )
    EmitScopeCleanup( c, c.scopeMark.Count - 1 )
    PopScope( c )
end sub

end namespace

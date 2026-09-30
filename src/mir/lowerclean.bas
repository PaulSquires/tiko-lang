'' lowerclean.bas -- the cleanup model: what runs when a scope ends.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The design is
'' docs/plan/08 section 6 and the comments below; nothing moved with it changed.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

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
            '' A bare 'defer' (TKO0828) registered nothing to run -- parser/defer.bas.
            if c.cleanupNode[i] <> Tko.NODE_NONE then LowerStmt( c, cast( Tko.NodeId, c.cleanupNode[i] ) )
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
                EmitDtorEpilogue_( c, cast( Tko.TypeId, c.cleanupType[i] ), tv )
            end if
        elseif c.cleanupNode[i] = CLEANUP_DESTROY_ARRAY then
            '' AN ARRAY OF T IS N OBJECTS. The entry names the ARRAY type, which is
            '' where both the element type and the count come from.
            EmitArrayElems_( c, c.cleanupSlot[i], _
                             cast( Tko.TypeId, c.cleanupType[i] ), false )
        elseif c.cleanupNode[i] = CLEANUP_IMPLICIT_DTOR then
            '' THE DESTRUCTOR FBC WRITES FOR YOU. It has no symbol -- there is no
            '' declaration anywhere -- so the entry names the TYPE and the emitted name
            '' comes from that.
            dim as MirValue ia
            ia.kind = cast( ubyte, MV_LOCAL )
            ia.ty = cast( ubyte, MT_PTR )
            ia.id = c.cleanupSlot[i]
            CallImplicitDtor_( c, cast( Tko.TypeId, c.cleanupType[i] ), ia )
        elseif c.cleanupNode[i] = CLEANUP_DESTRUCT_STR_ARRAY then
            '' A FIXED ARRAY OF VAR-LENGTH STRINGS owns N descriptors, and every one
            '' of them held a buffer nothing was releasing. Measured: fbc builds the
            '' array's descriptor and hands it to fb_ArrayDestructStr -- the same call
            '' ERASE makes over the same shape, which is why the entry carries the
            '' ARRAY type and rebuilds the descriptor here rather than keeping one.
            dim as MirValue sab
            sab.kind = cast( ubyte, MV_LOCAL )
            sab.ty = cast( ubyte, MT_PTR )
            sab.id = c.cleanupSlot[i]
            dim as MirValue sad
            if SynthFixedArrayDesc( c, sab, _
                                    cast( Tko.TypeId, c.cleanupType[i] ), sad ) then
                dim as FB.Array( of ulong ) saa
                saa.Push( cast( ulong, sad.kind ) )
                saa.Push( cast( ulong, sad.id ) )
                dim as Tko.TypeId sae = _
                    c.types->Inner( cast( Tko.TypeId, c.cleanupType[i] ) )
                if IsUStringType( c, sae ) then
                    EmitRtl( c, RTL_ARRAY_DESTRUCT_USTR, saa )
                else
                    EmitRtl( c, RTL_ARRAY_DESTRUCT_STR, saa )
                end if
            end if
        elseif c.cleanupNode[i] = CLEANUP_WSTR_DELETE then
            '' A WIDE TEMPORARY that must outlive its statement -- a SELECT's subject,
            '' which every case reads -- and still die on a RETURN or EXIT out of a case.
            '' The slot holds the allocation's POINTER, so it is loaded, as
            '' ReleaseWstrTemps_ does.
            dim as MirValue wsa
            wsa.kind = cast( ubyte, MV_LOCAL )
            wsa.ty = cast( ubyte, MT_PTR )
            wsa.id = c.cleanupSlot[i]
            dim as MirValue wsv = LowerExprLoad( c, wsa, MT_PTR )
            if wsv.kind <> cast( ubyte, MV_NONE ) then
                dim as FB.Array( of ulong ) wsargs
                wsargs.Push( cast( ulong, wsv.kind ) ) : wsargs.Push( cast( ulong, wsv.id ) )
                EmitRtl( c, RTL_WSTR_DELETE, wsargs )
            end if
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
            '' A USTRING IS RELEASED BY fb_UStrDelete. The two descriptors are the same
            '' SIZE, so calling the narrow one on a UTF-16 descriptor lowered, verified
            '' and freed the wrong thing.
            EmitRtl( c, StrRtlFor_( c, c.f->locals[c.cleanupSlot[i]].frontendType, _
                                    RTL_STR_DELETE ), args )
        else
            EmitDtorCall( c, cast( Tko.SymbolId, c.cleanupNode[i] ), c.cleanupSlot[i] )
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


'' A CALL'S HIDDEN RESULT OBJECT, destroyed where fbc destroys it.
''
'' Measured: 'print make( ).s' over a type holding a string is
''
''     MAKE( &TMP$3$1 );
''     fb_PrintString( 0, (FBSTRING*)&TMP$3$1, 1 );
''     _ZN1SD1Ev( &TMP$3$1 );
''
'' -- one destructor per call, at the end of the statement. Without it every call
'' returning a string-holding type LEAKED one object, which was recorded and left.
''
'' A LOOP HEAD releases its own before branching, because the condition runs again on
'' every iteration and the slot is reused: waiting for the statement to end would
'' destroy the last one and leak the rest.
'' A TEMPORARY WHOSE CONTENTS HAVE BEEN MOVED OUT is not destroyed: the buffers it
'' held now belong to whatever the bitwise copy wrote them into, and running the
'' destructor would hand that owner freed memory. Measured: 'return (5, "five")'
'' builds the tuple in a temporary and STORES it into the hidden pointer, so with
'' the temporary registered the caller's string was already gone -- 0xC0000374.
sub ForgetUdtTemp_( byref c as Ctx, byval slot as long )
    for i as long = c.udtTemps.Count - 1 to 0 step -1
        if cast( long, c.udtTemps[i] ) = slot then
            for k as long = i to c.udtTemps.Count - 2
                c.udtTemps[k] = c.udtTemps[k + 1]
                c.udtTempTypes[k] = c.udtTempTypes[k + 1]
            next
            c.udtTemps.Pop( )
            c.udtTempTypes.Pop( )
            return
        end if
    next
end sub

'' THE STRING TEMPORARIES MADE SINCE 'mark', DELETED HERE. Factored out of LowerStmt,
'' which released them at the end of the statement and nowhere else -- so a
'' temporary made inside ONE ARM of an 'iif' was deleted in the JOIN, on the path
'' that never built it. See LowerStringIif_.
sub ReleaseStrTemps_( byref c as Ctx, byval mark as long )
    while c.strTemps.Count > mark
        dim as long slot = cast( long, c.strTemps[c.strTemps.Count - 1] )
        c.strTemps.Pop( )
        '' A dead cursor means the statement ended in a terminator -- a RETURN or
        '' a GOTO -- and anything emitted here would land in no block at all. fbc
        '' has the same hole and leaks the temporary; matching it beats emitting
        '' an instruction with nowhere to go.
        if c.curBlock >= 0 then
            dim as MirValue addr
            addr.kind = cast( ubyte, MV_LOCAL )
            addr.ty = cast( ubyte, MT_PTR )
            addr.id = slot
            dim as FB.Array( of ulong ) args
            args.Push( cast( ulong, addr.kind ) ) : args.Push( cast( ulong, addr.id ) )
            EmitRtl( c, StrRtlFor_( c, c.f->locals[slot].frontendType, _
                                    RTL_STR_DELETE ), args )
        end if
    wend
end sub

'' A WIDE temporary's slot holds a POINTER to an allocation, so what is released is
'' the pointer LOADED from it -- not the slot's address, which is where the pointer
'' lives. fbc writes 'fb_WstrDelete( (uint16*)TMP$2$1 )'.
sub ReleaseWstrTemps_( byref c as Ctx, byval mark as long )
    while c.wstrTemps.Count > mark
        dim as long wslot = cast( long, c.wstrTemps[c.wstrTemps.Count - 1] )
        c.wstrTemps.Pop( )
        if c.curBlock >= 0 then
            dim as MirValue waddr
            waddr.kind = cast( ubyte, MV_LOCAL )
            waddr.ty = cast( ubyte, MT_PTR )
            waddr.id = wslot
            dim as MirValue wv = LowerExprLoad( c, waddr, MT_PTR )
            if wv.kind <> cast( ubyte, MV_NONE ) then
                dim as FB.Array( of ulong ) wargs
                wargs.Push( cast( ulong, wv.kind ) ) : wargs.Push( cast( ulong, wv.id ) )
                EmitRtl( c, RTL_WSTR_DELETE, wargs )
            end if
        end if
    wend
end sub

sub ReleaseUdtTemps_( byref c as Ctx, byval mark as long )
    while c.udtTemps.Count > mark
        dim as long slot = cast( long, c.udtTemps[c.udtTemps.Count - 1] )
        dim as Tko.TypeId t = cast( Tko.TypeId, c.udtTempTypes[c.udtTempTypes.Count - 1] )
        c.udtTemps.Pop( )
        c.udtTempTypes.Pop( )
        '' A dead cursor means the statement ended in a terminator, and anything
        '' emitted here would land in no block at all -- the same hole the string
        '' temporaries have, and fbc has it too.
        if c.curBlock >= 0 then
            dim as MirValue a
            a.kind = cast( ubyte, MV_LOCAL )
            a.ty = cast( ubyte, MT_PTR )
            a.id = slot
            dim as Tko.SymbolId dt = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
            if c.types->IsDynArray( t ) then
                '' AN ARRAY RESULT'S TEMPORARY is erased, not destroyed -- see lowerarrret.bas.
                EmitEraseDynAt_( c, a, t )
            elseif dt <> Tko.SYMBOL_NONE then
                dim as FB.Array( of ulong ) none_
                EmitStructorCall( c, dt, -1, @a, @none_ )
            else
                CallImplicitDtor_( c, t, a )
            end if
        end if
    wend
end sub

'' A CALL'S TEMPORARIES, PUT IN THE ORDER FBC MAKES THEM. The arguments are lowered right to
'' left and the receiver last, which is fbc's EVALUATION order, but fbc registers
'' destructors in SOURCE order -- the receiver, the call's hidden result, then each
'' argument left to right with its own temporaries together -- and runs them newest
'' first. Measured:
''
''     mkK( 1 ).m( takeR( mkH( 2 ) ), takeR( mkH( 3 ) ) )    destroys 3, 2, the receiver
''     takeR( mkK( 1 ).mh( takeR( mkH( 2 ) ) ) )             2, the result, the receiver
''     f2( mkH( 1 ) + mkH( 2 ), mkH( 4 ) )                   4, 4, 3, 3, 2, 1
''
'' Everything from 'headMark' on is rewritten in place: the receiver's run (from
'' 'recvMark'), the call's own result (up to 'argMark'), then argument 0's, 1's and so on.
'' 'segFrom[i]' is where argument i's run began; argument 0 was lowered last, so its run
'' ends where the receiver's begins. A list whose marks no longer nest -- something was
'' forgotten out of order -- is left as it is.
sub CallTempsInSourceOrder_ _
    ( byref c as Ctx, byval headMark as long, byval argMark as long, _
      byval recvMark as long, byref segFrom as FB.Array( of ulong ) )

    dim as long n = c.udtTemps.Count
    if n - headMark < 2 then return
    if (headMark > argMark) orelse (argMark > recvMark) orelse (recvMark > n) then return
    dim as long prev = recvMark
    for i as long = 0 to segFrom.Count - 1
        dim as long s = cast( long, segFrom[i] )
        if (s < argMark) orelse (s > prev) then return
        prev = s
    next

    dim as FB.Array( of ulong ) ns
    dim as FB.Array( of ulong ) nt
    for k as long = recvMark to n - 1
        ns.Push( c.udtTemps[k] ) : nt.Push( c.udtTempTypes[k] )
    next
    for k as long = headMark to argMark - 1
        ns.Push( c.udtTemps[k] ) : nt.Push( c.udtTempTypes[k] )
    next
    for i as long = 0 to segFrom.Count - 1
        dim as long stop_ = recvMark
        if i > 0 then stop_ = cast( long, segFrom[i - 1] )
        for k as long = cast( long, segFrom[i] ) to stop_ - 1
            ns.Push( c.udtTemps[k] ) : nt.Push( c.udtTempTypes[k] )
        next
    next
    for k as long = 0 to ns.Count - 1
        c.udtTemps[headMark + k] = ns[k]
        c.udtTempTypes[headMark + k] = nt[k]
    next
end sub

end namespace

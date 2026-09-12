'' lowerprocret.bas -- the string RETURN, and the small per-procedure queries the
'' rest of lowering asks: STATIC, the calling convention, and the sret copy.
''
'' Split out of lowerproc.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.


'' 'return expr' out of a STRING-RETURNING function. Returns false when this is not
'' one, so the ordinary RETURN carries on.
''
'' The value does not leave as a value: it is BUILT in the result descriptor and handed
'' to fb_StrAllocTempResult on the way out, which is what fbc emits. Returning the
'' expression directly would hand back a pointer to static text where the caller expects
'' a descriptor.
function LowerStringReturn( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    if c.resultSlot < 0 then return false
    if c.resultTy <> cast( ubyte, MT_AGG ) then return false
    '' AND THE RESULT MUST ACTUALLY BE A STRING. MT_AGG alone stopped being enough the
    '' moment a by-value UDT result got an aggregate slot too: every 'return <udt>'
    '' came through here, tried a string assignment into it, and then emitted
    '' fb_StrAllocTempResult ON A UDT. Not a decline -- a string runtime call on an
    '' object, which lowers cleanly and verifies.
    if IsStringType( c, c.resultType ) = false then return false

    if valueE <> Tko.NODE_NONE then
        if LowerStringAssignToSlot( c, c.resultSlot, valueE ) = false then SkipHere( c )
    end if
    '' A RETURN leaves every open scope, so their actions run before the terminator.
    EmitCleanupsTo( c, 0 )

    dim as MirValue rsa
    rsa.kind = cast( ubyte, MV_LOCAL )
    rsa.ty = cast( ubyte, MT_PTR )
    rsa.id = c.resultSlot
    dim as FB.Array( of ulong ) rr
    rr.Push( cast( ulong, rsa.kind ) ) : rr.Push( cast( ulong, rsa.id ) )
    Terminate( c, MTERM_RET, -1, -1, EmitRtl( c, ResultTempRtl_( c ), rr ) )
    c.curBlock = -1
    return true
end function


'' The copy-construction half of a UDT result. False when the type has no copy
'' constructor at all, written or synthesised, which is the trivial structure fbc
'' stores whole.

'' Whether a procedure is a STATIC member, which is the question "does it have a
'' receiver" asked the other way round. PF_STATIC may sit on EITHER node: on the
'' definition when the definition repeats the word, and on the DECLARE when -- as is
'' usual and as fbc requires for the allocation operators -- it does not.
function ProcIsStatic_ _
    ( byref c as Ctx, byval defn as Tko.NodeId, byval sid as Tko.SymbolId ) as boolean

    if defn <> Tko.NODE_NONE then
        dim as Tko.StmtPayload ptr dp = StmtOf( c, defn )
        if dp <> 0 then
            if (dp->extra and Tko.PF_STATIC) <> 0 then return true
        end if
    end if
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr psp = StmtOf( c, pn )
    if psp = 0 then return false
    return ((psp->extra and Tko.PF_STATIC) <> 0)
end function

'' cdecl / stdcall / pascal, off the proc's own flags. All three are one convention on
'' x86-64 and the emitted IR is identical; it is carried because it is part of the
'' signature, because win32 is a stated target, and because it is unrecoverable later.
function ProcCallConv_ _
    ( byref c as Ctx, byval pn as Tko.NodeId ) as ubyte

    if pn = Tko.NODE_NONE then return TKO_CC_CDECL
    dim as Tko.StmtPayload ptr sp = StmtOf( c, pn )
    if sp = 0 then return TKO_CC_CDECL
    if (sp->extra and Tko.PF_STDCALL) <> 0 then return TKO_CC_STDCALL
    if (sp->extra and Tko.PF_PASCAL) <> 0 then return TKO_CC_PASCAL
    return TKO_CC_CDECL
end function


private function SretCopyResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId, byval rt as Tko.TypeId ) as boolean

    if c.types->Kind( rt ) <> Tko.TK_UDT then return false
    '' The whole overload chain -- see CopyCtorOf_.
    dim as Tko.SymbolId cc = CopyCtorOf_( c, rt )
    dim as boolean written = (cc <> Tko.SYMBOL_NONE)
    if (written = false) andalso (NeedsLetBody_( c, rt ) = false) then return false

    '' AND THE SOURCE MUST BE ONE OF THESE. 'return T( 1 )' constructs a temporary
    '' somewhere this cannot see, and 'return' with no value has nothing to copy.
    dim as Tko.TypeId vt = c.types->Unqualify( c.info->TypeOf_( valueE ) )
    if vt <> c.types->Unqualify( rt ) then return false
    dim as MirValue src = LowerAddr( c, valueE )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue sa
    sa.kind = cast( ubyte, MV_LOCAL )
    sa.ty = cast( ubyte, MT_PTR )
    sa.id = c.sretParam
    dim as MirValue dst = LowerExprLoad( c, sa, MT_PTR )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    if written then
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, src.kind ) )
        cargs.Push( cast( ulong, src.id ) )
        EmitStructorCall( c, cc, -1, @dst, @cargs )
    else
        CallImplicitCopy_( c, rt, dst, src )
    end if
    return true
end function

end namespace

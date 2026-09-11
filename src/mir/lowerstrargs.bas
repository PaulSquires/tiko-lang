'' lowerstrargs.bas -- the STRING TEMPORARIES a call site builds for its arguments.
''
'' A byval var-length string argument takes a descriptor the CALLER makes and deletes;
'' a fixed 'ustring * N' against a byref ustring parameter takes a COPY, because the
'' runtime has no ustring temp-descriptor borrow to lend it one. Both are the call
'' site's own bookkeeping rather than anything about the callee.
''
'' Split out of lowercall.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.

'' IS THIS ARGUMENT A GENUINELY NARROW STRING?
''
'' The question a USTRING parameter has to ask, and there was no predicate for it.
'' IsStringType answers true for BOTH flavours, and a CONCATENATION has no type of its
'' own at all -- so neither alone can tell 'al' + 'pha' from a & b over two ustrings.
'' The terms are asked one at a time, which is what ConcatHasWideTerm_ beside it
'' already does for the wide case and for the same reason.
''
'' A 'ustring * N' source is deliberately NOT narrow here: FixedUStrArgTemp_ owns it,
'' and it copies in, calls, copies back and deletes.
private function ConcatHasUStrTerm_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as boolean

    if e = Tko.NODE_NONE then return false
    if IsUStringType( c, c.info->TypeOf_( e ) ) then return true
    if c.ast->Kind( e ) <> Tko.N_BINARY then return false
    dim as FB.Array( of ulong ) uvt
    FlattenConcat( c, e, uvt )
    for k as long = 0 to uvt.Count - 1
        if IsUStringType( c, c.info->TypeOf_( cast( Tko.NodeId, uvt[k] ) ) ) then
            return true
        end if
    next
    return false
end function

function NarrowStrArg_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as boolean

    if e = Tko.NODE_NONE then return false
    '' Anything wide or ustring-shaped belongs to one of the other arms.
    if TermIsWide_( c, e ) then return false
    if ConcatHasWideTerm_( c, e ) then return false
    if ConcatHasUStrTerm_( c, e ) then return false
    dim as longint fkn
    if StrSwapKind_( c, c.info->TypeOf_( e ), fkn ) = 4 then return false
    dim as Tko.TypeId at = c.info->TypeOf_( e )
    if at <> Tko.TYPE_NONE then
        if IsStringType( c, at ) then return (IsUStringType( c, at ) = false)
        '' A fixed NARROW string counts: 'zstring * N' and 'string * N' both assign
        '' into a descriptor the same way a var-length one does.
        dim as long sk = StrSwapKind_( c, at, fkn )
        return (sk = 1) orelse (sk = 3)
    end if
    '' NO TYPE AT ALL is a concatenation or an intrinsic call; the wide and ustring
    '' tests above have already refused every one of those that is not narrow.
    return (c.ast->Kind( e ) = Tko.N_BINARY)
end function

'' THE CALLER-BUILT DESCRIPTOR for one byval var-length string argument: zeroed,
'' assigned from the source, and passed by ADDRESS. The slot comes back so the call
'' site can delete it afterwards.
private function ByvalStrTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
    '' A STRING-TO-STRING 'cast' IS THE IDENTITY -- see StrIdentityConvOperand_.
    dim as Tko.NodeId sica = StrIdentityConvOperand_( c, argNode )
    if sica <> Tko.NODE_NONE then argNode = sica
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    ZeroStrDescriptor( c, dst )
    '' The same assignment a 'dim as string s = expr' makes, so every source shape --
    '' a literal, a fixed-length string, a concatenation -- reaches the entry point it
    '' already had. A WIDE source is its own conversion: measured,
    '' 'takeByvalString( whex( n ) )' is 'fb_WstrAssignToA( &TMP, -1, TMP_wide, 0 )'
    '' and not fb_StrAssign.
    '' A WIDE SOURCE FOR A USTRING TEMPORARY converts through fb_WstrToUStr and
    '' then assigns the descriptor it hands back. Measured, for a wide rvalue
    '' against a 'byref as const ustring':
    ''
    ''   vr = fb_WstrToUStr( TMP_wide )
    ''   fb_UStrAssign( &TMP_u, -1, vr, -1, 0 )
    ''   G( &TMP_u )
    ''
    '' The narrow conversion below refuses a ustring destination outright, so
    '' without this the temporary was built NARROW whatever the parameter said --
    '' an FBSTRING where an FBUSTRING belongs -- and the call declined.
    ''
    '' THE WIDE TEMPORARY ITSELF IS STILL LEAKED, as every wide temporary here is:
    '' fbc emits an fb_WstrDelete for it and tiko-lang models no wide lifetime. That
    '' is a leak and not a wrong answer, and it is recorded in rtl.bi's own header.
    if IsUStringType( c, pt ) andalso _
       (TermIsWide_( c, argNode ) orelse ConcatHasWideTerm_( c, argNode )) then
        dim as MirValue uv
        '' A CONCATENATION IS HANDLED BY THE CONVERTER, which builds its wide
        '' temporary first -- see WideTermAsUStr_.
        if WideTermAsUStr_( c, argNode, uv ) = false then return false
        dim as FB.Array( of ulong ) uargs
        uargs.Push( cast( ulong, dst.kind ) ) : uargs.Push( cast( ulong, dst.id ) )
        PushStrLen_( c, uargs, -1 )
        uargs.Push( cast( ulong, uv.kind ) ) : uargs.Push( cast( ulong, uv.id ) )
        PushStrLen_( c, uargs, -1 )
        uargs.Push( cast( ulong, MV_CONST_INT ) ) : uargs.Push( 0 )
        EmitRtl( c, RTL_USTR_ASSIGN, uargs )
        outSlot = slot
        outa = dst
        return true
    end if

    '' A GENUINELY NARROW SOURCE FOR A USTRING TEMPORARY converts through
    '' fb_UStrAssignFromA.
    ''
    '' The wide arm above takes a wide source; a narrow one fell to
    '' LowerStringAssignToSlot, which fills the temporary as an FBSTRING -- the exact
    '' mistake that arm's own comment warns about, one case along. An FBSTRING and an
    '' FBUSTRING share a 24-byte layout, so it linked, verified, and compared wrong:
    '' the callee read 'len' UTF-16 units out of a narrow buffer.
    ''
    '' Measured, fbc converts in and copies BACK, because the parameter is byref:
    ''
    ''     fb_UStrAssignFromA( &TMP$8$0, -1, &SV$0, -1, 0, 0 );
    ''     EQUALSREF( &TMP$8$0 );
    ''     fb_UStrAssignToA( &SV$0, -1, &TMP$8$0, -1, 0, 0 );
    ''
    '' THE COPY-BACK IS NOT EMITTED HERE. FixedUStrArgTemp_'s caller registers one
    '' through ustrBackNode/ustrBackSlot for the 'ustring * N' case; wiring the same
    '' list for this one is owed, and until it is, a callee that WRITES through such a
    '' parameter loses the write. Every reading callee is correct, which is what the
    '' corpus does. Recorded rather than guessed.
    if IsUStringType( c, pt ) andalso NarrowStrArg_( c, argNode ) then
        dim as MirValue nsv
        if StrDescriptorOf_( c, argNode, nsv ) = false then return false
        dim as FB.Array( of ulong ) nargs
        nargs.Push( cast( ulong, dst.kind ) ) : nargs.Push( cast( ulong, dst.id ) )
        PushStrLen_( c, nargs, -1 )
        nargs.Push( cast( ulong, nsv.kind ) ) : nargs.Push( cast( ulong, nsv.id ) )
        PushStrLen_( c, nargs, -1 )
        nargs.Push( cast( ulong, MV_CONST_INT ) ) : nargs.Push( 0 )
        nargs.Push( cast( ulong, MV_CONST_INT ) ) : nargs.Push( 0 )
        EmitRtl( c, RTL_USTR_FROM_A, nargs )
        outSlot = slot
        outa = dst
        return true
    end if

    if LowerWideToNarrowSlot( c, slot, pt, argNode ) then
    elseif LowerStringAssignToSlot( c, slot, argNode ) = false then
        return false
    end if
    outSlot = slot
    outa = dst
    return true
end function

'' A FIXED 'ustring * N' COPIED INTO A DESCRIPTOR, for a byref USTRING parameter.
'' The narrow family BORROWS one -- fb_StrAllocTempDescF over the same bytes -- and
'' the runtime has no ustring counterpart, so this is a real copy.
private function FixedUStrArgTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, _
      byref outa as MirValue, byref outSlot as long ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
    dim as longint tag
    if StrSwapKind_( c, c.info->TypeOf_( argNode ), tag ) <> 4 then return false
    dim as MirValue src = LowerAddr( c, argNode )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    ZeroStrDescriptor( c, dst )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    PushStrLen_( c, args, -1 )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    PushStrLen_( c, args, tag )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_USTR_ASSIGN, args )

    outSlot = slot
    outa = dst
    return true
end function

'' ...and the COPY BACK, after the call. fbc emits it whether or not the parameter
'' is CONST, so it is emitted here the same way rather than reasoned about: a
'' const parameter makes it a no-op, and guessing which is which would be a
'' semantic fork over an observable write.
private sub CopyBackUStrArgs_ _
    ( byref c as Ctx, byref nodes as FB.Array( of ulong ), _
      byref slots as FB.Array( of ulong ) )

    for k as long = nodes.Count - 1 to 0 step -1
        dim as Tko.NodeId an = cast( Tko.NodeId, nodes[k] )
        dim as longint tag
        if StrSwapKind_( c, c.info->TypeOf_( an ), tag ) <> 4 then continue for
        dim as MirValue dst = LowerAddr( c, an )
        if dst.kind = cast( ubyte, MV_NONE ) then continue for
        dim as MirValue src
        src.kind = cast( ubyte, MV_LOCAL )
        src.ty = cast( ubyte, MT_PTR )
        src.id = cast( long, slots[k] )
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
        PushStrLen_( c, args, tag )
        args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
        PushStrLen_( c, args, -1 )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, -1 ) )
        EmitRtl( c, RTL_USTR_ASSIGN, args )
    next
end sub

'' ...and their release, after the call returns.
private sub DeleteStrArgTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )

    for k as long = slots.Count - 1 to 0 step -1
        dim as MirValue a
        a.kind = cast( ubyte, MV_LOCAL )
        a.ty = cast( ubyte, MT_PTR )
        a.id = cast( long, slots[k] )
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, a.kind ) ) : args.Push( cast( ulong, a.id ) )
        EmitRtl( c, StrRtlFor_( c, cast( Tko.TypeId, types[k] ), RTL_STR_DELETE ), args )
    next
end sub


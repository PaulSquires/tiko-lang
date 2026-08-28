'' lowerstrargs.bas -- the STRING TEMPORARIES a call site builds for its arguments.
''
'' A byval var-length string argument takes a descriptor the CALLER makes and deletes;
'' a fixed 'ustring * N' against a byref ustring parameter takes a COPY, because the
'' runtime has no ustring temp-descriptor borrow to lend it one. Both are the call
'' site's own bookkeeping rather than anything about the callee.
''
'' Split out of lowercall.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.

'' THE CALLER-BUILT DESCRIPTOR for one byval var-length string argument: zeroed,
'' assigned from the source, and passed by ADDRESS. The slot comes back so the call
'' site can delete it afterwards.
private function ByvalStrTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
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
        '' A CONCATENATION HAS NO ADDRESS. It is built into a wide temporary first
        '' and converted from THAT -- measured, 'G( w & "z" )' is
        '' 'fb_WstrConcatWA( W, "z", 2 )' and then fb_WstrToUStr over its result.
        if ConcatHasWideTerm_( c, argNode ) then
            dim as MirValue wtmp
            if WideConcatToTemp_( c, argNode, wtmp ) = false then return false
            dim as FB.Array( of ulong ) cargs
            cargs.Push( cast( ulong, wtmp.kind ) ) : cargs.Push( cast( ulong, wtmp.id ) )
            uv = EmitRtl( c, RTL_WSTR_TO_USTR, cargs )
            if uv.kind = cast( ubyte, MV_NONE ) then return false
        elseif WideTermAsUStr_( c, argNode, uv ) = false then
            return false
        end if
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


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

'' IS THIS CALLEE A RUNTIME ENTRY POINT RATHER THAN A PROCEDURE?
''
'' It decides which shape a byref string argument takes, and the two are opposites.
'' fbc hands a RUNTIME entry point a POOL descriptor -- 'fb_GfxScreenInfo32( ...,
'' fb_StrAllocTempDescZEx( "", 0 ) )' -- because the entry point consumes it before
'' returning and the slot is free again immediately. It hands a USER procedure a
'' real temporary, because the callee's own string work would recycle that slot
'' underneath it.
''
'' ASKED OF THE ALIAS, because that is what the distinction actually is. SCREENINFO,
'' IMAGEINFO, GETMOUSE and their siblings reach lowering as ordinary declarations --
'' the prelude writes them with 'alias "fb_GfxScreenInfo32"' so that overload
'' resolution can pick between the 32- and 64-bit forms -- so nothing about the CALL
'' says which kind it is. The alias does: a procedure bound to a libfb symbol is
'' libfb, wherever its declaration was written.
private function RuntimeEntryCallee_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId ) as boolean

    if callee = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr sym = c.syms->SymbolAt( callee )
    if sym = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, sym->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )]
    if sp->aliasName = 0 then return false
    dim as string al = c.names->Spelling( sp->aliasName )
    if left( al, 3 ) = "fb_" then return true
    return (left( al, 5 ) = "__fb_")
end function

'' DOES THIS ARGUMENT PASS ITS OWN DESCRIPTOR TO A BYREF STRING PARAMETER?
''
'' Measured, and the rule is narrower than it looks: ONLY A VAR-LENGTH STRING
'' LVALUE does. Everything else -- a literal, a 'zstring * N', a 'string * N', a
'' concatenation, a function result, '*pz' -- gets a zeroed temporary, fb_StrAssign
'' in, the call, and fb_StrDelete after; the two fixed kinds also get a copy BACK.
'' One probe, seven arguments, fbc's own C:
''
''     P( "lit" )   memset TMP; fb_StrAssign( &TMP, -1, "lit", 4, 0 ); P( &TMP ); delete
''     P( v )       P( &V )                    -- and ONLY this one
''     P( z )       temp, call, fb_StrAssign( Z, 8, &TMP, -1, 0 ), delete
''     P( fx )      temp, call, fb_StrAssign( FX, tag, &TMP, -1, -1 ), delete
''     P( v & "c" ) concat into TMP11, fb_StrAssign into TMP12, P( &TMP12 ), delete
''     P( F( ) )    temp, call, delete
''     P( *pz )     temp, call, delete
''
'' WHY IT MATTERS, and it is not tidiness. tiko-lang answered every one of those
'' with fb_StrAllocTempDescZEx or fb_StrAllocTempDescF -- descriptors from libfb's
'' small ROTATING POOL. A pool slot is meant to live until the runtime call that
'' consumes it; handed to a USER function it stays live across the whole body, and
'' the callee's own string work recycles the very slot its parameter points at.
'' Measured: 'sub P( byref s as string )' printing 's' saw the text of a literal
'' from its OWN print statement, and 'P( "xx" )' reported len 4.
''
'' A USTRING AGAINST A NARROW PARAMETER IS A TEMPORARY TOO. Measured, for a
'' var-length ustring passed to 'byref s as string' and to 'byref s as const string'
'' alike -- fbc's own C:
''
''     memset TMP; vr = fb_UStrToStr( &U, -1 ); fb_StrAssign( &TMP, -1, vr, -1, 0 )
''     P( &TMP ); fb_StrDelete( &TMP )           -- and NO copy back
''
'' This used to answer 'owns its descriptor' for every cross-flavour pair, calling
'' that refusing to answer. It was not: the ustring's FBUSTRING went to the callee as
'' an FBSTRING, which read its UTF-16 buffer as narrow text -- 'AB' arrived as 'A',
'' NUL. The self-hosted compiler read TKO_LIBPATH that way into its library list and
'' could not find libfb, and printed every file name it had been handed as mojibake.
''
'' The OTHER direction -- a narrow argument against a ustring parameter -- is decided
'' before this is asked, by its own arm in lowercall.bas.
private function StrArgOwnDescriptor_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId ) as boolean

    if e = Tko.NODE_NONE then return true
    dim as Tko.TypeId at = c.info->TypeOf_( e )
    '' NO TYPE is a concatenation or an intrinsic's result -- string-shaped by the
    '' time it gets here, and one of the shapes fbc copies.
    if at = Tko.TYPE_NONE then return false
    at = c.types->Unqualify( at )
    if IsStringType( c, at ) = false then
        '' A FIXED NARROW STRING is copied; anything that is not a string at all is
        '' NOT THIS RULE'S BUSINESS. 'takesS( 0 )' is an error the checker already
        '' reports, and building it a temporary out of fb_LongintToStr would lower a
        '' call the compiler had just refused -- an implicit conversion tiko-lang
        '' does not have, emitted underneath a diagnostic.
        dim as longint fn_
        dim as long fk = StrSwapKind_( c, at, fn_ )
        return (fk <> 1) andalso (fk <> 3)
    end if
    '' A ustring into a narrow parameter is copied -- see above.
    if IsUStringType( c, at ) andalso (IsUStringType( c, pt ) = false) then return false
    if IsUStringType( c, at ) <> IsUStringType( c, pt ) then return true
    select case c.ast->Kind( e )
    case Tko.N_IDENT, Tko.N_MEMBER, Tko.N_INDEX, Tko.N_DEREF
        return true
    end select
    return false
end function

'' THE CALLER-BUILT DESCRIPTOR for one byval var-length string argument: zeroed,
'' assigned from the source, and passed by ADDRESS. The slot comes back so the call
'' site can delete it afterwards.
function ByvalStrTemp_ _
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

    '' A USTRING SOURCE FOR A USTRING TEMPORARY IS A USTRING ASSIGNMENT. Measured, for a
    '' var-length ustring passed to 'byval s as ustring':
    ''
    ''     memset( &TMP, 0, 24 ); fb_UStrAssign( &TMP, -1, &U, -1, 0 ); TAKEU( &TMP )
    ''     fb_UStrDelete( &TMP )
    ''
    '' Neither arm above owns it -- the source is not wide and not narrow -- so it fell
    '' to LowerStringAssignToSlot, which filled the temporary through fb_UStrAssignToA:
    '' a NARROW descriptor the callee then read as UTF-16. The self-hosted compiler's
    '' Text.UStringToUtf8( byval s as ustring ) returned mojibake that way, so
    '' SourceManager.Find never matched a header it had already loaded and every
    '' '#include once' included it again.
    ''
    '' AN ADDRESSABLE USTRING ONLY, looked through a byref -- 'byref absPath as ustring'
    '' is exactly the shape Find passes on. A ustring RVALUE is not measured here and
    '' declines rather than take the narrow path it used to.
    scope
        dim as Tko.TypeId uat = c.types->Unqualify( c.info->TypeOf_( argNode ) )
        if uat <> Tko.TYPE_NONE then
            if c.types->Kind( uat ) = Tko.TK_REFERENCE then
                uat = c.types->Unqualify( c.types->Inner( uat ) )
            end if
        end if
        if IsUStringType( c, pt ) andalso IsUStringType( c, uat ) then
            dim as MirValue usrc = LowerAddr( c, argNode )
            if usrc.kind = cast( ubyte, MV_NONE ) then return false
            dim as FB.Array( of ulong ) usa
            usa.Push( cast( ulong, dst.kind ) ) : usa.Push( cast( ulong, dst.id ) )
            PushStrLen_( c, usa, -1 )
            usa.Push( cast( ulong, usrc.kind ) ) : usa.Push( cast( ulong, usrc.id ) )
            PushStrLen_( c, usa, -1 )
            usa.Push( cast( ulong, MV_CONST_INT ) ) : usa.Push( 0 )
            EmitRtl( c, RTL_USTR_ASSIGN, usa )
            outSlot = slot
            outa = dst
            return true
        end if
    end scope

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
        '' THE FIXED KINDS, all three. fbc copies the temporary back into a
        '' 'ustring * N', a 'zstring * N' and a 'string * N' alike -- the
        '' parameter is byref, so a callee that writes through it must be seen.
        '' The trailing flag is the one fbc emits for each: 0 for the narrow
        '' kinds' own assignment and -1 for the space-padded one.
        dim as long fk = StrSwapKind_( c, c.info->TypeOf_( an ), tag )
        if (fk <> 4) andalso (fk <> 1) andalso (fk <> 3) then continue for
        '' A FIXED KIND WITH NO DECLARED LENGTH IS NOT ONE. An UNSIZED zstring --
        '' what a 'zstring ptr' points at, and what '*p' is -- reports kind 1 with a
        '' tag of 0, and copying back through it WROTE INTO WHATEVER THE POINTER
        '' NAMED. For a literal that is read-only memory:
        ''
        ''     dim as zstring ptr p = @"abc" : takes( *p )     -- segfault
        ''
        '' fbc emits the copy-back only for a SIZED lvalue -- 'fb_StrAssign( Z$0,
        '' 8ll, ... )' for a 'zstring * 8' -- and none at all for '*p'. It is
        '' fbcunit's own report_init_file( *filename ), so ex09 died in the harness.
        '' EXACTLY ZERO, not 'not positive': a real fixed length arrives ENCODED --
        '' FixedStrLenArg_ sets the high bit, so 'zstring * 8' carries
        '' -9223372036854775784 -- and only the UNSIZED form reports a plain 0.
        if tag = 0 then continue for
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
        if fk = 4 then
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, -1 ) )
            EmitRtl( c, RTL_USTR_ASSIGN, args )
        else
            dim as longint bflag = 0
            if fk = 3 then bflag = -1
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, bflag ) ) )
            EmitRtl( c, RTL_STR_ASSIGN, args )
        end if
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


'' Moved from lowercall.bas at the 1500-line cap; nothing in them changed.
'' Does parameter 'idx' declare 'byref as wstring'? The referent is what decides, and
'' a REFERENCE type has to be unwrapped to see it -- the recurring lesson in this
'' codebase, that a reference is transparent to TypeOf_.
function ParamWantsWideRef_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval sigT as Tko.TypeId, _
      byval idx as long ) as boolean

    dim as Tko.TypeId pt = ArgParamType_( c, callee, sigT, idx )
    if pt = Tko.TYPE_NONE then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then
        pu = c.types->Unqualify( c.types->Inner( pu ) )
    end if
    if c.types->Kind( pu ) <> Tko.TK_BUILTIN then return false
    return (c.types->BuiltinOf( pu ) = Tko.TY_WSTRING)
end function

'' A NARROW string argument: a var-length one, or a zstring in either spelling. The
'' wide kinds answer false -- they need no conversion.
function IsNarrowStrArg_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    if IsStringType( c, t ) then return true
    dim as longint zn
    dim as long k = StrSwapKind_( c, t, zn )
    return (k = 0) orelse (k = 1) orelse (k = 3)
end function


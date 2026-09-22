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
function StrArgOwnDescriptor_ _
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
    case Tko.N_MEMBER, Tko.N_INDEX, Tko.N_DEREF
        return true
    case Tko.N_IDENT
        '' AN IDENTIFIER THAT NAMES STORAGE owns its descriptor; one that merely LOOKS
        '' like an identifier does not. 'curdir', 'time' and 'date' take no arguments and
        '' no parentheses, so each is a lone N_IDENT typed STRING -- and each is a CALL
        '' whose result is a descriptor from libfb's small ROTATING POOL.
        ''
        '' Answering 'owns it' handed the pool slot straight to a user procedure:
        ''
        ''     %5 = call ptr fb_CurDir()
        ''     call void _ZN7AFXNOVA8DWSTRINGaSER8FBSTRING(@d, %5)
        ''
        '' and DWSTRING's 'operator let' does its own string work -- 'this.Clear :
        '' this.Add( ansiStr )' -- which recycles the very slot its parameter points at.
        '' 'dim as DWSTRING d = curdir' came out EMPTY. tiko-editor saved the current
        '' directory that way before a compile and could not put the process back.
        '' Measured, fbc copies first: 'memset( &TMP, 0, 24 ); vr = fb_CurDir();
        '' fb_StrAssign( &TMP, -1, vr, -1, 0 ); ..aSER8FBSTRING( &D, &TMP );'.
        ''
        '' This is the hazard THIS FUNCTION'S OWN HEADER describes, reached by the one
        '' shape the node kind cannot tell apart from a variable.
        dim as Tko.Symbol ptr vsy = c.syms->SymbolAt( c.info->RefOf( e ) )
        if vsy = 0 then return false
        select case vsy->kind
        case cast( ubyte, Tko.SYM_VARIABLE ), cast( ubyte, Tko.SYM_PARAMETER ), _
             cast( ubyte, Tko.SYM_FIELD )
            return true
        end select
        return false
    end select
    return false
end function

'' DOES A 'byref as string' PARAMETER OF A CONVERTING CONSTRUCTOR HAVE TO BUILD A
'' TEMPORARY for this argument? Two reasons it must, and LowerConvCtorInit_ knew only
'' the first: the argument is WIDE, or it is a narrow string that does not own a
'' descriptor -- which, for an argument the address arm there can reach at all, means a
'' FIXED one, 'zstring * N' or 'string * N'.
''
'' A fixed string is an ARRAY of a character builtin, so IsStringType says no to it and
'' the byref arm took its ADDRESS: the constructor read an FBSTRING out of the
'' characters. tiko-editor's theme writer is
''
''     function Theme_RoleName( byval idx as long ) as DWSTRING
''         return gThemeRoleDef(idx).name        '' name is 'zstring * 32'
''
'' -- and the DWSTRING built from it took its buffer pointer from the text 'role.bac',
'' so saving a theme died at 0xC0000005. Measured, fbc converts through a temporary and
'' copies back, the parameter being byref and not const:
''
''     memset( &TMP, 0, 24 );
''     fb_StrAssign( &TMP, -1, (void*)GZ$, 32ll, 0 );
''     _ZN1UC1ER8FBSTRINGj( this, &TMP, 0u );
''     fb_StrAssign( (void*)GZ$, 32ll, &TMP, -1, 0 );  fb_StrDelete( &TMP );
''
'' CtorArgValue_ already builds that temporary; all this decides is that the address arm
'' must not claim the argument first. THE COPY-BACK IS STILL NOT EMITTED, as it is not
'' for any of ByvalStrTemp_'s callers -- recorded in its own header.
function NarrowStrCtorParamConverts_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId ) as boolean

    if pt = Tko.TYPE_NONE then return false
    if argNode = Tko.NODE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( pt )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    if c.types->BuiltinOf( u ) <> Tko.TY_STRING then return false
    if TermIsWide_( c, argNode ) then return true
    return (StrArgOwnDescriptor_( c, argNode, u ) = false)
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
            dim as MirValue usrc
            '' A CALL RESULT HAS NO ADDRESS: its value IS the descriptor pointer, and
            '' fb_UStrAssign consumes it -- see the caller in lowercall.bas. So is a
            '' PAREN-LESS call or a property, 'TakeU( o.GetU )': LowerAddr answered with
            '' the procedure's CODE address, and fb_UStrAssign read it as a descriptor.
            dim as Tko.Symbol ptr ups = c.syms->SymbolAt( c.info->RefOf( argNode ) )
            dim as boolean upc = false
            if ups <> 0 then upc = (ups->kind = cast( ubyte, Tko.SYM_PROC ))
            if (c.ast->Kind( argNode ) = Tko.N_CALL) orelse upc then
                usrc = LowerExpr( c, argNode )
            else
                usrc = LowerAddr( c, argNode )
            end if
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

'' A USTRING RVALUE AGAINST A USTRING PARAMETER IS COPIED, CALLED ON AND DELETED. Measured,
'' for a user sub and for fb/string.bi's runtime-aliased declarations alike:
''
''   vr = MK( 1 )             fb_UStrAssign( &TMP, -1, vr, -1, 0 )   TAKE( &TMP )
''   vr = fb_UStrUcase( &U )  fb_UStrAssign( &TMP, -1, vr, -1, 0 )   TAKE( &TMP )
''   vr = fb_UStrConcat( .. ) fb_UStrAssign( &TMP, -1, vr, -1, 0 )   fb_UStrStartsWith( &TMP, .. )
''   ... fb_UStrDelete( &TMP ) after the statement
''
'' -- ucase, lcase, trim, ltrim, rtrim, left, right, mid and a 'u & "x"' chain all the
'' same. tiko passed vr itself: nothing released it (fb/fsinfo.bi's 'PathNormalize(
'' PathJoin( r, p ) )' ran the Linux descriptor pool dry after ~530 includes), and the
'' callee's first ustring assignment CONSUMED it, so 'dim s as string = u' then 'len( u )'
'' read 0. This used to ask for a call to a declared PROCEDURE only; the rule is the
'' argument's SHAPE. (A built-in intrinsic consuming a temporary directly -- 'len( ucase(
'' u ) )' -- never comes through the call path.)
''
'' 'anyChain' also copies an ALL-UTF-16 chain, which a ustring parameter leaves to
'' StrDescriptorOf_ and a wide one never reaches -- see WideArgOperand_.
function UStrResultArgTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, _
      byval anyChain as boolean = false ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
    if IsUStringType( c, pt ) = false then return false
    dim as Tko.NodeId an = Unparen_( c, argNode )
    '' UTF-16 only: a narrow or a wide rvalue has its own arm before this one.
    dim as boolean isU = IsUStringType( c, c.types->Unqualify( c.info->TypeOf_( an ) ) )
    dim as MirValue rv
    '' AN LVALUE PASSES ITS OWN DESCRIPTOR; only something with no address is copied.
    select case c.ast->Kind( an )
    case Tko.N_CALL
        '' A CALL, NOT AN ELEMENT: 'oldkeys( i )' is an N_CALL too, and has an address.
        '' fb/map.bi's Reserve loaded the 24 bytes where a pointer belongs. A declared
        '' procedure, or a built-in the resolver bound to nothing ('ucase( u )').
        dim as Tko.ListPayload ptr ucp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, an )].data )]
        if ucp->target = Tko.NODE_NONE then return false
        '' THE STRING INTRINSICS are spelled as calls and decided by their FIRST ARGUMENT,
        '' as LowerUStrIntrin_ decides them -- not by whatever the name binds to.
        dim as boolean intrin = false
        if (c.ast->Kind( ucp->target ) = Tko.N_IDENT) andalso (ucp->count >= 1) then
            dim as Tko.IdentPayload ptr uip = _
                @c.ast->idents[cast( long, c.ast->nodes[cast( long, ucp->target )].data )]
            select case Tko.Text.LowerAscii( c.names->Spelling( uip->name ) )
            case "ucase", "lcase", "trim", "ltrim", "rtrim", "left", "right", "mid"
                intrin = IsUStringType( c, c.info->TypeOf_( _
                    cast( Tko.NodeId, c.ast->children[ucp->first] ) ) )
            end select
        end if
        if intrin then
            '' The intrinsic's descriptor comes from LowerStrRvalue; LowerExpr has no arm
            '' for it and answered nothing, so the argument declined back to vr itself.
            if LowerStrRvalue( c, an, rv ) = false then return false
        else
            if isU = false then return false
            dim as Tko.Symbol ptr ucs = c.syms->SymbolAt( c.info->RefOf( ucp->target ) )
            if ucs = 0 then return false
            if ucs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
            rv = LowerExpr( c, an )
        end if
    '' A PAREN-LESS CALL IS A CALL. 'TakeU( o.GetU )', 'TakeU( FreeU )' and a property
    '' 'o.PU' are ustring RVALUES exactly as 'o.GetU( )' is, and fbc copies all three the
    '' same way -- 'vr = _ZN1T4GETUEi( &O$0, 0 ); fb_UStrAssign( &TMP, -1, vr, -1, 0 )'.
    '' Without this arm a ustring parameter was handed the pool temporary itself, which
    '' the callee's first read consumed ('len( u )' 0), and a WIDE one took LowerAddr's
    '' answer: the procedure's code address, read as a descriptor. A name bound to a
    '' procedure only -- a variable or a field passes its own descriptor.
    case Tko.N_IDENT, Tko.N_MEMBER
        if isU = false then return false
        dim as Tko.Symbol ptr bps = c.syms->SymbolAt( c.info->RefOf( an ) )
        if bps = 0 then return false
        if bps->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
        rv = LowerExpr( c, an )
    case Tko.N_INTRINSIC
        if isU = false then return false
        rv = LowerExpr( c, an )
    case Tko.N_BINARY
        dim as FB.Array( of ulong ) uterms
        FlattenConcat( c, an, uterms )
        if uterms.Count < 2 then return false
        if ConcatTermsAreU_( c, uterms ) = false then return false
        '' ALL UTF-16 ('UTake( a & b )') already builds its one temporary through
        '' StrDescriptorOf_; only a MIXED chain ('u & "x"') came out wrong there.
        dim as boolean mixed = false
        for ti as long = 0 to uterms.Count - 1
            if StrTermFlavour_( c, cast( Tko.NodeId, uterms[ti] ) ) <> STF_UTF16 then mixed = true
        next
        if (mixed = false) andalso (anyChain = false) then return false
        dim as long cslot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
        if cslot < 0 then return false
        dim as MirValue cdst
        cdst.kind = cast( ubyte, MV_LOCAL ) : cdst.ty = cast( ubyte, MT_PTR ) : cdst.id = cslot
        ZeroStrDescriptor( c, cdst )
        if LowerUStrChain( c, cdst, true, uterms, false ) = false then return false
        outSlot = cslot
        outa = cdst
        return true
    case else
        return false
    end select
    if rv.kind = cast( ubyte, MV_NONE ) then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL ) : dst.ty = cast( ubyte, MT_PTR ) : dst.id = slot
    ZeroStrDescriptor( c, dst )
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    PushStrLen_( c, args, -1 )
    args.Push( cast( ulong, rv.kind ) ) : args.Push( cast( ulong, rv.id ) )
    PushStrLen_( c, args, -1 )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_USTR_ASSIGN, args )
    outSlot = slot
    outa = dst
    return true
end function

'' A USTRING RVALUE FOR A WIDE PARAMETER IS COPIED, AND ITS DATA POINTER PASSED. Measured,
'' against 'byval p as wstring ptr' and 'byref w as wstring' alike:
''
''     FBUSTRING* vr$3 = _ZN1T4GETUEi( &O$0, 0 );
''     fb_UStrAssign( (void*)&TMP$10$0, -1ll, (void*)vr$3, -1ll, 0 );
''     TAKEW( (uint16*)*(uint16**)&TMP$10$0 );
''     fb_UStrDelete( (FBUSTRING*)&TMP$10$0 );
''
'' -- for a call with or without parentheses, a property, 'ucase( u )', 'u1 & u2' and
'' '"x" & u'. WideOperand_ owns none of them (a ustring is not WSTRING-typed), so every
'' one fell to NarrowToWideTemp_. A paren-less call or a property reached UStrDataArg_,
'' whose LowerAddr answered with the PROCEDURE'S address and loaded its first eight bytes
'' of machine code as the data pointer: fbx's CISaveFileDialog example died in
'' 'OutputDebugStringW( psfd.GetResultString )'. Every other rvalue went through
'' fb_StrAssign as if it were NARROW, and the callee saw one character. A ustring LVALUE
'' is not claimed -- its own data pointer is already UTF-16, see UStrDataArg_ -- and
'' anything else is WideOperand_'s, unchanged. The temporary joins 'temps'.
function WideArgOperand_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byref outa as MirValue, _
      byref temps as FB.Array( of ulong ), byref tempTypes as FB.Array( of ulong ) ) as boolean

    dim as Tko.TypeId ut = c.types->Builtin( Tko.TY_USTRING )
    dim as MirValue ud
    dim as long slot = -1
    if UStrResultArgTemp_( c, argNode, ut, ud, slot, true ) = false then
        return WideOperand_( c, argNode, outa )
    end if
    temps.Push( cast( ulong, slot ) )
    tempTypes.Push( cast( ulong, ut ) )
    dim as MirInst fa
    fa.op = cast( ushort, M_FIELD_ADDR ) : fa.ty = cast( ubyte, MT_PTR )
    fa.a = ud : fa.imm = 0
    dim as MirValue pa = Emit( c, fa )
    if pa.kind = cast( ubyte, MV_NONE ) then return false
    outa = LowerExprLoad( c, pa, MT_PTR )
    return (outa.kind <> cast( ubyte, MV_NONE ))
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

'' A UDT THAT CASTS ONLY TO A WSTRING, against a narrow 'byref as string', is a
'' CONVERSION and not an address. Measured on fbc, a BSTRING-shaped type -- 'cast( )
'' byref as const wstring' and 'cast( ) as any ptr' -- against 'byref s as string':
''
''     uint16* vr$1 = _ZN1BcvwEv( BS$1 );
''     fb_WstrAssignToA( (void*)&TMP$2$1, -1ll, vr$1, 0 );
''     _ZN1D3ADDER8FBSTRINGj( THIS$1, &TMP$2$1, 0u );
''     fb_StrDelete( (FBSTRING*)&TMP$2$1 );
''
'' No arm of the call's string-parameter branch owned it -- the argument is not
'' wide-typed -- so it reached LowerAddr and the callee was handed the OBJECT where an
'' FBSTRING belongs. It lowered and verified. The caller tries StrDescriptorOf_ first,
'' which keeps a narrow cast ahead of this one; a USTRING parameter is not measured and
'' is left alone. fbc copies nothing back, so neither does this.
function WideUdtStrArgTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref temps as FB.Array( of ulong ), _
      byref tempTypes as FB.Array( of ulong ) ) as boolean

    if argNode = Tko.NODE_NONE then return false
    if IsUStringType( c, pt ) then return false
    dim as Tko.TypeId at = c.types->Unqualify( c.info->TypeOf_( argNode ) )
    if WideCastOverload_( c, at ) = Tko.SYMBOL_NONE then return false
    dim as Tko.TypeId nsp = c.types->Builtin( Tko.TY_STRING )
    dim as long slot = -1
    if ByvalStrTemp_( c, argNode, nsp, outa, slot ) = false then return false
    temps.Push( cast( ulong, slot ) )
    tempTypes.Push( cast( ulong, nsp ) )
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

'' 'str( u )' OVER A USTRING IS THE CONVERSION TO NARROW, not the identity. Measured:
'' fbc emits 'fb_UStrAssignToA( &TMP, -1, U, -1, 0, -1 )' for a var-len ustring, a ustring
'' rvalue ('u & "c"') and a 'ustring * N' alike -- the assignment 'dim s as string = u'
'' makes. Taken as the identity, the UTF-16 buffer went out as narrow text ('ab' read as
'' 'a', NUL) and a 'ustring * N' came back empty. fbsqlite's hToUtf8 is 'return str(
'' textValue )', so every SQL string it built reached SQLite that way.
''
'' FALSE when no term of the operand is a ustring: the caller's identity path is right
'' for those. TRUE otherwise, with 'outv' the narrow temporary -- or MV_NONE if it could
'' not be filled, which the caller reports as a decline.
function UStrOperandToNarrow_ _
    ( byref c as Ctx, byval sa as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, sa, terms )
    dim as boolean anyU16 = false
    for i as long = 0 to terms.Count - 1
        if StrTermFlavour_( c, cast( Tko.NodeId, terms[i] ) ) = STF_UTF16 then anyU16 = true
    next
    if anyU16 = false then return false

    dim as MirValue none_
    outv = none_
    dim as long uslot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if uslot < 0 then return true
    dim as MirValue ud
    ud.kind = cast( ubyte, MV_LOCAL )
    ud.ty = cast( ubyte, MT_PTR )
    ud.id = uslot
    ZeroStrDescriptor( c, ud )
    if LowerStringAssignToSlot( c, uslot, sa ) = false then return true
    '' Released at the END OF THE STATEMENT, beside the other string temporaries.
    c.strTemps.Push( cast( ulong, uslot ) )
    outv = ud
    return true
end function

'' A NARROW ARGUMENT FOR A 'byref as ustring' PARAMETER, wherever that parameter is met
'' outside the ordinary call path: a constructor called explicitly, one run for 'dim x as
'' T = init', one run as an implicit conversion to a byval UDT, and 'operator []'.
'' Measured, 'Take( "lit" )' over a byval DbValue with 'constructor( byref textValue as
'' ustring )':
''
''     fb_UStrAssign( &TMP_u, -1, (uint16[]){...}, <len>, 0 )
''     _ZN7DBVALUEC1ER9FBUSTRING( &TMP, &TMP_u )
''
'' lowercall.bas had this arm; none of these did, so a literal's ADDRESS or a narrow
'' variable's own descriptor went where an FBUSTRING* belongs, and fbsqlite bound every
'' text value as empty or garbage.
''
'' FALSE, touching nothing, when the parameter is not a ustring or the argument is not
'' narrow. TRUE with 'outv' the temporary's address, on the statement's string
'' temporaries with its USTRING flavour so that fb_UStrDelete releases it.
function UStrParamArgTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if (argNode = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )
    if IsUStringType( c, pu ) = false then return false
    dim as Tko.TypeId ut = c.types->Builtin( Tko.TY_USTRING )
    dim as long slot = -1
    '' A USTRING RVALUE IS COPIED, as at a call -- UStrResultArgTemp_. Measured,
    '' 'Val( ucase( u ) )' and 'Val( u & "!" )' over 'constructor( byref t as ustring )'
    '' printed ' 4 [ROOM]' and ' 5 [room!]' under fbc and ' 0 []' under tiko:
    '' test_functions' 'DbValue( ucase( cell.AsText( ) ) & "!" )' returned "".
    if NarrowStrArg_( c, argNode ) = false then
        if UStrResultArgTemp_( c, argNode, ut, outv, slot ) = false then return false
    elseif ByvalStrTemp_( c, argNode, ut, outv, slot ) = false then
        return false
    end if
    if slot >= 0 then
        c.f->locals[slot].frontendType = ut
        c.strTemps.Push( cast( ulong, slot ) )
    end if
    return true
end function

'' THE NARROW TWIN, for a 'byref as string' parameter met outside the ordinary call path --
'' a self-operator: 'dws += "- Missing Ticker Symbol." & vbcrlf' over DWSTRING's
'' '+=( byref ansiStr as string )'. Measured, fbc copies the rvalue into a temporary:
''
''     fb_StrAssign( &TMP, -1, "lit", 4, 0 );  _ZN1TpLER8FBSTRING( &V, &TMP );  fb_StrDelete( &TMP )
''
'' FALSE, touching nothing, when the parameter is not a narrow var-length string or the
'' argument already owns a descriptor it can pass -- a variable, a field, an element.
function NarrowParamArgTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if (argNode = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )
    if (IsStringType( c, pu ) = false) orelse IsUStringType( c, pu ) then return false
    if StrArgOwnDescriptor_( c, argNode, pu ) then return false
    dim as long slot = -1
    if ByvalStrTemp_( c, argNode, pu, outv, slot ) = false then return false
    if slot >= 0 then
        c.f->locals[slot].frontendType = pu
        c.strTemps.Push( cast( ulong, slot ) )
    end if
    return true
end function


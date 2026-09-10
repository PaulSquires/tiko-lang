'' lowerbuiltin.bas -- FreeBASIC's BUILT-IN PROCEDURES: the names fbc predeclares and
'' lowers straight to a runtime call.
''
'' Split out of lowerintr.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.

'' FreeBASIC's BUILT-IN PROCEDURES -- the ones fbc predeclares and lowers straight to a
'' runtime call. They are not keywords and not in the intrinsic registry: a program
'' names them like any other procedure, nothing declares them, and tiko-lang counted every
'' one as an unbound callee.
''
'' Measured from fbc's own C:
''
''     allocate( 16 )        -> malloc( 16ull )
''     callocate( 4, 8 )     -> calloc( 4ull, 8ull )
''     callocate( 16 )       -> calloc( 16ull, 1ull )     one argument means size 1
''     reallocate( p, 32 )   -> realloc( p, 32ull )
''     deallocate( p )       -> free( p )
''     mutexcreate( )        -> fb_MutexCreate( )
''     mutexlock( m )        -> fb_MutexLock( m )
''     fb_Assert( f, l, p, e ) -> fb_Assert( char*, int64, char*, char* )
''
'' fb_Assert is in the list because fbc predeclares it too: the COM tests write their
'' own 'assert_' macro around it with nothing declaring it anywhere, and fbc compiles
'' them. 2,054 unlowered calls came from that one macro.
private function BuiltinProcRtl _
    ( byref nm as string, byref argc as long, byref retTy as MirType, _
      byval unboundOnly as boolean = false ) as RtlId

    select case nm
    case "allocate"     : retTy = MT_PTR  : return RTL_MALLOC
    case "callocate"    : retTy = MT_PTR  : return RTL_CALLOC
    case "reallocate"   : retTy = MT_PTR  : return RTL_REALLOC
    case "deallocate"   : retTy = MT_VOID : return RTL_FREE
    case "mutexcreate"  : retTy = MT_PTR  : return RTL_MUTEX_CREATE
    case "mutexdestroy" : retTy = MT_VOID : return RTL_MUTEX_DESTROY
    case "mutexlock"    : retTy = MT_VOID : return RTL_MUTEX_LOCK
    case "mutexunlock"  : retTy = MT_VOID : return RTL_MUTEX_UNLOCK
    case "fb_assert"    : retTy = MT_VOID : return RTL_ASSERT
    '' 'clear dst, value, bytes' -- libc memset, and the DESTINATION is passed by
    '' ADDRESS: fbc writes 'memset( (void*)A, 0, 16ull )' for 'clear a(0), 0, 16'.
    case "clear"        : retTy = MT_VOID : return RTL_MEMSET
    end select

    '' ...AND THE NAMES THAT REACH HERE ONLY WHEN NOTHING ELSE BOUND THEM. These
    '' are FreeBASIC runtime procedures spelled as ordinary identifiers rather
    '' than keywords, so the callee lookup finds nothing and the call declined:
    '' 'dim as long a = run( cmd )' is 'vr$3 = fb_Run( &CMD$0, vr$1 )' to fbc,
    '' and 'w = width( )' is 'fb_Width( -1, -1 )'.
    ''
    '' ONLY THE ONES WHOSE ENTRY POINT DOES NOT DEPEND ON THE ARGUMENT'S TYPE.
    '' IntrinsicProcPtrRtl_ below maps about fifty names and CANNOT be used for
    '' this: its own header says it answers with the FIRST overload -- RTL_HEX_B
    '' rather than RTL_HEX_L -- because that is what 'procptr( hex )' needs. Using
    '' it here would give 'hex( i )' the byte entry point, which is a wrong call
    '' where there used to be none.
    if unboundOnly then
        select case nm
        '' 'run' AND 'width' KEEP THEIR ARITY GUARD AND SO STILL DECLINE WHERE THE
        '' CALL IS SHORT. Measured: 'run( cmd )' is
        '' 'fb_Run( &CMD, fb_StrAllocTempDescZEx( "", 0 ) )' -- a DEFAULTED second
        '' argument this does not synthesise -- and 'width( )' is
        '' 'fb_Width( -1, -1 )'. Listing them costs nothing and is wrong nowhere:
        '' LowerBuiltinProc refuses a wrong arity, so the fully written spellings
        '' lower and the short ones decline as they did.
        case "run"          : retTy = MT_I32  : return RTL_RUN
        case "width"        : retTy = MT_I32  : return RTL_WIDTH
        case "chain"        : retTy = MT_I32  : return RTL_CHAIN
        '' 'seek( n )' -- THE FUNCTION SPELLING, which is a DIFFERENT entry point
        '' from the statement's: measured, 'dim as longint p = seek( 1 )' is
        '' 'fb_FileTell( 1 )' where 'seek #1, 2' is fb_FileSeekLarge. A comment
        '' in lowerdev.bas claimed this spelling 'already lowers'; it did not.
        case "seek"         : retTy = MT_I64  : return RTL_FILE_TELL
        '' 'end( n )' -- THE PARENTHESISED SPELLING of the END statement, which
        '' parses as a call and so never reached the statement's own case.
        '' Measured: 'if c then end( 1 )' is 'fb_End( 1 );'.
        case "end"          : retTy = MT_VOID : return RTL_END
        case "bsave"        : retTy = MT_I32  : return RTL_BSAVE
        case "bload"        : retTy = MT_I32  : return RTL_BLOAD
        case "dylibload"    : retTy = MT_PTR  : return RTL_DYLIB_LOAD
        case "dylibsymbol"  : retTy = MT_PTR  : return RTL_DYLIB_SYMBOL
        case "dylibfree"    : retTy = MT_VOID : return RTL_DYLIB_FREE
        end select
    end if
    return RTL_NONE
end function

'' Lower a call to one of them. Returns false when the callee is not a built-in, so an
'' ordinary unbound callee still declines as it did.
function LowerBuiltinProc _
    ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval argFirst as long, _
      byval argCount as long, byref outv as MirValue, _
      byval unboundOnly as boolean = false ) as boolean

    if calleeNode = Tko.NODE_NONE then return false
    if c.ast->Kind( calleeNode ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, calleeNode )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' ASSERT AND ASSERTWARN EMIT NOTHING, and their argument is NOT EVALUATED.
    '' Measured by running fbc's output: without -g, 'assert( f( ) = 1 )' where f
    '' prints does not print, and no fb_Assert appears in the generated C at all. tiko-lang
    '' has no -g equivalent and defines __FB_DEBUG__ as 0, so this is fbc's behaviour
    '' for every build tiko-lang can produce. Declining instead was 1,346 statements.
    if (nm = "assert") orelse (nm = "assertwarn") then
        outv = NoVal( )
        return true
    end if

    dim as long argc = argCount
    dim as MirType retTy = MT_VOID
    dim as RtlId r = BuiltinProcRtl( nm, argc, retTy, unboundOnly )
    if r = RTL_NONE then return false

    '' The declared arity, so a wrong-arity call is left to decline rather than being
    '' handed to the runtime with a short stack.
    dim as long want = RtlArity( r )
    dim as boolean callocOneArg = (r = RTL_CALLOC) andalso (argCount = 1)
    '' 'width' DEFAULTS EVERY ARGUMENT IT IS NOT GIVEN, to -1. Measured:
    ''
    ''   width( )         fb_Width( -1, -1 )
    ''   width( 80 )      fb_Width( 80, -1 )
    ''   width( 80, 25 )  fb_Width( 80, 25 )
    ''
    '' The arity guard refused the short forms outright, so 'w = loword( width( ) )'
    '' produced no value and the assignment around it declined.
    dim as long widthShort = 0
    if (r = RTL_WIDTH) andalso (argCount < want) then widthShort = want - argCount
    '' 'run( cmd )' DEFAULTS ITS SECOND ARGUMENT TO THE EMPTY STRING, which fbc
    '' spells 'fb_StrAllocTempDescZEx( "", 0 )' -- a temporary descriptor over a
    '' zero-length literal, not a null pointer.
    dim as boolean runShort = (r = RTL_RUN) andalso (argCount = want - 1)
    '' 'bsave( file, buf )' DEFAULTS ITS LAST TWO to zero. Measured, both
    '' spellings emit the same call:
    '' 'fb_GfxBsave( &F, B, 0u, (void*)0ull )'.
    dim as boolean bsaveShort = (r = RTL_BSAVE) andalso (argCount = want - 2)
    '' 'bload( file, buf )' DEFAULTS ITS LAST ONE the same way:
    '' 'fb_GfxBload( &F, (void*)0ull, (void*)0ull )' -- measured, and the arity
    '' guard refused the short form outright.
    dim as boolean bloadShort = (r = RTL_BLOAD) andalso (argCount = want - 1)
    dim as boolean widthOk = (widthShort > 0)
    dim as boolean shortOk = widthOk orelse runShort
    shortOk = shortOk orelse bsaveShort
    shortOk = shortOk orelse bloadShort
    dim as boolean arityBad = (argCount <> want)
    dim as boolean notCalloc = (callocOneArg = false)
    dim as boolean notShort = (shortOk = false)
    dim as boolean refuse = arityBad andalso notCalloc
    refuse = refuse andalso notShort
    if refuse then return false

    dim as FB.Array( of ulong ) args
    for i as long = 0 to argCount - 1
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[argFirst + i] )

        '' 'clear BYVAL p, 0, n' SAYS THE ARGUMENT ALREADY IS THE ADDRESS.
        ''
        '' That is the whole point of the spelling: 'clear @li, ...' takes the address
        '' of a TEMPORARY holding @li and clears the temporary -- fbc's own warning 50 --
        '' while 'clear byval @li, ...' clears li. Measured, both from one probe:
        ''
        ''     clear @li, 0, 8         TMP = &LI$0;  memset( &TMP, 0, 8 )
        ''     clear byval @li, 0, 8   memset( (void*)&LI$0, 0, 8 )
        ''
        '' KW_BYVAL was unwrapped in exactly one place in the lowerer -- the user-call
        '' path -- so here the wrapper reached LowerAddr, ConstOf and LowerExpr in turn
        '' and none of them knew what it was.
        dim as boolean forcedByval = false
        if c.ast->Kind( a ) = Tko.N_UNARY then
            dim as Tko.UnaryPayload ptr bup = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a )].data )]
            if cast( Tko.TokenKind, bup->op ) = Tko.KW_BYVAL then
                forcedByval = true
                a = bup->operand
            end if
        end if
        if forcedByval then
            dim as MirValue bv = LowerExpr( c, a )
            if bv.kind = cast( ubyte, MV_NONE ) then return false
            bv = Coerce( c, bv, MT_PTR, false )
            if bv.kind = cast( ubyte, MV_NONE ) then return false
            args.Push( cast( ulong, bv.kind ) )
            args.Push( cast( ulong, bv.id ) )
            continue for
        end if

        '' CLEAR's first argument is an LVALUE whose ADDRESS is passed, not its value.
        if (r = RTL_MEMSET) andalso (i = 0) then
            dim as MirValue da = LowerAddr( c, a )
            if da.kind = cast( ubyte, MV_NONE ) then
                '' NOT AN LVALUE. 'clear' takes 'byref as any', and fbc has three
                '' answers for an argument with no address of its own -- measured, all
                '' three from the same probe:
                ''
                ''   clear 0            memset( (void*)0ll, ... )      the VALUE is the
                ''                                                     address
                ''   clear @global_i    memset( (void*)&GLOBAL_I$, ... )   a link-time
                ''                                                     constant, used
                ''                                                     directly
                ''   clear @local_i     TMP = &LOCAL_I$;               a TEMPORARY, and
                ''                      memset( (void*)&TMP, ... )     ITS address --
                ''                                                     so the clear hits
                ''                                                     the temp, not the
                ''                                                     local
                ''
                '' The third is the point of
                '' warnings/param-byref-as-any-suspicious-temp-var.bas, which is named
                '' for fbc's own warning 50 on exactly that line. Reproducing it means
                '' reproducing a clear that does nothing, which is what fbc does.
                '' A CONSTANT IS THE ADDRESS. Asked of the AST, not of the lowered
                '' value: a literal comes back as a const INSTRUCTION here, which is
                '' indistinguishable by kind from anything else computed.
                dim as Tko.Check.ConstVal acv = Tko.Check.ConstOf( _
                    *c.ast, a, *c.srcMgr, *c.names, c.types->target.pointerBits, _
                    c.syms, Tko.SCOPE_GLOBAL )
                if acv.known then
                    args.Push( cast( ulong, MV_CONST_INT ) )
                    args.Push( cast( ulong, cast( long, acv.value ) ) )
                    continue for
                end if
                dim as MirValue vv = LowerExpr( c, a )
                if vv.kind = cast( ubyte, MV_NONE ) then return false
                '' A GLOBAL's address is a link-time constant and goes straight in.
                if vv.kind = cast( ubyte, MV_GLOBAL ) then
                    args.Push( cast( ulong, vv.kind ) )
                    args.Push( cast( ulong, vv.id ) )
                    continue for
                end if
                dim as long pbytes = c.types->target.pointerBits \ 8
                dim as long tslot = NewTempLocal( c, MT_PTR, pbytes )
                if tslot < 0 then return false
                dim as MirValue tv
                tv.kind = cast( ubyte, MV_LOCAL )
                tv.ty = cast( ubyte, MT_PTR )
                tv.id = tslot
                StoreThrough( c, tv, Coerce( c, vv, MT_PTR, false ) )
                args.Push( cast( ulong, tv.kind ) ) : args.Push( cast( ulong, tv.id ) )
                continue for
            end if
            args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
            continue for
        end if
        '' BSAVE AND BLOAD TAKE A STRING DESCRIPTOR, not a char pointer. Measured:
        ''
        ''     bsave( "foo.bmp", 0 )
        ''     vr = fb_StrAllocTempDescZEx( (char*)"foo.bmp", 7ll );
        ''     fb_GfxBsave( (FBSTRING*)vr, (void*)0ull, 0u, (void*)0ull );
        ''
        '' -- and tiko-lang handed the LITERAL's own address straight to a parameter
        '' declared FBSTRING*, so the runtime read a descriptor out of the string's
        '' bytes. Nothing declined. gfx/bsave-nullptr-fb.bas and -qb.bas.
        ''
        '' A string VARIABLE was already right, because its address IS its
        '' descriptor -- which is what hid this: only the literal is wrong, and the
        '' corpus writes the variable form far more often. KILL and the rest of the
        '' file family go through the prelude's declared procedures, where the
        '' ordinary call path wraps a literal already.
        ''
        '' The RTL signature cannot say this: every one of these parameters is 'p'.
        dim as boolean wantsStrDesc = false
        if i = 0 then wantsStrDesc = (r = RTL_BSAVE) orelse (r = RTL_BLOAD)
        '' ...AND THE DYNAMIC-LIBRARY PAIR, whose parameters read 'p' in the RTL table
        '' and are FBSTRING* in fbc's own C. Measured:
        ''
        ''     void* fb_DylibLoad( FBSTRING* );
        ''     void* fb_DylibSymbol( void*, FBSTRING* );
        ''     vr$1 = fb_DylibLoad( (FBSTRING*)vr$0 );
        ''     vr$3 = fb_DylibSymbol( D$0, (FBSTRING*)vr$2 );
        ''
        '' fb_Run and fb_Chain are the same fact, measured in the same run:
        ''
        ''     int32 fb_Run( FBSTRING*, FBSTRING* );
        ''     int32 fb_Chain( FBSTRING* );
        ''     vr$4  = fb_Run( (FBSTRING*)&S$0, (FBSTRING*)vr$2 );
        ''     vr$12 = fb_Chain( (FBSTRING*)&S$0 );
        ''
        '' -- a temporary descriptor for a literal, the variable's own address for a
        '' variable. Without it the descriptor was lowered as a VALUE and coerced to a
        '' pointer, which came out as 'bitcast' then 'trunc' then 'zext' over a
        '' 24-byte aggregate: two of the corpus's codegen failures, and a call that
        '' would have handed the runtime rubbish had it reached one.
        if i = 0 then
            if r = RTL_DYLIB_LOAD then wantsStrDesc = true
            if r = RTL_CHAIN then wantsStrDesc = true
            if r = RTL_RUN then wantsStrDesc = true
        end if
        if i = 1 then
            if r = RTL_DYLIB_SYMBOL then wantsStrDesc = true
            if r = RTL_RUN then wantsStrDesc = true
        end if
        if wantsStrDesc then
            dim as MirValue sdv
            if StrDescriptorOf_( c, a, sdv ) then
                args.Push( cast( ulong, sdv.kind ) )
                args.Push( cast( ulong, sdv.id ) )
                continue for
            end if
        end if

        dim as MirValue av = LowerExpr( c, a )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        av = CoerceTy( c, av, RtlParamType( r, i, (c.types->target.pointerBits = 32) ), c.info->TypeOf_( a ) )
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    next
    '' 'callocate( n )' -- fbc supplies the element size itself.
    if callocOneArg then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 1 )
    end if

    '' ...and the defaulted tails, in the same place and for the same reason.
    for k as long = 1 to widthShort
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, -1 ) )
    next
    if bsaveShort then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if
    if bloadShort then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if
    if runShort then
        dim as FB.Array( of ulong ) ta
        ta.Push( cast( ulong, MV_GLOBAL ) )
        ta.Push( cast( ulong, c.m->AddStringLiteral( "", *c.names ) ) )
        ta.Push( cast( ulong, MV_CONST_INT ) ) : ta.Push( 0 )
        dim as MirValue ev = EmitRtl( c, RTL_STR_TEMPZ, ta )
        if ev.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, ev.kind ) ) : args.Push( cast( ulong, ev.id ) )
    end if

    outv = EmitRtl( c, r, args )
    if retTy = MT_VOID then return true
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' 'strptr( x )' -- THE CHARACTER DATA POINTER, which is a different thing per flavour
'' and was lowered for none of them:
''
''   strptr( s )   over a STRING        '*(char**)&S'    the descriptor's first field
''   strptr( z )   over a 'zstring * N' '(char*)Z'       the buffer's own address
''   strptr( w )   over a 'wstring * N' '(uint16*)W'     likewise, and WIDE
''
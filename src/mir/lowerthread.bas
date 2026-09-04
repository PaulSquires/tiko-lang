'' lowerthread.bas -- 'threadcall f( a, b )'.
''
'' A THREAD CALL IS A MARSHALLED CALL, not a call. fbc hands fb_ThreadCall the
'' procedure's ADDRESS, its calling convention, a zero, the argument COUNT, and then a
'' (TYPE CODE, ADDRESS) PAIR for every argument -- no argument travels by value.
'' Measured, and the declaration is the one already in the runtime table:
''
''     void* fb_ThreadCall( void*, int32, int64, int32, ... );
''
''     threadcall NoArgs                fb_ThreadCall( (void*)&NOARGS, 0, 0ll, 0 )
''     threadcall Scal( 1, 2.5, 3 )     fb_ThreadCall( (void*)&SCAL, 0, 0ll, 3,
''                                          8ll, &TMP$4$0, 11ll, &TMP$5$0, 4ll, &TMP$6$0 )
''
'' THE TYPE CODES ARE MEASURED, one probe per type:
''
''     byte 2   ubyte 3   short 4   ushort 5   long 6   ulong 7
''     longint / integer(64) 8      ulongint 9    single 10   double 11
''     any ptr, zstring ptr, wstring ptr, string, ARRAY, and EVERY BYREF   13
''     an ENUM is its underlying integer, so 8 on win64 and 6 on win32
''
'' -- and the SECOND fixed argument is the CALLING CONVENTION: 1 for cdecl (and for a
'' procedure inside an EXTERN "C" block), 0 for stdcall and for the default. The third
'' never moved in any probe and is passed as the zero fbc passes.
''
'' WHAT IS NOT MODELLED HERE DECLINES rather than guessing:
''
''   - a BYVAL UDT argument, which fbc describes with a COMPOSITE descriptor --
''     '12, <fieldcount>, <code per field>', recursive, with a single-field type
''     collapsing to its field's own code. It also describes a 'zstring * N' FIELD as
''     one ubyte, which is a defect rather than a rule; both are recorded in HANDOFF.
''   - every shape fbc REFUSES: a boolean argument, a byref wstring, a union, a
''     bitfield, a UDT holding an array or a string, a pascal procedure, a variadic
''     cdecl one, a FUNCTION rather than a sub, an instance-qualified member call and a
''     procedure POINTER. Those want a diagnostic; declining is what this build has.
private function ThreadTypeCode_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref ok as boolean ) as longint

    ok = false
    if t = Tko.TYPE_NONE then return 0
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )

    '' Everything that travels as a POINTER shares one code.
    select case c.types->Kind( u )
    case Tko.TK_POINTER, Tko.TK_ARRAY, Tko.TK_PROC
        ok = true
        return 13
    case Tko.TK_ENUM
        u = c.types->Builtin( Tko.TY_INTEGER )
    case Tko.TK_UDT
        '' The composite descriptor is not modelled -- see the header.
        return 0
    end select
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return 0

    dim as boolean is32 = (c.types->target.pointerBits = 32)
    select case c.types->BuiltinOf( u )
    case Tko.TY_BYTE     : ok = true : return 2
    case Tko.TY_UBYTE    : ok = true : return 3
    case Tko.TY_SHORT    : ok = true : return 4
    case Tko.TY_USHORT   : ok = true : return 5
    case Tko.TY_LONG     : ok = true : return 6
    case Tko.TY_ULONG    : ok = true : return 7
    case Tko.TY_LONGINT  : ok = true : return 8
    case Tko.TY_ULONGINT : ok = true : return 9
    case Tko.TY_SINGLE   : ok = true : return 10
    case Tko.TY_DOUBLE   : ok = true : return 11
    case Tko.TY_INTEGER
        ok = true
        return iif( is32, 6, 8 )
    case Tko.TY_UINTEGER
        ok = true
        return iif( is32, 7, 9 )
    case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_FIXSTR
        ok = true
        return 13
    end select
    '' BOOLEAN lands here on purpose: fbc REFUSES it, error 288.
    return 0
end function

'' The callee a 'threadcall' names, with its argument list. Both spellings reach here:
'' 'threadcall f( 1 )' is an N_CALL and 'threadcall f' a bare name.
declare function ThreadCalleeOf_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byref outFirst as long, _
      byref outCount as long ) as Tko.SymbolId

private function ThreadCalleeOf_ _
    ( byref c as Ctx, byval it as Tko.NodeId, byref outFirst as long, _
      byref outCount as long ) as Tko.SymbolId

    outFirst = 0
    outCount = 0
    if it = Tko.NODE_NONE then return Tko.SYMBOL_NONE
    if c.ast->Kind( it ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, it )].data )]
        if lp->target = Tko.NODE_NONE then return Tko.SYMBOL_NONE
        outFirst = lp->first
        outCount = lp->count
        '' A QUALIFIED CALLEE IS STILL A CALLEE, and the same namespace test applies.
        if c.ast->Kind( lp->target ) = Tko.N_MEMBER then
            dim as long qf, qc
            return ThreadCalleeOf_( c, lp->target, qf, qc )
        end if
        return c.info->RefOf( lp->target )
    end if
    if c.ast->Kind( it ) = Tko.N_IDENT then return c.info->RefOf( it )

    '' 'threadcall ThreadCallNS.ns' -- A NAMESPACE-QUALIFIED CALLEE, which is a member
    '' access over a namespace and not over an object. An INSTANCE-qualified one is
    '' fbc error 289, so the base has to be a namespace and not merely resolve to a
    '' procedure: 'bc.m( )' must keep declining rather than call the member with no
    '' receiver.
    if c.ast->Kind( it ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr mb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, it )].data )]
        dim as Tko.Symbol ptr bs = c.syms->SymbolAt( c.info->RefOf( mb->lhs ) )
        if bs = 0 then return Tko.SYMBOL_NONE
        if bs->kind <> cast( ubyte, Tko.SYM_NAMESPACE ) then return Tko.SYMBOL_NONE
        return c.info->RefOf( it )
    end if
    return Tko.SYMBOL_NONE
end function

function LowerThreadCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if cast( Tko.TokenKind, sp->op ) <> Tko.KW_THREADCALL then return false
    if sp->count <> 1 then return false
    dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first] )

    dim as long aFirst, aCount
    dim as Tko.SymbolId callee = ThreadCalleeOf_( c, it, aFirst, aCount )
    if callee = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    if cs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false

    '' A FUNCTION IS NOT A THREAD CALL -- fbc error 289, "Expected sub". Neither is a
    '' PASCAL one, error 288.
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp->a <> Tko.NODE_NONE then return false
    if (pp->extra and Tko.PF_PASCAL) <> 0 then return false

    dim as MirValue fa = FuncAddrOf( c, callee )
    if fa.kind = cast( ubyte, MV_NONE ) then return false

    '' EVERY ARGUMENT LOWERED BEFORE ANYTHING IS PUSHED. A thread call that gives up
    '' half way would leave its temporaries and its stores behind and read as lowered.
    dim as FB.Array( of ulong ) args
    dim as FB.Array( of ulong ) strTemps
    dim as FB.Array( of ulong ) strTempTypes
    args.Push( cast( ulong, fa.kind ) ) : args.Push( cast( ulong, fa.id ) )
    dim as long conv = 0
    if (pp->extra and Tko.PF_CDECL) <> 0 then conv = 1
    if (pp->extra and Tko.PF_FOREIGN) <> 0 then conv = 1
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, conv ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    '' THE COUNT COMES FROM THE CALLEE, not from the call. A DEFAULTED PARAMETER IS
    '' PASSED like any other: measured, 'sub two( byval a as integer, opt as integer
    '' = 13 )' called as 'threadcall two( 5 )' is
    ''
    ''     TMP$4$0 = 13ll;
    ''     fb_ThreadCall( &TWO, 0, 0ll, 2, 8ll, &TMP$3$0, 8ll, &TMP$4$0 )
    ''
    '' -- TWO arguments, the written one and the default. tiko-lang passed the
    '' written count and stopped there, and fb_ThreadCall is VARIADIC, so nothing
    '' complained: the thread read an uninitialised 'opt'. Lowered, verified, and
    '' wrong. The ordinary call path has done this since it was written.
    dim as long nparams = ParamCountOf( c, callee )
    dim as long slots = aCount
    if (nparams > slots) andalso (IsVariadicProc( c, callee ) = false) then
        slots = nparams
    end if
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, slots ) )

    dim as long pbytes = c.types->target.pointerBits \ 8
    for i as long = 0 to slots - 1
        dim as Tko.NodeId ae = Tko.NODE_NONE
        if i < aCount then ae = cast( Tko.NodeId, c.ast->children[aFirst + i] )
        if ae <> Tko.NODE_NONE then
            if c.ast->Kind( ae ) = Tko.N_ELIDED then ae = Tko.NODE_NONE
        end if
        if ae = Tko.NODE_NONE then ae = ParamDefaultAt( c, callee, i )
        if ae = Tko.NODE_NONE then return false
        '' 'byval expr' AT A CALL SITE IS AN N_UNARY, and it is transparent here: fbc
        '' writes the same 'fb_ThreadCall( &S3, 0, 0ll, 1, 13ll, &TMP$2$0 )' with the
        '' byval as without it. Unstripped, the argument was classified as a unary
        '' expression, LowerThreadCall_ returned false, and the whole assignment
        '' declined -- while the ordinary call path had stripped it since it was
        '' written. threads/threadcall.bas:166.
        '' ...AND AN EXPLICIT 'byval' AGAINST A BYREF PARAMETER MEANS THE VALUE IS
        '' THE REFERENCE, so it is remembered rather than merely stripped.
        dim as boolean forcedByval = false
        if c.ast->Kind( ae ) = Tko.N_UNARY then
            dim as Tko.UnaryPayload ptr tup = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, ae )].data )]
            if cast( Tko.TokenKind, tup->op ) = Tko.KW_BYVAL then
                forcedByval = true
                ae = tup->operand
            end if
        end if
        if c.ast->Kind( ae ) = Tko.N_ELIDED then return false
        dim as Tko.TypeId pt = ParamTypeAt( c, callee, i )
        if pt = Tko.TYPE_NONE then return false
        dim as boolean byref_ = ParamIsByref( c, callee, i )

        dim as boolean codeOk = false
        dim as longint code = 0
        if byref_ orelse ParamIsArray( c, callee, i ) then
            '' EVERY BYREF IS 13, whatever it refers to: the pointee type is erased.
            code = 13
            codeOk = true
        else
            code = ThreadTypeCode_( c, pt, codeOk )
        end if
        if codeOk = false then return false

        dim as MirValue av
        if ParamIsArray( c, callee, i ) then
            '' AN ARRAY TRAVELS AS ITS DESCRIPTOR, and the descriptor's ADDRESS goes in
            '' a pointer temporary like any other byref.
            dim as MirValue adv
            if ArrayDescArg_( c, ae, true, adv ) = false then return false
            dim as long aslot = NewTempLocal( c, MT_PTR, pbytes )
            if aslot < 0 then return false
            av.kind = cast( ubyte, MV_LOCAL )
            av.ty = cast( ubyte, MT_PTR )
            av.id = aslot
            StoreThrough( c, av, adv )
        elseif byref_ then
            '' A POINTER TEMPORARY HOLDING THE ADDRESS, and the temporary's own address
            '' is what is passed. Measured: 'int64* TMP$4$0; TMP$4$0 = &IV$0;
            '' fb_ThreadCall( ..., 13ll, &TMP$4$0 )'.
            '' 'byval @bv' HAS NO ADDRESS OF ITS OWN -- it IS one. Asking LowerAddr
            '' for the address of an address-of gave MV_NONE and the whole
            '' assignment declined; fbc stores the VALUE, 'TMP$3$0 = &BV$0'.
            '' threads/threadcall.bas:166 is exactly this argument.
            dim as MirValue ad
            if forcedByval then
                ad = LowerExpr( c, ae )
            else
                ad = LowerAddr( c, ae )
            end if
            if ad.kind = cast( ubyte, MV_NONE ) then return false
            dim as long rslot = NewTempLocal( c, MT_PTR, pbytes )
            if rslot < 0 then return false
            av.kind = cast( ubyte, MV_LOCAL )
            av.ty = cast( ubyte, MT_PTR )
            av.id = rslot
            StoreThrough( c, av, ad )
        elseif IsStringType( c, pt ) then
            '' A BYVAL STRING IS COPIED into a temporary and a POINTER temporary holds
            '' that copy's address. Measured, and the copy's fb_StrDelete sits directly
            '' after the fb_ThreadCall -- before any threadwait, which is fbc's own
            '' lifetime and not one invented here.
            dim as MirValue sv
            dim as long sslot = -1
            if ByvalStrTemp_( c, ae, pt, sv, sslot ) = false then return false
            strTemps.Push( cast( ulong, sslot ) )
            strTempTypes.Push( cast( ulong, pt ) )
            dim as long qslot = NewTempLocal( c, MT_PTR, pbytes )
            if qslot < 0 then return false
            av.kind = cast( ubyte, MV_LOCAL )
            av.ty = cast( ubyte, MT_PTR )
            av.id = qslot
            StoreThrough( c, av, sv )
        else
            '' A BYVAL SCALAR OVER A VARIABLE PASSES THE VARIABLE'S OWN ADDRESS -- fbc
            '' makes no temporary for one -- and an RVALUE gets a temporary of the
            '' parameter's type.
            dim as MirType pmt = LowerType( pt, *c.types )
            if (pmt = MT_VOID) orelse (pmt = MT_AGG) then return false
            av = LowerAddr( c, ae )
            if av.kind = cast( ubyte, MV_NONE ) then
                dim as MirValue rv = LowerExpr( c, ae )
                if rv.kind = cast( ubyte, MV_NONE ) then return false
                rv = CoerceTy( c, rv, pmt, pt)
                if rv.kind = cast( ubyte, MV_NONE ) then return false
                dim as long vslot = NewTempLocal( c, pmt, TyWidthBytes_( pmt ) )
                if vslot < 0 then return false
                av.kind = cast( ubyte, MV_LOCAL )
                av.ty = cast( ubyte, MT_PTR )
                av.id = vslot
                StoreThrough( c, av, rv )
            end if
        end if
        if av.kind = cast( ubyte, MV_NONE ) then return false

        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( long, code ) ) )
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    next

    outv = EmitRtl( c, RTL_THREAD_CALL, args )
    DeleteStrArgTemps_( c, strTemps, strTempTypes )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

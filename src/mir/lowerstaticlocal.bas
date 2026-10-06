'' lowerstaticlocal.bas -- a STATIC local object: its lazy construction, and the atexit
'' thunk that destroys it.
''
'' Split out of lowerctor.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.


declare function EmitStaticDtorThunk_ _
    ( byref c as Ctx, byval g as long, byval t as Tko.TypeId ) as long

'' A STATIC LOCAL COPIED OUT OF AN EXPRESSION OF ITS OWN TYPE -- 'static as H s = mk( 3 )',
'' 'static as H s = mk', 'static as H s = obj.mk( 3 )'. LowerCtorInit takes a constructor
'' call and nothing else, so a function result fell past it and the static was never
'' initialised: the guard and the atexit thunk were emitted, the call was not, and it
'' verified with nothing declined. The program then read zeroed storage.
''
'' Measured, fbc never builds a static in place. The result goes into a TEMPORARY, is
'' COPIED into the static, and the temporary is destroyed after the atexit call:
''
''     MKFREE( &TMP$6$1, 3 );
''     __builtin_memcpy( &tmp$8, &TMP$6$1, 4 );      no copy constructor: the bytes
''     atexit( (void*)&LABEL$12 );
''     _ZN1HD1Ev( &TMP$6$1 );
''
''     _ZN1CC1ERS_( &tmp$6, vr$1 );                  a written copy constructor
''     _ZN1SC1ERKS_( &tmp$6, (struct $1S*)vr$1 );    a synthesised one, a string field
''     S1$1 = vr$0;                                   no destructor: a register result
''
'' so a destructor runs once per such declaration, on the first call -- the move
'' 'dim as H x = mk( 3 )' makes would run none.
private function LowerStaticCopyInit_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval init_ as Tko.NodeId, _
      byref ga as MirValue ) as boolean

    dim as Tko.TypeId ivt = c.info->TypeOf_( init_ )
    if ivt = Tko.TYPE_NONE then ivt = UntypedCallResult_( c, init_ )
    if ivt = Tko.TYPE_NONE then return false
    if c.types->Unqualify( ivt ) <> c.types->Unqualify( t ) then return false

    '' A PAREN-LESS CALL is LowerBareProcCall_'s, asked for the address.
    dim as MirValue sa
    if LowerBareProcCall_( c, init_, MT_PTR, sa ) = false then sa = LowerAddr( c, init_ )
    '' Declined, not dropped: falling back to the default constructor from here would
    '' be the silent loss this exists to end.
    if sa.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return true
    end if

    dim as Tko.SymbolId ucp = CopyCtorOf_( c, t )
    if ucp <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, sa.kind ) )
        cargs.Push( cast( ulong, sa.id ) )
        EmitStructorCall( c, ucp, -1, @ga, @cargs )
    elseif NeedsLetBody_( c, t ) then
        CallImplicitCopy_( c, t, ga, sa )
    else
        dim as MirValue mv
        dim as long sz = SizeOfType( c, t )
        if sz > 0 then mv = LowerExprLoad( c, sa, MT_AGG, sz )
        if mv.kind = cast( ubyte, MV_NONE ) then
            SkipHere( c )
            return true
        end if
        StoreThrough( c, ga, mv )
    end if
    return true
end function

'' A STATIC LOCAL OBJECT, constructed LAZILY the first time control reaches it.
''
'' Measured from what fbc emits for 'static as T a = T( 1 )' inside a procedure:
''
''     static int64 LABEL$9$1;                   the guard, module storage, zeroed
''     if( LABEL$9$1 != 0ll) goto label$10;
''     LABEL$9$1 = 1ll;
''     _ZN1TC1Ei( &tmp$6, 1 );                   the constructor, at the DECLARATION
''     atexit( (void*)&LABEL$8 );                and the destructor, registered
''     label$10:;
''
'' -- with a SEPARATE guard, thunk and atexit call for every such declaration, at the
'' point of the declaration and inside whatever branch encloses it: a static inside an
'' IF is not constructed until that branch runs. The thunk is a void() of its own that
'' calls the destructor on the storage, and atexit runs them in reverse registration
'' order, which is reverse construction order.
''
'' There is NO atexit and no thunk when the type has no destructor, and no guard at all
'' when it has neither constructor nor destructor: 'static as long n = 7' is a plain
'' static with a compile-time initialiser, which InitSharedGlobal already emits.
''
'' Without this the storage existed and nothing ever ran on it, so 'static as T s' over
'' a type holding a string left the descriptor uninitialised for the life of the
'' program -- the same crash DIM SHARED had before the module initialiser, and it
'' counted as lowered.
'' A RUN-ONCE GUARD over a static's declaration-time work: on return the current block runs on
'' the FIRST pass only, and StaticOnceEnd_ joins the two. -1 when it cannot be built.
''
'' THE GUARD is one per declaration, named after the storage it guards -- fbc gives it a label's
'' name, unique per declaration for the same reason -- AND AS VISIBLE AS THE STORAGE, which for a
'' static local is not at all. It went out external, so two modules each with a 'private function
'' nextId' holding a constructed 'static c' failed the link on 'duplicate symbol: NEXTID$c$init'
'' -- fbc emits the guard module-local (measured 2026-09-27: nothing external for it).
function StaticOnceBegin_( byref c as Ctx, byval g as long, byval suffix as string ) as long
    dim as Tko.InternId gnm = c.names->GetString( c.names->Spelling( c.m->globals[g].name ) & suffix )
    dim as long gg = c.m->AddVarGlobal( gnm, MT_I64, Tko.TYPE_NONE, 8 )
    c.m->globals[gg].isInternal = c.m->globals[g].isInternal
    dim as MirValue gaddr
    gaddr.kind = cast( ubyte, MV_GLOBAL ) : gaddr.ty = cast( ubyte, MT_PTR ) : gaddr.id = gg
    dim as MirValue gv = LowerExprLoad( c, gaddr, MT_I64 )
    if gv.kind = cast( ubyte, MV_NONE ) then return -1
    dim as MirInst tst
    tst.op = cast( ushort, M_ICMP_NE ) : tst.ty = cast( ubyte, MT_I32 )
    tst.a = gv : tst.b = ConstInt( c, 0, MT_I64 )
    dim as MirValue done_ = Emit( c, tst )
    if done_.kind = cast( ubyte, MV_NONE ) then return -1
    dim as long initB = NewBlock( c, "static.init" )
    dim as long skipB = NewBlock( c, "static.done" )
    Terminate( c, MTERM_CONDBR, skipB, initB, done_ )
    c.curBlock = initB
    StoreThrough( c, gaddr, ConstInt( c, 1, MT_I64 ) )
    return skipB
end function

sub StaticOnceEnd_( byref c as Ctx, byval skipB as long )
    Terminate( c, MTERM_BR, skipB, -1, NoVal( ) )
    c.curBlock = skipB
end sub

'' A STATIC DYNAMIC ARRAY WITH WRITTEN BOUNDS is sized ONCE, on the first pass: 'static a( l to u )'
'' over variables, and 'redim a( 1 to 2 ) as integer' inside a 'sub ... static' (dim/static.bas).
'' The first was never sized at all; the second re-dimensioned on every call, undoing a later
'' REDIM. 'emit' is the caller's own sizing, run inside the guard.
function StaticDynBoundsOnce_( byref c as Ctx, byval sid as Tko.SymbolId, byval ip as Tko.StmtPayload ptr ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if (s = 0) orelse (c.types->IsDynArray( s->type_ ) = false) then return false
    if (ip->c = Tko.NODE_NONE) orelse (AnyDimCount( c, ip ) <> 0) then return false
    dim as long g = GlobalFor( c, sid )
    if g < 0 then return false
    dim as MirValue ga
    ga.kind = cast( ubyte, MV_GLOBAL ) : ga.ty = cast( ubyte, MT_PTR ) : ga.id = g
    dim as long skipB = StaticOnceBegin_( c, g, "$bounds" )
    if skipB < 0 then return false
    '' THE BOUNDS' OWN TEMPORARIES DIE INSIDE THE GUARD: 'static a( 0 to f( T( 1 ) ) )' destroyed
    '' T( 1 ) again on every later call, where fbc does it once (structs/temp-var-dtors.bas).
    dim as long bmark = c.udtTemps.Count
    if EmitArrayBounds( c, ga, s->type_, ip, false ) = false then SkipHere( c )
    ReleaseUdtTemps_( c, bmark )
    StaticOnceEnd_( c, skipB )
    return true
end function

function LowerStaticLocalInit_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval init_ as Tko.NodeId ) as boolean

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    dim as Tko.TypeId t = s->type_
    if t = Tko.TYPE_NONE then return false

    dim as Tko.SymbolId ctors = Tko.SYMBOL_NONE
    dim as Tko.SymbolId dtor = Tko.SYMBOL_NONE
    dim as boolean wantsC = false
    dim as boolean wantsD = false
    dim as boolean isUdt = (c.types->Kind( t ) = Tko.TK_UDT)
    if isUdt then
        ctors = StructorOf( c, t, "__ctor" )
        dtor = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
        wantsC = (ctors <> Tko.SYMBOL_NONE) orelse TypeNeedsInit_( c, t )
        wantsD = (dtor <> Tko.SYMBOL_NONE) orelse TypeNeedsDtor_( c, t )
    else
        wantsC = ArrayElemNeedsInit_( c, t )
        wantsD = ArrayElemNeedsDtor_( c, t )
        '' ...AND AN INITIALISER LIST OVER A UDT ELEMENT WANTS CONSTRUCTING TOO, even
        '' when the element needs no DEFAULT construction. 'static as bar b1(0 to 4) =
        '' { bar(1), ... }' over a bar whose only constructor takes an argument answered
        '' 'nothing to do' here and fell to the byte-image fold, which cannot fold a
        '' constructor call and declined. Measured, fbc emits no image at all -- a
        '' run-once guard and one ctor call per element:
        ''
        ''     _ZN3BARC1Eu7INTEGER( (struct $3BAR*)B1$1, 1ll );
        ''     _ZN3BARC1Eu7INTEGER( (struct $3BAR*)((uint8*)B1$1 + 8ll), 2ll );
        ''
        '' and run, it prints ' 1 2 5' on both calls.
        if (wantsC = false) andalso (init_ <> Tko.NODE_NONE) then
            if c.types->Kind( t ) = Tko.TK_ARRAY then
                dim as Tko.TypeId el0 = c.types->Unqualify( c.types->Inner( t ) )
                if c.types->Kind( el0 ) = Tko.TK_UDT then
                    if StructorOf( c, el0, "__ctor" ) <> Tko.SYMBOL_NONE then
                        wantsC = true
                    end if
                end if
            end if
        end if
    end if
    if (wantsC = false) andalso (wantsD = false) then return false

    dim as long g = GlobalFor( c, sid )
    if g < 0 then return false
    dim as MirValue ga
    ga.kind = cast( ubyte, MV_GLOBAL )
    ga.ty = cast( ubyte, MT_PTR )
    ga.id = g

    '' A TYPE WITH ONLY A DESTRUCTOR keeps its initialiser IMAGE: 'static as DtorUDT x = ( 123 )' is
    '' emitted as any global's, and only the atexit registration is guarded (dim/udt-init.bas).
    if isUdt andalso (wantsC = false) andalso (init_ <> Tko.NODE_NONE) then InitSharedGlobal( c, sid, init_ )
    dim as long skipB = StaticOnceBegin_( c, g, "$init" )
    if skipB < 0 then return false

    '' THE CONSTRUCTOR. 'static as T a = T( 1 )' selects one by its arguments exactly
    '' as a local does; everything else takes the no-argument one, or the synthesised
    '' one for a type that needs initialising and declares none.
    dim as boolean constructed = false
    '' The temporaries the initialiser makes die INSIDE the guarded block: see below.
    dim as long smark = c.strTemps.Count
    dim as long wmark = c.wstrTemps.Count
    dim as long umark = c.udtTemps.Count
    if isUdt andalso (init_ <> Tko.NODE_NONE) then
        constructed = LowerCtorInit( c, -1, t, init_, @ga )
    end if
    if (constructed = false) andalso isUdt andalso (init_ <> Tko.NODE_NONE) then
        constructed = LowerStaticCopyInit_( c, t, init_, ga )
    end if
    if constructed = false then
        if isUdt then
            dim as Tko.SymbolId ct = StructorWithArity( c, ctors, 0 )
            if ct <> Tko.SYMBOL_NONE then
                dim as FB.Array( of ulong ) none1
                EmitStructorCall( c, ct, -1, @ga, @none1 )
                constructed = true
            elseif TypeNeedsInit_( c, t ) then
                CallImplicitCtor_( c, t, ga )
                constructed = true
            end if
        elseif wantsC then
            '' THE LIST FIRST, when there is one: it names each element's own
            '' constructor arguments, and default-constructing over it would throw
            '' them away.
            dim as boolean listed = false
            if init_ <> Tko.NODE_NONE then
                listed = LowerUdtArrayInit_( c, -1, t, init_, @ga )
            end if
            if listed = false then EmitArrayElemsAt_( c, ga, t, true )
            constructed = true
        end if
    end if

    '' THE DESTRUCTOR, through a thunk of its own -- atexit takes a void() and the
    '' destructor takes the object, so there is nothing to register directly.
    if wantsD then
        dim as long thunk = EmitStaticDtorThunk_( c, g, t )
        if thunk >= 0 then
            dim as MirInst fa
            fa.op = cast( ushort, M_FUNC_ADDR )
            fa.ty = cast( ubyte, MT_PTR )
            fa.callee = cast( ulong, thunk )
            dim as MirValue fv = Emit( c, fa )
            if fv.kind <> cast( ubyte, MV_NONE ) then
                dim as FB.Array( of ulong ) aargs
                aargs.Push( cast( ulong, fv.kind ) )
                aargs.Push( cast( ulong, fv.id ) )
                EmitRtl( c, RTL_ATEXIT, aargs )
            end if
        end if
    end if

    '' A COLLECTION INITIALISER'S CALLS, inside the guard, so the elements go in once.
    LowerCollInitCalls_( c, cast( Tko.NodeId, c.syms->SymbolAt( sid )->payload ) )

    '' ...AND THE INITIALISER'S TEMPORARIES DIE HERE, after the atexit call and still
    '' inside the guard -- measured, 'fb_StrDelete( &TMP$9$1 ); _ZN1HD1Ev( &TMP$6$1 );'
    '' on the line before the label. The statement's own flush runs in the join, on
    '' every call, over temporaries only the first call built.
    ReleaseStrTemps_( c, smark )
    ReleaseWstrTemps_( c, wmark )
    ReleaseUdtTemps_( c, umark )

    StaticOnceEnd_( c, skipB )
    return constructed orelse wantsD
end function

'' The thunk atexit is handed: a void() that destroys ONE static, built beside the
'' procedure that declared it rather than inside it.
private function EmitStaticDtorThunk_ _
    ( byref c as Ctx, byval g as long, byval t as Tko.TypeId ) as long

    dim as Tko.InternId nm = _
        c.names->GetString( c.names->Spelling( c.m->globals[g].name ) & "$dtor" )
    dim as MirFunction ptr f = c.m->AddFunction( nm, MT_VOID )
    f->isDefinition = true
    dim as long idx = c.m->functions.Count - 1

    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    c.f = f
    c.st->functions += 1
    c.curBlock = NewBlock( c, "entry" )

    dim as MirValue ga
    ga.kind = cast( ubyte, MV_GLOBAL )
    ga.ty = cast( ubyte, MT_PTR )
    ga.id = g

    if c.types->Kind( t ) = Tko.TK_UDT then
        dim as Tko.SymbolId dt = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
        if dt <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) none2
            EmitStructorCall( c, dt, -1, @ga, @none2 )
        elseif TypeNeedsDtor_( c, t ) then
            CallImplicitDtor_( c, t, ga )
        end if
    else
        EmitArrayElemsAt_( c, ga, t, false )
    end if

    Terminate( c, MTERM_RET, -1, -1, NoVal( ) )
    c.f = savedF
    c.curBlock = savedB
    return idx
end function

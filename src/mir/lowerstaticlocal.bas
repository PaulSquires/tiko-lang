'' lowerstaticlocal.bas -- a STATIC local object: its lazy construction, and the atexit
'' thunk that destroys it.
''
'' Split out of lowerctor.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.


declare function EmitStaticDtorThunk_ _
    ( byref c as Ctx, byval g as long, byval t as Tko.TypeId ) as long

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

    '' THE GUARD, one per declaration and named after the storage it guards. fbc gives
    '' it a label's name, which is unique per declaration for the same reason.
    dim as Tko.InternId gnm = _
        c.names->GetString( c.names->Spelling( c.m->globals[g].name ) & "$init" )
    dim as long gg = c.m->AddVarGlobal( gnm, MT_I64, Tko.TYPE_NONE, 8 )
    dim as MirValue gaddr
    gaddr.kind = cast( ubyte, MV_GLOBAL )
    gaddr.ty = cast( ubyte, MT_PTR )
    gaddr.id = gg

    dim as MirValue gv = LowerExprLoad( c, gaddr, MT_I64 )
    if gv.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirInst tst
    tst.op = cast( ushort, M_ICMP_NE )
    tst.ty = cast( ubyte, MT_I32 )
    tst.a = gv
    tst.b = ConstInt( c, 0, MT_I64 )
    dim as MirValue done_ = Emit( c, tst )
    if done_.kind = cast( ubyte, MV_NONE ) then return false

    dim as long initB = NewBlock( c, "static.init" )
    dim as long skipB = NewBlock( c, "static.done" )
    Terminate( c, MTERM_CONDBR, skipB, initB, done_ )

    c.curBlock = initB
    StoreThrough( c, gaddr, ConstInt( c, 1, MT_I64 ) )

    '' THE CONSTRUCTOR. 'static as T a = T( 1 )' selects one by its arguments exactly
    '' as a local does; everything else takes the no-argument one, or the synthesised
    '' one for a type that needs initialising and declares none.
    dim as boolean constructed = false
    if isUdt andalso (init_ <> Tko.NODE_NONE) then
        constructed = LowerCtorInit( c, -1, t, init_, @ga )
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

    Terminate( c, MTERM_BR, skipB, -1, NoVal( ) )
    c.curBlock = skipB
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

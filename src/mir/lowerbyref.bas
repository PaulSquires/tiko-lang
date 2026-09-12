'' lowerbyref.bas -- the temporaries a BYREF argument needs when the value it binds
'' has no address of its own.
''
'' Split out of lowercall.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.


'' A temporary holding an argument that must be passed BYREF and has no address of its
'' own. Returns the temporary's ADDRESS, or nothing when the value would not lower or
'' the parameter's type is one a scalar slot cannot hold.
''
'' AN AGGREGATE GOES THE SAME WAY, and it has to: 'sub tester( byref x as UDT =
'' type<UDT>( 123 ) )' called as 'tester( )' is 329 statements in one corpus file
'' alone. A UDT rvalue lowers to a LOADED aggregate -- a value, not an address -- so
'' passing it where a pointer belongs was the same bug in a wider slot. The store is
'' the plain M_STORE of an aggregate that a UDT return already uses.
'' NOT PRIVATE ANY MORE: 'operator []( index as integer )' declares a BYREF parameter --
'' in the fb dialect a parameter is byref unless it says otherwise -- so 'x[ 0 ]' needs
'' the same temporary an ordinary call's byref argument does. See LowerUdtIndexOp_.
function ByrefTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId ) as MirValue

    dim as MirValue none_
    if (argNode = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return none_

    '' UNQUALIFIED, because 'byref r as const any' is the same parameter as 'byref r
    '' as any' for this purpose and a const ANY would otherwise miss the test below.
    dim as MirType pmt = LowerType( c.types->Unqualify( pt ), *c.types )

    dim as MirValue rv = LowerExpr( c, argNode )
    if rv.kind = cast( ubyte, MV_NONE ) then
        '' A value that would not lower may still have an address -- and if it has
        '' one, LowerAddr would have found it before this was ever called.
        return none_
    end if

    dim as long sz = 0
    if pmt = MT_VOID then
        '' 'byref r as any' HAS NO TYPE TO MAKE A TEMPORARY OF, so the ARGUMENT's own
        '' type is what fbc uses -- and a CONSTANT is not given a temporary at all, it
        '' goes by VALUE cast to a pointer. Measured, and the comment in the corpus
        '' file that exercises it says the same thing:
        ''
        ''     u( 0 )       U( (void*)0ll )        no temp
        ''     u( i )       U( (void*)&I )         the variable's own address
        ''     u( i + 1 )   U( (void*)&TMP )       a temp of the ARGUMENT's type
        '' CONSTNESS IS THE SOURCE EXPRESSION'S QUESTION, not the lowered value's:
        '' a literal 0 comes out of LowerExpr as an instruction result, so testing the
        '' MirValue's kind answered "not constant" for the one case fbc singles out.
        dim as Tko.Check.ConstVal acv = Tko.Check.ConstOf( _
            *c.ast, argNode, *c.srcMgr, *c.names, c.types->target.pointerBits )
        if acv.known then return Coerce( c, rv, MT_PTR, false )
        pmt = cast( MirType, rv.ty )
        if (pmt = MT_VOID) orelse (pmt = MT_AGG) then return none_
        select case pmt
        case MT_I8            : sz = 1
        case MT_I16           : sz = 2
        case MT_I32, MT_F32   : sz = 4
        case else             : sz = 8
        end select
    else
        if pmt <> MT_AGG then rv = CoerceTy( c, rv, pmt, pt)
        sz = c.types->Layout( pt ).size
        if pmt = MT_AGG then sz = SizeOfType( c, pt )
    end if

    dim as long slot = NewTempLocal( c, pmt, sz )
    if slot < 0 then return none_
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot
    StoreThrough( c, tmp, rv )
    return tmp
end function


'' A TEMPORARY HOLDING A VALUE THAT IS ALREADY LOWERED.
''
'' ByrefTemp_ lowers the argument itself, which is right when the argument IS the
'' value. A value that came from somewhere else -- an 'operator cast' called on the
'' way into a byref parameter -- is in hand already and must not be lowered a second
'' time: that calls the operator twice, and structs/udt-ops-4.bas counts the calls.
function ByrefTempOf_ _
    ( byref c as Ctx, byref rv as MirValue, byval pt as Tko.TypeId ) as MirValue

    dim as MirValue none_
    if rv.kind = cast( ubyte, MV_NONE ) then return none_
    if pt = Tko.TYPE_NONE then return none_
    dim as Tko.TypeId rt = c.types->Unqualify( pt )
    if c.types->Kind( rt ) = Tko.TK_REFERENCE then
        rt = c.types->Unqualify( c.types->Inner( rt ) )
    end if
    dim as MirType pmt = LowerType( rt, *c.types )
    if (pmt = MT_VOID) orelse (pmt = MT_AGG) then return none_
    dim as MirValue v2 = CoerceTy( c, rv, pmt, rt )
    if v2.kind = cast( ubyte, MV_NONE ) then return none_
    dim as long slot = NewTempLocal( c, pmt, c.types->Layout( rt ).size )
    if slot < 0 then return none_
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot
    StoreThrough( c, tmp, v2 )
    return tmp
end function

'' A PROCEDURE NAMED WITHOUT ITS PARENTHESES, PASSED BYREF, IS A CALL. Measured, over
'' 'sub P( byref x as long )':
''
''     P( Free )  P( NS.Fn )  P( T.SFn )     fbc: 40 41 42 -- each one CALLED
''     'Selfy = 5 : P( Selfy )' inside Selfy  fbc: 7 -- a recursive call, not the result
''     a.Push( c.Count )  over FB.Array     vr = COUNT( &C ); TMP = vr; PUSH( &A, &TMP )
''
'' LowerAddr answers an identifier or member bound to a procedure with the procedure's
'' own address -- right for '@NS.Tramp' -- and every one of those handed the callee its
'' CODE: the value read back as 283935560, which is 48 83 EC 10, 'sub rsp, 16'. A
'' property getter is the same shape. The self-hosted compiler's generic registry
'' pushes 'instArgs.Count' like this, and so does most of tiko-lang.
''
'' True when the argument IS such a name; 'outa' is then the temporary, or nothing if
'' the value would not lower -- and the caller declines rather than pass the address.
function ParenlessProcTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue ) as boolean

    if argNode = Tko.NODE_NONE then return false
    dim as Tko.NodeKind k = c.ast->Kind( argNode )
    if (k <> Tko.N_IDENT) andalso (k <> Tko.N_MEMBER) then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( c.info->RefOf( argNode ) )
    if ps = 0 then return false
    if ps->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    outa = ByrefTemp_( c, argNode, pt )
    return true
end function

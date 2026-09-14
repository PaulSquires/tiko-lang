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

'' Does UDT 'pt' declare a one-parameter CONSTRUCTOR taking an 'at' -- or a base 'at'
'' derives from? The copy constructor never qualifies here: both callers have already
'' ruled out an 'at' that is 'pt' or derives from it.
private function HasUdtConvCtor_ _
    ( byref c as Ctx, byval pt as Tko.TypeId, byval at as Tko.TypeId ) as boolean

    dim as Tko.SymbolId cur = StructorOf( c, pt, "__ctor" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        if ParamCountOf( c, cur ) = 1 then
            dim as Tko.TypeId cpt = ParamTypeAt( c, cur, 0 )
            if cpt <> Tko.TYPE_NONE then
                cpt = c.types->Unqualify( cpt )
                if c.types->Kind( cpt ) = Tko.TK_REFERENCE then
                    cpt = c.types->Unqualify( c.types->Inner( cpt ) )
                end if
                if c.types->Kind( cpt ) = Tko.TK_UDT then
                    if c.types->BaseDistance( at, cpt ) >= 0 then return true
                end if
            end if
        end if
        cur = cs->nextOverload
    wend
    return false
end function

'' A BYREF UDT PARAMETER GIVEN AN ARGUMENT OF ANOTHER TYPE IS A CONVERSION: the parameter
'' type's constructor builds a temporary, its ADDRESS is bound, and it dies with the
'' statement's other temporaries -- see ByvalUdtCopyArg_. Measured on fbc, over
'' 'constructor W( byval v as long )' and 'byref wr as W':
''
''     takeWR( 6 )     _ZN1WC1Ei( &TMP$15$0, 6 );  int32 vr$4 = TAKEWR( &TMP$15$0 );
''     takeWR( n )     _ZN1WC1Ei( &TMP$19$0, N$0 );
''     takeWR( d )     _ZN1WC1Ei( &TMP$23$0, fb_D2I( D$0 ) );
''     takeWS( st )    _ZN2WSC1ER8FBSTRING( &TMP$44$0, &ST$0 );
''
'' -- a literal, a variable, a double and a string alike, and the same for 'byref as
'' const W', a method's parameter and a SUB called as a statement. A UDT argument was
'' the only one converted. A scalar took the other arms: a VARIABLE handed the callee its
'' own address to read as a W, and a LITERAL was stored bare into a W-sized temporary, so
'' 'takeWR( 6 )' printed 6 with no constructor and no destructor where fbc builds W( 6 ).
'' 'TakeDW( b )' over 'constructor DW( byref b as BS )' is the UDT shape: tiko bound '@b',
'' the BS's own bytes read as a DW; AfxNova's 'this.Add( bs )' in DWSTRING.+= is the same.
''
'' A UDT argument converts only when the parameter's type has a constructor for it -- a
'' derived object is the base subobject, not a conversion -- and an untyped argument or
'' a bare tuple list is somebody else's path. True when the argument needs converting;
'' 'outa' is then the temporary's address, or nothing when it could not be built, and
'' the caller declines rather than pass the source.
function ByrefConvNeeded_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId ) as boolean

    if (argNode = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )
    if c.types->Kind( pu ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId at0 = c.info->TypeOf_( argNode )
    if at0 = Tko.TYPE_NONE then return false
    dim as Tko.TypeId au = c.types->Unqualify( at0 )
    if c.types->Kind( au ) = Tko.TK_REFERENCE then au = c.types->Unqualify( c.types->Inner( au ) )
    if au = pu then return false
    if c.types->Kind( au ) = Tko.TK_UDT then
        if c.types->BaseDistance( au, pu ) >= 0 then return false
        if HasUdtConvCtor_( c, pu, au ) = false then return false
    elseif c.ast->Kind( Unparen_( c, argNode ) ) = Tko.N_TUPLE then
        return false
    end if
    return true
end function

'' ...and the conversion itself, when ByrefConvNeeded_ says one is needed.
function ByrefConvArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue ) as boolean

    if ByrefConvNeeded_( c, argNode, pt ) = false then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )

    dim as MirValue none_
    outa = none_
    dim as long ts = -1
    dim as Tko.TypeId tt = Tko.TYPE_NONE
    if UdtConvTemp_( c, argNode, pu, outa, ts, tt ) = false then
        outa = none_
        c.blameNode = cast( ulong, argNode )
        return true
    end if
    if ts >= 0 then
        c.udtTemps.Push( cast( ulong, ts ) )
        c.udtTempTypes.Push( cast( ulong, tt ) )
    end if
    return true
end function

'' The argument of a byref parameter that no earlier arm of the call took: converted when
'' ByrefConvArg_ says so, a paren-less procedure's result in a temporary (see
'' ParenlessProcTemp_), otherwise its own address. False when a conversion or a call is
'' required and could not be built. THE CONVERSION IS ASKED FIRST: 'takeWR( getSeven )'
'' over 'byref wr as W' is a call AND a conversion, and fbc writes both --
'' 'vr = GETSEVEN( ); _ZN1WC1Ei( &TMP, vr )' -- where the procedure's arm stored the long
'' bare into a W-sized temporary.
private function ByrefUdtArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue ) as boolean

    if ByrefConvArg_( c, argNode, pt, outa ) then
        return (outa.kind <> cast( ubyte, MV_NONE ))
    end if
    if ParenlessProcTemp_( c, argNode, pt, outa ) then
        return (outa.kind <> cast( ubyte, MV_NONE ))
    end if
    outa = LowerAddr( c, argNode )
    return true
end function


'' A 'byref as [const] wstring' CONSTRUCTOR PARAMETER TAKES WIDE CHARACTERS, as at a call
'' (lowercall.bas): what WideOperand_ gives -- a wide argument, or a narrow LITERAL
'' widened in place -- else a narrow string through NarrowToWideTemp_. fbc passes
'' '(uint16*)L"Mars"', or fb_StrToWstr into a temporary deleted after the call. False
'' when 'pt' is no wstring or nothing could be passed. Every constructor path asks this:
'' each took an ADDRESS instead -- of a pointer temporary for 'wstr( "Fevrier" )', of
'' the text or the descriptor for a narrow argument -- and the body read garbage.
'' Here rather than in lowerctor.bas, which is at its size limit.
function WideRefCtorArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if (argNode = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId u = c.types->Unqualify( pt )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    if c.types->BuiltinOf( u ) <> Tko.TY_WSTRING then return false
    if WideOperand_( c, argNode, outv ) then return true
    if IsNarrowStrArg_( c, c.info->TypeOf_( argNode ) ) = false then return false
    return NarrowToWideTemp_( c, argNode, outv )
end function


'' A STRING LITERAL BOUND FOR A 'byref as [const] wstring' CONSTRUCTOR PARAMETER is left out
'' when the arguments are lowered ahead of the overload pick: WideRefCtorArg_ lowers it WIDE
'' once the pick is made, and lowering it narrow first as well left a dead narrow global
'' beside the wide one -- 'base( "Sept" )', 'WU( "Mars" )'. fbc emits only 'L"Sept"'. A
'' literal has no side effect, so leaving it out reorders nothing. The pick is made here
'' from the argument TYPES, which is all PickCtor reads; 'idx' counts arguments.
function CtorLitArgIsWide_ _
    ( byref c as Ctx, byval ctors as Tko.SymbolId, byval first_ as long, _
      byval count as long, byval idx as long ) as boolean

    dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[first_ + idx] )
    if c.ast->Kind( Unparen_( c, a ) ) <> Tko.N_STRING_LIT then return false
    dim as FB.Array( of ulong ) argT
    for i as long = 0 to count - 1
        argT.Push( cast( ulong, c.info->TypeOf_( cast( Tko.NodeId, c.ast->children[first_ + i] ) ) ) )
    next
    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as long seen = 0
    for k as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + k] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then
            if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) = 0 then return false
            dim as Tko.TypeId u = c.types->Unqualify( c.info->TypeOf_( StmtOf( c, prm )->a ) )
            if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
            if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
            return (c.types->BuiltinOf( u ) = Tko.TY_WSTRING)
        end if
        seen += 1
    next
    return false
end function

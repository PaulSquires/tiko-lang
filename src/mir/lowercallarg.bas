'' lowercallarg.bas -- the UDT-ARGUMENT machinery of a call: conversion constructors,
'' bare type literals, byval copies, and the temporaries all three need.
''
'' Split out of lowercall.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.




'' THE CONVERSION CONSTRUCTOR for one argument that is not already the parameter's type.
''
'' 'sub f( byval x as UDT )' called as 'f( 1122 )' over a type declaring
'' 'declare constructor( byval n as integer )'. Measured:
''
''     struct UDT TMP$2$0;
''     _ZN3UDTC1Eu7INTEGER( &TMP$2$0, 1122ll );
''     F( TMP$2$0 );
''
'' -- a temporary, the constructor into it, and the temporary passed. It is destroyed at
'' the END OF THE STATEMENT, after the call's result has been consumed, which is what
'' the argument-temporary list this returns into already does.
''
'' Without it the raw operand went straight to the callee: 'call void F( 1122 )', an
'' integer where an object belongs, with "0 statements not lowered" beside it. It lowered
'' and it verified.
''
'' A CONVERSION CONSTRUCTOR IS ANY ARITY-1 CONSTRUCTOR WHOSE PARAMETER IS NOT THE TYPE
'' ITSELF -- one whose parameter IS the type is the copy constructor, and that is a
'' different path with a different meaning.
private function ConvCtorFor_ _
    ( byref c as Ctx, byval pt as Tko.TypeId ) as Tko.SymbolId

    dim as Tko.SymbolId cur = StructorOf( c, pt, "__ctor" )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
            next
            if np = 1 then
                dim as Tko.TypeId cpt = ParamTypeAt( c, cur, 0 )
                if cpt <> Tko.TYPE_NONE then
                    dim as Tko.TypeId u = cpt
                    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Inner( u )
                    if c.types->Unqualify( u ) <> c.types->Unqualify( pt ) then
                        return cur
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' A TEMPORARY OF THE PARAMETER'S TYPE, constructed from the argument. Returns its
'' ADDRESS; the caller decides whether the callee wants that or the aggregate loaded out
'' of it, which is the same choice an ordinary byval UDT argument already makes.
'' 'f( type( ) )' -- A BARE TYPE LITERAL AS AN ARGUMENT.
''
'' Recognised by SHAPE: an empty N_TUPLE marked as a type literal with no type name
'' of its own. The type comes from the PARAMETER, which is the only place it can
'' come from, so Check cannot type it and every use of one declined -- the same
'' reason LowerBareTypeLiteralAssign_ exists on the assignment side.
''
'' Measured, and BOTH passing modes build the same temporary and destroy it after
'' the call:
''
''   _ZN1TC1Ev( &TMP$3$0 );  HPASSBYVAL( &TMP$3$0 );  _ZN1TD1Ev( &TMP$3$0 );
''   _ZN1TC1Ev( &TMP$4$0 );  HPASSBYREF( &TMP$4$0 );  _ZN1TD1Ev( &TMP$4$0 );
''
'' Returns the temporary's SLOT; the caller decides whether the callee takes its
'' address or its value, and registers the destructor.
private function BareTypeLiteralArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outSlot as long ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
    '' '( 4, 5 )' WRITTEN AS AN ARGUMENT keeps the parentheses it was written with:
    '' the list arrives wrapped in an N_PAREN, where the same text on the right of
    '' an '=' does not. Testing for N_TUPLE alone saw nothing here.
    argNode = Unparen_( c, argNode )
    if c.ast->Kind( argNode ) <> Tko.N_TUPLE then return false
    if pt = Tko.TYPE_NONE then return false
    dim as Tko.TypeId dt = c.types->Unqualify( pt )
    if c.types->Kind( dt ) = Tko.TK_REFERENCE then
        dt = c.types->Unqualify( c.types->Inner( dt ) )
    end if
    if c.types->Kind( dt ) <> Tko.TK_UDT then return false

    '' A BARE TUPLE LIST IS THE SAME RULE ONE STEP ALONG: the PARAMETER decides the
    '' type. 'takesDD( (4, 5) )' against 'byval p as (double, double)' types the
    '' literal (INTEGER, INTEGER) on its own, and passing THAT reinterprets two
    '' integers as two doubles -- measured, tiko printed 1.97e-323 and 2.47e-323
    '' where fbc prints 4 and 5. The literal's own type is not a hint here, it is
    '' wrong, and the same is true of its SIZE: '( Counted( 3 ), 4 )' is 16 bytes
    '' against a 'byval p as (Counted, long)' that is 8.
    ''
    '' ONLY FOR A TUPLE PARAMETER. Against an ordinary UDT a parenthesised list is
    '' the field-list initialiser, which has its own path and its own rules about
    '' which constructors it may skip.
    dim as boolean bareLit = _
        ((c.ast->nodes[cast( long, argNode )].flags and Tko.NF_TYPE_LITERAL) <> 0)
    if bareLit then
        if c.info->TypeOf_( argNode ) <> Tko.TYPE_NONE then return false
    else
        if IsTupleType_( c, dt ) = false then return false
    end if
    dim as long sz = SizeOfType( c, dt )
    if sz <= 0 then return false

    dim as long tslot = NewTempLocal( c, MT_AGG, sz )
    if tslot < 0 then return false
    '' LowerCtorInit WANTS A CONSTRUCTOR, and a plain tuple of scalars has none --
    '' which is why this declined for '(double, double)' and the argument fell
    '' through to being lowered as its own type. A field list is the other way to
    '' fill one, and it is the same one the declaration form uses.
    if LowerCtorInit( c, tslot, dt, argNode ) = false then
        dim as MirValue tinit
        tinit.kind = cast( ubyte, MV_LOCAL )
        tinit.ty = cast( ubyte, MT_PTR )
        tinit.id = tslot
        if TypeNeedsInit_( c, dt ) then CallImplicitCtor_( c, dt, tinit )
        if LowerUdtParenInit_( c, tslot, dt, argNode ) = false then return false
    end if
    if TypeNeedsDtor_( c, dt ) then
        c.udtTemps.Push( cast( ulong, tslot ) )
        c.udtTempTypes.Push( cast( ulong, dt ) )
    end if
    outSlot = tslot
    return true
end function

'' THE TYPE A CONSTRUCTOR ARGUMENT IS CHOSEN BY. A literal with a unicode escape is a WIDE
'' literal to fbc -- a 'WSTRING * n' -- whatever Check typed it, and it picks the constructor a
'' wstring picks. Measured on fbc-modern, for a 'wstring * 8' variable, 'wstr( "x" )' and an
'' escaped literal alike: over { string, const wstring, wstring ptr } all three take the
'' POINTER, over { string, const wstring } the const wstring -- explicit 'H( a )', implicit
'' 'dim as H h = a' and a byval argument the same. The literal took the STRING one and drew
'' as '?'. 'WSTRING * 1' is the type wstr( ) already has, which matched fbc on every path.
function CtorArgTypeOf_( byref c as Ctx, byval e as Tko.NodeId ) as Tko.TypeId
    if LitHasUnicodeEscape_( c, e ) then
        return c.types->ArrayOf( c.types->Builtin( Tko.TY_WSTRING ), 1, 1 )
    end if
    return c.info->TypeOf_( e )
end function

'' 'operator cast( ) as <the parameter's own type>', declared on the ARGUMENT'S type.
''
'' The other direction -- a constructor on the parameter's type taking the argument's --
'' is HasUdtConvCtor_, and it was the only one asked, so a UDT that converts by casting
'' was passed as its own BYTES. Where the source is the larger type that is not a wrong
'' value, it is a stack overrun: AfxNova's 'Send( byval Body as VARIANT )' took a
'' 56-byte DVARIANT blitted into the 24-byte slot the parameter sized, and the 32 bytes
'' past the end were the caller's saved registers. tiko-editor's update check crashed on
'' the thread-exit path, in a runtime whose FBTHREAD pointer had come back as 1.
''
'' fbc gives such an operator a STATIC result and returns a POINTER to it -- measured,
'' 'struct $2TU* _ZN2CVcv2TUEv( struct $2CV* )' -- which is what EmitMemberCallArgs_
'' already knows and why a cast is the one member that takes no hidden result pointer.
function UdtCastToUdt_ _
    ( byref c as Ctx, byval au as Tko.TypeId, byval pt as Tko.TypeId ) as Tko.SymbolId

    if (au = Tko.TYPE_NONE) orelse (pt = Tko.TYPE_NONE) then return Tko.SYMBOL_NONE
    if au = pt then return Tko.SYMBOL_NONE
    if c.types->Kind( au ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    if c.types->Kind( pt ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = StructorOf( c, au, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        if cs->type_ <> Tko.TYPE_NONE then
            dim as Tko.TypeId ru = c.types->Unqualify( cs->type_ )
            if c.types->Kind( ru ) = Tko.TK_REFERENCE then
                ru = c.types->Unqualify( c.types->Inner( ru ) )
            end if
            if ru = pt then return cur
        end if
        cur = cs->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' ...AND WHETHER THAT CAST CAN BE TAKEN HERE. Asked by ArgNeedsUdtConv_ as well as
'' by the conversion itself, and it has to be the SAME question in both: a decision to
'' convert that the conversion then declines is not a fallback, it is a call that no
'' longer lowers at all.
''
'' ONLY INTO A DESTINATION THAT NEITHER COPIES NOR DESTROYS. The operator's result is
'' its own -- fbc gives it a static -- so the copy taken from it can only be a bitwise
'' one, and a temporary holding a second owner's bytes must not be destroyed. A
'' destination with either declines and keeps exactly the behaviour it has today,
'' until there is a measurement that says what fbc does with it.
function UdtCastArgOk_ _
    ( byref c as Ctx, byval au as Tko.TypeId, byval pt as Tko.TypeId ) as boolean

    if UdtCastToUdt_( c, au, pt ) = Tko.SYMBOL_NONE then return false
    if TypeNeedsDtor_( c, pt ) then return false
    if CopyCtorOf_( c, pt ) <> Tko.SYMBOL_NONE then return false
    if NeedsLetBody_( c, pt ) then return false
    return true
end function

'' A CAST THAT RETURNS A REFERENCE -- 'operator cast( ) byref as TU' -- hands back an object
'' that already exists, so it serves ANY destination: a byref parameter takes the reference
'' itself, and anything else copies out of it with the destination's own copy. Measured on
'' fbc, TV casting 'byref as TU' to a TU with a copy constructor and a destructor:
''
''     s2( v )    over 'byref u as TU'   cast -- nothing else, even beside 'TU( byref as TV )'
''     s1( v )    over 'byval u as TU'   cast, copy constructor, destructor (no TU( TV ))
''
'' tiko took neither and passed v's own bytes as a TU (structs/udt-init-ops-2.bas).
declare function ArgUdtType_( byref c as Ctx, byval argNode as Tko.NodeId ) as Tko.TypeId
declare function DirectUdtCtor_( byref c as Ctx, byval pt as Tko.TypeId, byval at as Tko.TypeId ) as boolean

function UdtByrefCast_ _
    ( byref c as Ctx, byval au as Tko.TypeId, byval pt as Tko.TypeId ) as Tko.SymbolId

    dim as Tko.SymbolId cs = UdtCastToUdt_( c, au, pt )
    if cs = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    '' 'byref' on a result is the procedure's NF_BYREF, not part of its type -- CallReturnsByref_.
    dim as Tko.Symbol ptr csy = c.syms->SymbolAt( cs )
    if csy = 0 then return Tko.SYMBOL_NONE
    dim as Tko.NodeId cpn = cast( Tko.NodeId, csy->payload )
    if (cpn = Tko.NODE_NONE) orelse (c.ast->Kind( cpn ) <> Tko.N_PROC) then return Tko.SYMBOL_NONE
    if (c.ast->nodes[cast( long, cpn )].flags and Tko.NF_BYREF) = 0 then return Tko.SYMBOL_NONE
    return cs
end function

'' The argument's type, as the conversion picks see it: a reference is the thing it
'' refers to, and a qualifier is not part of the question.
function ArgUdtType_( byref c as Ctx, byval argNode as Tko.NodeId ) as Tko.TypeId
    dim as Tko.TypeId at = c.info->TypeOf_( argNode )
    if at = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( at ) = Tko.TK_REFERENCE then at = c.types->Inner( at )
    return c.types->Unqualify( at )
end function

'' A UDT VALUE CONVERTED TO ANOTHER UDT BY THE SOURCE'S OWN 'operator cast' -- the
'' VALUE, where UdtConvTemp_ hands back somewhere to find it. An initialiser, an
'' assignment and an explicit 'cast( )' all want the converted aggregate itself; only
'' an argument needs an address. Measured on fbc, a 56-byte source that casts to a
'' 24-byte one prints the operator's values through every one of those positions, and
'' tiko-lang blitted the source's first 24 bytes into the destination instead.
''
'' WHICH OF THE TWO RUNS DEPENDS ON WHETHER THE DESTINATION IS BEING CONSTRUCTED. Measured on
'' fbc-modern, A casting to B2 and B2 constructible from A:
''
''     dim as B2 b = a / byval argument / return a / new B2( a )   the CONSTRUCTOR   300
''     b = a / h.f = a / arr( 0 ) = a / cast( B2, a ) / byref arg  the CAST          400
''
'' 'constructing' says which: an initialiser passes true and the constructor wins; an
'' assignment and an explicit 'cast( )' pass false. tiko let the constructor block the cast
'' everywhere -- and an assignment, having no constructor to run either, copied A's own bytes
'' into the B2 (overload re-pick refactor, Phase 3). A derived value is not a conversion at
'' all: it is the base subobject, which the ordinary copy already gets right.
function UdtCastValue_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval dstT as Tko.TypeId, _
      byref outv as MirValue, byval constructing as boolean = true ) as boolean

    if e = Tko.NODE_NONE then return false
    if dstT = Tko.TYPE_NONE then return false
    dim as Tko.TypeId du = c.types->Unqualify( dstT )
    if c.types->Kind( du ) = Tko.TK_REFERENCE then
        du = c.types->Unqualify( c.types->Inner( du ) )
    end if
    if c.types->Kind( du ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId au = ArgUdtType_( c, e )
    if au = Tko.TYPE_NONE then return false
    if c.types->BaseDistance( au, du ) >= 0 then return false
    if constructing andalso HasUdtConvCtor_( c, du, au ) then return false
    dim as Tko.SymbolId cs = Tko.SYMBOL_NONE
    if UdtCastArgOk_( c, au, du ) then cs = UdtCastToUdt_( c, au, du )
    if cs = Tko.SYMBOL_NONE then return false
    dim as MirValue self_ = LowerAddr( c, e )
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    outv = EmitMemberCall( c, cs, self_, MT_AGG )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' COPY-CONSTRUCT 'dst' OF TYPE 'pt' FROM THE OBJECT AT 'src': its copy constructor, else
'' the implicit copy, else the bytes. 'dst' is raw storage.
function CopyIntoFromRef_ _
    ( byref c as Ctx, byval pt as Tko.TypeId, byref dst as MirValue, byref src as MirValue ) as boolean

    dim as Tko.SymbolId cc = CopyCtorOf_( c, pt )
    if cc <> Tko.SYMBOL_NONE then
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, src.kind ) ) : cargs.Push( cast( ulong, src.id ) )
        dim as MirValue cdst = dst
        EmitStructorCall( c, cc, -1, @cdst, @cargs )
        return true
    end if
    if NeedsLetBody_( c, pt ) then
        CallImplicitCopy_( c, pt, dst, src )
        return true
    end if
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false
    dim as MirValue whole = LowerExprLoad( c, src, MT_AGG, sz )
    if whole.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, dst, whole )
    return true
end function

'' 'dim a as TU = v' OVER A 'TV.cast( ) byref as TU' and no 'TU( byref as TV )': the cast, then
'' a's copy out of the reference. Measured on fbc: "cast", "ctor<-TU", and a's destructor at
'' scope end -- tiko took v's own bytes as a TU. False, emitting nothing, when it is not that
'' shape.
function ByrefCastInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, byval init_ as Tko.NodeId, _
      byval selfv as MirValue ptr ) as boolean

    if (slot < 0) andalso (selfv = 0) then return false
    dim as MirValue dst
    if selfv <> 0 then
        dst = *selfv
    else
        dst.kind = cast( ubyte, MV_LOCAL ) : dst.ty = cast( ubyte, MT_PTR ) : dst.id = slot
    end if
    dim as Tko.TypeId au = ArgUdtType_( c, init_ )
    if (au = Tko.TYPE_NONE) orelse (c.types->Kind( au ) <> Tko.TK_UDT) then return false
    dim as Tko.TypeId pt = c.types->Unqualify( t )
    if au = pt then return false
    if c.types->BaseDistance( au, pt ) >= 0 then return false
    dim as Tko.SymbolId bcast = UdtByrefCast_( c, au, pt )
    if bcast = Tko.SYMBOL_NONE then return false
    if DirectUdtCtor_( c, pt, au ) then return false
    if UdtCastArgOk_( c, au, pt ) then return false
    dim as MirValue bself = LowerAddr( c, init_ )
    if bself.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue bref = EmitMemberCall( c, bcast, bself, MT_PTR )
    if bref.kind = cast( ubyte, MV_NONE ) then return false
    return CopyIntoFromRef_( c, pt, dst, bref )
end function

'' A one-parameter constructor of 'pt' taking 'at' itself or one of its bases -- not one
'' reached through a conversion of 'at'.
function DirectUdtCtor_( byref c as Ctx, byval pt as Tko.TypeId, byval at as Tko.TypeId ) as boolean
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
                if c.types->Kind( cpt ) = Tko.TK_REFERENCE then cpt = c.types->Unqualify( c.types->Inner( cpt ) )
                if (c.types->Kind( cpt ) = Tko.TK_UDT) andalso (c.types->BaseDistance( at, cpt ) >= 0) then return true
            end if
        end if
        cur = cs->nextOverload
    wend
    return false
end function

private function UdtConvTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId, _
      byval preferCast as boolean = false ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if argNode = Tko.NODE_NONE then return false
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false

    '' A WIDE STRING FOR A TYPE WITH A 'wstring ptr' CONSTRUCTOR takes that one, as fbc does --
    '' see WideArgCharPtrCtor_. PickCtor has no single cheapest candidate to offer for it.
    if WideArgCharPtrCtor_( c, argNode, pt ) then
        dim as long wslot = NewTempLocal( c, MT_AGG, sz )
        if wslot < 0 then return false
        if CharPtrCtorInit_( c, wslot, pt, argNode ) = false then return false
        if TypeNeedsDtor_( c, pt ) then
            outSlot = wslot
            outType = pt
        end if
        outa.kind = cast( ubyte, MV_LOCAL )
        outa.ty = cast( ubyte, MT_PTR )
        outa.id = wslot
        return true
    end if

    '' THE ARGUMENT'S OWN CAST, when the parameter's type has no constructor for it.
    '' Asked in that order so every call that works today keeps the constructor it has;
    '' this is the case that had no path at all.
    ''
    '' The temporary is NOT registered for destruction: UdtCastArgOk_ has already
    '' refused every destination that would need it.
    dim as Tko.TypeId aut = ArgUdtType_( c, argNode )
    '' ...OR, for a BYREF argument, whenever it has one: fbc passes a byref parameter the
    '' CAST's result even beside a converting constructor (UdtCastValue_'s table).
    '' A REFERENCE-RETURNING CAST -- see UdtByrefCast_ -- unless the parameter's type has a
    '' constructor taking the argument's own type: HasUdtConvCtor_ also counts the COPY
    '' constructor reached THROUGH this cast, and that path passed the argument's bytes to it
    '' uncast. A trivial destination copied by value keeps the path below.
    dim as Tko.SymbolId bcast = Tko.SYMBOL_NONE
    if aut <> Tko.TYPE_NONE then bcast = UdtByrefCast_( c, aut, pt )
    if (bcast <> Tko.SYMBOL_NONE) andalso (preferCast orelse (DirectUdtCtor_( c, pt, aut ) = false)) andalso _
       (preferCast orelse (UdtCastArgOk_( c, aut, pt ) = false)) then
        dim as MirValue bself = LowerAddr( c, argNode )
        if bself.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue bref = EmitMemberCall( c, bcast, bself, MT_PTR )
        if bref.kind = cast( ubyte, MV_NONE ) then return false
        if preferCast then
            outa = bref
            return true
        end if
        dim as long bslot = NewTempLocal( c, MT_AGG, sz )
        if bslot < 0 then return false
        dim as MirValue bdst
        bdst.kind = cast( ubyte, MV_LOCAL )
        bdst.ty = cast( ubyte, MT_PTR )
        bdst.id = bslot
        if CopyIntoFromRef_( c, pt, bdst, bref ) = false then return false
        if TypeNeedsDtor_( c, pt ) then
            outSlot = bslot
            outType = pt
        end if
        outa = bdst
        return true
    end if
    if (aut <> Tko.TYPE_NONE) andalso (preferCast orelse (HasUdtConvCtor_( c, pt, aut ) = false)) then
        dim as Tko.SymbolId dcast = Tko.SYMBOL_NONE
        if UdtCastArgOk_( c, aut, pt ) then dcast = UdtCastToUdt_( c, aut, pt )
        if dcast <> Tko.SYMBOL_NONE then
            dim as MirValue dself = LowerAddr( c, argNode )
            if dself.kind = cast( ubyte, MV_NONE ) then return false
            dim as long dslot = NewTempLocal( c, MT_AGG, sz )
            if dslot < 0 then return false
            '' AS AN AGGREGATE, which is what the definition of a cast to a type
            '' like this one returns. fbc's own cast operator hands back a POINTER
            '' to a static, and EmitMemberCallArgs_ knows it -- but tiko-lang lowers
            '' one whose result needs neither copying nor destroying as an ordinary
            '' by-value aggregate, and asking for a pointer made the call disagree
            '' with the callee. WalkCalls answers a disagreement by DECLINING the
            '' callee's whole return convention -- it zeroes retSize -- so the
            '' operator's own definition then reached the emitter still returning an
            '' aggregate, as 'the ABI pass has not run'.
            dim as MirValue dval = EmitMemberCall( c, dcast, dself, MT_AGG )
            if dval.kind = cast( ubyte, MV_NONE ) then return false
            dim as MirValue ddst
            ddst.kind = cast( ubyte, MV_LOCAL )
            ddst.ty = cast( ubyte, MT_PTR )
            ddst.id = dslot
            StoreThrough( c, ddst, dval )
            outa = ddst
            return true
        end if
    end if

    '' BY THE ARGUMENT'S TYPE, not by position in the chain. ConvCtorFor_ answers
    '' "some arity-1 constructor that is not the copy one", which is the right question
    '' only when there is EXACTLY ONE. Measured on fbc:
    ''
    ''     type LV
    ''         declare constructor( byval v as boolean )
    ''         declare constructor( byref v as string )
    ''     end type
    ''     take( LV( s ) )        '' s is a STRING
    ''
    '' fbc prints 3 -- the string constructor -- and the chain head is the boolean one,
    '' so tiko coerced a string descriptor to a boolean with a 'sext' and called the
    '' wrong constructor. It lowered and it verified. fb/logger.bi's
    '' 'LogValue( v.Message( ) )' is the same shape, nine constructors deep.
    ''
    '' PickCtor is the cost model overload resolution itself uses; the chain walk is
    '' kept as the fallback for an argument Check could not type, where a cost cannot
    '' be computed and the old answer is still the best available.
    dim as Tko.SymbolId cv = Tko.SYMBOL_NONE
    dim as Tko.TypeId argt0 = CtorArgTypeOf_( c, argNode )
    if argt0 <> Tko.TYPE_NONE then
        dim as FB.Array( of ulong ) one
        one.Push( cast( ulong, argt0 ) )
        cv = PickCtor( c, StructorOf( c, pt, "__ctor" ), one )
    end if
    if cv = Tko.SYMBOL_NONE then cv = ConvCtorFor_( c, pt )
    if cv = Tko.SYMBOL_NONE then return false
    dim as Tko.TypeId cpt = ParamTypeAt( c, cv, 0 )
    if cpt = Tko.TYPE_NONE then return false

    '' EVERYTHING THAT CAN FAIL, BEFORE ANYTHING IS EMITTED. A decline that has already
    '' made a temporary does not LOOK like one -- the alloca counts as an instruction and
    '' the statement reads as lowered with the call missing from it.
    dim as boolean byrefP = ParamIsByref( c, cv, 0 )

    '' A CHAINED USER CONVERSION: the argument is a UDT that CASTS to what the
    '' conversion constructor wants, so two user steps run back to back. Measured,
    '' 'u <> v' over a TV that casts to STRING and a TU built from one:
    ''
    ''     vr$5 = _ZN2TVcv8FBSTRINGEv( &V$0 );
    ''     _ZN2TUC1ER8FBSTRING( &TMP$3$0, ... );
    ''
    '' -- fbc's priority 4, which structs/udt-comp-ops-2.bas is written to exercise.
    '' The cast SYMBOL is found here and CALLED below, so a decline still emits
    '' nothing.
    ''
    '' Only a POINTER-SHAPED cast result is taken: a string is a descriptor pointer
    '' and a UDT is an address, which is what a byref parameter wants either way. A
    '' cast yielding a SCALAR into a byref parameter needs a temporary of its own and
    '' is not measured, so it declines rather than guessing.
    dim as Tko.SymbolId chainCast = Tko.SYMBOL_NONE
    dim as Tko.TypeId cpu = c.types->Unqualify( cpt )
    if c.types->Kind( cpu ) = Tko.TK_REFERENCE then
        cpu = c.types->Unqualify( c.types->Inner( cpu ) )
    end if
    dim as Tko.TypeId au = c.types->Unqualify( c.info->TypeOf_( argNode ) )
    if c.types->Kind( au ) = Tko.TK_REFERENCE then
        au = c.types->Unqualify( c.types->Inner( au ) )
    end if
    dim as boolean chainOk = (au <> Tko.TYPE_NONE) andalso (au <> cpu)
    if chainOk then chainOk = (c.types->Kind( au ) = Tko.TK_UDT)
    if chainOk then chainOk = (IsStringType( c, cpu ) orelse (c.types->Kind( cpu ) = Tko.TK_UDT))
    if chainOk then
        dim as Tko.SymbolId ccur = StructorOf( c, au, "cast" )
        while ccur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr ccs = c.syms->SymbolAt( ccur )
            if ccs = 0 then exit while
            dim as Tko.TypeId crt = ccs->type_
            if crt <> Tko.TYPE_NONE then
                dim as Tko.TypeId cru = c.types->Unqualify( crt )
                if c.types->Kind( cru ) = Tko.TK_REFERENCE then
                    cru = c.types->Unqualify( c.types->Inner( cru ) )
                end if
                if cru = cpu then
                    chainCast = ccur
                    exit while
                end if
            end if
            ccur = ccs->nextOverload
        wend
    end if

    dim as MirValue av
    '' A BYVAL UDT CONSTRUCTOR PARAMETER takes the argument the way any byval UDT parameter
    '' does: a caller-built COPY through the copy constructor, destroyed after the call,
    '' or the aggregate itself for a type that needs neither. Measured on fbc, over
    '' 'constructor foo( byval v as bar )': 'bar copy', then the constructor, for a bar
    '' with a copy constructor, and a plain memcpy for one without. This declined at the
    '' MT_AGG test below, which ArgNeedsUdtConv_ used to be too broad to ever reach.
    dim as boolean byvalUdt = false
    dim as long copySlot = -1
    dim as Tko.TypeId copyType = Tko.TYPE_NONE
    if (byrefP = false) andalso (chainCast = Tko.SYMBOL_NONE) then
        byvalUdt = (c.types->Kind( cpu ) = Tko.TK_UDT)
    end if
    if byvalUdt then
        if ParamIsIndirectUdt_( c, cv, 0 ) then
            if ByvalUdtCopyArg_( c, argNode, cpu, av, copySlot, copyType ) = false then return false
        else
            dim as MirValue srcA = LowerAddr( c, argNode )
            if srcA.kind = cast( ubyte, MV_NONE ) then return false
            av = LowerExprLoad( c, srcA, MT_AGG, SizeOfType( c, cpu ) )
        end if
    elseif chainCast <> Tko.SYMBOL_NONE then
        dim as MirValue cself = LowerAddr( c, argNode )
        if cself.kind = cast( ubyte, MV_NONE ) then return false
        av = EmitMemberCall( c, chainCast, cself, MT_PTR )
    elseif byrefP then
        '' A NARROW ARGUMENT FOR A USTRING PARAMETER IS A CONVERSION -- UStrParamArgTemp_.
        if UStrParamArgTemp_( c, argNode, cpt, av ) = false then
            '' ...A BYREF WSTRING PARAMETER TAKES THE CHARACTERS and a BYREF STRING a
            '' DESCRIPTOR, as CtorArgValue_ has them. Both got an address, which a literal
            '' has not got: ByrefTemp_ below then stored the literal's POINTER into a
            '' 24-byte slot and the constructor read it as a descriptor. Measured,
            '' 'takeWS( "q" )' over 'constructor WS( byref t as string )' crashed where
            '' fbc writes 'fb_StrAssign( &TMP$32$0, -1, "q", 2, 0 );
            '' _ZN2WSC1ER8FBSTRING( &TMP$33$0, &TMP$32$0 )' -- byval or byref WS alike.
            if WideRefCtorArg_( c, argNode, cpu, av ) = false then
                dim as boolean narrowStr = IsStringType( c, cpu ) andalso (IsUStringType( c, cpu ) = false)
                if narrowStr andalso (StrArgOwnDescriptor_( c, argNode, cpu ) = false) then
                    dim as long sslot = -1
                    if ByvalStrTemp_( c, argNode, cpu, av, sslot ) then
                        if sslot >= 0 then
                            c.f->locals[sslot].frontendType = cpu
                            c.strTemps.Push( cast( ulong, sslot ) )
                        end if
                    end if
                elseif narrowStr then
                    if StrDescriptorOf_( c, argNode, av ) = false then av = LowerAddr( c, argNode )
                else
                    av = LowerAddr( c, argNode )
                end if
            end if
        end if
        '' AN RVALUE HAS NO ADDRESS, AND THE CONVERSION STILL HAPPENS. The
        '' constructor that does it may take its operand BYREF -- fb's own
        '' 'constructor foo( byref v as byte )' is the corpus's shape -- and a
        '' CONSTANT argument has nothing to point at. Measured, fbc makes two
        '' temporaries and passes the first's address:
        ''
        ''   TMP$2$0 = (int8)1;
        ''   _ZN3FOOC1ERa( &TMP$3$0, &TMP$2$0 );
        ''   BYVAL_( TMP$3$0 );
        ''
        '' ByrefTemp_ is the same helper the ordinary byref-argument path uses
        '' for exactly this.
        if av.kind = cast( ubyte, MV_NONE ) then
            av = ByrefTemp_( c, argNode, cpt )
        end if
    else
        '' A UDT FOR A NUMERIC PARAMETER goes through its numeric cast first -- the [cast][ctor]
        '' chain (structpick.bas StructorCastCost), coerced from the cast's own result type.
        dim as Tko.SymbolId numCast = Tko.SYMBOL_NONE
        if c.types->Kind( au ) = Tko.TK_UDT then numCast = Tko.Check.NumericCastPick( *c.syms, *c.types, *c.names, au, cpu )
        if numCast <> Tko.SYMBOL_NONE then
            if UserCastToNum_( c, argNode, av, cpu ) = false then return false
            dim as MirType nmt = LowerType( cpt, *c.types )
            if (nmt = MT_VOID) orelse (nmt = MT_AGG) then return false
            av = CoerceTy( c, av, nmt, c.syms->SymbolAt( numCast )->type_, cpt )
            if av.kind = cast( ubyte, MV_NONE ) then return false
            chainCast = numCast   '' converted: no second coercion below
        else
            av = LowerExpr( c, argNode )
        end if
    end if
    if av.kind = cast( ubyte, MV_NONE ) then return false
    if (byrefP = false) andalso (chainCast = Tko.SYMBOL_NONE) then
        if byvalUdt = false then
            dim as MirType cmt = LowerType( cpt, *c.types )
            if (cmt = MT_VOID) orelse (cmt = MT_AGG) then return false
            av = CoerceTy( c, av, cmt, c.info->TypeOf_( argNode ))
            if av.kind = cast( ubyte, MV_NONE ) then return false
        end if
    end if

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    dim as FB.Array( of ulong ) cargs
    cargs.Push( cast( ulong, av.kind ) )
    cargs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, cv, -1, @dst, @cargs )
    '' THE CONSTRUCTOR'S OWN BYVAL COPY LIVES TO THE END OF THE STATEMENT, not to the end of
    '' the constructor call. Measured: over a bar with a destructor fbc prints 'ref 60'
    '' from the outer call BEFORE 'bar dtor' -- the copy outlives the call it was built
    '' for -- which is the statement-temporary list's lifetime.
    if copySlot >= 0 then
        c.udtTemps.Push( cast( ulong, copySlot ) )
        c.udtTempTypes.Push( cast( ulong, copyType ) )
    end if

    if TypeNeedsDtor_( c, pt ) then
        outSlot = slot
        outType = pt
    end if
    outa = dst
    return true
end function

'' THE OPERAND OF A USER-DEFINED OPERATOR, converted to the parameter's type the way
'' an ARGUMENT would be. Two shapes, and they are not the same code:
''
''   an 'operator cast' ON THE SOURCE that yields the parameter's own type is called
''   and its RESULT IS THE OPERAND -- measured, and there is no temporary and no
''   destructor at all:
''
''     struct $2TU* vr$4 = _ZN2TVcv2TUEv( &VV$0 );
''     int64 vr$6 = _ZneR2TUS0_( &UU$0, vr$4 );
''
''   a conversion CONSTRUCTOR on the destination builds a temporary, the operator is
''   called on it, and the temporary is DESTRUCTED at end of statement:
''
''     _ZN2TUC1ER2TV( &TMP$2$0, &VV$0 );
''     int64 vr$7 = _ZneR2TUS0_( &UU$0, &TMP$2$0 );
''     _ZN2TUD1Ev( &TMP$2$0 );
''
'' TWO CHAINED conversions -- a cast to STRING and then a constructor FROM string --
'' are not modelled and decline, in the cost model as well as here.
function UserConvOperand_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if (e = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then
        pu = c.types->Unqualify( c.types->Inner( pu ) )
    end if
    '' A UDT OPERAND INTO A SCALAR PARAMETER IS THE OTHER DIRECTION, and it was not
    '' modelled at all: everything below converts INTO a UDT. Measured, fbc accepts
    ''
    ''     operator - ( byref l as foo, byval r as single ) as foo
    ''     print l - r      '' r is a foo with 'operator cast( ) as double'
    ''
    '' and calls the operator. Check SELECTS it -- the cost model prices the cast --
    '' and then lowering could not build the argument, so LowerUserBinaryOp_ declined
    '' and the expression fell back to casting BOTH operands to a number and doing
    '' built-in arithmetic. That is not a decline anyone sees: it emits, it verifies,
    '' and it answers whatever the built-in answers. overload/tostring.bas is written
    '' to catch exactly this and could not: its operator computes the same number the
    '' built-in does, and only the PRINT of the UDT result told them apart.
    if c.types->Kind( pu ) <> Tko.TK_UDT then
        dim as Tko.TypeId es = c.types->Unqualify( c.info->TypeOf_( e ) )
        if c.types->Kind( es ) = Tko.TK_REFERENCE then
            es = c.types->Unqualify( c.types->Inner( es ) )
        end if
        if c.types->Kind( es ) <> Tko.TK_UDT then return false
        if UserConvToScalar_( c, e, pu, outa ) = false then return false
        outa = CoerceTy( c, outa, LowerType( pu, *c.types ), pu )
        return (outa.kind <> cast( ubyte, MV_NONE ))
    end if
    dim as Tko.TypeId et = c.types->Unqualify( c.info->TypeOf_( e ) )
    if c.types->Kind( et ) = Tko.TK_REFERENCE then
        et = c.types->Unqualify( c.types->Inner( et ) )
    end if
    if et = Tko.TYPE_NONE then return false
    if et = pu then return false

    '' THE CAST FIRST: fbc prefers it, and the file that exercises this says so in
    '' its own priority table.
    if c.types->Kind( et ) = Tko.TK_UDT then
        dim as Tko.SymbolId cur = StructorOf( c, et, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
            if cs = 0 then exit while
            dim as Tko.TypeId rt = cs->type_
            if rt <> Tko.TYPE_NONE then
                dim as Tko.TypeId ru = c.types->Unqualify( rt )
                if c.types->Kind( ru ) = Tko.TK_REFERENCE then
                    ru = c.types->Unqualify( c.types->Inner( ru ) )
                end if
                if ru = pu then
                    dim as MirValue self_ = LowerAddr( c, e )
                    if self_.kind = cast( ubyte, MV_NONE ) then return false
                    outa = EmitMemberCall( c, cur, self_, MT_PTR )
                    return (outa.kind <> cast( ubyte, MV_NONE ))
                end if
            end if
            cur = cs->nextOverload
        wend
    end if

    return UdtConvTemp_( c, e, pu, outa, outSlot, outType )
end function

'' A WIDE VALUE THAT IS NOT ITSELF A UDT: a wstring, 'wchr( n )', or a concatenation with a
'' wide term, whatever Check typed it. A lone UDT value is a copy or its own conversion, never
'' the operand of a wide-character member. WideArgCharPtrCtor_ and the 'let' and '+=' picks
'' ask it -- see WideCharOverload_.
function WideValueForCharMember_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    if e = Tko.NODE_NONE then return false
    dim as Tko.NodeId a = Unparen_( c, e )
    if ConcatHasWideTerm_( c, a ) then return true
    dim as Tko.TypeId au = c.types->Unqualify( c.info->TypeOf_( a ) )
    if c.types->Kind( au ) = Tko.TK_REFERENCE then au = c.types->Unqualify( c.types->Inner( au ) )
    if c.types->Kind( au ) = Tko.TK_UDT then return false
    return TermIsWide_( c, a )
end function

'' Whether argument 'i' of 'callee' has to be CONVERTED rather than passed. True only
'' when the parameter is a UDT and the argument is not already one of that type -- an
'' argument of the same type is a copy, and both other cases are somebody else's path.
private function ArgNeedsUdtConv_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long, _
      byval argNode as Tko.NodeId ) as boolean

    if argNode = Tko.NODE_NONE then return false
    if ParamIsArray( c, callee, idx ) then return false
    dim as Tko.TypeId pt = ParamTypeAt( c, callee, idx )
    if pt = Tko.TYPE_NONE then return false
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Inner( pt )
    pt = c.types->Unqualify( pt )
    if c.types->Kind( pt ) <> Tko.TK_UDT then return false

    '' A BARE TUPLE LIST IS NOT A CONVERSION. '( 4, 5 )' has a type of its own --
    '' (INTEGER, INTEGER) -- but it is not a value being converted FROM: it is a
    '' list of elements to be built AS the parameter's type, which is what
    '' BareTypeLiteralArg_ does. Treated as a conversion it built a temporary of
    '' the right SIZE and filled it with the wrong values: 'takesDD( (4, 5) )'
    '' stored two integer bit patterns into two doubles.
    if c.ast->Kind( argNode ) = Tko.N_TUPLE then
        if (c.ast->nodes[cast( long, argNode )].flags and Tko.NF_TYPE_LITERAL) = 0 then
            if IsTupleType_( c, pt ) then return false
        end if
    end if
    '' A WIDE STRING for a type with a 'wstring ptr' constructor -- see WideArgCharPtrCtor_.
    '' Asked before the type test: 'wchr( n )' and a wide concatenation may have none.
    if WideArgCharPtrCtor_( c, argNode, pt ) then return true

    '' 'this' is the OBJECT it points at -- InitSourceType_. Typed as the pointer, it
    '' was a UDT argument needing a conversion nobody could build, and the call dropped.
    dim as Tko.TypeId at = InitSourceType_( c, argNode )
    if at = Tko.TYPE_NONE then return false
    if c.types->Kind( at ) = Tko.TK_REFERENCE then at = c.types->Inner( at )
    at = c.types->Unqualify( at )
    if at = pt then return false
    '' A DERIVED OBJECT IS NOT A CONVERSION -- it is the base subobject at offset zero,
    '' which the ordinary path already passes.
    ''
    '' ANY OTHER UDT IS ONE WHEN THE PARAMETER'S TYPE HAS A CONSTRUCTOR FOR IT. This
    '' refused EVERY UDT argument, so the constructor never ran and the source object's
    '' bytes were passed where the destination belongs: 'TakeDWv( b )' over 'byval d as
    '' DW' with 'constructor DW( byref b as BS )' printed 100 where fbc prints 107. A
    '' constructor that takes its UDT operand BYVAL still declines in UdtConvTemp_ (the
    '' MT_AGG test) -- a decline where there was a wrong answer.
    if c.types->Kind( at ) = Tko.TK_UDT then
        if c.types->BaseDistance( at, pt ) >= 0 then return false
        if HasUdtConvCtor_( c, pt, at ) then return true
        '' ...OR THE ARGUMENT CASTS TO IT -- see UdtCastArgOk_, which is the same
        '' test the conversion makes, so a yes here is a conversion that happens.
        return UdtCastArgOk_( c, at, pt ) orelse (UdtByrefCast_( c, at, pt ) <> Tko.SYMBOL_NONE)
    end if
    return true
end function

'' THE RESULT TYPE A CALL MAY RETURN THROUGH A HIDDEN POINTER: a named procedure's own, as
'' before -- and now a PROCEDURE POINTER'S too. A call through a pointer passed no result
'' slot at all, while PtrCallSigIndex_ let the emitter infer one from the result's SIZE:
'' PsTooltip's 'pTip->TooltipCallback( hWin, hAttached, idx )', returning a DWSTRING, put
'' hWin in the slot and the LONG idx where a pointer belongs -- clang refused PsCalendar --
'' and a 4-byte result with a destructor came back "in a register" the callee never wrote:
'' garbage. fbc passes the slot first either way, measured: '(*cb)( &TMP$7$2, a, b, idx )'.
function SretCallType_ _
    ( byref c as Ctx, byval cs as Tko.Symbol ptr, byval viaPointer as boolean, _
      byval sigT as Tko.TypeId ) as Tko.TypeId

    if (viaPointer = false) andalso (cs <> 0) then
        if cs->kind = cast( ubyte, Tko.SYM_PROC ) then return cs->type_
        return Tko.TYPE_NONE
    end if
    if viaPointer = false then return Tko.TYPE_NONE
    if sigT = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( sigT ) <> Tko.TK_PROC then return Tko.TYPE_NONE
    return c.types->Inner( sigT )
end function

'' The value of a call that returned through its hidden slot is the SLOT -- its ADDRESS
'' where the caller wants a pointer (a copy constructor's source), its contents otherwise --
'' exactly as the direct path reads it; any other call's is its own result.
function SretOrResult_ _
    ( byref c as Ctx, byref sretTmp as MirValue, byref iv as MirValue, _
      byval mt as MirType ) as MirValue
    if sretTmp.kind = cast( ubyte, MV_NONE ) then return iv
    if mt = MT_PTR then return sretTmp
    return LowerExprLoad( c, sretTmp, MT_AGG )
end function

'' 'this' PASSED BYVAL IS THE OBJECT'S VALUE, not the pointer it is held in: measured,
'' fbc writes 'BYV( *THIS$1 )' for 'byv( this )' over 'byval s as T'. LowerExpr loaded the
'' pointer, so the callee read eight bytes of address as its T. Sized to the PARAMETER,
'' as UpcastAggInit_ is, so a base parameter takes the subobject at offset zero. False,
'' emitting nothing, for any other argument or a parameter that is not an aggregate.
function ThisByvalArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue ) as boolean

    if IsThisPointerIdent_( c, argNode ) = false then return false
    if pt = Tko.TYPE_NONE then return false
    if LowerType( pt, *c.types ) <> MT_AGG then return false
    dim as Tko.TypeId upt = c.types->Unqualify( pt )
    if c.types->BaseDistance( InitSourceType_( c, argNode ), upt ) < 0 then return false
    dim as MirValue sa = InitSourceAddr_( c, argNode )
    if sa.kind = cast( ubyte, MV_NONE ) then return false
    outa = LowerExprLoad( c, sa, MT_AGG, SizeOfType( c, upt ) )
    return (outa.kind <> cast( ubyte, MV_NONE ))
end function

'' THE CALLER-BUILT COPY of one byval non-trivial UDT argument.
''
'' Returns the address to pass, and the temporary's slot when one was made so the call
'' site can register it. A slot of -1 means nothing needs destroying, which is the type
'' with a copy constructor and no destructor.
''
'' THE COPY IS A STATEMENT TEMPORARY, not the call's. The call site puts it on
'' c.udtTemps the moment it is made, and it dies with the statement's other temporaries,
'' in reverse order of making. Measured, fbc's 'print takeV( nm ) + cnt( ); cnt( )'
'' prints ' 7[~7] 1', and 'f2( n1, mkFrom( n2 ) )' destroys the copy of mkFrom's
'' result, mkFrom's own argument copy, mkFrom's result and then n1's copy. Destroying it
'' straight after the call ran it before the rest of the expression. A conversion
'' temporary (UdtConvTemp_) follows the same rule, byval, byref and as an operand.
private function ByvalUdtCopyArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if argNode = Tko.NODE_NONE then return false
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false

    '' WHICH COPY, DECIDED BEFORE ANYTHING IS EMITTED. A decline that has already made
    '' a temporary is a decline that does not LOOK like one: the alloca counts as an
    '' instruction, and the statement then reads as lowered with the call missing from
    '' it. That is the shape this whole sweep exists to find.
    ''   2  the written copy constructor      1  the synthesised one      0  memcpy
    '' CopyCtorOf_ RATHER THAN THE FIRST ONE-ARGUMENT CONSTRUCTOR. 'ComPtr( of T )'
    '' declares 'constructor( byval raw as T ptr )' BEFORE its copy constructor, so
    '' the shape test met the pointer one, said 'not a copy constructor' and fell
    '' through to memcpy -- and the callee's destructor then Released an object the
    '' caller still owned. Measured: 'TakesByval( a, seen )' over an owning ComPtr
    '' reported one reference where fbc reports two, and left the caller's handle
    '' pointing at a freed object.
    dim as Tko.SymbolId cc = CopyCtorOf_( c, pt )
    dim as long how = 0
    if cc <> Tko.SYMBOL_NONE then how = 2
    if (how = 0) andalso NeedsLetBody_( c, pt ) then how = 1
    '' A DYNAMIC ARRAY MEMBER AND NO WRITTEN COPY CONSTRUCTOR IS A DECLINE.
    ''
    '' fbc synthesises one for such a type and copies the array with fb_ArrayRedimTo
    '' and an element loop; tiko-lang deliberately synthesises none, because an
    '' assignment that skipped the array would look like the field had been handled.
    '' The bitwise fallback is fine for a type whose destructor owns nothing -- fbc
    '' itself memcpys one -- but here the temporary would hold a SECOND descriptor
    '' over the caller's data, and destroying it after the call would erase it.
    '' A CONSTRUCTOR CALL IS BUILT WHERE THE COPY WOULD GO, and is that copy. 'takeo(
    '' Obj( 1 ) )' and 'takeo( type<Obj>( 2 ) )' over 'byval o as Obj' made the object in
    '' a temporary of its own and then copied it -- bitwise, for a type with no copy
    '' constructor -- into this one, and destroyed BOTH: a buffer the constructor
    '' allocated was freed twice, 0xC0000374. Measured, fbc constructs straight into the
    '' argument's temporary and destroys it once after the call:
    ''
    ''     _ZN3OBJC1Ei( &TMP$2$0, 1 );  TAKEO( &TMP$2$0 );  _ZN3OBJD1Ev( &TMP$2$0 );
    ''
    '' Decided BEFORE a slot is made, so a call that is not a constructor -- an array
    '' element, a function result -- takes the copy path below with nothing emitted.
    dim as Tko.TypeId upt = c.types->Unqualify( pt )
    dim as boolean ctorArg = (TypeCtorTypeOf_( c, argNode ) = upt)
    if (ctorArg = false) andalso (c.ast->Kind( argNode ) = Tko.N_TUPLE) then
        ctorArg = ((c.ast->nodes[cast( long, argNode )].flags and Tko.NF_TYPE_LITERAL) <> 0) _
                  andalso (c.types->Unqualify( c.info->TypeOf_( argNode ) ) = upt)
    end if
    if ctorArg andalso (StructorOf( c, upt, "__ctor" ) <> Tko.SYMBOL_NONE) then
        dim as long cslot = NewTempLocal( c, MT_AGG, sz )
        if cslot < 0 then return false
        if LowerCtorInit( c, cslot, upt, argNode ) then
            outa.kind = cast( ubyte, MV_LOCAL )
            outa.ty = cast( ubyte, MT_PTR )
            outa.id = cslot
            if TypeNeedsDtor_( c, pt ) then
                outSlot = cslot
                outType = pt
            end if
            return true
        end if
        '' Not a call LowerCtorInit builds -- the copy path below, as before.
    end if
    '' ...AND A FIELD LIST OVER A TYPE WITH NO CONSTRUCTOR is built there too: 'f( type( 123 ) )' made
    '' the literal in a temporary and COPIED it into this one, destroying both -- 2 destructor calls
    '' where fbc runs 1 (structs/byval-copy.bas).
    if ctorArg andalso (c.ast->Kind( argNode ) = Tko.N_TUPLE) andalso (StructorOf( c, upt, "__ctor" ) = Tko.SYMBOL_NONE) then
        dim as long fslot = NewTempLocal( c, MT_AGG, sz )
        if fslot < 0 then return false
        outa.kind = cast( ubyte, MV_LOCAL ) : outa.ty = cast( ubyte, MT_PTR ) : outa.id = fslot
        if TypeNeedsInit_( c, upt ) then CallImplicitCtor_( c, upt, outa )
        if LowerUdtParenInit_( c, fslot, upt, argNode ) then
            if TypeNeedsDtor_( c, pt ) then outSlot = fslot : outType = pt
            return true
        end if
        return false
    end if

    if (how = 0) andalso HasDynArrayMember_( c, pt ) then return false

    '' THE SOURCE HAS TO HAVE AN ADDRESS. A copy constructor takes one, and a bitwise
    '' copy of an rvalue that something else already owns would be a second owner of
    '' its buffer -- so an argument with no address DECLINES rather than being copied
    '' some other way.
    '' ...and for 'this' the address is the pointer's VALUE -- see InitSourceAddr_.
    dim as MirValue src = InitSourceAddr_( c, argNode )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    select case how
    case 2
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, src.kind ) )
        cargs.Push( cast( ulong, src.id ) )
        EmitStructorCall( c, cc, -1, @dst, @cargs )
    case 1
        CallImplicitCopy_( c, pt, dst, src )
    case else
        '' fbc emits '__builtin_memcpy( &TMP$4$0, &D$0, 4 )' and nothing else for a
        '' type whose only claim on this path is a destructor.
        '' SIZED TO THE PARAMETER, NOT TO THE ARGUMENT. 's1( c0, 2 )' over
        '' 'byval p as parent' with a CHILD argument loaded all sixteen bytes of the
        '' child and stored them into the eight-byte temporary -- an upcast, and the
        '' base subobject is at offset 0, so the parameter's size is the whole copy.
        '' clang refuses the mismatched store, so the module did not build.
        dim as MirValue whole = LowerExprLoad( c, src, MT_AGG, sz )
        if whole.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, dst, whole )
    end select

    if TypeNeedsDtor_( c, pt ) then
        outSlot = slot
        outType = pt
    end if
    outa = dst
    return true
end function

'' 'an = dg' WHERE THE TARGET'S TYPE HAS AN 'operator let' FOR A THIRD TYPE THE SOURCE CASTS TO:
'' fbc calls 'Animal.let( an, dg.cast( LivingThing ) )' (structs/obj_cast_ovl2.bas), where tiko
'' emitted NOTHING for the statement. Only into a parameter type UdtCastArgOk_ allows -- the
'' cast's result is bit-copied into a temporary that is not destroyed. False, emitting nothing,
'' when no 'let' takes such a type.
function LetViaCast_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval atl as Tko.TypeId, byval avt as Tko.TypeId ) as boolean
    if (atl = Tko.TYPE_NONE) orelse (avt = Tko.TYPE_NONE) orelse (atl = avt) then return false
    if (c.types->Kind( atl ) <> Tko.TK_UDT) orelse (c.types->Kind( avt ) <> Tko.TK_UDT) then return false
    dim as Tko.SymbolId cur = StructorOf( c, atl, "let" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.Symbol ptr ls = c.syms->SymbolAt( cur )
        if ls = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, ls->payload )
        dim as Tko.TypeId pt = Tko.TYPE_NONE
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            for k as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + k] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then pt = c.types->Unqualify( c.info->TypeOf_( StmtOf( c, prm )->a ) ) : exit for
            next
        end if
        if (pt <> Tko.TYPE_NONE) andalso (c.types->Kind( pt ) = Tko.TK_REFERENCE) then pt = c.types->Unqualify( c.types->Inner( pt ) )
        if (pt <> Tko.TYPE_NONE) andalso UdtCastArgOk_( c, avt, pt ) then
            dim as Tko.SymbolId cs = UdtCastToUdt_( c, avt, pt )
            dim as MirValue self_ = LowerAddr( c, value )
            if self_.kind = cast( ubyte, MV_NONE ) then return false
            dim as MirValue cv = EmitMemberCall( c, cs, self_, MT_AGG )
            if cv.kind = cast( ubyte, MV_NONE ) then return false
            dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, pt ) )
            if slot < 0 then return false
            dim as MirValue ta
            ta.kind = cast( ubyte, MV_LOCAL ) : ta.ty = cast( ubyte, MT_PTR ) : ta.id = slot
            StoreThrough( c, ta, cv )
            dim as MirValue da = LowerAddr( c, target )
            if da.kind = cast( ubyte, MV_NONE ) then return false
            dim as FB.Array( of ulong ) largs
            largs.Push( cast( ulong, ta.kind ) ) : largs.Push( cast( ulong, ta.id ) )
            EmitStructorCall( c, cur, -1, @da, @largs )
            return true
        end if
        cur = ls->nextOverload
    wend
    return false
end function

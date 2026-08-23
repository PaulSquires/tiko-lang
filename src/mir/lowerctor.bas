'' lowerctor.bas -- constructor selection for a DIM initialiser.
''
'' Split out of lower.bas, which is at its size limit.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko


'' 'dim as T x = T( 5 )'. The initialiser parses as a CALL on the type's name, so it
'' is recognised by the callee naming the variable's own UDT rather than by any
'' special syntax. Returns false when this is not a constructor call.
'' ONE CONSTRUCTOR ARGUMENT, converted the way the parameter needs rather than the way
'' the expression came. Two of the three cases are not a Coerce:
''
''   byval p as zstring ptr   <- a STRING passes its DATA POINTER, '*(char**)&S'
''   byref s as string        <- a DESCRIPTOR, which a literal or an rvalue has not got
''
'' Shared by both constructor paths, because 'dim u as U = str( t )' and
'' 'dim u as U = U( str( t ) )' differ only in spelling.
private function CtorArgValue_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outv as MirValue ) as boolean

    if argNode = Tko.NODE_NONE then return false
    dim as Tko.TypeId at = c.info->TypeOf_( argNode )

    if pt <> Tko.TYPE_NONE then
        dim as Tko.TypeId u = c.types->Unqualify( pt )
        if c.types->Kind( u ) = Tko.TK_POINTER then
            dim as Tko.TypeId pin = c.types->Unqualify( c.types->Inner( u ) )
            if c.types->Kind( pin ) = Tko.TK_BUILTIN then
                if c.types->BuiltinOf( pin ) = Tko.TY_ZSTRING then
                    if IsStringType( c, at ) then return ZstrDataOf_( c, argNode, outv )
                end if
                if c.types->BuiltinOf( pin ) = Tko.TY_WSTRING then
                    if IsWideString_( c, at ) then return WideOperand_( c, argNode, outv )
                end if
            end if
        end if
        if IsStringType( c, u ) then
            if StrDescriptorOf_( c, argNode, outv ) then return true
        end if
    end if

    outv = LowerExpr( c, argNode )
    if outv.kind = cast( ubyte, MV_NONE ) then return false
    if pt <> Tko.TYPE_NONE then
        dim as MirType pmt = LowerType( pt, *c.types )
        if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
            outv = Coerce( c, outv, pmt, IsUnsignedType( c, pt ) )
        end if
    end if
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'dim u as U = s' -- A CONVERTING CONSTRUCTOR, chosen by the initialiser's type.
''
'' Only the explicit 'dim u as U = U( s )' spelling was handled, so this one fell
'' through to the DEFAULT constructor and the initialiser was DROPPED: the object was
'' built empty, no store, no decline, no diagnostic. fbc emits
'' '_ZN1UC1EPKc( &U1, *(char**)&S )'.
function LowerConvCtorInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init_ as Tko.NodeId ) as boolean

    if init_ = Tko.NODE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId it = c.info->TypeOf_( init_ )
    if it = Tko.TYPE_NONE then return false
    '' The same type is a COPY, which the caller has already handled -- and a paren
    '' initialiser list is field stores, not a conversion.
    if c.types->Unqualify( it ) = c.types->Unqualify( t ) then return false

    dim as Tko.SymbolId ctors = StructorOf( c, t, "__ctor" )
    if ctors = Tko.SYMBOL_NONE then return false
    dim as FB.Array( of ulong ) argT
    argT.Push( cast( ulong, it ) )
    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' The parameter's type, for the conversion the argument needs.
    dim as Tko.TypeId pt = Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        exit for
    next

    dim as MirValue av
    if CtorArgValue_( c, init_, pt, av ) = false then return false
    dim as FB.Array( of ulong ) cargs
    cargs.Push( cast( ulong, av.kind ) )
    cargs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, pick, slot, 0, @cargs )
    return true
end function

function LowerCtorInit _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init_ as Tko.NodeId ) as boolean

    if init_ = Tko.NODE_NONE then return false
    if c.ast->Kind( init_ ) <> Tko.N_CALL then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false

    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init_ )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if ip->name <> c.types->NameOf( t ) then return false

    dim as Tko.SymbolId ctors = StructorOf( c, t, "__ctor" )
    if ctors = Tko.SYMBOL_NONE then return false

    '' Argument VALUES first, then the pick: the types are needed to choose, and the
    '' values must be evaluated in source order regardless of which overload wins.
    dim as FB.Array( of ulong ) argT
    dim as FB.Array( of ulong ) argKind
    dim as FB.Array( of ulong ) argId
    for i as long = 0 to cp->count - 1
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue av = LowerExpr( c, a )
        argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
        argKind.Push( cast( ulong, av.kind ) )
        argId.Push( cast( ulong, av.id ) )
    next

    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' Arguments are coerced to the chosen overload's PARAMETER types: MIR has no
    '' implicit conversions, and the overload was selected knowing a conversion would
    '' be needed, so it has to be written down.
    dim as Tko.StmtPayload ptr cpp = StmtOf( c, pn )
    dim as long ai2 = 0
    for i as long = 0 to cpp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if ai2 >= argT.Count then exit for
        dim as MirValue av
        av.kind = cast( ubyte, argKind[ai2] )
        av.ty = cast( ubyte, LowerType( cast( Tko.TypeId, argT[ai2] ), *c.types ) )
        av.id = argId[ai2]
        dim as Tko.StmtPayload ptr sp3 = StmtOf( c, prm )
        dim as MirValue cv = Coerce( c, av, _
            LowerType( c.info->TypeOf_( sp3->a ), *c.types ) )
        argKind[ai2] = cv.kind
        argId[ai2] = cv.id
        ai2 += 1
    next

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, MV_LOCAL ) )
    c.m->argPool.Push( cast( ulong, slot ) )
    for i as long = 0 to argT.Count - 1
        c.m->argPool.Push( argKind[i] )
        c.m->argPool.Push( argId[i] )
    next

    dim as Tko.InternId nm = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, MT_VOID )
        decl->isDefinition = false
        decl->paramCount = argT.Count + 1
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = argT.Count + 1
    ins.callee = fidx
    Emit( c, ins )
    return true
end function

'' Construct a 'T( args )' into a slot that already exists. Shared by the expression
'' form above and by 'return T( ... )', which constructs into the RESULT slot and needs
'' no temporary at all.
function EmitTypeCtorInto_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval slot as long, _
      byval cp as Tko.ListPayload ptr ) as boolean

    dim as Tko.SymbolId ctor = StructorWithArity( c, StructorOf( c, t, "__ctor" ), _
                                                  cp->count )
    if ctor = Tko.SYMBOL_NONE then return false

    '' THE ARGUMENTS, coerced to the constructor's own parameter types: 'TimeSpan( 0 )'
    '' passes an INTEGER literal to a 'byval as longint', and handing the runtime the
    '' narrow value would put half a quantity in a 64-bit slot.
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( ctor )
    if cs = 0 then return false
    dim as Tko.NodeId cn = cast( Tko.NodeId, cs->payload )
    if cn = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, cn )

    dim as FB.Array( of ulong ) args
    dim as long pi = 0
    for i as long = 0 to cp->count - 1
        dim as Tko.NodeId ae = cast( Tko.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue av = LowerExpr( c, ae )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        '' The matching parameter, counted over N_PARAM children only.
        dim as Tko.TypeId pt = Tko.TYPE_NONE
        dim as long seen = 0
        for k as long = 0 to pp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + k] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            if seen = pi then
                pt = c.info->TypeOf_( StmtOf( c, prm )->a )
                exit for
            end if
            seen += 1
        next
        pi += 1
        if pt <> Tko.TYPE_NONE then
            av = Coerce( c, av, LowerType( pt, *c.types ), IsUnsignedType( c, pt ) )
            if av.kind = cast( ubyte, MV_NONE ) then return false
        end if
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    next

    EmitStructorCall( c, ctor, slot, 0, @args )
    return true
end function

'' 'base( n )' inside a constructor -- THE BASE-CLASS CONSTRUCTOR CALL.
''
'' Measured: 'base( n )' in C's constructor is '_ZN1PC1Eu7INTEGER( (struct P*)THIS, n )'
'' -- a direct constructor call on the base subobject, and the implicit default base
'' construction is NOT emitted beside it.
''
'' 'extends P' is modelled as a FIELD NAMED 'base' at offset 0, which is what makes
'' this ordinary: the receiver is that field's address and the type to construct is
'' that field's type. 'base.i' and 'base.M( )' already went through the member path
'' for the same reason; only the constructor form had nowhere to go, and it declined
'' in 43 corpus lines.
''
'' Returns false when the call is not this shape, so an ordinary call to something
'' that happens to be spelled 'base' is unaffected.
function LowerBaseCtorCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr tip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( tip->name ) ) <> "base" then return false

    '' The receiver's own type, through 'this'. Nothing outside a method has one, and
    '' a method whose type does not extend anything has no 'base' field.
    if c.curProcSym = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr me_ = c.syms->SymbolAt( c.curProcSym )
    if me_ = 0 then return false
    if me_->inner = Tko.SCOPE_NONE then return false
    dim as Tko.SymbolId tsid = c.syms->LookupLocal( me_->inner, _
        c.names->Fold( c.names->GetString( "this" ) ) )
    if tsid = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return false
    if ts->type_ = Tko.TYPE_NONE then return false
    if c.types->Kind( ts->type_ ) <> Tko.TK_POINTER then return false
    dim as Tko.TypeId ot = c.types->Inner( ts->type_ )
    if ot = Tko.TYPE_NONE then return false

    dim as Tko.SymbolId bsid = UdtMemberNamed_( c, ot, "base" )
    if bsid = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr bs = c.syms->SymbolAt( bsid )
    if bs = 0 then return false
    if bs->kind <> cast( ubyte, Tko.SYM_FIELD ) then return false
    dim as Tko.TypeId bt = bs->type_
    if bt = Tko.TYPE_NONE then return false
    if c.types->Kind( bt ) <> Tko.TK_UDT then return false

    dim as Tko.SymbolId ctors = StructorOf( c, bt, "__ctor" )
    if ctors = Tko.SYMBOL_NONE then return false

    '' Argument VALUES first, then the pick: the types are needed to choose, and the
    '' values must be evaluated in source order whichever overload wins.
    dim as FB.Array( of ulong ) argT
    dim as FB.Array( of ulong ) argKind
    dim as FB.Array( of ulong ) argId
    for i as long = 0 to cp->count - 1
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue av = LowerExpr( c, a )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
        argKind.Push( cast( ulong, av.kind ) )
        argId.Push( cast( ulong, av.id ) )
    next

    dim as Tko.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ps->payload )
    if pn = Tko.NODE_NONE then return false

    '' Coerced to the chosen overload's PARAMETER types: MIR has no implicit
    '' conversions, and the overload was picked knowing a conversion would be needed.
    dim as Tko.StmtPayload ptr cpp = StmtOf( c, pn )
    dim as long ai = 0
    dim as FB.Array( of ulong ) cargs
    for i as long = 0 to cpp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if ai >= argT.Count then exit for
        dim as MirValue av
        av.kind = cast( ubyte, argKind[ai] )
        av.ty = cast( ubyte, LowerType( cast( Tko.TypeId, argT[ai] ), *c.types ) )
        av.id = argId[ai]
        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        dim as MirValue cv = Coerce( c, av, LowerType( pt, *c.types ), _
                                     IsUnsignedType( c, pt ) )
        if cv.kind = cast( ubyte, MV_NONE ) then return false
        cargs.Push( cast( ulong, cv.kind ) ) : cargs.Push( cast( ulong, cv.id ) )
        ai += 1
    next
    if ai <> cast( long, argT.Count ) then return false

    dim as MirValue recv = AddrOfThisField( c, bsid )
    if recv.kind = cast( ubyte, MV_NONE ) then return false
    EmitStructorCall( c, pick, -1, @recv, @cargs )
    return true
end function

end namespace

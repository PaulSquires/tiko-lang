'' lowerprocptr.bas -- 'procptr', in all four of its spellings.
''
'' Split out of lowerintr.bas at the 1500-line cap and included from it in the same
'' place.



declare function SameProcResult_ _
    ( byref c as Ctx, byval a as Tko.TypeId, byval b as Tko.TypeId ) as boolean
declare function SameParamType_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval pi as long, _
      byval st as Tko.TypeId, byval si as long ) as boolean

'' The overload in the chain that starts at whatever 'fnE' is bound to whose signature
'' is the procedure type 'sigN' names, as an M_FUNC_ADDR.
private function ProcPtrBySignature_ _
    ( byref c as Ctx, byval fnE as Tko.NodeId, byval sigN as Tko.NodeId, _
      byref outv as MirValue ) as boolean

    dim as Tko.TypeId st = c.types->Unqualify( c.info->TypeOf_( sigN ) )
    '' ...OR A TYPEDEF NAMING THE SIGNATURE. 'type t as sub( byval as single )'
    '' followed by 'procptr( s, t )' writes the second argument as an ORDINARY
    '' IDENTIFIER, not a type reference, so it carries no type of its own and the
    '' selector found nothing -- while the spelled-out 'sub( byval as single )'
    '' beside it worked. fbc answers the same address for both: 'P1$0 =
    '' (tmp$4)&_Z1Sf'.
    if st = Tko.TYPE_NONE then
        if c.ast->Kind( sigN ) = Tko.N_IDENT then
            dim as Tko.Symbol ptr tsy = c.syms->SymbolAt( c.info->RefOf( sigN ) )
            if tsy <> 0 then
                select case cast( Tko.SymbolKind, tsy->kind )
                case Tko.SYM_TYPEDEF, Tko.SYM_UDT
                    st = c.types->Unqualify( tsy->type_ )
                end select
            end if
        end if
    end if
    if st = Tko.TYPE_NONE then return false
    if c.types->Kind( st ) = Tko.TK_POINTER then
        st = c.types->Unqualify( c.types->Inner( st ) )
    end if
    if c.types->Kind( st ) <> Tko.TK_PROC then return false

    dim as Tko.SymbolId first_ = c.info->RefOf( fnE )
    if first_ = Tko.SYMBOL_NONE then return false

    dim as long want = c.types->ProcParamCount( st )
    dim as Tko.TypeId wantRet = c.types->Inner( st )
    dim as Tko.SymbolId cur = first_
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        if cs->kind = cast( ubyte, Tko.SYM_PROC ) then
            dim as boolean ok = (ParamCountOf( c, cur ) = want)
            if ok then ok = SameProcResult_( c, cs->type_, wantRet )
            if ok then
                for i as long = 0 to want - 1
                    if SameParamType_( c, cur, i, st, i ) = false then
                        ok = false
                        exit for
                    end if
                next
            end if
            if ok then
                outv = FuncAddrOf( c, cur )
                return (outv.kind <> cast( ubyte, MV_NONE ))
            end if
        end if
        cur = cs->nextOverload
    wend
    return false
end function


'' Two RESULT types. A SUB spells its absence TWO WAYS: a declared one carries
'' TYPE_NONE and a procedure TYPE carries the VOID builtin, because ResolveTypeRef
'' fills one in where a declaration leaves the field empty.
function SameProcResult_ _
    ( byref c as Ctx, byval a as Tko.TypeId, byval b as Tko.TypeId ) as boolean
    dim as boolean av = (a = Tko.TYPE_NONE)
    dim as boolean bv = (b = Tko.TYPE_NONE)
    if av = false then
        if c.types->Kind( a ) = Tko.TK_BUILTIN then
            av = (c.types->BuiltinOf( a ) = Tko.TY_VOID)
        end if
    end if
    if bv = false then
        if c.types->Kind( b ) = Tko.TK_BUILTIN then
            bv = (c.types->BuiltinOf( b ) = Tko.TY_VOID)
        end if
    end if
    if av andalso bv then return true
    if av orelse bv then return false
    return (c.types->Unqualify( a ) = c.types->Unqualify( b ))
end function


'' One parameter of a declared procedure against one of a procedure TYPE. The
'' reference wrapper is stripped from both because only the proc type carries it;
'' BYREF is compared from the parameter node's own flag against that wrapper.
function SameParamType_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval pi as long, _
      byval st as Tko.TypeId, byval si as long ) as boolean

    dim as Tko.TypeId want = c.types->ProcParam( st, si )
    if want = Tko.TYPE_NONE then return false
    dim as boolean wantRef = (c.types->Kind( want ) = Tko.TK_REFERENCE)
    if wantRef then want = c.types->Inner( want )

    dim as Tko.TypeId got = ParamTypeAt( c, callee, pi )
    if got = Tko.TYPE_NONE then return false
    if c.types->Kind( got ) = Tko.TK_REFERENCE then got = c.types->Inner( got )

    if c.types->Unqualify( got ) <> c.types->Unqualify( want ) then return false
    return (ParamIsByref( c, callee, pi ) = wantRef)
end function


function LowerProcPtr _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    '' 'procptr( T.constructor, sub( byval as integer ) )' WRITES A SECOND ARGUMENT to
    '' pick between overloads, so one is not the only legal count.
    if (lp->count <> 1) andalso (lp->count <> 2) then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "procptr" then return false

    '' The operand names a PROCEDURE. Anything else -- an overload set nothing chose
    '' between, a name that did not resolve -- has no single address to take.
    dim as Tko.NodeId fnE = cast( Tko.NodeId, c.ast->children[lp->first] )

    '' 'procptr( T.m, VIRTUAL )' IS NOT AN ADDRESS. Measured: fbc folds it to the
    '' member's VTABLE SLOT INDEX as an int64 -- 1 for the second virtual member and 0
    '' for the first -- which is what pointers/procptr-virtual.bas asserts against its
    '' own INDEX constants. Emitting the procedure's address instead would be a
    '' well-typed value and the wrong number.
    if lp->count = 2 then
        dim as Tko.NodeId va = cast( Tko.NodeId, c.ast->children[lp->first + 1] )
        if IsVirtualArg_( c, va ) then
            if c.ast->Kind( fnE ) <> Tko.N_MEMBER then return false
            dim as Tko.BinaryPayload ptr vmb = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, fnE )].data )]
            dim as Tko.TypeId vot = c.types->Unqualify( c.info->TypeOf_( vmb->lhs ) )
            if vot = Tko.TYPE_NONE then
                '' 'T.m' names the TYPE, not a value, so the base carries no type of
                '' its own: it is the type reference itself.
                vot = c.types->Unqualify( c.info->TypeOf_( fnE ) )
                if c.ast->Kind( vmb->lhs ) = Tko.N_IDENT then
                    dim as Tko.SymbolId vts2 = c.info->RefOf( vmb->lhs )
                    dim as Tko.Symbol ptr vtsy = c.syms->SymbolAt( vts2 )
                    if vtsy <> 0 then vot = c.types->Unqualify( vtsy->type_ )
                end if
            end if
            if vot = Tko.TYPE_NONE then return false
            dim as Tko.SymbolId vps = c.info->RefOf( fnE )
            if vps = Tko.SYMBOL_NONE then vps = c.info->RefOf( vmb->rhs )
            if vps = Tko.SYMBOL_NONE then return false
            dim as Tko.Symbol ptr vpsy = c.syms->SymbolAt( vps )
            if vpsy = 0 then return false
            if c.vts = 0 then return false

            '' THE DECLARATION ITSELF MUST SAY VIRTUAL OR ABSTRACT. A derived type's
            '' override written as a plain 'declare sub proc1( )' fills the base's slot
            '' and is dispatched through it -- but fbc answers -1 for
            '' 'procptr( D.proc1, virtual )', not the slot it occupies. Measured, and
            '' the answer is a CONSTANT either way rather than a decline.
            dim as long vslot = -1
            dim as Tko.NodeId vpn = cast( Tko.NodeId, vpsy->payload )
            if (vpn <> Tko.NODE_NONE) andalso (c.ast->Kind( vpn ) = Tko.N_PROC) then
                dim as ushort vmods = StmtOf( c, vpn )->extra
                if (vmods and (Tko.PF_VIRTUAL or Tko.PF_ABSTRACT)) <> 0 then
                    vslot = c.vts->SlotOf( vot, vps, vpn )
                end if
            end if
            outv = ConstInt( c, vslot, MT_I64 )
            return true
        end if
    end if

    '' 'procptr( f, sub( ) )' PICKS AN OVERLOAD BY SIGNATURE. Measured, over two subs
    '' called 's' and two members called 'M':
    ''
    ''   procptr( s, sub( ) )                 &_Z1Sv
    ''   procptr( s, sub( byval as byte ) )   &_Z1Sa
    ''   procptr( C.M, sub( byval as long ) ) &_ZN1C1MEi
    ''
    '' Check PICKS AND TYPES it too, in MemberProcPtr_ -- but the ref it writes onto
    '' the operand does not survive: TypeOf_ is asked about that node again later and
    '' the ordinary member binding puts the FIRST overload back. So the selection is
    '' repeated here, over the chain that hangs off whatever IS bound, and the two
    '' agree because they read the same signature.
    ''
    '' Matched on ARITY, each parameter's type and its passing mode, and the result
    '' type. A SUB spells its absent result two ways -- TYPE_NONE on a declaration and
    '' the VOID builtin in a procedure TYPE, which is what ResolveTypeRef fills in --
    '' so comparing them raw made every 'procptr( s, sub( ) )' miss its own overload.
    if lp->count = 2 then
        dim as Tko.NodeId sigN = cast( Tko.NodeId, c.ast->children[lp->first + 1] )
        dim as boolean sigOk = (c.ast->Kind( sigN ) = Tko.N_TYPEREF)
        if sigOk = false then sigOk = (c.ast->Kind( sigN ) = Tko.N_IDENT)
        if sigOk then
            dim as MirValue sv
            if ProcPtrBySignature_( c, fnE, sigN, sv ) then
                outv = sv
                return true
            end if
        end if
    end if

    '' A RUNTIME ENTRY POINT, which fbc predeclares and nothing in the source declares:
    '' 'procptr( fb_ArrayRedimEx )'. Its address is the same M_FUNC_ADDR over the
    '' inventory's own linker name.
    if c.ast->Kind( fnE ) = Tko.N_IDENT then
        dim as Tko.IdentPayload ptr rip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, fnE )].data )]
        dim as RtlId rr = RtlByName( c.names->Spelling( rip->name ) )
        '' ...AND AN INTRINSIC NAMES ONE TOO. 'procptr( cls )' is '&fb_Cls' --
        '' measured, for sixty spellings -- so the keyword resolves to the same
        '' address the runtime name does.
        if rr = RTL_NONE then
            rr = IntrinsicProcPtrRtl_( Tko.Text.LowerAscii( _
                c.names->Spelling( rip->name ) ) )
        end if
        if rr <> RTL_NONE then
            dim as boolean is32 = (c.types->target.pointerBits = 32)
            dim as Tko.InternId rnm = c.names->GetString( RtlLinkName( rr, is32 ) )
            dim as long ridx = -1
            for i as long = 0 to c.m->functions.Count - 1
                if c.m->functions[i]->name = rnm then
                    ridx = i
                    exit for
                end if
            next
            if ridx < 0 then
                dim as MirFunction ptr rdecl = _
                    c.m->AddFunction( rnm, RtlReturn( rr, is32 ) )
                rdecl->isDefinition = false
                RtlSignature( rdecl, rr, is32 )
                ridx = c.m->functions.Count - 1
            end if
            dim as MirInst rfa
            rfa.op = cast( ushort, M_FUNC_ADDR )
            rfa.ty = cast( ubyte, MT_PTR )
            rfa.callee = cast( ulong, ridx )
            outv = Emit( c, rfa )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
    end if

    '' CHECK DECIDES WHICH PROCEDURE, and if it could not, neither can this. A second
    '' argument that selected nothing leaves the whole expression untyped -- and
    '' emitting an address for it anyway put a pointer in a VOID slot, which is a
    '' verify failure rather than a decline. 'procptr( T.m, virtual )' is exactly that
    '' shape: it names which OVERRIDE to point at, which this path cannot answer.
    if lp->count = 2 then
        if c.info->TypeOf_( id ) = Tko.TYPE_NONE then return false
    end if

    outv = FuncAddrOf( c, c.info->RefOf( fnE ) )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' The ADDRESS OF A RUNTIME ENTRY POINT, as an M_FUNC_ADDR over the function table.
''
'' PUT passes one -- the blender for its blend mode -- and no source expression names
'' it, so it is reached the way ERASE reaches a destructor: by asking the inventory
'' rather than the symbol table.

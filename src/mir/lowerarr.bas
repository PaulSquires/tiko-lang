'' lowerarr.bas -- addresses: array indexing, and LowerAddr itself.
''
'' The address of a(i, j) is
''
''     base + SUM( index_k * stride_k )  -  SUM( lbound_k * stride_k )
''
'' row-major, so the LAST dimension has stride elemSize and each earlier one is scaled by
'' the element counts of every dimension after it. The second sum is a constant, and fbc
'' folds it into a single bias -- 'dim as long b(1 to 3, 1 to 4)' indexed b(i,i) becomes
''
''     *(int32*)( (int64)B$1 + ((((int64)I$1 << 2) + (int64)I$1) << 2) + -20ll )
''
'' which is base + 20i - 20: stride 16 for the first dimension, 4 for the second, and a
'' bias of 1*16 + 1*4 = 20.

#include once "mir/lowerctx.bi"

namespace Tko.Mir
declare function UserOpTempAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean


'' Defined below; LowerAddr above it needs the name.
declare function LowerPtrIndex( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

declare function ArrayStrides _
    ( byref c as Ctx, byval t as Tko.TypeId, byref strides as FB.Array( of longint ), _
      byref bias as longint ) as boolean

'' Whether a node is an 'iif' whose ARMS are UDTs. Asked before anything is lowered:
'' LowerAggIif_ emits a branch sequence, and a caller that tried it speculatively and
'' then fell through would evaluate both arms twice.
function IsAggIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then return false
    for k as long = 1 to 2
        dim as Tko.TypeId at = _
            c.info->TypeOf_( cast( Tko.NodeId, c.ast->children[lp->first + k] ) )
        if at <> Tko.TYPE_NONE then
            if c.types->Kind( at ) = Tko.TK_UDT then return true
        end if
    next
    return false
end function


'' The ADDRESS of an assignable expression, or an undef value when this slice cannot
'' produce one (a member, an index, a dereference).
function LowerAddr _
    ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    dim as MirValue v
    if id = Tko.NODE_NONE then return v

    '' THE OPEN 'with' SUBJECT WAS ALREADY EVALUATED. Resolve points every baseless
    '' '.field' at the subject's own node, so the node is reached once per member --
    '' and lowering it each time would call 'with( status( hFindSlot( @this ) ) )' once
    '' per field. fbc evaluates the subject ONCE; its address is on the stack, so this
    '' hands the same one back.
    for wi as long = c.withNode.Count - 1 to 0 step -1
        if cast( Tko.NodeId, c.withNode[wi] ) = id then
            dim as MirValue wslotv
            wslotv.kind = cast( ubyte, c.withKind[wi] )
            wslotv.ty = cast( ubyte, MT_PTR )
            wslotv.id = cast( long, c.withId[wi] )
            '' The SLOT holds the address; the address IS its contents.
            return LowerExprLoad( c, wslotv, MT_PTR )
        end if
    next

    '' PARENTHESES ARE TRANSPARENT TO AN ADDRESS. '( ( d + s ) - s ).Ticks' wraps the
    '' inner operator in a paren, and with no case for one here the address fell
    '' through to the value path, which stored the RESULT POINTER into a fresh
    '' aggregate temporary -- an address where the object belonged.
    if c.ast->Kind( id ) = Tko.N_PAREN then
        dim as Tko.ListPayload ptr plp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if plp->count = 1 then
            return LowerAddr( c, cast( Tko.NodeId, c.ast->children[plp->first] ) )
        end if
        return v
    end if

    '' 'type<P>( 5, 6 )' HAS AN ADDRESS ONLY BECAUSE A TEMPORARY IS BUILT FOR IT, which
    '' is what a byref parameter defaulted from one needs. fbc does the same.
    if c.ast->Kind( id ) = Tko.N_TUPLE then
        dim as MirValue ula
        if LowerUdtLiteralAddr_( c, id, ula ) then return ula
        return v
    end if

    '' A USER OPERATOR RETURNING A UDT HAS AN ADDRESS, because the result is a
    '' TEMPORARY the caller made: '( ( d + s ) - s ).Ticks' is how fb/chrono.bi's own
    '' tests are written, and LowerAddr had no case for a BINARY at all -- so the
    '' member on the result declined while the same operator assigned to a variable
    '' lowered.
    ''
    '' An sret operator already hands back its temporary's address; a TRIVIAL UDT
    '' comes back by value and is stored into one here, exactly as a small UDT
    '' returned from an ordinary call is below.
    if (c.ast->Kind( id ) = Tko.N_BINARY) orelse (c.ast->Kind( id ) = Tko.N_UNARY) then
        dim as MirValue uov
        if UserOpTempAddr_( c, id, uov ) then return uov
    end if

    '' A BYREF-RETURNING CALL YIELDS AN ADDRESS, which is the whole point of one:
    '' fbc writes 'int32* vr = _ZN1TixEi( &A, 1 ); *vr = 99;' for 'a[ 1 ] = 99'. So
    '' 'operator []' over a container is an LVALUE, and without this every assignment
    '' through one declined -- which is how a container is written to.
    ''
    '' The call is lowered as a POINTER rather than as its declared element type: the
    '' reference IS the pointer, and asking for the element would load through it.
    '' N_CALL only: an N_INDEX over a UDT is the 'operator []' path further down,
    '' which knows how to find the receiver -- this one would call the operator with
    '' the subscript and NO 'this'.
    if c.ast->Kind( id ) = Tko.N_CALL then
        '' 'P( 3 ).v' -- A MEMBER ON A CONSTRUCTOR TEMPORARY. The path below asks for a
        '' SYM_PROC, and a type-constructor call binds to the UDT instead, so it fell
        '' straight through while the same member on a FUNCTION's returned temporary
        '' worked. fb/chrono.bi writes most of its assertions this way.
        dim as MirValue ctv
        if LowerTypeCtorTempAddr_( c, id, ctv ) then return ctv

        dim as Tko.ListPayload ptr bl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.SymbolId bcal = c.info->RefOf( id )
        if bcal = Tko.SYMBOL_NONE then bcal = c.info->RefOf( bl->target )
        dim as Tko.Symbol ptr bcs = c.syms->SymbolAt( bcal )
        if bcs <> 0 then
            if bcs->kind = cast( ubyte, Tko.SYM_PROC ) then
                dim as Tko.NodeId bpn = cast( Tko.NodeId, bcs->payload )
                if (bpn <> Tko.NODE_NONE) andalso (c.ast->Kind( bpn ) = Tko.N_PROC) then
                    '' ...and a UDT RETURNED THROUGH A HIDDEN POINTER is already a
                    '' temporary the caller owns, so the call's value is its address.
                    '' 'this.GetD( ).W' -- a property on a call result -- asked for one
                    '' and got nothing, which is how fb/chrono.bi writes most of its
                    '' accessors.
                    dim as boolean byrefRet = _
                        ((c.ast->nodes[cast( long, bpn )].flags and Tko.NF_BYREF) <> 0)
                    if byrefRet orelse UsesSretReturn( c, bcs->type_ ) then
                        dim as MirValue bv = LowerCallParts( c, bl->target, bcal, _
                                                            bl->first, bl->count, MT_PTR )
                        if bv.kind <> cast( ubyte, MV_NONE ) then return bv
                    elseif bcs->type_ <> Tko.TYPE_NONE then
                        '' A SMALL UDT COMES BACK IN REGISTERS, so there is no hidden
                        '' temporary to take the address of -- but 'GetD( ).a' still
                        '' needs one. The value is stored into a temporary of its own
                        '' type and that is what the member reads through.
                        if c.types->Kind( bcs->type_ ) = Tko.TK_UDT then
                            dim as MirValue av = LowerCallParts( c, bl->target, bcal, _
                                                                 bl->first, bl->count, MT_AGG )
                            if av.kind <> cast( ubyte, MV_NONE ) then
                                dim as long aslot = NewTempLocal( c, MT_AGG, _
                                    SizeOfType( c, bcs->type_ ) )
                                if aslot >= 0 then
                                    dim as MirValue at2
                                    at2.kind = cast( ubyte, MV_LOCAL )
                                    at2.ty = cast( ubyte, MT_PTR )
                                    at2.id = aslot
                                    StoreThrough( c, at2, av )
                                    return at2
                                end if
                            end if
                        end if
                    end if
                end if
            end if
        end if
    end if

    '' A QUALIFIED NAME -- 'ns.counter' -- is bound by Resolve to the symbol inside the
    '' namespace, so its address is that symbol's storage. It is NOT a member access on
    '' a value and has no base to compute from.
    ''
    '' Without this the resolve fix made 'ns.counter = 2' stop being counted as declined
    '' while still emitting no store: the statement silently did nothing, which is worse
    '' than the honest decline it replaced.
    if c.ast->Kind( id ) = Tko.N_MEMBER then
        dim as Tko.SymbolId qsid = c.info->RefOf( id )
        if qsid <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr qs = c.syms->SymbolAt( qsid )
            if qs <> 0 then
                if qs->kind = cast( ubyte, Tko.SYM_VARIABLE ) then return AddrOfVar( c, qsid )
            end if
        end if
    end if

    '' 'x.f' is the base's address plus a CONSTANT offset. The offset comes from the
    '' measured layout, and Check already bound the member to its field symbol, so
    '' nothing is looked up twice.
    if c.ast->Kind( id ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' CONST IS TRANSPARENT TO A FIELD ACCESS, and the UDT store is keyed by the
        '' UNQUALIFIED type -- so 'x.n' over a 'byref x as const T' looked its field up
        '' under a type the store has never heard of, found nothing, and declined.
        '' Every copy constructor in the corpus is written 'byref x as const T'.
        dim as Tko.TypeId bt = c.types->Unqualify( c.info->TypeOf_( mp->lhs ) )
        dim as MirValue base_

        '' 'p->v' OVER A UDT IS A CALL to that UDT's global 'operator ->', whose byref
        '' result is a POINTER at the ABI -- so the access is that call and then the
        '' ordinary constant field offset. Measured from what fbc emits:
        ''
        ''     h->v = 77   vr = _ZptR6HOLDER( &H )   *(int32*)vr = 77
        ''
        '' and the operator is called AGAIN for every occurrence, which is what fbc
        '' does rather than caching the pointer.
        if (bt <> Tko.TYPE_NONE) andalso _
           ((c.ast->nodes[cast( long, id )].flags and Tko.NF_ARROW) <> 0) andalso _
           (c.types->Kind( bt ) = Tko.TK_UDT) then
            dim as Tko.SymbolId aop = Tko.Check.ArrowOperatorFor( _
                *c.types, *c.syms, *c.names, *c.ast, *c.info, bt )
            if aop <> Tko.SYMBOL_NONE then
                dim as Tko.TypeId art = Tko.Check.ArrowResultType( *c.types, *c.syms, aop )
                if art <> Tko.TYPE_NONE then
                    dim as MirValue self_ = LowerAddr( c, mp->lhs )
                    if self_.kind = cast( ubyte, MV_NONE ) then return v
                    dim as FB.Array( of ulong ) aargs
                    aargs.Push( cast( ulong, self_.kind ) )
                    aargs.Push( cast( ulong, self_.id ) )
                    base_ = EmitDirectCall_( c, aop, MT_PTR, aargs )
                    if base_.kind = cast( ubyte, MV_NONE ) then return v
                    bt = art
                    dim as Tko.SymbolId afs = c.info->RefOf( id )
                    dim as Tko.Symbol ptr afsym = c.syms->SymbolAt( afs )
                    if afsym = 0 then return v
                    if (afsym->flags and Tko.SYMF_BITFIELD) <> 0 then return v
                    dim as boolean afound = false
                    dim as long aoff = c.udts->FieldOffset( bt, afsym->name, afound )
                    if afound = false then return v
                    dim as MirInst ains
                    ains.op = cast( ushort, M_FIELD_ADDR )
                    ains.ty = cast( ubyte, MT_PTR )
                    ains.a = base_
                    ains.imm = aoff
                    return Emit( c, ains )
                end if
            end if
        end if

        '' A PAREN-LESS CALL AS THE BASE. 'mk.field' and 'T.StaticFn.field' are CALLS
        '' -- measured, fbc emits 'vr = MK( ); TMP = vr;' for 'mk.ticks' and the same
        '' code it emits for 'mk( ).ticks', which is the whole difference between the
        '' two spellings.
        ''
        '' Asking LowerAddr for the address of a PROCEDURE gave its CODE address, and
        '' the field offset was then applied to that: 'mk.ticks' read the function's
        '' own bytes as a struct. It lowered, it verified, and nothing declined.
        '' chrono/core.bas writes 'DateTime.MaxValue.Day' eleven times.
        dim as boolean calledBase = false
        dim as Tko.Symbol ptr bsy = c.syms->SymbolAt( c.info->RefOf( mp->lhs ) )
        if bsy <> 0 then
            if LowerBareProcCall_( c, mp->lhs, MT_AGG, base_ ) then
                bt = c.types->Unqualify( bsy->type_ )
                '' An SRET result IS the temporary's address already; anything
                '' narrower comes back as a VALUE and needs one of its own before a
                '' field offset can be applied to it.
                if UsesSretReturn( c, bsy->type_ ) = false then
                    dim as long btslot = _
                        NewTempLocal( c, MT_AGG, SizeOfType( c, bsy->type_ ) )
                    if btslot < 0 then return v
                    dim as MirValue bta
                    bta.kind = cast( ubyte, MV_LOCAL )
                    bta.ty = cast( ubyte, MT_PTR )
                    bta.id = btslot
                    StoreThrough( c, bta, base_ )
                    base_ = bta
                end if
                calledBase = true
            end if
        end if

        if calledBase then
            '' the call's value IS the temporary's address
        elseif (bt <> Tko.TYPE_NONE) andalso (c.types->Kind( bt ) = Tko.TK_POINTER) then
            '' Through a pointer the base is the VALUE, not its slot. The POINTEE may
            '' be const too -- 'byval p as const T ptr' -- so it is unqualified as well.
            base_ = LowerExpr( c, mp->lhs )
            bt = c.types->Unqualify( c.types->Inner( bt ) )
        else
            base_ = LowerAddr( c, mp->lhs )
        end if
        if base_.kind = cast( ubyte, MV_NONE ) then return v
        dim as Tko.SymbolId fsym = c.info->RefOf( id )
        dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsym )
        if fs = 0 then return v

        '' A BITFIELD HAS NO ADDRESS OF ITS OWN. Its declared type sizes the storage
        '' UNIT, not the field, so handing back the unit's address would let an
        '' ordinary load or store read and write every field packed beside it. The
        '' layout is not packed yet either -- tools/gen/check-udt.sh measures that gap
        '' on three shapes -- so this declines rather than emitting an access that
        '' would be wrong twice over.
        if (fs->flags and Tko.SYMF_BITFIELD) <> 0 then return v

        dim as boolean found = false
        dim as long off = c.udts->FieldOffset( bt, fs->name, found )
        if found = false then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_FIELD_ADDR )
        ins.ty = cast( ubyte, MT_PTR )
        ins.a = base_
        ins.imm = off
        return Emit( c, ins )
    end if

    '' 'cast( T, x )' OVER AN AGGREGATE IS A REINTERPRETATION, so it has the operand's
    '' address and the target type's layout. That is what an up-cast IS in FreeBASIC --
    '' 'cast( T1, x2 ).s' reads T1's own field out of a T2 -- and without an address the
    '' member access on it declined, 73 statements in the corpus file that exists to
    '' test exactly this.
    ''
    '' Only for an aggregate target: a numeric cast produces a VALUE and has no address,
    '' and handing back the operand's would read the wrong width from it.
    if c.ast->Kind( id ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr cl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if (cl->count = 2) andalso (cl->target <> Tko.NODE_NONE) then
            if c.ast->Kind( cl->target ) = Tko.N_IDENT then
                dim as Tko.IdentPayload ptr cip = _
                    @c.ast->idents[cast( long, c.ast->nodes[cast( long, cl->target )].data )]
                dim as string cnm = Tko.Text.LowerAscii( c.names->Spelling( cip->name ) )
                if (cnm = "cast") orelse (cnm = "ctype") then
                    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cl->first] )
                    if c.ast->Kind( a0 ) = Tko.N_TYPEREF then
                        dim as Tko.TypeId tt = c.info->TypeOf_( id )
                        if tt <> Tko.TYPE_NONE then
                            if c.types->Kind( tt ) = Tko.TK_UDT then
                                return LowerAddr( c, cast( Tko.NodeId, _
                                                  c.ast->children[cl->first + 1] ) )
                            end if
                        end if
                    end if
                end if
            end if
        end if
    end if

    '' Parentheses are kept in the tree for diagnostics, so an address has to see through
    '' them: '(*p).M( )' is a PAREN around a deref, and stopping at the paren lost the
    '' receiver.
    if c.ast->Kind( id ) = Tko.N_PAREN then
        dim as Tko.ListPayload ptr pp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if pp->count = 1 then
            return LowerAddr( c, cast( Tko.NodeId, c.ast->children[pp->first] ) )
        end if
        return v
    end if

    '' The address of '*p' IS p. Without this '(*p).M( )' had no receiver to pass, and
    '' 'sub P( byref x as T )' -- which lowering sees as a dereference -- had no address
    '' to store through.
    if c.ast->Kind( id ) = Tko.N_DEREF then
        dim as Tko.UnaryPayload ptr dp = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' ...UNLESS IT IS A USER OPERATOR. '*p' over a UDT is a CALL to that UDT's
        '' 'operator *', which fb/sharedptr.bi and fb/comptr.bi both declare byref --
        '' and it is spelled with the same token as a dereference, so it arrives here.
        '' Check binds the operator onto this node; taking the operand's value instead
        '' would read the HANDLE as if it were the pointer.
        if c.info->RefOf( id ) <> Tko.SYMBOL_NONE then
            dim as MirValue duv
            if LowerUserUnaryOp_( c, id, dp, MT_PTR, duv ) then return duv
        end if
        return LowerExpr( c, dp->operand )
    end if

    '' A UDT 'iif' HAS AN ADDRESS -- the temporary it builds its result in. That is
    '' what '(iif( c, a, b )).i' needs, and without it the member access had no base
    '' to offset from and the whole statement declined.
    ''
    '' Asked by SHAPE before anything is lowered, because LowerAggIif_ emits a branch
    '' sequence and reaching it twice would evaluate both arms twice.
    if IsAggIif_( c, id ) then
        dim as Tko.ListPayload ptr ip2 = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as MirValue av
        if LowerAggIif_( c, cast( Tko.NodeId, c.ast->children[ip2->first] ), _
                            cast( Tko.NodeId, c.ast->children[ip2->first + 1] ), _
                            cast( Tko.NodeId, c.ast->children[ip2->first + 2] ), av ) then
            return av
        end if
        return v
    end if

    '' A subscript is spelled as a call, so it is recognised by the callee's TYPE.
    if IsArrayIndex( c, id ) then return LowerArrayIndex( c, id )

    '' '[ ]' is a separate node and only ever pointer indexing in -lang fb.
    if c.ast->Kind( id ) = Tko.N_INDEX then return LowerPtrIndex( c, id )

    if c.ast->Kind( id ) <> Tko.N_IDENT then return v
    dim as Tko.SymbolId sid = c.info->RefOf( id )
    if sid = Tko.SYMBOL_NONE then return v

    '' AN UNQUALIFIED FIELD, inside a method of its own type. 'v = 1' where v is a
    '' field is 'this->v = 1', and there is no base written to say so.
    ''
    '' AddrOfVar gave it a LOCAL SLOT instead -- a fresh variable that shadowed the
    '' field for the whole procedure. So 'v = 1' wrote to the stack, 'this.v = 2' beside
    '' it wrote to the object, and 'return v' read the local back UNINITIALISED. No
    '' diagnostic, no verify failure, correct-looking MIR, and this is the idiomatic
    '' spelling: most FreeBASIC methods never write 'this.'.
    ''
    '' The sibling-CALL case already had this handled; the sibling-FIELD case did not.
    dim as Tko.Symbol ptr fsy = c.syms->SymbolAt( sid )
    if fsy <> 0 then
        if fsy->kind = cast( ubyte, Tko.SYM_FIELD ) then return AddrOfThisField( c, sid )
    end if

    return AddrOfVar( c, sid )
end function

'' 'this->field', for a field named without a base.
''
'' The owning type comes from THIS's own type -- a pointer to it -- rather than from
'' the field symbol, because that is the pointer the offset is applied to and the two
'' must agree. Returns nothing when there is no 'this' in scope, which is a field
'' referenced from outside any method: an error the checker owes, not something to
'' invent an address for.
function AddrOfThisField( byref c as Ctx, byval fsid as Tko.SymbolId ) as MirValue
    dim as MirValue v
    if c.curProcSym = Tko.SYMBOL_NONE then return v
    dim as Tko.Symbol ptr me = c.syms->SymbolAt( c.curProcSym )
    if me = 0 then return v
    if me->inner = Tko.SCOPE_NONE then return v

    dim as Tko.SymbolId tsid = c.syms->LookupLocal( me->inner, _
        c.names->Fold( c.names->GetString( "this" ) ) )
    if tsid = Tko.SYMBOL_NONE then return v
    dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return v
    if ts->type_ = Tko.TYPE_NONE then return v
    if c.types->Kind( ts->type_ ) <> Tko.TK_POINTER then return v
    dim as Tko.TypeId bt = c.types->Inner( ts->type_ )
    if bt = Tko.TYPE_NONE then return v

    dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsid )
    if fs = 0 then return v
    dim as boolean found = false
    dim as long off = c.udts->FieldOffset( bt, fs->name, found )
    if found = false then return v

    '' THIS holds a pointer, so the base is its VALUE. Its own address would be a
    '' pointer to a pointer.
    dim as MirValue ta = AddrOfVar( c, tsid )
    if ta.kind = cast( ubyte, MV_NONE ) then return v
    dim as MirValue base_ = LowerExprLoad( c, ta, MT_PTR )
    if base_.kind = cast( ubyte, MV_NONE ) then return v

    dim as MirInst fa
    fa.op = cast( ushort, M_FIELD_ADDR )
    fa.ty = cast( ubyte, MT_PTR )
    fa.a = base_
    fa.imm = off
    return Emit( c, fa )
end function

'' 'p[i]' -- POINTER INDEXING, which is '*(p + i)' scaled by the pointee's size. There
'' was no N_INDEX case in lowering at all, so every one of these produced nothing: a
'' read declined, and a write through 'p[i] = x' stored nowhere.
''
'' It is the same shape as an array subscript, minus the bounds: the base is the
'' pointer's VALUE rather than its address, there is one index, and the stride is the
'' pointee's size. fbc computes it the same way.
'' THE CHARACTER SIZE of a string type, or 0 for anything else: 1 narrow, 2 wide.
''
'' BOTH SPELLINGS COUNT. The SIZED form is an ARRAY of the builtin ('zstring * 8'); the
'' UNSIZED one is the BARE builtin, which is what a 'zstring ptr' points at and what
'' '*pz' derefs to. Keeping them apart is what made '(*pz)[i]' match neither the array
'' test nor the pointer one, so it declined while the two spellings either side of it
'' worked.
function CharElemSize_( byref c as Ctx, byval t as Tko.TypeId ) as long
    if t = Tko.TYPE_NONE then return 0
    dim as Tko.TypeId el = t
    if c.types->Kind( el ) = Tko.TK_ARRAY then el = c.types->Inner( el )
    if el = Tko.TYPE_NONE then return 0
    if c.types->Kind( el ) <> Tko.TK_BUILTIN then return 0
    select case c.types->BuiltinOf( el )
    case Tko.TY_ZSTRING, Tko.TY_FIXSTR : return 1
    '' A ustring's unit is TWO BYTES on every target, where a wstring's is 2 on
    '' Windows and 4 on Linux -- so it shares the stride here and not the rule.
    case Tko.TY_WSTRING, Tko.TY_FIXUSTR : return 2
    end select
    return 0
end function

function LowerPtrIndex( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
    dim as MirValue none_
    if c.ast->Kind( id ) <> Tko.N_INDEX then return none_
    dim as Tko.ListPayload ptr sp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->count <> 1 then return none_
    if sp->target = Tko.NODE_NONE then return none_

    dim as Tko.TypeId pt = c.info->TypeOf_( sp->target )
    if pt = Tko.TYPE_NONE then return none_

    '' A UDT WITH 'operator []' -- every container in the runtime headers has one, and
    '' 'a[ 0 ]' over one is a CALL, not an address computation. What comes back is a
    '' BYREF result, so it is a pointer to the element and the caller loads through it
    '' exactly as it would through any other address this function returns.
    if c.types->Kind( pt ) = Tko.TK_UDT then
        dim as Tko.SymbolId ixs = UdtMemberNamed_( c, pt, "[]" )
        if ixs <> Tko.SYMBOL_NONE then
            if sp->count <> 1 then return none_
            dim as MirValue self_ = LowerAddr( c, sp->target )
            if self_.kind = cast( ubyte, MV_NONE ) then return none_
            dim as Tko.NodeId ie = cast( Tko.NodeId, c.ast->children[sp->first] )
            dim as MirValue iv = LowerExpr( c, ie )
            if iv.kind = cast( ubyte, MV_NONE ) then return none_
            iv = Coerce( c, iv, MT_I32, IsUnsignedType( c, c.info->TypeOf_( ie ) ) )
            dim as FB.Array( of ulong ) ia
            ia.Push( cast( ulong, iv.kind ) ) : ia.Push( cast( ulong, iv.id ) )
            return EmitMemberCallArgs_( c, ixs, self_, MT_PTR, @ia )
        end if
    end if

    '' A STRING SUBSCRIPTED IS ITS CHARACTER -- one byte narrow, TWO wide -- and the
    '' base is the string's ADDRESS rather than a value loaded from it, because a char
    '' array has no pointer to load. Measured:
    ''
    ''     n = a[1]   over 'wstring * 8'   *(uint16*)((int64)(uint16*)A + 2ll)
    ''     n = z[1]   over 'zstring * 8'   *(uint8*)((int64)(char*)Z + 1ll)
    ''
    '' THREE SPELLINGS mean the same thing and all three arrive here: 'z[i]' over a
    '' fixed string, 'pz[i]' over a 'zstring ptr', and '(*pz)[i]', whose target is the
    '' UNSIZED builtin and matched neither the array test nor the pointer one. The
    '' byte-by-byte loop fbcunit's own CU_ASSERT_WSTRING_EQUAL writes is exactly this
    '' shape, so all three appear in the corpus.
    '' A VAR-LENGTH STRING SUBSCRIPTED IS ITS CHARACTER TOO, but its base is the DATA
    '' POINTER LOADED OUT OF THE DESCRIPTOR rather than the descriptor's own address --
    '' a descriptor is not a character array. Measured:
    ''
    ''     s[1]   over 'string'    *(uint8*) ((uint8*)*(char**)&S$0   + 1ll)
    ''     u[1]   over 'ustring'   *(uint16*)((uint8*)*(uint16**)&U$0 + 2ll)
    ''
    '' Neither flavour had a case at all: CharElemSize_ answers 0 for both descriptors,
    '' so they fell through to the POINTER path, whose type test then refused them. A
    '' read declined and a write stored nowhere. 's[i]' is ordinary FreeBASIC, and
    '' fb/tuiwidth.bi builds every surrogate pair this way.
    dim as long dsz = 0
    if c.types->Kind( pt ) = Tko.TK_BUILTIN then
        select case c.types->BuiltinOf( pt )
        case Tko.TY_STRING  : dsz = 1
        case Tko.TY_USTRING : dsz = 2
        end select
    end if

    dim as long esz = CharElemSize_( c, pt )
    dim as MirValue base_
    if dsz > 0 then
        esz = dsz
        dim as MirValue desc = LowerAddr( c, sp->target )
        if desc.kind = cast( ubyte, MV_NONE ) then return none_
        '' Field 0 of the descriptor is its data pointer.
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = desc
        fa.imm = 0
        dim as MirValue pa0 = Emit( c, fa )
        if pa0.kind = cast( ubyte, MV_NONE ) then return none_
        base_ = LowerExprLoad( c, pa0, MT_PTR )
        if base_.kind = cast( ubyte, MV_NONE ) then return none_
    elseif esz > 0 then
        base_ = LowerAddr( c, sp->target )
        if base_.kind = cast( ubyte, MV_NONE ) then return none_
    else
        if c.types->Kind( pt ) <> Tko.TK_POINTER then return none_
        dim as Tko.TypeId el = c.types->Inner( pt )
        if el = Tko.TYPE_NONE then return none_
        esz = c.types->Layout( el ).size
        dim as long ui = c.udts->Find( el )
        if ui >= 0 then esz = c.udts->udts[ui].size
        '' A 'zstring ptr' POINTS AT CHARACTERS. The pointee is the unsized builtin,
        '' which has no layout size of its own, so the stride came out 0.
        if esz <= 0 then esz = CharElemSize_( c, el )
        if esz <= 0 then return none_

        '' The POINTER'S VALUE is the base -- not its address, which is where the
        '' pointer variable lives.
        base_ = LowerExpr( c, sp->target )
        if base_.kind = cast( ubyte, MV_NONE ) then return none_
    end if

    dim as MirType offTy = MT_I64
    if c.types->target.pointerBits = 32 then offTy = MT_I32

    dim as Tko.NodeId ix = cast( Tko.NodeId, c.ast->children[sp->first] )
    dim as MirValue iv = LowerExpr( c, ix )
    if iv.kind = cast( ubyte, MV_NONE ) then return none_
    iv = Coerce( c, iv, offTy, IsUnsignedType( c, c.info->TypeOf_( ix ) ) )

    dim as MirValue term = iv
    if esz <> 1 then
        dim as MirInst mul
        mul.op = cast( ushort, M_MUL )
        mul.ty = cast( ubyte, offTy )
        mul.a = iv
        mul.b = ConstInt( c, esz, offTy )
        term = Emit( c, mul )
        if term.kind = cast( ubyte, MV_NONE ) then return none_
    end if

    dim as MirInst pa
    pa.op = cast( ushort, M_PTR_ADD )
    pa.ty = cast( ubyte, MT_PTR )
    pa.a = base_
    pa.b = term
    return Emit( c, pa )
end function

'' Whether an N_CALL is really a subscript: FreeBASIC spells indexing and calling the
'' same way, so the callee's TYPE is what tells them apart.
function IsArrayIndex( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    '' N_CALL is a LIST node -- callee in 'target', arguments in the child pool -- not a
    '' statement payload. Reading it as one is the payload-pool mistake this codebase has
    '' now made four times; the rule is to check how a node is CONSTRUCTED, not what its
    '' name suggests.
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    dim as Tko.TypeId t = c.info->TypeOf_( cp->target )
    if t = Tko.TYPE_NONE then return false
    return (c.types->Kind( t ) = Tko.TK_ARRAY)
end function

'' The ADDRESS of one element.
function LowerArrayIndex( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
    dim as MirValue none_
    dim as Tko.ListPayload ptr sp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as Tko.TypeId at = c.info->TypeOf_( sp->target )

    '' A DYNAMIC array has no compile-time strides: its base and its per-dimension
    '' element counts live in the descriptor and are read from it.
    if c.types->IsDynArray( at ) then return LowerDynArrayIndex( c, id, sp, at )

    dim as FB.Array( of longint ) strides
    dim as longint bias
    if ArrayStrides( c, at, strides, bias ) = false then return none_
    '' A subscript count that does not match the rank is an error the checker should
    '' report; lowering something with the wrong number of indices would compute an
    '' address from whichever dimensions happened to line up.
    if sp->count <> strides.Count then return none_

    dim as MirValue base_ = LowerAddr( c, sp->target )
    if base_.kind = cast( ubyte, MV_NONE ) then return none_

    '' Offsets are computed at pointer width, so a 32-bit index does not truncate the
    '' product on a large array.
    dim as MirType offTy = MT_I64
    if c.types->target.pointerBits = 32 then offTy = MT_I32

    dim as MirValue acc
    for k as long = 0 to sp->count - 1
        dim as Tko.NodeId ix = cast( Tko.NodeId, c.ast->children[sp->first + k] )
        dim as MirValue iv = LowerExpr( c, ix )
        if iv.kind = cast( ubyte, MV_NONE ) then return none_
        iv = Coerce( c, iv, offTy )

        '' A stride of 1 needs no multiply, which is most of the single-dimension cases.
        dim as MirValue term = iv
        if strides[k] <> 1 then
            dim as MirInst mul
            mul.op = cast( ushort, M_MUL )
            mul.ty = cast( ubyte, offTy )
            mul.a = iv
            mul.b = ConstInt( c, strides[k], offTy )
            term = Emit( c, mul )
        end if

        if acc.kind = cast( ubyte, MV_NONE ) then
            acc = term
        else
            dim as MirInst add_
            add_.op = cast( ushort, M_ADD )
            add_.ty = cast( ubyte, offTy )
            add_.a = acc
            add_.b = term
            acc = Emit( c, add_ )
        end if
    next
    if acc.kind = cast( ubyte, MV_NONE ) then return none_

    '' The lbound bias is one constant for the whole subscript, subtracted once.
    if bias <> 0 then
        dim as MirInst sub_
        sub_.op = cast( ushort, M_SUB )
        sub_.ty = cast( ubyte, offTy )
        sub_.a = acc
        sub_.b = ConstInt( c, bias, offTy )
        acc = Emit( c, sub_ )
    end if

    dim as MirInst pa
    pa.op = cast( ushort, M_PTR_ADD )
    pa.ty = cast( ubyte, MT_PTR )
    pa.a = base_
    pa.b = acc
    return Emit( c, pa )
end function

'' Per-dimension byte strides, and the constant lbound bias.
''
'' Row-major: the last dimension has stride elemSize, and each earlier one is scaled by
'' the element COUNTS of every dimension after it. Returns false when the bounds were not
'' constant, in which case nothing may be folded and the subscript is not lowered.
private function ArrayStrides _
    ( byref c as Ctx, byval t as Tko.TypeId, byref strides as FB.Array( of longint ), _
      byref bias as longint ) as boolean

    bias = 0
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_ARRAY then return false

    dim as Tko.TypeId elem = c.types->Inner( t )
    dim as long esz
    dim as long ui = c.udts->Find( elem )
    if ui >= 0 then
        esz = c.udts->udts[ui].size
    else
        esz = c.types->Layout( elem ).size
    end if
    if esz <= 0 then return false

    '' Rank comes from the retained bounds rather than from 'dims', so a type whose
    '' bounds were dropped cannot silently produce a plausible stride list.
    dim as long rank = 0
    do
        dim as boolean known
        c.types->ArrayBound( t, rank, false, known )
        if known = false then exit do
        rank += 1
    loop
    if rank = 0 then return false

    dim as FB.Array( of longint ) los, counts
    for k as long = 0 to rank - 1
        dim as boolean lk, hk
        dim as longint lo = c.types->ArrayBound( t, k, false, lk )
        dim as longint hi = c.types->ArrayBound( t, k, true, hk )
        if (lk = false) orelse (hk = false) then return false
        if hi < lo then return false
        los.Push( lo )
        counts.Push( hi - lo + 1 )
    next

    for k as long = 0 to rank - 1
        strides.Push( 0 )
    next
    dim as longint run = esz
    for k as long = rank - 1 to 0 step -1
        strides[k] = run
        run *= counts[k]
    next
    for k as long = 0 to rank - 1
        bias += los[k] * strides[k]
    next
    return true
end function

'' A BRACE INITIALISER over a fixed-size array: 'dim a(0 to 2) as integer = { 1, 2, 3 }'.
'' Returns false when this is not one, so the caller falls back to an ordinary store.
''
'' fbc emits the element stores directly -- '*A = 1', '*(A+8) = 2', '*(A+16) = 3' --
'' and that is all this does. It produced NOTHING before, and the DIM path skipped its
'' store without counting it, so the array was allocated and left holding whatever the
'' stack did.
''
'' A brace list SHORTER than the array leaves the rest alone, which is what fbc's own
'' output does; a longer one stops at the array's length rather than writing past it.
function LowerArrayInit _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId ) as boolean

    if init = Tko.NODE_NONE then return false
    if c.ast->Kind( init ) <> Tko.N_INITIALIZER then return false
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_ARRAY then return false

    dim as Tko.TypeId el = c.types->Inner( t )
    if el = Tko.TYPE_NONE then return false
    dim as MirType emt = LowerType( el, *c.types )
    if (emt = MT_VOID) orelse (emt = MT_AGG) then return false
    dim as long esz = c.types->Layout( el ).size
    if esz <= 0 then return false

    dim as long total = c.types->ElemCount( t )
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]

    dim as MirValue base_
    base_.kind = cast( ubyte, MV_LOCAL )
    base_.ty = cast( ubyte, MT_PTR )
    base_.id = slot

    for i as long = 0 to lp->count - 1
        if (total > 0) andalso (i >= total) then exit for
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        dim as MirValue ev = LowerExpr( c, e )
        if ev.kind = cast( ubyte, MV_NONE ) then return false

        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = i * esz
        dim as MirValue ea = Emit( c, fa )
        if ea.kind = cast( ubyte, MV_NONE ) then return false

        dim as MirInst st
        st.op = cast( ushort, M_STORE )
        st.ty = cast( ubyte, MT_VOID )
        st.a = ea
        st.b = Coerce( c, ev, emt, IsUnsignedType( c, c.info->TypeOf_( e ) ) )
        Emit( c, st )
    next
    return true
end function


'' THE ADDRESS OF A USER OPERATOR'S UDT RESULT, or false when the node is not one.
private function UserOpTempAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId op = c.info->RefOf( id )
    if op = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr os = c.syms->SymbolAt( op )
    if os = 0 then return false
    if os->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.TypeId rt = os->type_
    if rt = Tko.TYPE_NONE then return false
    if c.types->Kind( c.types->Unqualify( rt ) ) <> Tko.TK_UDT then return false
    '' A BYREF-returning operator hands back a reference, which the arrow and index
    '' paths below already know how to read; this one is about a VALUE result.
    dim as Tko.NodeId pn = cast( Tko.NodeId, os->payload )
    if pn = Tko.NODE_NONE then return false
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then return false

    dim as MirValue uv
    dim as boolean got = false
    if c.ast->Kind( id ) = Tko.N_BINARY then
        dim as Tko.BinaryPayload ptr ubp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        got = LowerUserBinaryOp_( c, id, ubp, MT_PTR, uv )
    else
        dim as Tko.UnaryPayload ptr uup = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        got = LowerUserUnaryOp_( c, id, uup, MT_PTR, uv )
    end if
    if got = false then return false
    if uv.kind = cast( ubyte, MV_NONE ) then return false

    '' An SRET result IS the temporary's address already.
    if UsesSretReturn( c, rt ) then
        outv = uv
        return true
    end if

    dim as long tslot = NewTempLocal( c, MT_AGG, SizeOfType( c, rt ) )
    if tslot < 0 then return false
    dim as MirValue ta
    ta.kind = cast( ubyte, MV_LOCAL )
    ta.ty = cast( ubyte, MT_PTR )
    ta.id = tslot
    StoreThrough( c, ta, uv )
    outv = ta
    return true
end function

end namespace

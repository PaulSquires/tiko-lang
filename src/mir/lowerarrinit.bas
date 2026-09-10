'' lowerarrinit.bas -- BRACE INITIALISERS over arrays: the fixed-size, string,
'' wide-string and UDT-element forms. Split out of lowerarr.bas on 2026-09-10 for the
'' 1500-line cap; nothing about the code changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir
declare function ArrayStrides _
    ( byref c as Ctx, byval t as Tko.TypeId, byref strides as FB.Array( of longint ), _
      byref bias as longint ) as boolean

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
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

declare function LowerFixStrArrayInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval n as longint, byval isU as boolean, _
      byval selfv as MirValue ptr = 0 ) as boolean

declare sub FlattenInitLeaves_ _
    ( byref c as Ctx, byval init as Tko.NodeId, _
      byref outv as FB.Array( of ulong ) )


declare function LowerStrArrayInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean

'' THE LEAF EXPRESSIONS OF A NESTED BRACE INITIALISER, in row-major order: a nested
'' N_INITIALIZER is read through rather than treated as a value, which is what makes
'' '{ {1,2,3}, {4,5,6} }' six integers laid out end to end.
sub FlattenInitLeaves_ _
    ( byref c as Ctx, byval init as Tko.NodeId, _
      byref outv as FB.Array( of ulong ) )

    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( e ) = Tko.N_INITIALIZER then
            FlattenInitLeaves_( c, e, outv )
        else
            outv.Push( cast( ulong, e ) )
        end if
    next
end sub

'' The destination is a SLOT or, for storage with no slot, an ADDRESS -- selfv. A
'' STATIC local and a UDT FIELD are both storage without a frame slot.
function LowerArrayInit _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean

    if init = Tko.NODE_NONE then return false
    if c.ast->Kind( init ) <> Tko.N_INITIALIZER then return false
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_ARRAY then return false

    dim as Tko.TypeId el = c.types->Inner( t )
    if el = Tko.TYPE_NONE then return false
    '' A VAR-LENGTH STRING ELEMENT IS NOT A STORE. Its 24 bytes are a descriptor,
    '' so 'dim as string s(0 to 1) = { "a", "b" }' is one fb_StrInit per element,
    '' measured. It lowers as an aggregate, which the size test below rejected --
    '' the whole initialiser was dropped and the array read back empty.
    if IsStringType( c, el ) then
        '' NARROW ONLY. fb_StrInit over an FBUSTRING would write narrow bytes into
        '' a UTF-16 descriptor; the UTF-16 form declines rather than doing that.
        if IsUStringType( c, el ) then return false
        return LowerStrArrayInit_( c, slot, t, init, selfv )
    end if
    '' A FIXED-LENGTH STRING ELEMENT -- 'dim as zstring * 32 z(0 to 1) = { "abcdef",
    '' "ghijkl" }' -- is an ARRAY OF ARRAYS, since 'zstring * N' is itself modelled as
    '' an array of the char builtin. It lowers as an aggregate like every other array,
    '' so it was rejected too. Measured, the destination length is the ELEMENT'S OWN
    '' character count and not -1:
    ''
    ''   fb_StrAssign( (void*)Z$0, 32ll, (void*)"abcdef", 7ll, 0 );
    ''   fb_StrAssign( (void*)((int64)(char*)Z$0 + 32ll), 32ll, (void*)"ghijkl", 7ll, 0 );
    ''
    '' -- which is exactly what the SCALAR declaration of one already emits, so each
    '' element goes through the same routine with its own address as the destination.
    dim as longint fen
    dim as long fek = StrSwapKind_( c, el, fen )
    '' KIND 2 IS 'wstring * N' and belongs here with the other three. It was omitted, so
    '' a wide fixed-string array fell through to the aggregate test below, was not a UDT,
    '' and declined -- while the narrow twin one line away lowered.
    if (fek = 1) orelse (fek = 2) orelse (fek = 3) orelse (fek = 4) then
        return LowerFixStrArrayInit_( c, slot, t, init, fen, (fek = 4), selfv )
    end if

    '' A UDT ELEMENT lowers as an aggregate, which the test below rejected outright:
    '' 'dim as Decimal d(0 to 4) = { D( "-1000" ), ... }' dropped its whole
    '' initialiser and every element read back as whatever the stack held.
    dim as MirType emt = LowerType( el, *c.types )
    if emt = MT_AGG then
        if c.types->Kind( c.types->Unqualify( el ) ) <> Tko.TK_UDT then return false
        return LowerUdtArrayInit_( c, slot, t, init, selfv )
    end if
    if emt = MT_VOID then return false
    dim as long esz = c.types->Layout( el ).size
    if esz <= 0 then return false

    dim as long total = c.types->ElemCount( t )

    '' A MULTI-DIMENSIONAL INITIALISER IS WRITTEN IN ROWS -- 'dim c(0 to 1, 0 to 2) as
    '' integer = { {1,2,3}, {4,5,6} }' -- and the storage is one flat run in row-major
    '' order, so the rows are read through and their leaves laid out end to end. Each
    '' row is itself an N_INITIALIZER, which LowerExpr has nothing to make of: the
    '' whole declaration declined and the array was left uninitialised.
    ''
    '' Only where the array HAS more than one dimension. Over a one-dimensional array
    '' a nested brace list means something else -- the fields of an element -- and
    '' flattening it would spread one element's fields across several elements.
    dim as FB.Array( of ulong ) leaves
    if c.types->types[cast( long, t )].dims > 1 then
        FlattenInitLeaves_( c, init, leaves )
    else
        dim as Tko.ListPayload ptr lp0 = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
        for i as long = 0 to lp0->count - 1
            leaves.Push( c.ast->children[lp0->first + i] )
        next
    end if

    dim as MirValue base_
    if selfv <> 0 then
        base_ = *selfv
    else
        base_.kind = cast( ubyte, MV_LOCAL )
        base_.ty = cast( ubyte, MT_PTR )
        base_.id = slot
    end if

    for i as long = 0 to leaves.Count - 1
        if (total > 0) andalso (i >= total) then exit for
        dim as Tko.NodeId e = cast( Tko.NodeId, leaves[i] )
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
        st.b = CoerceTy( c, ev, emt, c.info->TypeOf_( e ))
        Emit( c, st )
    next
    return true
end function


'' ONE fb_StrAssign PER ELEMENT, over an array whose elements are FIXED-LENGTH
'' strings. Each element's destination length is its own character count, which is the
'' same argument the scalar declaration of one passes -- so the work is the scalar
'' routine, called once per element with that element's address.
private function LowerFixStrArrayInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval n as longint, byval isU as boolean, _
      byval selfv as MirValue ptr = 0 ) as boolean

    dim as Tko.TypeId el = c.types->Inner( t )
    dim as long esz = SizeOfType( c, el )
    if esz <= 0 then return false
    dim as long total = c.types->ElemCount( t )
    '' A MULTI-DIMENSIONAL INITIALISER IS WRITTEN IN ROWS and the storage is one flat
    '' run in row-major order -- the same rule the scalar path follows. This walked only
    '' the TOP-LEVEL children, so every row arrived as a nested N_INITIALIZER that the
    '' element assignment had nothing to make of, and the whole declaration declined.
    dim as FB.Array( of ulong ) leaves
    if c.types->types[cast( long, t )].dims > 1 then
        FlattenInitLeaves_( c, init, leaves )
    else
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
        for i as long = 0 to lp->count - 1
            leaves.Push( c.ast->children[lp->first + i] )
        next
    end if

    dim as MirValue base_
    if selfv <> 0 then
        base_ = *selfv
    else
        base_.kind = cast( ubyte, MV_LOCAL )
        base_.ty = cast( ubyte, MT_PTR )
        base_.id = slot
    end if

    dim as long written = 0
    for i as long = 0 to cast( long, leaves.Count ) - 1
        if (total > 0) andalso (i >= total) then exit for
        dim as Tko.NodeId e = cast( Tko.NodeId, leaves[i] )
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = i * esz
        dim as MirValue ea = Emit( c, fa )
        if ea.kind = cast( ubyte, MV_NONE ) then return false
        if LowerZstrAssignTo( c, ea, n, e, true, isU ) = false then return false
        written = i + 1
    next

    '' AND THE ELEMENTS THE INITIALISER DID NOT NAME ARE ZEROED. A fixed-length string
    '' is raw storage, not a descriptor, so an unwritten one holds whatever the frame
    '' held -- and this simply stopped at the last supplied leaf. Measured: fbc emits an
    '' explicit memset over the rest, per row and for the whole tail.
    if (total > 0) andalso (written < total) then
        dim as MirInst ta
        ta.op = cast( ushort, M_FIELD_ADDR )
        ta.ty = cast( ubyte, MT_PTR )
        ta.a = base_
        ta.imm = written * esz
        dim as MirValue taddr = Emit( c, ta )
        if taddr.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) za
        za.Push( cast( ulong, taddr.kind ) ) : za.Push( cast( ulong, taddr.id ) )
        za.Push( cast( ulong, MV_CONST_INT ) ) : za.Push( 0 )
        za.Push( cast( ulong, MV_CONST_INT ) )
        za.Push( cast( ulong, (total - written) * esz ) )
        EmitRtl( c, RTL_MEMSET, za )
    end if
    return true
end function

'' ONE fb_StrInit PER ELEMENT, over an array whose descriptors have already been
'' zeroed at the declaration. An element the initialiser does not name keeps that
'' zeroed descriptor, which is the empty string -- fbc leaves it alone too.
private function LowerStrArrayInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean

    dim as Tko.TypeId el = c.types->Inner( t )
    dim as long esz = c.types->Layout( el ).size
    if esz <= 0 then return false
    dim as long total = c.types->ElemCount( t )
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]

    dim as MirValue base_
    if selfv <> 0 then
        base_ = *selfv
    else
        base_.kind = cast( ubyte, MV_LOCAL )
        base_.ty = cast( ubyte, MT_PTR )
        base_.id = slot
    end if

    for i as long = 0 to lp->count - 1
        if (total > 0) andalso (i >= total) then exit for
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = i * esz
        dim as MirValue ea = Emit( c, fa )
        if ea.kind = cast( ubyte, MV_NONE ) then return false
        '' THE ANSWER IS READ. An element that will not build is the whole
        '' initialiser declining, not a silently empty slot in the middle of it.
        if StrInitFrom_( c, ea, e ) = false then return false
    next
    return true
end function

'' ONE ELEMENT OF A BRACE INITIALISER OVER AN ARRAY OF UDT.
''
'' Measured, and the two rows differ by more than emphasis:
''
''   POD                *(struct $1U*)A$0 = vr$2;
''   with structors     _ZN1CC1ERKS_( (struct $1C*)A$0, vr$3 );
''
'' -- a COPY CONSTRUCTOR for the second, and no default construction before it: fbc
'' constructs each element once, from its initialiser, and never twice. A type holding
'' a string is the case that notices, because an aggregate store there would leave two
'' objects owning one buffer and both would release it.
function LowerUdtElemInit_ _
    ( byref c as Ctx, byref dst as MirValue, byval et as Tko.TypeId, _
      byval e as Tko.NodeId ) as boolean

    dim as Tko.TypeId ivt = c.info->TypeOf_( e )
    if (ivt <> Tko.TYPE_NONE) andalso (ivt = et) then
        dim as Tko.SymbolId ucp = CopyCtorOf_( c, et )
        if (ucp <> Tko.SYMBOL_NONE) orelse NeedsLetBody_( c, et ) then
            dim as MirValue src = LowerAddr( c, e )
            if src.kind = cast( ubyte, MV_NONE ) then return false
            if ucp <> Tko.SYMBOL_NONE then
                dim as FB.Array( of ulong ) cargs
                cargs.Push( cast( ulong, src.kind ) )
                cargs.Push( cast( ulong, src.id ) )
                EmitStructorCall( c, ucp, -1, @dst, @cargs )
            else
                CallImplicitCopy_( c, et, dst, src )
            end if
            return true
        end if
    end if

    '' A CONSTRUCTOR CALL SPELT OUT -- '{ C( 1 ), C( 2 ) }' -- constructs INTO the
    '' element, exactly as it does into a variable's slot.
    if LowerCtorInit( c, -1, et, e, @dst ) then return true

    '' ...AND ONE THAT IS NOT SPELT OUT IS STILL A CONSTRUCTOR CALL. 'dim tb(0 to 1) as
    '' foo = { 7, 8 }' over a 'constructor foo( byval v as integer )' fell past both
    '' branches above to the POD copy and STORED 7 AND 8 RAW into the elements --
    '' no ctor, no decline, and it verified. Measured, fbc:
    ''
    ''     _ZN3FOOC1Eu7INTEGER( (struct $3FOO*)TB$0, 7ll );
    ''     _ZN3FOOC1Eu7INTEGER( (struct $3FOO*)((int64)TB$0 + 8ll), 8ll );
    ''
    '' and run, with a constructor that multiplies by ten, fbc prints ' 70  80' where
    '' tiko-lang's elements held 7 and 8. The scalar 'dim as foo a = 7' had taken the
    '' converting constructor since it was written; only the ELEMENT position had not.
    if LowerConvCtorInit_( c, -1, et, e, @dst ) then return true

    '' A BARE PARENTHESISED FIELD LIST -- '{ ( 7, 8, 9 ) }' -- IS THE ELEMENT'S OWN
    '' FIELDS, and it has to be built with the ELEMENT'S type. Left to LowerExpr below
    '' it went to the tuple path, which infers a synthetic UDT from the values: over
    ''
    ''     type mt : as byte a, b : as integer c : end type
    ''
    '' -- sixteen bytes, at 0, 1 and 8 -- that built a TWENTY-FOUR byte temporary with
    '' i64 fields at 0, 8 and 16 and stored the whole of it into the element, writing
    '' eight bytes past its end and into the NEXT one. It verified, it declined
    '' nothing, and every field but the first held the wrong value. fbc prints
    '' ' 7  8  9'.
    select case c.ast->Kind( e )
    case Tko.N_TUPLE, Tko.N_PAREN
        if LowerUdtParenInit_( c, -1, et, e, @dst ) then return true
    end select

    '' ...and a POD element is the plain aggregate copy fbc emits for one.
    dim as MirValue ev = LowerExpr( c, e )
    if ev.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, dst, ev )
    return true
end function

'' A BRACE INITIALISER OVER AN ARRAY OF UDT, element by element. An element the list
'' does not name is left as the declaration made it -- default-constructed or zeroed --
'' which is what fbc does with a short list.
'' The destination is a SLOT or, for a STATIC LOCAL, an ADDRESS -- selfv. A static's
'' storage is a GLOBAL and has no slot.
function LowerUdtArrayInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean

    dim as Tko.TypeId el = c.types->Inner( t )
    '' THE ELEMENT'S SIZE, through SizeOfType rather than Layout( ).size: a UDT's
    '' layout record is not what carries its size here, and reading it gave 0 --
    '' which this rejected as 'no size', declining every UDT array initialiser.
    dim as long esz = SizeOfType( c, el )
    if esz <= 0 then return false
    dim as long total = c.types->ElemCount( t )
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]

    dim as MirValue base_
    if selfv <> 0 then
        base_ = *selfv
    else
        base_.kind = cast( ubyte, MV_LOCAL )
        base_.ty = cast( ubyte, MT_PTR )
        base_.id = slot
    end if

    for i as long = 0 to lp->count - 1
        if (total > 0) andalso (i >= total) then exit for
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = i * esz
        dim as MirValue ea = Emit( c, fa )
        if ea.kind = cast( ubyte, MV_NONE ) then return false
        '' THE ANSWER IS READ. An element that will not build declines the whole
        '' initialiser rather than leaving a hole in the middle of it.
    if LowerUdtElemInit_( c, ea, el, e ) = false then return false
    next
    return true
end function

end namespace

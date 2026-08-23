'' lowerudtlit.bas -- the anonymous UDT literal and the field-list initialiser.
''
'' 'type<P>( 5, 6 )', 'type( 5, 6 )' and the bare '( 5, 6 )' are ONE construct with
'' three spellings. Measured: fbc emits the same field stores and the same tail memset
'' for all of them, so they share one lowering here and differ only in where the TYPE
'' comes from -- the written one, the declaration's, or the context's.
''
'' Split out of lowersub.bas at the 1500-line cap. Nothing moved with it changed.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

'' THE LEAF VALUES of an initialiser, in order, with nested lists opened out. fbc
'' accepts a field list written either way -- 'type<Outer>( type<P>( 1, 2 ), 3 )' and
'' 'type<Outer>( 1, 2, 3 )' both give stores at 0, 4 and 8 -- so a nested list is
'' punctuation here, exactly as it is on the field side.
private function FlattenInitValues_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as FB.Array( of ulong ), _
      byval depth as long ) as boolean

    if depth > 8 then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        select case c.ast->Kind( e )
        case Tko.N_TUPLE, Tko.N_INITIALIZER
            '' A nested field list, or the '{ ... }' an ARRAY FIELD takes.
            if FlattenInitValues_( c, e, outv, depth + 1 ) = false then return false
        case else
            outv.Push( cast( ulong, e ) )
        end select
    next
    return true
end function

'' Defined below, and used above it: FreeBASIC needs the forward declaration.
declare function FlattenUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval base_ as long, _
      byref offs as FB.Array( of ulong ), byref tys as FB.Array( of ulong ), _
      byval depth as long ) as boolean

'' 'type<P>( 5, 6 )' AS A VALUE, not as an initialiser -- an argument, a parameter
'' default, anything that is not the right-hand side of a declaration. fbc builds a
'' TEMPORARY and field-initialises it, exactly as it does for a declaration:
''
''     struct $1P TMP$5$0;  *(uint32*)&TMP$5$0 = 5u;  ...  Q( TMP$5$0 );
''
'' Returns the temp's SLOT, or -1. Split from the value and address entry points below
'' because a byref argument needs the address and a byval one needs the load, and
'' building the object twice for the two of them would be wrong as well as wasteful.
function UdtLiteralSlot_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as long

    if c.ast->Kind( id ) <> Tko.N_TUPLE then return -1
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    '' A TARGET IS WHAT MAKES IT A LITERAL. A bare '( a, b )' is the tuple feature and
    '' has no type of its own; only the written form reaches here.
    if lp->target = Tko.NODE_NONE then return -1
    if c.ast->Kind( lp->target ) <> Tko.N_TYPEREF then return -1

    dim as Tko.TypeId lt = c.info->TypeOf_( id )
    if lt = Tko.TYPE_NONE then return -1
    if c.types->Kind( lt ) <> Tko.TK_UDT then return -1

    dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, lt ) )
    if slot < 0 then return -1
    if LowerUdtParenInit_( c, slot, lt, id ) = false then return -1
    return slot
end function

function LowerUdtLiteralValue_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as long slot = UdtLiteralSlot_( c, id )
    if slot < 0 then return false
    dim as MirValue addr
    addr.kind = cast( ubyte, MV_LOCAL )
    addr.ty = cast( ubyte, MT_PTR )
    addr.id = slot
    outv = LowerExprLoad( c, addr, MT_AGG )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function LowerUdtLiteralAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as long slot = UdtLiteralSlot_( c, id )
    if slot < 0 then return false
    outv.kind = cast( ubyte, MV_LOCAL )
    outv.ty = cast( ubyte, MT_PTR )
    outv.id = slot
    return true
end function

function LowerUdtParenInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval init as Tko.NodeId ) as boolean

    if slot < 0 then return false
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    select case c.ast->Kind( init )
    case Tko.N_TUPLE, Tko.N_PAREN
    case else
        return false
    end select

    dim as long ui = c.udts->Find( t )
    if ui < 0 then return false

    '' A SINGLE ELEMENT OF THE TYPE ITSELF IS NOT A FIELD LIST. 'dim as Decimal a =
    '' ( ( x - y ) / z )' has to be written with those outer parentheses -- fbc cannot
    '' parse the operator otherwise, and fb/fintvm.bi says so in a comment beside every
    '' one -- so the parens are punctuation, not an initialiser. Reading them as one
    '' meant storing a whole Decimal into its first FIELD, which is a type error the
    '' void-result rule then declined; before that rule it would have stored something.
    dim as Tko.ListPayload ptr pl0 = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]
    if pl0->count = 1 then
        dim as Tko.NodeId only_ = cast( Tko.NodeId, c.ast->children[pl0->first] )
        dim as Tko.TypeId ot = c.info->TypeOf_( only_ )
        if ot <> Tko.TYPE_NONE then
            if c.types->Unqualify( ot ) = c.types->Unqualify( t ) then return false
        end if
    end if

    '' THE FIELDS, FLATTENED. 'dim as Outer x = ( ( 1, 2 ), 3 )' emits the same three
    '' stores at 0, 4 and 8 that a flat type would: nesting exists in the parser and
    '' nowhere else, so a nested UDT field contributes its OWN leaves here rather than
    '' one aggregate slot.
    dim as FB.Array( of ulong ) fOff
    dim as FB.Array( of ulong ) fTy
    if FlattenUdtFields_( c, t, 0, fOff, fTy, 0 ) = false then return false
    dim as long fCount = fOff.Count
    if fCount <= 0 then return false

    dim as FB.Array( of ulong ) vNode
    if FlattenInitValues_( c, init, vNode, 0 ) = false then return false
    dim as long vCount = vNode.Count
    if vCount <= 0 then return false
    '' MORE VALUES THAN FIELDS is not this construct -- it declines rather than
    '' writing past the last one.
    if vCount > fCount then return false

    dim as MirValue base_
    base_.kind = cast( ubyte, MV_LOCAL )
    base_.ty = cast( ubyte, MT_PTR )
    base_.id = slot

    '' EVERY VALUE LOWERED BEFORE ANYTHING IS STORED. A value that will not lower means
    '' the whole initialiser declines, and emitting the earlier stores first would leave
    '' a half-initialised object behind with a decline beside it.
    '' A LEAF CURSOR, NOT AN INDEX, because ONE VALUE CAN COVER SEVERAL LEAVES.
    '' Measured: 'dim y1 as T3 = ( x1, 31, 301 )' over a T3 that EXTENDS T1 is
    '' '__builtin_memcpy( &Y1, &X1, 4 )' for the base and scalar stores for the rest.
    '' Pairing value i with leaf i instead coerced a whole object into an i32 slot -- a
    '' SIGN-EXTENDED AGGREGATE -- and wrote every field after it one place early.
    dim as FB.Array( of ulong ) vals
    dim as FB.Array( of ulong ) vOff
    dim as long cur = 0
    for i as long = 0 to vCount - 1
        dim as Tko.NodeId e = cast( Tko.NodeId, vNode[i] )
        if cur >= fCount then return false
        dim as MirType fmt = cast( MirType, fTy[cur] )
        dim as MirValue v = LowerExpr( c, e )
        if v.kind = cast( ubyte, MV_NONE ) then return false
        dim as long span = 1
        if v.ty = cast( ubyte, MT_AGG ) then
            '' THE RUN OF LEAVES THIS OBJECT COVERS, measured by its own size. A value
            '' that does not span a whole number of leaves declines rather than being
            '' written across a field boundary.
            dim as Tko.TypeId vt = c.info->TypeOf_( e )
            if vt = Tko.TYPE_NONE then return false
            '' SizeOfType, not TypeContext.Layout: a UDT's size lives in the UDT
            '' store, and Layout answers 0 for one. That zero made every aggregate
            '' value decline here, which looked exactly like the guard working.
            dim as long vsz = SizeOfType( c, vt )
            if vsz <= 0 then return false
            dim as long stop_ = cast( long, fOff[cur] ) + vsz
            span = 0
            while (cur + span < fCount) andalso (cast( long, fOff[cur + span] ) < stop_)
                span += 1
            wend
            if span < 1 then return false
        else
            v = Coerce( c, v, fmt, IsUnsignedType( c, c.info->TypeOf_( e ) ) )
            if v.kind = cast( ubyte, MV_NONE ) then return false
        end if
        vOff.Push( cast( ulong, fOff[cur] ) )
        vals.Push( cast( ulong, v.kind ) )
        vals.Push( cast( ulong, v.id ) )
        vals.Push( cast( ulong, v.ty ) )
        cur += span
    next

    for i as long = 0 to vCount - 1
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = cast( long, vOff[i] )
        dim as MirValue addr = Emit( c, fa )
        if addr.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue v
        v.kind = cast( ubyte, vals[i * 3] )
        v.id = cast( long, vals[i * 3 + 1] )
        v.ty = cast( ubyte, vals[i * 3 + 2] )
        dim as MirInst st
        st.op = cast( ushort, M_STORE )
        st.ty = cast( ubyte, MT_VOID )
        st.a = addr
        st.b = v
        Emit( c, st )
    next

    '' THE TAIL, zeroed AFTER the stores and only as far as it goes -- from the first
    '' field with no value to the end of the object. A UNION gets none: measured, and
    '' the one place the two shapes disagree.
    if cur < fCount then
        if IsUnionType_( c, t ) = false then
            dim as long tailOff = cast( long, fOff[cur] )
            dim as long tailLen = c.udts->udts[ui].size - tailOff
            if tailLen > 0 then
                dim as MirInst ta
                ta.op = cast( ushort, M_FIELD_ADDR )
                ta.ty = cast( ubyte, MT_PTR )
                ta.a = base_
                ta.imm = tailOff
                dim as MirValue taddr = Emit( c, ta )
                if taddr.kind <> cast( ubyte, MV_NONE ) then
                    dim as FB.Array( of ulong ) ma
                    ma.Push( cast( ulong, taddr.kind ) ) : ma.Push( cast( ulong, taddr.id ) )
                    ma.Push( cast( ulong, MV_CONST_INT ) ) : ma.Push( 0 )
                    ma.Push( cast( ulong, MV_CONST_INT ) ) : ma.Push( cast( ulong, tailLen ) )
                    EmitRtl( c, RTL_MEMSET, ma )
                end if
            end if
        end if
    end if
    return true
end function

'' Every LEAF field of a UDT, in declaration order, as (byte offset, MIR type).
''
'' A nested UDT contributes its own leaves rather than one aggregate slot, which is what
'' makes 'dim as Outer x = ( ( 1, 2 ), 3 )' three stores at 0, 4 and 8 -- fbc flattens
'' the initialiser completely and the parens are decoration.
''
'' Returns false rather than a partial list for anything that has no plain store: a
'' BITFIELD, whose address would be the whole packed unit, or a field type that lowers
'' to no MIR type at all.
function FlattenUdtFields_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval base_ as long, _
      byref offs as FB.Array( of ulong ), byref tys as FB.Array( of ulong ), _
      byval depth as long ) as boolean

    if depth > 8 then return false
    dim as long ui = c.udts->Find( t )
    if ui < 0 then return false
    dim as long f0 = c.udts->udts[ui].first
    dim as long n = c.udts->udts[ui].count
    if n <= 0 then return false
    for i as long = 0 to n - 1
        dim as Tko.UdtField ptr fld = @c.udts->fields[f0 + i]
        if fld->bitWidth <> 0 then return false
        dim as MirType fmt = LowerType( fld->type_, *c.types )
        if fmt = MT_AGG then
            '' A FIXED ARRAY FIELD CONTRIBUTES ITS ELEMENTS, one leaf each. Measured:
            '' 'as ubyte d4( 0 to 7 )' initialised from '{ &hC0, 0, ... }' is eight byte
            '' stores at offsets 8..15, not one aggregate store. Refusing it declined
            '' every GUID in fb/comptr.bi, which is how COM declares every IID.
            ''
            '' A DYNAMIC array is a descriptor rather than storage and has no elements
            '' to write here.
            if c.types->Kind( fld->type_ ) = Tko.TK_ARRAY then
                if c.types->IsDynArray( fld->type_ ) then return false
                dim as Tko.TypeId et = c.types->Inner( fld->type_ )
                dim as MirType emt = LowerType( et, *c.types )
                if (emt = MT_VOID) orelse (emt = MT_AGG) then return false
                dim as long esz = c.types->Layout( et ).size
                if esz <= 0 then return false
                dim as long total = c.types->Layout( fld->type_ ).size \ esz
                if total <= 0 then return false
                for k as long = 0 to total - 1
                    offs.Push( cast( ulong, base_ + fld->offset + k * esz ) )
                    tys.Push( cast( ulong, emt ) )
                next
                continue for
            end if
            if c.types->Kind( fld->type_ ) <> Tko.TK_UDT then return false
            if FlattenUdtFields_( c, fld->type_, base_ + fld->offset, offs, tys, _
                                  depth + 1 ) = false then return false
        else
            if fmt = MT_VOID then return false
            offs.Push( cast( ulong, base_ + fld->offset ) )
            tys.Push( cast( ulong, fmt ) )
        end if
    next
    return true
end function

'' Whether a UDT was declared as a UNION. The flag lives on the declaring N_TYPE node,
'' which the type's symbol points at -- there is nothing in the layout that says so,
'' because a union's fields all sit at offset 0 and a one-field struct looks the same.
function IsUnionType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return false
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    dim as Tko.NodeId n = cast( Tko.NodeId, s->payload )
    if n = Tko.NODE_NONE then return false
    if c.ast->Kind( n ) <> Tko.N_TYPE then return false
    return ((c.ast->nodes[cast( long, n )].flags and Tko.NF_IS_UNION) <> 0)
end function

end namespace

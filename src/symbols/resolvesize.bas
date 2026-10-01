'' resolvesize.bas -- the ARRAY SIZE LIMIT.
''
'' Split out of resolve.bas at the 1500-line lint cap and included from it, inside its
'' own namespace. Nothing in it changed in the move.

'' AN ARRAY MUST FIT IN A SIGNED 32-BIT BYTE COUNT -- fbc error 50, 'Array too big'.
'' The limit is on TOTAL BYTES, not on the element count, and it is 2147483647
'' EXACTLY. Measured on three element widths, each side of the boundary:
''
''     byte  t(0 to &h7FFFFFFE)   2147483647 bytes   accepted
''     byte  t(0 to &h7FFFFFFF)   2147483648         error 50
''     long  t(0 to 536870910)    2147483644         accepted
''     long  t(0 to 536870911)    2147483648         error 50
''     short t(0 to 1073741822)   2147483646         accepted
''     short t(0 to 1073741823)   2147483648         error 50
''
'' -- and the dimensions MULTIPLY: 'byte t(0 to 5, 0 to 400000000)' is error 50 too.
''
'' COMPUTED IN 64 BITS, which is the whole point. TypeContext.Layout returns a LONG
'' and multiplies the element size by the count, so the size of an array this big
'' has already overflowed by the time anyone could look at it -- the check cannot be
'' written in terms of the answer it is trying to reject.
''
'' An element whose own size is not known yet measures 0 and passes. Resolve runs
'' three times and UDT layouts are computed between the second and the third, so a
'' UDT-element array is only judged on the pass that can judge it -- and 0 is the
'' safe answer, because missing a rejection leaves tiko-lang where it already was.
private sub ArrayTooBig_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval at as Tko.NodeId, _
      byval nm as Tko.InternId )

    if t = Tko.TYPE_NONE then return
    if c.types->Kind( t ) <> Tko.TK_ARRAY then return
    if c.types->IsDynArray( t ) then return
    dim as Tko.TypeId et = c.types->Inner( t )
    if et = Tko.TYPE_NONE then return
    dim as longint esz = cast( longint, c.types->Layout( et ).size )
    if esz <= 0 then return
    '' THE COUNT IS RECOMPUTED FROM THE BOUNDS, in 64 bits, and not read off the
    '' type. TypeRecord.elems is a LONG, so 'byte t(0 to &h7FFFFFFF)' -- 2147483648
    '' elements -- has already overflowed to a negative there, and the two shapes
    '' furthest over the limit were the two this check could not see.
    dim as long dims = c.types->types[cast( long, t )].dims
    if dims < 1 then return
    dim as long bfirst = c.types->types[cast( long, t )].first
    if c.types->types[cast( long, t )].count < dims * 2 then return
    dim as longint n = 1
    for d as long = 0 to dims - 1
        dim as longint lo = c.types->boundPool[bfirst + d * 2]
        dim as longint hi = c.types->boundPool[bfirst + d * 2 + 1]
        '' A LOWER BOUND ABOVE THE UPPER is fbc's error 182, "Invalid array subscript":
        '' 'dim array(1 to 0)', '(0 to -1)', '(-1)', a field or an extern the same, and
        '' '(&h8000000000000000 to &h8000000000000000)' -- an upper bound of LONGINT's minimum
        '' is refused however low the lower one (fbc-modern 1.20, 2026-09-29;
        '' dim/array-invalid-subscript-1..2). A REDIM's bounds are the runtime's.
        if (hi < lo) orelse (hi = &h8000000000000000ll) then
            c.diags->Report( Tko.TKO0887, Tko.PointRange( c.ast->Loc( at ) ), c.names->Spelling( nm ) )
            return
        end if
        n *= (hi - lo + 1)
        '' A product that has run away is already over the limit; stop before it
        '' can wrap even in 64 bits.
        if n > 2147483647 then exit for
    next
    if n <= 0 then return
    if (esz * n) <= 2147483647 then return
    c.diags->Report( Tko.TKO0613, Tko.PointRange( c.ast->Loc( at ) ), _
                     c.names->Spelling( nm ) )
end sub

'' TOO MANY EXPRESSIONS IN AN AGGREGATE INITIALIZER -- fbc error 67.
''
'' Too FEW is legal and fills the rest with zero; only too many is refused. Measured:
''
''     type of 2 fields   ( 1, 2 )       accepted
''                        ( 1, 2, 3 )    error 67
''                        ( 1 )          accepted
''     union of 2         ( 1 )          accepted
''                        ( 1, 2 )       error 67
''
'' A UNION IS ONE SLOT, however many members it has -- they overlap, so there is only
'' one thing to initialise. And in a TYPE an ANONYMOUS aggregate is one slot too:
'' 'type T { a; union { b; c } }' takes ( 1, 2 ) and refuses ( 1, 2, 3 ). 'extends'
'' costs a slot as well -- 'type D extends B { b }' takes two -- and that one needs no
'' code, because fbc spells the base as a FIELD NAMED 'base' and the walk below counts
'' it like any other.
''
'' A METHOD AND A STATIC FIELD ARE NOT SLOTS. Both measured: a type with two instance
'' fields and a method still refuses three expressions.
''
'' TOP LEVEL ONLY. A nested over-count -- '( 1, ( 2, 3, 4 ) )' -- is fbc error 7, a
'' SYNTAX error raised while reading the inner parenthesis, and it belongs with the
'' array '{ }' forms (error 65) rather than here. The corpus family this closes is
'' named 'union-init-bad-TOPLEVEL' for the same reason.
'' TOO MANY EXPRESSIONS IN AN AGGREGATE INITIALIZER -- fbc error 67.
''
'' Too FEW is legal and fills the rest with zero; only too many is refused.
''
'' WHAT IS COUNTED IS SCALAR LEAVES, and everything flattens into them. Every one of
'' these was measured, and the first version of this check got four of them wrong:
''
''     type T { a; b }                    ( 1, 2 )        ok   ( 1, 2, 3 )   error 67
''     union U { a; b }                   ( 1 )           ok   ( 1, 2 )      error 67
''     type T { a; union { b; c } }       ( 1, 2 )        ok   ( 1, 2, 3 )   error 67
''     union U { type { a; b } }          ( 1, 2 )        ok   ( 1, 2, 3 )   error 67
''     type Inner { p; q }
''     type T { a; i as Inner }           ( 1, 2, 3 )     ok   -- IT FLATTENS
''                                        ( 1, ( 2, 3 ) ) ok   -- and it still nests
''     type P1 { a; b }
''     type P2 extends P1 { c; d }        ( 1, 2, 3, 4 )  ok   ( 1 ... 5 )   error 67
''
'' So:  a TYPE is the SUM over its top-level members;
''      a UNION is its FIRST member alone -- they overlap, there is one thing to fill;
''      a UDT member contributes ITS OWN count, not one;
''      'extends' needs no code at all, because fbc spells the base as a FIELD NAMED
''      'base' and it flattens like any other UDT member.
''
'' AND THE TYPE COUNTED IS THE LITERAL'S, NOT THE VARIABLE'S. 'dim as parent p =
'' type<child>( 4, 5 )' is legal over a one-field parent: the expressions fill a CHILD
'' and the result is then upcast. The type ref rides in the list's TARGET, which the
'' bare parenthesised form leaves empty.
''
'' A METHOD AND A STATIC FIELD ARE NOT SLOTS. Both measured.
''
'' DECLINED RATHER THAN GUESSED: an ARRAY or a STRING member. Neither is reachable
'' through the flat form at all -- over a type holding 'a(0 to 3) as integer' fbc
'' answers error 64, "Expected '{'", and over one holding a string it answers error 7 --
'' so counting leaves through them would be inventing a number for a shape that has no
'' legal flat spelling. The whole declaration goes unchecked instead.
''
'' TOP LEVEL ONLY. A nested over-count -- '( 1, ( 2, 3, 4 ) )' -- is fbc error 7, raised
'' while READING the inner parenthesis, and it belongs with the array brace forms.

'' The UDT's own symbol, from its type. Check has this too, over Check's Ctx -- the two
'' cannot share one copy, so this is the second.
private function UdtSymOf_ _
    ( byref c as Ctx, byval u as Tko.TypeId ) as Tko.SymbolId

    dim as Tko.InternId tn = c.types->NameOf( u )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( u ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    return ts
end function

declare function SlotsOfType_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval depth as long ) as long

'' One anonymous-aggregate GROUP, counted the way udtlayout.bas PLACES one: the fields
'' are a flat list carrying 'anonDepth', a deeper depth opens a nested group, and
'' SYMF_UNION on its first field says whether that group overlaps. Mirrored rather than
'' shared, because the layout pass returns bytes and this returns slots -- but the
'' TRAVERSAL has to be identical, or 'union { type { a; b } }' counts as one.
private function SlotsGroup_ _
    ( byref c as Ctx, byref flds as FB.Array( of ulong ), byref idx as long, _
      byval depth as long, byval isUnion as boolean, byval rdepth as long ) as long

    dim as long total = 0
    '' -2 means "no member seen yet". A UNION answers with its FIRST member's count,
    '' but the loop still has to CONSUME the rest of the group: returning early left
    '' 'idx' inside it, and the caller then read the same members again as a second
    '' group -- which is how 'type T { a; union { b; c } }' counted three.
    dim as long firstN = -2
    dim as boolean first = true

    while idx < flds.Count
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cast( Tko.SymbolId, flds[idx] ) )
        if f = 0 then exit while
        dim as long fd = cast( long, f->anonDepth )
        if fd < depth then exit while

        '' Does this field START A NEW GROUP at or above this depth? The same test
        '' PlaceGroup makes, and for the same reason: a field opens the levels
        '' (anonDepth - anonOpen + 1) .. anonDepth.
        if (first = false) andalso (depth > 0) andalso (f->anonOpen > 0) then
            if (fd - cast( long, f->anonOpen ) + 1) <= depth then exit while
        end if

        dim as long n = 0
        if fd > depth then
            '' THE KIND OF THE LEVEL BEING OPENED, read off the mask exactly as
            '' udtlayout.bas PlaceGroup reads it. A field's SYMF_UNION describes only
            '' its INNERMOST aggregate, and an anonymous TYPE inside an anonymous UNION
            '' is sequential at its own level and overlapping at its parent's.
            dim as boolean nestedIsUnion = false
            if depth < 16 then
                nestedIsUnion = ((f->anonUnionMask and _
                                  cast( ushort, 1 shl depth )) <> 0)
            end if
            n = SlotsGroup_( c, flds, idx, depth + 1, nestedIsUnion, rdepth )
        else
            n = SlotsOfType_( c, f->type_, rdepth + 1 )
            idx += 1
        end if

        if n < 0 then return -1
        if firstN = -2 then firstN = n
        total += n
        first = false
    wend
    if isUnion then
        if firstN = -2 then return -1
        return firstN
    end if
    return total
end function

private function SlotsOfUdt_ _
    ( byref c as Ctx, byval u as Tko.TypeId, byval rdepth as long ) as long

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( UdtSymOf_( c, u ) )
    if s = 0 then return -1
    if s->inner = Tko.SCOPE_NONE then return -1
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return -1

    dim as FB.Array( of ulong ) flds
    dim as Tko.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Tko.SYM_FIELD ) then
            '' A BITFIELD is declined for layout everywhere else in this compiler; it
            '' is declined here too rather than counted as an ordinary member.
            if (f->flags and Tko.SYMF_BITFIELD) <> 0 then return -1
            dim as boolean isStatic = ((f->flags and _
                (Tko.SYMF_STATIC or Tko.SYMF_SHARED)) <> 0)
            if isStatic = false then flds.Push( cast( ulong, cur ) )
        end if
        cur = f->nextInScope
    wend
    if flds.Count = 0 then return -1

    dim as long idx = 0
    dim as boolean isUnion = ((s->flags and Tko.SYMF_UNION_KIND) <> 0)
    return SlotsGroup_( c, flds, idx, 0, isUnion, rdepth )
end function

function SlotsOfType_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval depth as long ) as long

    if t = Tko.TYPE_NONE then return -1
    if depth > 16 then return -1
    dim as Tko.TypeId u = c.types->Unqualify( t )
    select case c.types->Kind( u )
    case Tko.TK_UDT
        return SlotsOfUdt_( c, u, depth )
    case Tko.TK_POINTER, Tko.TK_ENUM
        return 1
    case Tko.TK_BUILTIN
        '' A STRING member has no flat spelling; see the header. A FIXED-LENGTH one
        '' arrives as TK_ARRAY and is declined with the real arrays, below.
        select case c.types->BuiltinOf( u )
        case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_USTRING
            return -1
        end select
        return 1
    end select
    return -1
end function

private sub InitTooMany_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval init as Tko.NodeId, _
      byval nm as Tko.InternId, byval here as Tko.ScopeId )

    if init = Tko.NODE_NONE then return
    dim as Tko.NodeKind ik = c.ast->Kind( init )
    '' A BRACE LIST on anything but an array is TKO0845's now (braceinit.bas), so only a
    '' paren list is counted here.
    dim as boolean isList = (ik = Tko.N_TUPLE)
    if isList = false then return

    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init )].data )]

    '' 'type<child>( 4, 5 )' fills a CHILD and upcasts. Its type ref is the target.
    dim as Tko.TypeId lt = t
    if lp->target <> Tko.NODE_NONE then
        dim as Tko.TypeId a = ResolveTypeRef( c, lp->target, here )
        if a = Tko.TYPE_NONE then return
        lt = a
    end if

    dim as long slots = SlotsOfType_( c, lt, 0 )
    if slots < 0 then return
    if lp->count <= slots then return

    c.diags->Report( Tko.TKO0618, Tko.PointRange( c.ast->Loc( init ) ), _
                     c.names->Spelling( nm ) )
end sub

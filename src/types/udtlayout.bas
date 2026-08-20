'' udtlayout.bas -- see udtlayout.bi for the measured rules this implements.

#include once "types/udtlayout.bi"

namespace Fbx

function UdtLayouts.Find( byval t as TypeId ) as long
    for i as long = 0 to this.udts.Count - 1
        if this.udts[i].type_ = t then return i
    next
    return -1
end function

function UdtLayouts.FieldOffset _
    ( byval t as TypeId, byval nm as InternId, byref found as boolean ) as long

    found = false
    dim as long ui = this.Find( t )
    if ui < 0 then return 0
    dim as UdtInfo ptr u = @this.udts[ui]
    for i as long = 0 to u->count - 1
        if this.fields[u->first + i].name = nm then
            found = true
            return this.fields[u->first + i].offset
        end if
    next
    return 0
end function

private function AlignUp( byval n as long, byval a as long ) as long
    if a <= 1 then return n
    return ((n + a - 1) \ a) * a
end function

'' The alignment a member of this type is placed at. For a UDT that is its computed
'' alignment; for anything else the type system already knows it.
private function MemberAlign _
    ( byval t as TypeId, byref types as TypeContext, byref store as UdtLayouts ) as long

    dim as long ui = store.Find( t )
    if ui >= 0 then return store.udts[ui].align
    '' An array is aligned as its ELEMENT, and the element may itself be a UDT whose
    '' layout only this store knows -- TypeContext.Layout cannot see it.
    if types.Kind( t ) = TK_ARRAY then
        return MemberAlign( types.Inner( t ), types, store )
    end if
    dim as TypeLayout l = types.Layout( t )
    if l.align <= 0 then return 1
    return l.align
end function

private function MemberSize _
    ( byval t as TypeId, byref types as TypeContext, byref store as UdtLayouts ) as long

    dim as long ui = store.Find( t )
    if ui >= 0 then return store.udts[ui].size
    if types.Kind( t ) = TK_ARRAY then
        dim as long n = types.ElemCount( t )
        if n <= 0 then n = 1
        return MemberSize( types.Inner( t ), types, store ) * n
    end if
    dim as TypeLayout l = types.Layout( t )
    if l.size < 0 then return 0
    return l.size
end function

'' One GROUP of fields: the members of a named aggregate, or of one anonymous aggregate
'' spliced into it. Recursive, because an anonymous group nests and its KIND -- union or
'' type -- is independent of its parent's.
''
'' This replaced a single forward pass that scanned ahead for a "run of consecutive union
'' members". A run cannot express an anonymous TYPE inside a UNION: its members are
'' SEQUENTIAL and the group as a whole OVERLAPS its siblings. winnt.bi's _SLIST_HEADER
'' is that shape, and it laid out wrongly for as long as the run model lasted.
''
'' 'emit' is false on the measuring pass. A nested group's alignment decides where it
'' starts, and its size is not known until its members are placed, so it is measured
'' first and then placed -- the same two-pass shape the old run-scan used, one level up.
private sub PlaceGroup _
    ( byref flds as FB.Array( of ulong ), byref idx as long, byval depth as long, _
      byval isUnion as boolean, byval pack as long, byval baseOff as long, _
      byval emit as boolean, byref syms as SymbolTable, byref types as TypeContext, _
      byref store as UdtLayouts, byref u as UdtInfo, _
      byref outSize as long, byref outAlign as long )

    dim as long off = 0
    dim as long grpAlign = 1
    dim as long grpSize = 0
    dim as boolean first = true

    while idx < flds.Count
        dim as SymbolId sid = cast( SymbolId, flds[idx] )
        dim as Symbol ptr f = syms.SymbolAt( sid )
        if f = 0 then exit while
        dim as long fd = cast( long, f->anonDepth )
        if fd < depth then exit while

        if fd > depth then
            '' A nested anonymous group. Measure it, place it as ONE member, then walk
            '' it again for real.
            dim as long probe = idx
            dim as long gs = 0
            dim as long ga = 1
            dim as boolean nestedIsUnion = ((f->flags and SYMF_UNION) <> 0)
            PlaceGroup( flds, probe, depth + 1, nestedIsUnion, pack, 0, false, _
                        syms, types, store, u, gs, ga )
            dim as long ea = ga
            if (pack > 0) andalso (ea > pack) then ea = pack
            dim as long at = 0
            if isUnion then
                at = 0
                if gs > grpSize then grpSize = gs
            else
                off = AlignUp( off, ea )
                at = off
                off += gs
                grpSize = off
            end if
            if ga > grpAlign then grpAlign = ga
            PlaceGroup( flds, idx, depth + 1, nestedIsUnion, pack, baseOff + at, emit, _
                        syms, types, store, u, gs, ga )
            first = false
            continue while
        end if

        '' A field written at THIS level. A second anonymous group at the same depth
        '' ends this one.
        if (first = false) andalso (depth > 0) andalso _
           ((f->flags and SYMF_UNION_FIRST) <> 0) then
            exit while
        end if

        dim as long natural = MemberAlign( f->type_, types, store )
        dim as long fa = natural
        if (pack > 0) andalso (fa > pack) then fa = pack
        dim as long fs = MemberSize( f->type_, types, store )
        if natural > grpAlign then grpAlign = natural

        dim as long at2 = 0
        if isUnion then
            at2 = 0
            if fs > grpSize then grpSize = fs
        else
            off = AlignUp( off, fa )
            at2 = off
            off += fs
            grpSize = off
        end if

        if emit then
            dim as UdtField uf
            uf.name = f->name
            uf.type_ = f->type_
            uf.offset = baseOff + at2
            store.fields.Push( uf )
            u.count += 1
        end if

        first = false
        idx += 1
    wend

    outSize = grpSize
    outAlign = grpAlign
end sub

'' One UDT, given its scope. Returns false when a member's type is not yet known, so
'' the caller can try again after the types it depends on have been laid out.
private function LayOutOne _
    ( byval sym as SymbolId, byref syms as SymbolTable, byref types as TypeContext, _
      byref store as UdtLayouts ) as boolean

    dim as Symbol ptr s = syms.SymbolAt( sym )
    if s = 0 then return false
    if s->type_ = TYPE_NONE then return false
    if store.Find( s->type_ ) >= 0 then return true

    dim as SymScope ptr sc = syms.ScopeAt( s->inner )
    if sc = 0 then return false

    dim as UdtInfo u
    u.type_ = s->type_
    u.first = store.fields.Count
    u.count = 0

    '' 'field = N' caps how far each MEMBER is aligned. The type's own alignment stays
    '' the maximum of its members' NATURAL alignments, which is why Field1 packs to
    '' offsets 0/1/5 and size 7 yet still embeds 4-aligned.
    dim as long pack = types.Packing( s->type_ )

    '' The fields in declaration order, so the placement below can look ahead. The
    '' per-scope list is a linked list and a group needs its whole extent before its
    '' first member can be placed, which a single forward pass cannot give.
    dim as FB.Array( of ulong ) flds
    dim as SymbolId cur = sc->firstSym
    while cur <> SYMBOL_NONE
        dim as Symbol ptr f = syms.SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, SYM_FIELD ) then
            if f->type_ = TYPE_NONE then
                '' A member whose type is not resolved yet. Abandon rather than lay
                '' the type out wrongly -- a half-computed offset is worse than none.
                while store.fields.Count > u.first
                    store.fields.Pop( )
                wend
                return false
            end if
            flds.Push( cast( ulong, cur ) )
        end if
        cur = f->nextInScope
    wend

    dim as long idx = 0
    dim as long maxAlign = 1
    dim as long total = 0
    PlaceGroup( flds, idx, 0, ((s->flags and SYMF_UNION_KIND) <> 0), pack, 0, true, _
                syms, types, store, u, total, maxAlign )
    dim as long offset = total

    '' A type's alignment is the maximum of its members', and its size is rounded up
    '' to that -- which is where the trailing padding of 'byte, long, short' (offsets
    '' 0, 4, 8; size 12, not 10) comes from.
    u.align = maxAlign
    dim as long sizeAlign = maxAlign
    if (pack > 0) andalso (sizeAlign > pack) then sizeAlign = pack
    u.size = AlignUp( offset, sizeAlign )
    if u.size = 0 then u.size = 1
    store.udts.Push( u )
    return true
end function

function ComputeUdtLayouts _
    ( byref syms as SymbolTable, byref types as TypeContext, _
      byref store as UdtLayouts ) as long

    '' A UDT can contain another, so the order matters. Rather than sort the
    '' dependency graph, this repeats until nothing new is laid out: the number of
    '' rounds is the nesting depth, which is small, and a cycle simply stops making
    '' progress instead of recursing forever.
    dim as boolean progress = true
    while progress
        progress = false
        for i as long = 1 to syms.Count( )
            dim as SymbolId sid = cast( SymbolId, i )
            dim as Symbol ptr s = syms.SymbolAt( sid )
            if s = 0 then continue for
            if s->kind <> cast( ubyte, SYM_UDT ) then continue for
            if s->type_ = TYPE_NONE then continue for
            if store.Find( s->type_ ) >= 0 then continue for
            if LayOutOne( sid, syms, types, store ) then progress = true
        next
    wend
    return store.udts.Count
end function

'' One UDT's rows, under a given NAME. A layout has one shape and may have several
'' names: a TYPEDEF aliasing a UDT is that layout, and a TUPLE has no name of its own
'' that anyone wrote -- 'type Tup2 as (long, string)' desugars to a synthetic UDT called
'' '$tup:6:15', so the only spelling a reader or a gate can look up is the alias.
private function RowsFor _
    ( byref store as UdtLayouts, byref names as Interner, _
      byval idx as long, byref nm as string ) as string

    dim as UdtInfo ptr u = @store.udts[idx]
    dim as string outp = nm & " size " & str( u->size ) & _
                         " align " & str( u->align ) & chr( 10 )
    for j as long = 0 to u->count - 1
        dim as UdtField ptr f = @store.fields[u->first + j]
        outp += "  " & nm & " off " & names.Spelling( f->name ) & " " & _
                str( f->offset ) & chr( 10 )
    next
    return outp
end function

function DumpUdtLayouts _
    ( byref store as UdtLayouts, byref types as TypeContext, _
      byref names as Interner, byref syms as SymbolTable ) as string

    dim as string outp = ""
    for i as long = 0 to store.udts.Count - 1
        outp += RowsFor( store, names, i, types.Name( store.udts[i].type_ ) )
    next

    '' Every TYPEDEF that names a UDT, under its own spelling.
    for i as long = 1 to syms.Count( )
        dim as Symbol ptr s = syms.SymbolAt( cast( SymbolId, i ) )
        if s = 0 then continue for
        if s->kind <> cast( ubyte, SYM_TYPEDEF ) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as long at = store.Find( s->type_ )
        if at < 0 then continue for
        outp += RowsFor( store, names, at, names.Spelling( s->name ) )
    next
    outp += "udts: " & str( store.udts.Count ) & chr( 10 )
    return outp
end function

end namespace

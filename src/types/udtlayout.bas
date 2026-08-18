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
    dim as TypeLayout l = types.Layout( t )
    if l.align <= 0 then return 1
    return l.align
end function

private function MemberSize _
    ( byval t as TypeId, byref types as TypeContext, byref store as UdtLayouts ) as long

    dim as long ui = store.Find( t )
    if ui >= 0 then return store.udts[ui].size
    dim as TypeLayout l = types.Layout( t )
    if l.size < 0 then return 0
    return l.size
end function

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

    dim as long offset = 0
    dim as long maxAlign = 1
    dim as boolean inUnionRun = false
    dim as long unionStart = 0
    dim as long unionSize = 0
    dim as long unionAlign = 1

    '' Declaration order, through the per-scope linked list.
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
            dim as long fa = MemberAlign( f->type_, types, store )
            dim as long fs = MemberSize( f->type_, types, store )
            if fa > maxAlign then maxAlign = fa
            dim as boolean isUnion = ((f->flags and SYMF_UNION) <> 0)

            '' A run of consecutive union members shares ONE offset -- they overlap --
            '' and that offset is aligned to the WIDEST member of the run, not to the
            '' first one. So the run is scanned ahead before anything is placed:
            '' 'union : as long l : as double d' puts BOTH at 8, and reacting member
            '' by member put l at 4 and d at 8, which is a union that is not a union.
            if isUnion andalso (inUnionRun = false) then
                dim as long runAlign = 1
                dim as long runSize = 0
                dim as SymbolId scan = cur
                while scan <> SYMBOL_NONE
                    dim as Symbol ptr g = syms.SymbolAt( scan )
                    if g = 0 then exit while
                    if g->kind <> cast( ubyte, SYM_FIELD ) then exit while
                    if (g->flags and SYMF_UNION) = 0 then exit while
                    dim as long ga = MemberAlign( g->type_, types, store )
                    dim as long gs = MemberSize( g->type_, types, store )
                    if ga > runAlign then runAlign = ga
                    if gs > runSize then runSize = gs
                    scan = g->nextInScope
                wend
                inUnionRun = true
                unionAlign = runAlign
                unionSize = runSize
                unionStart = AlignUp( offset, runAlign )
                offset = unionStart
                if runAlign > maxAlign then maxAlign = runAlign
            elseif (isUnion = false) andalso inUnionRun then
                offset = unionStart + unionSize
                inUnionRun = false
            end if

            if isUnion = false then
                offset = AlignUp( offset, fa )
            else
                offset = unionStart
            end if

            dim as UdtField uf
            uf.name = f->name
            uf.type_ = f->type_
            uf.offset = offset
            store.fields.Push( uf )
            u.count += 1
            if isUnion = false then offset += fs
        end if
        cur = f->nextInScope
    wend

    if inUnionRun then offset = unionStart + unionSize

    '' A type's alignment is the maximum of its members', and its size is rounded up
    '' to that -- which is where the trailing padding of 'byte, long, short' (offsets
    '' 0, 4, 8; size 12, not 10) comes from.
    u.align = maxAlign
    u.size = AlignUp( offset, maxAlign )
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

function DumpUdtLayouts _
    ( byref store as UdtLayouts, byref types as TypeContext, _
      byref names as Interner ) as string

    dim as string outp = ""
    for i as long = 0 to store.udts.Count - 1
        dim as UdtInfo ptr u = @store.udts[i]
        outp += types.Name( u->type_ ) & " size " & str( u->size ) & _
                " align " & str( u->align ) & chr( 10 )
        for j as long = 0 to u->count - 1
            dim as UdtField ptr f = @store.fields[u->first + j]
            outp += "  " & types.Name( u->type_ ) & " off " & _
                    names.Spelling( f->name ) & " " & str( f->offset ) & chr( 10 )
        next
    next
    outp += "udts: " & str( store.udts.Count ) & chr( 10 )
    return outp
end function

end namespace

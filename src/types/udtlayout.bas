'' udtlayout.bas -- see udtlayout.bi for the measured rules this implements.

#import "std/containers"
#include once "types/udtlayout.bi"
#include once "diag/diagids.bi"
#include once "support/irtext.bi"

namespace Tko

function UdtLayouts.Find( byval t as TypeId ) as long
    for i as long = 0 to this.udts.Count - 1
        if this.udts[i].type_ = t then return i
    next
    return -1
end function

function UdtLayouts.FieldOffset _
    ( byval t as TypeId, byval nm as InternId, byref found as boolean ) as long

    dim as TypeId ft = TYPE_NONE
    return this.FieldOffsetType( t, nm, found, ft )
end function

'' The same walk, also handing back the field's own type -- see the header.
function UdtLayouts.FieldOffsetType _
    ( byval t as TypeId, byval nm as InternId, byref found as boolean, _
      byref fieldType as TypeId ) as long

    found = false
    fieldType = TYPE_NONE
    dim as long ui = this.Find( t )
    if ui < 0 then return 0
    dim as UdtInfo ptr u = @this.udts[ui]
    dim as long baseAt = -1
    for i as long = 0 to u->count - 1
        if this.fields[u->first + i].name = nm then
            found = true
            fieldType = this.fields[u->first + i].type_
            return this.fields[u->first + i].offset
        end if
        if this.fields[u->first + i].name = this.baseName then baseAt = u->first + i
    next

    '' AN INHERITED FIELD. 'extends T' is a field named 'base', so a name this type does
    '' not hold is looked for in that field's type, and its offset is added -- which is
    '' zero today, because the base is always the first member, but adding it is what
    '' makes the walk state the rule rather than rely on it.
    if (baseAt >= 0) andalso (nm <> this.baseName) then
        dim as TypeId bt = this.fields[baseAt].type_
        if (bt <> TYPE_NONE) andalso (bt <> t) then
            dim as boolean up = false
            dim as TypeId uft = TYPE_NONE
            dim as long off = this.FieldOffsetType( bt, nm, up, uft )
            if up then
                found = true
                fieldType = uft
                return this.fields[baseAt].offset + off
            end if
        end if
    end if
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
    '' A DYNAMIC array is a descriptor of POINTERS, so it aligns as one -- not as its
    '' element, which is what the array rule below would say.
    if types.IsDynArray( t ) then return types.target.pointerBits \ 8
    if types.Kind( t ) = TK_ARRAY then
        return MemberAlign( types.Inner( t ), types, store )
    end if
    dim as TypeLayout l = types.Layout( t )
    if l.align <= 0 then return 1
    return l.align
end function

'' A DYNAMIC ARRAY IS ITS DESCRIPTOR, not its elements. 'd( any ) as long' as a member
'' measured FOUR bytes -- the element size -- where fbc says seventy-two, so a UDT
'' holding one was the wrong size and every field after it was at the wrong offset.
''
'' Silent for as long as nothing wrote through the descriptor: 'sizeof' was wrong and
'' nothing read it. The moment a constructor initialised the descriptor it became a
'' write past the end of the object.
''
'' The shape is measured in mir/lowerdesc.bas: six pointer-sized fields and three more
'' per dimension. Rank 0 is an unspecified dimension count, which fbc gives the full
'' eight slots because it does not know either.
private function DescBytes_( byval t as TypeId, byref types as TypeContext ) as long
    dim as long n = types.DynRank( t )
    if n <= 0 then n = 8
    return (types.target.pointerBits \ 8) * (6 + n * 3)
end function

private function MemberSize _
    ( byval t as TypeId, byref types as TypeContext, byref store as UdtLayouts ) as long

    dim as long ui = store.Find( t )
    if ui >= 0 then return store.udts[ui].size
    if types.IsDynArray( t ) then return DescBytes_( t, types )
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
    ( byref flds as containers.Array( of ulong ), byref idx as long, byval depth as long, _
      byval isUnion as boolean, byval pack as long, byval baseOff as long, _
      byval emit as boolean, byref syms as SymbolTable, byref types as TypeContext, _
      byref store as UdtLayouts, byref u as UdtInfo, _
      byref outSize as long, byref outAlign as long )

    dim as long off = 0
    dim as long grpAlign = 1
    dim as long grpSize = 0
    dim as boolean first = true

    '' THE OPEN BITFIELD UNIT. 'bitRunSize' is the unit's width in BYTES, 0 when no
    '' run is open; 'bitNext' is the next free bit measured from the START OF THE
    '' GROUP, so a bitfield can pack into space an ordinary field has already partly
    '' used -- 'x as ubyte' then 'a : 3 as ulong' is FOUR bytes with a at bits 8..10,
    '' not a fresh unit after x.
    ''
    '' The whole rule is written down in tools/gen/udt-truth.py, measured over eleven
    '' shapes by running fbc, and check-udt.sh holds six of them.
    dim as long bitRunSize = 0
    dim as long bitNext = 0
    '' Where the open run's CURRENT unit starts, in bits from the start of the group.
    dim as long bitRunStart = 0

    while idx < flds.Count
        dim as SymbolId sid = cast( SymbolId, flds[idx] )
        dim as Symbol ptr f = syms.SymbolAt( sid )
        if f = 0 then exit while
        dim as long fd = cast( long, f->anonDepth )
        if fd < depth then exit while

        '' DOES THIS FIELD START A NEW GROUP AT OR ABOVE THIS DEPTH? A field opens the
        '' levels (anonDepth - anonOpen + 1) .. anonDepth, so it ends the group at
        '' 'depth' when the shallowest level it opens is 'depth' or above. Without
        '' this, 'type { union { a }; union { type { b } } }' put b inside the FIRST
        '' union -- b sits at anonDepth 2, the second union owns no field of its own at
        '' depth 1, and nothing else said the group had ended. Measured: 4 bytes where
        '' fbc says 8.
        if (first = false) andalso (depth > 0) then
            dim as long opensAt = fd - cast( long, f->anonOpen ) + 1
            if (f->anonOpen > 0) andalso (opensAt <= depth) then exit while
        end if

        if fd > depth then
            '' A nested anonymous group. Measure it, place it as ONE member, then walk
            '' it again for real.
            dim as long probe = idx
            dim as long gs = 0
            dim as long ga = 1
            '' THE KIND OF THE LEVEL BEING OPENED, not of the field's innermost
            '' aggregate. An anonymous TYPE inside an anonymous UNION is sequential at
            '' its own level and overlapping at its parent's, and one bit could not say
            '' both -- so the mask is read at the level this call is about to place.
            dim as boolean nestedIsUnion = false
            if depth < 16 then
                nestedIsUnion = ((f->anonUnionMask and _
                                  cast( ushort, 1 shl depth )) <> 0)
            end if
            '' ITS OWN 'field = N' caps its members and its own padding, not where it sits: that
            '' is still the enclosing level's cap over its NATURAL alignment. Measured, fbc:
            ''   union C : type field = 1 : byte a, long b, byte c        b at 1, c at 5, size 8
            ''   type F : union field = 1 : type : short a, byte b : ... : byte c   c at 3, size 4
            '' (structs/anon-align.bas). Every group below it inherits the cap.
            dim as long npack = pack
            if (f->anonPack > 0) andalso (cast( long, f->anonPackLevel ) = depth + 1) then npack = f->anonPack
            PlaceGroup( flds, probe, depth + 1, nestedIsUnion, npack, 0, false, _
                        syms, types, store, u, gs, ga )
            dim as long ea = ga
            if (pack > 0) andalso (ea > pack) then ea = pack
            dim as long at = 0
            if isUnion then
                at = 0
                if gs > grpSize then grpSize = gs
            else
                '' A GROUP AFTER A BITFIELD RUN starts at the end of the run's unit, as an
                '' ordinary field does -- and a bitfield after the group starts after it.
                '' Neither was done: the bit cursor stayed where the group began, so
                '' winnt.h's IMPORT_OBJECT_HEADER put 'Type : 2 as WORD' on top of the
                '' union before it (byte 16 where fbc has 18), and 'x : 3 as ulong' then a
                '' union put the union at byte 1 where fbc has 4. Measured, fbc-modern.
                if bitRunSize > 0 then
                    off = (bitRunStart + bitRunSize * 8) \ 8
                    if off > grpSize then grpSize = off
                    bitRunSize = 0
                end if
                off = AlignUp( off, ea )
                at = off
                off += gs
                grpSize = off
                bitNext = off * 8
            end if
            if ga > grpAlign then grpAlign = ga
            PlaceGroup( flds, idx, depth + 1, nestedIsUnion, npack, baseOff + at, emit, _
                        syms, types, store, u, gs, ga )
            first = false
            continue while
        end if

        dim as long natural = MemberAlign( f->type_, types, store )
        dim as long fa = natural
        if (pack > 0) andalso (fa > pack) then fa = pack
        dim as long fs = MemberSize( f->type_, types, store )
        '' A BASE THAT IS A BARE STRING TYPE OCCUPIES NOTHING. Measured, fbc:
        ''
        ''     type C extends wstring : x as byte : end type    sizeof 1
        ''     type D extends zstring : x as byte : end type    sizeof 1
        ''
        '' -- the base is a MARKER, not storage: what it buys is that the whole
        '' string family's conversions accept the type. tiko counted it as the 2 (or
        '' 1) bytes a bare wstring or zstring reports, so every such type was too
        '' long and every field after the base sat at the wrong offset.
        '' udt-wstring/conversion.bas's UWSTRING_FIXED is 34 bytes that way and 32
        '' to fbc.
        if f->name = store.baseName then
            if types.Kind( f->type_ ) = TK_BUILTIN then
                select case types.BuiltinOf( f->type_ )
                case TY_ZSTRING, TY_WSTRING
                    fs = 0
                    fa = 1
                    '' AND THE ALIGNMENT TOO: the UDT's own alignment is the widest
                    '' member's, and a base that occupies nothing contributes
                    '' none. Leaving it at 2 made 'extends wstring' with one
                    '' BYTE field 2 bytes long where fbc says 1.
                    natural = 1
                end select
            end if
        end if

        dim as long bw = 0
        if (f->flags and SYMF_BITFIELD) <> 0 then bw = f->payload

        dim as long at2 = 0
        dim as long bitAt = 0
        dim as long unitAt = 0, unitLen = 0

        if bw > 0 then
            '' A BITFIELD. Its unit is as wide as its declared type and aligned to it,
            '' UNLESS a run is already open and the field still fits inside it -- a
            '' later bitfield packs into the current unit whatever its own type says.
            '' 'ubyte:3 then ulong:3' is ONE byte; 'ulong:3 then ubyte:3' is four.
            '' The unit is the aligned region CONTAINING the cursor, not the next
            '' one along. That distinction is the whole of BitAfterFld: 'x as ubyte'
            '' then 'a : 3 as ulong' puts a at bits 8..10 of the unit anchored at 0 --
            '' aligning the cursor UP to 32 instead pushed a into a second unit and
            '' made the type 12 bytes where fbc says 8.
            dim as long unitBits = fs * 8
            dim as long unitStart = 0
            if bitRunSize > 0 then
                '' A run is open: its width governs, whatever this field's type says.
                unitBits = bitRunSize * 8
                unitStart = bitRunStart
            else
                '' A NEW run. Its width, and its alignment, come from THIS field --
                '' the only bitfield in the run that contributes any alignment at all.
                bitRunSize = fs
                if natural > grpAlign then grpAlign = natural
                '' ITS UNIT STARTS AT THE REGION CONTAINING THE CURSOR, and the region is
                '' the PACKED alignment. Measured: 'field=1 : ubyte p : long x:3' is 5
                '' bytes in fbc -- x's unit starts at byte 1 -- where anchoring on the
                '' unit's own width put it at 0 and made the type 2. Unpacked, the packed
                '' alignment IS the unit's, so nothing there moves.
                dim as long anchorBits = fa * 8
                if anchorBits < 8 then anchorBits = 8
                unitStart = (bitNext \ anchorBits) * anchorBits
            end if
            if (bitNext - unitStart) + bw > unitBits then
                '' IT DOES NOT FIT, so a NEW run begins -- of THIS field's type, not the
                '' open run's. Keeping the open width put 'd : 10 as ushort' after two
                '' ubyte bitfields into an 8-bit unit: the type was 5 bytes where fbc's is
                '' 6, and 'd = 1023' read back 255. Measured: the new unit starts at the END
                '' of the open one, rounded UP to the field's packed alignment: 'field=1 :
                '' long a:20, b:20' puts b at bit 32; 'field=1 : ubyte a:7, ulong d:30' puts
                '' d at bit 8, unpacked at 32; 'field=1 : ubyte p, long a:20, ushort b:14'
                '' at bit 40.
                dim as long ovAnchor = fa * 8
                if ovAnchor < 8 then ovAnchor = 8
                unitStart = ((unitStart + unitBits + ovAnchor - 1) \ ovAnchor) * ovAnchor
                bitRunSize = fs
                unitBits = fs * 8
                if natural > grpAlign then grpAlign = natural
                bitNext = unitStart
            end if
            bitRunStart = unitStart

            at2 = bitNext \ 8
            bitAt = bitNext mod 8
            unitAt = unitStart \ 8
            unitLen = bitRunSize
            bitNext += bw

            if isUnion then
                '' THE WHOLE UNIT, in a union: a 'u : 3 as long' member occupies four bytes,
                '' not one -- fbc makes the anonymous union holding it four bytes long.
                dim as long ub = fs
                if ub > grpSize then grpSize = ub
                at2 = 0
                bitAt = 0
                unitAt = 0
                unitLen = fs
                bitNext = 0
                bitRunSize = 0
            else
                '' The extent is the bits actually used, rounded up to a byte. The
                '' UNIT is not reserved: 'ubyte:3 then ulong:3' is one byte, not four.
                dim as long used = (bitNext + 7) \ 8
                if used > grpSize then grpSize = used
                off = used
            end if
        else
            if natural > grpAlign then grpAlign = natural

            '' AN ORDINARY FIELD AFTER A BITFIELD RUN starts at the END OF THE UNIT,
            '' not at the next free byte: 'a : 3 as ulong' then 'y as ubyte' puts y at
            '' 4. Closing the run here is what makes that happen.
            if bitRunSize > 0 then
                off = (bitRunStart + bitRunSize * 8) \ 8
                if off > grpSize then grpSize = off
                bitRunSize = 0
                bitNext = 0
            end if

            if isUnion then
                at2 = 0
                if fs > grpSize then grpSize = fs
            else
                off = AlignUp( off, fa )
                at2 = off
                off += fs
                grpSize = off
                bitNext = off * 8
            end if
        end if

        if emit then
            dim as UdtField uf
            uf.name = f->name
            uf.type_ = f->type_
            uf.offset = baseOff + at2
            uf.bitOffset = bitAt
            uf.bitWidth = bw
            if bw > 0 then
                uf.unitOffset = baseOff + unitAt
                uf.unitBytes = unitLen
            end if
            store.fields.Push( uf )
            u.count += 1
        end if

        first = false
        idx += 1
    wend

    '' AN OPEN RUN AT THE END OF THE TYPE CLOSES AT ITS UNIT'S FULL WIDTH, as it does when
    '' an ordinary field follows. Measured, fbc: 'field=1 : short a:3, w:8, h:8' is 4 bytes,
    '' 'field=1 : long x:3' is 4, 'field=2 : long x:3' is 4 -- tiko said 3, 1 and 2, and
    '' a load of h's short unit ran a byte past the object, which only -O2 noticed
    '' (structs/bitfield_conv). Unpacked, the alignment padding already gave the same size.
    if (isUnion = false) andalso (bitRunSize > 0) then
        dim as long closeAt = (bitRunStart + bitRunSize * 8) \ 8
        if closeAt > grpSize then grpSize = closeAt
    end if

    '' AN ANONYMOUS GROUP IS PADDED TO ITS OWN ALIGNMENT, as a named one is: 'union : type : as short a
    '' : as byte b : end type : end union : as byte c' puts c at 4 where tiko had 3 -- the inner type is
    '' four bytes, not three (structs/anon-align.bas). The top level pads in its caller.
    if depth > 0 then
        dim as long gpa = grpAlign
        if (pack > 0) andalso (gpa > pack) then gpa = pack
        grpSize = AlignUp( grpSize, gpa )
    end if
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
    dim as containers.Array( of ulong ) flds
    dim as SymbolId cur = sc->firstSym
    while cur <> SYMBOL_NONE
        dim as Symbol ptr f = syms.SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, SYM_FIELD ) then
            dim as boolean notReady = (f->type_ = TYPE_NONE)
            '' A MEMBER WHOSE OWN TYPE IS A UDT THAT IS NOT LAID OUT YET. The rounds
            '' above exist for exactly this, but only an UNRESOLVED type stopped a
            '' round -- a resolved one whose layout was still missing was measured as
            '' SIZE ZERO and the enclosing type came out too small, silently.
            ''
            '' It could not happen while every type was declared before its use. The
            '' builtin 'object' is declared at the END of the unit, so 'extends object'
            '' reaches this before its base exists, and 'a size 16' became 'a size 4'
            '' with no diagnostic anywhere.
            if notReady = false then
                if types.Kind( f->type_ ) = TK_UDT then
                    if store.Find( f->type_ ) < 0 then notReady = true
                end if
            end if
            if notReady then
                '' Abandon rather than lay the type out wrongly -- a half-computed
                '' offset is worse than none.
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

    '' The name an 'extends' becomes a field under. Interned once here so FieldOffset,
    '' which has no interner and runs on every member access, can compare against it.
    if syms.names <> 0 then store.baseName = syms.names->GetString( "base" )

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
    dim as TypeId baseTy = TYPE_NONE
    dim as long baseOff = 0
    for j as long = 0 to u->count - 1
        dim as UdtField ptr f = @store.fields[u->first + j]
        outp += "  " & nm & " off " & names.Spelling( f->name ) & " " & _
                str( f->offset ) & chr( 10 )
        if f->name = store.baseName then
            baseTy = f->type_
            baseOff = f->offset
        end if
    next

    '' INHERITED FIELDS, under the derived type's name and at their offset within it.
    '' They are not in this type's own field list -- 'extends' is one field holding the
    '' whole base -- so without this the dump shows a type that has an 'f1' as a type
    '' that has no 'f1', and the layout gate could not check a single inherited offset.
    while baseTy <> TYPE_NONE
        dim as long bi = store.Find( baseTy )
        if bi < 0 then exit while
        dim as UdtInfo ptr b = @store.udts[bi]
        dim as TypeId nextTy = TYPE_NONE
        dim as long nextOff = 0
        for j as long = 0 to b->count - 1
            dim as UdtField ptr f = @store.fields[b->first + j]
            if f->name = store.baseName then
                nextTy = f->type_
                nextOff = baseOff + f->offset
                continue for
            end if
            outp += "  " & nm & " inherited " & names.Spelling( f->name ) & " " & _
                    str( baseOff + f->offset ) & chr( 10 )
        next
        if nextTy = baseTy then exit while
        baseTy = nextTy
        baseOff = nextOff
    wend
    return outp
end function

function DumpUdtLayouts _
    ( byref store as UdtLayouts, byref types as TypeContext, _
      byref names as Interner, byref syms as SymbolTable ) as string

    dim as IrText outp
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

namespace Tko

'' See udtlayout.bi. The count is recomputed from the bounds in 64 bits, exactly as
'' Resolve does for a builtin element: TypeInfo.elems has already overflowed for the
'' shapes furthest over the limit.
function CheckArraySizes _
    ( byref syms as SymbolTable, byref types as TypeContext, _
      byref store as UdtLayouts, byref names as Interner, _
      byref diags as DiagnosticEngine ) as long

    dim as long reported = 0
    '' A TYPE THAT DOES NOT FIT -- fbc error 51, "User Defined Type too big". Measured at
    '' the boundary: 'as byte array( 0 to &h7FFFFFFF - 1 )' alone is accepted at exactly
    '' 2147483647 bytes, and one more byte beside it is refused.
    ''
    '' DETECTED BY THE OVERFLOW ITSELF. UdtInfo.size is a LONG, so the refused case has
    '' already wrapped to -2147483648 by the time anything can look at it -- a NEGATIVE
    '' size with fields present is the signature. A total that wrapped all the way round
    '' to a small positive number would be missed, which is an under-detection and not a
    '' wrong answer; computing it in 64 bits belongs in ComputeUdtLayouts itself.
    for ui as long = 0 to store.udts.Count - 1
        dim as UdtInfo ptr ui2 = @store.udts[ui]
        if ui2->size >= 0 then continue for
        if ui2->count <= 0 then continue for
        '' ...UNLESS ONE MEMBER ARRAY IS ITSELF OVER THE LIMIT, in which case that array is
        '' the error fbc reports (50) and the type's overflow is its consequence. Reporting
        '' both put two diagnostics on one declaration, which this suite's array-sizes-2
        '' test caught.
        dim as boolean memberTooBig = false
        for fi as long = 0 to ui2->count - 1
            dim as TypeId ft = types.Unqualify( store.fields[ui2->first + fi].type_ )
            if types.Kind( ft ) <> TK_ARRAY then continue for
            if types.IsDynArray( ft ) then continue for
            dim as TypeId fe = types.Unqualify( types.Inner( ft ) )
            '' A UDT ELEMENT'S SIZE LIVES IN THE LAYOUT STORE, not the type table --
            '' types.Layout answers 0 for one, which made this test skip exactly the
            '' Container6 shape it exists to suppress.
            dim as longint fesz = 0
            if types.Kind( fe ) = TK_UDT then
                dim as long fvi = store.Find( fe )
                if fvi >= 0 then fesz = cast( longint, store.udts[fvi].size )
            else
                fesz = cast( longint, types.Layout( fe ).size )
            end if
            if fesz <= 0 then continue for
            dim as long fdims = types.types[cast( long, ft )].dims
            if fdims < 1 then continue for
            dim as long ffirst = types.types[cast( long, ft )].first
            if types.types[cast( long, ft )].count < fdims * 2 then continue for
            dim as longint fn = 1
            for d as long = 0 to fdims - 1
                dim as longint flo = types.boundPool[ffirst + d * 2]
                dim as longint fhi = types.boundPool[ffirst + d * 2 + 1]
                if fhi < flo then fn = 0 : exit for
                fn *= (fhi - flo + 1)
                if fn > 2147483647 then exit for
            next
            if fn <= 0 then continue for
            if (fesz * fn) > 2147483647 then
                memberTooBig = true
                exit for
            end if
        next
        if memberTooBig then continue for
        dim as InternId unm = types.NameOf( ui2->type_ )
        dim as SourceLoc uloc
        for k as long = 0 to syms.symbols.Count - 1
            dim as Symbol ptr us = @syms.symbols[k]
            if us->kind <> cast( ubyte, SYM_UDT ) then continue for
            if us->type_ <> ui2->type_ then continue for
            uloc = us->loc
            exit for
        next
        diags.Report( TKO0754, PointRange( uloc ), names.Spelling( unm ) )
        reported += 1
    next
    for i as long = 0 to syms.symbols.Count - 1
        dim as Symbol ptr s = @syms.symbols[i]
        if (s->kind <> cast( ubyte, SYM_VARIABLE )) andalso _
           (s->kind <> cast( ubyte, SYM_FIELD )) then continue for
        if s->type_ = TYPE_NONE then continue for
        dim as TypeId t = types.Unqualify( s->type_ )
        if types.Kind( t ) <> TK_ARRAY then continue for
        if types.IsDynArray( t ) then continue for
        dim as TypeId et = types.Unqualify( types.Inner( t ) )
        if types.Kind( et ) <> TK_UDT then continue for
        dim as long vi = store.Find( et )
        if vi < 0 then continue for
        dim as longint esz = cast( longint, store.udts[vi].size )
        if esz <= 0 then continue for
        dim as long dims = types.types[cast( long, t )].dims
        if dims < 1 then continue for
        dim as long bfirst = types.types[cast( long, t )].first
        if types.types[cast( long, t )].count < dims * 2 then continue for
        dim as longint n = 1
        dim as boolean bad = false
        for d as long = 0 to dims - 1
            dim as longint lo = types.boundPool[bfirst + d * 2]
            dim as longint hi = types.boundPool[bfirst + d * 2 + 1]
            if hi < lo then bad = true : exit for
            n *= (hi - lo + 1)
            if n > 2147483647 then exit for
        next
        if bad then continue for
        if n <= 0 then continue for
        if (esz * n) <= 2147483647 then continue for
        diags.Report( TKO0613, PointRange( s->loc ), names.Spelling( s->name ) )
        reported += 1
    next
    return reported
end function

end namespace

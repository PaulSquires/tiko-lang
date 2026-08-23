'' udtlayout.bi -- computing a UDT's size, alignment and field offsets.
''
'' A struct's layout is ABI. It is compatibility surface in the strictest sense: a
'' field at the wrong offset does not fail, it silently reads the neighbouring
'' field's bytes. Every rule here was measured from fbc by compiling and running a
'' probe -- tests/types/expected/fbc-udt.txt -- because 'sizeof' and 'offsetof' are
'' compile-time constants that '#print' will not fold.
''
'' The two rules that are NOT guessable:
''
''   - A type's alignment is the maximum of its members' alignments, and 'field = N'
''     does NOT reduce it. 'field = 1' packs the fields WITHIN the type -- offsets
''     0, 1, 5 for byte/long/short, size 7 -- yet that type still embeds 4-aligned.
''   - A UNION places every member at offset 0; its size is the largest member's,
''     rounded up to its own alignment.

#ifndef __TKO_UDTLAYOUT_BI__
#define __TKO_UDTLAYOUT_BI__

#include once "tko.bi"
#include once "types/type.bi"
#include once "symbols/symbol.bi"

namespace Tko

    type UdtField
        as InternId name
        as TypeId   type_
        as long     offset
        '' A BITFIELD's position INSIDE the byte at 'offset', and how many bits it
        '' owns. bitWidth 0 means an ordinary field -- every other member leaves both
        '' at zero, so nothing that ignores them changes meaning.
        as long     bitOffset
        as long     bitWidth
    end type

    type UdtInfo
        as TypeId   type_
        as long     size
        as long     align
        as long     first      '' into the store's field pool
        as long     count
    end type

    '' Layouts live beside the type table rather than inside TypeInfo: only a few
    '' types are UDTs, and the field pool would otherwise sit unused on every one.
    type UdtLayouts
        as FB.Array( of UdtInfo )  udts
        as FB.Array( of UdtField ) fields
        '' The interned 'base' -- the field an 'extends' becomes. Held here rather than
        '' looked up per call: FieldOffset has no interner and is on the hot path of
        '' every member access.
        as InternId                baseName

        declare function Find( byval t as TypeId ) as long
        declare function FieldOffset _
            ( byval t as TypeId, byval nm as InternId, byref found as boolean ) as long
    end type

    '' Compute the layout of every UDT in the symbol table. Field order and types come
    '' from the type's scope in DECLARATION order, which is what the per-scope linked
    '' list exists for.
    declare function ComputeUdtLayouts _
        ( byref syms as SymbolTable, byref types as TypeContext, _
          byref store as UdtLayouts ) as long

    declare function DumpUdtLayouts _
        ( byref store as UdtLayouts, byref types as TypeContext, _
          byref names as Interner, byref syms as SymbolTable ) as string

end namespace

#endif

'' vtable.bi -- the virtual method table a UDT gets from EXTENDS OBJECT.
''
'' Every rule here was measured from fbc's own C output and is recorded in
'' docs/language/object-abi.md. The three that are NOT guessable:
''
''   - The stored vptr points at SLOT TWO, not slot zero. Below it sit a null word
''     and the pointer to this type's RTTI record. So slot n of the table below is at
''     byte offset n * sizeof(ptr) FROM THE VPTR, which is what a call site indexes.
''   - A 'declare abstract' occupies a slot, holding NULL. It is not absent, and a
''     derived type's override fills that same slot rather than appending.
''   - A virtual DESTRUCTOR's slot is its DECLARATION POSITION like any other. It is
''     not first and not last by rule; declared first, it is slot 0.
''
'' A type has a table if and only if it extends OBJECT, transitively. fbc rejects
'' 'virtual' on anything that does not -- error 221 -- so there is no such thing as a
'' vptr-bearing UDT outside this chain, and the vptr is never anywhere but offset 0.

#ifndef __TKO_VTABLE_BI__
#define __TKO_VTABLE_BI__

#include once "tko.bi"
#include once "ast/nodes.bi"
#include once "types/type.bi"
#include once "symbols/symbol.bi"
#include once "symbols/mangle.bi"
#include once "symbols/resolve.bi"

namespace Tko

    type VtSlot
        '' The procedure this slot dispatches to, or SYMBOL_NONE for an ABSTRACT slot
        '' that no type in this chain has filled yet.
        as SymbolId proc_
        '' Kept beside the symbol so an override can be matched without going back to
        '' the symbol table for every candidate.
        as InternId name
        as NodeId   decl
    end type

    type VtInfo
        as TypeId   type_
        as long     first          '' into the store's slot pool
        as long     count
    end type

    type VTables
        as FB.Array( of VtInfo ) types_
        as FB.Array( of VtSlot ) slots
        '' The interned 'base' -- the field an EXTENDS becomes. See udtlayout.bi.
        as InternId baseName

        declare function Find( byval t as TypeId ) as long
        '' Which slot dispatches to this procedure, or -1 if it is not virtual in this
        '' type. This is what a call site needs and the only reason the table exists.
        declare function SlotOf( byval t as TypeId, byval p as SymbolId ) as long
    end type

    '' Build a table for every UDT that extends OBJECT. Runs after Resolve, because
    '' matching an override needs the PARAMETER TYPES and those are Resolve's answer.
    declare function ComputeVTables _
        ( byref ast as AstArena, byref syms as SymbolTable, byref types as TypeContext, _
          byref info as SemanticInfo, byref store as VTables ) as long

    '' Slots are printed as the EMITTED SYMBOL NAME, not as 'Type.method': that is what
    '' fbc's own vtable initialiser holds, so the gate compares the two directly rather
    '' than through a spelling neither compiler uses.
    declare function DumpVTables _
        ( byref ast as AstArena, byref store as VTables, byref types as TypeContext, _
          byref names as Interner, byref syms as SymbolTable, _
          byref info as SemanticInfo ) as string

end namespace

#endif

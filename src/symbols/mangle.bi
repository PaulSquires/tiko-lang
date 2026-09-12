'' mangle.bi -- the emitted symbol name for a procedure.
''
'' This is the D3 gate (docs/plan/README, decision D3): tiko-lang must produce names that
'' are BYTE-IDENTICAL to fbc's, because a name that differs by one character does not
'' fail loudly -- it fails at link time in someone else's project, against a library
'' tiko-lang never saw. Every rule here was measured by compiling a probe with fbc and
'' reading the object file's symbol table, never read off documentation; the probe
'' corpus and its expected output are tests/mangle/.
''
'' fbc's scheme is the Itanium C++ ABI, with four FreeBASIC-specific rules:
''
''   1. A name is mangled only when it is NESTED (in a namespace or a type) or when
''      the OVERLOAD keyword was written. Everything else is emitted as the source
''      spelling, UPPERCASED.
''   2. ALIAS replaces the identifier and KEEPS ITS CASE -- but mangling still
''      applies around it: 'sub F overload alias "lower_case"' is _Z10lower_casei.
''   3. Foreign linkage -- EXTERN "C", EXTERN "Windows" -- takes the spelling
''      verbatim, case preserved, and ignores OVERLOAD entirely.
''   4. 'integer' and 'uinteger' are VENDOR EXTENDED types, u7INTEGER and u8UINTEGER,
''      not 'x'/'y'. They are pointer-sized and so distinct from longint even where
''      both are 64 bits, and they take part in substitution like any other type.

#ifndef __TKO_MANGLE_BI__
#define __TKO_MANGLE_BI__

#include once "tko.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "types/type.bi"

namespace Tko.Mangle

    '' The substitution table of the Itanium ABI: the encoding of each component
    '' that has already appeared, in order of first appearance. A repeat is emitted
    '' as S_, S0_, S1_ ... rather than encoded again.
    '' Candidates are keyed by TYPE, not by the string they encode to. Keying by the
    '' string is wrong in a way that only shows on the SECOND occurrence: encoding
    '' 'UDT ptr' a second time recurses, finds 'UDT' already present, and produces
    '' "PS0_" -- which does not match the stored "P3UDT", so a fresh candidate is
    '' added and the name diverges from fbc's. A type is looked up before it is
    '' encoded, never after.
    type Substitutions
        as FB.Array( of string ) items      '' the encoding of each candidate
        as FB.Array( of ulong )  keys       '' the TypeId it came from, 0 for a name
        '' An ARRAY parameter is keyed by its ELEMENT type: 'FBARRAY<T>' and 'T'
        '' are two candidates over the one TypeId, and the encoding cannot be the
        '' key because the second occurrence of the element is itself substituted.
        as FB.Array( of ulong )  arrKeys
        as FB.Array( of long )   arrIdx
        '' THE RANK IS PART OF THE KEY: 'a(any)' and 'a(any,any)' are FBARRAY1 and
        '' FBARRAY2, two different template instantiations over the same element.
        as FB.Array( of long )   arrRank

        declare function Find( byref enc as string ) as long
        declare function FindType( byval t as Tko.TypeId ) as long
        declare sub Add( byref enc as string, byval t as Tko.TypeId = 0 )
        '' A candidate pushed WITHOUT the duplicate test. A template's arguments are
        '' candidates in their own right even when one repeats: measured, fbc spells
        '' 'Pair( of string, string )' 4PairI8FBSTRING8FBSTRINGE and its copy
        '' assignment refers back to the whole as S2_, which counts both.
        declare sub AddRaw( byref enc as string, byval t as Tko.TypeId = 0 )
    end type

    '' Record an instantiation for the mangler: 'nm' is its folded structural name,
    '' 'spell' the generic's DECLARED spelling, 'args' its type arguments in order.
    '' Whether 'nm' names a generic instantiation -- a TYPE or a PROCEDURE.
    declare function IsInstName _
        ( byref types as Tko.TypeContext, byval nm as Tko.InternId ) as boolean
    declare sub RegisterInst _
        ( byref types as Tko.TypeContext, byval nm as Tko.InternId, _
          byval spell as Tko.InternId, byref args as FB.Array( of ulong ) )

    '' The emitted symbol name for one procedure declaration.
    declare function ProcName _
        ( byref ast as Tko.AstArena, byval proc_ as Tko.NodeId, _
          byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
          byref types as Tko.TypeContext, byref info as Tko.SemanticInfo ) as string

    '' What __FUNCTION__ expands to: the procedure's own name, UPPERCASED and qualified
    '' by its enclosing namespaces and types -- 'NS.INNER', 'T.M'. It does not
    '' distinguish overloads, so it is not a mangled name and shares only the qualifier
    '' walk with one. Measured, docs/internals/phase-6-pointers.md.
    '' A STATIC MEMBER'S linker name: the nested-name mangling with the member
    '' component uppercased and a '$' appended. Measured -- '_ZN1T8COUNTER$E'.
    declare function StaticMemberName _
        ( byref syms as Tko.SymbolTable, byval sc as Tko.ScopeId, _
          byref names as Tko.Interner, byref member as string ) as string

    declare function SourceQualifiedName _
        ( byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId, _
          byref names as Tko.Interner ) as string

    '' __FUNCTION__'s value at a use site in scope 'sc'. At MODULE level the answer is
    '' the implicit main procedure's name, '__FB_MAINPROC__' -- measured from the C fbc
    '' emits, not assumed. (Writing it into a CONCATENATION at module level is a
    '' separate matter: fbc then looks __FB_MAINPROC__ up as an identifier and reports
    '' error 42. As a plain value it is the string.)
    declare function EnclosingProcName _
        ( byref syms as Tko.SymbolTable, byval sc as Tko.ScopeId, _
          byref names as Tko.Interner ) as string

    '' The same answer from the procedure SYMBOL rather than from a scope, for lowering,
    '' which tracks the procedure it is in and not the scope chain around a node.
    declare function ProcNameOrMain _
        ( byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId, _
          byref names as Tko.Interner ) as string

    '' Encode one type as an Itanium type component, updating the substitution table.
    '' 'syms' is needed because a UDT declared in a namespace encodes as a NESTED
    '' NAME -- N<prefix>3VECE, not 3VEC -- so the type's declaring scope has to be
    '' walked to spell it.
    declare function TypeCode _
        ( byval t as Tko.TypeId, byref types as Tko.TypeContext, _
          byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
          byref subs as Substitutions ) as string

    declare function Dump _
        ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
          byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
          byref types as Tko.TypeContext, byref info as Tko.SemanticInfo ) as string

end namespace

#endif

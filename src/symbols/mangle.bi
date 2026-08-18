'' mangle.bi -- the emitted symbol name for a procedure.
''
'' This is the D3 gate (docs/plan/README, decision D3): fbx must produce names that
'' are BYTE-IDENTICAL to fbc's, because a name that differs by one character does not
'' fail loudly -- it fails at link time in someone else's project, against a library
'' fbx never saw. Every rule here was measured by compiling a probe with fbc and
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

#ifndef __FBX_MANGLE_BI__
#define __FBX_MANGLE_BI__

#include once "fbx.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "types/type.bi"

namespace Fbx.Mangle

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

        declare function Find( byref enc as string ) as long
        declare function FindType( byval t as Fbx.TypeId ) as long
        declare sub Add( byref enc as string, byval t as Fbx.TypeId = 0 )
    end type

    '' The emitted symbol name for one procedure declaration.
    declare function ProcName _
        ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
          byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo ) as string

    '' Encode one type as an Itanium type component, updating the substitution table.
    '' 'syms' is needed because a UDT declared in a namespace encodes as a NESTED
    '' NAME -- N<prefix>3VECE, not 3VEC -- so the type's declaring scope has to be
    '' walked to spell it.
    declare function TypeCode _
        ( byval t as Fbx.TypeId, byref types as Fbx.TypeContext, _
          byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
          byref subs as Substitutions ) as string

    declare function Dump _
        ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
          byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo ) as string

end namespace

#endif

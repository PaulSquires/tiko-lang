'' symbol.bi -- symbols and scopes.
''
'' Name resolution is a SEPARATE phase from parsing (docs/plan/07 section 1), split
'' into collect / resolve / check. Splitting collect from resolve is what makes
'' FreeBASIC's order-independence work: inside a TYPE a member may reference a member
'' declared later, and a SUB may call one declared further down the module.
''
'' Invariants:
''   - SymbolId 0 and ScopeId 0 are "none"; scope 1 is always the global scope.
''   - A symbol's 'name' is the FOLDED spelling. The lexer already folds, so lookup is
''     an integer compare and case-insensitivity costs nothing here.
''   - Declaration ORDER is preserved per scope. It is observable: destruction runs in
''     reverse declaration order (docs/plan/08 section 6).
''   - Overloads chain through 'nextOverload'; a name maps to the FIRST of them.

#ifndef __FBX_SYMBOL_BI__
#define __FBX_SYMBOL_BI__

#include once "fbx.bi"
#include once "source/location.bi"
#include once "types/type.bi"
#include once "support/intern.bi"

namespace Fbx

    type SymbolId as ulong
    type ScopeId  as ulong

    const SYMBOL_NONE as SymbolId = 0
    const SCOPE_NONE  as ScopeId  = 0
    const SCOPE_GLOBAL as ScopeId = 1

    '' SYM( name, spelling )
    #macro FBX_SYMKIND_LIST( SYM )
        SYM( SYM_VARIABLE,  "var"       )
        SYM( SYM_PARAMETER, "param"     )
        SYM( SYM_CONSTANT,  "const"     )
        SYM( SYM_FIELD,     "field"     )
        SYM( SYM_PROC,      "proc"      )
        SYM( SYM_UDT,       "type"      )
        SYM( SYM_ENUM,      "enum"      )
        SYM( SYM_ENUMCONST, "enumconst" )
        SYM( SYM_TYPEDEF,   "typedef"   )
        SYM( SYM_NAMESPACE, "namespace" )
        SYM( SYM_LABEL,     "label"     )
    #endmacro

    enum SymbolKind
        SYM_NONE = 0
        #define SYM( s_id, s_name ) s_id,
        FBX_SYMKIND_LIST( SYM )
        #undef SYM
        SYM_KIND_COUNT
    end enum

    enum ScopeKind
        SCOPEK_GLOBAL = 0
        SCOPEK_MODULE
        SCOPEK_NAMESPACE
        SCOPEK_TYPE
        SCOPEK_PROC
        SCOPEK_BLOCK
    end enum

    const SYMF_SHARED   as ushort = &h0001
    const SYMF_STATIC   as ushort = &h0002
    const SYMF_CONST    as ushort = &h0004
    const SYMF_EXTERN   as ushort = &h0008
    const SYMF_DECLARED as ushort = &h0010   '' seen as a DECLARE, no body yet
    const SYMF_DEFINED  as ushort = &h0020
    const SYMF_OVERLOAD as ushort = &h0040
    const SYMF_PRIVATE  as ushort = &h0080

    type Symbol
        as ubyte     kind
        as ushort    flags
        as InternId  name          '' folded spelling
        as ScopeId   parent
        as TypeId    type_
        as SourceLoc loc
        as SymbolId  nextOverload
        as SymbolId  nextInScope   '' declaration order within the parent scope
        as ScopeId   inner         '' the scope this symbol opens, if any
        as long      payload       '' AST node, enum value, parameter index ...
    end type

    '' Declaration order is a per-scope LINKED LIST, not a range: an inner scope can
    '' open part-way through a scope (a method's parameters inside a TYPE), so a
    '' scope's symbols are not contiguous in creation order.
    type SymScope
        as ubyte    kind
        as ScopeId  parent
        as SymbolId owner
        as SymbolId firstSym
        as SymbolId lastSym
        as long     count
    end type

    type SymbolVec as FB.Array( of Symbol )
    type ScopeVec  as FB.Array( of SymScope )
    type SymSlotVec as FB.Array( of ulong )

    type SymbolTable
        as SymbolVec  symbols
        as ScopeVec   scopes
        as SymSlotVec slots        '' open addressing on (scope, name)
        as long       mask
        as long       occupied
        as Interner ptr names

        declare constructor( )
        declare sub Attach( byval it as Interner ptr )

        declare function OpenScope _
            ( byval k as ScopeKind, byval parent as ScopeId, _
              byval owner as SymbolId ) as ScopeId

        '' Declare a name in a scope. Named DeclareSym: DECLARE is a keyword. If the name already exists there and both are
        '' procedures, the new one is chained as an overload; otherwise 'duplicate'
        '' is set and the existing symbol is returned.
        declare function DeclareSym _
            ( byval scope_ as ScopeId, byval nm as InternId, byval k as SymbolKind, _
              byval loc as SourceLoc, byref duplicate as boolean ) as SymbolId

        '' Innermost-first through the enclosing scope chain.
        declare function Lookup _
            ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId
        declare function LookupLocal _
            ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

        declare function SymbolAt( byval id as SymbolId ) as Symbol ptr
        declare function ScopeAt( byval id as ScopeId ) as SymScope ptr
        declare function Count( ) as long
        declare function ScopeCount( ) as long

        private:
        declare sub Rehash( byval newSlots as long )
        declare function SlotFor _
            ( byval scope_ as ScopeId, byval nm as InternId ) as long
    end type

    declare function SymbolKindName( byval k as SymbolKind ) as string
    declare function ScopeKindName( byval k as ScopeKind ) as string

end namespace

#endif

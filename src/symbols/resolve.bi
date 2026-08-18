'' resolve.bi -- name resolution.
''
'' The second of the three sub-phases (docs/plan/07 section 1). Collect created a
'' symbol for every declaration; Resolve binds every REFERENCE to one, turns each
'' syntactic TypeRef into a semantic TypeId, and eliminates the parser's deliberately
'' ambiguous call-or-assign node.
''
'' Annotations live in SIDE TABLES keyed by NodeId, not in the nodes
'' (docs/plan/05 section 4). That keeps the AST immutable after parsing, which is what
'' makes caching, re-dumping and a future language server sound.
''
'' Contract:
''   - May report "undefined symbol" and "this is not callable".
''   - May NOT report type errors: that is Check's job.

#ifndef __FBX_RESOLVE_BI__
#define __FBX_RESOLVE_BI__

#include once "fbx.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "types/type.bi"
#include once "diag/engine.bi"

namespace Fbx

    '' What the parser could not decide and the resolver did (docs/plan/07 section 8).
    enum AmbiguousResolution
        AMB_UNRESOLVED = 0
        AMB_CALL              '' Foo 1, 2   -- a procedure call
        AMB_ASSIGN            '' x = 1      -- an assignment
        AMB_PROPERTY_SET      '' p = 1      -- a property setter call
        AMB_RESULT            '' f = 1 inside f -- BASIC's result assignment
        AMB_ERROR
    end enum

    type SymIdVec  as FB.Array( of ulong )
    type TypeIdVec3 as FB.Array( of ulong )
    type ByteVec   as FB.Array( of ubyte )

    '' Per-node annotations. Dense arrays indexed by NodeId: the AST is contiguous, so
    '' this is cheaper and simpler than a map.
    type SemanticInfo
        as SymIdVec   refSymbol     '' NodeId -> SymbolId  (identifiers, call targets)
        as TypeIdVec3 nodeType      '' NodeId -> TypeId    (type references)
        as SymIdVec   nodeScope     '' NodeId -> ScopeId   (recorded by Collect)
        as ByteVec    ambiguous     '' NodeId -> AmbiguousResolution

        declare sub Resize( byval nodeCount as long )
        declare sub SetRef( byval n as NodeId, byval s as SymbolId )
        declare function RefOf( byval n as NodeId ) as SymbolId
        declare sub SetType( byval n as NodeId, byval t as TypeId )
        declare function TypeOf_( byval n as NodeId ) as TypeId
        declare sub SetScope( byval n as NodeId, byval s as ScopeId )
        declare function ScopeOf( byval n as NodeId ) as ScopeId
        declare sub SetAmbiguous( byval n as NodeId, byval a as AmbiguousResolution )
        declare function AmbiguousOf( byval n as NodeId ) as AmbiguousResolution
    end type

end namespace

namespace Fbx.Resolve

    type Stats
        as long references        '' identifiers bound to a symbol
        as long builtins          '' names that are BUILTIN (LEN, ASC, SIN ...)
        as long undefined_        '' genuinely unresolved
        as long typeRefs
        as long calls
        as long assigns
        '' Triage aid: the interned names that did not bind, so the causes can be
        '' aggregated instead of guessed at.
        as FB.Array( of ulong ) unresolvedNames
    end type

    declare sub Run _
        ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
          byref names as Fbx.Interner, byref diags as Fbx.DiagnosticEngine, _
          byref src as Fbx.SourceManager, _
          byref info as Fbx.SemanticInfo, byref st as Stats )

    declare function Dump _
        ( byref ast as Fbx.AstArena, byref syms as Fbx.SymbolTable, _
          byref types as Fbx.TypeContext, byref names as Fbx.Interner, _
          byref info as Fbx.SemanticInfo, byref st as Stats ) as string

end namespace

#endif

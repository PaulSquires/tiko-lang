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

#ifndef __TKO_RESOLVE_BI__
#define __TKO_RESOLVE_BI__

#include once "tko.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "types/type.bi"
#include once "diag/engine.bi"

namespace Tko

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
        '' Bumped by every SetType and SetRef that CHANGES something: Check's "this node
        '' is untyped" memo is valid only while it is unchanged.
        as ulong      version
        as TypeIdVec3 nodeType      '' NodeId -> TypeId    (type references)
        as SymIdVec   nodeScope     '' NodeId -> ScopeId   (recorded by Collect)
        as ByteVec    ambiguous     '' NodeId -> AmbiguousResolution
        '' NodeId -> the instantiation frame (DiagnosticEngine.AddInstFrame) a re-parsed
        '' generic body belongs to, or 0. Set on the body's N_PROC; a pass that walks the
        '' body enters the frame, so what it reports names the instantiation (T16).
        as SymIdVec   instFrame
        '' NodeId -> the PROCEDURE CHECK CHOSE FOR A DECISION THE NODE IMPLIES but does not
        '' name: the constructor of 'dim x as T = v' or 'T( args )', the 'operator let' of
        '' 'x = v', the conversion an argument or operand undergoes. Kept apart from
        '' refSymbol, which is what the node NAMES (scan.bas counts its reads and writes),
        '' so lowering reads the choice instead of making it again (audit Phase 4).
        as SymIdVec   decision

        declare sub Resize( byval nodeCount as long )
        declare sub SetRef( byval n as NodeId, byval s as SymbolId )
        declare function RefOf( byval n as NodeId ) as SymbolId
        declare sub SetType( byval n as NodeId, byval t as TypeId )
        declare function TypeOf_( byval n as NodeId ) as TypeId
        declare sub SetScope( byval n as NodeId, byval s as ScopeId )
        declare function ScopeOf( byval n as NodeId ) as ScopeId
        declare sub SetAmbiguous( byval n as NodeId, byval a as AmbiguousResolution )
        declare function AmbiguousOf( byval n as NodeId ) as AmbiguousResolution
        declare sub SetInstFrame( byval n as NodeId, byval f as long )
        declare function InstFrameOf( byval n as NodeId ) as long
        declare sub SetDecision( byval n as NodeId, byval s as SymbolId )
        declare function DecisionOf( byval n as NodeId ) as SymbolId
    end type

end namespace

namespace Tko.Resolve

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
        '' ...and the NODES, for the undeclared-name report that runs after Check
        '' (Check.ReportUndeclared) -- Resolve cannot make it, because a builtin that is
        '' not a keyword binds nothing either and only a later pass can rule it out.
        as FB.Array( of ulong ) unresolvedIds
        '' ...and the TYPE REFERENCES whose name found nothing -- 'dim as Foo a', 'type X as
        '' FB.Array( of Cell )' with no Array declared. Reported after Check, by the same
        '' pass, once nothing has typed them by then; see undeclared.bas.
        as FB.Array( of ulong ) unresolvedTypes
    end type

    declare sub Run _
        ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
          byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
          byref names as Tko.Interner, byref diags as Tko.DiagnosticEngine, _
          byref src as Tko.SourceManager, _
          byref info as Tko.SemanticInfo, byref st as Stats, _
          byval parser as any ptr = 0, byval maxInstDepth as long = 64 )

    declare function Dump _
        ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
          byref types as Tko.TypeContext, byref names as Tko.Interner, _
          byref info as Tko.SemanticInfo, byref st as Stats ) as string

end namespace

#endif

'' resolvectx.bi -- the Resolve pass's shared context.
''
'' INTERNAL to src/symbols. It exists because resolve.bas reached the 1500-line lint
'' cap and the generic-instantiation half had to move out, and a split is only possible
'' once the two halves can name the same Ctx and the same few helpers. Nothing outside
'' this directory includes it; resolve.bi is still the public face.

#pragma once

#include once "symbols/resolve.bi"

namespace Fbx.Resolve

type Ctx
    as Fbx.AstArena ptr     ast
    as Fbx.SymbolTable ptr  syms
    as Fbx.TypeContext ptr  types
    as Fbx.Interner ptr     names
    as Fbx.SourceManager ptr srcMgr    '' only for the constant evaluator
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.SemanticInfo ptr info
    as Stats ptr            st
    as Fbx.SymbolId         currentProc
    '' The open WITH subjects, innermost last. A '.field' written inside one has no
    '' base in the AST and takes the innermost of these.
    as FB.Array( of ulong )  withSubject
    '' For the BACKPATCH pass: this walk is in source order, and a typedef may name a
    '' type declared later. The typedefs, and the declarations that could not be typed
    '' because of one.
    as FB.Array( of ulong )  typedefNode
    as FB.Array( of ulong )  typedefScope
    as FB.Array( of ulong )  pendingItem
    as FB.Array( of ulong )  pendingScope
    '' The generic type parameters currently in scope, innermost binding last: the
    '' name and the TypeId it stands for. A plain stack rather than a map, because a
    '' generic has one or two parameters and instantiation nests at most a few deep.
    as FB.Array( of ulong )  gparamName
    as FB.Array( of ulong )  gparamType
    '' THE PARSER, still holding the token buffer the unit was parsed from. Kept as an
    '' 'any ptr' so this header does not have to include the parser's -- generic.bas
    '' casts it back. Zero when the caller has no parser to give, in which case a
    '' generic's members are not instantiated and behave as they did before.
    as any ptr               parser
    '' INSTANTIATIONS WAITING FOR THEIR MEMBERS. Six entries each -- generic node,
    '' instantiation name, its inner scope, the scope it was named from, and the
    '' (first, count) of its arguments in pendInstArgs.
    ''
    '' Deferred rather than done on the spot because instantiating a member RE-PARSES
    '' it, and parsing grows ast.stmts. Every StmtPayload ptr held by a caller further
    '' up -- including the one for the very DIM whose type is being resolved -- is a
    '' pointer INTO that vector, and dangles the moment it reallocates. The first
    '' 'dim as Box( of long ) a' in a file came out untyped for exactly that reason.
    as FB.Array( of ulong )  pendInst
    as FB.Array( of ulong )  pendInstArgs
    '' How far pendInst has been drained. A cursor rather than a clear, because the
    '' drain is RE-ENTERED: instantiating one member walks its body, which reaches the
    '' same statement boundary and drains again. Each entry is still done once.
    as long                  pendDone
    '' GENERIC PROCEDURES waiting to be instantiated. Six entries each -- the generic's
    '' node, the symbol the call site was already given, its structural name, the scope
    '' it lives in, and the (first, count) of its arguments in pendProcArgs.
    as FB.Array( of ulong )  pendProc
    as FB.Array( of ulong )  pendProcArgs
    as long                  pendProcDone
end type

'' The helpers the split shares. Their definitions stay in resolve.bas -- only the
'' names are published here.
declare function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
declare function ResolveTypeRef _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId ) as Fbx.TypeId
declare function ArrayFromBounds _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, byval first as long, _
      byval count as long ) as Fbx.TypeId
declare sub WalkStmt _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval scope_ as Fbx.ScopeId )
declare function ListOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.ListPayload ptr
declare function IterElemType_ _
    ( byref c as Ctx, byval seqT as Fbx.TypeId ) as Fbx.TypeId
declare sub BindDeclType _
    ( byref c as Ctx, byval scope_ as Fbx.ScopeId, byval nm as Fbx.InternId, _
      byval t as Fbx.TypeId )
declare function ArrayFromPairs _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, _
      byref los as FB.Array( of ulong ), byref his as FB.Array( of ulong ), _
      byval init as Fbx.NodeId = Fbx.NODE_NONE, _
      byval emptyIsDynamic as boolean = false ) as Fbx.TypeId
declare function ArrayFromBoundsNode _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, byval id as Fbx.NodeId, _
      byval init as Fbx.NodeId = Fbx.NODE_NONE ) as Fbx.TypeId
declare sub BackpatchTypedefs( byref c as Ctx )
declare function IdentNameOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.InternId
declare function InstantiateGenericProc_ _
    ( byref c as Ctx, byval callId as Fbx.NodeId, byval scope_ as Fbx.ScopeId ) as Fbx.SymbolId
declare sub InstantiatePendingProcs_( byref c as Ctx )
declare sub DiscoverInstantiations_ _
    ( byref c as Ctx, byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref diags as Fbx.DiagnosticEngine, byref info as Fbx.SemanticInfo )
declare function QualifierPrefix_( byref c as Ctx, byval sc as Fbx.ScopeId ) as string
declare function HasGenericDecl_( byref c as Ctx ) as boolean
declare sub WalkBlock_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval here as Fbx.ScopeId )
'' Drain the deferred member instantiations.
declare sub InstantiatePending_( byref c as Ctx )
declare function InstantiateGeneric_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr, _
      byval scope_ as Fbx.ScopeId, byval gsid as Fbx.SymbolId ) as Fbx.TypeId

end namespace

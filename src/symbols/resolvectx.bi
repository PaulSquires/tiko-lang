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
declare function InstantiateGeneric_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr, _
      byval scope_ as Fbx.ScopeId ) as Fbx.TypeId

end namespace

'' resolvectx.bi -- the Resolve pass's shared context.
''
'' INTERNAL to src/symbols. It exists because resolve.bas reached the 1500-line lint
'' cap and the generic-instantiation half had to move out, and a split is only possible
'' once the two halves can name the same Ctx and the same few helpers. Nothing outside
'' this directory includes it; resolve.bi is still the public face.

#pragma once

#include once "symbols/resolve.bi"

namespace Tko.Resolve

type Ctx
    as Tko.AstArena ptr     ast
    as Tko.SymbolTable ptr  syms
    as Tko.TypeContext ptr  types
    as Tko.Interner ptr     names
    as Tko.SourceManager ptr srcMgr    '' only for the constant evaluator
    as Tko.DiagnosticEngine ptr diags
    as Tko.SemanticInfo ptr info
    as Stats ptr            st
    as Tko.SymbolId         currentProc
    '' The open WITH subjects, innermost last. A '.field' written inside one has no
    '' base in the AST and takes the innermost of these.
    as FB.Array( of ulong )  withSubject
    '' For the BACKPATCH pass: this walk is in source order, and a typedef may name a
    '' type declared later. The typedefs, and the declarations that could not be typed
    '' because of one.
    as FB.Array( of ulong )  typedefNode
    as FB.Array( of ulong )  typedefScope
    '' PARAMETERS whose typeref would not resolve on the first pass, revisited after
    '' BackpatchTypedefs -- the same treatment pendingItem gives a variable. Every
    '' mingw binding needs it: win/windef.bi writes 'type WPARAM as UINT_PTR'
    '' before including the header that declares UINT_PTR.
    as FB.Array( of ulong )  pendParam
    as FB.Array( of ulong )  pendParamScope
    '' PROCEDURES whose RESULT typeref would not resolve, for the same reason.
    as FB.Array( of ulong )  pendResultProc
    as FB.Array( of ulong )  pendResultProcScope
    '' TYPE FIELDS, for the same reason: 'wParam as WPARAM' inside a TYPE met the same
    '' unresolved typedef, and a UDT with an untyped field gets NO LAYOUT -- so
    '' REBARBANDINFOW, returned by value from AfxNova's AfxGetRebarBandInfo, reached the
    '' backend with no size at all and stopped it with an ICE.
    as FB.Array( of ulong )  pendField
    as FB.Array( of ulong )  pendFieldScope
    '' TYPE ARGUMENTS IN EXPRESSIONS -- 'cast( LPARAM, p )', 'type<LPARAM>( 0 )' --
    '' for the same reason. The cast's result type IS its typeref's, cached here, so
    '' one resolved before its typedef leaves the call it is an argument of untyped:
    '' AfxNova's AfxSetWindowIcon returned 'ret void' from a pointer function.
    '' A PROCEDURE TYPE WHOSE RESULT NAMES A TYPEDEF DECLARED LATER, for the same
    '' reason and repaired the same way -- except that the type is INTERNED and
    '' already bound to variables by the time the name becomes known, so the
    '' backpatch mends the TYPE rather than re-deriving it. See BackpatchTypedefs.
    as FB.Array( of ulong )  pendProcType
    as FB.Array( of ulong )  pendProcTypeScope
    as FB.Array( of ulong )  pendProcTypeId
    as FB.Array( of ulong )  pendExprType
    as FB.Array( of ulong )  pendExprTypeScope
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
    '' THE INSTANTIATION CACHE for generic procedures, one entry each: the key and the
    '' symbol it produced. A SIDE table rather than a name lookup, because the key has
    '' to name the GENERIC as well as the arguments and the symbol's name must not --
    '' the name is what gets mangled, and fbc's is "MK<8>", not "MK#11<8>".
    as FB.Array( of ulong )  procInstKey
    as FB.Array( of ulong )  procInstSym
    '' WALKING A PARAMETER DEFAULT, which is written at the DECLARATION and evaluated at
    '' the call site -- not inside the procedure's body, though it is walked in the
    '' procedure's scope. A module-level local is visible to it, and fbc refuses it for a
    '' different reason (its error 272, TKO0640): see ModuleLocalHidden_.
    as boolean               inParamDefault
end type

'' The helpers the split shares. Their definitions stay in resolve.bas -- only the
'' names are published here.
declare function StmtOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
declare function ResolveTypeRef _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.TypeId
declare function ArrayFromBounds _
    ( byref c as Ctx, byval base_ as Tko.TypeId, byval first as long, _
      byval count as long, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_NONE ) as Tko.TypeId
declare sub WalkStmt _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )
declare function ListOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.ListPayload ptr
declare function IterElemType_ _
    ( byref c as Ctx, byval seqT as Tko.TypeId ) as Tko.TypeId
declare sub PendExprTypeRef_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )
'' LEN/SIZEOF/TYPEOF's leading 'NS.proc' is the proc's bare name -- resolveintr.bas.
declare sub DropNsPrefix_ _
    ( byref c as Ctx, byval opnd as Tko.NodeId, byval scope_ as Tko.ScopeId )
declare sub BindDeclType _
    ( byref c as Ctx, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval t as Tko.TypeId, byval force as boolean = false )
declare function InitCountAt _
    ( byref c as Ctx, byval init as Tko.NodeId, byval depth as long ) as long
declare function ArrayFromPairs _
    ( byref c as Ctx, byval base_ as Tko.TypeId, _
      byref los as FB.Array( of ulong ), byref his as FB.Array( of ulong ), _
      byval init as Tko.NodeId = Tko.NODE_NONE, _
      byval emptyIsDynamic as boolean = false, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_NONE ) as Tko.TypeId
declare function ArrayFromBoundsNode _
    ( byref c as Ctx, byval base_ as Tko.TypeId, byval id as Tko.NodeId, _
      byval init as Tko.NodeId = Tko.NODE_NONE, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_NONE ) as Tko.TypeId
declare function BindParamType_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId ) as Tko.TypeId
declare function ForwardTypedefTarget_ _
    ( byref c as Ctx, byval tsp as Tko.StmtPayload ptr, _
      byval here as Tko.ScopeId ) as Tko.TypeId
'' ONE PROCEDURE-TYPE PARAMETER'S TYPE, with the passing mode a procedure type gives
'' it. Shared with BackpatchTypedefs, which mends a parameter whose typedef came
'' later and has to arrive at exactly the answer the first pass would have.
declare function ProcTypeParamType_ _
    ( byref c as Ctx, byval prm as Tko.NodeId, _
      byval scope_ as Tko.ScopeId ) as Tko.TypeId

declare sub BackpatchTypedefs( byref c as Ctx )
declare function IdentNameOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.InternId
declare function InstantiateGenericProc_ _
    ( byref c as Ctx, byval callId as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.SymbolId
declare sub InstantiatePendingProcs_( byref c as Ctx )
declare function RewriteShadowedIntrinsic_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId ) as boolean
declare sub DiscoverInstantiations_ _
    ( byref c as Ctx, byref ast as Tko.AstArena, byval root as Tko.NodeId, _
      byref diags as Tko.DiagnosticEngine, byref info as Tko.SemanticInfo )
declare function QualifierPrefix_( byref c as Ctx, byval sc as Tko.ScopeId ) as string
declare function HasGenericDecl_( byref c as Ctx ) as boolean
declare sub WalkBlock_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )
'' Drain the deferred member instantiations.
declare sub InstantiatePending_( byref c as Ctx )
declare function InstantiateGeneric_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.StmtPayload ptr, _
      byval scope_ as Tko.ScopeId, byval gsid as Tko.SymbolId ) as Tko.TypeId

end namespace

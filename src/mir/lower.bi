'' lower.bi -- AST to MIR.
''
'' Lowering is the ONE place FreeBASIC's semantics are eliminated (docs/plan/09
'' section 1). Everything downstream sees a small closed instruction set.
''
'' THIS SLICE COVERS: procedures, scalar locals, integer and floating-point
'' expressions, assignment, IF / WHILE / DO / FOR, RETURN, and direct calls.
''
'' IT DOES NOT COVER, and these are the bulk of docs/plan/09 section 4: strings and
'' their runtime calls, arrays and descriptors, UDTs, constructors and destructors,
'' the cleanup model, SELECT CASE, GOTO and labels, error handling, properties,
'' virtual dispatch, and the whole ABI layer. Each of those needs either the runtime
'' declarations or the cleanup model, and neither exists yet.

#ifndef __FBX_MIR_LOWER_BI__
#define __FBX_MIR_LOWER_BI__

#include once "mir/mir.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "symbols/check.bi"
#include once "types/udtlayout.bi"
#include once "mir/rtl.bi"
#include once "diag/engine.bi"

namespace Fbx.Mir

    type LowerStats
        as long functions
        as long blocks
        as long insts
        as long skipped        '' statements this slice does not lower yet
        '' Non-zero means the label pre-scan disagreed with the depth actually open at
        '' the label. Always zero unless ScanLabels has drifted from the lowering.
        as long labelDepthMismatch
        as long scopeImbalance '' scopes opened and not closed -- always an ICE

        '' WHERE the unlowered statements are, by node kind, and for N_INTRINSIC by the
        '' keyword -- PRINT, INPUT, OPEN and the rest share one node kind, so a count
        '' against N_INTRINSIC alone says nothing about which to implement next.
        ''
        '' A single total invites guessing at what to do next; this makes the answer
        '' something to read off rather than argue about.
        as FB.Array( of long ) skippedKind
        as FB.Array( of ulong ) skippedIntrOp
        as FB.Array( of long ) skippedIntrN
    end type

    declare function Lower _
        ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
          byref names as Fbx.Interner, byref info as Fbx.SemanticInfo, _
          byref src as Fbx.SourceManager, byref udts as Fbx.UdtLayouts, _
          byref m as MirModule, byref st as LowerStats ) as long

end namespace

#endif

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
        '' Blocks that had NO TERMINATOR and were given a fallthrough. Always the
        '' downstream mark of a decline: a label block whose statement never lowered.
        as long blocksRepaired

        '' WHERE the unlowered statements are, by node kind, and for N_INTRINSIC by the
        '' keyword -- PRINT, INPUT, OPEN and the rest share one node kind, so a count
        '' against N_INTRINSIC alone says nothing about which to implement next.
        ''
        '' A single total invites guessing at what to do next; this makes the answer
        '' something to read off rather than argue about.
        as FB.Array( of long ) skippedKind
        as FB.Array( of ulong ) skippedIntrOp
        as FB.Array( of long ) skippedIntrN

        '' Declines that happened INSIDE a statement rather than at the dispatch, by the
        '' kind of statement they were inside. This is where the mass is: the dispatch
        '' breakdown accounts for about 3,700 of ~98,700.
        as FB.Array( of long ) innerKind

        '' WHY an N_AMBIGUOUS statement declined. That one bucket is 90% of the total, so
        '' a count against it says only "look here"; this says what to look at. The
        '' callee NAMES are collected for the unresolved case, because the answer to
        '' "what is missing" has twice turned out to be a short list of names rather than
        '' a missing feature.
        as long ambCallUnbound      '' a call whose callee bound to no symbol
        as long ambCallNoCode       '' callee bound, and still nothing was emitted
        as long ambAssign           '' an assignment that did not lower
        as long ambResultNoSlot     '' 'function = expr' whose result type has no slot
        as long varByref            '' 'dim byref' -- a reference variable, not lowered
        as long ambOther            '' property-set, result-assign, unclassified
        '' ... by the SHAPE of the thing that was not a call, and by the AmbiguousOf
        '' classification when there was no expression to look at. 'other' has been the
        '' second-largest bucket for four commits without anyone knowing what is in it.
        as FB.Array( of long ) ambOtherShape
        as FB.Array( of long ) ambOtherClass
        as FB.Array( of ulong ) ambUnboundNames
        '' ... and by the SHAPE of the callee, because only a plain identifier has a
        '' name to collect and most of them are not one.
        as FB.Array( of long ) ambUnboundShape
        '' For a member callee: the MEMBER's own name, and whether the BASE had a type
        '' at all. The two are different problems -- a member that could not be found on
        '' a type it was looked up in, against a base that was never typed so nothing
        '' could be looked up -- and one list cannot tell them apart.
        as FB.Array( of ulong ) ambMemberNames
        as long ambMemberBaseTyped
        as long ambMemberBaseUntyped

        '' Every decline, by the SITE that recorded it. The bucket breakdown says which
        '' STATEMENT a decline was inside; this says which line of the lowering gave up,
        '' which is the thing you can actually go and implement. Roughly twenty sites, so
        '' a linear scan is cheaper than a map and keeps the order stable.
        as FB.Array( of ulong ) skipSiteFile   '' InternId of the file name
        as FB.Array( of long )  skipSiteLine
        as FB.Array( of long )  skipSiteN
    end type

    declare function Lower _
        ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
          byref names as Fbx.Interner, byref info as Fbx.SemanticInfo, _
          byref src as Fbx.SourceManager, byref udts as Fbx.UdtLayouts, _
          byref m as MirModule, byref st as LowerStats ) as long

end namespace

#endif

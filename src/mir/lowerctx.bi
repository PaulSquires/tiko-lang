'' lowerctx.bi -- the state MIR lowering threads through itself.
''
'' Private to src/mir: it exists because lowering outgrew one file (build/lint.sh caps
'' a source at 1500 lines), and splitting it means the context has to be shared rather
'' than file-local.

#ifndef __FBX_LOWERCTX_BI__
#define __FBX_LOWERCTX_BI__

#include once "mir/lower.bi"
#include once "symbols/mangle.bi"

namespace Fbx.Mir

type Ctx
    as Fbx.AstArena ptr     ast
    as Fbx.SymbolTable ptr  syms
    as Fbx.TypeContext ptr  types
    as Fbx.Interner ptr     names
    as Fbx.SemanticInfo ptr info
    as MirModule ptr        m
    as MirFunction ptr      f
    as LowerStats ptr       st
    as long                 curBlock
    '' The innermost loop's exit and continue targets, for EXIT and CONTINUE. A stack
    '' rather than a pair, because the statements take a level count.
    as FB.Array( of long )  breakTo
    as FB.Array( of long )  contTo
    as Fbx.SourceManager ptr srcMgr    '' only for the constant evaluator
    as Fbx.UdtLayouts ptr   udts      '' field offsets, for member access
    '' THE CLEANUP MODEL (docs/plan/08 section 6).
    ''
    '' One flat list of actions, plus a stack of marks giving where each open scope's
    '' actions begin. Actions run in REVERSE REGISTRATION ORDER, and locals and
    '' DEFERs share the one list -- which is what makes the measured fbc order fall
    '' out rather than needing to be arranged. Measured: a local 'a' declared before
    '' two defers is destroyed AFTER both of them run, newest defer first.
    '' Two action kinds share ONE list, because the ORDER is one order: a local
    '' declared before two defers is destroyed after both run (measured), which only
    '' falls out if they are interleaved rather than kept apart.
    ''   RunDefer      cleanupNode = the statement,   cleanupSlot = -1
    ''   DestroyLocal  cleanupNode = the dtor symbol,  cleanupSlot = the slot
    ''   DeleteString  cleanupNode = 0,                cleanupSlot = the slot
    as FB.Array( of ulong ) cleanupNode
    as FB.Array( of long )  cleanupSlot
    as FB.Array( of long )  scopeMark      '' index into cleanupNode per open scope
    '' The scope depth each open loop started at, so EXIT and CONTINUE know how many
    '' scopes they are leaving.
    as FB.Array( of long )  loopScope
end type

declare function Emit( byref c as Ctx, byref ins as MirInst ) as MirValue
declare function NoVal( ) as MirValue
declare function LowerExpr( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
declare function LowerAddr( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
declare sub LowerStmt( byref c as Ctx, byval id as Fbx.NodeId )
declare function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
declare function SameLValue _
    ( byref c as Ctx, byval a as Fbx.NodeId, byval b as Fbx.NodeId ) as boolean
declare function IsStringType( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
declare function LowerStringAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean
declare function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue

end namespace

#endif

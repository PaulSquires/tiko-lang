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

    '' The procedure being lowered, as a SYMBOL. MirFunction carries only the mangled
    '' name, and __FUNCTION__ needs the source one -- 'NS.INNER', not '_ZN2NS5INNEREv'.
    as Fbx.SymbolId         curProcSym

    '' The statement kind currently being lowered, so a decline INSIDE one can say which.
    '' The statement-dispatch breakdown accounts for about 3,700 of ~98,700 declines; the
    '' rest happen part-way through a statement and had no attribution at all.
    as ushort               curStmtKind

    '' DIM SHARED / STATIC storage, keyed by SYMBOL rather than by name. Two statics
    '' called 'n' in sibling scopes are two declarations and so two symbols; keying on
    '' the spelling merged them into one variable.
    as FB.Array( of ulong ) gvarSym
    as FB.Array( of long )  gvarSlot

    '' Labels, three parallel arrays. The DEPTH is filled by a pre-scan before the body
    '' is lowered, because a forward 'goto' has to know how many scopes it leaves before
    '' the label itself has been reached.
    as FB.Array( of ulong ) labelName
    as FB.Array( of long )  labelBlock     '' -1 until the block is created
    as FB.Array( of long )  labelDepth     '' -1 when the pre-scan never saw it
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
declare function NewTempLocal _
    ( byref c as Ctx, byval ty as MirType, byval sizeBytes as long ) as long
declare function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue


    '' lowerctl.bas -- control flow.
    declare sub LowerSelect( byref c as Ctx, byval id as Fbx.NodeId )
    declare sub LowerEndStmt( byref c as Ctx, byval id as Fbx.NodeId )
    declare sub LowerLabel( byref c as Ctx, byval id as Fbx.NodeId )
    declare sub LowerGoto( byref c as Ctx, byval id as Fbx.NodeId )
    declare sub ScanLabels _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval depth as long )


    '' lower.bas -- shared by the other lowering files.
    declare function NewBlock( byref c as Ctx, byref label as string ) as long
    declare sub Terminate _
        ( byref c as Ctx, byval k as MirTermKind, byval t1 as long, _
          byval t2 as long, byref cond as MirValue )
    declare function IsUnsignedType _
        ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    declare sub PushScope( byref c as Ctx )
    declare sub CloseScope( byref c as Ctx )
    declare sub EmitCleanupsTo( byref c as Ctx, byval outermost as long )
    declare function LowerExprLoad _
        ( byref c as Ctx, byref addr as MirValue, byval t as MirType ) as MirValue
    declare function Coerce _
        ( byref c as Ctx, byref v as MirValue, byval want as MirType ) as MirValue
    declare function BinOpFor _
        ( byval tk as Fbx.TokenKind, byval t as MirType, _
          byval isUnsigned as boolean ) as MirOp
    declare sub LowerBlock( byref c as Ctx, byval id as Fbx.NodeId )

    declare sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    declare function LowerStringInit _
        ( byref c as Ctx, byval slot as long, byval target as Fbx.NodeId, _
          byval value as Fbx.NodeId ) as boolean

    '' lowerstore.bas -- frame slot vs module storage.
    declare function LocalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    declare function IsSharedVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    declare function IsStaticLocal( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    declare function GlobalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    declare function AddrOfVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as MirValue

    declare function LowerPrint( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerSwap( byref c as Ctx, byval id as Fbx.NodeId ) as boolean

    declare function LowerStrCompare _
        ( byref c as Ctx, byval bp as Fbx.BinaryPayload ptr, _
          byval tk as Fbx.TokenKind ) as MirValue

    '' lowerarr.bas -- array indexing.
    declare function IsArrayIndex( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerArrayIndex( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
    declare function ConstFloat _
        ( byref c as Ctx, byval v as double, byval t as MirType ) as MirValue
    declare function IsFloatTy( byval t as MirType ) as boolean
    '' The conversion intrinsics -- CBYTE, CBOOL, CAST, CPTR and the rest.
    declare function IsConvIntrinsic _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerConvIntrinsic _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue

    declare function ConstInt _
        ( byref c as Ctx, byval v as longint, byval t as MirType ) as MirValue

    '' The address of a string literal's bytes, as a module global.
    declare function LowerStringLitAddr _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
    declare function LowerTextAddr _
        ( byref c as Ctx, byref text as string ) as MirValue
    '' A DIM SHARED / STATIC initialiser: a compile-time value, not a store on entry.
    declare sub InitSharedGlobal _
        ( byref c as Ctx, byval sid as Fbx.SymbolId, byval init as Fbx.NodeId )

    '' TRUE, FALSE and __FUNCTION__: predeclared names that are values, not storage.
    declare function LowerPredeclared _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    '' A string literal's text, with the escapes already resolved.
    declare function StringLitText_ _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as string

    '' Records a decline part-way through the statement being lowered.
    declare sub SkipHere( byref c as Ctx )
    declare sub SkipStmt( byref c as Ctx, byval id as Fbx.NodeId )

end namespace

#endif

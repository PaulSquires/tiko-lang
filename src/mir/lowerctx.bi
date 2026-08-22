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
    '' The CONSTRUCT KIND behind each breakTo entry -- KW_FOR, KW_DO, KW_WHILE,
    '' KW_SELECT or KW_SCOPE. Without it 'exit for, for' broke ONE level instead of
    '' two, silently, and 'exit select' had nothing to match against.
    as FB.Array( of long )  loopKind
    '' Slots holding string temporaries whose life ends with the current STATEMENT.
    as FB.Array( of ulong ) strTemps
    '' DATA. The head of the module's block chain (-1 when it has none), and the
    '' label -> block map a 'restore lbl' resolves through. Both are built by a
    '' PRE-PASS, because 'restore lbl' may name a label that appears later.
    '' The current procedure's HIDDEN RESULT POINTER, when it has one: parameter 0,
    '' holding the caller's storage. -1 when the result is not returned that way.
    '' Whether the current procedure returns a TRIVIAL UDT by value, in which case the
    '' result slot holds the object itself and 'ret' carries its VALUE.
    as boolean              udtResult
    as long                 sretParam
    as long                 dataHead
    as FB.Array( of ulong ) dataLabelName
    as FB.Array( of ulong ) dataLabelBlock

    '' The procedure being lowered, as a SYMBOL. MirFunction carries only the mangled
    '' name, and __FUNCTION__ needs the source one -- 'NS.INNER', not '_ZN2NS5INNEREv'.
    as Fbx.SymbolId         curProcSym

    '' The result slot of the procedure being lowered, or -1 for a SUB and for any
    '' result type this does not handle. Measured from fbc's own C:
    ''
    ''     int64 F( int64 N$1 ) {
    ''         int64 fb$result$1;
    ''         __builtin_memset( &fb$result$1, 0, 8ll );
    ''         fb$result$1 = 7ll;             <- 'function = 7'
    ''         return fb$result$1;            <- falling off the end
    ''     }
    ''
    '' Zero-initialised and returned unconditionally, so a function that assigns
    '' nothing returns zero rather than whatever the stack held.
    as long                 resultSlot
    as ubyte                resultTy
    as Fbx.TypeId           resultType

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
    declare sub LowerExitLike _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval isExit as boolean )
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
    declare function LoadResult( byref c as Ctx ) as MirValue
    '' lowerproc.bas -- the two procedure lowerings.
    declare sub LowerProc( byref c as Ctx, byval id as Fbx.NodeId )
    declare sub LowerMainModule( byref c as Ctx, byval root as Fbx.NodeId )
    declare function ZeroOf( byref c as Ctx, byval t as MirType ) as MirValue
    '' 'srcUnsigned' is the SOURCE's signedness, which a MirType cannot carry: MT_I32
    '' says 32 bits and nothing about how to widen them. Without it a ULONG widened to
    '' a LONGINT sign-extended -- 4,000,000,000 became -294,967,296 -- and a ULONGINT
    '' converted to a DOUBLE went through sitofp and came out -1. Both measured by
    '' running fbc, which prints 4000000000 and 1.844674407370955e+019.
    declare function Coerce _
        ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
          byval srcUnsigned as boolean = false ) as MirValue
    declare function BinOpFor _
        ( byval tk as Fbx.TokenKind, byval t as MirType, _
          byval isUnsigned as boolean ) as MirOp
    declare sub LowerBlock( byref c as Ctx, byval id as Fbx.NodeId )

    declare sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    '' The (pointer, length) pair for one term of a concatenation, appended to 'args'.
    declare function EmitStrTerm _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), _
          byval term as Fbx.NodeId ) as boolean
    '' Flatten a left-leaning '+'/'&' chain into its terms, in source order.
    declare sub FlattenConcat _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )
    declare function LowerStringInit _
        ( byref c as Ctx, byval slot as long, byval target as Fbx.NodeId, _
          byval value as Fbx.NodeId ) as boolean

    '' lowerstore.bas -- frame slot vs module storage.
    declare function LocalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    declare function IsSharedVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    declare function IsStaticLocal( byref c as Ctx, byval sid as Fbx.SymbolId ) as boolean
    declare function GlobalFor( byref c as Ctx, byval sid as Fbx.SymbolId ) as long
    declare function AddrOfVar( byref c as Ctx, byval sid as Fbx.SymbolId ) as MirValue
    declare function AddrOfThisField _
        ( byref c as Ctx, byval fsid as Fbx.SymbolId ) as MirValue

    declare function LowerPrint( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    '' lowerio.bas
    declare function LowerWrite( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerPoke( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerLrset _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval isRight as boolean ) as boolean
    '' lowerusing.bas
    declare function LowerPrintUsing( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    '' lowerdesc.bas
    declare function SynthFixedArrayDesc _
        ( byref c as Ctx, byref arrAddr as MirValue, byval t as Fbx.TypeId, _
          byref outv as MirValue ) as boolean
    '' Whether a UDT return travels through an explicit hidden pointer. Measured:
    '' the type has a DESTRUCTOR or a COPY CONSTRUCTOR. Size plays no part.
    declare function UsesSretReturn( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    declare function LowerErase( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function SizeOfType( byref c as Ctx, byval t as Fbx.TypeId ) as long
    '' A cleanup entry that is neither a symbol nor the string-delete 0: erase the
    '' dynamic array in this slot. Deliberately an impossible SymbolId.
    const CLEANUP_ERASE_ARRAY as ulong = &hFFFFFFFF

    declare function DescBytesFor( byref c as Ctx, byval rank as long ) as long
    declare sub EmitEraseDynLocal( byref c as Ctx, byval slot as long )
    declare function PickCtor _
        ( byref c as Ctx, byval ctors as Fbx.SymbolId, _
          byref argT as FB.Array( of ulong ) ) as Fbx.SymbolId
    '' lowerctor.bas
    declare function LowerCtorInit _
        ( byref c as Ctx, byval slot as long, byval t as Fbx.TypeId, _
          byval init_ as Fbx.NodeId ) as boolean
    declare function LowerDynArrayIndex _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.ListPayload ptr, _
          byval at as Fbx.TypeId ) as MirValue
    declare function LowerArrayBoundCall _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    '' lowerdata.bas
    declare function CollectDataBlocks( byref c as Ctx, byval root as Fbx.NodeId ) as long
    declare function LowerRead( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerRestore( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare sub EmitImplicitRestore( byref c as Ctx )
    declare function LowerRedim _
        ( byref c as Ctx, byval id as Fbx.NodeId, _
          byval sp as Fbx.StmtPayload ptr ) as boolean
    declare sub InitDynArrayDesc _
        ( byref c as Ctx, byref desc as MirValue, byval t as Fbx.TypeId )
    declare function DynArrayDataPtr _
        ( byref c as Ctx, byref desc as MirValue ) as MirValue
    declare function FuncAddrOf( byref c as Ctx, byval fsid as Fbx.SymbolId ) as MirValue
    declare function UsingEndsLine_ _
        ( byref c as Ctx, byval sp as Fbx.StmtPayload ptr ) as boolean
    declare function LowerPrintPos _
        ( byref c as Ctx, byval it as Fbx.NodeId, byref chan as MirValue ) as boolean
    declare sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
    declare function LowerSwap( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerLineInput( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function WideStringElems( byref c as Ctx, byval t as Fbx.TypeId ) as long
    declare function LowerForEachArray( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerForEachIter _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr, _
          byval seqE as Fbx.NodeId, byval at as Fbx.TypeId ) as boolean
    declare function EmitMemberCall _
        ( byref c as Ctx, byval sym as Fbx.SymbolId, byref self_ as MirValue, _
          byval rt as MirType ) as MirValue
    '' lowerfor.bas
    declare sub LowerFor( byref c as Ctx, byval id as Fbx.NodeId )
    declare sub LowerDo( byref c as Ctx, byval id as Fbx.NodeId )
    declare function LowerStringReturn( byref c as Ctx, byval valueE as Fbx.NodeId ) as boolean
    declare function LowerSretResult _
        ( byref c as Ctx, byval valueE as Fbx.NodeId ) as boolean
    declare function LowerStringAssignToSlot _
        ( byref c as Ctx, byval slot as long, byval value as Fbx.NodeId ) as boolean
    declare function LowerStringAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval target as Fbx.NodeId, _
          byval value as Fbx.NodeId ) as boolean
    declare function LowerInput _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval isLine as boolean ) as boolean
    declare function LowerWideConcatAssign _
        ( byref c as Ctx, byval target as Fbx.NodeId, byval n as long, _
          byval value as Fbx.NodeId ) as boolean
    declare function LowerWstrOf _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerLen _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideAssign _
        ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean
    declare function LowerWideToNarrow _
        ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean
    declare function IsStringIif_( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function IsAggIif_( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerAggIif_ _
        ( byref c as Ctx, byval condE as Fbx.NodeId, byval thenE as Fbx.NodeId, _
          byval elseE as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare sub StoreThrough _
        ( byref c as Ctx, byref addr as MirValue, byref val as MirValue )
    declare function LowerZstrAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as longint, _
          byval value as Fbx.NodeId, byval isInit as boolean ) as boolean
    declare function LowerStrRvalue _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerMathCall_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function UserCastToStr_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue, _
          byref raw as boolean ) as boolean
    declare function LowerStrOf_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerStrNumCall_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerRadixCall_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function StrDescriptorOf_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function IifArmType_( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId
    declare function WideOperand_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideRvalue _
        ( byref c as Ctx, byval value as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as long, _
          byval value as Fbx.NodeId ) as boolean
    declare function LowerWideConcatAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as long, _
          byval value as Fbx.NodeId ) as boolean
    '' lowerintr.bas
    declare function LowerClose( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerError( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerDelete( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    declare function LowerBuiltinProc _
        ( byref c as Ctx, byval calleeNode as Fbx.NodeId, byval argFirst as long, _
          byval argCount as long, byref outv as MirValue ) as boolean
    declare function LowerProcPtr _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerArrayInit _
        ( byref c as Ctx, byval slot as long, byval t as Fbx.TypeId, _
          byval init as Fbx.NodeId ) as boolean
    declare function LowerStringIif_ _
        ( byref c as Ctx, byval condE as Fbx.NodeId, byval thenE as Fbx.NodeId, _
          byval elseE as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function StrInitFrom_ _
        ( byref c as Ctx, byref dst as MirValue, byval e as Fbx.NodeId ) as boolean
    '' An 'iif' call and its three arms, WITHOUT asking what the arms are. Used where
    '' the context already knows the result is a string -- a term of a string
    '' assignment, an arm of another string iif -- because the arm types cannot answer
    '' it: Check computes no type for an intrinsic call, so 'iif( c, hex( 1 ),
    '' hex( 2 ) )' looks like an iif over nothing.
    declare function IsIifCall_ _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref condE as Fbx.NodeId, _
          byref thenE as Fbx.NodeId, byref elseE as Fbx.NodeId ) as boolean
    declare function LowerIif _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType, _
          byref outv as MirValue ) as boolean
    declare function LowerBitfieldRead _
        ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean
    declare function LowerBitfieldStore _
        ( byref c as Ctx, byval id as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean
    declare function LowerCompoundAssign _
        ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId, _
          byval op as Fbx.TokenKind ) as boolean
    declare function ParamIsByref _
        ( byref c as Ctx, byval callee as Fbx.SymbolId, byval idx as long ) as boolean

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
    '' Constructors and destructors: finding them, and calling one on a slot.
    declare function StructorOf _
        ( byref c as Ctx, byval t as Fbx.TypeId, byref which as string ) as Fbx.SymbolId
    declare function StructorWithArity _
        ( byref c as Ctx, byval first_ as Fbx.SymbolId, byval want as long ) as Fbx.SymbolId
    '' 'slot' is a LOCAL whose address is the receiver. A NEGATIVE slot means the
    '' receiver is already a value and comes through 'selfVal' -- which is what DELETE
    '' has: a pointer, not a local.
    declare sub EmitStructorCall _
        ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long, _
          byval selfVal as MirValue ptr = 0 )
    declare sub EmitCtorCall _
        ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long )
    declare sub EmitDtorCall _
        ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long )

    '' A call from its PIECES, so both of FreeBASIC's spellings reach one place.
    declare function LowerCallParts _
        ( byref c as Ctx, byval calleeNode as Fbx.NodeId, byval callee as Fbx.SymbolId, _
          byval argFirst as long, byval argCount as long, _
          byval mt as MirType ) as MirValue

    '' The paren-less call statement: 'W 1, 2'.
    declare function LowerStmtCall _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    '' The implicit THIS for 'obj.M( )' / 'p->M( )', or MV_NONE when there is none.
    declare function ReceiverOf _
        ( byref c as Ctx, byval target as Fbx.NodeId, _
          byval callee as Fbx.SymbolId ) as MirValue

    '' A DIM SHARED / STATIC initialiser: a compile-time value, not a store on entry.
    declare sub InitSharedGlobal _
        ( byref c as Ctx, byval sid as Fbx.SymbolId, byval init as Fbx.NodeId )

    '' TRUE, FALSE and __FUNCTION__: predeclared names that are values, not storage.
    declare function LowerPredeclared _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    '' A string literal's text, with the escapes already resolved.
    declare function StringLitText_ _
        ( byref c as Ctx, byval id as Fbx.NodeId ) as string

    '' Which half of a declined call statement is at fault, and the callee's name.
    declare sub CountUnlowredCall( byref c as Ctx, byval call_ as Fbx.NodeId )

    '' Records a decline part-way through the statement being lowered.
    ''
    '' A MACRO, so the call SITE is captured rather than this file's own line. Twenty
    '' places give up on a statement and the totals alone cannot tell them apart; with
    '' the site, "what is not lowered" is a list of lines to go and read.
    declare sub SkipAt _
        ( byref c as Ctx, byref fileName as string, byval lineNo as long )
    #define SkipHere( c__ ) SkipAt( (c__), __FILE__, __LINE__ )
    declare sub SkipStmt( byref c as Ctx, byval id as Fbx.NodeId )

end namespace

#endif

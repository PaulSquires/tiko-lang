'' lowerctx.bi -- the state MIR lowering threads through itself.
''
'' Private to src/mir: it exists because lowering outgrew one file (build/lint.sh caps
'' a source at 1500 lines), and splitting it means the context has to be shared rather
'' than file-local.

#ifndef __TKO_LOWERCTX_BI__
#define __TKO_LOWERCTX_BI__

#include once "mir/lower.bi"
#include once "symbols/mangle.bi"

namespace Tko.Mir

type Ctx
    as Tko.AstArena ptr     ast
    as Tko.SymbolTable ptr  syms
    as Tko.TypeContext ptr  types
    as Tko.Interner ptr     names
    as Tko.SemanticInfo ptr info
    as MirModule ptr        m
    as MirFunction ptr      f
    as LowerStats ptr       st
    as long                 curBlock
    '' The innermost loop's exit and continue targets, for EXIT and CONTINUE. A stack
    '' rather than a pair, because the statements take a level count.
    as FB.Array( of long )  breakTo
    as FB.Array( of long )  contTo
    as Tko.SourceManager ptr srcMgr    '' only for the constant evaluator
    as Tko.UdtLayouts ptr   udts      '' field offsets, for member access
    '' THE SYNTHESISED STRUCTORS THIS UNIT ACTUALLY ASKED FOR. fbc emits one only
    '' where something calls it -- a file declaring a type and never a variable of it
    '' gets no constructor at all -- so the demand is recorded as calls are emitted and
    '' the bodies follow, rather than one per type whether used or not.
    as FB.Array( of ulong ) implWantedType
    as FB.Array( of long )  implWantedKind    '' 1 constructor, 0 destructor
    '' MODULE-LIFETIME OBJECTS THAT NEED CONSTRUCTING. fbc emits a _GLOBAL__I and a
    '' _GLOBAL__D carrying GCC's constructor/destructor attributes, and runs the
    '' globals in DECLARATION order in the first and in exact reverse in the second.
    '' Recorded as declarations are seen, so the order is the source's.
    as FB.Array( of long )  modInitGlobal
    as FB.Array( of ulong ) modInitType
    '' The virtual method tables, for emitting them and for dispatching through one.
    as Tko.VTables ptr      vts
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
    ''   ImplicitDtor  cleanupNode = CLEANUP_IMPLICIT_DTOR, cleanupType = the type
    '' A fourth action, and the only one that needs a THIRD column: the structor it
    '' runs has no symbol -- fbc synthesised it and so does tiko-lang -- so the entry names
    '' the TYPE and the name is derived from that.
    as FB.Array( of ulong ) cleanupType
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
    '' The same, for WIDE temporaries -- a separate list because they are released
    '' differently: a wide temporary slot holds a POINTER to an allocation, so its
    '' release is fb_WstrDelete on the pointer LOADED from the slot, where a narrow one
    '' is fb_StrDelete on the descriptor's own address.
    as FB.Array( of ulong ) wstrTemps
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
    as Tko.SymbolId         curProcSym

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
    as Tko.TypeId           resultType

    '' The statement kind currently being lowered, so a decline INSIDE one can say which.
    '' The statement-dispatch breakdown accounts for about 3,700 of ~98,700 declines; the
    '' rest happen part-way through a statement and had no attribution at all.
    as ushort               curStmtKind
    '' The statement being lowered, so a decline can name the SOURCE LINE it came
    '' from. Bucketing by the diagnostic hides what bucketing by the line shows.
    as ulong                curStmtNode
    '' The sub-expression to BLAME for the next decline, when something narrower than
    '' the statement is known to be at fault. A statement written inside a MACRO reports
    '' the macro's own line, so 'CU_ASSERT( x )' attributed every failure in the corpus
    '' to one line of fbcunit.bi; the ARGUMENT's tokens come from the INVOCATION and
    '' point where the work actually is. Cleared as it is consumed.
    as ulong                blameNode

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
declare function LowerExpr( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
declare function LowerAddr( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
declare sub LowerStmt( byref c as Ctx, byval id as Tko.NodeId )
declare function StmtOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
declare function SameLValue _
    ( byref c as Ctx, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
declare function IsStringType( byref c as Ctx, byval t as Tko.TypeId ) as boolean
declare function LowerStringAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
declare function NewTempLocal _
    ( byref c as Ctx, byval ty as MirType, byval sizeBytes as long ) as long
declare function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue


    '' lowerctl.bas -- control flow.
    declare sub LowerSelect( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerExitLike _
        ( byref c as Ctx, byval id as Tko.NodeId, byval isExit as boolean )
    declare sub LowerEndStmt( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerLabel( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerGoto( byref c as Ctx, byval id as Tko.NodeId )
    declare sub ScanLabels _
        ( byref c as Ctx, byval id as Tko.NodeId, byval depth as long )


    '' lower.bas -- shared by the other lowering files.
    declare function NewBlock( byref c as Ctx, byref label as string ) as long
    declare sub Terminate _
        ( byref c as Ctx, byval k as MirTermKind, byval t1 as long, _
          byval t2 as long, byref cond as MirValue )
    declare function IsUnsignedType _
        ( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare sub PushScope( byref c as Ctx )
    declare sub CloseScope( byref c as Ctx )
    declare sub EmitCleanupsTo( byref c as Ctx, byval outermost as long )
    declare function LowerExprLoad _
        ( byref c as Ctx, byref addr as MirValue, byval t as MirType ) as MirValue
    declare function LoadResult( byref c as Ctx ) as MirValue
    '' lowerproc.bas -- the two procedure lowerings.
    declare sub LowerProc( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerMainModule( byref c as Ctx, byval root as Tko.NodeId )
    declare function ZeroOf( byref c as Ctx, byval t as MirType ) as MirValue
    '' 'srcUnsigned' is the SOURCE's signedness, which a MirType cannot carry: MT_I32
    '' says 32 bits and nothing about how to widen them. Without it a ULONG widened to
    '' a LONGINT sign-extended -- 4,000,000,000 became -294,967,296 -- and a ULONGINT
    '' converted to a DOUBLE went through sitofp and came out -1. Both measured by
    '' running fbc, which prints 4000000000 and 1.844674407370955e+019.
    declare function Coerce _
        ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
          byval srcUnsigned as boolean = false ) as MirValue
    declare function EmitImpEqv_ _
        ( byref c as Ctx, byval tk as Tko.TokenKind, byval ty as MirType, _
          byref l as MirValue, byref r as MirValue ) as MirValue
    declare function BinOpFor _
        ( byval tk as Tko.TokenKind, byval t as MirType, _
          byval isUnsigned as boolean ) as MirOp
    declare sub LowerBlock( byref c as Ctx, byval id as Tko.NodeId )

    declare sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    '' The (pointer, length) pair for one term of a concatenation, appended to 'args'.
    declare function EmitStrTerm _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), _
          byval term as Tko.NodeId ) as boolean
    '' Flatten a left-leaning '+'/'&' chain into its terms, in source order.
    declare sub FlattenConcat _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outp as FB.Array( of ulong ) )
    declare function LowerStringInit _
        ( byref c as Ctx, byval slot as long, byval target as Tko.NodeId, _
          byval value as Tko.NodeId ) as boolean

    '' lowerstore.bas -- frame slot vs module storage.
    declare function LocalFor( byref c as Ctx, byval sid as Tko.SymbolId ) as long
    declare function IsSharedVar( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean
    declare function IsStaticLocal( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean
    declare function GlobalFor( byref c as Ctx, byval sid as Tko.SymbolId ) as long
    declare function BindAliasStorage _
        ( byref c as Ctx, byval sid as Tko.SymbolId, byval init_ as Tko.NodeId, _
          byval inModule as boolean ) as boolean
    declare function AddrOfVar( byref c as Ctx, byval sid as Tko.SymbolId ) as MirValue
    declare function AddrOfThisField _
        ( byref c as Ctx, byval fsid as Tko.SymbolId ) as MirValue
    declare function LowerBaseCtorCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId ) as boolean

    declare function LowerPrint( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    '' lowerio.bas
    declare function LowerWrite( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerPoke( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerLrset _
        ( byref c as Ctx, byval id as Tko.NodeId, byval isRight as boolean ) as boolean
    '' lowerusing.bas
    declare function LowerPrintUsing( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    '' lowerdesc.bas
    declare function SynthFixedArrayDesc _
        ( byref c as Ctx, byref arrAddr as MirValue, byval t as Tko.TypeId, _
          byref outv as MirValue ) as boolean
    '' Whether a UDT return travels through an explicit hidden pointer. Measured:
    '' the type has a DESTRUCTOR or a COPY CONSTRUCTOR. Size plays no part.
    declare function UsesSretReturn( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function LowerErase( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function SizeOfType( byref c as Ctx, byval t as Tko.TypeId ) as long
    '' A cleanup entry that is neither a symbol nor the string-delete 0: erase the
    '' dynamic array in this slot. Deliberately an impossible SymbolId.
    const CLEANUP_ERASE_ARRAY as ulong = &hFFFFFFFF
    const CLEANUP_IMPLICIT_DTOR as ulong = &hFFFFFFFE
    const CLEANUP_DESTROY_ARRAY as ulong = &hFFFFFFFD
    const CLEANUP_DTOR_EPILOGUE as ulong = &hFFFFFFFC

    declare function DescBytesFor( byref c as Ctx, byval rank as long ) as long
    declare sub EmitEraseDynLocal( byref c as Ctx, byval slot as long )
    '' The same for a descriptor whose ADDRESS is in hand -- 'erase this.items', where
    '' the descriptor is a FIELD and has no slot of its own.
    declare sub EmitEraseDynAt_ _
        ( byref c as Ctx, byref d as MirValue, byval t as Tko.TypeId )
    declare function PickCtor _
        ( byref c as Ctx, byval ctors as Tko.SymbolId, _
          byref argT as FB.Array( of ulong ) ) as Tko.SymbolId
    '' lowerctor.bas
    declare function LowerConvCtorInit_ _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init_ as Tko.NodeId ) as boolean
    declare function LowerCtorInit _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init_ as Tko.NodeId ) as boolean
    declare function LowerDynArrayIndex _
        ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.ListPayload ptr, _
          byval at as Tko.TypeId ) as MirValue
    declare function LowerArrayBoundCall _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    '' lowerdata.bas
    declare function CollectDataBlocks( byref c as Ctx, byval root as Tko.NodeId ) as long
    declare function LowerRead( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerRestore( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare sub EmitImplicitRestore( byref c as Ctx )
    declare function LowerRedim _
        ( byref c as Ctx, byval id as Tko.NodeId, _
          byval sp as Tko.StmtPayload ptr ) as boolean
    declare sub InitDynArrayDesc _
        ( byref c as Ctx, byref desc as MirValue, byval t as Tko.TypeId )
    declare function DynArrayDataPtr _
        ( byref c as Ctx, byref desc as MirValue ) as MirValue
    declare function FuncAddrOf( byref c as Ctx, byval fsid as Tko.SymbolId ) as MirValue
    declare function FuncAddrOfRtl( byref c as Ctx, byval r as RtlId ) as MirValue
    declare function UsingEndsLine_ _
        ( byref c as Ctx, byval sp as Tko.StmtPayload ptr ) as boolean
    declare function LowerPrintPos _
        ( byref c as Ctx, byval it as Tko.NodeId, byref chan as MirValue ) as boolean
    declare sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
    declare function LowerSwap( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerLineInput( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function WideStringElems( byref c as Ctx, byval t as Tko.TypeId ) as long
    declare function LowerForEachArray( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerForEachIter _
        ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.StmtPayload ptr, _
          byval seqE as Tko.NodeId, byval at as Tko.TypeId ) as boolean
    declare function EmitDirectCall_ _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byval rt as MirType, _
          byref args as FB.Array( of ulong ) ) as MirValue
    declare function EmitMemberCallArgs_ _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
          byval rt as MirType, byval args as FB.Array( of ulong ) ptr ) as MirValue
    declare function UdtMemberNamed_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId
    declare function EmitMemberCall _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
          byval rt as MirType ) as MirValue
    '' lowerfor.bas
    declare sub LowerFor( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerDo( byref c as Ctx, byval id as Tko.NodeId )
    declare function LowerStringReturn( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    declare function LowerSretResult _
        ( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
    declare function LowerStringAssignToSlot _
        ( byref c as Ctx, byval slot as long, byval value as Tko.NodeId ) as boolean
    declare function LowerStringAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval target as Tko.NodeId, _
          byval value as Tko.NodeId ) as boolean
    declare function LowerInput _
        ( byref c as Ctx, byval id as Tko.NodeId, byval isLine as boolean ) as boolean
    declare function Unparen_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.NodeId
    declare function ConcatTermsToTempDesc_ _
        ( byref c as Ctx, byref terms as FB.Array( of ulong ), _
          byref outv as MirValue ) as boolean
    declare function ConcatToTempDesc_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function ConcatHasWideTerm_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    declare function TermIsWide_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    declare function WideCastOverload_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    declare function WideToNarrowTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function NarrowToWideTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function IsWstrCall_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function NumberToStrDesc_ _
        ( byref c as Ctx, byval a0 as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function ConstStringTextOf_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outText as string, _
          byval depth as long = 0 ) as boolean
    declare function ZstrDataOf_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerConcatAssignStmt _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
          byval op as Tko.TokenKind ) as boolean
    declare function LowerWideConcatAssign _
        ( byref c as Ctx, byval target as Tko.NodeId, byval n as long, _
          byval value as Tko.NodeId ) as boolean
    declare function LowerWstrOf _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerLen _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideAssign _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    '' A static aggregate's initial value, as the bytes of its storage -- lowerudtlit.bas.
    declare function FoldAggInit_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byval init as Tko.NodeId, _
          byval size_ as long, byref outBytes as string ) as boolean

    '' 'type<T>( ... )' as a value or an address -- lowersub.bas.
    declare function LowerUdtLiteralValue_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerUdtLiteralAddr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    '' THE VARARG CURSOR -- lowercva.bas.
    declare function LowerCvaStart( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerCvaCopy( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerCvaEnd( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerCvaArg _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideToNarrow _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    declare function LowerWideToNarrowSlot _
        ( byref c as Ctx, byval slot as long, byval dt as Tko.TypeId, _
          byval value as Tko.NodeId ) as boolean
    declare function IsStringIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function IsAggIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerAggIif_ _
        ( byref c as Ctx, byval condE as Tko.NodeId, byval thenE as Tko.NodeId, _
          byval elseE as Tko.NodeId, byref outv as MirValue ) as boolean
    declare sub StoreThrough _
        ( byref c as Ctx, byref addr as MirValue, byref val as MirValue )
    declare function LowerUdtParenInit_ _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init as Tko.NodeId ) as boolean
    declare function IsUnionType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function LowerZstrAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as longint, _
          byval value as Tko.NodeId, byval isInit as boolean ) as boolean
    declare function LowerStrRvalue _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function ConcatToTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerMathCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare sub LowerIf _
        ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.StmtPayload ptr )
    declare function LowerTypeCtorExpr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function TypeCtorTypeOf_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId
    declare function EmitTypeCtorInto_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byval slot as long, _
          byval cp as Tko.ListPayload ptr ) as boolean
    declare function LowerUserUnaryOp_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byval up as Tko.UnaryPayload ptr, _
          byval mt as MirType, byref outv as MirValue ) as boolean
    declare function LowerUserBinaryOp_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
          byval mt as MirType, byref outv as MirValue ) as boolean
    declare function LowerPropertyGet_ _
        ( byref c as Ctx, byval node as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerPropertySet_ _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    declare function UserCastToStr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
          byref raw as boolean ) as boolean
    declare function LowerStrOf_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerStrNumCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerRadixCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
          byval wantWide as boolean = false ) as boolean
    declare function LowerOpen_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerOpenCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function StrDescriptorOf_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function IifArmType_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId
    declare function WideOperand_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideRvalue _
        ( byref c as Ctx, byval value as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerWideAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as long, _
          byval value as Tko.NodeId ) as boolean
    declare function LowerWideConcatAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as long, _
          byval value as Tko.NodeId ) as boolean
    '' lowerintr.bas
    declare function LowerClose( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerError( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerNew_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function CtorOf_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byval want as long ) as Tko.SymbolId
    declare function LowerDelete( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerBuiltinProc _
        ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval argFirst as long, _
          byval argCount as long, byref outv as MirValue ) as boolean
    declare function LowerProcPtr _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerArrayInit _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init as Tko.NodeId ) as boolean
    declare function PrintRtlFor( byref c as Ctx, byval t as Tko.TypeId ) as RtlId
    declare function PrintOne _
        ( byref c as Ctx, byval it as Tko.NodeId, byval mask as long, _
          byref chan as MirValue ) as boolean
    declare function IsWideString_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    '' A WIDE CONCATENATION built into a temporary the caller owns. fb_WstrConcat gives
    '' back an allocation released with fb_WstrDelete at the end of the statement.
    declare function WideConcatToTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    '' 1 for a narrow string type, 2 for a wide one, 0 for anything else. Both the
    '' SIZED spelling ('zstring * 8', an array of the builtin) and the UNSIZED one
    '' (the bare builtin, which a 'zstring ptr' points at) count.
    declare function CharElemSize_( byref c as Ctx, byval t as Tko.TypeId ) as long
    '' The LENGTH ARGUMENT a 'string * N' is passed as, which is not N: measured,
    '' '&h8000000000000000 or N' on win64 and '&h80000000 or N' on win32, the SIGN BIT
    '' being the tag that says "N space-padded bytes".
    declare function FixedStrLenArg_( byref c as Ctx, byval n as longint ) as longint
    '' Push a string operand's LENGTH, as a const instruction when it will not fit the
    '' 32-bit inline constant field -- which a fixed-length string's tagged length
    '' never does.
    declare sub PushStrLen_ _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), byval n as longint )
    declare function LowerWideIif_ _
        ( byref c as Ctx, byval condE as Tko.NodeId, byval thenE as Tko.NodeId, _
          byval elseE as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerStringIif_ _
        ( byref c as Ctx, byval condE as Tko.NodeId, byval thenE as Tko.NodeId, _
          byval elseE as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function StrInitFrom_ _
        ( byref c as Ctx, byref dst as MirValue, byval e as Tko.NodeId ) as boolean
    '' An 'iif' call and its three arms, WITHOUT asking what the arms are. Used where
    '' the context already knows the result is a string -- a term of a string
    '' assignment, an arm of another string iif -- because the arm types cannot answer
    '' it: Check computes no type for an intrinsic call, so 'iif( c, hex( 1 ),
    '' hex( 2 ) )' looks like an iif over nothing.
    declare function IsIifCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref condE as Tko.NodeId, _
          byref thenE as Tko.NodeId, byref elseE as Tko.NodeId ) as boolean
    declare function LowerIif _
        ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType, _
          byref outv as MirValue ) as boolean
    declare function LowerBitfieldRead _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerBitfieldStore _
        ( byref c as Ctx, byval id as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    declare function LowerCompoundAssign _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
          byval op as Tko.TokenKind ) as boolean
    declare function ParamCountOf( byref c as Ctx, byval callee as Tko.SymbolId ) as long
    declare function LowerBareProcCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType, _
          byref outv as MirValue ) as boolean
    declare function IsVariadicProc( byref c as Ctx, byval callee as Tko.SymbolId ) as boolean
    declare function ParamDefaultAt _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as Tko.NodeId
    declare function ParamTypeAt _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as Tko.TypeId
    declare function ParamIsArray _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean
    declare function ParamIsByref _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean

    declare function LowerStrCompare _
        ( byref c as Ctx, byval bp as Tko.BinaryPayload ptr, _
          byval tk as Tko.TokenKind ) as MirValue

    '' lowerarr.bas -- array indexing.
    declare function IsArrayIndex( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerArrayIndex( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
    declare function ConstFloat _
        ( byref c as Ctx, byval v as double, byval t as MirType ) as MirValue
    declare function IsFloatTy( byval t as MirType ) as boolean
    '' The conversion intrinsics -- CBYTE, CBOOL, CAST, CPTR and the rest.
    declare function IsConvIntrinsic _
        ( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerConvIntrinsic _
        ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType ) as MirValue

    declare function ConstInt _
        ( byref c as Ctx, byval v as longint, byval t as MirType ) as MirValue

    '' The address of a string literal's bytes, as a module global.
    declare function LowerStringLitAddr _
        ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
    declare function LowerTextAddr _
        ( byref c as Ctx, byref text as string ) as MirValue
    '' Constructors and destructors: finding them, and calling one on a slot.
    declare function StructorOf _
        ( byref c as Ctx, byval t as Tko.TypeId, byref which as string ) as Tko.SymbolId
    declare function StructorWithArity _
        ( byref c as Ctx, byval first_ as Tko.SymbolId, byval want as long ) as Tko.SymbolId
    '' 'slot' is a LOCAL whose address is the receiver. A NEGATIVE slot means the
    '' receiver is already a value and comes through 'selfVal' -- which is what DELETE
    '' has: a pointer, not a local.
    declare sub EmitStructorCall _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byval slot as long, _
          byval selfVal as MirValue ptr = 0, byval args as FB.Array( of ulong ) ptr = 0 )
    declare sub EmitCtorCall _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byval slot as long )
    declare sub EmitDtorCall _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byval slot as long )

    '' A call from its PIECES, so both of FreeBASIC's spellings reach one place.
    declare function LowerCallParts _
        ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval callee as Tko.SymbolId, _
          byval argFirst as long, byval argCount as long, _
          byval mt as MirType ) as MirValue

    '' The paren-less call statement: 'W 1, 2'.
    declare function LowerStmtCall _
        ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    '' The implicit THIS for 'obj.M( )' / 'p->M( )', or MV_NONE when there is none.
    '' lowergfx.bas -- the graphics statements.
    declare function LowerCallExpr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType ) as MirValue
    declare function LowerRgbCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerStrPtrCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerIntrinsicStmt( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerGfxStmt( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerGfxScreen( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerGfxExprCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    '' lowerimpl.bas -- the structors fbc writes for you.
    declare function UdtSymOf_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    declare function TypeNeedsInit_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function TypeNeedsDtor_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function NeedsCtorBody_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function NeedsDtorBody_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare sub EmitCtorPrologue_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref thisPtr as MirValue, _
          byval skipBase as boolean = false )
    declare sub EmitDtorEpilogue_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref thisPtr as MirValue )
    declare function ImplicitCtorName_( byref c as Ctx, byval t as Tko.TypeId ) as string
    declare function ImplicitDtorName_( byref c as Ctx, byval t as Tko.TypeId ) as string
    declare sub CallImplicitCtor_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref selfv as MirValue )
    declare sub CallImplicitDtor_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref selfv as MirValue )
    declare function NeedsLetBody_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function HasDynArrayMember_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function ImplicitLetName_( byref c as Ctx, byval t as Tko.TypeId ) as string
    declare function ImplicitCopyName_( byref c as Ctx, byval t as Tko.TypeId ) as string
    declare sub EmitLetBody_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref dst as MirValue, byref src as MirValue )
    declare sub CallImplicitLet_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref dst as MirValue, byref src as MirValue )
    declare sub CallImplicitCopy_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref dst as MirValue, byref src as MirValue )
    declare sub WantImplicit_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byval k as long )
    declare function ArrayElemNeedsInit_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function ArrayElemNeedsDtor_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare sub EmitArrayElems_ _
        ( byref c as Ctx, byval slot as long, byval at as Tko.TypeId, byval isCtor as boolean )
    declare sub EmitArrayElemsAt_ _
        ( byref c as Ctx, byref base_ as MirValue, byval at as Tko.TypeId, _
          byval isCtor as boolean )
    declare sub EmitModuleInit_( byref c as Ctx )
    declare sub EmitImplicitStructors( byref c as Ctx )

    '' lowervtab.bas -- virtual method tables.
    declare sub EmitVTableGlobals( byref c as Ctx )
    declare function VtableGlobalOf_( byref c as Ctx, byval t as Tko.TypeId ) as long
    declare function RttiGlobalOf_( byref c as Ctx, byval t as Tko.TypeId ) as long
    declare function StoreVptr_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byref thisAddr as MirValue ) as boolean
    declare function VirtualSlotOf_ _
        ( byref c as Ctx, byval target as Tko.NodeId, byval callee as Tko.SymbolId ) as long
    declare function VirtualCalleeOf_ _
        ( byref c as Ctx, byref self_ as MirValue, byval slot as long ) as MirValue

    declare function ReceiverOf _
        ( byref c as Ctx, byval target as Tko.NodeId, _
          byval callee as Tko.SymbolId ) as MirValue

    '' A DIM SHARED / STATIC initialiser: a compile-time value, not a store on entry.
    declare sub InitSharedGlobal _
        ( byref c as Ctx, byval sid as Tko.SymbolId, byval init as Tko.NodeId )

    '' TRUE, FALSE and __FUNCTION__: predeclared names that are values, not storage.
    declare function LowerPredeclared _
        ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    '' A string literal's text, with the escapes already resolved.
    declare function StringLitText_ _
        ( byref c as Ctx, byval id as Tko.NodeId ) as string

    '' Which half of a declined call statement is at fault, and the callee's name.
    declare sub CountUnlowredCall( byref c as Ctx, byval call_ as Tko.NodeId )

    '' Records a decline part-way through the statement being lowered.
    ''
    '' A MACRO, so the call SITE is captured rather than this file's own line. Twenty
    '' places give up on a statement and the totals alone cannot tell them apart; with
    '' the site, "what is not lowered" is a list of lines to go and read.
    declare sub SkipAt _
        ( byref c as Ctx, byref fileName as string, byval lineNo as long )
    #define SkipHere( c__ ) SkipAt( (c__), __FILE__, __LINE__ )
    declare sub SkipStmt( byref c as Ctx, byval id as Tko.NodeId )

end namespace

#endif

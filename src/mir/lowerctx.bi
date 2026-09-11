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
    '' -e/-ex/-exx. Only level 3 changes emission today: array bounds checks.
    as long                 errLevel
    '' The module name those checks report, filled once at entry.
    as string               errModName
    '' 'ON ERROR GOTO label' -- the blocks a runtime error may jump to in the procedure
    '' being lowered, and the blocks whose terminator is that jump.
    ''
    '' BOTH LISTS EXIST BECAUSE THE JUMP IS EMITTED BEFORE ITS DESTINATIONS ARE KNOWN.
    '' A check site can be lowered long before the ON ERROR that installs the handler --
    '' or after it -- so the indirectbr goes out with an empty destination list and the
    '' list is filled once the procedure is finished. LLVM verifies that set, and an
    '' omitted destination is a module it refuses.
    as FB.Array( of ulong ) errHandlerBlocks
    as FB.Array( of ulong ) errIndirectBlocks
    '' 'ON ERROR GOTO label' WHERE THE LABEL IS NOT LOWERED YET, which is the usual
    '' case: the handler sits at the end of the procedure and the statement naming it
    '' at the top. A block cannot be created early to take its address -- blocks are
    '' EXTENTS over one instruction list and must be created in the order they are
    '' filled -- so the operand goes out as a placeholder and is rewritten once the
    '' label has been reached. Parallel arrays: where the operand sits in the argument
    '' pool, and which label slot it names.
    as FB.Array( of ulong ) errPendingArg
    as FB.Array( of ulong ) errPendingSlot
    '' Whether this procedure has an ON ERROR at all, known before lowering starts.
    '' Without a handler the runtime never returns from a failed check -- it aborts --
    '' so the jump is dead code, and emitting it would mean an indirectbr with no
    '' destinations, which LLVM will not take.
    as boolean              hasErrHandler
    '' THE UNIT'S MODULE SCOPE, recorded once. Lowering has no scope of its own -- it
    '' walks a typed tree -- but a CONSTANT FOLD needs one: ConstOf answers 'unknown'
    '' for every identifier when it is handed no symbol table, and Lookup walks
    '' OUTWARD, so SCOPE_GLOBAL cannot see a module-level 'const'.
    as Tko.ScopeId          modScope
    '' ...and the procedure currently being lowered, for the same reason: a 'static'
    '' local's initialiser is folded while lowering the PROCEDURE, and the constant it
    '' names may be in the namespace the procedure lives in rather than at file level.
    as Tko.ScopeId          procScope
    '' The innermost loop's exit and continue targets, for EXIT and CONTINUE. A stack
    '' rather than a pair, because the statements take a level count.
    as FB.Array( of long )  breakTo
    as FB.Array( of long )  contTo
    '' THE ONE COMPARISON NODE BEING LOWERED AS A CONDITION, or NODE_NONE.
    ''
    '' A comparison used as a VALUE is NEGATED -- fbc writes '-((int64)A < (int64)B)',
    '' so 'print a < b' prints -1 and not 1 -- and a comparison used as a CONDITION is
    '' a branch, which only asks whether it is nonzero. Negating one there would be an
    '' extra instruction in every IF in the corpus and is not what fbc emits.
    ''
    '' The exact NODE rather than a depth, because a condition may CONTAIN a value-
    '' position comparison: 'if (a < b) + 1' negates the inner one, measured.
    as Tko.NodeId           rawCmpNode
    '' THE OPEN 'with' SUBJECTS AND THE ADDRESS EACH WAS EVALUATED TO, innermost last.
    ''
    '' Resolve points every baseless '.field' at the subject's OWN NODE, which makes the
    '' tree a DAG: one expression reached from as many places as there are members. Left
    '' to lower itself each time, 'with( status( hFindSlot( @this ) ) )' would call
    '' hFindSlot once per '.field'. fbc evaluates the subject ONCE, so its address is
    '' computed once here and every use inside the body reads this instead.
    as FB.Array( of ulong )  withNode
    as FB.Array( of ulong )  withKind
    as FB.Array( of ulong )  withId
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
    '' The INITIALISER NODE for a module global constructed by a named constructor --
    '' 'dim shared f as foo = foo( 7 )' -- or NODE_NONE for the default-constructed
    '' ones. Parallel to modInitGlobal. fbc emits the chosen call in its module
    '' initialiser: '_ZN3FOOC1Eu7INTEGER( &F$, 7ll )'.
    as FB.Array( of ulong ) modInitCall
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
    '' STATEMENT-LIFETIME UDT TEMPORARIES: the hidden result object of a call that
    '' returns a UDT by value. Measured -- fbc destroys one at the END OF THE
    '' STATEMENT that consumed it, which is shorter than any scope, so it belongs
    '' beside the string temporaries and not on the cleanup list.
    as FB.Array( of ulong ) udtTemps
    '' WHERE THE CURRENT STATEMENT'S UDT TEMPORARIES START. LowerStmt releases
    '' everything above it once the statement ends, but a RETURN never gets there:
    '' it terminates the block, and the release then has nowhere to emit. The
    '' return paths use this mark to let go of them BEFORE they terminate.
    as long stmtUdtMark
    as FB.Array( of ulong ) udtTempTypes
    '' DATA. The head of the module's block chain (-1 when it has none), and the
    '' label -> block map a 'restore lbl' resolves through. Both are built by a
    '' PRE-PASS, because 'restore lbl' may name a label that appears later.
    '' The current procedure's HIDDEN RESULT POINTER, when it has one: parameter 0,
    '' holding the caller's storage. -1 when the result is not returned that way.
    '' Whether the current procedure returns a TRIVIAL UDT by value, in which case the
    '' result slot holds the object itself and 'ret' carries its VALUE.
    as boolean              udtResult
    '' A BYREF RESULT: the slot holds an ADDRESS, and 'function = expr' stores the
    '' address of expr rather than its value.
    as boolean              byrefResult
    '' WHETHER THE LAST CALL LOWERED. Read by the statement dispatcher, because a
    '' call's arguments are emitted before the call can fail and an instruction count
    '' therefore cannot tell a dropped call from a lowered one. Calls NEST, and the
    '' OUTERMOST is the last to write it -- which is the one the statement is asking
    '' about, and why this is a flag rather than a counter.
    as boolean              lastCallOk
    as long                 lastCallFailLine
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
declare function PtrArithElem_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as long
declare function LowerExpr( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
'' An expression lowered as a CONDITION: the same lowering, with the top-level
'' comparison left un-negated because a branch only asks whether it is nonzero.
declare function LowerCondition( byref c as Ctx, byval e as Tko.NodeId ) as MirValue
'' Destroy every statement-lifetime UDT temporary made since 'mark'. Called from the
'' statement dispatcher, and from a LOOP HEAD, where waiting for the statement to end
'' would leak one per iteration.
declare sub ReleaseUdtTemps_( byref c as Ctx, byval mark as long )
declare sub ForgetUdtTemp_( byref c as Ctx, byval slot as long )
declare function LowerAddr( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
declare sub LowerStmt( byref c as Ctx, byval id as Tko.NodeId )
declare function StmtOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
declare function SameLValue _
    ( byref c as Ctx, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
declare function IsStringType( byref c as Ctx, byval t as Tko.TypeId ) as boolean
declare function IsFixedStrArray_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
declare function LowerStringAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
declare function NewTempLocal _
    ( byref c as Ctx, byval ty as MirType, byval sizeBytes as long ) as long
    '' lowerboundchk.bas -- the -exx array bounds check, one dimension at a time.
declare sub EmitNullCheck_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref pv as MirValue )
declare sub EmitBoundsCheck_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval target as Tko.NodeId, _
      byval at as Tko.TypeId, byval k as long, byref iv as MirValue, _
      byval offTy as MirType )
declare function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue


    '' lowerctl.bas -- control flow.
    declare sub LowerSelect( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerExitLike _
        ( byref c as Ctx, byval id as Tko.NodeId, byval isExit as boolean )
    declare sub LowerEndStmt( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerLabel( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerOnGoto( byref c as Ctx, byval id as Tko.NodeId )
    declare sub LowerGoto( byref c as Ctx, byval id as Tko.NodeId )
    declare sub ScanLabels _
        ( byref c as Ctx, byval id as Tko.NodeId, byval depth as long )


    '' lower.bas -- shared by the other lowering files.
    '' lowerboundchk.bas -- the indirect jump a failed -e check hands back, and the
    '' pass that gives it its destinations once the procedure's handlers are known.
    declare sub EmitErrorJump_( byref c as Ctx, byref r as MirValue )
    declare sub ResolveErrorJumps_( byref c as Ctx )
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
    ( byref c as Ctx, byref addr as MirValue, byval t as MirType, _
      byval sizeBytes as long = 0 ) as MirValue
    declare function LoadResult( byref c as Ctx ) as MirValue
    '' lowerproc.bas -- the two procedure lowerings.
    declare sub LowerProc( byref c as Ctx, byval id as Tko.NodeId )
    '' isMainModule decides whether the top-level code becomes 'main' or a module
    '' constructor named 'fb_ctor__<moduleName>'.
    declare sub LowerMainModule _
        ( byref c as Ctx, byval root as Tko.NodeId, _
          byval isMainModule as boolean, byref moduleName as string )
    declare function ZeroOf( byref c as Ctx, byval t as MirType ) as MirValue
    '' 'srcUnsigned' is the SOURCE's signedness, which a MirType cannot carry: MT_I32
    '' says 32 bits and nothing about how to widen them. Without it a ULONG widened to
    '' a LONGINT sign-extended -- 4,000,000,000 became -294,967,296 -- and a ULONGINT
    '' converted to a DOUBLE went through sitofp and came out -1. Both measured by
    '' running fbc, which prints 4000000000 and 1.844674407370955e+019.
    '' COERCE, GIVEN THE SOURCE'S FRONTEND TYPE. Prefer this to Coerce wherever the
    '' source type is known: it asks BOTH questions the conversion depends on --
    '' signedness and booleanness -- where the bare Coerce could only be told one.
    declare function CoerceTy _
        ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
          byval srcTid as Tko.TypeId, _
          byval dstTid as Tko.TypeId = Tko.TYPE_NONE ) as MirValue
    declare function IsBooleanType _
        ( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function Coerce _
        ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
          byval srcUnsigned as boolean = false, _
          byval dstUnsigned as boolean = false ) as MirValue
    declare function EmitImpEqv_ _
        ( byref c as Ctx, byval tk as Tko.TokenKind, byval ty as MirType, _
          byref l as MirValue, byref r as MirValue ) as MirValue
    declare function BinOpFor _
        ( byval tk as Tko.TokenKind, byval t as MirType, _
          byval isUnsigned as boolean ) as MirOp
    declare sub LowerBlock( byref c as Ctx, byval id as Tko.NodeId )

    declare sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    declare sub ZeroStrTempAtEntry_( byref c as Ctx, byref dst as MirValue )
    '' The (pointer, length) pair for one term of a concatenation, appended to 'args'.
    declare function EmitStrTerm _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), _
          byval term as Tko.NodeId, byval isU as boolean = false ) as boolean
    '' Flatten a left-leaning '+'/'&' chain into its terms, in source order.
    declare sub FlattenConcat _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outp as FB.Array( of ulong ) )
    declare function LowerStringInit _
        ( byref c as Ctx, byval slot as long, byval target as Tko.NodeId, _
          byval value as Tko.NodeId ) as boolean

    '' lowerstore.bas -- frame slot vs module storage.
    declare function LocalFor( byref c as Ctx, byval sid as Tko.SymbolId ) as long
    declare function ProcIsStatic_ _
        ( byref c as Ctx, byval defn as Tko.NodeId, byval sid as Tko.SymbolId ) as boolean
    declare function ProcCallConv_ _
        ( byref c as Ctx, byval pn as Tko.NodeId ) as ubyte
    declare function ParamMirType _
        ( byref c as Ctx, byval t as Tko.TypeId ) as MirType
    '' Fills a function's signature from the procedure it declares -- see lowerproc.bas.
    declare sub SignatureFromProc _
        ( byref c as Ctx, byval f as MirFunction ptr, byval pn as Tko.NodeId, _
          byval withSret as boolean, byval withThis as boolean )
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
    declare function LowerIsTypeOf_ _
        ( byref c as Ctx, byval lhs as Tko.NodeId, byval rhs as Tko.NodeId, _
          byref outv as MirValue ) as boolean
    declare function LowerPeek _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, byval wantAddr as boolean = false ) as boolean

    declare function LowerMidAssign _
        ( byref c as Ctx, byval target as Tko.NodeId, _
          byval value as Tko.NodeId ) as boolean
    declare function LowerCloseCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerDir _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerBitOp _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    declare function LowerPoke( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerLrset _
        ( byref c as Ctx, byval id as Tko.NodeId, byval isRight as boolean ) as boolean
    '' lowerusing.bas
    declare function LowerPrintUsing _
        ( byref c as Ctx, byval id as Tko.NodeId, byval fromIdx as long = 0, _
          byval fmtNode as Tko.NodeId = Tko.NODE_NONE ) as boolean
    '' lowerdesc.bas
    '' How many elements a FIXED array holds, across every dimension; 0 when the
    '' shape is dynamic or its bounds do not read.
    declare function FixedArrayElems _
        ( byref c as Ctx, byval t as TypeId ) as longint
    declare function SynthFixedArrayDesc _
        ( byref c as Ctx, byref arrAddr as MirValue, byval t as Tko.TypeId, _
          byref outv as MirValue ) as boolean
    '' Whether a UDT return travels through an explicit hidden pointer. Measured:
    '' the type has a DESTRUCTOR or a COPY CONSTRUCTOR. Size plays no part.
    declare function UsesSretReturn( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function LowerErase( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function SizeOfType( byref c as Ctx, byval t as Tko.TypeId ) as long
    '' The SysV eightbyte classes of a type -- see mir/eightbyte.bas.
    declare function ClassifyEightbytes _
        ( byref c as Ctx, byval t as Tko.TypeId ) as ulong
    '' A cleanup entry that is neither a symbol nor the string-delete 0: erase the
    '' dynamic array in this slot. Deliberately an impossible SymbolId.
    const CLEANUP_ERASE_ARRAY as ulong = &hFFFFFFFF
    const CLEANUP_IMPLICIT_DTOR as ulong = &hFFFFFFFE
    const CLEANUP_DESTROY_ARRAY as ulong = &hFFFFFFFD
    const CLEANUP_DTOR_EPILOGUE as ulong = &hFFFFFFFC
    const CLEANUP_DESTRUCT_STR_ARRAY as ulong = &hFFFFFFFB

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
          byval init_ as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean
    '' A CONVERTING 'operator let' -- 'x = 5' over a UDT. See lowerctor.bas.
    declare function LowerUserLetConv_ _
        ( byref c as Ctx, byval target as Tko.NodeId, byval t as Tko.TypeId, _
          byval value as Tko.NodeId ) as boolean
    declare function LowerCtorInit _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init_ as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean
    '' A STATIC LOCAL that needs constructing: the guard flag, the constructor and the
    '' atexit thunk fbc emits for one.
    declare function LowerStaticLocalInit_ _
        ( byref c as Ctx, byval sid as Tko.SymbolId, byval init_ as Tko.NodeId ) as boolean
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
    declare function NormaliseBool _
        ( byref c as Ctx, byref v as MirValue ) as MirValue
    declare function AnyDimCount _
        ( byref c as Ctx, byval ip as Tko.StmtPayload ptr ) as long
    declare function EmitArrayBounds _
        ( byref c as Ctx, byref desc as MirValue, byval aty as Tko.TypeId, _
          byval ip as Tko.StmtPayload ptr, byval presv as boolean ) as boolean
    declare sub InitDynArrayDesc _
        ( byref c as Ctx, byref desc as MirValue, byval t as Tko.TypeId )
    declare function DynArrayDataPtr _
        ( byref c as Ctx, byref desc as MirValue ) as MirValue
    '' lowerthread.bas
    declare function LowerThreadCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
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
          byref args as FB.Array( of ulong ), _
          byval withSret as boolean = false ) as MirValue
    declare function MemberCallRetTy_ _
        ( byref c as Ctx, byval sym as Tko.SymbolId ) as MirType
    declare function EmitMemberCallArgs_ _
        ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
          byval rt as MirType, byval args as FB.Array( of ulong ) ptr ) as MirValue
    '' lowerselfop.bas
    declare function SelfOpMemberCall_ _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
          byval op as Tko.TokenKind, byval tt as Tko.TypeId ) as boolean
    declare function UserConvToScalar_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byval dstT as Tko.TypeId, _
          byref outv as MirValue ) as boolean
    declare function UserCastNumOverload_ _
        ( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    declare function UserCastToNum_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

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
        ( byref c as Ctx, byval valueE as Tko.NodeId, _
          byval isReturn as boolean = false ) as boolean
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
    '' lowerinit.bas -- the two CHARACTER predicates. Declared here rather than in
    '' lower.bas alone because lowerwstr.bas is its OWN compilation unit and could
    '' not see them: the wide concatenation test needs the same 'a character plus a
    '' number is arithmetic' rule the narrow one has.
    '' lowermember.bas -- one field's initialisation, for the synthesised structors.
    declare sub InitMember_ _
        ( byref c as Ctx, byref addr as MirValue, byval ft as Tko.TypeId )
    declare function CharLvalueTy_( byref c as Ctx, byval id as Tko.NodeId ) as MirType
    declare function NumericTerm_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function ConcatHasWideTerm_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    declare function TermIsWide_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    declare function NarrowStrArg_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    declare function RuntimeEntryCallee_ _
        ( byref c as Ctx, byval callee as Tko.SymbolId ) as boolean
    declare function StrArgOwnDescriptor_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId ) as boolean
    declare function WideCastOverload_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    declare function WideToNarrowTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    '' A number or a boolean rendered WIDE, into a statement-lifetime temporary.
    declare function NumberToWideTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function NarrowToWideTemp_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LitHasUnicodeEscape_ _
        ( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    declare function WideLitGlobal_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outChars as long ) as long
    declare function IsWstrCall_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function IsStrCall_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function NumberToStrDesc_ _
        ( byref c as Ctx, byval a0 as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerClosureAddr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
          byval dstv as MirValue ptr = 0 ) as boolean
    declare function LowerClosure_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function ConstStringTextOf_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outText as string, _
          byval depth as long = 0, _
          byval scope_ as Tko.ScopeId = Tko.SCOPE_GLOBAL ) as boolean
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
    '' USTRING -- the UTF-16 string flavour, lowerstr.bas.
    '' 'T( args )' as an addressable temporary -- lowerswap.bas.
    '' 'a[ i ]' over a UDT with 'operator []', in the shape the operator declares.
    declare function LowerUdtIndexOp_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue, _
          byref outByref as boolean ) as boolean
    declare function LowerTypeCtorTempAddr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    '' File GET and PUT -- lowerio.bas.
    declare function LowerFileGetPut _
        ( byref c as Ctx, byval id as Tko.NodeId, byval isPut as boolean, _
          byref outv as MirValue ) as boolean

    declare function IsUStringType( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function ConcatTermsAreU_ _
        ( byref c as Ctx, byref terms as FB.Array( of ulong ) ) as boolean
    declare function UStrRtl_( byval narrow as RtlId ) as RtlId
    declare function StrRtlFor_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byval narrow as RtlId ) as RtlId
    declare sub PushUStrLiteralArg _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), byval gidx as long, _
          byval nchars as long )

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
          byval value as Tko.NodeId, byval isInit as boolean = false, _
          byval selfv as MirValue ptr = 0 ) as boolean
    declare function IsStringIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function IsAggIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerAggIif_ _
        ( byref c as Ctx, byval condE as Tko.NodeId, byval thenE as Tko.NodeId, _
          byval elseE as Tko.NodeId, byref outv as MirValue ) as boolean
    declare sub StoreThrough _
        ( byref c as Ctx, byref addr as MirValue, byref val as MirValue )
    '' A brace initialiser over an array of UDT. 'selfv' is the destination when there
    '' is no slot -- a STATIC local's storage is a global.
    declare function LowerUdtArrayInit_ _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean
    declare function LowerUdtParenInit_ _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean
    declare function IsUnionType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function LowerZstrAssignTo _
        ( byref c as Ctx, byref dst as MirValue, byval n as longint, _
          byval value as Tko.NodeId, byval isInit as boolean, _
          byval isU as boolean = false ) as boolean
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
    declare function UserCastToWide_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
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
    '' A temporary holding an argument that must be passed BYREF and has no address of
    '' its own -- lowercall.bas.
    declare function ByrefTemp_ _
        ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId ) as MirValue
    declare function StrDescriptorOf_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function IifArmType_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId
    declare function WideAppendToU_ _
        ( byref c as Ctx, byref dst as MirValue, byval value as Tko.NodeId ) as boolean
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
    declare function LowerColorCall_ _
        ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval argFirst as long, _
          byval argCount as long, byref outv as MirValue ) as boolean
    declare function LowerBuiltinProc _
        ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval argFirst as long, _
          byval argCount as long, byref outv as MirValue, _
          byval unboundOnly as boolean = false ) as boolean
    declare function LowerProcPtr _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerArrayInit _
        ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
          byval init as Tko.NodeId, byval selfv as MirValue ptr = 0 ) as boolean
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
    declare sub PushStrArg _
        ( byref args as FB.Array( of ulong ), byref addr as MirValue )
    '' The FLAVOUR of one term of a string chain -- see lowerterm.bas. NEUTRAL follows
    '' the destination: a literal, a string constant, a rendered number, an untyped
    '' intrinsic call.
    const STF_NEUTRAL as long = 0
    const STF_NARROW  as long = 1
    const STF_WIDE    as long = 2
    const STF_UTF16   as long = 3
    declare function LowerStrOperandOp_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function IsTupleType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function LowerDestructure _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    declare function LowerTupleCompare _
        ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
          byval tk as Tko.TokenKind, byref outv as MirValue ) as boolean
    '' '__FB_QUERY_SYMBOL__( q, sym )' -- fbc's compile-time symbol query, folded.
    '' The low 'n' bits set, for a bitfield mask.
    declare function BitMask_( byval n as long ) as longint
    '' 'x.a op= v' over a BITFIELD: a read, the operator and a masked write.
    declare function BitfieldCompound_ _
        ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
          byval bop as Tko.TokenKind ) as boolean
    declare function LowerQuerySymbol_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerOffsetOf _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function TyWidthBytes_( byval t as MirType ) as long
    declare function StrCatText_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as string ) as boolean
    declare function StrTermFlavour_( byref c as Ctx, byval term as Tko.NodeId ) as long
    declare function UStrCmpOperand_ _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), _
          byval term as Tko.NodeId ) as boolean
    declare function WideTermAsUStr_ _
        ( byref c as Ctx, byval term as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function IsUStringDest_( byref c as Ctx, byref dst as MirValue ) as boolean
    declare function LowerStrConvertTerm _
        ( byref c as Ctx, byref dst as MirValue, byval dstIsU as boolean, _
          byval term as Tko.NodeId, byval isInit as boolean ) as boolean
    declare function LowerNarrowChainToU_ _
        ( byref c as Ctx, byref dst as MirValue, _
          byref terms as FB.Array( of ulong ), byval isInit as boolean ) as boolean
    declare function LowerUStrChain _
        ( byref c as Ctx, byref dst as MirValue, byval dstIsU as boolean, _
          byref terms as FB.Array( of ulong ), byval isInit as boolean ) as boolean
    declare function StrChainNeedsConvert _
        ( byref c as Ctx, byval dstIsU as boolean, _
          byref terms as FB.Array( of ulong ) ) as boolean
    declare sub PushStrLiteralArg _
        ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
    '' lowerustr.bas -- the USTRING intrinsic family, the third beside the narrow set
    '' in lowersub.bas and the wide one in lowerwstr.bas.
    '' The ADDRESS of a SYNTHESISED structor -- kind_ 1 for the constructor, 0 for
    '' the destructor. FuncAddrOf names a WRITTEN procedure through its symbol; an
    '' implicit one has only the name its body will be emitted under.
    declare function ImplStructorAddr_ _
        ( byref c as Ctx, byval t as Tko.TypeId, byval kind_ as long ) as MirValue

    declare function LowerUStrIntrin_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    declare sub PushStrLen_ _
        ( byref c as Ctx, byref args as FB.Array( of ulong ), byval n as longint )
    declare function LowerWideIif_ _
        ( byref c as Ctx, byval condE as Tko.NodeId, byval thenE as Tko.NodeId, _
          byval elseE as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function IsStrIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
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
    declare function LowerBitfieldStoreValue_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref val as MirValue ) as boolean
    declare function LowerBitfieldStore _
        ( byref c as Ctx, byval id as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    '' 'a andalso b' from its PIECES, so the compound form can reach it too.
    declare function LowerShortCircuitParts_ _
        ( byref c as Ctx, byval lhsE as Tko.NodeId, byval rhsE as Tko.NodeId, _
          byval isAnd as boolean, byval mt as MirType ) as MirValue
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
    declare function PushCtorArgs_ _
        ( byref c as Ctx, byval ctor as Tko.SymbolId, byval first_ as long, _
          byval count as long, byref args as FB.Array( of ulong ) ) as boolean
    declare function UserConvOperand_ _
        ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
          byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean
    declare sub DestroyOperandTemps_ _
        ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
          byref types as FB.Array( of ulong ) )
    declare function ArrayDescArg_ _
        ( byref c as Ctx, byval argNode as Tko.NodeId, _
          byval isArrayParam as boolean, byref outv as MirValue ) as boolean

    declare function ParamIsArray _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean
    declare function ParamIsByref _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean

    declare function LowerStrCompare _
        ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
          byval tk as Tko.TokenKind ) as MirValue

    '' lowerarr.bas -- array indexing.
    '' Is this node 'this' -- the receiver, held in the ABI as a POINTER?
    declare function IsThisPointerIdent_ _
        ( byref c as Ctx, byval n as Tko.NodeId ) as boolean
    declare function IsArrayIndex( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerArrayIndex( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
    declare function ConstFloat _
        ( byref c as Ctx, byval v as double, byval t as MirType ) as MirValue
    declare function IsFloatTy( byval t as MirType ) as boolean
    '' The conversion intrinsics -- CBYTE, CBOOL, CAST, CPTR and the rest.
    declare function IsConvIntrinsic _
        ( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    '' The operand of a string-to-string 'cast'/'cptr' -- see the definition.
    declare function StrIdentityConvOperand_ _
        ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.NodeId
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
    '' 'wantRef' asks for the REFERENCE a byref-returning call hands back rather than
    '' the referent. LowerAddr needs the address; every value read needs the load.
    '' It cannot be inferred from 'mt': a 'function f( ) byref as long ptr' read as a
    '' VALUE also asks for MT_PTR, and loading is right for that one.
    declare function LowerCallParts _
        ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval callee as Tko.SymbolId, _
          byval argFirst as long, byval argCount as long, _
          byval mt as MirType, byval wantRef as boolean = false ) as MirValue

    '' The paren-less call statement: 'W 1, 2'.
    declare function LowerStmtCall _
        ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    '' The implicit THIS for 'obj.M( )' / 'p->M( )', or MV_NONE when there is none.
    '' lowergfx.bas -- the graphics statements.
    declare function LowerCallExpr_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType ) as MirValue
    declare function LowerRgbCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerVarPtrCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerStrPtrCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
    declare function LowerIntrinsicStmt( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerGfxStmt( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerGfxScreen( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    declare function LowerGfxExprCall_ _
        ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    '' lowerfieldinit.bas -- 'a as integer = 123' inside a TYPE. The value is run by
    '' the constructor, so lowerimpl.bas is what calls both of these.
    declare function FieldInitOf_ _
        ( byref c as Ctx, byval f as Tko.Symbol ptr ) as Tko.NodeId
    declare sub EmitFieldInit_ _
        ( byref c as Ctx, byref addr as MirValue, byval ft as Tko.TypeId, _
          byval init as Tko.NodeId )
    '' ...and whether that initialiser is the word ANY, which suppresses the field's
    '' zero fill and its member constructor as well as the store.
    declare function FieldInitIsAny_ _
        ( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    '' 'T( args )' constructed ON AN ADDRESS -- a field's, or a shared global's. The
    '' chosen constructor, its arguments coerced to that overload's parameters, and no
    '' temporary of T anywhere.
    declare function CtorCallOnAddr_ _
        ( byref c as Ctx, byref addr as MirValue, byval ft as Tko.TypeId, _
          byval init as Tko.NodeId ) as boolean
    '' lowerimpl.bas -- the structors fbc writes for you.
    declare function UdtSymOf_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    declare function TypeNeedsInit_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function TypeNeedsDtor_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function NeedsCtorBody_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    '' ...and whether a constructor that ALREADY EXISTS has a prologue. Not the same
    '' question: see the comment on the definition.
    declare function CtorPrologueWork_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    '' A byval UDT parameter that fbc passes as a POINTER to a caller-built copy.
    declare function ByvalUdtIndirect_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function ParamIsIndirectUdt_ _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean
    '' ...and a byval var-length STRING parameter, which is the same shape with the
    '' string runtime doing the copying.
    declare function ByvalStrIndirect_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    declare function ParamIsIndirectStr_ _
        ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long ) as boolean
    declare function ByvalStrTemp_ _
        ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
          byref outa as MirValue, byref outSlot as long ) as boolean
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
    declare function CopyCtorOf_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
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

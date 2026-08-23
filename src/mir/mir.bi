'' mir.bi -- the mid-level IR.
''
'' MIR exists so FreeBASIC's semantics have exactly ONE place where they are
'' eliminated (lowering), and so the backend consumes a small closed instruction set
'' rather than a syntax tree (docs/plan/09 section 1, decision D8).
''
'' What is ABSENT from MIR is the point of it: no string, no array, no UDT semantics,
'' no boolean distinct from i8. Those are frontend concepts and are gone by here. A
'' value is an integer, a float, a pointer, or an opaque aggregate identified by a
'' frontend TypeId for layout purposes only.
''
'' NOT SSA. Locals are alloca + load/store and temporaries are single-assignment by
'' construction -- the same shape LLVM's own frontends emit before mem2reg, so LLVM
'' promotes them for free and lowering stays simple. The IR is nonetheless shaped for
'' a future SSA form: explicit blocks, explicit terminators, and no implicit
'' fallthrough anywhere.

#ifndef __TKO_MIR_BI__
#define __TKO_MIR_BI__

#include once "tko.bi"
#include once "types/type.bi"
#include once "support/intern.bi"

namespace Tko.Mir

    '' The closed type set. 'agg' carries a frontend TypeId because an aggregate's
    '' layout is still a frontend question; nothing else about it survives.
    enum MirType
        MT_VOID = 0
        MT_I8
        MT_I16
        MT_I32
        MT_I64
        MT_F32
        MT_F64
        MT_PTR
        MT_AGG
    end enum

    '' MIR( opcode, mnemonic, operand count, has result )
    ''
    '' The mnemonic is the only spelling used by --dump-ir and by the golden tests, so
    '' an opcode cannot be renamed in one place and not the other.
    #macro TKO_MIR_LIST( OP )
        OP( M_CONST,      "const",      0, true  )
        OP( M_ALLOCA,     "alloca",     0, true  )
        OP( M_LOAD,       "load",       1, true  )
        OP( M_FIELD_ADDR, "field.addr", 1, true  )   '' base + a CONSTANT offset
        '' base + a COMPUTED BYTE offset. Distinct from M_ADD so nothing downstream can
        '' read it as integer arithmetic: the offset is already in bytes and must not be
        '' scaled again by an element size.
        OP( M_PTR_ADD,    "ptr.add",    2, true  )
        OP( M_STORE,      "store",      2, false )
        OP( M_ADD,        "add",        2, true  )
        OP( M_SUB,        "sub",        2, true  )
        OP( M_MUL,        "mul",        2, true  )
        OP( M_SDIV,       "sdiv",       2, true  )
        OP( M_UDIV,       "udiv",       2, true  )
        OP( M_FDIV,       "fdiv",       2, true  )
        OP( M_SREM,       "srem",       2, true  )
        OP( M_UREM,       "urem",       2, true  )
        OP( M_NEG,        "neg",        1, true  )
        OP( M_AND,        "and",        2, true  )
        OP( M_OR,         "or",         2, true  )
        OP( M_XOR,        "xor",        2, true  )
        OP( M_NOT,        "not",        1, true  )
        OP( M_SHL,        "shl",        2, true  )
        OP( M_LSHR,       "lshr",       2, true  )
        OP( M_ASHR,       "ashr",       2, true  )
        OP( M_ICMP_EQ,    "icmp.eq",    2, true  )
        OP( M_ICMP_NE,    "icmp.ne",    2, true  )
        OP( M_ICMP_SLT,   "icmp.slt",   2, true  )
        OP( M_ICMP_SGT,   "icmp.sgt",   2, true  )
        OP( M_ICMP_SLE,   "icmp.sle",   2, true  )
        OP( M_ICMP_SGE,   "icmp.sge",   2, true  )
        OP( M_ICMP_ULT,   "icmp.ult",   2, true  )
        OP( M_ICMP_UGT,   "icmp.ugt",   2, true  )
        OP( M_FCMP_EQ,    "fcmp.eq",    2, true  )
        OP( M_FCMP_NE,    "fcmp.ne",    2, true  )
        OP( M_FCMP_LT,    "fcmp.lt",    2, true  )
        OP( M_FCMP_GT,    "fcmp.gt",    2, true  )
        OP( M_FCMP_LE,    "fcmp.le",    2, true  )
        OP( M_FCMP_GE,    "fcmp.ge",    2, true  )
        OP( M_TRUNC,      "trunc",      1, true  )
        OP( M_SEXT,       "sext",       1, true  )
        OP( M_ZEXT,       "zext",       1, true  )
        OP( M_FPTRUNC,    "fptrunc",    1, true  )
        OP( M_FPEXT,      "fpext",      1, true  )
        OP( M_FPTOSI,     "fptosi",     1, true  )
        OP( M_SITOFP,     "sitofp",     1, true  )
        '' FLOAT to FLOAT, rounding to the nearest integral value, halves to EVEN.
        '' FreeBASIC does NOT truncate a float on the way to an integer: measured by
        '' running fbc, 1.4 -> 1, 1.6 -> 2, 2.5 -> 2, 3.5 -> 4, -2.5 -> -2. A bare
        '' fptosi truncates toward zero and gives 1, 1, 2, 3, -2 -- wrong in three of
        '' those five. fbc emits __builtin_nearbyint before its cast and so does this.
        OP( M_NEARBYINT,  "nearbyint",  1, true  )
        '' An UNSIGNED source converted to floating point. sitofp on a ulongint of
        '' 1.8e19 yields -1; fbc casts from the unsigned type and gets 1.8e19.
        OP( M_UITOFP,     "uitofp",     1, true  )
        '' THE MATH INTRINSICS THAT ARE NOT RUNTIME CALLS. fbc emits gcc BUILTINS for
        '' these -- '__builtin_sqrt( X )', not a call to anything libfb exports -- so
        '' they are OPCODES here rather than RTL entries. Putting them in the runtime
        '' inventory would also have broken check-rtl, which reads what fbc DECLARES,
        '' and a builtin is declared nowhere.
        ''
        '' Only the ones fbc actually spells that way. 'fix', 'frac' and 'sgn' ARE
        '' runtime calls -- fb_FIXDouble, fb_FRACd, fb_SGNl -- and 'atan2' is a plain
        '' libc call with no builtin prefix at all. None of that is symmetrical and
        '' none of it is guessable; each was read off fbc's own C.
        OP( M_FLOOR,      "floor",      1, true  )
        OP( M_SQRT,       "sqrt",       1, true  )
        OP( M_SIN,        "sin",        1, true  )
        OP( M_COS,        "cos",        1, true  )
        OP( M_TAN,        "tan",        1, true  )
        OP( M_ASIN,       "asin",       1, true  )
        OP( M_ACOS,       "acos",       1, true  )
        OP( M_ATAN,       "atan",       1, true  )
        OP( M_LOG,        "log",        1, true  )
        OP( M_EXP,        "exp",        1, true  )
        '' ABS on a FLOAT and ABS on an INTEGER are different builtins, and the float
        '' one differs again by width: fabs, fabsf, llabs.
        OP( M_FABS,       "fabs",       1, true  )
        OP( M_IABS,       "iabs",       1, true  )
        OP( M_BITCAST,    "bitcast",    1, true  )
        OP( M_CALL,       "call",      -1, true  )
        '' A CALL THROUGH A VALUE. docs/plan/09 lists 'call_indirect' in the opcode
        '' table; this is it. The callee is in 'a' rather than in the 'callee' index,
        '' and everything else -- the argument pool extent, the result type -- is a
        '' direct call's.
        OP( M_CALL_IND,   "call.ind",  -1, true  )
        '' THE ADDRESS OF A FUNCTION, by index into the module's function table. What
        '' 'procptr( f )' produces, and what a lambda's value would be. fbc spells it
        '' '(tmp$2)&F'.
        OP( M_FUNC_ADDR,  "func.addr",  0, true  )
        OP( M_CALL_RTL,   "call.rtl",  -1, true  )
        '' THE VARARG CURSOR OPCODES. fbc emits these as gcc builtins over a va_list --
        '' '__builtin_va_start( *(__builtin_va_list*)&ARGS, N )' -- so like the math
        '' builtins above they are opcodes here rather than runtime inventory entries,
        '' and for the same reason: check-rtl reads what fbc DECLARES, and a builtin is
        '' declared nowhere.
        ''
        '' Every one of them takes the ADDRESS of the cva_list, never its value. That is
        '' what makes a 24-byte Linux va_list and an 8-byte Windows one the same shape
        '' here.
        ''
        '' M_VA_START's SECOND operand is the last NAMED parameter, which is what fbc
        '' passes. LLVM's own llvm.va_start takes only the list pointer and a backend
        '' may ignore operand 2 -- it is carried because fbc emits it and because
        '' dropping it would lose the only link between the cursor and the signature it
        '' walks.
        OP( M_VA_START,   "va.start",   2, false )
        '' The result TYPE is the type being fetched; LLVM has a real 'va_arg'
        '' instruction with exactly this shape.
        OP( M_VA_ARG,     "va.arg",     1, true  )
        OP( M_VA_END,     "va.end",     1, false )
        OP( M_VA_COPY,    "va.copy",    2, false )
    #endmacro

    enum MirOp
        M_NONE = 0
        #define OP( o_id, o_name, o_args, o_res ) o_id,
        TKO_MIR_LIST( OP )
        #undef OP
        M_OP_COUNT
    end enum

    '' Terminators are separate from instructions: every block ends in exactly one,
    '' and nothing follows it. Keeping them out of the instruction list makes that
    '' structural rather than something the verifier has to notice.
    enum MirTermKind
        MTERM_NONE = 0
        MTERM_RET
        MTERM_BR
        MTERM_CONDBR
        MTERM_UNREACHABLE
    end enum

    enum MirValueKind
        MV_NONE = 0
        MV_TEMP           '' an instruction result
        MV_CONST_INT
        MV_CONST_FLOAT
        MV_LOCAL          '' the ADDRESS of a local slot
        MV_PARAM
        MV_GLOBAL
        MV_UNDEF
    end enum

    '' Eight bytes, per docs/plan/09 section 2.
    type MirValue
        as ubyte  kind          '' MirValueKind
        as ubyte  ty            '' MirType
        as ushort aggIdx        '' index into the module's aggregate table, MT_AGG only
        as ulong  id            '' temp/local/param/global index, or a constant index
    end type

    type MirValueVec as FB.Array( of MirValue )

    type MirInst
        as ushort   op          '' MirOp
        as ubyte    ty          '' result type
        as ubyte    _pad
        as ulong    result      '' temp id, or 0 when the opcode has no result
        as MirValue a
        as MirValue b
        as long     first       '' call arguments: into the module's argument pool
        as long     count
        as ulong    callee      '' M_CALL / M_CALL_RTL: index into functions/externs
        as longint  imm         '' M_CONST integer payload, M_ALLOCA slot index
        as double   fimm        '' M_CONST float payload
    end type

    type MirInstVec as FB.Array( of MirInst )

    '' A block OWNS its instructions. They cannot live in one per-function list with
    '' (first, count) extents: lowering opens the head, body and exit blocks of a loop
    '' before filling any of them, so instructions for different blocks interleave and
    '' no extent describes them.
    type MirBlock
        as InternId label
        as MirInstVec insts
        as ubyte    term        '' MirTermKind
        as MirValue cond        '' MTERM_CONDBR / MTERM_RET value
        as long     target      '' MTERM_BR, or the TRUE arm of MTERM_CONDBR
        as long     target2     '' the FALSE arm
    end type

    type MirBlockVec as FB.Array( of MirBlock )

    type MirLocal
        as InternId name
        as ubyte    ty
        as Tko.TypeId frontendType   '' kept for aggregate layout and for the dump
        as long     size
        '' The SYMBOL this slot belongs to, 0 for a compiler temporary. Slots are found
        '' by symbol and not by spelling: two variables called 'x' in sibling scopes of
        '' one procedure are two declarations, two symbols and two slots, and merging
        '' them on the name gave the second one the FIRST one's type. That is the same
        '' bug MirGlobal's table already carries a comment about, left unfixed here.
        '' A ulong, not a SymbolId: MIR does not include the symbol table, and
        '' should not start to for one field. SymbolId IS a ulong.
        as ulong    sym
    end type

    type MirLocalVec as FB.Array( of MirLocal )

    type MirFunction
        as InternId name            '' ALREADY MANGLED -- MIR never sees a source name
        as ubyte    retTy
        as long     paramCount
        as MirLocalVec locals
        as MirBlockVec blocks
        as long     nextTemp
        '' GCC's constructor / destructor attribute. fbc emits '_GLOBAL__I' and
        '' '_GLOBAL__D' with these, so module-lifetime objects are constructed before
        '' main and destroyed after it. A backend has to know which is which; the name
        '' alone is a convention, and this is not.
        as boolean  isModuleCtor
        as boolean  isModuleDtor
        as boolean  isDefinition    '' false for a declaration with no body
    end type

    type MirFunctionVec as FB.Array( of MirFunction ptr )

    '' A module-level datum: either a string literal's bytes, or a DIM SHARED variable.
    ''
    '' A shared variable is storage, not code. fbc emits 'static int32 H$ = 5;' -- the
    '' initialiser is part of the definition, not a store executed in main -- so the
    '' initial value is carried here rather than lowered into an instruction.
    type MirGlobal
        as InternId name
        as string   bytes          '' the literal's contents, NUL not included
        as boolean  isString
        '' A WIDE literal. 'bytes' still holds the SOURCE text; the width is applied
        '' when the bytes are emitted, because wchar is 2 bytes on Windows and 4 on
        '' Linux and baking one in here would make the IR target-specific.
        as boolean  isWide
        '' A DATA BLOCK: a packed array of { int16 TYPE; ptr NODE }, indexing the
        '' module's dataTypes / dataRefs pools. A ref of -1 is a null pointer; any
        '' other value is the index of the global whose ADDRESS goes in that slot,
        '' which is what makes the chain a relocation rather than a number.
        as boolean  isData
        as long     dataFirst
        as long     dataCount
        '' A POINTER TABLE: a run of pointer-sized words, each one a NULL, the
        '' ADDRESS OF ANOTHER GLOBAL, or the ADDRESS OF A FUNCTION. Both a vtable and
        '' an RTTI record are exactly that and nothing else, so one kind serves both
        '' rather than two that differ only in what they are called.
        ''
        '' It cannot reuse the DATA block: a data entry's ref is always a global, and
        '' a vtable's slots are FUNCTIONS -- by name, because the function may be
        '' declared in another module and have no index here.
        as boolean  isPtrTable
        as long     ptrFirst
        as long     ptrCount
        '' DECLARED HERE, DEFINED ELSEWHERE. 'object' has an RTTI record that fbc
        '' references and never emits -- 'extern struct $8fb_RTTI$ __fb_ZTS6Object' --
        '' because it lives in the runtime. Without saying so, an empty table would
        '' read as a real one with no entries.
        as boolean  isExternal
        as boolean  isVar
        as ubyte    ty             '' MirType, isVar only
        as Tko.TypeId frontendType
        as long     size
        as longint  initInt        '' compile-time initial value
        as double   initFlt
        '' AN AGGREGATE'S initial value, as the raw bytes of its storage. fbc emits
        '' 'static struct $1G G$1 = { 1u, 2, 3 };' -- a static UDT is initialised where
        '' it is DEFINED, not by a store somewhere -- and the field values with their
        '' offsets are exactly a byte image of the object.
        as string   initBytes
        as boolean  hasInit
    end type

    type MirGlobalVec as FB.Array( of MirGlobal )

    type MirModule
        as InternId ptr names
        as MirFunctionVec functions
        as MirGlobalVec globals
        '' The DATA blocks' entries, pooled: FB.Array by value inside a struct that
        '' itself lives in an FB.Array is a copy hazard, and there is nothing here
        '' that a flat pool does not express.
        as FB.Array( of long ) dataTypes
        as FB.Array( of long ) dataRefs
        '' A POINTER TABLE's entries, pooled beside the data blocks and for the same
        '' reason. Kind 0 is a null word, 1 a global's address (ref is its index) and
        '' 2 a function's address (ref is the InternId of its emitted name).
        as FB.Array( of long )  ptrKinds
        as FB.Array( of ulong ) ptrRefs
        as FB.Array( of ulong ) argPool     '' call arguments, as MirValue ids

        declare constructor( )
        declare destructor( )
        declare function AddFunction _
            ( byval nm as InternId, byval retTy as MirType ) as MirFunction ptr
        '' Identical literals share one global, which is smaller and is what fbc
        '' does -- two occurrences of the same text are one datum.
        declare function AddDataBlock( byref names as Interner ) as long
        declare sub PushDataEntry _
            ( byval g as long, byval ty as long, byval ref as long )
        declare function AddWideStringLiteral _
            ( byref text as string, byref names as Interner ) as long
        declare function AddStringLiteral _
            ( byref text as string, byref names as Interner ) as long
        '' A DIM SHARED variable. Unlike a literal these are never merged: two
        '' variables of the same value are still two variables.
        '' A vtable or an RTTI record. Named globals, never merged: two types with
        '' identical tables are still two tables, because their addresses are what
        '' tells one type from the other at run time.
        declare function AddPtrTable( byval nm as InternId ) as long
        declare sub PushPtrNull( byval g as long )
        declare sub PushPtrGlobal( byval g as long, byval which as long )
        declare sub PushPtrFunc( byval g as long, byval nm as InternId )
        declare function AddVarGlobal _
            ( byval nm as InternId, byval ty as MirType, byval ft as Tko.TypeId, _
              byval sizeBytes as long ) as long
    end type

    declare function TypeName( byval t as MirType ) as string
    declare function OpName( byval o as MirOp ) as string
    declare function OpArity( byval o as MirOp ) as long
    declare function OpHasResult( byval o as MirOp ) as boolean

    '' The MIR type a frontend type lowers to. Aggregates keep their TypeId.
    declare function LowerType _
        ( byval t as Tko.TypeId, byref types as Tko.TypeContext ) as MirType

end namespace

#endif

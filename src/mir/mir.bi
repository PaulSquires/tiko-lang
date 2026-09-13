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
        OP( M_ICMP_ULE,   "icmp.ule",   2, true  )
        OP( M_ICMP_UGE,   "icmp.uge",   2, true  )
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
        '' FLOAT to an UNSIGNED 64-BIT integer. fbc calls fb_D2UL / fb_F2UL for that
        '' one target and the SIGNED helper for every other -- measured:
        ''
        ''   culngint( d )  fb_D2UL( D )            cuint( d )   fb_D2UL( D )
        ''   culng( d )     (uint32)fb_D2L( D )     cushort( d ) (uint16)fb_D2I( D )
        ''
        '' -- because only at 64 bits does the unsigned range run past what a signed
        '' conversion can express: fptosi of 2^63 does not produce 9223372036854775808.
        OP( M_FPTOUI,     "fptoui",     1, true  )
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
    '' THE SysV EIGHTBYTE CLASSES of an aggregate, packed two bits each.
    ''
    '' Win64 classifies an aggregate by its SIZE and needs nothing else, which is why
    '' paramAggs holds a byte count. SysV cannot be answered from a size: '{int,int}'
    '' and '{float,float}' are both eight bytes and go in different register files.
    '' Its classifier needs to know what is IN each eightbyte -- field-level layout the
    '' backend does not have, and should not be given, because handing it the layout
    '' store back is exactly the coupling docs/plan/10 exists to prevent.
    ''
    '' So MIR carries the CONCLUSION rather than the evidence. The frontend has the
    '' layout store and works this out once, where it records the signature; two bits
    '' per eightbyte is the whole descriptor. Measured rules, in
    '' docs/internals/phase-8-sysv-abi.md: over sixteen bytes is MEMORY, otherwise an
    '' eightbyte is SSE when every field overlapping it is a float or a double and
    '' INTEGER otherwise, and a 'long double' forces MEMORY.
    const TKO_EB_NONE    as ulong = 0
    const TKO_EB_INTEGER as ulong = 1
    const TKO_EB_SSE     as ulong = 2
    const TKO_EB_MEMORY  as ulong = 3
    '' Eightbyte 0 in bits 0-1, eightbyte 1 in bits 2-3. MEMORY in eightbyte 0 means
    '' the whole aggregate, and nothing reads eightbyte 1 then.
    #define TKO_EB_PACK( c0, c1 )  ((c0) or ((c1) shl 2))
    #define TKO_EB0( p )           ((p) and 3)
    #define TKO_EB1( p )           (((p) shr 2) and 3)

    '' PARAMETER ATTRIBUTES. Not decoration -- each one CHANGES how the argument
    '' travels, and LLVM will not do it without being told.
    ''
    '' SRET marks the hidden result pointer. On win64 the callee must also return that
    '' pointer in RAX; a plain pointer parameter gets it into RCX correctly and leaves
    '' RAX undefined, which an fbc-compiled caller reads -- fbc's own C is
    '' 'struct T* vr = F( &tmp )'. So without this, tiko-lang's objects link against
    '' fbc's and then disagree about the return value.
    ''
    '' BYVAL marks a MEMORY-class aggregate on SysV, which is passed ON THE STACK by
    '' value. A plain pointer would pass an address in a register instead: a different
    '' ABI, not a different spelling.
    const TKO_PA_NONE  as ubyte = 0
    const TKO_PA_SRET  as ubyte = 1
    const TKO_PA_BYVAL as ubyte = 2

    '' THE CALLING CONVENTIONS. One on x86-64 -- they differ only in who cleans the
    '' stack, and on x86-64 nobody does -- but three in the source language and three on
    '' win32, so the distinction is recorded rather than collapsed at the point where it
    '' happens to make no difference.
    const TKO_CC_CDECL   as ubyte = 0
    const TKO_CC_STDCALL as ubyte = 1
    const TKO_CC_PASCAL  as ubyte = 2

    enum MirTermKind
        MTERM_NONE = 0
        MTERM_RET
        MTERM_BR
        MTERM_CONDBR
        MTERM_UNREACHABLE
        '' 'goto *p' -- the jump fb_ErrorThrowAt and the -e checks hand back. LLVM's
        '' 'indirectbr' must list every block the jump can reach, so the destinations
        '' are carried beside the value rather than being left implicit; without the
        '' list the verifier rejects the module and the optimiser may delete the
        '' handler as unreachable.
        MTERM_INDIRECTBR
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
        '' THE ADDRESS OF A BLOCK, for ON ERROR. 'id' is the block index within the
        '' function this value appears in -- LLVM's 'blockaddress(@fn, %label)', and
        '' GCC's '&&label', which is what fbc emits: 'fb_ErrorSetHandler( &&label$2 )'.
        '' It exists for exactly one purpose and is not a general address: a block
        '' address is only meaningful to the function that owns the block.
        MV_BLOCKADDR
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
        '' The SOURCE LINE of the statement it was lowered from, in the procedure's own
        '' file, 0 when unknown -- what '-g' writes as a DILocation. Not dumped.
        as long     dbgLine
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
        as MirValue ret2        '' MTERM_RET's second register, where retTy2 says so
        as long     target      '' MTERM_BR, or the TRUE arm of MTERM_CONDBR
        as long     target2     '' the FALSE arm
        '' MTERM_INDIRECTBR only: every block 'goto *p' may reach, as block indices.
        '' LLVM requires the list; see the enum.
        as FB.Array( of ulong ) indirectTargets
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
        '' ...and the same for an MT_AGG return, 0 otherwise. Same reason.
        as long     retSize
        '' ...and the return's, same encoding.
        as ulong    retClass
        '' THE SECOND RETURN REGISTER, MT_VOID for none. Only the ABI pass sets it: a
        '' SysV aggregate of nine to sixteen bytes comes back in two, and LLVM spells
        '' that '{ retTy, retTy2 }'. See codegen/abi.bas.
        as ubyte    retTy2
        '' Where the procedure is, for '-g': its file as FileId + 1 (0 for none) and
        '' the line it starts on. Instruction lines are only recorded in THAT file.
        as ulong    dbgFile
        as long     dbgLine
        as long     paramCount
        as MirLocalVec locals
        as MirBlockVec blocks
        as long     nextTemp
        '' GCC's constructor / destructor attribute. fbc emits '_GLOBAL__I' and
        '' '_GLOBAL__D' with these, so module-lifetime objects are constructed before
        '' main and destroyed after it. A backend has to know which is which; the name
        '' alone is a convention, and this is not.
        '' The ONLY way a parameter is added. Every site that used to write
        '' 'paramCount += 1' goes through here, so an arity can no longer be recorded
        '' without the type that belongs to it.
        declare sub AddParam _
            ( byval ty as MirType, byval aggSize as ulong = 0, _
              byval aggClass as ulong = 0, byval attr as ubyte = 0 )
        as boolean  isModuleCtor
        '' LOCAL LINKAGE -- 'internal' in LLVM, lowercase 't' to nm. A module
        '' constructor is file-scope in fbc, and it matters: two modules whose
        '' constructors were both global would collide on the ctor instead of on
        '' main, which is the same bug wearing a different name.
        as boolean  isPrivate
        '' EXPORT: emitted as 'dllexport', which is what puts the name in a DLL's
        '' export table. Independent of isPrivate -- a private procedure is not
        '' linker-visible at all, so the two cannot both be true.
        as boolean  isExported
        as boolean  isModuleDtor
        '' AN INSTANTIATED GENERIC, emitted by every unit that uses it. Its
        '' definition goes out with weak, foldable linkage so the duplicates
        '' collapse instead of failing the link.
        as boolean  isWeak
        as boolean  isDefinition    '' false for a declaration with no body
        '' THE SIGNATURE. docs/plan/09 gives every function and extern a signature and a
        '' calling convention; nothing consumed them until the backend, so until now only
        '' the ARITY was recorded. An LLVM 'declare' cannot be written from an arity --
        '' 'declare i32 @MessageBoxA()' is a different function from the real one -- and the
        '' ABI pass classifies each parameter by type, so both are needed here and not
        '' recoverable downstream: a DECLARATION has no locals to read them off.
        ''
        '' paramCount is 'paramTys.Count' and is maintained only through AddParam.
        as FB.Array( of ubyte ) paramTys        '' MirType, one per parameter
        '' THE SIZE IN BYTES of an MT_AGG parameter, 0 otherwise.
        ''
        '' The SIZE, not the frontend TypeId it used to hold. The ABI classifier's whole
        '' input is a byte count -- on win64 an aggregate is passed in a register if and
        '' only if its size is 1, 2, 4 or 8 -- and a TypeId would have forced the backend
        '' to ask the frontend's layout store a question, which is the coupling
        '' docs/plan/10 exists to avoid. The frontend knows the size when it records the
        '' signature; it writes it down there.
        as FB.Array( of ulong ) paramAggs
        '' ...and its SysV eightbyte classes, packed as above. Zero for a parameter
        '' that is not an aggregate, and unread on win64.
        as FB.Array( of ulong ) paramClasses
        '' ...and its attribute, TKO_PA_*. The attribute's TYPE comes from paramAggs,
        '' which is why that keeps holding the aggregate's size after the parameter
        '' itself has become a pointer.
        as FB.Array( of ubyte ) paramAttrs
        '' WHERE EACH PARAMETER CAME FROM, filled by the ABI pass.
        ''
        '' SysV turns one aggregate into TWO parameters, which shifts the index of every
        '' parameter after it -- and the body still refers to parameters by their
        '' ORIGINAL index. Without a map, '$1' silently becomes the second eightbyte of
        '' '$0'. paramOrig[new] is the original index (-1 for a parameter the pass
        '' invented, such as the sret pointer) and paramPart[new] is the byte offset
        '' within that original aggregate, so a prologue store knows which half it is
        '' writing and where it goes.
        as FB.Array( of long ) paramOrig
        as FB.Array( of long ) paramPart
        '' A VARIADIC TAIL. LLVM spells it '(i32, ...)' and a call to a variadic differs
        '' from a call to a fixed function at the ABI level -- on win64 a float argument in
        '' the tail goes in BOTH an XMM and a GPR -- so this is an ABI fact, not a spelling.
        '' THE FIRST PARAMETER IS THE HIDDEN RESULT POINTER. Recorded rather than
        '' re-derived, because "does this return through a hidden pointer" is NOT a
        '' property of the return type: 'operator cast' over a UDT with a destructor
        '' returns 'struct TU*' with NO hidden parameter -- fbc gives it a STATIC
        '' result instead -- while a member function returning the same type gets
        '' '( struct TU*, struct HOLDER* )'. Both were measured. A caller that asks
        '' the type instead of the callee gets the second answer for the first case
        '' and passes an argument nothing declared.
        as boolean  hasSretParam
        as boolean  isVariadic
        '' cdecl / stdcall / pascal. All three collapse on x86-64 and the emitted IR is the
        '' same, but the convention is still carried: it is part of the signature, win32 is
        '' a stated target, and dropping it here would make it unrecoverable later.
        as ubyte    callConv
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
        '' ...AND UTF-16 WHATEVER THE TARGET'S wchar, because a USTRING's units are
        '' 16 bits everywhere. Measured on Linux, where wchar is 4 bytes: fbc hands
        '' fb_UStrAssign '(uint16[]){...}' and fb_WstrAssign 'uint32*'. Set only by
        '' SplitUtf16Literals, on a twin of the wchar literal.
        as boolean  isUtf16
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
        '' A WIDE LITERAL'S CODE UNITS. 'bytes' holds the literal's SOURCE TEXT, which
        '' is what the dump prints and what one-byte-per-unit widening used to be
        '' derived from -- and that cannot hold a '\uXXXX' above 255 at all. The
        '' units are the VALUE; the text is for reading.
        as boolean  isPtrTable
        as long     ptrFirst
        as long     ptrCount
        as long     wcharFirst
        as long     wcharCount
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
        '' AN INITIAL VALUE THAT IS AN ADDRESS, not a number: 'static px as UDT ptr =
        '' @x' is a RELOCATION, which nothing here could express -- initInt holds a
        '' constant and initBytes a byte image, and the address of another global is
        '' neither. So every static pointer initialised from one declined.
        ''
        '' -1 when there is none. 'initRelocOff' is the byte offset added to it, for
        '' '@array( 2 )'; 'initRelocFn' names a FUNCTION instead, by name rather than
        '' by index, because it may be defined in another module -- the same reason a
        '' pointer table's function words are named.
        as long     initReloc
        as longint  initRelocOff
        as InternId initRelocFn
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
        '' Every wide literal's code units, pooled beside the data blocks and for the
        '' same reason: an FB.Array by value inside a struct that itself lives in an
        '' FB.Array is a copy hazard.
        as FB.Array( of ulong ) wcharPool
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
        '' ...FROM ITS DECODED CODE UNITS, which is the only form that can carry a
        '' '\uXXXX'. 'text' is kept for the dump and never read as the value.
        declare function AddWideStringUnits _
            ( byref text as string, byref units as FB.Array( of ulong ), _
              byref names as Interner ) as long
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
        '' Where wchar is not 16 bits: every wide literal handed to an fb_UStr* entry
        '' point is redirected to a UTF-16 twin of itself. Run once, after lowering.
        declare sub SplitUtf16Literals( byref names as Interner )
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

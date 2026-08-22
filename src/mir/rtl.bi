'' rtl.bi -- the ONE place that knows the runtime's interface.
''
'' docs/plan/11 section 3: no 'fb_StrAssign' string literal anywhere else in fbx. That
'' buys one place to audit against the runtime, signature checking at MIR construction
'' rather than a crash at run time, and a dumpable inventory that can be diffed
'' against the library's actual exports.
''
'' The signatures were MEASURED, not transcribed. fbc's own rtl-*.bas tables are
'' compiler source and are GPL -- and docs/plan/11 already flags the runtime licence
'' as a prerequisite for release -- so instead 'fbc -r' was used: the C intermediate
'' it leaves DECLARES every runtime function it calls. That is licence-clean and it is
'' better evidence, being what fbc actually emits rather than what a table says.
'' tools/gen/rtl-truth.py regenerates it and checks every name against libfb.a.

#ifndef __FBX_RTL_BI__
#define __FBX_RTL_BI__

#include once "fbx.bi"
#include once "mir/mir.bi"

namespace Fbx.Mir

    '' RTL( id, symbol, return type, parameter types )
    ''
    '' The parameter spelling is the MIR type letters, so a mismatch at a call site is
    '' a build-time failure rather than a linker error:
    ''   v void   b i8   s i16   l i32   q i64   f f32   d f64   p ptr
    ''   z POINTER-WIDTH -- 'ssize_t', i64 on win64 and i32 on win32
    ''
    '' 'z' is the reason the return column is a letter too. fb_StrLen returns a length,
    '' which follows the pointer: 'int64' on win64 and 'int32' on win32, measured from
    '' what fbc declares. Only the two PrintLongint entries keep a genuine 'q'.
    ''   '.' marks a VARIADIC tail: a REDIM's bounds are passed as a variable number
    ''   of trailing arguments, so only the fixed prefix can be checked.
    ''
    '' A var-length string is passed as a POINTER TO ITS DESCRIPTOR with a length of
    '' -1; a literal is passed as its bytes with the real length. That convention is
    '' why every string entry takes (ptr, i64) pairs rather than one argument.
    #macro FBX_RTL_LIST( RTL )
        '' The program entry pair. fbc emits these ONLY for the main translation unit:
        '' fb_Init before the module-level body, fb_End after its cleanups.
        RTL( RTL_INIT,              "fb_Init",             "v",   "lpl"   )
        RTL( RTL_END,               "fb_End",              "v",   "l"     )
        '' Same argument shape as fb_StrAssign, but for a DECLARATION with an
        '' initialiser. fbc uses Init there and Assign only for a later store; a local
        '' with no initialiser instead gets its 24-byte descriptor zeroed.
        RTL( RTL_STR_INIT,          "fb_StrInit",          "p",   "pzpzl" )
        RTL( RTL_STR_ASSIGN,        "fb_StrAssign",        "p",   "pzpzl" )
        RTL( RTL_STR_CONCAT_ASSIGN, "fb_StrConcatAssign",  "p",   "pzpzl" )
        RTL( RTL_STR_CONCAT,        "fb_StrConcat",        "p",   "ppzpz"  )
        RTL( RTL_STR_COMPARE,       "fb_StrCompare",       "l",   "pzpz"  )
        RTL( RTL_STR_DELETE,        "fb_StrDelete",        "v",   "p"     )
        '' SWAP of two strings. Six arguments, not four: each side is (ptr, length,
        '' flag) where the flag is 0 -- the same shape fb_StrAssign uses plus a trailing
        '' word per operand.
        RTL( RTL_STR_SWAP,          "fb_StrSwap",          "v",   "pzlpzl" )
        RTL( RTL_WSTR_SWAP,         "fb_WstrSwap",         "v",   "pzpz"  )
        '' WIDE STRINGS. A wstring VALUE is always a bare uint16* -- there is no
        '' descriptor type, and no var-length wstring exists at all ('dim as wstring w'
        '' is fbc error 28). So none of this needs a wide analogue of fb_StrInit or of
        '' scope cleanup; only the temporaries these return need fb_WstrDelete.
        ''
        '' The (dst, dstlen) pair takes the declared ELEMENT COUNT, not bytes. Where a
        '' NARROW operand appears it uses the ordinary (void*, len) convention: a
        '' literal passes its byte length INCLUDING the NUL, a descriptor passes -1.
        RTL( RTL_WSTR_ASSIGN,       "fb_WstrAssign",       "p",   "pzp"   )
        RTL( RTL_WSTR_ASSIGN_FROMA, "fb_WstrAssignFromA",  "p",   "pzpz"  )
        RTL( RTL_WSTR_ASSIGN_TOA,   "fb_WstrAssignToA",    "p",   "pzpl"  )
        RTL( RTL_WSTR_DELETE,       "fb_WstrDelete",       "v",   "p"     )
        RTL( RTL_WSTR_LEN,          "fb_WstrLen",          "z",   "p"     )
        '' No lengths, unlike the narrow fb_StrCompare, and an int32 result that fbc
        '' widens before testing. One function covers all six operators.
        RTL( RTL_WSTR_COMPARE,      "fb_WstrCompare",      "l",   "pp"    )
        RTL( RTL_WSTR_CONCAT,       "fb_WstrConcat",       "p",   "pp"    )
        RTL( RTL_WSTR_CONCAT_WA,    "fb_WstrConcatWA",     "p",   "ppz"   )
        RTL( RTL_WSTR_CONCAT_AW,    "fb_WstrConcatAW",     "p",   "pzp"   )
        RTL( RTL_WSTR_CONCAT_ASSIGN,"fb_WstrConcatAssign", "p",   "pzp"   )
        RTL( RTL_PRINT_WSTR,        "fb_PrintWstr",        "v",   "lpl"   )
        '' byte/short widen to int32 and ubyte/ushort to uint32; there are no
        '' per-width entries.
        RTL( RTL_INT_TO_WSTR,       "fb_IntToWstr",        "p",   "l"     )
        RTL( RTL_UINT_TO_WSTR,      "fb_UIntToWstr",       "p",   "l"     )
        RTL( RTL_LONGINT_TO_WSTR,   "fb_LongintToWstr",    "p",   "q"     )
        RTL( RTL_ULONGINT_TO_WSTR,  "fb_ULongintToWstr",   "p",   "q"     )
        RTL( RTL_FLOAT_TO_WSTR,     "fb_FloatToWstr",      "p",   "f"     )
        RTL( RTL_DOUBLE_TO_WSTR,    "fb_DoubleToWstr",     "p",   "d"     )
        '' Takes a RAW char*, not a descriptor: fbc dereferences the descriptor's data
        '' field at the call site.
        RTL( RTL_STR_TO_WSTR,       "fb_StrToWstr",        "p",   "p"     )
        RTL( RTL_WSTR_TO_STR,       "fb_WstrToStr",        "p",   "p"     )
        '' The wide substring and trim families. Every one RETURNS A TEMPORARY that
        '' fbc releases with fb_WstrDelete; fbx does not model that lifetime yet, so
        '' each call leaks one -- stated rather than hidden.
        ''
        '' Note the ARGUMENT ORDERS ARE NOT UNIFORM and were measured one by one:
        '' instr takes its start FIRST, instrrev takes it LAST, and 'mid' with no
        '' length passes -1 rather than 0.
        RTL( RTL_WSTR_TRIM,         "fb_WstrTrim",         "p",   "p"     )
        RTL( RTL_WSTR_TRIM_ANY,     "fb_WstrTrimAny",      "p",   "pp"    )
        RTL( RTL_WSTR_TRIM_EX,      "fb_WstrTrimEx",       "p",   "pp"    )
        RTL( RTL_WSTR_LTRIM,        "fb_WstrLTrim",        "p",   "p"     )
        RTL( RTL_WSTR_LTRIM_ANY,    "fb_WstrLTrimAny",     "p",   "pp"    )
        RTL( RTL_WSTR_LTRIM_EX,     "fb_WstrLTrimEx",      "p",   "pp"    )
        RTL( RTL_WSTR_RTRIM,        "fb_WstrRTrim",        "p",   "p"     )
        RTL( RTL_WSTR_RTRIM_ANY,    "fb_WstrRTrimAny",     "p",   "pp"    )
        RTL( RTL_WSTR_RTRIM_EX,     "fb_WstrRTrimEx",      "p",   "pp"    )
        RTL( RTL_WSTR_LEFT,         "fb_WstrLeft",         "p",   "pz"    )
        RTL( RTL_WSTR_RIGHT,        "fb_WstrRight",        "p",   "pz"    )
        RTL( RTL_WSTR_MID,          "fb_WstrMid",          "p",   "pzz"   )
        RTL( RTL_WSTR_UCASE,        "fb_WstrUcase2",       "p",   "pl"    )
        RTL( RTL_WSTR_LCASE,        "fb_WstrLcase2",       "p",   "pl"    )
        RTL( RTL_MEM_SWAP,          "fb_MemSwap",          "v",   "ppz"   )
        RTL( RTL_STR_LEN,           "fb_StrLen",           "z",   "pz"    )
        RTL( RTL_STR_MID,           "fb_StrMid",           "p",   "pzz"   )
        RTL( RTL_STR_LEFT,          "fb_LEFT",             "p",   "pz"    )
        '' The NARROW substring and trim family. Each returns an FBSTRING* the runtime
        '' owns and that fbc NEVER deletes -- unlike the wide family, there is no
        '' lifetime to model here at all.
        ''
        '' The spellings are NOT consistent and were read off fbc one by one: the four
        '' bare forms and LEFT/RIGHT are SHOUTED, while the Ex/Any variants, mid and
        '' the two case entries are mixed-case with a different prefix.
        RTL( RTL_STR_RIGHT,         "fb_RIGHT",            "p",   "pz"    )
        RTL( RTL_STR_TRIM,          "fb_TRIM",             "p",   "p"     )
        RTL( RTL_STR_TRIM_EX,       "fb_TrimEx",           "p",   "pp"    )
        RTL( RTL_STR_TRIM_ANY,      "fb_TrimAny",          "p",   "pp"    )
        RTL( RTL_STR_LTRIM,         "fb_LTRIM",            "p",   "p"     )
        RTL( RTL_STR_LTRIM_EX,      "fb_LTrimEx",          "p",   "pp"    )
        RTL( RTL_STR_LTRIM_ANY,     "fb_LTrimAny",         "p",   "pp"    )
        RTL( RTL_STR_RTRIM,         "fb_RTRIM",            "p",   "p"     )
        RTL( RTL_STR_RTRIM_EX,      "fb_RTrimEx",          "p",   "pp"    )
        RTL( RTL_STR_RTRIM_ANY,     "fb_RTrimAny",         "p",   "pp"    )
        RTL( RTL_STR_UCASE,         "fb_StrUcase2",        "p",   "pl"    )
        RTL( RTL_STR_LCASE,         "fb_StrLcase2",        "p",   "pl"    )

        '' DATA / READ / RESTORE. The DESTINATION TYPE alone picks the entry point;
        '' there is no mask and no channel. INTEGER and UINTEGER are target-dependent
        '' and the inventory cannot say so, so lowering picks between Int and Longint.
        RTL( RTL_DATA_RESTORE,      "fb_DataRestore",      "v",   "p"     )
        RTL( RTL_DATA_READ_STR,     "fb_DataReadStr",      "v",   "pzl"   )
        RTL( RTL_DATA_READ_WSTR,    "fb_DataReadWstr",     "v",   "pz"    )
        RTL( RTL_DATA_READ_BOOL,    "fb_DataReadBool",     "v",   "p"     )
        RTL( RTL_DATA_READ_BYTE,    "fb_DataReadByte",     "v",   "p"     )
        RTL( RTL_DATA_READ_UBYTE,   "fb_DataReadUByte",    "v",   "p"     )
        RTL( RTL_DATA_READ_SHORT,   "fb_DataReadShort",    "v",   "p"     )
        RTL( RTL_DATA_READ_USHORT,  "fb_DataReadUShort",   "v",   "p"     )
        RTL( RTL_DATA_READ_INT,     "fb_DataReadInt",      "v",   "p"     )
        RTL( RTL_DATA_READ_UINT,    "fb_DataReadUInt",     "v",   "p"     )
        RTL( RTL_DATA_READ_LONGINT, "fb_DataReadLongint",  "v",   "p"     )
        RTL( RTL_DATA_READ_ULONGINT,"fb_DataReadULongint", "v",   "p"     )
        RTL( RTL_DATA_READ_SINGLE,  "fb_DataReadSingle",   "v",   "p"     )
        RTL( RTL_DATA_READ_DOUBLE,  "fb_DataReadDouble",   "v",   "p"     )
        RTL( RTL_STR_TEMPZ,         "fb_StrAllocTempDescZEx", "p",  "pz"  )
        '' The same thing without a length: a NUL-terminated char* whose length the
        '' runtime works out. That is what a ZSTRING destination borrows for LSET.
        RTL( RTL_STR_TEMPZ_NOLEN,   "fb_StrAllocTempDescZ", "p",   "p"     )
        '' A STRING RESULT. fbc builds the value in a local descriptor and hands the
        '' runtime that descriptor on the way out; what the function actually returns
        '' is the POINTER this gives back, not the descriptor itself.
        RTL( RTL_STR_TEMP_RESULT,   "fb_StrAllocTempResult", "p",   "p"     )
        RTL( RTL_VALINT,            "fb_VALINT",           "l",   "p"     )
        '' PRINT has NO generic entry point: every scalar type has its own, and the
        '' third argument is a SEPARATOR MASK -- 0 nothing, 1 newline, 2 tab --
        '' describing what follows that item. A POINTER has no entry of its own and
        '' goes through fb_PrintULongint.
        RTL( RTL_PRINT_STRING,      "fb_PrintString",      "v",   "lpl"   )
        RTL( RTL_PRINT_VOID,        "fb_PrintVoid",        "v",   "ll"    )
        RTL( RTL_PRINT_BYTE,        "fb_PrintByte",        "v",   "lbl"   )
        RTL( RTL_PRINT_UBYTE,       "fb_PrintUByte",       "v",   "lbl"   )
        RTL( RTL_PRINT_SHORT,       "fb_PrintShort",       "v",   "lsl"   )
        RTL( RTL_PRINT_USHORT,      "fb_PrintUShort",      "v",   "lsl"   )
        RTL( RTL_PRINT_INT,         "fb_PrintInt",         "v",   "lll"   )
        RTL( RTL_PRINT_UINT,        "fb_PrintUInt",        "v",   "lll"   )
        RTL( RTL_PRINT_LONGINT,     "fb_PrintLongint",     "v",   "lql"   )
        RTL( RTL_PRINT_ULONGINT,    "fb_PrintULongint",    "v",   "lql"   )
        RTL( RTL_PRINT_SINGLE,      "fb_PrintSingle",      "v",   "lfl"   )
        RTL( RTL_PRINT_DOUBLE,      "fb_PrintDouble",      "v",   "ldl"   )
        RTL( RTL_PRINT_BOOL,        "fb_PrintBool",        "v",   "lbl"   )

        '' WRITE is one-to-one with PRINT minus SPC, TAB and USING. Its only separator
        '' is ',' -- 'write s;' is fbc error 3 -- so its masks are only 2 and 1.
        RTL( RTL_WRITE_VOID,        "fb_WriteVoid",        "v",   "ll"    )
        RTL( RTL_WRITE_BOOL,        "fb_WriteBool",        "v",   "lbl"   )
        RTL( RTL_WRITE_BYTE,        "fb_WriteByte",        "v",   "lbl"   )
        RTL( RTL_WRITE_UBYTE,       "fb_WriteUByte",       "v",   "lbl"   )
        RTL( RTL_WRITE_SHORT,       "fb_WriteShort",       "v",   "lsl"   )
        RTL( RTL_WRITE_USHORT,      "fb_WriteUShort",      "v",   "lsl"   )
        RTL( RTL_WRITE_INT,         "fb_WriteInt",         "v",   "lll"   )
        RTL( RTL_WRITE_UINT,        "fb_WriteUInt",        "v",   "lll"   )
        RTL( RTL_WRITE_LONGINT,     "fb_WriteLongint",     "v",   "lql"   )
        RTL( RTL_WRITE_ULONGINT,    "fb_WriteULongint",    "v",   "lql"   )
        RTL( RTL_WRITE_SINGLE,      "fb_WriteSingle",      "v",   "lfl"   )
        RTL( RTL_WRITE_DOUBLE,      "fb_WriteDouble",      "v",   "ldl"   )
        RTL( RTL_WRITE_STRING,      "fb_WriteString",      "v",   "lpl"   )
        RTL( RTL_WRITE_WSTR,        "fb_WriteWstr",        "v",   "lpl"   )

        '' LSET and RSET pad or truncate a string INTO a destination that already has
        '' storage. Both take DESCRIPTORS; a zstring destination borrows a temporary
        '' one and a wide destination has its own pair of entries.
        RTL( RTL_STR_LSET,          "fb_StrLset",          "v",   "pp"    )
        RTL( RTL_STR_RSET,          "fb_StrRset",          "v",   "pp"    )
        RTL( RTL_WSTR_LSET,         "fb_WstrLset",         "v",   "pp"    )
        RTL( RTL_WSTR_RSET,         "fb_WstrRset",         "v",   "pp"    )
        '' ARRAY DESCRIPTOR routines. Only the ones a FIXED array needs are here; the
        '' four variadic Redim* entries wait until dynamic arrays are modelled, and
        '' they are the only array routines that are CDECL on win32.
        RTL( RTL_ARRAY_CLEAR,       "fb_ArrayClear",       "l",   "p"     )
        RTL( RTL_ARRAY_CLEAR_OBJ,   "fb_ArrayClearObj",    "l",   "ppp"   )
        RTL( RTL_ARRAY_DESTRUCT_STR,"fb_ArrayDestructStr", "v",   "p"     )
        RTL( RTL_ARRAY_DESTRUCT_OBJ,"fb_ArrayDestructObj", "v",   "pp"    )
        RTL( RTL_ARRAY_ERASE_OBJ,   "fb_ArrayEraseObj",    "l",   "ppp"   )
        RTL( RTL_ARRAY_STR_ERASE,   "fb_ArrayStrErase",    "v",   "p"     )
        RTL( RTL_ARRAY_LBOUND,      "fb_ArrayLBound",      "z",   "pz"    )
        RTL( RTL_ARRAY_UBOUND,      "fb_ArrayUBound",      "z",   "pz"    )
        '' SPC and TAB take NO MASK, so 'print spc(n);' emits one call and nothing
        '' else -- no newline, no fb_PrintVoid. Note the argument widths: SPC's count
        '' is ssize (64-bit on win64, 32 on win32) and TAB's is int32 on BOTH. That
        '' asymmetry is measured, not a transcription slip.
        RTL( RTL_PRINT_SPC,         "fb_PrintSPC",         "v",   "lz"    )
        RTL( RTL_PRINT_TAB,         "fb_PrintTab",         "v",   "ll"    )

        '' PRINT USING. Init takes ONLY the format descriptor -- no channel -- while
        '' every item call and End take the channel first. Unlike PRINT there is no
        '' per-width entry point: every integral type widens to 64 bits.
        RTL( RTL_USING_INIT,        "fb_PrintUsingInit",   "l",   "p"     )
        RTL( RTL_USING_STR,         "fb_PrintUsingStr",    "l",   "lpl"   )
        RTL( RTL_USING_WSTR,        "fb_PrintUsingWstr",   "l",   "lpl"   )
        RTL( RTL_USING_SINGLE,      "fb_PrintUsingSingle", "l",   "lfl"   )
        RTL( RTL_USING_DOUBLE,      "fb_PrintUsingDouble", "l",   "ldl"   )
        RTL( RTL_USING_LONGINT,     "fb_PrintUsingLongint","l",   "lql"   )
        RTL( RTL_USING_ULONGINT,    "fb_PrintUsingULongint","l",  "lql"   )
        RTL( RTL_USING_BOOLEAN,     "fb_PrintUsingBoolean","l",   "lbl"   )
        RTL( RTL_USING_END,         "fb_PrintUsingEnd",    "l",   "l"     )
        RTL( RTL_ARRAY_ERASE,       "fb_ArrayErase",       "l",   "p"     )
        RTL( RTL_ARRAY_REDIM,       "fb_ArrayRedimEx",     "l",   "pzllz." )
        RTL( RTL_ARRAY_REDIM_PRESV, "fb_ArrayRedimPresvEx", "l",  "pzllz." )
        '' The Obj forms take a CONSTRUCTOR and a DESTRUCTOR pointer where the Ex
        '' forms take two integers. Which pair fbc uses is decided by whether the
        '' element type has either -- IMPLICIT ONES INCLUDED, so a POD UDT takes Ex
        '' and a UDT holding a string takes Obj.
        RTL( RTL_ARRAY_REDIM_OBJ,   "fb_ArrayRedimObj",    "l",   "pzppz." )
        RTL( RTL_ARRAY_REDIM_PRESV_OBJ, "fb_ArrayRedimPresvObj", "l", "pzppz." )
        RTL( RTL_FILE_OPEN,         "fb_FileOpen",         "l",   "pllllL" )
        RTL( RTL_FILE_CLOSE,        "fb_FileClose",        "l",   "l"     )
        RTL( RTL_FILE_CLOSEALL,     "fb_FileCloseAll",     "l",   ""      )
        '' Returns the ADDRESS to jump to when a handler is installed, which is why its
        '' return type is a pointer and not void. fbx installs none -- ON ERROR is not
        '' implemented -- so the call never returns and the block ends unreachable.
        RTL( RTL_ERROR_THROW,       "fb_ErrorThrowEx",     "p",   "llppp" )
        '' LIBC, not the FB runtime, and named exactly that: fbc emits a plain
        '' 'free( p )' for DELETE rather than routing it through fb_*. It is cdecl on
        '' every target, so RtlLinkName must not decorate it either.
        RTL( RTL_FREE,              "free",                "v",   "p"     )
        '' The rest of libc's allocator, reached through FreeBASIC's own built-in
        '' procedures: 'allocate' is malloc, 'callocate' calloc, 'reallocate' realloc.
        '' 'callocate( n )' with one argument passes an element size of 1.
        RTL( RTL_MALLOC,            "malloc",              "p",   "z"     )
        RTL( RTL_CALLOC,            "calloc",              "p",   "zz"    )
        RTL( RTL_REALLOC,           "realloc",             "p",   "pz"    )
        '' 'clear dst, value, bytes' is libc memset. Measured: fbc emits
        '' 'memset( (void*)A, 0, 16ull )' for the general form.
        RTL( RTL_MEMSET,            "memset",              "p",   "plz"   )
        '' Mutexes. All four are ordinary stdcall entries on win32.
        RTL( RTL_MUTEX_CREATE,      "fb_MutexCreate",      "p",   ""      )
        RTL( RTL_MUTEX_DESTROY,     "fb_MutexDestroy",     "v",   "p"     )
        RTL( RTL_MUTEX_LOCK,        "fb_MutexLock",        "v",   "p"     )
        RTL( RTL_MUTEX_UNLOCK,      "fb_MutexUnlock",      "v",   "p"     )
        '' fbc PREDECLARES this one -- a program may call it with no declaration in
        '' sight, which is how the COM tests reach it through their own assert_ macro.
        RTL( RTL_ASSERT,            "fb_Assert",           "v",   "pzpp"  )
        RTL( RTL_FILE_LINEINPUT,    "fb_FileLineInput",    "l",   "lpzl"  )
        '' INPUT. One "start" call, then one call per destination, each passed BY
        '' ADDRESS. The start is fb_ConsoleInput( promptDesc, addQuestion, echoNewline )
        '' -- the prompt is always passed, as a temp descriptor, empty when absent --
        '' or fb_FileInput( n ) for the '#n' form.
        ''
        '' LINE INPUT is different again: ONE call with the destination inside it.
        ''
        '' NOTE THE CASING. The runtime spells these Ubyte/Ushort/Uint/Ulongint with a
        '' lowercase second letter, where the fb_Print family above uses UByte and
        '' ULongint. Copying the Print casing produces a link error.
        RTL( RTL_CONSOLE_INPUT,     "fb_ConsoleInput",     "l",   "pll"   )
        RTL( RTL_FILE_INPUT,        "fb_FileInput",        "l",   "l"     )
        RTL( RTL_LINEINPUT,         "fb_LineInput",        "l",   "ppzlll" )
        RTL( RTL_INPUT_BYTE,        "fb_InputByte",        "l",   "p"     )
        RTL( RTL_INPUT_UBYTE,       "fb_InputUbyte",       "l",   "p"     )
        RTL( RTL_INPUT_SHORT,       "fb_InputShort",       "l",   "p"     )
        RTL( RTL_INPUT_USHORT,      "fb_InputUshort",      "l",   "p"     )
        RTL( RTL_INPUT_INT,         "fb_InputInt",         "l",   "p"     )
        RTL( RTL_INPUT_UINT,        "fb_InputUint",        "l",   "p"     )
        RTL( RTL_INPUT_LONGINT,     "fb_InputLongint",     "l",   "p"     )
        RTL( RTL_INPUT_ULONGINT,    "fb_InputUlongint",    "l",   "p"     )
        RTL( RTL_INPUT_SINGLE,      "fb_InputSingle",      "l",   "p"     )
        RTL( RTL_INPUT_DOUBLE,      "fb_InputDouble",      "l",   "p"     )
        RTL( RTL_INPUT_STRING,      "fb_InputString",      "l",   "pzl"   )
        RTL( RTL_INPUT_WSTR,        "fb_InputWstr",        "l",   "pz"    )
    #endmacro

    enum RtlId
        RTL_NONE = 0
        #define RTL( r_id, r_sym, r_ret, r_args ) r_id,
        FBX_RTL_LIST( RTL )
        #undef RTL
        RTL_COUNT
    end enum

    '' The UNDECORATED name. win32 adds a leading underscore and, for everything but
    '' the variadic entries, a stdcall '@N' -- measured, '_fb_StrAssign@20'.
    declare function RtlTypeOfLetter _
        ( byref c as string, byval is32 as boolean ) as MirType
    declare function RtlSymbol( byval r as RtlId ) as string
    declare function RtlLinkName _
        ( byval r as RtlId, byval is32 as boolean ) as string
    '' 'is32' is win32: Linux is 64-bit only by decision.
    declare function RtlReturn( byval r as RtlId, byval is32 as boolean ) as MirType
    declare function RtlParams( byval r as RtlId ) as string
    declare function RtlByName( byref nm as string ) as RtlId
    declare function RtlArity( byval r as RtlId ) as long
    declare function RtlParamType _
        ( byval r as RtlId, byval i as long, byval is32 as boolean ) as MirType

    '' The whole inventory, for --dump-rtl and for the differential against the
    '' signatures fbc emits.
    declare function DumpRtl( byval is32 as boolean ) as string

end namespace

#endif

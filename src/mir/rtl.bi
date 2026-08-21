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
        RTL( RTL_MEM_SWAP,          "fb_MemSwap",          "v",   "ppz"   )
        RTL( RTL_STR_LEN,           "fb_StrLen",           "z",   "pz"    )
        RTL( RTL_STR_MID,           "fb_StrMid",           "p",   "pzz"   )
        RTL( RTL_STR_LEFT,          "fb_LEFT",             "p",   "pz"    )
        RTL( RTL_STR_TEMPZ,         "fb_StrAllocTempDescZEx", "p",  "pz"  )
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
        RTL( RTL_ARRAY_ERASE,       "fb_ArrayErase",       "l",   "p"     )
        RTL( RTL_ARRAY_REDIM,       "fb_ArrayRedimEx",     "l",   "pzllz." )
        RTL( RTL_ARRAY_REDIM_PRESV, "fb_ArrayRedimPresvEx", "l",  "pzllz." )
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

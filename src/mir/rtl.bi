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
        RTL( RTL_STR_LEN,           "fb_StrLen",           "z",   "pz"    )
        RTL( RTL_STR_MID,           "fb_StrMid",           "p",   "pzz"   )
        RTL( RTL_STR_LEFT,          "fb_LEFT",             "p",   "pz"    )
        RTL( RTL_STR_TEMPZ,         "fb_StrAllocTempDescZEx", "p",  "pz"  )
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
        RTL( RTL_FILE_LINEINPUT,    "fb_FileLineInput",    "l",   "lpzl"  )
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
    declare function RtlArity( byval r as RtlId ) as long
    declare function RtlParamType _
        ( byval r as RtlId, byval i as long, byval is32 as boolean ) as MirType

    '' The whole inventory, for --dump-rtl and for the differential against the
    '' signatures fbc emits.
    declare function DumpRtl( byval is32 as boolean ) as string

end namespace

#endif

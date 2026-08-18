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
    ''   '.' marks a VARIADIC tail: a REDIM's bounds are passed as a variable number
    ''   of trailing arguments, so only the fixed prefix can be checked.
    ''
    '' A var-length string is passed as a POINTER TO ITS DESCRIPTOR with a length of
    '' -1; a literal is passed as its bytes with the real length. That convention is
    '' why every string entry takes (ptr, i64) pairs rather than one argument.
    #macro FBX_RTL_LIST( RTL )
        RTL( RTL_STR_ASSIGN,        "fb_StrAssign",        MT_PTR,  "pqpql" )
        RTL( RTL_STR_CONCAT_ASSIGN, "fb_StrConcatAssign",  MT_PTR,  "pqpql" )
        RTL( RTL_STR_CONCAT,        "fb_StrConcat",        MT_PTR,  "ppqpq"  )
        RTL( RTL_STR_COMPARE,       "fb_StrCompare",       MT_I32,  "pqpq"  )
        RTL( RTL_STR_DELETE,        "fb_StrDelete",        MT_VOID, "p"     )
        RTL( RTL_STR_LEN,           "fb_StrLen",           MT_I64,  "pq"    )
        RTL( RTL_STR_MID,           "fb_StrMid",           MT_PTR,  "pqq"   )
        RTL( RTL_STR_LEFT,          "fb_LEFT",             MT_PTR,  "pq"    )
        RTL( RTL_STR_TEMPZ,         "fb_StrAllocTempDescZEx", MT_PTR, "pq"  )
        RTL( RTL_VALINT,            "fb_VALINT",           MT_I32,  "p"     )
        RTL( RTL_PRINT_STRING,      "fb_PrintString",      MT_VOID, "lpl"   )
        RTL( RTL_PRINT_LONGINT,     "fb_PrintLongint",     MT_VOID, "lql"   )
        RTL( RTL_PRINT_VOID,        "fb_PrintVoid",        MT_VOID, "ll"    )
        RTL( RTL_ARRAY_ERASE,       "fb_ArrayErase",       MT_I32,  "p"     )
        RTL( RTL_ARRAY_REDIM,       "fb_ArrayRedimEx",     MT_I32,  "pqllq." )
        RTL( RTL_ARRAY_REDIM_PRESV, "fb_ArrayRedimPresvEx", MT_I32, "pqllq." )
        RTL( RTL_FILE_OPEN,         "fb_FileOpen",         MT_I32,  "pllllL" )
        RTL( RTL_FILE_CLOSE,        "fb_FileClose",        MT_I32,  "l"     )
        RTL( RTL_FILE_LINEINPUT,    "fb_FileLineInput",    MT_I32,  "lpql"  )
    #endmacro

    enum RtlId
        RTL_NONE = 0
        #define RTL( r_id, r_sym, r_ret, r_args ) r_id,
        FBX_RTL_LIST( RTL )
        #undef RTL
        RTL_COUNT
    end enum

    declare function RtlSymbol( byval r as RtlId ) as string
    declare function RtlReturn( byval r as RtlId ) as MirType
    declare function RtlParams( byval r as RtlId ) as string
    declare function RtlArity( byval r as RtlId ) as long
    declare function RtlParamType( byval r as RtlId, byval i as long ) as MirType

    '' The whole inventory, for --dump-rtl and for the differential against the
    '' signatures fbc emits.
    declare function DumpRtl( ) as string

end namespace

#endif

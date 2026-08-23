'' intrinsics.bi -- THE intrinsic registry.
''
'' fbc spends 6,708 lines across 17 'parser-quirk-*.bas' files on statements that look
'' like syntax but are really calls with bespoke grammar. docs/plan/04 section 5 says
'' to treat them as DATA, and this is that table.
''
'' The 114 keywords fbc classes as "quirk" are not one thing. They are three:
''
''   IFORM_EXPR      an expression function -- LEN, ASC, VARPTR, SIN. These must NOT
''                   be treated as statement starters; they only appear in expressions.
''   IFORM_CONTEXT   a modifier that only appears INSIDE another construct -- ACCESS,
''                   APPEND, BINARY, OUTPUT, PRESERVE. Never a statement either.
''   IFORM_*         everything else: a real statement, either generic (name followed
''                   by a comma-separated expression list) or with its own grammar.
''
'' Getting the first two groups wrong is what makes 'dim l as long = len(s)' parse as
'' a LEN statement. The classification is the point of the table.

#ifndef __TKO_INTRINSICS_BI__
#define __TKO_INTRINSICS_BI__

#include once "lexer/token.bi"

namespace Tko

    enum IntrinsicForm
        IFORM_NONE = 0
        IFORM_EXPR          '' expression function; not a statement
        IFORM_CONTEXT       '' modifier inside another construct; not a statement
        IFORM_GENERIC       '' NAME arg, arg, arg
        IFORM_NOARGS        '' NAME
        IFORM_PRINT         '' PRINT/LPRINT/WRITE: #n, ';' ',' SPC TAB USING
        IFORM_INPUT         '' INPUT/WINPUT: [#n,] [prompt;] var, var
        IFORM_LINE          '' LINE INPUT, and the graphics LINE
        IFORM_OPEN          '' OPEN f FOR mode ACCESS a AS #n
        IFORM_FILENUM       '' CLOSE/SEEK/LOCK/UNLOCK: #n [, expr]
        IFORM_GETPUT        '' GET/PUT: file form and graphics form share a keyword
        IFORM_DATA          '' DATA: a comma-separated list of literals
        IFORM_ON            '' ON expr GOTO/GOSUB list, ON ERROR GOTO label
        IFORM_SWAP          '' SWAP a, b
        IFORM_NAME          '' NAME old AS new
        IFORM_DEFTYPE       '' DEFINT A-Z
        IFORM_GFX           '' PSET/PRESET/CIRCLE/PAINT/DRAW/VIEW/WINDOW/PALETTE/...
        IFORM_UNSUPPORTED   '' GOSUB, RESUME: not in -lang fb (probes D1, D2)
        IFORM_CVA_ARG       '' cva_arg( list, TYPE ) -- the second argument is a type
        IFORM_DECLARED      '' OPTION, REDIM: parsed by the declaration layer instead
    end enum

    '' INTR( token kind, form )
    #macro TKO_INTRINSIC_LIST( INTR )
        '' ---- expression functions: NOT statements
        INTR( KW_ACOS,        IFORM_EXPR )
        INTR( KW_ASC,         IFORM_EXPR )
        INTR( KW_ASIN,        IFORM_EXPR )
        INTR( KW_ATAN2,       IFORM_EXPR )
        INTR( KW_ATN,         IFORM_EXPR )
        INTR( KW_CHR,         IFORM_EXPR )
        INTR( KW_COS,         IFORM_EXPR )
        INTR( KW_CVD,         IFORM_EXPR )
        INTR( KW_CVI,         IFORM_EXPR )
        INTR( KW_CVL,         IFORM_EXPR )
        INTR( KW_CVLONGINT,   IFORM_EXPR )
        INTR( KW_CVS,         IFORM_EXPR )
        INTR( KW_CVSHORT,     IFORM_EXPR )
        '' The varargs intrinsics. cva_start/cva_end/cva_copy are STATEMENTS; cva_arg is
        '' an expression whose SECOND ARGUMENT IS A TYPE -- 'cva_arg( x, long )' -- which
        '' no ordinary argument list can parse, so it has its own form.
        INTR( KW_CVA_START,   IFORM_GENERIC )
        INTR( KW_CVA_END,     IFORM_GENERIC )
        INTR( KW_CVA_COPY,    IFORM_GENERIC )
        INTR( KW_CVA_ARG,     IFORM_CVA_ARG )
        INTR( KW_DEFINED,     IFORM_EXPR )
        INTR( KW_ERR,         IFORM_EXPR )
        INTR( KW_EXP,         IFORM_EXPR )
        INTR( KW_IMAGECREATE, IFORM_EXPR )
        INTR( KW_INSTR,       IFORM_EXPR )
        INTR( KW_INSTRREV,    IFORM_EXPR )
        INTR( KW_LBOUND,      IFORM_EXPR )
        INTR( KW_LCASE,       IFORM_EXPR )
        INTR( KW_LEN,         IFORM_EXPR )
        INTR( KW_LOG,         IFORM_EXPR )
        INTR( KW_LTRIM,       IFORM_EXPR )
        INTR( KW_MID,         IFORM_EXPR )   '' MID( ) = x is an assignment; see below
        INTR( KW_MKD,         IFORM_EXPR )
        INTR( KW_MKI,         IFORM_EXPR )
        INTR( KW_MKL,         IFORM_EXPR )
        INTR( KW_MKLONGINT,   IFORM_EXPR )
        INTR( KW_MKS,         IFORM_EXPR )
        INTR( KW_MKSHORT,     IFORM_EXPR )
        INTR( KW_PEEK,        IFORM_EXPR )
        INTR( KW_POINT,       IFORM_EXPR )
        INTR( KW_RTRIM,       IFORM_EXPR )
        INTR( KW_SADD,        IFORM_EXPR )
        INTR( KW_SIN,         IFORM_EXPR )
        INTR( KW_SIZEOF,      IFORM_EXPR )
        INTR( KW_SPC,         IFORM_EXPR )   '' only inside a PRINT list
        INTR( KW_SQR,         IFORM_EXPR )
        INTR( KW_STR,         IFORM_EXPR )
        INTR( KW_STRPTR,      IFORM_EXPR )
        INTR( KW_TAB,         IFORM_EXPR )   '' only inside a PRINT list
        INTR( KW_TAN,         IFORM_EXPR )
        INTR( KW_TRIM,        IFORM_EXPR )
        INTR( KW_UBOUND,      IFORM_EXPR )
        INTR( KW_UCASE,       IFORM_EXPR )
        INTR( KW_VARPTR,      IFORM_EXPR )
        INTR( KW_WCHR,        IFORM_EXPR )
        INTR( KW_WSTR,        IFORM_EXPR )

        '' ---- context modifiers: NOT statements
        INTR( KW_ACCESS,      IFORM_CONTEXT )
        INTR( KW_APPEND,      IFORM_CONTEXT )
        INTR( KW_BINARY,      IFORM_CONTEXT )
        INTR( KW_DYNAMIC,     IFORM_CONTEXT )
        INTR( KW_ENCODING,    IFORM_CONTEXT )
        INTR( KW_EXPLICIT,    IFORM_CONTEXT )
        INTR( KW_INCLUDE,     IFORM_CONTEXT )
        INTR( KW_LOCAL,       IFORM_CONTEXT )
        INTR( KW_OUTPUT,      IFORM_CONTEXT )
        INTR( KW_PRESERVE,    IFORM_CONTEXT )
        INTR( KW_RANDOM,      IFORM_CONTEXT )

        '' ---- statements with their own grammar
        INTR( KW_PRINT,       IFORM_PRINT )
        INTR( KW_LPRINT,      IFORM_PRINT )
        INTR( KW_WRITE,       IFORM_PRINT )
        INTR( KW_INPUT,       IFORM_INPUT )
        INTR( KW_WINPUT,      IFORM_INPUT )
        INTR( KW_LINE,        IFORM_LINE )
        INTR( KW_OPEN,        IFORM_OPEN )
        INTR( KW_CLOSE,       IFORM_FILENUM )
        INTR( KW_SEEK,        IFORM_FILENUM )
        INTR( KW_LOCK,        IFORM_FILENUM )
        INTR( KW_UNLOCK,      IFORM_FILENUM )
        INTR( KW_GET,         IFORM_GETPUT )
        INTR( KW_PUT,         IFORM_GETPUT )
        INTR( KW_DATA,        IFORM_DATA )
        INTR( KW_ON,          IFORM_ON )
        INTR( KW_SWAP,        IFORM_SWAP )
        INTR( KW_NAME,        IFORM_NAME )

        INTR( KW_DEFBYTE,     IFORM_DEFTYPE )
        INTR( KW_DEFDBL,      IFORM_DEFTYPE )
        INTR( KW_DEFINT,      IFORM_DEFTYPE )
        INTR( KW_DEFLNG,      IFORM_DEFTYPE )
        INTR( KW_DEFLONGINT,  IFORM_DEFTYPE )
        INTR( KW_DEFSHORT,    IFORM_DEFTYPE )
        INTR( KW_DEFSNG,      IFORM_DEFTYPE )
        INTR( KW_DEFSTR,      IFORM_DEFTYPE )
        INTR( KW_DEFUBYTE,    IFORM_DEFTYPE )
        INTR( KW_DEFUINT,     IFORM_DEFTYPE )
        INTR( KW_DEFULNG,     IFORM_DEFTYPE )
        INTR( KW_DEFULONGINT, IFORM_DEFTYPE )
        INTR( KW_DEFUSHORT,   IFORM_DEFTYPE )

        '' ---- graphics: lowered to gfxlib2, never reimplemented (plan README 1.2)
        INTR( KW_CIRCLE,      IFORM_GFX )
        INTR( KW_DRAW,        IFORM_GFX )
        INTR( KW_PAINT,       IFORM_GFX )
        INTR( KW_PALETTE,     IFORM_GFX )
        INTR( KW_PRESET,      IFORM_GFX )
        INTR( KW_PSET,        IFORM_GFX )
        INTR( KW_SCREEN,      IFORM_GFX )
        INTR( KW_VIEW,        IFORM_GFX )
        INTR( KW_WINDOW,      IFORM_GFX )

        '' ---- generic: NAME followed by a comma-separated expression list
        INTR( KW_COLOR,       IFORM_GENERIC )
        INTR( KW_ERASE,       IFORM_GENERIC )
        INTR( KW_ERROR,       IFORM_GENERIC )
        INTR( KW_FIELD,       IFORM_GENERIC )
        INTR( KW_LSET,        IFORM_GENERIC )
        INTR( KW_POKE,        IFORM_GENERIC )
        INTR( KW_READ,        IFORM_GENERIC )
        INTR( KW_RESTORE,     IFORM_GENERIC )
        INTR( KW_RSET,        IFORM_GENERIC )
        INTR( KW_THREADCALL,  IFORM_GENERIC )
        INTR( KW_WIDTH,       IFORM_GENERIC )

        '' ---- statements the declaration layer already owns
        INTR( KW_OPTION,      IFORM_DECLARED )
        INTR( KW_REDIM,       IFORM_DECLARED )

        '' ---- not in -lang fb (probes D1, D2)
        INTR( KW_GOSUB,       IFORM_UNSUPPORTED )
        INTR( KW_RESUME,      IFORM_UNSUPPORTED )
    #endmacro

    declare function IntrinsicFormOf( byval k as TokenKind ) as IntrinsicForm
    declare function IsStatementIntrinsic( byval k as TokenKind ) as boolean

end namespace

#endif

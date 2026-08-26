'' prectable.bi -- THE precedence table.
''
'' Derived by measurement against fbc, not from the manual: see
'' docs/language/precedence.md for the method and the six results that contradict
'' intuition. This is the only place in the compiler where precedence is expressed
'' (docs/plan/04 section 3).
''
'' Higher binds tighter. Every binary operator in FreeBASIC is LEFT-associative,
'' including '^' -- so there is no associativity column: there is nothing to vary.

#ifndef __TKO_PRECTABLE_BI__
#define __TKO_PRECTABLE_BI__

#include once "lexer/token.bi"

namespace Tko

    '' Levels, loosest to tightest. Unary operators sit at PREC_NOT and PREC_SIGN.
    enum Precedence
        PREC_NONE     = 0
        PREC_ANDALSO  = 1      '' andalso, orelse -- ONE level, left-associative
        PREC_IMP      = 2
        PREC_EQV      = 3
        PREC_XOR      = 4
        PREC_OR       = 5
        PREC_AND      = 6
        PREC_NOT      = 7      '' unary NOT: looser than relationals, tighter than AND
        PREC_REL      = 8      '' = <> < <= > >=
        PREC_CONCAT   = 9      '' &
        PREC_ADD      = 10     '' + -
        PREC_SHIFT    = 11     '' shl shr -- TIGHTER than + and -, unlike C
        PREC_MOD      = 12
        PREC_INTDIV   = 13     '' \
        PREC_MUL      = 14     '' * /
        PREC_SIGN     = 15     '' unary - +
        PREC_POWER    = 16     '' ^
        PREC_POSTFIX  = 17     '' . -> ( ) [ ]
    end enum

    '' BINOP( token kind, precedence )
    #macro TKO_BINOP_LIST( BINOP )
        BINOP( KW_ORELSE,     PREC_ANDALSO )
        BINOP( KW_ANDALSO,    PREC_ANDALSO )
        BINOP( KW_IMP,        PREC_IMP     )
        BINOP( KW_EQV,        PREC_EQV     )
        BINOP( KW_XOR,        PREC_XOR     )
        BINOP( KW_OR,         PREC_OR      )
        BINOP( KW_AND,        PREC_AND     )
        BINOP( TK_EQ,         PREC_REL     )
        BINOP( TK_NE,         PREC_REL     )
        BINOP( TK_LT,         PREC_REL     )
        BINOP( TK_LE,         PREC_REL     )
        BINOP( TK_GT,         PREC_REL     )
        BINOP( TK_GE,         PREC_REL     )
        '' 'a IS T' -- the RTTI type test. Measured for PRECEDENCE, not assumed:
        '' '-1 = a is Dog' is -1, so it binds TIGHTER than '=' -- read the other way
        '' round it would be '(-1 = a) is Dog', which does not compile -- and 'a is Dog
        '' andalso 1' compiles, so it is tighter than ANDALSO too. Its right operand is
        '' a TYPE NAME rather than an expression, so nothing binds to its right and
        '' this level only says how much of the left it takes.
        BINOP( KW_IS,         PREC_CONCAT  )
        BINOP( TK_AMP,        PREC_CONCAT  )
        BINOP( TK_PLUS,       PREC_ADD     )
        BINOP( TK_MINUS,      PREC_ADD     )
        BINOP( KW_SHL,        PREC_SHIFT   )
        BINOP( KW_SHR,        PREC_SHIFT   )
        BINOP( KW_MOD,        PREC_MOD     )
        BINOP( TK_BACKSLASH,  PREC_INTDIV  )
        BINOP( TK_STAR,       PREC_MUL     )
        BINOP( TK_SLASH,      PREC_MUL     )
        BINOP( TK_CARET,      PREC_POWER   )
    #endmacro

    declare function InfixPrec( byval k as TokenKind ) as long

end namespace

#endif

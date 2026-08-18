'' token.bi -- the token model.
''
'' A Token is 16 bytes and carries no payload of its own beyond a handle: identifiers
'' hold an InternId, literals hold an index into the unit's literal pool. The original
'' spelling is always recoverable from (loc, length) against the source buffer, so
'' nothing needs to be copied to preserve it (docs/plan/03 section 4).
''
'' Invariants:
''   - Every token has a valid loc within its file, including TK_EOF.
''   - TK_IDENT's ident is the interned ASCII-FOLDED spelling. Case-sensitive text
''     comes from the source buffer, never from the interner.
''   - The vector always ends with exactly one TK_EOF.
''   - A malformed token is TK_INVALID with a real span. The lexer never stops early.

#ifndef __FBX_TOKEN_BI__
#define __FBX_TOKEN_BI__

#include once "fbx.bi"
#include once "source/location.bi"
#include once "lexer/keywords.bi"

namespace Fbx

    enum KeywordClass
        KWCLASS_OPERATOR = 0     '' AND, MOD, SHL, NEW ...
        KWCLASS_KEYWORD          '' DIM, IF, SUB, INTEGER ...
        KWCLASS_INTRINSIC        '' PRINT, OPEN, DRAW ... -- the plan/04 section 5 registry
    end enum

    '' PUNCT( enum name, spelling )
    '' Longest-match is the scanner's job; this list only names them and supplies the
    '' text for dumps and diagnostics.
    #macro FBX_PUNCT_LIST( PUNCT )
        PUNCT( TK_LPAREN,     "("   )
        PUNCT( TK_RPAREN,     ")"   )
        PUNCT( TK_LBRACKET,   "["   )
        PUNCT( TK_RBRACKET,   "]"   )
        PUNCT( TK_LBRACE,     "{"   )
        PUNCT( TK_RBRACE,     "}"   )
        PUNCT( TK_COMMA,      ","   )
        PUNCT( TK_SEMICOLON,  ";"   )
        PUNCT( TK_COLON,      ":"   )
        PUNCT( TK_DOT,        "."   )
        PUNCT( TK_ELLIPSIS,   "..." )
        PUNCT( TK_ARROW,      "->"  )
        PUNCT( TK_FATARROW,   "=>"  )
        PUNCT( TK_AT,         "@"   )
        PUNCT( TK_QUESTION,   "?"   )
        PUNCT( TK_HASH,       "#"   )
        PUNCT( TK_EQ,         "="   )
        PUNCT( TK_NE,         "<>"  )
        PUNCT( TK_LT,         "<"   )
        PUNCT( TK_LE,         "<="  )
        PUNCT( TK_GT,         ">"   )
        PUNCT( TK_GE,         ">="  )
        PUNCT( TK_PLUS,       "+"   )
        PUNCT( TK_MINUS,      "-"   )
        PUNCT( TK_STAR,       "*"   )
        PUNCT( TK_SLASH,      "/"   )
        PUNCT( TK_BACKSLASH,  "\"   )
        PUNCT( TK_CARET,      "^"   )
        PUNCT( TK_AMP,        "&"   )
        PUNCT( TK_PLUSEQ,     "+="  )
        PUNCT( TK_MINUSEQ,    "-="  )
        PUNCT( TK_STAREQ,     "*="  )
        PUNCT( TK_SLASHEQ,    "/="  )
        PUNCT( TK_BSLASHEQ,   "\="  )
        PUNCT( TK_CARETEQ,    "^="  )
        PUNCT( TK_AMPEQ,      "&="  )
        PUNCT( TK_BANG,       "!"   )
        PUNCT( TK_DOLLAR,     "$"   )
        PUNCT( TK_PERCENT,    "%"   )
        PUNCT( TK_TILDE,      "~"   )
    #endmacro

    enum TokenKind
        TK_EOF = 0
        TK_EOL              '' a real newline, or a ':' statement separator
        TK_INVALID          '' something the lexer could not make sense of
        TK_IDENT
        TK_INT_LIT
        TK_FLOAT_LIT
        TK_STRING_LIT

        TK_PUNCT_FIRST
        #define PUNCT( p_name, p_text ) p_name,
        FBX_PUNCT_LIST( PUNCT )
        #undef PUNCT
        TK_PUNCT_LAST

        TK_KW_FIRST
        #define KW( k_name, k_text, k_class ) k_name,
        FBX_KEYWORD_LIST( KW )
        #undef KW
        TK_KW_LAST

        TK_KIND_COUNT
    end enum

    '' Token flags. AtLineStart and SpaceBefore exist for the preprocessor: a '#'
    '' only begins a directive at the start of a line, and macro expansion has to
    '' reproduce spacing faithfully enough to re-lex.
    const TF_AT_LINE_START as ushort = &h0001
    const TF_SPACE_BEFORE  as ushort = &h0002
    const TF_FROM_MACRO    as ushort = &h0004
    const TF_HAS_SUFFIX    as ushort = &h0008   '' identifier carried a $ % & ! # suffix
    '' A ':' statement separator, as opposed to a real end of line. Both are TK_EOL --
    '' ':' separates statements exactly as a newline does -- but 'name:' is a LABEL and
    '' 'name' alone is a CALL, so the two have to be tellable apart. Length cannot do it:
    '' ':' and a bare LF are both one byte.
    const TF_COLON         as ushort = &h0010

    type Token                      '' 16 bytes
        as ushort    kind
        as ushort    flags
        as SourceLoc loc
        as ulong     length         '' source length, for range reconstruction
        union
            as InternId ident       '' TK_IDENT: the FOLDED spelling
            as ulong    literal     '' TK_INT_LIT / TK_FLOAT_LIT / TK_STRING_LIT
        end union
    end type

    type TokenVec as FB.Array( of Token )

    '' ------------------------------------------------------------ literal pool

    enum StringKind
        STRK_PLAIN = 0     '' "..."      -- '""' doubling only
        STRK_ESCAPED       '' !"..."     -- backslash escapes processed
        STRK_RAW           '' $"..."     -- nothing processed
    end enum

    '' Numeric suffixes, as written. The type they imply is a semantic question, so
    '' the lexer records what it saw and decides nothing.
    enum NumSuffix
        NSUF_NONE = 0
        NSUF_INTEGER       '' %
        NSUF_LONG          '' L or &
        NSUF_UINTEGER      '' U
        NSUF_ULONG         '' UL
        NSUF_LONGINT       '' LL
        NSUF_ULONGINT      '' ULL
        NSUF_SINGLE        '' ! or F
        NSUF_DOUBLE        '' # or D
    end enum

    type Literal
        as ubyte      kind          '' TK_INT_LIT / TK_FLOAT_LIT / TK_STRING_LIT
        as ubyte      strKind       '' StringKind
        as ubyte      suffix        '' NumSuffix
        as ubyte      radix         '' 10, 16, 8 or 2 -- for diagnostics and dumps
        as ulongint   intValue
        as double     fltValue
        '' The string payload is a RAW SPAN, undecoded -- OPTION ESCAPE is not known
        '' yet -- and it carries THE FILE IT BELONGS TO.
        ''
        '' The file used to be taken from the token's loc, which coupled two unrelated
        '' things: where a diagnostic should POINT and where the text LIVES. Macro
        '' expansion rewrites the first (RelexInto repoints synthesised tokens at the use
        '' site so errors land somewhere the user can see), and that silently moved the
        '' second, so '#param' returned the invocation's own source text.
        as long       textFile      '' FileId of the buffer the span indexes
        as long       textOffset
        as long       textLength
    end type

    type LiteralVec as FB.Array( of Literal )

    '' -------------------------------------------------------------- keyword map
    '' Keyword lookup is an array index, not a hash: the keyword spellings are
    '' interned FIRST, so they occupy InternIds 1..FBX_KEYWORD_COUNT contiguously and
    '' an identifier is a keyword exactly when its folded id falls in that range.
    '' This replaces the perfect hash of docs/plan/03 section 5.2 -- same cost, and it
    '' falls out of interning the compiler already does.
    type KeywordMap
        as FB.Array( of ushort ) kinds     '' index = InternId, value = TokenKind
        as FB.Array( of ubyte )  classes   '' index = InternId, value = KeywordClass
        as long maxId

        declare function KindOf( byval id as InternId ) as TokenKind
        declare function ClassOf( byval id as InternId ) as KeywordClass
    end type

    declare function TokenKindName( byval k as TokenKind ) as string
    declare function TokenKindText( byval k as TokenKind ) as string
    declare function IsKeywordKind( byval k as TokenKind ) as boolean
    declare function KeywordClassOf( byval k as TokenKind ) as KeywordClass
    declare function IsCallConvKind( byval k as TokenKind ) as boolean
    declare function IsTypeKeyword( byval k as TokenKind ) as boolean
    declare function IsPunctKind( byval k as TokenKind ) as boolean

end namespace

#endif

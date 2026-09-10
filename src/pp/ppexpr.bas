'' ppexpr.bas -- the '#if' expression evaluator.  Included by pp.bas.
''
'' Deliberately NOT the semantic constant evaluator (docs/plan/03 section 6.4): this
'' runs before types exist, over a token list that has already been macro-expanded.
'' The duplication is about 200 lines and is the right trade; it is called out here so
'' it is not "fixed" later by a well-meaning refactor.
''
'' Values are an int64 or a string. FreeBASIC's '#if' compares strings with '=' and
'' '<>' (as in '#if __FB_LANG__ = "fb"'), so both kinds are first class.

namespace Tko

type PpValue
    as boolean  isStr
    as longint  num
    as string   str_
    '' THE VALUE CAME FROM AN ESCAPED LITERAL somewhere -- '!"..."'. The span this
    '' evaluator reads is RAW SOURCE, so a backslash escape has not been decoded and a
    '' unicode one has not been recognised as making the whole literal WIDE. '#if'
    '' compares content and has always been content with that; __FB_EVAL__ has to
    '' RE-EMIT the value, and re-emitting undecoded bytes would produce a different
    '' string. So it is carried, and the one caller that cannot live with it refuses.
    as boolean  escaped
    '' ...and the literal was WIDE -- it carried a '\u' escape, which promotes the
    '' whole thing to a wstring. Decoding the byte escapes around one and dropping
    '' the wide ones would produce a string neither compiler has, so it is carried
    '' and __FB_EVAL__ refuses it.
    as boolean  wide
end type

type PpExprState
    as PpEngine ptr e
    as TokenVec ptr toks
    as long     pos
    as boolean  bad
end type

'' Whether a string token was written in the ESCAPED spelling, '!"..."'. The kind is
'' on the literal payload, which the token indexes; the SPELLING has already lost the
'' prefix by the time it comes back from SpellOf.
private function StrTokenIsEscaped_ _
    ( byref e as PpEngine, byref t as Token ) as boolean

    if Tk( t ) <> TK_STRING_LIT then return false
    dim as long li = cast( long, t.literal )
    if (li < 0) orelse (li >= e.outp->literals.Count) then return false
    return (e.outp->literals[li].strKind = cast( ubyte, STRK_ESCAPED ))
end function

private function PxPeek( byref x as PpExprState ) as TokenKind
    if x.pos >= x.toks->Count then return TK_EOF
    return cast( TokenKind, x.toks->At( x.pos ).kind )
end function

private function PxTok( byref x as PpExprState ) as Token
    dim as Token t
    if x.pos < x.toks->Count then t = x.toks->At( x.pos )
    return t
end function

private sub PxNext( byref x as PpExprState )
    x.pos += 1
end sub

private function PxNum( byval v as longint ) as PpValue
    dim as PpValue r
    r.isStr = false
    r.num = v
    return r
end function

private function PxTruth( byref v as PpValue ) as boolean
    if v.isStr then return (len( v.str_ ) > 0)
    return (v.num <> 0)
end function

declare function PxOrElse( byref x as PpExprState ) as PpValue

'' The size of a BUILTIN type is target data, which the preprocessor legitimately
'' knows -- '#if sizeof( integer ) = 8' needs no symbol table. A user type does, and
'' returns -1 so the caller can mark the condition unevaluable.
'' MEASURED on both targets, because two of these rows differ and the table had them
'' hardcoded at their win64 values:
''
''              win64   win32
''   integer      8       4
''   string      24      12
''   wstring      2       2
''   zstring      1       1
''   boolean      1       1
''
'' '#if sizeof( integer ) = 8' would have taken the wrong branch of every header on
'' win32 -- silently, since a wrong branch is not an error. WSTRING and ZSTRING were
'' simply absent, which is what '#if sizeof( wstring ) = 4' failed on.
private function BuiltinSizeOf( byval k as TokenKind, byval is64 as boolean ) as long
    select case k
    case KW_BYTE, KW_UBYTE, KW_BOOLEAN            : return 1
    case KW_ZSTRING                               : return 1
    case KW_SHORT, KW_USHORT, KW_WSTRING          : return 2
    case KW_LONG, KW_ULONG, KW_SINGLE             : return 4
    case KW_INTEGER, KW_UINTEGER                  : return iif( is64, 8, 4 )
    case KW_LONGINT, KW_ULONGINT, KW_DOUBLE       : return 8
    case KW_STRING                                : return iif( is64, 24, 12 )
    end select
    return -1
end function

'' Two 'typeof' operands can be compared without a symbol table when BOTH name a
'' type directly: 'typeof( long ) = typeof( long )'. The token kind is the identity.
'' 'typeof( someVariable )' needs the type system and is not evaluable here.
private function TypeIdentityOf( byval k as TokenKind ) as long
    '' The IDENTITY of a builtin is its token kind, so the size argument is irrelevant
    '' here -- any target that gives it a size gives it an identity.
    if BuiltinSizeOf( k, true ) >= 0 then return cast( long, k )
    select case k
    case KW_ANY, KW_ZSTRING, KW_WSTRING, KW_USTRING : return cast( long, k )
    end select
    return -1
end function

'' primary := number | string | identifier | defined(id) | '(' expr ')'
private function PxPrimary( byref x as PpExprState ) as PpValue
    dim as TokenKind k = PxPeek( x )
    dim as Token t = PxTok( x )

    select case k
    case TK_INT_LIT
        '' The literal pool belongs to whichever Lex.Result produced the token, and
        '' by this point the expression has been flattened -- so re-read the spelling
        '' rather than chase the pool index.
        dim as string sp = SpellOf( *x.e, t )
        PxNext( x )
        dim as string digits = sp
        dim as longint v = 0
        if len( digits ) >= 2 andalso (digits[0] = 38) then          '' &H &O &B
            dim as long radix = 8
            dim as ubyte c = digits[1]
            if (c = 72) orelse (c = 104) then radix = 16
            if (c = 66) orelse (c = 98) then radix = 2
            dim as long start = 2
            if (c >= 48) andalso (c <= 57) then start = 1
            for i as long = start to len( digits ) - 1
                dim as long d = -1
                dim as ubyte ch = digits[i]
                if (ch >= 48) andalso (ch <= 57) then d = ch - 48
                if (ch >= 65) andalso (ch <= 70) then d = ch - 55
                if (ch >= 97) andalso (ch <= 102) then d = ch - 87
                if (d < 0) orelse (d >= radix) then exit for
                v = v * radix + d
            next
        else
            v = vallng( digits )
        end if
        return PxNum( v )

    case TK_FLOAT_LIT
        dim as string sp = SpellOf( *x.e, t )
        PxNext( x )
        return PxNum( clngint( val( sp ) ) )

    case TK_STRING_LIT
        '' ADJACENT LITERALS ARE ONE STRING. '"#define " "X" " 1"' is a single value
        '' in FreeBASIC, and the corpus writes __FB_EVAL__ arguments that way -- two of
        '' the twenty-five. Reading only the first left the rest as stray tokens after
        '' the expression, which the caller then rejected as trailing input.
        dim as PpValue r
        r.isStr = true
        do
            dim as Token st = PxTok( x )
            dim as string sp = SpellOf( *x.e, st )
            PxNext( x )
            '' Strip the delimiters and any !/$ prefix; comparisons are on content.
            dim as long a = instr( sp, """" )
            dim as long b = instrrev( sp, """" )
            dim as string body
            if (a > 0) andalso (b > a) then
                body = mid( sp, a + 1, b - a - 1 )
            else
                body = sp
            end if
            '' '""' INSIDE A LITERAL IS ONE QUOTE -- the span is raw source and the
            '' lexer only refuses to end the literal there, so the collapse happens on
            '' the way out, exactly as the MIR reader does it.
            dim as string coll
            dim as long i = 1
            while i <= len( body )
                dim as string ch = mid( body, i, 1 )
                coll += ch
                if (ch = """") andalso (mid( body, i + 1, 1 ) = """") then
                    i += 2
                else
                    i += 1
                end if
            wend
            '' AN ESCAPED LITERAL IS DECODED HERE, not carried raw. '#if' compares
            '' content and undecoded bytes were close enough for it, but __FB_EVAL__
            '' RE-EMITS the value: '!"plain"' came back with nothing to re-emit and
            '' declined, and '"A" + !"\0"' -- which fbc answers with '\x41\x00' --
            '' declined with it. pp/macro-eval-str.bas is 11 of those and its
            '' utf16le twin another 11.
            if StrTokenIsEscaped_( *x.e, st ) then
                dim as boolean wasWide = false
                dim as string dec = Tko.Text.DecodeEscapedBody( coll, wasWide )
                if wasWide then
                    r.wide = true
                    r.escaped = true
                    r.str_ += coll
                else
                    r.str_ += dec
                end if
            else
                r.str_ += coll
            end if
            if PxPeek( x ) <> TK_STRING_LIT then exit do
        loop
        return r

    case TK_LPAREN
        PxNext( x )
        dim as PpValue v = PxOrElse( x )
        if PxPeek( x ) = TK_RPAREN then
            PxNext( x )
        else
            x.bad = true
        end if
        return v

    case TK_MINUS
        PxNext( x )
        dim as PpValue v = PxPrimary( x )
        return PxNum( -v.num )

    case TK_PLUS
        PxNext( x )
        return PxPrimary( x )

    '' ABS, SGN, LEN and IIF over CONSTANTS -- none of them needs a symbol table,
    '' which is the only thing this evaluator is short of. Without them every '#if'
    '' naming one was 'invalid expression' and the whole condition unevaluable.
    ''
    '' SAFE DESPITE THE VALUE BEING INTEGER-ONLY, and that is worth saying: a FLOAT
    '' literal in a '#if' is already refused outright (TKO0315) rather than
    '' truncated, so none of these can ever be handed one and quietly answer for a
    '' number it did not get. INT, FIX, FRAC and the C* casts are left out for the
    '' same reason from the other side: over integers they are identity or zero,
    '' which is true but useless, and the float arguments the corpus actually
    '' writes are refused before they reach here.
    case KW_ABS, KW_SGN, KW_LEN
        PxNext( x )
        dim as boolean fparen = (PxPeek( x ) = TK_LPAREN)
        if fparen then PxNext( x )
        dim as PpValue a0 = PxOrElse( x )
        if fparen then
            if PxPeek( x ) = TK_RPAREN then
                PxNext( x )
            else
                x.bad = true
            end if
        end if
        if x.bad then return PxNum( 0 )
        select case k
        case KW_LEN
            if a0.isStr then return PxNum( len( a0.str_ ) )
            '' LEN of a non-string is a TYPE question here, and the
            '' preprocessor has no symbol to ask about.
            x.bad = true
            return PxNum( 0 )
        case KW_ABS
            if a0.isStr then
                x.bad = true
                return PxNum( 0 )
            end if
            if a0.num < 0 then return PxNum( -a0.num )
            return PxNum( a0.num )
        case else
            if a0.isStr then
                x.bad = true
                return PxNum( 0 )
            end if
            if a0.num > 0 then return PxNum( 1 )
            if a0.num < 0 then return PxNum( -1 )
            return PxNum( 0 )
        end select

    '' IIF picks a branch; BOTH are parsed, because the unchosen one still has to
    '' be consumed for the parse to stay in step.
    case KW_IIF
        PxNext( x )
        if PxPeek( x ) <> TK_LPAREN then
            x.bad = true
            return PxNum( 0 )
        end if
        PxNext( x )
        dim as PpValue ic = PxOrElse( x )
        if PxPeek( x ) <> TK_COMMA then
            x.bad = true
            return PxNum( 0 )
        end if
        PxNext( x )
        dim as PpValue it = PxOrElse( x )
        if PxPeek( x ) <> TK_COMMA then
            x.bad = true
            return PxNum( 0 )
        end if
        PxNext( x )
        dim as PpValue ie = PxOrElse( x )
        if PxPeek( x ) = TK_RPAREN then
            PxNext( x )
        else
            x.bad = true
        end if
        if x.bad then return PxNum( 0 )
        if PxTruth( ic ) then return it
        return ie

    case KW_SIZEOF, KW_TYPEOF
        PxNext( x )
        dim as boolean paren = (PxPeek( x ) = TK_LPAREN)
        if paren then PxNext( x )
        dim as TokenKind inner = PxPeek( x )
        dim as long v = -1
        if k = KW_SIZEOF then
            v = BuiltinSizeOf( inner, x.e->cfg->targetIs64 )
        else
            v = TypeIdentityOf( inner )
        end if
        if v < 0 then
            '' A user symbol or type: the preprocessor cannot know. Mark the whole
            '' condition unevaluable rather than guessing a branch (probe P2).
            x.bad = true
        else
            PxNext( x )
        end if
        '' Consume to the matching ')' either way, so recovery stays sane.
        if paren then
            dim as long depth = 1
            while (depth > 0) andalso (x.pos < x.toks->Count)
                if PxPeek( x ) = TK_LPAREN then depth += 1
                if PxPeek( x ) = TK_RPAREN then depth -= 1
                PxNext( x )
            wend
        end if
        if v < 0 then return PxNum( 0 )
        return PxNum( v )

    case KW_WSTR
        '' 'wstr( expr )' -- THE WIDE FLAVOUR OF ITS OPERAND, and nothing else
        '' about the value changes: the conversion is a WIDTH, not a content.
        '' Measured, __FB_EVAL__( wstr( "A" ) ) is '\u0041' and
        '' __FB_EVAL__( "A" ) is '$"A"' -- the same character, re-emitted in the
        '' wide spelling.
        ''
        '' Without this the whole expression was 'not a constant' and every
        '' __FB_EVAL__ over a wide value declined -- six in each of
        '' pp/macro-eval-str.bas and its utf16le twin.
        PxNext( x )
        if PxPeek( x ) <> TK_LPAREN then
            x.bad = true
            return PxNum( 0 )
        end if
        PxNext( x )
        dim as PpValue wv = PxOrElse( x )
        if PxPeek( x ) = TK_RPAREN then
            PxNext( x )
        else
            x.bad = true
        end if
        if wv.isStr = false then
            x.bad = true
            return PxNum( 0 )
        end if
        wv.wide = true
        return wv

    case KW_DEFINED, TK_IDENT
        dim as string nm = "defined"
        if k = TK_IDENT then
            nm = x.e->names->Spelling( cast( InternId, t.literal ) )
        end if
        PxNext( x )

        '' 'DEFINED' is a KEYWORD in FreeBASIC, so it never arrives as an identifier.
        '' Missing that made every '#if not defined( X )' in the corpus unevaluable.
        if nm = "defined" then
            '' defined X and defined( X ) are both accepted, as in fbc.
            dim as boolean paren = (PxPeek( x ) = TK_LPAREN)
            if paren then PxNext( x )
            '' 'defined' queries the SYMBOL TABLE, not just the macro table. Verified
            '' against fbc: defined( constructor ) is true because it is a keyword, and
            '' defined( myvar ) is true for a declared variable. The keyword case is
            '' answerable here; the user-symbol case is probe P2's architectural gap.
            dim as PpValue r = PxNum( 0 )
            if PxPeek( x ) = TK_IDENT then
                dim as InternId want = cast( InternId, PxTok( x ).literal )
                PxNext( x )
                if MacroFor( *x.e, want ) <> 0 then r = PxNum( -1 )
            elseif IsKeywordKind( PxPeek( x ) ) then
                PxNext( x )
                r = PxNum( -1 )
            else
                x.bad = true
            end if
            if paren then
                if PxPeek( x ) = TK_RPAREN then
                    PxNext( x )
                else
                    x.bad = true
                end if
            end if
            return r
        end if

        '' TRUE and FALSE CARRY A VALUE HERE, because fbc's are boolean consts in the
        '' symbol table (symb-keyword.bas: -1 and 0) and its '#if' reads them like any
        '' other const. Measured on fbc 1.10 and fbc-modern: '#if TRUE' takes the true
        '' branch and '#if FALSE' does not. They arrive as identifiers rather than as a
        '' value because PPB_SELF refuses to expand them -- which is what keeps them
        '' BOOLEAN for the parser -- so without this both were 0 and '#if TRUE'
        '' silently selected the false half.
        if nm = "true" then return PxNum( -1 )
        if nm = "false" then return PxNum( 0 )

        '' An identifier that survived expansion is an undefined macro, which is 0.
        return PxNum( 0 )

    case else
        '' A keyword can appear here: NOT is handled above this level, and DEFINED
        '' is an identifier. Anything else is malformed.
        x.bad = true
        PxNext( x )
        return PxNum( 0 )
    end select
end function

private function PxUnary( byref x as PpExprState ) as PpValue
    if PxPeek( x ) = KW_NOT then
        PxNext( x )
        dim as PpValue v = PxUnary( x )
        return PxNum( not v.num )
    end if
    return PxPrimary( x )
end function

private function PxMul( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxUnary( x )
    do
        dim as TokenKind k = PxPeek( x )
        dim as boolean isMul = (k = TK_STAR) orelse (k = TK_SLASH) orelse _
                               (k = TK_BACKSLASH) orelse (k = KW_MOD)
        if isMul = false then exit do
        PxNext( x )
        dim as PpValue r = PxUnary( x )
        select case k
        case TK_STAR      : l = PxNum( l.num * r.num )
        case TK_SLASH     : if r.num <> 0 then l = PxNum( l.num \ r.num ) else l = PxNum( 0 )
        case TK_BACKSLASH : if r.num <> 0 then l = PxNum( l.num \ r.num ) else l = PxNum( 0 )
        case else         : if r.num <> 0 then l = PxNum( l.num mod r.num ) else l = PxNum( 0 )
        end select
    loop
    return l
end function

private function PxAdd( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxMul( x )
    do
        dim as TokenKind k = PxPeek( x )
        dim as boolean isAdd = (k = TK_PLUS) orelse (k = TK_MINUS) orelse (k = TK_AMP)
        if isAdd = false then exit do
        PxNext( x )
        dim as PpValue r = PxMul( x )
        '' '+' AND '&' OVER TWO STRINGS CONCATENATE. Nothing here did: both operands
        '' went through '.num', which is zero for a string, so '"A" + "B"' folded to 0.
        '' '#if' never writes it, but __FB_EVAL__ is written with almost nothing else --
        '' and fbc concatenates, measured.
        if l.isStr andalso r.isStr andalso (k <> TK_MINUS) then
            dim as PpValue c
            c.isStr = true
            c.str_ = l.str_ + r.str_
            c.escaped = l.escaped orelse r.escaped
            c.wide = l.wide orelse r.wide
            l = c
        elseif (l.isStr orelse r.isStr) then
            '' A STRING AND A NUMBER IS NOT SOMETHING TO GUESS AT. fbc has its own rule
            '' for it and it has not been measured, so it is refused rather than folded
            '' to whichever operand happens to be numeric.
            x.bad = true
            l = PxNum( 0 )
        elseif k = TK_PLUS then
            l = PxNum( l.num + r.num )
        elseif k = TK_MINUS then
            l = PxNum( l.num - r.num )
        else
            x.bad = true
            l = PxNum( 0 )
        end if
    loop
    return l
end function

private function PxShift( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxAdd( x )
    do
        dim as TokenKind k = PxPeek( x )
        dim as boolean isShift = (k = KW_SHL) orelse (k = KW_SHR)
        if isShift = false then exit do
        PxNext( x )
        dim as PpValue r = PxAdd( x )
        if k = KW_SHL then
            l = PxNum( l.num shl r.num )
        else
            l = PxNum( l.num shr r.num )
        end if
    loop
    return l
end function

private function PxRel( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxShift( x )
    do
        dim as TokenKind k = PxPeek( x )
        dim as boolean isRel = (k = TK_EQ) orelse (k = TK_NE) orelse (k = TK_LT) orelse _
                               (k = TK_LE) orelse (k = TK_GT) orelse (k = TK_GE)
        if isRel = false then exit do
        PxNext( x )
        dim as PpValue r = PxShift( x )

        dim as boolean res = false
        dim as boolean bothStr = l.isStr orelse r.isStr
        if bothStr then
            dim as string a = l.str_, b = r.str_
            if l.isStr = false then a = str( l.num )
            if r.isStr = false then b = str( r.num )
            select case k
            case TK_EQ : res = (a = b)
            case TK_NE : res = (a <> b)
            case TK_LT : res = (a < b)
            case TK_LE : res = (a <= b)
            case TK_GT : res = (a > b)
            case else  : res = (a >= b)
            end select
        else
            select case k
            case TK_EQ : res = (l.num = r.num)
            case TK_NE : res = (l.num <> r.num)
            case TK_LT : res = (l.num < r.num)
            case TK_LE : res = (l.num <= r.num)
            case TK_GT : res = (l.num > r.num)
            case else  : res = (l.num >= r.num)
            end select
        end if

        l = PxNum( iif( res, -1, 0 ) )
    loop
    return l
end function

private function PxAnd( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxRel( x )
    while PxPeek( x ) = KW_AND
        PxNext( x )
        dim as PpValue r = PxRel( x )
        l = PxNum( l.num and r.num )
    wend
    return l
end function

private function PxOr( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxAnd( x )
    do
        dim as TokenKind k = PxPeek( x )
        dim as boolean isOr = (k = KW_OR) orelse (k = KW_XOR) orelse _
                              (k = KW_EQV) orelse (k = KW_IMP)
        if isOr = false then exit do
        PxNext( x )
        dim as PpValue r = PxAnd( x )
        select case k
        case KW_OR  : l = PxNum( l.num or r.num )
        case KW_XOR : l = PxNum( l.num xor r.num )
        case KW_EQV : l = PxNum( not (l.num xor r.num) )
        case else   : l = PxNum( (not l.num) or r.num )
        end select
    loop
    return l
end function

private function PxAndAlso( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxOr( x )
    while PxPeek( x ) = KW_ANDALSO
        PxNext( x )
        dim as PpValue r = PxOr( x )
        dim as boolean b = PxTruth( l ) andalso PxTruth( r )
        l = PxNum( iif( b, -1, 0 ) )
    wend
    return l
end function

function PxOrElse( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxAndAlso( x )
    while PxPeek( x ) = KW_ORELSE
        PxNext( x )
        dim as PpValue r = PxAndAlso( x )
        dim as boolean b = PxTruth( l ) orelse PxTruth( r )
        l = PxNum( iif( b, -1, 0 ) )
    wend
    return l
end function

'' Evaluate an already-expanded token list as a '#if' condition.
'' The same expression grammar, but for a VALUE rather than a truth.
''
'' __FB_ARG_EXTRACT__ and __FB_ARG_LISTEXPAND__ both take an integer argument that is
'' an EXPRESSION in practice, not a literal: the corpus writes
'' '__FB_ARG_EXTRACT__( __FB_ARG_COUNT__( args ) - 1, args )'. Reading digits off the
'' spelling handled the literal cases and rejected that one, which is the shape that
'' matters.
'' The same expression grammar again, for the WHOLE VALUE -- number or string.
''
'' PpEvalIntTokens throws a string away (it sets ok = false for one), which is right for
'' the two builtins that want a count. __FB_EVAL__ wants whichever the expression is.
function PpEvalValueTokens _
    ( byref e as PpEngine, byref toks as TokenVec, byref ok as boolean ) as PpValue

    dim as PpExprState x
    x.e = @e
    x.toks = @toks
    x.pos = 0
    x.bad = false

    dim as PpValue v
    if toks.IsEmpty( ) then
        ok = false
        return v
    end if

    v = PxOrElse( x )
    if x.pos < toks.Count then x.bad = true
    ok = (x.bad = false)
    return v
end function

function PpEvalIntTokens _
    ( byref e as PpEngine, byref toks as TokenVec, byref ok as boolean ) as longint

    dim as PpExprState x
    x.e = @e
    x.toks = @toks
    x.pos = 0
    x.bad = false

    if toks.IsEmpty( ) then
        ok = false
        return 0
    end if

    dim as PpValue v = PxOrElse( x )
    if x.pos < toks.Count then x.bad = true
    if v.isStr then x.bad = true
    ok = (x.bad = false)
    return v.num
end function

private function PpEvalCondition _
    ( byref e as PpEngine, byref toks as TokenVec, byref ok as boolean ) as boolean

    dim as PpExprState x
    x.e = @e
    x.toks = @toks
    x.pos = 0
    x.bad = false

    if toks.IsEmpty( ) then
        ok = false
        return false
    end if

    dim as PpValue v = PxOrElse( x )
    '' Trailing junk means the expression was not understood, which matters: silently
    '' evaluating half a condition would silently compile the wrong branch.
    if x.pos < toks.Count then x.bad = true
    ok = (x.bad = false)
    return PxTruth( v )
end function

end namespace

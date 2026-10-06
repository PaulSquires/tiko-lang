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
    '' A FLOATING value -- a float literal, or '/' of anything. 'num' then holds it
    '' rounded, for the builtins that only read an integer.
    as boolean  isFlt
    as double   fnum
    '' AN UNSIGNED integer -- a decimal literal above the longint range, and what is
    '' computed from one. Compared and divided unsigned; 'num' holds its 64 bits.
    as boolean  isUns
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
    '' A NAME USED AS A LITERAL -- an undeclared identifier, or a keyword such as 'name' or
    '' 'string'. fbc reads one as its UPPERCASE spelling: 'undeclaredid = "UNDECLAREDID"' is
    '' true, two different names are unequal, '#if undeclaredid' alone is false and
    '' 'undeclaredid = 0' is error 20 (pp/if.bas, measured). Numerically it stays 0, as it
    '' always was here, so only a comparison with a STRING or another NAME reads 'str_'.
    as boolean  isName
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
    if (li < 0) orelse (li >= (*e.lits).Count) then return false
    return ((*e.lits)[li].strKind = cast( ubyte, STRK_ESCAPED ))
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

private function PxFlt( byval d as double ) as PpValue
    dim as PpValue r
    r.isFlt = true
    r.fnum = d
    if (d > -9.2e18) andalso (d < 9.2e18) then r.num = clngint( d )
    return r
end function

'' An operand as a double, and as an integer -- FreeBASIC rounds a float to nearest.
private function PxD( byref v as PpValue ) as double
    if v.isFlt then return v.fnum
    if v.isUns then return cast( double, cast( ulongint, v.num ) )
    return cdbl( v.num )
end function

private function PxName_( byref nm as string ) as PpValue
    dim as PpValue r
    r.isName = true
    r.str_ = ucase( nm )
    return r
end function

private function PxNumU( byval v as longint, byval uns as boolean ) as PpValue
    dim as PpValue r = PxNum( v )
    r.isUns = uns
    return r
end function

private function PxI( byref v as PpValue ) as longint
    return v.num
end function

private function PxTruth( byref v as PpValue ) as boolean
    if v.isStr then return (len( v.str_ ) > 0)
    if v.isFlt then return (v.fnum <> 0)
    return (v.num <> 0)
end function

declare function PxOrElse( byref x as PpExprState ) as PpValue
declare function PxNot( byref x as PpExprState ) as PpValue

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

'' WHAT tiko's FIXED-WIDTH NAMES STAND FOR when the program has not typedef'd them itself:
'' the prelude's ten, which are parsed after the unit and so never noted (prelude.bas).
private function FixedWidthKind_( byref nm as string ) as long
    select case lcase( nm )
    case "int8"    : return cast( long, KW_BYTE )
    case "uint8"   : return cast( long, KW_UBYTE )
    case "int16"   : return cast( long, KW_SHORT )
    case "uint16"  : return cast( long, KW_USHORT )
    case "int32"   : return cast( long, KW_LONG )
    case "uint32"  : return cast( long, KW_ULONG )
    case "int64"   : return cast( long, KW_LONGINT )
    case "uint64"  : return cast( long, KW_ULONGINT )
    case "float32" : return cast( long, KW_SINGLE )
    case "float64" : return cast( long, KW_DOUBLE )
    end select
    return 0
end function

'' 'typeof( name )' OF A VARIABLE OR A NAMED TYPE (T61): fbc reads every declaration above
'' an '#if', and so does this, through what the parser noted (PpEngine.varTypeKey). The
'' operand -- '[const] T [ptr ...]' or a variable -- as a key, with its ')' consumed; ""
'' when it is anything else, which stays unevaluable.
private function PxTypeOperand_( byref x as PpExprState ) as string
    if PxPeek( x ) = KW_CONST then PxNext( x )
    dim as TokenKind k = PxPeek( x )
    dim as Token t = PxTok( x )
    dim as string key
    '' A KEYWORD THAT IS NO BUILTIN TYPE names a type like any identifier: 'type Point' is
    '' legal, and POINT is the graphics function's keyword.
    dim as InternId nmId = INTERN_NONE
    if k = TK_IDENT then
        nmId = cast( InternId, t.literal )
    elseif IsKeywordKind( k ) andalso (TypeIdentityOf( k ) < 0) then
        nmId = x.e->names->GetString( Text.LowerAscii( TokenKindText( k ) ) )
    end if
    if nmId <> INTERN_NONE then
        dim as long ix = cast( long, x.e->names->Fold( nmId ) )
        dim as boolean isType = false
        if ix < x.e->typedefKey.Count then isType = (len( x.e->typedefKey[ix] ) > 0)
        if (isType = false) andalso (ix < x.e->typeNameMark.Count) then isType = (x.e->typeNameMark[ix] <> 0)
        if isType = false then isType = (FixedWidthKind_( x.e->names->Spelling( cast( InternId, ix ) ) ) > 0)
        if (isType = false) andalso (ix < x.e->varTypeKey.Count) then key = x.e->varTypeKey[ix]
        if isType then key = "N" & str( ix )
        if len( key ) = 0 then return ""
    elseif TypeIdentityOf( k ) >= 0 then
        key = "K" & str( cast( long, k ) )
    else
        return ""
    end if
    PxNext( x )
    while (PxPeek( x ) = KW_PTR) orelse (PxPeek( x ) = KW_POINTER)
        key &= " ptr"
        PxNext( x )
    wend
    if PxPeek( x ) <> TK_RPAREN then return ""
    PxNext( x )
    return key
end function

'' A KEY'S VALUE: typedefs followed to what they stand for. A plain builtin is its token
'' kind, as 'typeof( long )' always was; anything else -- a pointer, a named type -- a
'' string no number can equal.
private function PxTypeValue_( byref e as PpEngine, byval key as string ) as PpValue
    for guard as long = 0 to 15
        dim as long sp = instr( key, " " )
        dim as string base_ = iif( sp > 0, left( key, sp - 1 ), key )
        dim as string rest = iif( sp > 0, mid( key, sp ), "" )
        if left( base_, 1 ) <> "N" then exit for
        dim as long ix = valint( mid( base_, 2 ) )
        if ix < e.typedefKey.Count then
            if len( e.typedefKey[ix] ) > 0 then
                key = e.typedefKey[ix] & rest
                continue for
            end if
        end if
        dim as long fw = FixedWidthKind_( e.names->Spelling( cast( InternId, ix ) ) )
        if fw > 0 then key = "K" & str( fw ) & rest
        exit for
    next
    '' fbc's 'typeof' IS TEXT -- the type's name in capitals: 'LONG', 'LONG PTR', 'T' for a
    '' UDT. Measured: '#if typeof( l ) = "LONG"' and '= long' are both true, and
    '' 'typeof( integer ) = typeof( longint )' is false. A builtin was its token kind here,
    '' so a comparison with a string or a type keyword could never hold (pp/if.bas,
    '' pp/typeof.bas, namespace/ns-using*.bas).
    dim as long sp2 = instr( key, " " )
    dim as string b2 = iif( sp2 > 0, left( key, sp2 - 1 ), key )
    dim as string tail2 = iif( sp2 > 0, mid( key, sp2 ), "" )
    dim as string txt
    if left( b2, 1 ) = "K" then
        txt = TokenKindText( cast( TokenKind, valint( mid( b2, 2 ) ) ) )
    else
        txt = e.names->Spelling( cast( InternId, valint( mid( b2, 2 ) ) ) )
    end if
    dim as PpValue r
    r.isStr = true
    r.str_ = ucase( txt & tail2 )
    return r
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
            '' A DECIMAL ABOVE THE LONGINT RANGE IS UNSIGNED in code -- see
            '' Check.DecimalLitUnsigned -- and '#if 18446744073709551615 > 0' is true to
            '' fbc. Read as a longint it was -1. It is carried UNSIGNED, so it still
            '' equals a '&hFFFFFFFFFFFFFFFF' beside it, which a double would not.
            dim as ulongint uv = valulng( digits )
            if uv > &h7FFFFFFFFFFFFFFFull then return PxNumU( cast( longint, uv ), true )
            v = cast( longint, uv )
        end if
        return PxNum( v )

    case TK_FLOAT_LIT
        '' A FLOAT, not a rounded integer: '#if 2.6 = 3' was TRUE and '#if 0.4' FALSE,
        '' where fbc compares the double and answers the other way round both times.
        dim as string sp = SpellOf( *x.e, t )
        PxNext( x )
        return PxFlt( val( sp ) )

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
        if v.isFlt then return PxFlt( -v.fnum )
        return PxNum( -v.num )

    '' NOT AS AN OPERAND, as in code: 'FOO = TRUE' over '#define TRUE NOT FALSE' is
    '' 'not false = not false', and the second NOT is the right side of '='. It takes
    '' what NOT takes anywhere -- a relational.
    case KW_NOT
        return PxNot( x )

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
    '' FRAC, INT, FIX AND SQR FOLD TOO, and ABS and SGN over a FLOAT -- measured, fbc's '#if'
    '' takes 'frac( 1.5 ) = .5', 'int( -1.5 ) = -2' and 'fix( -1.5 ) = -1'; the generated
    '' cases of optimizations/consteval.bas write '#if ... (frac( val2 ) <> .0)' a hundred
    '' times. ABS and SGN read a float as one; they took its rounded integer.
    case KW_ABS, KW_SGN, KW_LEN, KW_FRAC, KW_INT, KW_FIX, KW_SQR
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
        if (k <> KW_LEN) andalso a0.isStr then
            x.bad = true
            return PxNum( 0 )
        end if
        select case k
        case KW_FRAC
            if a0.isFlt = false then return PxNum( 0 )
            return PxFlt( frac( a0.fnum ) )
        case KW_INT
            if a0.isFlt = false then return a0
            return PxFlt( int( a0.fnum ) )
        case KW_FIX
            if a0.isFlt = false then return a0
            return PxFlt( fix( a0.fnum ) )
        case KW_SQR
            return PxFlt( sqr( PxD( a0 ) ) )
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
            if a0.isFlt then return PxFlt( abs( a0.fnum ) )
            if a0.num < 0 then return PxNum( -a0.num )
            return PxNum( a0.num )
        case else
            if a0.isStr then
                x.bad = true
                return PxNum( 0 )
            end if
            if a0.isFlt then return PxNum( sgn( a0.fnum ) )
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
        if paren andalso (k = KW_TYPEOF) then
            dim as long at0 = x.pos
            dim as string key = PxTypeOperand_( x )
            if len( key ) > 0 then return PxTypeValue_( *x.e, key )
            x.pos = at0
        end if
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
        if k = KW_TYPEOF then
            dim as PpValue tv
            tv.isStr = true
            tv.str_ = ucase( TokenKindText( cast( TokenKind, v ) ) )
            return tv
        end if
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

    case KW_LCASE, KW_UCASE
        '' 'lcase( s, mode )' AND 'ucase( s, mode )' -- THE TWO-ARGUMENT FORM ONLY, which fbc
        '' evaluates in '#if'; the one-argument form is its error 11 there (measured,
        '' string/case.bas). ASCII letters only, whichever mode.
        PxNext( x )
        if PxPeek( x ) = TK_LPAREN then
            PxNext( x )
            dim as PpValue cv = PxOrElse( x )
            if PxPeek( x ) <> TK_COMMA then
                x.bad = true
                return PxNum( 0 )
            end if
            PxNext( x )
            dim as PpValue mv = PxOrElse( x )
            if PxPeek( x ) <> TK_RPAREN then
                x.bad = true
                return PxNum( 0 )
            end if
            PxNext( x )
            if (cv.isStr = false) orelse mv.isStr then
                x.bad = true
                return PxNum( 0 )
            end if
            if k = KW_LCASE then cv.str_ = lcase( cv.str_ ) else cv.str_ = ucase( cv.str_ )
            return cv
        end if
        x.bad = true
        return PxNum( 0 )

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
            '' 'defined( ..RANDOMIZE )' -- THE GLOBAL NAMESPACE, spelled with a leading '..':
            '' the same lookup, from the top (fbc-int/math-rnd.bas, measured true for a
            '' builtin and a shared variable, false for an undeclared name).
            if PxPeek( x ) = TK_DOT then
                PxNext( x )
                if PxPeek( x ) = TK_DOT then PxNext( x )
            end if
            '' 'defined' queries the SYMBOL TABLE, not just the macro table. Verified
            '' against fbc: defined( constructor ) is true because it is a keyword,
            '' defined( myvar ) is true for a declared variable, and so are a TYPE, a
            '' type alias, an ENUM, an enum MEMBER, a CONST and a DECLARE -- measured,
            '' all seven.
            ''
            '' The declared-name half is answered from the marks the PARSER leaves as
            '' it goes (PpNoteDeclared). That is sound because the preprocessor is
            '' pull-based: the parser has already read everything above this directive.
            '' It is an APPROXIMATION of fbc's table and knows nothing of scopes, so
            '' only module-level declarations are recorded -- fbc's own rule is
            '' position-dependent and scope-respecting, and a name that has gone out of
            '' scope must not answer yes. Measured: a local or parameter is NOT visible
            '' after its procedure ends, a TYPE's FIELD is never visible, and a
            '' declaration BELOW the directive is not visible either.
            dim as PpValue r = PxNum( 0 )
            if PxPeek( x ) = TK_IDENT then
                dim as InternId want = cast( InternId, PxTok( x ).literal )
                PxNext( x )
                if MacroFor( *x.e, want ) <> 0 then
                    r = PxNum( -1 )
                elseif IsDefinedBuiltin_( *x.e, want ) then
                    r = PxNum( -1 )
                end if
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

        '' ...AND SO DOES ANY OTHER CONST fbc's '#if' can see. Measured: 'const K = 5'
        '' then '#if K = 5' takes the TRUE branch under fbc, and 'const as long L =
        '' &h0A00' then '#if L >= &h0600' does too. The value comes from the parser,
        '' which has already read everything above this directive -- see
        '' PpEngine.constMark. win/_mingw.bi writes '_WIN32_WINNT' as one of these,
        '' so without it every '#if _WIN32_WINNT >= &h0600' in the Windows headers
        '' read 0 and took the false branch: LOCALE_NAME_USER_DEFAULT and the rest of
        '' the Vista-and-later half were never declared.
        if x.e <> 0 then
            dim as longint cv = 0
            if PpConstValue( *x.e, t.literal, cv ) then return PxNum( cv )
            '' ...BUT A VARIABLE OR A PROCEDURE IS NOT A CONSTANT: fbc's errors 11 and 17
            '' (parser/declkind.bas has the measurements). A TYPE, an ENUM and the rest
            '' read as 0 below, quietly, as fbc's do. The directive reports TKO0308.
            select case DeclaredKind_( *x.e, t.literal )
            case 2, 3
                x.bad = true
                return PxNum( 0 )
            end select
        end if

        '' An identifier that survived expansion is an undefined macro: a NAME, which is 0
        '' in arithmetic and its capitals in a comparison -- see PpValue.isName.
        return PxName_( nm )

    case else
        '' A KEYWORD NOT CALLED is a name too -- 'string', 'long', 'name': fbc reads it as
        '' its capitals, so '#if typeof( s ) = string' holds (pp/if.bas). A keyword with an
        '' argument list is a function this evaluator does not have; anything else is
        '' malformed.
        PxNext( x )
        if IsKeywordKind( k ) andalso (PxPeek( x ) <> TK_LPAREN) then
            return PxName_( TokenKindText( k ) )
        end if
        x.bad = true
        return PxNum( 0 )
    end select
end function

'' Two string values, concatenated.
private function PxJoin_( byref l as PpValue, byref r as PpValue ) as PpValue
    dim as PpValue c
    c.isStr = true
    c.str_ = l.str_ + r.str_
    c.escaped = l.escaped orelse r.escaped
    c.wide = l.wide orelse r.wide
    return c
end function

'' THE LANGUAGE'S PRECEDENCE, which is fbc's -- '#if' goes through the same expression
'' parser as code there. Loosest first:
''
''     andalso orelse | xor eqv imp | or | and | not | relational | & | + - | shl shr
''     | mod | \ | * /
''
'' The ladder here had NOT binding tightest, '* / \ mod' as one level and SHL below
'' '+', so '#if not 1 = 2', '#if 1 shl 2 + 1 = 5', '#if 7 \ 2 * 2 = 1' and '#if 10 mod 4
'' * 2 = 2' each took the other branch from fbc -- silently, as a wrong branch is.
'' '/' is FLOATING, as it is in code: '#if 7 / 2 = 3.5' is true. '\' and MOD by zero is
'' fbc's error 100, not 0.
private function PxMul( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxPrimary( x )
    do
        dim as TokenKind k = PxPeek( x )
        if (k <> TK_STAR) andalso (k <> TK_SLASH) then exit do
        PxNext( x )
        dim as PpValue r = PxPrimary( x )
        if k = TK_SLASH then
            l = PxFlt( PxD( l ) / PxD( r ) )
        elseif l.isFlt orelse r.isFlt then
            l = PxFlt( PxD( l ) * PxD( r ) )
        else
            l = PxNumU( l.num * r.num, l.isUns orelse r.isUns )
        end if
    loop
    return l
end function

private function PxIntDiv( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxMul( x )
    while PxPeek( x ) = TK_BACKSLASH
        PxNext( x )
        dim as PpValue r = PxMul( x )
        if PxI( r ) = 0 then
            x.bad = true
            l = PxNum( 0 )
        elseif l.isUns orelse r.isUns then
            l = PxNumU( cast( longint, cast( ulongint, PxI( l ) ) \ cast( ulongint, PxI( r ) ) ), true )
        else
            l = PxNum( PxI( l ) \ PxI( r ) )
        end if
    wend
    return l
end function

private function PxMod( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxIntDiv( x )
    while PxPeek( x ) = KW_MOD
        PxNext( x )
        dim as PpValue r = PxIntDiv( x )
        if PxI( r ) = 0 then
            x.bad = true
            l = PxNum( 0 )
        elseif l.isUns orelse r.isUns then
            l = PxNumU( cast( longint, cast( ulongint, PxI( l ) ) mod cast( ulongint, PxI( r ) ) ), true )
        else
            l = PxNum( PxI( l ) mod PxI( r ) )
        end if
    wend
    return l
end function

private function PxShift( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxMod( x )
    do
        dim as TokenKind k = PxPeek( x )
        if (k <> KW_SHL) andalso (k <> KW_SHR) then exit do
        PxNext( x )
        dim as PpValue r = PxMod( x )
        if k = KW_SHL then
            l = PxNumU( PxI( l ) shl PxI( r ), l.isUns )
        elseif l.isUns then
            l = PxNumU( cast( longint, cast( ulongint, PxI( l ) ) shr PxI( r ) ), true )
        else
            l = PxNum( PxI( l ) shr PxI( r ) )
        end if
    loop
    return l
end function

private function PxAdd( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxShift( x )
    do
        dim as TokenKind k = PxPeek( x )
        if (k <> TK_PLUS) andalso (k <> TK_MINUS) then exit do
        PxNext( x )
        dim as PpValue r = PxShift( x )
        '' '+' OVER TWO STRINGS CONCATENATES -- see PxCat. A string and a number is not
        '' something to guess at: fbc has its own rule for it and it has not been
        '' measured, so it is refused rather than folded.
        if l.isStr andalso r.isStr andalso (k = TK_PLUS) then
            l = PxJoin_( l, r )
        elseif l.isStr orelse r.isStr then
            x.bad = true
            l = PxNum( 0 )
        elseif l.isFlt orelse r.isFlt then
            l = PxFlt( iif( k = TK_PLUS, PxD( l ) + PxD( r ), PxD( l ) - PxD( r ) ) )
        elseif k = TK_PLUS then
            l = PxNumU( l.num + r.num, l.isUns orelse r.isUns )
        else
            l = PxNumU( l.num - r.num, l.isUns orelse r.isUns )
        end if
    loop
    return l
end function

'' '&' -- looser than '+', as in code. Over two strings it concatenates, which is what
'' __FB_EVAL__ is written with; anything else is refused, as before.
private function PxCat( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxAdd( x )
    while PxPeek( x ) = TK_AMP
        PxNext( x )
        dim as PpValue r = PxAdd( x )
        if l.isStr andalso r.isStr then
            l = PxJoin_( l, r )
        else
            x.bad = true
            l = PxNum( 0 )
        end if
    wend
    return l
end function

private function PxRel( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxCat( x )
    do
        dim as TokenKind k = PxPeek( x )
        dim as boolean isRel = (k = TK_EQ) orelse (k = TK_NE) orelse (k = TK_LT) orelse _
                               (k = TK_LE) orelse (k = TK_GT) orelse (k = TK_GE)
        if isRel = false then exit do
        PxNext( x )
        dim as PpValue r = PxCat( x )

        dim as boolean res = false
        '' TEXT when either side is a string, or both are NAMES; a name against a number
        '' stays numeric (0), as it always was here.
        dim as boolean asText = (l.isStr orelse r.isStr) orelse (l.isName andalso r.isName)
        if asText then
            dim as string a = l.str_, b = r.str_
            if (l.isStr = false) andalso (l.isName = false) then a = str( l.num )
            if (r.isStr = false) andalso (r.isName = false) then b = str( r.num )
            select case k
            case TK_EQ : res = (a = b)
            case TK_NE : res = (a <> b)
            case TK_LT : res = (a < b)
            case TK_LE : res = (a <= b)
            case TK_GT : res = (a > b)
            case else  : res = (a >= b)
            end select
        elseif l.isFlt orelse r.isFlt then
            dim as double a = PxD( l ), b = PxD( r )
            select case k
            case TK_EQ : res = (a = b)
            case TK_NE : res = (a <> b)
            case TK_LT : res = (a < b)
            case TK_LE : res = (a <= b)
            case TK_GT : res = (a > b)
            case else  : res = (a >= b)
            end select
        elseif l.isUns orelse r.isUns then
            dim as ulongint a = cast( ulongint, l.num ), b = cast( ulongint, r.num )
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

'' NOT -- looser than the relationals, tighter than AND: 'not a = b' is 'not (a = b)'.
function PxNot( byref x as PpExprState ) as PpValue
    if PxPeek( x ) = KW_NOT then
        PxNext( x )
        dim as PpValue v = PxNot( x )
        return PxNum( not PxI( v ) )
    end if
    return PxRel( x )
end function

private function PxAnd( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxNot( x )
    while PxPeek( x ) = KW_AND
        PxNext( x )
        dim as PpValue r = PxNot( x )
        l = PxNum( PxI( l ) and PxI( r ) )
    wend
    return l
end function

private function PxOr( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxAnd( x )
    while PxPeek( x ) = KW_OR
        PxNext( x )
        dim as PpValue r = PxAnd( x )
        l = PxNum( PxI( l ) or PxI( r ) )
    wend
    return l
end function

'' XOR, EQV and IMP -- one level, as fbc's cLogExpression has them.
private function PxLog( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxOr( x )
    do
        dim as TokenKind k = PxPeek( x )
        if (k <> KW_XOR) andalso (k <> KW_EQV) andalso (k <> KW_IMP) then exit do
        PxNext( x )
        dim as PpValue r = PxOr( x )
        select case k
        case KW_XOR : l = PxNum( PxI( l ) xor PxI( r ) )
        case KW_EQV : l = PxNum( not (PxI( l ) xor PxI( r )) )
        case else   : l = PxNum( (not PxI( l )) or PxI( r ) )
        end select
    loop
    return l
end function

'' ANDALSO and ORELSE -- one level, left to right, as in code.
function PxOrElse( byref x as PpExprState ) as PpValue
    dim as PpValue l = PxLog( x )
    do
        dim as TokenKind k = PxPeek( x )
        if (k <> KW_ANDALSO) andalso (k <> KW_ORELSE) then exit do
        PxNext( x )
        dim as PpValue r = PxLog( x )
        dim as boolean b
        if k = KW_ANDALSO then
            b = PxTruth( l ) andalso PxTruth( r )
        else
            b = PxTruth( l ) orelse PxTruth( r )
        end if
        l = PxNum( iif( b, -1, 0 ) )
    loop
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

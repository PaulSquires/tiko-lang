'' lexer.bas -- see lexer.bi

#include once "lexer/lexer.bi"
#include once "support/text.bi"

namespace Fbx

'' ------------------------------------------------------------- token metadata

dim shared as zstring ptr punctText( 0 to TK_KIND_COUNT - 1 )
dim shared as zstring ptr kindNames( 0 to TK_KIND_COUNT - 1 )
dim shared as ubyte kindClasses( 0 to TK_KIND_COUNT - 1 )
dim shared as boolean tokenTablesReady = false

private sub InitTokenTables( )
    if tokenTablesReady then return

    for i as long = 0 to TK_KIND_COUNT - 1
        punctText(i) = @""
        kindNames(i) = @"?"
    next

    kindNames(TK_EOF)        = @"EOF"
    kindNames(TK_EOL)        = @"EOL"
    kindNames(TK_INVALID)    = @"INVALID"
    kindNames(TK_IDENT)      = @"IDENT"
    kindNames(TK_INT_LIT)    = @"INT"
    kindNames(TK_FLOAT_LIT)  = @"FLOAT"
    kindNames(TK_STRING_LIT) = @"STRING"

    #macro PUNCT( p_name, p_text )
        punctText(p_name) = @p_text
        kindNames(p_name) = @#p_name
    #endmacro
    FBX_PUNCT_LIST( PUNCT )
    #undef PUNCT

    #macro KW( k_name, k_text, k_class )
        punctText(k_name) = @k_text
        kindNames(k_name) = @#k_name
        kindClasses(k_name) = cast( ubyte, k_class )
    #endmacro
    FBX_KEYWORD_LIST( KW )
    #undef KW

    tokenTablesReady = true
end sub

function TokenKindName( byval k as TokenKind ) as string
    InitTokenTables( )
    dim as boolean bad = (k < 0) orelse (k >= TK_KIND_COUNT)
    if bad then return "?"
    return *kindNames(k)
end function

function TokenKindText( byval k as TokenKind ) as string
    InitTokenTables( )
    dim as boolean bad = (k < 0) orelse (k >= TK_KIND_COUNT)
    if bad then return ""
    return *punctText(k)
end function

function IsKeywordKind( byval k as TokenKind ) as boolean
    return (k > TK_KW_FIRST) andalso (k < TK_KW_LAST)
end function

function KeywordClassOf( byval k as TokenKind ) as KeywordClass
    InitTokenTables( )
    dim as boolean bad = (k < 0) orelse (k >= TK_KIND_COUNT)
    if bad then return KWCLASS_KEYWORD
    return cast( KeywordClass, kindClasses(k) )
end function

'' Calling conventions may appear between 'function' and its parameter list.
function IsCallConvKind( byval k as TokenKind ) as boolean
    select case k
    case KW_CDECL, KW_STDCALL, KW_PASCAL, KW___THISCALL, KW___FASTCALL
        return true
    end select
    return false
end function

'' The keywords that can OPEN a type reference. Used to tell 'sizeof( long ptr )'
'' from 'sizeof( someVariable )' without needing the symbol table.
function IsTypeKeyword( byval k as TokenKind ) as boolean
    select case k
    case KW_BYTE, KW_UBYTE, KW_SHORT, KW_USHORT, KW_LONG, KW_ULONG, _
         KW_INTEGER, KW_UINTEGER, KW_LONGINT, KW_ULONGINT, KW_SINGLE, _
         KW_DOUBLE, KW_BOOLEAN, KW_STRING, KW_ZSTRING, KW_WSTRING, _
         KW_USTRING, KW_ANY, KW_CONST, KW_SUB, KW_FUNCTION
        return true
    end select
    return false
end function

function IsPunctKind( byval k as TokenKind ) as boolean
    return (k > TK_PUNCT_FIRST) andalso (k < TK_PUNCT_LAST)
end function

function KeywordMap.KindOf( byval id as InternId ) as TokenKind
    dim as boolean out_ = (id = INTERN_NONE) orelse (cast( long, id ) > this.maxId)
    if out_ then return TK_IDENT
    return cast( TokenKind, this.kinds[cast( long, id )] )
end function

function KeywordMap.ClassOf( byval id as InternId ) as KeywordClass
    dim as boolean out_ = (id = INTERN_NONE) orelse (cast( long, id ) > this.maxId)
    if out_ then return KWCLASS_KEYWORD
    return cast( KeywordClass, this.classes[cast( long, id )] )
end function

end namespace

namespace Fbx.Lex

sub InitKeywords _
    ( byref names as Fbx.Interner, byref map as Fbx.KeywordMap )

    '' Interned in table order and BEFORE anything else, so ids are 1..N contiguous
    '' and the map is a plain array index. Lowercase, because the lexer folds.
    #macro KW( k_name, k_text, k_class )
        scope
            dim as string folded = Fbx.Text.LowerAscii( k_text )
            dim as Fbx.InternId id = names.GetString( folded )
            while map.kinds.Count <= cast( long, id )
                map.kinds.Push( cast( ushort, Fbx.TK_IDENT ) )
                map.classes.Push( 0 )
            wend
            map.kinds[cast( long, id )] = cast( ushort, k_name )
            map.classes[cast( long, id )] = cast( ubyte, k_class )
            if cast( long, id ) > map.maxId then map.maxId = cast( long, id )
        end scope
    #endmacro
    FBX_KEYWORD_LIST( KW )
    #undef KW
end sub

'' ------------------------------------------------------------- character tests

private function IsDigit( byval c as ubyte ) as boolean
    return (c >= 48) andalso (c <= 57)
end function

private function IsHexDigit( byval c as ubyte ) as boolean
    dim as boolean d = (c >= 48) andalso (c <= 57)
    dim as boolean u = (c >= 65) andalso (c <= 70)
    dim as boolean l = (c >= 97) andalso (c <= 102)
    return d orelse u orelse l
end function

private function IsIdentStart( byval c as ubyte ) as boolean
    dim as boolean u = (c >= 65) andalso (c <= 90)
    dim as boolean l = (c >= 97) andalso (c <= 122)
    return u orelse l orelse (c = 95)
end function

private function IsIdentCont( byval c as ubyte ) as boolean
    return IsIdentStart( c ) orelse IsDigit( c )
end function

private function IsSpace( byval c as ubyte ) as boolean
    return (c = 32) orelse (c = 9) orelse (c = 11) orelse (c = 12)
end function

'' &H &O &B or a bare digit: the byte after '&' decides literal versus concat.
'' Probe L1 in docs/language/probes.md -- whitespace is significant here.
private function StartsNumericAfterAmp( byval c as ubyte ) as boolean
    dim as boolean radix = (c = 72) orelse (c = 104) orelse _
                           (c = 79) orelse (c = 111) orelse _
                           (c = 66) orelse (c = 98)
    return radix orelse IsDigit( c )
end function

'' ------------------------------------------------------------------ the state

type Scanner
    as const ubyte ptr p
    as long   n
    as long   i
    as Fbx.FileId file
    as Fbx.SourceManager ptr src
    as Fbx.Interner ptr names
    as Fbx.KeywordMap ptr kwmap
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.Lex.Result ptr outp
    as ushort pendingFlags
end type

private function LocAt( byref s as Scanner, byval offset as long ) as Fbx.SourceLoc
    return s.src->LocFor( s.file, offset )
end function

private sub Emit _
    ( byref s as Scanner, byval kind as Fbx.TokenKind, byval first as long, _
      byval payload as ulong = 0 )

    dim as Fbx.Token t
    t.kind = cast( ushort, kind )
    t.flags = s.pendingFlags
    t.loc = LocAt( s, first )
    t.length = cast( ulong, s.i - first )
    t.literal = payload
    s.outp->tokens.Push( t )
    s.pendingFlags = 0
end sub

private sub Report _
    ( byref s as Scanner, byval id as Fbx.DiagId, byval first as long, _
      byval a0 as string = "" )

    dim as Fbx.SourceRange r
    r.first = LocAt( s, first )
    r.last = LocAt( s, s.i )
    s.diags->Report( id, r, a0 )
end sub

'' ------------------------------------------------------------------- comments

'' /' ... '/ and they NEST (probe L6).
private sub SkipBlockComment( byref s as Scanner, byval first as long )
    dim as long depth = 1
    s.i += 2
    while s.i < s.n
        dim as boolean opens = (s.p[s.i] = 47) andalso (s.i + 1 < s.n) andalso (s.p[s.i + 1] = 39)
        dim as boolean closes = (s.p[s.i] = 39) andalso (s.i + 1 < s.n) andalso (s.p[s.i + 1] = 47)
        if opens then
            depth += 1
            s.i += 2
        elseif closes then
            depth -= 1
            s.i += 2
            if depth = 0 then return
        else
            s.i += 1
        end if
    wend
    Report( s, Fbx.FBX0202, first )
end sub

private sub SkipLineComment( byref s as Scanner )
    while s.i < s.n
        if s.p[s.i] = 10 then exit while
        s.i += 1
    wend
end sub

'' ---------------------------------------------------------------- identifiers

private sub ScanIdentifier( byref s as Scanner )
    dim as long first = s.i
    while (s.i < s.n) andalso IsIdentCont( s.p[s.i] )
        s.i += 1
    wend

    '' Fold into a stack buffer; only pathological identifiers touch the heap.
    dim as long n = s.i - first
    dim as ubyte folded(0 to 255)
    dim as Fbx.InternId id = Fbx.INTERN_NONE
    if n <= 256 then
        Fbx.Text.LowerAsciiInto( @s.p[first], n, @folded(0) )
        id = s.names->Get( @folded(0), n )
    else
        dim as ubyte ptr heap_ = allocate( n )
        Fbx.Text.LowerAsciiInto( @s.p[first], n, heap_ )
        id = s.names->Get( heap_, n )
        deallocate( heap_ )
    end if

    '' A trailing $ % & ! # is a type suffix. In -lang fb it is warned about and
    '' ignored (probe L2), which is a later phase's job -- the lexer only records it.
    dim as ushort extra = 0
    if s.i < s.n then
        dim as ubyte c = s.p[s.i]
        dim as boolean suffix = (c = 36) orelse (c = 37) orelse (c = 38) orelse _
                                (c = 33) orelse (c = 35)
        '' '#' is the Double suffix, but 'a##b' is the paste operator: a doubled '#'
        '' is never a suffix. Without this the macro expander sees 'a' and '#b'.
        if (c = 35) andalso (s.i + 1 < s.n) then
            if s.p[s.i + 1] = 35 then suffix = false
        end if
        if suffix then
            extra = Fbx.TF_HAS_SUFFIX
            s.i += 1
        end if
    end if

    dim as Fbx.TokenKind kind = s.kwmap->KindOf( id )
    s.pendingFlags or= extra

    '' REM comments to end of line, and is a keyword everywhere else it appears.
    if kind = Fbx.KW_REM then
        SkipLineComment( s )
        return
    end if

    if kind = Fbx.TK_IDENT then
        Emit( s, Fbx.TK_IDENT, first, cast( ulong, id ) )
    else
        Emit( s, kind, first )
    end if
end sub

'' -------------------------------------------------------------------- numbers

private sub PushLiteral( byref s as Scanner, byref lit as Fbx.Literal, byval first as long )
    s.outp->literals.Push( lit )
    Emit( s, cast( Fbx.TokenKind, lit.kind ), first, cast( ulong, s.outp->literals.Count - 1 ) )
end sub

'' Reads the trailing type suffix of a numeric literal. Longest match first:
'' ULL before UL before U, LL before L.
private function ScanNumSuffix( byref s as Scanner, byval isFloat as boolean ) as Fbx.NumSuffix
    if s.i >= s.n then return Fbx.NSUF_NONE

    dim as ubyte c0 = s.p[s.i]
    dim as ubyte u0 = c0
    if (u0 >= 97) andalso (u0 <= 122) then u0 -= 32

    select case u0
    case 37                                  '' %
        s.i += 1 : return Fbx.NSUF_INTEGER
    case 38                                  '' &
        s.i += 1 : return Fbx.NSUF_LONG
    case 33                                  '' !
        s.i += 1 : return Fbx.NSUF_SINGLE
    case 35                                  '' #
        s.i += 1 : return Fbx.NSUF_DOUBLE
    case 70                                  '' F
        s.i += 1 : return Fbx.NSUF_SINGLE
    case 68                                  '' D
        if isFloat = false then return Fbx.NSUF_NONE   '' 'd' is the exponent marker
        s.i += 1 : return Fbx.NSUF_DOUBLE
    case 85                                  '' U, UL, ULL
        dim as long save = s.i
        s.i += 1
        dim as long ells = 0
        while (s.i < s.n) andalso ells < 2
            dim as ubyte c = s.p[s.i]
            if (c = 76) orelse (c = 108) then
                ells += 1 : s.i += 1
            else
                exit while
            end if
        wend
        if ells = 0 then return Fbx.NSUF_UINTEGER
        if ells = 1 then return Fbx.NSUF_ULONG
        return Fbx.NSUF_ULONGINT
        s.i = save
    case 76                                  '' L, LL
        s.i += 1
        if s.i < s.n then
            dim as ubyte c = s.p[s.i]
            if (c = 76) orelse (c = 108) then
                s.i += 1
                return Fbx.NSUF_LONGINT
            end if
        end if
        return Fbx.NSUF_LONG
    end select

    return Fbx.NSUF_NONE
end function

private function DigitValue( byval c as ubyte ) as long
    if IsDigit( c ) then return c - 48
    if (c >= 65) andalso (c <= 70) then return c - 55
    if (c >= 97) andalso (c <= 102) then return c - 87
    return -1
end function

'' &H &O &B and the bare-& octal form.
private sub ScanRadixLiteral( byref s as Scanner, byval first as long )
    s.i += 1                                    '' past '&'

    dim as long radix = 8
    if s.i < s.n then
        dim as ubyte c = s.p[s.i]
        select case c
        case 72, 104 : radix = 16 : s.i += 1
        case 79, 111 : radix = 8  : s.i += 1
        case 66, 98  : radix = 2  : s.i += 1
        end select
    end if

    dim as ulongint value = 0
    dim as long digits = 0
    while s.i < s.n
        dim as long d = DigitValue( s.p[s.i] )
        if (d < 0) orelse (d >= radix) then exit while
        value = value * radix + d
        digits += 1
        s.i += 1
    wend

    if digits = 0 then
        Report( s, Fbx.FBX0203, first, "&" )
        Emit( s, Fbx.TK_INVALID, first )
        return
    end if

    dim as Fbx.Literal lit
    lit.kind = cast( ubyte, Fbx.TK_INT_LIT )
    lit.radix = cast( ubyte, radix )
    lit.intValue = value
    lit.suffix = cast( ubyte, ScanNumSuffix( s, false ) )
    PushLiteral( s, lit, first )
end sub

private sub ScanNumber( byref s as Scanner )
    dim as long first = s.i
    dim as boolean isFloat = false

    while (s.i < s.n) andalso IsDigit( s.p[s.i] )
        s.i += 1
    wend

    '' '.' is a decimal point only when a digit follows, so 1..2 and a member access
    '' on a numeric-looking name are not mis-scanned.
    if (s.i < s.n) andalso (s.p[s.i] = 46) then
        dim as boolean digitNext = (s.i + 1 < s.n) andalso IsDigit( s.p[s.i + 1] )
        if digitNext then
            isFloat = true
            s.i += 1
            while (s.i < s.n) andalso IsDigit( s.p[s.i] )
                s.i += 1
            wend
        end if
    end if

    if s.i < s.n then
        dim as ubyte c = s.p[s.i]
        dim as boolean expMarker = (c = 69) orelse (c = 101) orelse (c = 68) orelse (c = 100)
        if expMarker then
            dim as long save = s.i
            dim as long j = s.i + 1
            if j < s.n then
                dim as ubyte signByte = s.p[j]
                if (signByte = 43) orelse (signByte = 45) then j += 1
            end if
            dim as boolean haveExpDigits = (j < s.n) andalso IsDigit( s.p[j] )
            if haveExpDigits then
                isFloat = true
                s.i = j
                while (s.i < s.n) andalso IsDigit( s.p[s.i] )
                    s.i += 1
                wend
            else
                s.i = save
            end if
        end if
    end if

    dim as long digitsEnd = s.i
    dim as Fbx.NumSuffix suffix = ScanNumSuffix( s, isFloat )
    dim as boolean floatSuffix = (suffix = Fbx.NSUF_SINGLE) orelse (suffix = Fbx.NSUF_DOUBLE)
    if floatSuffix then isFloat = true

    dim as Fbx.Literal lit
    lit.radix = 10
    lit.suffix = cast( ubyte, suffix )

    dim as string spelling = space( digitsEnd - first )
    memcpy( strptr( spelling ), @s.p[first], digitsEnd - first )

    if isFloat then
        lit.kind = cast( ubyte, Fbx.TK_FLOAT_LIT )
        '' 'd' is FreeBASIC's double exponent marker; val( ) wants 'e'.
        dim as long at = instr( spelling, "d" )
        if at = 0 then at = instr( spelling, "D" )
        if at > 0 then spelling = left( spelling, at - 1 ) & "e" & mid( spelling, at + 1 )
        lit.fltValue = val( spelling )
    else
        lit.kind = cast( ubyte, Fbx.TK_INT_LIT )
        lit.intValue = cast( ulongint, vallng( spelling ) )
    end if

    PushLiteral( s, lit, first )
end sub

'' -------------------------------------------------------------------- strings

'' The payload span is recorded UNDECODED: OPTION ESCAPE decides what a plain "..."
'' means and the lexer does not know it yet (docs/plan/03 section 5.1).
private sub ScanString( byref s as Scanner, byval kind as Fbx.StringKind, byval first as long )
    if kind <> Fbx.STRK_PLAIN then s.i += 1     '' past the ! or $
    s.i += 1                                    '' past the opening quote

    dim as long textFirst = s.i
    dim as boolean closed = false

    while s.i < s.n
        dim as ubyte c = s.p[s.i]
        if c = 10 then exit while               '' a literal never crosses a newline
        if c = 34 then
            dim as boolean doubled = (s.i + 1 < s.n) andalso (s.p[s.i + 1] = 34)
            if doubled then
                s.i += 2                        '' "" is an embedded quote, always
                continue while
            end if
            closed = true
            exit while
        end if
        '' In an escaped literal a backslash protects the next byte, including a quote.
        if (kind = Fbx.STRK_ESCAPED) andalso (c = 92) andalso (s.i + 1 < s.n) then
            s.i += 2
            continue while
        end if
        s.i += 1
    wend

    dim as long textLast = s.i
    if closed then
        s.i += 1
    else
        '' fbc closes it at the newline and warns rather than failing (probe L3), so
        '' fbx must also accept the file.
        Report( s, Fbx.FBX0201, first )
    end if

    dim as Fbx.Literal lit
    lit.kind = cast( ubyte, Fbx.TK_STRING_LIT )
    lit.strKind = cast( ubyte, kind )
    lit.textFile = cast( long, s.file )
    lit.textOffset = textFirst
    lit.textLength = textLast - textFirst
    PushLiteral( s, lit, first )
end sub

'' ---------------------------------------------------------------- punctuation

private sub ScanPunct( byref s as Scanner )
    dim as long first = s.i
    dim as ubyte c = s.p[s.i]
    dim as ubyte c1 = 0
    if s.i + 1 < s.n then c1 = s.p[s.i + 1]

    dim as Fbx.TokenKind kind = Fbx.TK_INVALID
    dim as long nchars = 1

    select case c
    case 40 : kind = Fbx.TK_LPAREN
    case 41 : kind = Fbx.TK_RPAREN
    case 91 : kind = Fbx.TK_LBRACKET
    case 93 : kind = Fbx.TK_RBRACKET
    case 123 : kind = Fbx.TK_LBRACE
    case 125 : kind = Fbx.TK_RBRACE
    case 44 : kind = Fbx.TK_COMMA
    case 59 : kind = Fbx.TK_SEMICOLON
    case 64 : kind = Fbx.TK_AT
    case 63 : kind = Fbx.TK_QUESTION
    case 35 : kind = Fbx.TK_HASH
    case 33 : kind = Fbx.TK_BANG        '' standalone '!' -- fbc tokenises it
    case 36 : kind = Fbx.TK_DOLLAR
    case 37 : kind = Fbx.TK_PERCENT
    case 126 : kind = Fbx.TK_TILDE

    case 46                                     '' . or ...
        dim as boolean triple = (c1 = 46) andalso (s.i + 2 < s.n) andalso (s.p[s.i + 2] = 46)
        if triple then
            kind = Fbx.TK_ELLIPSIS : nchars = 3
        else
            kind = Fbx.TK_DOT
        end if

    case 61                                     '' = or =>
        if c1 = 62 then
            kind = Fbx.TK_FATARROW : nchars = 2
        else
            kind = Fbx.TK_EQ
        end if

    case 60                                     '' < <= <>
        if c1 = 61 then
            kind = Fbx.TK_LE : nchars = 2
        elseif c1 = 62 then
            kind = Fbx.TK_NE : nchars = 2
        else
            kind = Fbx.TK_LT
        end if

    case 62                                     '' > >=
        if c1 = 61 then
            kind = Fbx.TK_GE : nchars = 2
        else
            kind = Fbx.TK_GT
        end if

    case 43                                     '' + +=
        if c1 = 61 then
            kind = Fbx.TK_PLUSEQ : nchars = 2
        else
            kind = Fbx.TK_PLUS
        end if

    case 45                                     '' - -= ->
        if c1 = 61 then
            kind = Fbx.TK_MINUSEQ : nchars = 2
        elseif c1 = 62 then
            kind = Fbx.TK_ARROW : nchars = 2
        else
            kind = Fbx.TK_MINUS
        end if

    case 42                                     '' * *=
        if c1 = 61 then
            kind = Fbx.TK_STAREQ : nchars = 2
        else
            kind = Fbx.TK_STAR
        end if

    case 47                                     '' / /=
        if c1 = 61 then
            kind = Fbx.TK_SLASHEQ : nchars = 2
        else
            kind = Fbx.TK_SLASH
        end if

    case 92                                     '' \ \=
        if c1 = 61 then
            kind = Fbx.TK_BSLASHEQ : nchars = 2
        else
            kind = Fbx.TK_BACKSLASH
        end if

    case 94                                     '' ^ ^=
        if c1 = 61 then
            kind = Fbx.TK_CARETEQ : nchars = 2
        else
            kind = Fbx.TK_CARET
        end if

    case 38                                     '' & &= or a radix literal
        if c1 = 61 then
            kind = Fbx.TK_AMPEQ : nchars = 2
        else
            kind = Fbx.TK_AMP
        end if
    end select

    if kind = Fbx.TK_INVALID then
        '' NOT a diagnostic. fbc lexes an unrecognised byte into a token and lets the
        '' PARSER reject it -- which is what allows __FB_QUOTE__( <non-ascii> ) to
        '' stringify bytes that could never be an identifier. The token carries its
        '' span, so the parser can name the character. Probe L9.
        s.i += 1
        Emit( s, Fbx.TK_INVALID, first )
        return
    end if

    s.i += nchars
    Emit( s, kind, first )
end sub

'' ------------------------------------------------------------------- the loop

sub Run _
    ( byref src as Fbx.SourceManager, byval file as Fbx.FileId, _
      byref names as Fbx.Interner, byref kwmap as Fbx.KeywordMap, _
      byref diags as Fbx.DiagnosticEngine, byref outp as Result )

    Fbx.InitTokenTables( )

    dim as Fbx.SourceFile ptr f = src.FileAt( file )
    if f = 0 then return

    dim as Scanner s
    s.n = f->text.Count
    s.p = 0
    if s.n > 0 then s.p = @f->text[0]
    s.i = 0
    s.file = file
    s.src = @src
    s.names = @names
    s.kwmap = @kwmap
    s.diags = @diags
    s.outp = @outp
    s.pendingFlags = Fbx.TF_AT_LINE_START

    while s.i < s.n
        dim as ubyte c = s.p[s.i]

        '' ---- whitespace, continuations and newlines
        if IsSpace( c ) then
            s.i += 1
            s.pendingFlags or= Fbx.TF_SPACE_BEFORE
            continue while
        end if

        if c = 13 then
            s.i += 1
            continue while
        end if

        if c = 10 then
            dim as long first = s.i
            s.i += 1
            Emit( s, Fbx.TK_EOL, first )
            s.pendingFlags = Fbx.TF_AT_LINE_START
            continue while
        end if

        '' A trailing '_' continues the logical line: swallow it and the newline, and
        '' do NOT emit TK_EOL (probe L8).
        if c = 95 then
            dim as long j = s.i + 1
            while (j < s.n) andalso IsSpace( s.p[j] )
                j += 1
            wend
            dim as boolean atCr = (j < s.n) andalso (s.p[j] = 13)
            if atCr then j += 1
            dim as boolean atEol = (j < s.n) andalso (s.p[j] = 10)
            if atEol then
                s.i = j + 1
                s.pendingFlags or= Fbx.TF_SPACE_BEFORE
                continue while
            end if
            '' otherwise '_' starts an identifier
        end if

        '' ---- comments
        if c = 39 then                              '' '
            SkipLineComment( s )
            continue while
        end if
        if c = 47 then                              '' /' ... '/
            dim as boolean opensBlock = (s.i + 1 < s.n) andalso (s.p[s.i + 1] = 39)
            if opensBlock then
                SkipBlockComment( s, s.i )
                continue while
            end if
        end if

        '' ---- ':' separates statements and is treated as an end of line
        ''
        '' Flagged, because the parser has to tell it from a real newline: 'name:' is a
        '' label and 'name' on its own is a call.
        if c = 58 then
            dim as long first = s.i
            s.i += 1
            s.pendingFlags or= Fbx.TF_COLON
            Emit( s, Fbx.TK_EOL, first )
            continue while
        end if

        '' ---- literals and identifiers
        if IsIdentStart( c ) then
            '' !"..." and $"..." are string prefixes, not identifiers -- but only
            '' when a quote follows immediately.
            ScanIdentifier( s )
            continue while
        end if

        if IsDigit( c ) then
            ScanNumber( s )
            continue while
        end if

        if c = 46 then                              '' .5 is a float
            dim as boolean digitNext = (s.i + 1 < s.n) andalso IsDigit( s.p[s.i + 1] )
            if digitNext then
                ScanNumber( s )
                continue while
            end if
        end if

        if c = 34 then                              '' "..."
            ScanString( s, Fbx.STRK_PLAIN, s.i )
            continue while
        end if

        if (c = 33) orelse (c = 36) then            '' !"..." or $"..."
            dim as boolean quoteNext = (s.i + 1 < s.n) andalso (s.p[s.i + 1] = 34)
            if quoteNext then
                dim as Fbx.StringKind k = Fbx.STRK_ESCAPED
                if c = 36 then k = Fbx.STRK_RAW
                ScanString( s, k, s.i )
                continue while
            end if
        end if

        '' ---- '&': literal prefix or concat, decided by the very next byte
        if c = 38 then
            dim as boolean numeric = (s.i + 1 < s.n) andalso _
                                     StartsNumericAfterAmp( s.p[s.i + 1] )
            if numeric then
                ScanRadixLiteral( s, s.i )
                continue while
            end if
        end if

        ScanPunct( s )
    wend

    '' Exactly one TK_EOF, at the end-of-file location the source manager reserves.
    dim as Fbx.Token eof
    eof.kind = cast( ushort, Fbx.TK_EOF )
    eof.flags = s.pendingFlags
    eof.loc = src.LocFor( file, s.n )
    eof.length = 0
    eof.literal = 0
    outp.tokens.Push( eof )

    for each t as Fbx.Token in outp.tokens
        if t.kind = cast( ushort, Fbx.TK_INVALID ) then outp.invalidCount += 1
    next
end sub

'' ----------------------------------------------------------------------- dump

function Dump _
    ( byref src as Fbx.SourceManager, byval file as Fbx.FileId, _
      byref names as Fbx.Interner, byref r as Result ) as string

    dim as string outp = ""
    outp += "file " & src.PathOf( file ) & ", " & r.tokens.Count & " tokens" & chr( 10 )

    dim as long index = 0
    for each t as Fbx.Token in r.tokens
        dim as Fbx.DecodedLoc d = src.Decode( t.loc )
        dim as Fbx.TokenKind k = cast( Fbx.TokenKind, t.kind )

        dim as string row = ""
        row += right( "     " & str( index ), 5 ) & " "
        row += right( "    " & str( d.lineNo ), 4 ) & ":"
        row += left( str( d.column ) & "    ", 4 ) & " "
        row += left( Fbx.TokenKindName( k ) & "                    ", 20 )

        select case k
        case Fbx.TK_IDENT
            row += "'" & names.Spelling( cast( Fbx.InternId, t.literal ) ) & "'"
        case Fbx.TK_INT_LIT
            dim as Fbx.Literal ptr lit = @r.literals[cast( long, t.literal )]
            row += str( lit->intValue ) & " radix=" & lit->radix & " suffix=" & lit->suffix
        case Fbx.TK_FLOAT_LIT
            dim as Fbx.Literal ptr lit = @r.literals[cast( long, t.literal )]
            row += str( lit->fltValue ) & " suffix=" & lit->suffix
        case Fbx.TK_STRING_LIT
            dim as Fbx.Literal ptr lit = @r.literals[cast( long, t.literal )]
            '' The literal's OWN file, not the dump's: they differ once a token has
            '' come through macro expansion.
            dim as Fbx.SourceFile ptr f = src.FileAt( cast( Fbx.FileId, lit->textFile ) )
            dim as string payload = ""
            if (lit->textLength > 0) andalso (f <> 0) then
                payload = space( lit->textLength )
                memcpy( strptr( payload ), @f->text[lit->textOffset], lit->textLength )
            end if
            row += "kind=" & lit->strKind & " <" & payload & ">"
        case else
            dim as string spellText = Fbx.TokenKindText( k )
            if len( spellText ) > 0 then row += "'" & spellText & "'"
        end select

        if (t.flags and Fbx.TF_HAS_SUFFIX) <> 0 then row += " [suffix]"
        outp += rtrim( row ) & chr( 10 )
        index += 1
    next

    return outp
end function

end namespace

'' constfold.bas -- THE CONSTANT EVALUATOR.
''
'' Split out of check.bas when that file passed the 1500-line lint cap, by subject:
'' everything here folds an expression to a number at compile time, and nothing here
'' knows anything about types or diagnostics.
''
'' It has three callers with three different needs -- a fixed string's length, an enum
'' member's value and '#assert' -- which is why it takes the symbol table optionally:
'' a caller with no scope to look a name up in gets 'not constant', which is the honest
'' answer for it.

#include once "symbols/check.bi"
#include once "support/text.bi"

namespace Tko.Check

'' -------------------------------------------------------- constant evaluation

'' Everything below matches fbc exactly, and most of it would be wrong if guessed:
''
''   - A true comparison is -1, not 1.
''   - '\' truncates TOWARD ZERO, so -7 \ 2 is -3, and MOD takes the sign of the
''     DIVIDEND: -7 mod 2 is -1 while 7 mod -2 is 1.
''   - SHR on a signed value is ARITHMETIC: -1 shr 1 stays -1.
''   - Shifts are done at 64 bits: 1 shl 32 is 4294967296, not 0.
''   - NOT is a bitwise complement, so 'not 0' is -1.

private function CV_( byval v as longint ) as ConstVal
    dim as ConstVal r
    r.known = true
    r.value = v
    r.bits = 64
    return r
end function

'' A value folded at a WIDTH. Anything narrower than 64 bits is sign-extended back, so
'' the stored value is always the one a 64-bit register would hold -- '1 shl 31' at 32
'' bits is -2147483648, not 2147483648.
private function CVW_( byval v as longint, byval bits as long ) as ConstVal
    dim as ConstVal r
    r.known = true
    r.bits = iif( bits <= 32, 32, 64 )
    if r.bits = 32 then
        r.value = cast( longint, cast( long, v ) )
    else
        r.value = v
    end if
    return r
end function

'' The width a binary operator folds at: the WIDER of its operands.
private function WiderOf_( byref a as ConstVal, byref b as ConstVal ) as long
    dim as long wa = iif( a.bits = 0, 64, a.bits )
    dim as long wb = iif( b.bits = 0, 64, b.bits )
    return iif( wa > wb, wa, wb )
end function

'' The width an INTEGER LITERAL has. Its suffix decides when it has one; otherwise it is
'' INTEGER -- pointer-width -- unless the value does not fit, when fbc promotes it to
'' LONGINT. Measured: on win32 'typeof( 5000000000 )' is LONGINT while
'' 'typeof( &hFFFFFFFF )' is INTEGER, and the second folds to -1.
private function LitBits_ _
    ( byval suffix as ubyte, byval v as longint, byval intBits as long ) as long

    select case cast( Tko.NumSuffix, suffix )
    case Tko.NSUF_LONG, Tko.NSUF_ULONG, Tko.NSUF_INTEGER, Tko.NSUF_UINTEGER
        '' '%' and 'U' are INTEGER and UINTEGER, which are pointer-width; 'L' and 'UL'
        '' are LONG and ULONG, which are 32 everywhere.
        select case cast( Tko.NumSuffix, suffix )
        case Tko.NSUF_LONG, Tko.NSUF_ULONG : return 32
        end select
        return intBits
    case Tko.NSUF_LONGINT, Tko.NSUF_ULONGINT
        return 64
    end select
    if intBits >= 64 then return 64
    if (v >= -2147483648ll) andalso (v <= 4294967295ll) then return 32
    return 64
end function

private function CVNone_( ) as ConstVal
    dim as ConstVal r
    return r
end function

'' A FreeBASIC truth value is -1, never 1.
'' The same as CVW_, carrying the UNSIGNEDNESS through. Separate rather than a default
'' argument so every existing call keeps folding as signed, which is what it was.
private function CVWU_ _
    ( byval v as longint, byval bits as long, byval uns as boolean ) as ConstVal
    dim as ConstVal r = CVW_( v, bits )
    r.uns = uns
    return r
end function

'' Is a numeric suffix an UNSIGNED one? 'u', 'ul' and 'ull'. A bare hex literal is NOT
'' unsigned -- measured, '&hFFFFFFFF' at 32 bits is -1 to fbc.
private function SuffixUnsigned_( byval suffix as ubyte ) as boolean
    select case cast( Tko.NumSuffix, suffix )
    case Tko.NSUF_UINTEGER, Tko.NSUF_ULONG, Tko.NSUF_ULONGINT
        return true
    end select
    return false
end function

private function CVBool_( byval b as boolean ) as ConstVal
    return CV_( iif( b, cast( longint, -1 ), cast( longint, 0 ) ) )
end function

private function IPow_( byval b as longint, byval e as longint ) as longint
    if e < 0 then return 0
    dim as longint r = 1
    for i as longint = 1 to e
        r *= b
    next
    return r
end function


'' The numeric value of a literal argument, as a double, so the rounding intrinsics
'' can see 2.5 rather than an integer. Returns false when it is not a literal.
private function LitNum_ _
    ( byref ast as Tko.AstArena, byval id as Tko.NodeId, byref d as double ) as boolean

    if id = Tko.NODE_NONE then return false
    dim as Tko.NodeKind k = ast.Kind( id )
    if k = Tko.N_PAREN then
        dim as Tko.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return false
        return LitNum_( ast, cast( Tko.NodeId, ast.children[pp->first] ), d )
    end if
    if k = Tko.N_UNARY then
        dim as Tko.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        if LitNum_( ast, up->operand, d ) = false then return false
        if cast( Tko.TokenKind, up->op ) = Tko.TK_MINUS then d = -d
        return true
    end if
    dim as Tko.LiteralPayload ptr lp = 0
    if (k = Tko.N_FLOAT_LIT) orelse (k = Tko.N_INT_LIT) then
        lp = @ast.literals[cast( long, ast.nodes[cast( long, id )].data )]
    end if
    if lp = 0 then return false
    if k = Tko.N_FLOAT_LIT then
        d = lp->fltValue
    else
        d = cast( double, cast( longint, lp->intValue ) )
    end if
    return true
end function

'' A FLOATING constant, folded. Separate from ConstOf on purpose: ConstVal carries a
'' longint, so a float has nowhere to go in it -- which is why 'const PI = 3.5' has
'' never had a value and every use of one declined. Widening ConstVal would change what
'' every integer caller sees; a second entry point changes nothing for them.
''
'' Only the four arithmetic operators and unary minus, which is what a floating
'' constant expression is made of. A mixed expression folds in DOUBLE, as fbc's does.
function ConstFloatOf _
    ( byref ast as Tko.AstArena, byval id as Tko.NodeId, byref outd as double, _
      byval depth as long = 0, byval syms as Tko.SymbolTable ptr = 0, _
      byval scope_ as Tko.ScopeId = 0 ) as boolean

    if id = Tko.NODE_NONE then return false
    if depth > 32 then return false

    select case ast.Kind( id )
    case Tko.N_FLOAT_LIT, Tko.N_INT_LIT
        return LitNum_( ast, id, outd )

    case Tko.N_PAREN
        dim as Tko.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return false
        return ConstFloatOf( ast, cast( Tko.NodeId, ast.children[pp->first] ), _
                             outd, depth + 1, syms, scope_ )

    case Tko.N_UNARY
        dim as Tko.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        if ConstFloatOf( ast, up->operand, outd, depth + 1, syms, scope_ ) = false then
            return false
        end if
        select case cast( Tko.TokenKind, up->op )
        case Tko.TK_MINUS : outd = -outd
        case Tko.TK_PLUS
        case else : return false
        end select
        return true

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @ast.binaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as double l, r
        if ConstFloatOf( ast, bp->lhs, l, depth + 1, syms, scope_ ) = false then
            return false
        end if
        if ConstFloatOf( ast, bp->rhs, r, depth + 1, syms, scope_ ) = false then
            return false
        end if
        select case cast( Tko.TokenKind, bp->op )
        case Tko.TK_PLUS  : outd = l + r
        case Tko.TK_MINUS : outd = l - r
        case Tko.TK_STAR  : outd = l * r
        case Tko.TK_SLASH
            '' DIVIDING BY ZERO IS AN ANSWER IN FLOATING POINT, not an error: IEEE
            '' gives +/-INF and 0/0 gives a NaN, and fbc FOLDS all of them -- measured,
            '' 'dim shared as double b = 1.0 / 0.0' emits '__builtin_inf()' and
            '' '0.0 / 0.0' emits '(-__builtin_nan( "" ))'. Refusing it left every
            '' INF and NaN constant unfolded, so a STATIC or SHARED initialised from
            '' one had no image at all: 32 declines in numbers/infnan.bas, which is
            '' the file that exists to test exactly these values.
            outd = l / r
        '' '^' IS A FLOAT OPERATOR AND ITS RESULT IS A DOUBLE. '2^63' is how the
        '' corpus writes every power-of-two boundary -- numbers/cast_f2ll.bas writes
        '' six of them -- and with no case for it the whole constant was unknown.
        case Tko.TK_CARET : outd = l ^ r
        case else : return false
        end select
        return true

    '' A NAMED FLOAT CONSTANT. 'const as double d = 2^63' followed by
    '' 'culngint( d )' folded to nothing, and a conversion that folds to nothing
    '' declines at every use. Optional, exactly as in ConstOf: a caller with no scope
    '' to look in passes nothing and gets the old answer.
    case Tko.N_IDENT
        if syms = 0 then return false
        if depth >= 16 then return false
        dim as Tko.InternId inm = _
            ast.idents[cast( long, ast.nodes[cast( long, id )].data )].name
        dim as Tko.SymbolId csid = syms->Lookup( scope_, inm )
        if csid = Tko.SYMBOL_NONE then return false
        dim as Tko.Symbol ptr cs = syms->SymbolAt( csid )
        if cs = 0 then return false
        if cs->kind <> cast( ubyte, Tko.SYM_CONSTANT ) then return false
        if (cs->flags and Tko.SYMF_BUILTIN) <> 0 then return false
        if cs->payload = 0 then return false
        dim as Tko.NodeId citem = cast( Tko.NodeId, cs->payload )
        if ast.Kind( citem ) <> Tko.N_VAR_ITEM then return false
        dim as Tko.StmtPayload ptr cip = _
            @ast.stmts[cast( long, ast.nodes[cast( long, citem )].data )]
        return ConstFloatOf( ast, cip->b, outd, depth + 1, syms, cs->parent )
    end select
    return false
end function

'' CINT rounds HALF TO EVEN -- cint(2.5) is 2 and cint(3.5) is 4 -- which is the one
'' rule here nobody guesses right. INT floors, FIX truncates toward zero.
private function RoundHalfEven_( byval d as double ) as longint
    dim as double f = int( d )
    dim as double diff = d - f
    if diff > 0.5 then return cast( longint, f ) + 1
    if diff < 0.5 then return cast( longint, f )
    dim as longint fi = cast( longint, f )
    if (fi mod 2) = 0 then return fi
    return fi + 1
end function

'' The intrinsics fbc folds at compile time. Anything not listed simply does not fold,
'' which is an absence rather than an error.
'' THE SYMBOL TABLE COMES WITH IT. Every argument here was folded WITHOUT it, so a
'' conversion over a NAMED constant folded to nothing: 'cbool( FALSE )' and
'' 'cbyte( K )' alike, and the constant they initialise then had no value -- so every
'' USE of it declined, which is what boolean-conversions.bas is written out of.
private function ConstCall_ _
    ( byref ast as Tko.AstArena, byval id as Tko.NodeId, _
      byref src as Tko.SourceManager, byref names as Tko.Interner, _
      byval intBits as long, byval syms as Tko.SymbolTable ptr, _
      byval scope_ as Tko.ScopeId, byval depth as long ) as ConstVal

    dim as Tko.ListPayload ptr cp = _
        @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return CVNone_( )
    if ast.Kind( cp->target ) <> Tko.N_IDENT then return CVNone_( )
    dim as Tko.IdentPayload ptr ip = _
        @ast.idents[cast( long, ast.nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( names.Spelling( ip->name ) )

    if (nm = "iif") andalso (cp->count = 3) then
        dim as ConstVal c = ConstOf( ast, cast( Tko.NodeId, ast.children[cp->first] ), _
                                     src, names, intBits, syms, scope_, depth )
        if c.known = false then return CVNone_( )
        dim as long pick = iif( c.value <> 0, 1, 2 )
        return ConstOf( ast, cast( Tko.NodeId, ast.children[cp->first + pick] ), _
                        src, names, intBits, syms, scope_, depth )
    end if

    '' 'cast( T, expr )' AND 'cptr( T, expr )' FOLD TO THEIR OPERAND. The conversion
    '' does not change a compile-time INTEGER value -- narrowing is the caller's
    '' business, and every use site coerces to its own type anyway.
    ''
    '' inc/win/winerror.bi declares every COM result this way:
    ''
    ''     const S_OK = cast( HRESULT, &h00000000 )
    ''
    '' so the constant had NO VALUE, and it was the USES that declined -- 'return
    '' S_OK', 'if failed( hr )', '*ppv = 0 : return E_POINTER'. The line the count
    '' pointed at never mentioned a cast.
    if ((nm = "cast") orelse (nm = "cptr")) andalso (cp->count = 2) then
        return ConstOf( ast, cast( Tko.NodeId, ast.children[cp->first + 1] ), src, _
                        names, intBits, syms, scope_, depth )
    end if

    if cp->count <> 1 then return CVNone_( )
    dim as Tko.NodeId a0 = cast( Tko.NodeId, ast.children[cp->first] )

    '' LEN and ASC read the literal's SPAN out of the source buffer: the parser keeps
    '' the extent, not the decoded text.
    if (nm = "len") orelse (nm = "asc") then
        if ast.Kind( a0 ) <> Tko.N_STRING_LIT then return CVNone_( )
        dim as Tko.LiteralPayload ptr lp = _
            @ast.literals[cast( long, ast.nodes[cast( long, a0 )].data )]
        if nm = "len" then return CV_( lp->strLength )
        if lp->strLength <= 0 then return CVNone_( )
        dim as Tko.DecodedLoc dl = src.Decode( ast.Loc( a0 ) )
        dim as Tko.SourceFile ptr f = src.FileAt( dl.file )
        if f = 0 then return CVNone_( )
        if lp->strOffset >= f->text.Count then return CVNone_( )
        return CV_( f->text[lp->strOffset] )
    end if

    '' THE CV FAMILY OVER A LITERAL. 'cvshort( "ABCDEFGH" )' is the first two bytes of
    '' that text read as a little-endian integer, and fbc FOLDS it -- string/mkcv.bas
    '' writes seven 'const as longint' initialised that way and then asserts each
    '' against a hex constant, so a constant with no value is seven declines and the
    '' lines that mention it never mention a cv.
    ''
    '' Measured: "ABCDEFGH" gives &h4241 for cvshort, &h44434241 for cvl and
    '' &h4847464544434241 for cvlongint -- little-endian, and SIGNED, which is what
    '' makes the reinterpretation and not a sum.
    ''
    '' The bytes come out of the SOURCE SPAN, the same way LEN and ASC read theirs, so
    '' a literal whose span is longer than its decoded length -- one with an escape in
    '' it -- is refused rather than read wrong.
    dim as long cvBytes = 0
    select case nm
    case "cvshort" : cvBytes = 2
    case "cvl", "cvs" : cvBytes = 4
    case "cvlongint", "cvd" : cvBytes = 8
    case "cvi" : cvBytes = intBits \ 8
    end select
    '' CVS and CVD are FLOAT reinterpretations, not integer ones, and this folder has
    '' no float value to give back. Named above only so they are not silently folded
    '' as integers.
    if (nm = "cvs") orelse (nm = "cvd") then cvBytes = 0
    if (cvBytes >= 2) andalso (ast.Kind( a0 ) = Tko.N_STRING_LIT) then
        dim as Tko.LiteralPayload ptr clp = _
            @ast.literals[cast( long, ast.nodes[cast( long, a0 )].data )]
        '' AN ESCAPED LITERAL IS NOT ITS OWN BYTES. An escaped newline spans two
        '' characters and is
        '' one byte, so reading the span would fold the backslash. Refused rather than
        '' decoded: the plain and raw kinds are the ones whose span IS the value, and
        '' those are what the corpus writes.
        dim as boolean cvPlain = (clp->strKind <> cast( ubyte, Tko.STRK_ESCAPED ))
        if cvPlain andalso (clp->strLength >= cvBytes) then
            '' THE SPAN'S OWN FILE, not the node's location -- macro expansion is free
            '' to rewrite the second and the payload says so in its own comment.
            dim as Tko.SourceFile ptr cf = _
                src.FileAt( cast( Tko.FileId, clp->strFile ) )
            if cf <> 0 then
                if (clp->strOffset + cvBytes) <= cf->text.Count then
                    dim as ulongint acc = 0
                    for i as long = cvBytes - 1 to 0 step -1
                        acc = (acc shl 8) or cast( ulongint, cf->text[clp->strOffset + i] )
                    next
                    select case cvBytes
                    case 2 : return CVW_( cast( longint, cast( short, acc ) ), 32 )
                    case 4 : return CVW_( cast( longint, cast( long, acc ) ), 32 )
                    end select
                    return CV_( cast( longint, acc ) )
                end if
            end if
        end if
    end if

    dim as double d = 0
    dim as boolean isNum = LitNum_( ast, a0, d )
    dim as ConstVal iv = ConstOf( ast, a0, src, names, intBits, syms, scope_, depth )
    '' A NAMED float constant, or an EXPRESSION over one, is a number too -- but only
    '' asked for when the integer folder already said it had nothing, so a named
    '' INTEGER constant keeps the exact integer path below rather than going round
    '' through a double it may not fit in.
    if (isNum = false) andalso (iv.known = false) then
        isNum = ConstFloatOf( ast, a0, d, 0, syms, scope_ )
    end if

    select case nm
    case "abs"
        if iv.known then return CV_( abs( iv.value ) )
    case "sgn"
        if iv.known then return CV_( sgn( iv.value ) )
    '' A NAMED CONSTANT IS NOT A LITERAL, and 'isNum' asks only about a literal. So
    '' 'const CL = clng( K )' over 'const K = 300' folded to NOTHING while
    '' 'clng( 300 )' folded -- and a constant with no value makes every USE of it
    '' decline. The rounding is the FLOAT path's; an integer that is already known
    '' needs none of it.
    case "cint", "clngint"
        if isNum then
            dim as longint r = RoundHalfEven_( d )
            if nm = "cint" then return CV_( r )
            return CV_( r )
        end if
        if iv.known then return CV_( iv.value )
    case "clng"
        '' CLNG targets 32 bits, and an out-of-range float does NOT wrap: fbc yields
        '' the x86 "indefinite" value, &h80000000, and warns about the overflow.
        '' Wrapping instead gives 1410065408 for clng(1e10) -- a plausible number and
        '' the wrong one. CINT is exempt because it targets 64-bit INTEGER, so
        '' cint(1e10) does not overflow at all.
        if isNum then
            dim as longint r = RoundHalfEven_( d )
            if (r > 2147483647ll) orelse (r < -2147483648ll) then
                return CV_( -2147483648ll )
            end if
            return CV_( r )
        end if
        if iv.known then
            if (iv.value > 2147483647ll) orelse (iv.value < -2147483648ll) then
                return CV_( -2147483648ll )
            end if
            return CV_( iv.value )
        end if
    case "int"
        if isNum then return CV_( cast( longint, int( d ) ) )
        if iv.known then return CV_( iv.value )
    case "fix"
        if isNum then return CV_( cast( longint, fix( d ) ) )
        if iv.known then return CV_( iv.value )

    '' THE REST OF THE CONVERSION FAMILY, which folds by TRUNCATING to the target's
    '' width and carrying its signedness. Only CINT, CLNG and CLNGINT were here, so
    '' 'const A = cuint( 1 )' had no value at all -- and a constant with no value is a
    '' DECLINE at every use of it, which is how one corpus file lost 220 statements.
    ''
    '' CLNG keeps its own case above: an out-of-range float does not wrap there, it
    '' becomes the x86 indefinite value, and that is measured rather than derived.
    case "cbyte"   : if iv.known then return CVW_( cast( longint, cast( byte, iv.value ) ), 32 )
    case "cubyte"  : if iv.known then return CVWU_( cast( longint, cast( ubyte, iv.value ) ), 32, true )
    case "cshort"  : if iv.known then return CVW_( cast( longint, cast( short, iv.value ) ), 32 )
    case "cushort" : if iv.known then return CVWU_( cast( longint, cast( ushort, iv.value ) ), 32, true )
    case "culng"   : if iv.known then return CVWU_( cast( longint, cast( ulong, iv.value ) ), 32, true )
    case "cuint", "culngint"
        '' AN UNSIGNED TARGET TAKES THE WHOLE 64-BIT RANGE, so the float path cannot
        '' go through the signed rounding above: measured, fbc folds
        '' 'culngint( 2^63 )' to 9223372036854775808ull and 'culngint( 2^64 - 2^11 )'
        '' to 18446744073709549568ull, both of which are negative read as signed.
        if isNum then return CVWU_( cast( longint, culngint( d ) ), 64, true )
        if iv.known then return CVWU_( iv.value, 64, true )
    case "cbool"
        '' A FreeBASIC truth value is -1, never 1.
        if iv.known then return CV_( iif( iv.value <> 0, -1, 0 ) )
    end select
    return CVNone_( )
end function

'' ONE CONSTANT'S DECLARED TYPE, applied to its folded value: the width to truncate
'' to and whether the result is unsigned. Read off the N_TYPEREF's keyword rather
'' than the type table, which this module does not have.
function ClampConstToTypeRef _
    ( byref ast as Tko.AstArena, byval tref as Tko.NodeId, _
      byref v as ConstVal, byval intBits as long ) as ConstVal

    if v.known = false then return v
    if tref = Tko.NODE_NONE then return v
    if ast.Kind( tref ) <> Tko.N_TYPEREF then return v
    dim as Tko.AstNode ptr tn = @ast.nodes[cast( long, tref )]
    if (tn->flags and Tko.NF_PTR) <> 0 then return v
    if (tn->flags and Tko.NF_PROC_TYPE) <> 0 then return v
    dim as Tko.StmtPayload ptr tp = _
        @ast.stmts[cast( long, ast.nodes[cast( long, tref )].data )]
    dim as long bits = 0
    dim as boolean uns = false
    select case cast( Tko.TokenKind, tp->op )
    case Tko.KW_BYTE     : bits = 8
    case Tko.KW_UBYTE    : bits = 8  : uns = true
    case Tko.KW_SHORT    : bits = 16
    case Tko.KW_USHORT   : bits = 16 : uns = true
    case Tko.KW_LONG     : bits = 32
    case Tko.KW_ULONG    : bits = 32 : uns = true
    case Tko.KW_INTEGER  : bits = intBits
    case Tko.KW_UINTEGER : bits = intBits : uns = true
    case Tko.KW_LONGINT  : bits = 64
    case Tko.KW_ULONGINT : bits = 64 : uns = true
    case else            : return v
    end select
    '' TRUNCATED AT THE DECLARED WIDTH, by hand: CVW_ rounds every width up to 32 or
    '' 64 and sign-extends, so it cannot say 255 for a ubyte at all.
    dim as ulongint mask = &hFFFFFFFFFFFFFFFFull
    if bits < 64 then mask = (1ull shl bits) - 1
    dim as ulongint raw = cast( ulongint, v.value ) and mask
    if uns = false then
        dim as ulongint signBit = 1ull shl (bits - 1)
        if (raw and signBit) <> 0 then raw or= (not mask)
    end if
    dim as ConstVal r
    r.known = true
    r.bits = iif( bits <= 32, 32, 64 )
    r.value = cast( longint, raw )
    r.uns = uns
    return r
end function
function ConstOf _
    ( byref ast as Tko.AstArena, byval id as Tko.NodeId, _
      byref src as Tko.SourceManager, byref names as Tko.Interner, _
      byval intBits as long = 64, byval syms as Tko.SymbolTable ptr = 0, _
      byval scope_ as Tko.ScopeId = 0, byval depth as long = 0 ) as ConstVal

    if id = Tko.NODE_NONE then return CVNone_( )

    select case ast.Kind( id )
    case Tko.N_INT_LIT
        dim as Tko.LiteralPayload ptr lp = _
            @ast.literals[cast( long, ast.nodes[cast( long, id )].data )]
        dim as longint iv = cast( longint, lp->intValue )
        return CVWU_( iv, LitBits_( lp->suffix, iv, intBits ), _
                      SuffixUnsigned_( lp->suffix ) )

    case Tko.N_IDENT
        '' A NAMED CONSTANT in a constant expression. 'const MAX = 9' followed by
        '' 'dim as zstring * (MAX+1) z' is 10 bytes to fbc, and folding stopped dead
        '' here: with no N_IDENT case at all, every length written with a name was
        '' unknown, the ZSTRING stayed a bare builtin, and MIR could only type the
        '' slot 'void'.
        ''
        '' Needs the symbol table, which this routine did not take. It is OPTIONAL --
        '' callers that have no scope to look in pass nothing and get the old answer,
        '' which is the honest one for them.
        if syms = 0 then return CVNone_( )
        if depth >= 16 then return CVNone_( )
        dim as Tko.InternId inm = _
            ast.idents[cast( long, ast.nodes[cast( long, id )].data )].name
        dim as Tko.SymbolId csid = syms->Lookup( scope_, inm )
        if csid = Tko.SYMBOL_NONE then return CVNone_( )
        dim as Tko.Symbol ptr cs = syms->SymbolAt( csid )
        if cs = 0 then return CVNone_( )
        '' An ENUM MEMBER folds to its number directly: Resolve worked the numbering
        '' out once and put THE VALUE in 'payload', where a plain constant keeps a node
        '' id. The symbol kind is what says which, and reading one as the other indexes
        '' the wrong pool.
        if cs->kind = cast( ubyte, Tko.SYM_ENUMCONST ) then
            return CVW_( cast( longint, cs->payload ), 32 )
        end if
        if cs->kind <> cast( ubyte, Tko.SYM_CONSTANT ) then return CVNone_( )

        '' A PREDECLARED constant -- 'true' and 'false' -- keeps THE VALUE in 'payload'
        '' where a user constant keeps a node id, which is what SYMF_BUILTIN exists to
        '' say. Reading one as the other indexed the node arena at -1 and ABORTED THE
        '' COMPILER: '#assert( X = true )' crashed tiko-lang outright, in two corpus files.
        '' The same payload-pool mistake this codebase has now made seven times, made
        '' here by the code that added this case.
        if (cs->flags and Tko.SYMF_BUILTIN) <> 0 then
            return CVW_( cast( longint, cs->payload ), 32 )
        end if

        if cs->payload = 0 then return CVNone_( )
        dim as Tko.NodeId citem = cast( Tko.NodeId, cs->payload )
        if ast.Kind( citem ) <> Tko.N_VAR_ITEM then return CVNone_( )
        dim as Tko.StmtPayload ptr cip = _
            @ast.stmts[cast( long, ast.nodes[cast( long, citem )].data )]
        dim as ConstVal ivv = _
            ConstOf( ast, cip->b, src, names, intBits, syms, cs->parent, depth + 1 )
        '' AT THE CONSTANT'S OWN DECLARED WIDTH AND SIGNEDNESS.
        ''
        '' 'const v as ubyte = not u' folded to the INITIALISER's value and stopped
        '' there, so v was -1 where fbc has 255 -- measured, fbc's C for
        '' 'dim as integer x = v' is 'X = 255ll'. The declared type is the whole
        '' point of an unsigned constant and nothing here was reading it.
        ''
        '' A POINTER or a proc type is left alone: its value is an address, not a
        '' number to truncate.
        return ClampConstToTypeRef( ast, cip->a, ivv, intBits )

    case Tko.N_PAREN
        dim as Tko.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return CVNone_( )
        return ConstOf( ast, cast( Tko.NodeId, ast.children[pp->first] ), src, names, _
                        intBits, syms, scope_, depth )

    case Tko.N_UNARY
        dim as Tko.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as ConstVal v = ConstOf( ast, up->operand, src, names, intBits, syms, scope_, depth )
        if v.known = false then return CVNone_( )
        '' A unary operator folds at its OPERAND's width: 'not 0' is -1 either way, but
        '' '-(1 shl 31)' at 32 bits is 2147483648 rather than -2147483648.
        select case cast( Tko.TokenKind, up->op )
        case Tko.TK_MINUS : return CVWU_( -v.value, v.bits, v.uns )
        case Tko.TK_PLUS  : return CVWU_( v.value, v.bits, v.uns )
        case Tko.KW_NOT   : return CVWU_( not v.value, v.bits, v.uns )
        end select
        return CVNone_( )

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @ast.binaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as ConstVal l = ConstOf( ast, bp->lhs, src, names, intBits, syms, scope_, depth )
        if l.known = false then return CVNone_( )
        dim as ConstVal r = ConstOf( ast, bp->rhs, src, names, intBits, syms, scope_, depth )
        if r.known = false then return CVNone_( )
        dim as longint a = l.value
        dim as longint b = r.value
        '' The operator folds at the WIDER operand's width, and the result is narrowed
        '' back to it. A COMPARISON is not arithmetic: its result is INTEGER, so it takes
        '' the target's width whatever the operands were.
        dim as long w = WiderOf_( l, r )
        '' FreeBASIC's promotion: an operator with ONE unsigned operand is unsigned.
        dim as boolean uw = l.uns orelse r.uns

        '' Compared as UNSIGNED when either side is. At 32 bits only the low half
        '' counts, because that is the value's real width -- comparing the
        '' sign-extended 64-bit form would make every negative-looking 32-bit constant
        '' larger than it is.
        dim as ulongint ua = cast( ulongint, a )
        dim as ulongint ub = cast( ulongint, b )
        if w = 32 then
            ua = cast( ulongint, cast( ulong, a ) )
            ub = cast( ulongint, cast( ulong, b ) )
        end if

        '' SHIFTS are done at the operand width, so '1 shl 31' is -2147483648 on win32
        '' and 2147483648 on win64, and '1 shl 32' is 1 there and 4294967296 here. That
        '' is a wrap, not an error: fbc warns and carries on.
        dim as longint sb = b
        if (w = 32) andalso (sb >= 0) then sb = sb and 31

        select case cast( Tko.TokenKind, bp->op )
        case Tko.TK_PLUS      : return CVWU_( a + b, w, uw )
        case Tko.TK_MINUS     : return CVWU_( a - b, w, uw )
        case Tko.TK_STAR      : return CVWU_( a * b, w, uw )
        case Tko.TK_BACKSLASH
            if b = 0 then return CVNone_( )
            return CVW_( a \ b, w )
        case Tko.KW_MOD
            if b = 0 then return CVNone_( )
            return CVW_( a mod b, w )
        case Tko.TK_CARET     : return CVW_( IPow_( a, b ), w )
        case Tko.KW_SHL       : return CVW_( a shl sb, w )
        case Tko.KW_SHR
            '' SHR is ARITHMETIC, and at 32 bits it must shift the 32-bit value rather
            '' than the sign-extended one: '&hFFFFFFFF shr 4' is -1 shr 4 = -1.
            if w = 32 then return CVW_( cast( longint, cast( long, a ) ) shr sb, w )
            return CVW_( a shr sb, w )
        case Tko.KW_AND       : return CVW_( a and b, w )
        case Tko.KW_OR        : return CVW_( a or b, w )
        case Tko.KW_XOR       : return CVW_( a xor b, w )
        case Tko.KW_EQV       : return CVW_( a eqv b, w )
        case Tko.KW_IMP       : return CVW_( a imp b, w )
        case Tko.TK_EQ        : return CVBool_( a = b )
        case Tko.TK_NE        : return CVBool_( a <> b )
        case Tko.TK_LT
            if uw then return CVBool_( ua < ub )
            return CVBool_( a < b )
        case Tko.TK_GT
            if uw then return CVBool_( ua > ub )
            return CVBool_( a > b )
        case Tko.TK_LE
            if uw then return CVBool_( ua <= ub )
            return CVBool_( a <= b )
        case Tko.TK_GE
            if uw then return CVBool_( ua >= ub )
            return CVBool_( a >= b )
        case Tko.KW_ANDALSO   : return CVBool_( (a <> 0) andalso (b <> 0) )
        case Tko.KW_ORELSE    : return CVBool_( (a <> 0) orelse (b <> 0) )
        end select
        return CVNone_( )

    case Tko.N_CALL
        return ConstCall_( ast, id, src, names, intBits, syms, scope_, depth )
    end select

    return CVNone_( )
end function

end namespace

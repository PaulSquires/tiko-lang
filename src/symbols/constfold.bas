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

namespace Fbx.Check

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

    select case cast( Fbx.NumSuffix, suffix )
    case Fbx.NSUF_LONG, Fbx.NSUF_ULONG, Fbx.NSUF_INTEGER, Fbx.NSUF_UINTEGER
        '' '%' and 'U' are INTEGER and UINTEGER, which are pointer-width; 'L' and 'UL'
        '' are LONG and ULONG, which are 32 everywhere.
        select case cast( Fbx.NumSuffix, suffix )
        case Fbx.NSUF_LONG, Fbx.NSUF_ULONG : return 32
        end select
        return intBits
    case Fbx.NSUF_LONGINT, Fbx.NSUF_ULONGINT
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
    select case cast( Fbx.NumSuffix, suffix )
    case Fbx.NSUF_UINTEGER, Fbx.NSUF_ULONG, Fbx.NSUF_ULONGINT
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
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, byref d as double ) as boolean

    if id = Fbx.NODE_NONE then return false
    dim as Fbx.NodeKind k = ast.Kind( id )
    if k = Fbx.N_PAREN then
        dim as Fbx.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return false
        return LitNum_( ast, cast( Fbx.NodeId, ast.children[pp->first] ), d )
    end if
    if k = Fbx.N_UNARY then
        dim as Fbx.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        if LitNum_( ast, up->operand, d ) = false then return false
        if cast( Fbx.TokenKind, up->op ) = Fbx.TK_MINUS then d = -d
        return true
    end if
    dim as Fbx.LiteralPayload ptr lp = 0
    if (k = Fbx.N_FLOAT_LIT) orelse (k = Fbx.N_INT_LIT) then
        lp = @ast.literals[cast( long, ast.nodes[cast( long, id )].data )]
    end if
    if lp = 0 then return false
    if k = Fbx.N_FLOAT_LIT then
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
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, byref outd as double, _
      byval depth as long = 0 ) as boolean

    if id = Fbx.NODE_NONE then return false
    if depth > 32 then return false

    select case ast.Kind( id )
    case Fbx.N_FLOAT_LIT, Fbx.N_INT_LIT
        return LitNum_( ast, id, outd )

    case Fbx.N_PAREN
        dim as Fbx.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return false
        return ConstFloatOf( ast, cast( Fbx.NodeId, ast.children[pp->first] ), _
                             outd, depth + 1 )

    case Fbx.N_UNARY
        dim as Fbx.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        if ConstFloatOf( ast, up->operand, outd, depth + 1 ) = false then return false
        select case cast( Fbx.TokenKind, up->op )
        case Fbx.TK_MINUS : outd = -outd
        case Fbx.TK_PLUS
        case else : return false
        end select
        return true

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = _
            @ast.binaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as double l, r
        if ConstFloatOf( ast, bp->lhs, l, depth + 1 ) = false then return false
        if ConstFloatOf( ast, bp->rhs, r, depth + 1 ) = false then return false
        select case cast( Fbx.TokenKind, bp->op )
        case Fbx.TK_PLUS  : outd = l + r
        case Fbx.TK_MINUS : outd = l - r
        case Fbx.TK_STAR  : outd = l * r
        case Fbx.TK_SLASH
            if r = 0.0 then return false
            outd = l / r
        case else : return false
        end select
        return true
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
private function ConstCall_ _
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, _
      byref src as Fbx.SourceManager, byref names as Fbx.Interner ) as ConstVal

    dim as Fbx.ListPayload ptr cp = _
        @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return CVNone_( )
    if ast.Kind( cp->target ) <> Fbx.N_IDENT then return CVNone_( )
    dim as Fbx.IdentPayload ptr ip = _
        @ast.idents[cast( long, ast.nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( names.Spelling( ip->name ) )

    if (nm = "iif") andalso (cp->count = 3) then
        dim as ConstVal c = ConstOf( ast, cast( Fbx.NodeId, ast.children[cp->first] ), _
                                     src, names )
        if c.known = false then return CVNone_( )
        dim as long pick = iif( c.value <> 0, 1, 2 )
        return ConstOf( ast, cast( Fbx.NodeId, ast.children[cp->first + pick] ), _
                        src, names )
    end if

    if cp->count <> 1 then return CVNone_( )
    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, ast.children[cp->first] )

    '' LEN and ASC read the literal's SPAN out of the source buffer: the parser keeps
    '' the extent, not the decoded text.
    if (nm = "len") orelse (nm = "asc") then
        if ast.Kind( a0 ) <> Fbx.N_STRING_LIT then return CVNone_( )
        dim as Fbx.LiteralPayload ptr lp = _
            @ast.literals[cast( long, ast.nodes[cast( long, a0 )].data )]
        if nm = "len" then return CV_( lp->strLength )
        if lp->strLength <= 0 then return CVNone_( )
        dim as Fbx.DecodedLoc dl = src.Decode( ast.Loc( a0 ) )
        dim as Fbx.SourceFile ptr f = src.FileAt( dl.file )
        if f = 0 then return CVNone_( )
        if lp->strOffset >= f->text.Count then return CVNone_( )
        return CV_( f->text[lp->strOffset] )
    end if

    dim as double d = 0
    dim as boolean isNum = LitNum_( ast, a0, d )
    dim as ConstVal iv = ConstOf( ast, a0, src, names )

    select case nm
    case "abs"
        if iv.known then return CV_( abs( iv.value ) )
    case "sgn"
        if iv.known then return CV_( sgn( iv.value ) )
    case "cint", "clngint"
        if isNum then
            dim as longint r = RoundHalfEven_( d )
            if nm = "cint" then return CV_( r )
            return CV_( r )
        end if
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
    case "int"
        if isNum then return CV_( cast( longint, int( d ) ) )
    case "fix"
        if isNum then return CV_( cast( longint, fix( d ) ) )

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
        if iv.known then return CVWU_( iv.value, 64, true )
    case "cbool"
        '' A FreeBASIC truth value is -1, never 1.
        if iv.known then return CV_( iif( iv.value <> 0, -1, 0 ) )
    end select
    return CVNone_( )
end function

function ConstOf _
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, _
      byref src as Fbx.SourceManager, byref names as Fbx.Interner, _
      byval intBits as long = 64, byval syms as Fbx.SymbolTable ptr = 0, _
      byval scope_ as Fbx.ScopeId = 0, byval depth as long = 0 ) as ConstVal

    if id = Fbx.NODE_NONE then return CVNone_( )

    select case ast.Kind( id )
    case Fbx.N_INT_LIT
        dim as Fbx.LiteralPayload ptr lp = _
            @ast.literals[cast( long, ast.nodes[cast( long, id )].data )]
        dim as longint iv = cast( longint, lp->intValue )
        return CVWU_( iv, LitBits_( lp->suffix, iv, intBits ), _
                      SuffixUnsigned_( lp->suffix ) )

    case Fbx.N_IDENT
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
        dim as Fbx.InternId inm = _
            ast.idents[cast( long, ast.nodes[cast( long, id )].data )].name
        dim as Fbx.SymbolId csid = syms->Lookup( scope_, inm )
        if csid = Fbx.SYMBOL_NONE then return CVNone_( )
        dim as Fbx.Symbol ptr cs = syms->SymbolAt( csid )
        if cs = 0 then return CVNone_( )
        '' An ENUM MEMBER folds to its number directly: Resolve worked the numbering
        '' out once and put THE VALUE in 'payload', where a plain constant keeps a node
        '' id. The symbol kind is what says which, and reading one as the other indexes
        '' the wrong pool.
        if cs->kind = cast( ubyte, Fbx.SYM_ENUMCONST ) then
            return CVW_( cast( longint, cs->payload ), 32 )
        end if
        if cs->kind <> cast( ubyte, Fbx.SYM_CONSTANT ) then return CVNone_( )

        '' A PREDECLARED constant -- 'true' and 'false' -- keeps THE VALUE in 'payload'
        '' where a user constant keeps a node id, which is what SYMF_BUILTIN exists to
        '' say. Reading one as the other indexed the node arena at -1 and ABORTED THE
        '' COMPILER: '#assert( X = true )' crashed fbx outright, in two corpus files.
        '' The same payload-pool mistake this codebase has now made seven times, made
        '' here by the code that added this case.
        if (cs->flags and Fbx.SYMF_BUILTIN) <> 0 then
            return CVW_( cast( longint, cs->payload ), 32 )
        end if

        if cs->payload = 0 then return CVNone_( )
        dim as Fbx.NodeId citem = cast( Fbx.NodeId, cs->payload )
        if ast.Kind( citem ) <> Fbx.N_VAR_ITEM then return CVNone_( )
        dim as Fbx.StmtPayload ptr cip = _
            @ast.stmts[cast( long, ast.nodes[cast( long, citem )].data )]
        return ConstOf( ast, cip->b, src, names, intBits, syms, cs->parent, depth + 1 )

    case Fbx.N_PAREN
        dim as Fbx.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return CVNone_( )
        return ConstOf( ast, cast( Fbx.NodeId, ast.children[pp->first] ), src, names, _
                        intBits, syms, scope_, depth )

    case Fbx.N_UNARY
        dim as Fbx.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as ConstVal v = ConstOf( ast, up->operand, src, names, intBits, syms, scope_, depth )
        if v.known = false then return CVNone_( )
        '' A unary operator folds at its OPERAND's width: 'not 0' is -1 either way, but
        '' '-(1 shl 31)' at 32 bits is 2147483648 rather than -2147483648.
        select case cast( Fbx.TokenKind, up->op )
        case Fbx.TK_MINUS : return CVWU_( -v.value, v.bits, v.uns )
        case Fbx.TK_PLUS  : return CVWU_( v.value, v.bits, v.uns )
        case Fbx.KW_NOT   : return CVWU_( not v.value, v.bits, v.uns )
        end select
        return CVNone_( )

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = _
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

        select case cast( Fbx.TokenKind, bp->op )
        case Fbx.TK_PLUS      : return CVWU_( a + b, w, uw )
        case Fbx.TK_MINUS     : return CVWU_( a - b, w, uw )
        case Fbx.TK_STAR      : return CVWU_( a * b, w, uw )
        case Fbx.TK_BACKSLASH
            if b = 0 then return CVNone_( )
            return CVW_( a \ b, w )
        case Fbx.KW_MOD
            if b = 0 then return CVNone_( )
            return CVW_( a mod b, w )
        case Fbx.TK_CARET     : return CVW_( IPow_( a, b ), w )
        case Fbx.KW_SHL       : return CVW_( a shl sb, w )
        case Fbx.KW_SHR
            '' SHR is ARITHMETIC, and at 32 bits it must shift the 32-bit value rather
            '' than the sign-extended one: '&hFFFFFFFF shr 4' is -1 shr 4 = -1.
            if w = 32 then return CVW_( cast( longint, cast( long, a ) ) shr sb, w )
            return CVW_( a shr sb, w )
        case Fbx.KW_AND       : return CVW_( a and b, w )
        case Fbx.KW_OR        : return CVW_( a or b, w )
        case Fbx.KW_XOR       : return CVW_( a xor b, w )
        case Fbx.KW_EQV       : return CVW_( a eqv b, w )
        case Fbx.KW_IMP       : return CVW_( a imp b, w )
        case Fbx.TK_EQ        : return CVBool_( a = b )
        case Fbx.TK_NE        : return CVBool_( a <> b )
        case Fbx.TK_LT
            if uw then return CVBool_( ua < ub )
            return CVBool_( a < b )
        case Fbx.TK_GT
            if uw then return CVBool_( ua > ub )
            return CVBool_( a > b )
        case Fbx.TK_LE
            if uw then return CVBool_( ua <= ub )
            return CVBool_( a <= b )
        case Fbx.TK_GE
            if uw then return CVBool_( ua >= ub )
            return CVBool_( a >= b )
        case Fbx.KW_ANDALSO   : return CVBool_( (a <> 0) andalso (b <> 0) )
        case Fbx.KW_ORELSE    : return CVBool_( (a <> 0) orelse (b <> 0) )
        end select
        return CVNone_( )

    case Fbx.N_CALL
        return ConstCall_( ast, id, src, names )
    end select

    return CVNone_( )
end function

end namespace

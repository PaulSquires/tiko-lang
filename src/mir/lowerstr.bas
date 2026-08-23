'' lowerstr.bas -- string lowering and the runtime call helper.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The division
'' is by subject rather than by size: everything here is about the string runtime.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' Defined below; the wide-string helpers above it classify a narrow operand.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' PushStrArg and PushStrLiteralArg are declared in lowerctx.bi now: lowerterm.bas
'' calls both, so they are no longer local to this file.
declare function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean


'' 'a = b + a'. The chain is built in an anonymous FBSTRING slot and then assigned.
''
'' The temporary is NEVER deleted here, and that is measured rather than assumed: fbc
'' emits a plain 'FBSTRING TMP;' local and no fb_StrDelete for it. The runtime frees
'' the temp descriptor when it is handed to fb_StrAssign, so deleting it as well would
'' be a double free.
private function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean

    if terms.Count < 2 then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    '' fb_StrConcat takes the destination descriptor first, then the two operands.
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) )
    args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ) ) = false then return false
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[1] ) ) = false then return false
    dim as MirValue acc = EmitRtl( c, RTL_STR_CONCAT, args )

    '' Any further terms concatenate onto the temporary in place.
    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Tko.NodeId, terms[i] ) ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) )
        more.Push( 0 )
        EmitRtl( c, RTL_STR_CONCAT_ASSIGN, more )
    next

    dim as FB.Array( of ulong ) fin
    PushStrArg( fin, dst )
    PushStrArg( fin, tmp )
    fin.Push( cast( ulong, MV_CONST_INT ) )
    fin.Push( 0 )
    EmitRtl( c, RTL_STR_ASSIGN, fin )
    return true
end function

'' A NARROW CONCATENATION AS A TEMPORARY DESCRIPTOR, for the readers that want a value
'' rather than a destination: PRINT, and anything else fbc hands an FBSTRING* to.
''
''     __builtin_memset( &TMP, 0, 24ll );
''     fb_StrConcat( &TMP, (void*)&S, -1ll, (void*)"x", 2ll );
''     fb_PrintString( 0, (FBSTRING*)&TMP, 1 );
''
'' 'print s & "x"' declined without it: the print path asked a BINARY for an address.
function ConcatToTempDesc_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    if e = Tko.NODE_NONE then return false
    if c.ast->Kind( e ) <> Tko.N_BINARY then return false
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, e, terms )
    return ConcatTermsToTempDesc_( c, terms, outv )
end function

'' The same, over a term list that has already been flattened -- which is how the WIDE
'' path folds the NARROW PREFIX of a mixed chain: 'x & ", " & w' is a narrow concat of
'' the first two and only then a wide one.
function ConcatTermsToTempDesc_ _
    ( byref c as Ctx, byref terms as FB.Array( of ulong ), _
      byref outv as MirValue ) as boolean

    if terms.Count < 2 then return false

    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot
    ZeroStrDescriptor( c, tmp )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) ) : args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ) ) = false then return false
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[1] ) ) = false then return false
    EmitRtl( c, RTL_STR_CONCAT, args )

    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Tko.NodeId, terms[i] ) ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) )
        more.Push( 0 )
        EmitRtl( c, RTL_STR_CONCAT_ASSIGN, more )
    next

    outv = tmp
    return true
end function

'' Up to 'maxDigits' digits in 'radix', greedy, value clamped to a byte. Shared by
'' the hex escape and the three '&' forms, which differ only in radix and digit count.
private function ReadRadix_ _
    ( byref f as Tko.SourceFile, byval base_ as long, byval limit as long, _
      byref i as long, byval radix as long, byval maxDigits as long ) as long

    dim as long v = 0
    dim as long d = 0
    while (d < maxDigits) andalso (i < limit)
        dim as ubyte k = f.text[base_ + i]
        dim as long dv = -1
        if (k >= 48) andalso (k <= 57) then
            dv = k - 48
        elseif (k >= 97) andalso (k <= 122) then
            dv = k - 97 + 10
        elseif (k >= 65) andalso (k <= 90) then
            dv = k - 65 + 10
        end if
        if (dv < 0) orelse (dv >= radix) then exit while
        v = v * radix + dv
        i += 1
        d += 1
    wend
    if v > 255 then v = 255
    return v
end function

'' One escape, 'i' indexing the BACKSLASH. Returns the byte, or -1 for an escape that
'' produces NOTHING, and advances 'i' past everything consumed.
''
'' Every rule here was measured by RUNNING a program fbc compiled --
'' tools/gen/escape-truth.py holds the probe, tests/types/expected/fbc-escape.txt the
'' answers, and tools/gen/check-escape.sh replays all 47 of them.
private function DecodeEscape_ _
    ( byref f as Tko.SourceFile, byval base_ as long, byval limit as long, _
      byref i as long ) as long

    i += 1                                  '' past the backslash
    if i >= limit then return 92             '' a trailing backslash is itself

    dim as ubyte c = f.text[base_ + i]

    '' The ten NAMED escapes, CASE-SENSITIVELY. An uppercase N is the letter N, not a
    '' newline. Nothing else is named: there is no ESC escape and no NUL escape, and
    '' the corpus depends on it -- logger_sinks.bas writes what looks like an ANSI
    '' colour sequence and fbc emits a plain letter e.
    select case c
    case asc( "a" ) : i += 1 : return 7
    case asc( "b" ) : i += 1 : return 8
    case asc( "f" ) : i += 1 : return 12
    case asc( "n" ) : i += 1 : return 10
    case asc( "r" ) : i += 1 : return 13
    case asc( "t" ) : i += 1 : return 9
    case asc( "v" ) : i += 1 : return 11
    case 92         : i += 1 : return 92
    case 34         : i += 1 : return 34
    case 39         : i += 1 : return 39
    end select

    '' DECIMAL, not octal -- three digits reading 101 is byte 101, not 65. One to three
    '' digits, greedy, and the value CLAMPS at 255 rather than wrapping.
    if (c >= 48) andalso (c <= 57) then
        dim as long v = 0
        dim as long d = 0
        while (d < 3) andalso (i < limit)
            dim as ubyte k = f.text[base_ + i]
            if (k < 48) orelse (k > 57) then exit while
            v = v * 10 + (k - 48)
            i += 1
            d += 1
        wend
        if v > 255 then v = 255
        return v
    end if

    '' HEX, at most TWO digits: four hex characters after it are one byte and then two
    '' letters of ordinary text. Zero digits is allowed and yields 0.
    if (c = asc( "x" )) orelse (c = asc( "X" )) then
        i += 1
        return ReadRadix_( f, base_, limit, i, 16, 2 )
    end if

    '' The radix forms: h hex (2 digits), o octal (3), b binary (8). An unknown radix
    '' letter makes the marker VANISH and leaves the rest as text, which is why this
    '' returns -1 rather than a byte.
    if c = 38 then
        if i + 1 < limit then
            dim as ubyte r = f.text[base_ + i + 1]
            select case r
            case asc( "h" ), asc( "H" )
                i += 2 : return ReadRadix_( f, base_, limit, i, 16, 2 )
            case asc( "o" ), asc( "O" )
                i += 2 : return ReadRadix_( f, base_, limit, i, 8, 3 )
            case asc( "b" ), asc( "B" )
                i += 2 : return ReadRadix_( f, base_, limit, i, 2, 8 )
            end select
        end if
        i += 1
        return -1
    end if

    '' ANYTHING ELSE is the character itself, and is NEVER an error.
    i += 1
    return c
end function

'' The text of a string literal. The parser records the span rather than the decoded
'' bytes, so it is read back out of the source buffer here.
'' THE EXPRESSION INSIDE A REDUNDANT '( )'. The parser keeps parentheses -- diagnostics
'' and faithful dumps both want them -- so every recogniser that matches on SHAPE has to
'' see through one, and none of them did: '(str(a)) = (str(b))' declined where
'' 'str(a) = str(b)' beside it lowered, which is the shape fbcunit's CU_ASSERT_EQUAL
'' macro writes for every one of its arguments.
''
'' A parenthesised LIST is not a redundant paren and is left alone.
function Unparen_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.NodeId
    dim as Tko.NodeId n = id
    for guard as long = 0 to 15
        if n = Tko.NODE_NONE then return n
        if c.ast->Kind( n ) <> Tko.N_PAREN then return n
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if lp->count <> 1 then return n
        n = cast( Tko.NodeId, c.ast->children[lp->first] )
    next
    return n
end function

function StringLitText_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as string

    if c.ast->Kind( id ) <> Tko.N_STRING_LIT then return ""
    dim as Tko.LiteralPayload ptr lp = _
        @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->strLength <= 0 then return ""
    '' The literal's OWN file, not the node's loc: a literal built by macro expansion is
    '' repointed at the use site for diagnostics, and its text does not live there.
    dim as Tko.SourceFile ptr f = c.srcMgr->FileAt( cast( Tko.FileId, lp->strFile ) )
    if f = 0 then return ""
    if (lp->strOffset + lp->strLength) > f->text.Count then return ""
    '' '""' inside a literal is ONE quote -- measured: len( $"q""q" ) is 3. The lexer
    '' already refuses to end the literal there, but the span it records is the RAW
    '' source, so the collapse has to happen on the way out. Without it every
    '' stringised argument containing a quote would carry an extra byte, which is the
    '' silent half of the bug the '$"..."' spelling fixes the loud half of.
    ''
    dim as string r = space( lp->strLength )
    dim as long n = 0
    dim as long i = 0

    '' An ESCAPED literal containing a unicode escape is left ALONE. Those promote the
    '' whole literal to a WSTRING -- measured, the type of one is WSTRING against
    '' ZSTRING for a literal holding only byte escapes -- and tiko-lang does not model a wide
    '' literal. Decoding the byte escapes around it and dropping the wide ones would
    '' produce a literal that is neither compiler's answer. 2120 occurrences in the
    '' corpus, and they stay an OPEN GAP rather than a wrong one.
    dim as boolean decode = (lp->strKind = cast( ubyte, Tko.STRK_ESCAPED ))
    if decode then
        for k as long = 0 to lp->strLength - 2
            if f->text[lp->strOffset + k] = 92 then
                dim as ubyte nx = f->text[lp->strOffset + k + 1]
                if (nx = asc( "u" )) orelse (nx = asc( "U" )) then
                    decode = false
                    exit for
                end if
            end if
        next
    end if

    while i < lp->strLength
        dim as ubyte ch = f->text[lp->strOffset + i]

        if decode andalso (ch = 92) then
            dim as long b = DecodeEscape_( *f, lp->strOffset, lp->strLength, i )
            '' A NUL from a numeric escape ENDS the literal, at compile time: fbc puts
            '' the bytes before it into the target and the rest never exists.
            if b = 0 then exit while
            if b > 0 then
                r[n] = cast( ubyte, b )
                n += 1
            end if
            continue while
        end if

        r[n] = ch
        n += 1
        dim as boolean doubledQuote = (ch = 34) andalso (i + 1 < lp->strLength) andalso _
                                      (f->text[lp->strOffset + i + 1] = 34)
        i += iif( doubledQuote, 2, 1 )
    wend
    return left( r, n )
end function


'' THE TEXT OF A STRING CONSTANT, folded here because the constant evaluator cannot
'' carry one: ConstVal.value is a longint, so 'const F = "f.txt"' has no value it can
'' return and every use of F declined -- the assignment, the PRINT, and the filename of
'' every OPEN in the corpus's file tests, which is how they all name their file.
''
'' Only literals and the concatenation of literals are folded, which is what a constant
'' declaration can hold: fbc rejects a non-constant initialiser outright.
function ConstStringTextOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outText as string, _
      byval depth as long = 0 ) as boolean

    if id = Tko.NODE_NONE then return false
    if depth > 16 then return false

    select case c.ast->Kind( id )
    case Tko.N_STRING_LIT
        outText = StringLitText_( c, id )
        return true

    case Tko.N_PAREN
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if lp->count <> 1 then return false
        return ConstStringTextOf_( c, cast( Tko.NodeId, c.ast->children[lp->first] ), _
                                   outText, depth + 1 )

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TokenKind op = cast( Tko.TokenKind, bp->op )
        if (op <> Tko.TK_AMP) andalso (op <> Tko.TK_PLUS) then return false
        dim as string lt, rt
        if ConstStringTextOf_( c, bp->lhs, lt, depth + 1 ) = false then return false
        if ConstStringTextOf_( c, bp->rhs, rt, depth + 1 ) = false then return false
        outText = lt + rt
        return true

    case Tko.N_IDENT
        '' The constant's payload is its N_VAR_ITEM, whose 'b' is the initialiser --
        '' the same shape the integer folder reads, and read as the same pool.
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( c.info->RefOf( id ) )
        if cs = 0 then return false
        if cs->kind <> cast( ubyte, Tko.SYM_CONSTANT ) then return false
        if (cs->flags and Tko.SYMF_BUILTIN) <> 0 then return false
        if cs->payload = 0 then return false
        dim as Tko.NodeId item = cast( Tko.NodeId, cs->payload )
        if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then return false
        return ConstStringTextOf_( c, StmtOf( c, item )->b, outText, depth + 1 )
    end select
    return false
end function

'' ------------------------------------------------------------------ runtime

'' A call to a runtime function, by table id. Nothing here spells a runtime name: the
'' inventory is the only place that does (docs/plan/11 section 3).
function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue

    dim as MirValue v
    '' The LINKER-VISIBLE name, which on win32 carries the underscore and the stdcall
    '' '@N'. A 32-bit pointer means win32: Linux is 64-bit only by decision.
    dim as boolean is32 = (c.types->target.pointerBits = 32)
    dim as Tko.InternId nm = c.names->GetString( RtlLinkName( r, is32 ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, RtlReturn( r, is32 ) )
        decl->isDefinition = false
        decl->paramCount = RtlArity( r )
        fidx = c.m->functions.Count - 1
    end if

    dim as long first = c.m->argPool.Count \ 2
    for i as long = 0 to args.Count - 1
        c.m->argPool.Push( args[i] )
    next

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL_RTL )
    ins.ty = cast( ubyte, RtlReturn( r, is32 ) )
    ins.first = first
    ins.count = args.Count \ 2
    ins.callee = fidx
    return Emit( c, ins )
end function

'' The (pointer, length) pair the string runtime takes. A var-length string is its
'' DESCRIPTOR's address with a length of -1; the runtime reads the length from the
'' descriptor itself.
'' A LITERAL is passed as its own bytes with a real length -- strlen PLUS ONE, for
'' the terminator: fbc emits 2 for "x" and 6 for "hello". Getting that off by one
'' truncates or overruns, and neither shows up near the cause.
'' A bare string literal in VALUE position: the ADDRESS of its bytes.
''
'' That is what a 'zstring ptr' parameter wants, and a parameter is the only context a
'' bare literal reaches here in -- PRINT and concatenation take their own paths, which
'' call AddStringLiteral directly because they need the length alongside the pointer.
''
'' Without this the literal lowered to NOTHING while the call around it still emitted:
'' 'call void P(%1, _, %2)', an undef where a pointer belonged, and the statement
'' counted as lowered.
'' The predeclared names that are VALUES rather than storage, or MV_NONE.
''
'' TRUE and FALSE have no slot to load from -- -1 and 0, one byte, measured -- and
'' __FUNCTION__ is a literal by the time it reaches lowering: the address of the
'' enclosing procedure's SOURCE name, which MirFunction cannot answer because it carries
'' the mangled one. Resolve has already typed it 'zstring * n'.
function LowerPredeclared _
    ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    dim as MirValue v
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return v
    if (s->flags and Tko.SYMF_BUILTIN) <> 0 then
        return ConstInt( c, cast( longint, s->payload ), MT_I8 )
    end if
    if (s->flags and Tko.SYMF_FUNCNAME) <> 0 then
        return LowerTextAddr( c, Tko.Mangle.ProcNameOrMain( _
            *c.syms, c.curProcSym, *c.names ) )
    end if

    '' A user CONST has no storage either -- 'const K = 7' emits no variable -- so it
    '' folds to its value. The payload is the declaration ITEM, and its initialiser is
    '' what the constant evaluator reads.
    ''
    '' A STRING constant folds to nothing here and falls through to decline, which is
    '' honest: ConstOf answers numbers, and a string constant needs a literal global.
    '' An ENUM MEMBER is a constant too, and its 'payload' is THE VALUE ITSELF rather
    '' than a declaration node -- the numbering is worked out once, in Resolve, because
    '' it depends on the members before it. Reading it as a node id here would index the
    '' statement pool with an integer that means something else entirely, which is the
    '' payload-pool mistake this codebase keeps making; the flag that says which is the
    '' SYMBOL KIND.
    if s->kind = cast( ubyte, Tko.SYM_ENUMCONST ) then
        dim as MirType emt = LowerType( c.info->TypeOf_( id ), *c.types )
        '' An enum is a 32-bit integer to fbc, and that is what an unrecognised type
        '' falls back to here rather than the i64 a plain constant would take.
        if (emt = MT_VOID) orelse (emt = MT_AGG) then emt = MT_I32
        return ConstInt( c, cast( longint, s->payload ), emt )
    end if

    if s->kind = cast( ubyte, Tko.SYM_CONSTANT ) then
        if s->payload = 0 then return v
        dim as Tko.NodeId item = cast( Tko.NodeId, s->payload )
        if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then return v
        dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
        dim as Tko.Check.ConstVal cv = _
            Tko.Check.ConstOf( *c.ast, ip->b, *c.srcMgr, *c.names, _
                               c.types->target.pointerBits, c.syms, s->parent )
        dim as MirType mt = LowerType( c.info->TypeOf_( id ), *c.types )
        if mt = MT_VOID then mt = MT_I64
        if (cv.known = false) andalso (IsFloatTy( mt ) = false) then return v
        '' ConstOf answers INTEGERS only, so a float constant never reaches here with
        '' a known value -- and must not be given one by casting an integer field to a
        '' double, which would make 'const PI = 3.5' into 3 without a word.
        ''
        '' It is lowered from its INITIALISER instead. A constant's initialiser is a
        '' constant expression, so lowering it emits the value directly, and no
        '' evaluator has to learn about floats to get there. Declining was 862 of one
        '' corpus file's statements -- every 'iif( c, T1, 0.0 )' over a
        '' 'const T1 as double', where BOTH arms came out empty.
        if IsFloatTy( mt ) then
            if cv.known then return v
            return LowerExpr( c, ip->b )
        end if
        return ConstInt( c, cv.value, mt )
    end if
    return v
end function

function LowerTextAddr _
    ( byref c as Ctx, byref text as string ) as MirValue

    dim as MirValue g
    g.kind = cast( ubyte, MV_GLOBAL )
    g.ty = cast( ubyte, MT_PTR )
    g.id = cast( ulong, c.m->AddStringLiteral( text, *c.names ) )
    return g
end function

function LowerStringLitAddr _
    ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue
    return LowerTextAddr( c, StringLitText_( c, id ) )
end function


sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
    args.Push( cast( ulong, MV_GLOBAL ) )
    args.Push( cast( ulong, gidx ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, nbytes + 1 ) )
end sub

sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
    args.Push( cast( ulong, addr.kind ) )
    args.Push( cast( ulong, addr.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( ulongint, -1 ) ) )
end sub


function IsStringType _
    ( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return false
    dim as Tko.BuiltinType b = c.types->BuiltinOf( t )
    return (b = Tko.TY_STRING) orelse (b = Tko.TY_USTRING)
end function

'' A USTRING -- the UTF-16 flavour, var-length or 'ustring * N'. It shares every SHAPE
'' with the narrow family, and that symmetry is exactly why it was a miscompile:
'' IsStringType says yes to both, so every narrow path claimed it and 'dim as ustring
'' v = "x"' lowered to fb_StrInit with a NARROW literal. A UTF-16 descriptor held
'' narrow bytes and fb_StrDelete was called on an FBUSTRING.
function IsUStringType _
    ( byref c as Ctx, byval t as Tko.TypeId ) as boolean

    if t = Tko.TYPE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    '' 'ustring * N' is an ARRAY of the fixed-ustring element.
    if c.types->Kind( u ) = Tko.TK_ARRAY then
        dim as Tko.TypeId e = c.types->Unqualify( c.types->Inner( u ) )
        if c.types->Kind( e ) <> Tko.TK_BUILTIN then return false
        return (c.types->BuiltinOf( e ) = Tko.TY_FIXUSTR)
    end if
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    return (c.types->BuiltinOf( u ) = Tko.TY_USTRING)
end function

'' The UTF-16 entry point matching a narrow one. One table rather than a test at each
'' of the twenty-odd call sites, so a new site cannot quietly use the narrow one.
function UStrRtl_( byval narrow as RtlId ) as RtlId
    select case narrow
    case RTL_STR_INIT          : return RTL_USTR_INIT
    case RTL_STR_ASSIGN        : return RTL_USTR_ASSIGN
    case RTL_STR_CONCAT_ASSIGN : return RTL_USTR_CONCAT_ASSIGN
    case RTL_STR_CONCAT        : return RTL_USTR_CONCAT
    case RTL_STR_COMPARE       : return RTL_USTR_COMPARE
    case RTL_STR_LEN           : return RTL_USTR_LEN
    case RTL_STR_DELETE        : return RTL_USTR_DELETE
    end select
    return narrow
end function

'' The same, chosen by the type at the site.
function StrRtlFor_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval narrow as RtlId ) as RtlId
    if IsUStringType( c, t ) then return UStrRtl_( narrow )
    return narrow
end function

'' THE LENGTH ARGUMENT OF A USTRING LITERAL. Measured: it is the CHARACTER COUNT with
'' the sign bit set -- '"abc"' is &h8000000000000003 -- and the NUL is NOT counted,
'' unlike the narrow family, where fb_StrInit is passed len+1.
sub PushUStrLiteralArg _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), byval gidx as long, _
      byval nchars as long )
    args.Push( cast( ulong, MV_GLOBAL ) )
    args.Push( cast( ulong, gidx ) )
    '' PushStrLen_, NOT a bare push: the tagged length does not fit in the 32-bit
    '' immediate an argument slot carries, and casting it to one truncates the SIGN
    '' BIT away -- '&h8000000000000001' became a plain 1, which is the tag gone and a
    '' length that happens to look right.
    PushStrLen_( c, args, FixedStrLenArg_( c, nchars ) )
end sub

'' 'a = b' and 'a = a + b' between var-length strings. Returns false when this is not
'' a string assignment, so the caller falls back to an ordinary store.


'' A string local at its DECLARATION, which is not the same as an assignment to it.
''
'' Measured from fbc:
''   dim as string a           ->  memset( &A, 0, 24 )
''   dim as string b = "hi"    ->  fb_StrInit( &B, -1, "hi", 3, 0 )
''   a = "x"                   ->  fb_StrAssign( &A, -1, "x", 2, 0 )
''
'' Init and Assign differ because Assign releases whatever the destination already
'' held; at a declaration there is nothing to release and the descriptor is garbage,
'' so calling Assign on it would free that garbage.
function LowerStringInit _
    ( byref c as Ctx, byval slot as long, byval target as Tko.NodeId, _
      byval value as Tko.NodeId ) as boolean

    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    if value = Tko.NODE_NONE then
        ZeroStrDescriptor( c, dst )
        return true
    end if

    '' A concatenation cannot go through fb_StrInit, which takes one source. Zero the
    '' descriptor so it is a valid empty string, then build into it the ordinary way.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )
    if terms.Count <> 1 then
        ZeroStrDescriptor( c, dst )
        if target = Tko.NODE_NONE then return true
        return LowerStringAssign( c, target, value )
    end if

    '' THE FLAVOUR COMES FROM THE DESTINATION. A ustring takes fb_UStrInit and a
    '' UTF-16 literal; sending it through the narrow entry point put narrow bytes in a
    '' UTF-16 descriptor, which lowered and verified.
    '' THE SLOT FIRST: 'target' here is the N_VAR_ITEM, which is a declaration rather
    '' than an expression and has no type of its own. Asking it gave TYPE_NONE, so
    '' every ustring declaration still took the narrow path.
    dim as boolean isU = false
    if slot >= 0 then isU = IsUStringType( c, c.f->locals[slot].frontendType )
    if isU = false then isU = IsUStringType( c, c.info->TypeOf_( target ) )

    dim as FB.Array( of ulong ) args
    PushStrArg( args, dst )
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ), isU ) = false then
        '' The source did not lower, so the descriptor must still be made valid --
        '' its fb_StrDelete is registered either way.
        ZeroStrDescriptor( c, dst )
        return false
    end if
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( 0 )
    EmitRtl( c, iif( isU, RTL_USTR_INIT, RTL_STR_INIT ), args )
    return true
end function


'' PRINT.
''
'' MEASURED from fbc (docs/internals/phase-6-print.md). There is NO generic print entry
'' point: every scalar type has its own, and the third argument is a SEPARATOR MASK
'' saying what follows THAT item --
''
''     0   nothing        ';' between items, or a trailing ';'
''     1   newline        end of the statement
''     2   tab            ',' between items
''
''     print            -> fb_PrintVoid( 0, 1 )
''     print s          -> fb_PrintString( 0, &S, 1 )
''     print s; n       -> fb_PrintString( 0, &S, 0 )  fb_PrintInt( 0, N, 1 )
''     print s, n       -> fb_PrintString( 0, &S, 2 )  fb_PrintInt( 0, N, 1 )
''     print s;         -> fb_PrintString( 0, &S, 0 )
''
'' so the mask belongs to the item BEFORE the separator, and a trailing ';' suppresses
'' the newline entirely rather than printing one.
function LowerPrint( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )

    '' 'print using' is a different statement shape -- bracketed by Init and End, with
    '' its own flatter set of entry points -- and lives in lowerusing.bas.
    if sp->extra <> 0 then return LowerPrintUsing( c, id )

    '' THE FILE NUMBER. It is not a different statement, it is the first argument that
    '' was being hard-coded to 0 -- 219 corpus statements declined for it. Lowered ONCE
    '' here and reused for every item, which is what fbc does: 'print #h, a, b' puts h
    '' in a temporary and passes that temporary twice, so a channel expression with a
    '' side effect runs once.
    '' The console channel is the IMMEDIATE 0, not an instruction producing 0. fbc
    '' writes 'fb_PrintInt( 0, ... )' and so did tiko-lang before this; materialising a
    '' const would add an instruction to every print in the tree for nothing.
    dim as MirValue chan
    chan.kind = cast( ubyte, MV_CONST_INT )
    chan.ty = cast( ubyte, MT_I32 )
    chan.id = 0
    if sp->a <> Tko.NODE_NONE then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    end if

    '' No items at all is the bare 'print', a newline on its own.
    if sp->count = 0 then
        dim as FB.Array( of ulong ) va
        va.Push( cast( ulong, chan.kind ) ) : va.Push( cast( ulong, chan.id ) )
        PushConst( va, 1 )
        EmitRtl( c, RTL_PRINT_VOID, va )
        return true
    end if

    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Tko.N_PRINT_SEP then continue for

        '' What follows decides the mask: a ';' suppresses, a ',' tabs, and anything
        '' else -- including running out of children -- ends the line.
        dim as long mask = 1
        if i + 1 < sp->count then
            dim as Tko.NodeId nx = cast( Tko.NodeId, c.ast->children[sp->first + i + 1] )
            if c.ast->Kind( nx ) = Tko.N_PRINT_SEP then
                dim as Tko.StmtPayload ptr np = StmtOf( c, nx )
                if np->op = cast( ushort, Tko.TK_COMMA ) then
                    mask = 2
                else
                    mask = 0
                end if
                '' A separator with nothing after it is a TRAILING one, and trailing
                '' means no newline -- which is the 0 already chosen for ';'. A
                '' trailing ',' still tabs, so the mask stands either way.
            end if
        end if

        if PrintOne( c, it, mask, chan ) = false then return false
    next
    return true
end function


'' The print entry point for a type. There is no generic one, and a POINTER has none of
'' its own -- fbc sends it through fb_PrintULongint.
function PrintRtlFor( byref c as Ctx, byval t as Tko.TypeId ) as RtlId
    if t = Tko.TYPE_NONE then return RTL_NONE
    select case c.types->Kind( t )
    case Tko.TK_POINTER, Tko.TK_PROC : return RTL_PRINT_ULONGINT
    case Tko.TK_ENUM                 : return RTL_PRINT_INT
    case Tko.TK_BUILTIN
        select case c.types->BuiltinOf( t )
        case Tko.TY_BYTE      : return RTL_PRINT_BYTE
        case Tko.TY_UBYTE     : return RTL_PRINT_UBYTE
        case Tko.TY_SHORT     : return RTL_PRINT_SHORT
        case Tko.TY_USHORT    : return RTL_PRINT_USHORT
        case Tko.TY_LONG      : return RTL_PRINT_INT
        case Tko.TY_ULONG     : return RTL_PRINT_UINT
        case Tko.TY_LONGINT   : return RTL_PRINT_LONGINT
        case Tko.TY_ULONGINT  : return RTL_PRINT_ULONGINT
        case Tko.TY_SINGLE    : return RTL_PRINT_SINGLE
        case Tko.TY_DOUBLE    : return RTL_PRINT_DOUBLE
        case Tko.TY_BOOLEAN   : return RTL_PRINT_BOOL
        case Tko.TY_INTEGER
            if c.types->target.pointerBits = 32 then return RTL_PRINT_INT
            return RTL_PRINT_LONGINT
        case Tko.TY_UINTEGER
            if c.types->target.pointerBits = 32 then return RTL_PRINT_UINT
            return RTL_PRINT_ULONGINT
        end select
    end select
    return RTL_NONE
end function

'' An i32 constant argument, which every print call needs twice.
sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, v ) )
end sub




'' SWAP a, b -- measured from fbc, and it is TWO different lowerings.
''
'' A STRING pair goes through the runtime, six arguments rather than four: each side is
'' (pointer, length, flag) with the flag 0.
''
''     fb_StrSwap( &S$1, -1ll, 0, &T$1, -1ll, 0 )
''
'' Anything else is a TEMPORARY OF THE OPERAND'S OWN TYPE and three assignments:
''
''     { double TMP;  TMP = D$1;  D$1 = E$1;  E$1 = TMP; }
''
'' Note the temporary is typed to the operand, not to a fixed width: swapping two
'' doubles through an integer slot would round-trip the bits through the wrong register
'' class, and swapping two aggregates would not fit at all.
'' What kind of string a type is, for the SWAP runtime's argument shape. Returns
''   0 = var-length STRING, and 'n' is set to -1
''   1 = ZSTRING * N,       and 'n' is N
''   2 = WSTRING * N,       and 'n' is N
''  -1 = not a string
''
'' A fixed-length string is modelled as an ARRAY of the element builtin, which is what
'' it is, so the count comes off the array rather than out of a byte size.
function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

    if t = Tko.TYPE_NONE then return -1
    if IsStringType( c, t ) then
        n = -1
        return 0
    end if
    '' AN UNSIZED ZSTRING -- what a 'zstring ptr' points at, and what '*pz' is. It has
    '' no declared count, and fbc passes LENGTH 0 for one: 'fb_StrAssign( PC, 0ll, PA,
    '' 0ll, 0 )', 0 meaning "NUL-terminated, work it out". It matched neither the array
    '' test below nor IsStringType above, so every operation through a zstring pointer
    '' declined -- and 'hStringChecks( *pa, *pb, *pc )' is how the corpus exercises the
    '' whole string surface a second time.
    if c.types->Kind( t ) = Tko.TK_BUILTIN then
        if c.types->BuiltinOf( t ) = Tko.TY_ZSTRING then
            n = 0
            return 1
        end if
        '' AND THE WIDE HALF OF THE SAME THING -- what a 'wstring ptr' points at, and
        '' what '*pw' is. Its absence made 'line input #1, *pw, 10' answer "not a
        '' string at all" and decline, while the zstring line beside it lowered.
        if c.types->BuiltinOf( t ) = Tko.TY_WSTRING then
            n = 0
            return 2
        end if
    end if

    if c.types->Kind( t ) <> Tko.TK_ARRAY then return -1
    dim as Tko.TypeId el = c.types->Inner( t )
    if el = Tko.TYPE_NONE then return -1
    if c.types->Kind( el ) <> Tko.TK_BUILTIN then return -1
    n = c.types->ElemCount( t )
    if n <= 0 then return -1
    select case c.types->BuiltinOf( el )
    case Tko.TY_ZSTRING : return 1
    case Tko.TY_WSTRING : return 2
    case Tko.TY_FIXUSTR
        '' 'ustring * N' -- the FIXED-LENGTH UTF-16 flavour, and its tag is N MINUS
        '' ONE where 'string * N' uses N. Measured, both on win64:
        ''
        ''     dim as string  * 8 s   ->  fb_StrInit ( S, &h8000000000000008, ... )
        ''     dim as ustring * 8 u   ->  fb_UStrInit( U, &h8000000000000007, ... )
        ''
        '' so its capacity is N-1 usable characters, exactly as 'zstring * N' is, and
        '' the fixed narrow string is the odd one out. Nothing about the two spellings
        '' says which, and getting it wrong writes one character past the end.
        n = FixedStrLenArg_( c, n - 1 )
        return 4
    case Tko.TY_FIXSTR
        '' 'string * N' -- the FIXED-LENGTH, space-padded flavour. 'n' comes back
        '' ENCODED, because that is the only form any runtime call wants it in, and
        '' encoding it here means every '(pointer, length)' push site emits fbc's
        '' constant without knowing this type exists.
        n = FixedStrLenArg_( c, n )
        return 3
    end select
    return -1
end function

'' THE LENGTH ARGUMENT for a 'string * N', which is not N.
''
'' Measured: fbc passes '&h8000000000000000 or N' on win64 and '&h80000000 or N' on
'' win32 -- POINTER-SIZED, with the SIGN BIT as the tag that says "this operand is N
'' space-padded bytes, not a descriptor and not a NUL-terminated buffer". A plain
'' 'string' passes -1 and a 'zstring * N' passes N unsigned, so all three flavours are
'' told apart by this one argument rather than by separate entry points.
'' Push a string operand's LENGTH argument.
''
'' MV_CONST_INT'S PAYLOAD IS 32 BITS. Every other string length fits -- -1, or a
'' declared count -- but a 'string * N' passes '&h8000000000000000 or N', which
'' truncates to plain N in that field and silently turns the fixed-length tag into an
'' ordinary zstring count. A value that wide needs a CONST INSTRUCTION, which is what
'' ConstInt emits, so it is pushed as a temp rather than inline.
sub PushStrLen_( byref c as Ctx, byref args as FB.Array( of ulong ), byval n as longint )
    if (n >= -2147483648ll) andalso (n <= 2147483647ll) then
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( long, n ) ) )
        return
    end if
    dim as MirValue lv = ConstInt( c, n, MT_I64 )
    args.Push( cast( ulong, lv.kind ) )
    args.Push( cast( ulong, lv.id ) )
end sub

function FixedStrLenArg_( byref c as Ctx, byval n as longint ) as longint
    if c.types->target.pointerBits = 32 then
        return cast( longint, cast( long, (&h80000000ul or cast( ulong, n )) ) )
    end if
    return cast( longint, (&h8000000000000000ull or cast( ulongint, n )) )
end function

'' LEN. Returns false when the node is not one, so the caller carries on.
''
'' Measured from fbc's own C:
''
''     len( s )   fb_StrLen( (void*)&S, -1ll )      a var-length STRING descriptor
''     len( z )   fb_StrLen( (void*)Z, 8ll )        a ZSTRING * 8, its own count
''     len( w )   fb_WstrLen( (uint16*)W )          no length argument at all
''     len( t )   8ll                               anything else FOLDS to its size
''
'' It was lowered NOWHERE -- not even for a narrow string -- so every 'n = len( s )'
'' declined, and inside a DIM initialiser did so silently until the initialiser path
'' started counting.
function LowerLen _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    dim as string lenNm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    '' SIZEOF IS NOT LEN. It is ALWAYS the type's size and never a runtime call:
    '' measured, 'sizeof( s )' over a var-length string is 24 and 'sizeof( z )' over a
    '' 'zstring * 8' is 8, where 'len' of either is fb_StrLen. Sharing this function is
    '' right -- everything after the string branches is identical -- but sharing the
    '' string branches would have made sizeof measure the TEXT.
    ''
    '' It was typed and never lowered at all, so every 'sizeof' declined silently
    '' inside a DIM initialiser -- including 'callocate( sizeof( long ) * 3 )', which
    '' is how the corpus writes an allocation.
    dim as boolean isSizeof = (lenNm = "sizeof")
    if (lenNm <> "len") andalso (isSizeof = false) then return false

    dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[lp->first] )
    dim as Tko.TypeId at = c.info->TypeOf_( a )
    if at = Tko.TYPE_NONE then return false

    '' WIDE: one argument, no length.
    if (IsWideString_( c, at )) andalso (isSizeof = false) then
        dim as MirValue wa = LowerAddr( c, a )
        if wa.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) wargs
        wargs.Push( cast( ulong, wa.kind ) ) : wargs.Push( cast( ulong, wa.id ) )
        outv = EmitRtl( c, RTL_WSTR_LEN, wargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' NARROW: a descriptor passes -1, a fixed ZSTRING its element count.
    dim as longint zn = -1
    dim as boolean narrow = false
    if isSizeof = false then
        narrow = IsStringType( c, at )
        if narrow = false then
            if StrSwapKind_( c, at, zn ) = 1 then narrow = true
        end if
    end if

    '' 'len( a )' OVER A 'string * N' IS THE CONSTANT N -- measured, fbc emits
    '' 'GI$ = 32ll;' with no call at all, because a fixed string's length is its
    '' declared size and never its contents. That is the opposite of 'zstring * N',
    '' whose len IS a runtime strlen. Every 'if len( a ) = 0' over a fixed string is
    '' therefore dead code, in fbc as here.
    if isSizeof = false then
        dim as longint fn2
        if StrSwapKind_( c, at, fn2 ) = 3 then
            outv = ConstInt( c, c.types->ElemCount( at ), MT_I64 )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
    end if
    if narrow then
        '' A LITERAL has no descriptor and folds: fbc knows its length outright.
        if c.ast->Kind( a ) = Tko.N_STRING_LIT then
            outv = ConstInt( c, len( StringLitText_( c, a ) ), MT_I64 )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
        '' NOT NECESSARILY ADDRESSABLE. 'len( a + b )' has no address to take, and fbc
        '' builds the concatenation into a temporary and measures that:
        '' 'fb_StrLen( (void*)fb_StrConcat( &TMP, &A, -1, &B, -1 ), -1ll )'. Anything
        '' else that hands back a descriptor works the same way.
        dim as MirValue sa = LowerAddr( c, a )
        if sa.kind = cast( ubyte, MV_NONE ) then
            if StrDescriptorOf_( c, a, sa ) = false then return false
            zn = -1
        end if
        if sa.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) sargs
        sargs.Push( cast( ulong, sa.kind ) ) : sargs.Push( cast( ulong, sa.id ) )
        sargs.Push( cast( ulong, MV_CONST_INT ) ) : sargs.Push( cast( ulong, zn ) )
        '' fb_UStrLen for a UTF-16 descriptor: it counts CODE UNITS, and fb_StrLen
        '' would read the same 24 bytes as a narrow descriptor.
        outv = EmitRtl( c, StrRtlFor_( c, at, RTL_STR_LEN ), sargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' ANYTHING ELSE folds to the type's SIZE -- 'len( t )' over a UDT and 'len( i )'
    '' over an integer are both compile-time constants to fbc.
    dim as long sz = c.types->Layout( at ).size
    dim as long ui = c.udts->Find( at )
    if ui >= 0 then sz = c.udts->udts[ui].size
    if sz <= 0 then return false
    outv = ConstInt( c, sz, MT_I64 )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' The type of an 'iif' from its ARMS, or TYPE_NONE when the node is not one. Check
'' computes nothing for the call itself.
function IifArmType_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId
    if c.ast->Kind( id ) <> Tko.N_CALL then return Tko.TYPE_NONE
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return Tko.TYPE_NONE
    if lp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return Tko.TYPE_NONE
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then
        return Tko.TYPE_NONE
    end if
    for k as long = 1 to 2
        dim as Tko.TypeId at = _
            c.info->TypeOf_( cast( Tko.NodeId, c.ast->children[lp->first + k] ) )
        if at <> Tko.TYPE_NONE then return at
    next
    return Tko.TYPE_NONE
end function


function IsIifCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref condE as Tko.NodeId, _
      byref thenE as Tko.NodeId, byref elseE as Tko.NodeId ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then return false
    condE = cast( Tko.NodeId, c.ast->children[lp->first] )
    thenE = cast( Tko.NodeId, c.ast->children[lp->first + 1] )
    elseE = cast( Tko.NodeId, c.ast->children[lp->first + 2] )
    return true
end function

'' Whether a node is an 'iif' whose ARMS are strings.
''
'' Decided from an arm's type rather than from the call's, because Check computes no
'' type for an iif call at all. Asked BEFORE anything is lowered: LowerIif emits a
'' whole branch sequence, so a caller that tried it speculatively and then fell
'' through to another path would evaluate both arms twice.
function IsStringIif_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then return false

    for k as long = 1 to 2
        dim as Tko.NodeId arm = cast( Tko.NodeId, c.ast->children[lp->first + k] )
        if c.ast->Kind( arm ) = Tko.N_STRING_LIT then return true
        if IsStringType( c, c.info->TypeOf_( arm ) ) then return true
    next
    return false
end function


'' 'wstr( x )' -- a scalar or a narrow string widened into a fresh wide TEMPORARY.
'' Returns false when the node is not one.
''
'' Measured: byte and short widen to int32 and go through fb_IntToWstr, ubyte and
'' ushort to uint32 and fb_UIntToWstr -- there are NO per-width entries. A narrow
'' string goes through fb_StrToWstr, which takes a RAW char*, so fbc dereferences the
'' descriptor's data field at the call site rather than passing the descriptor.
''
'' The result is a temporary the caller must release with fb_WstrDelete. tiko-lang does not
'' model that lifetime yet, so this LEAKS one wide temporary per conversion -- stated
'' rather than hidden, and no worse than not compiling the program at all.
'' Is this the call 'wstr( x )'? Asked by the concatenation and PRINT paths, which need
'' to know a term is WIDE before anything is emitted for it -- and its TYPE does not
'' say so.
function IsWstrCall_( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    if id = Tko.NODE_NONE then return false
    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    '' ...and the WIDE RADIX FAMILY, which is wide by the same rule and for the same
    '' reason: Check computes no type for the call, so only the NAME says so.
    select case Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    case "wstr", "whex", "woct", "wbin"
        return true
    end select
    return false
end function

function LowerWstrOf _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "wstr" then return false

    dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[lp->first] )

    '' A STRING LITERAL is FOLDED, not converted. Measured: fbc emits L"abc" and no
    '' call at all -- 'wstr( "  ab  " )' becomes '(uint16*)L"  ab  "'. Sending it
    '' through fb_StrToWstr would have needed a descriptor the literal does not have,
    '' which is why this declined: 2,496 corpus statements, all of them
    '' 'dim w as wstring * 50 = trim( wstr( "..." ) )' and its relatives.
    if c.ast->Kind( a ) = Tko.N_STRING_LIT then
        dim as string wlit = StringLitText_( c, a )
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = c.m->AddWideStringLiteral( wlit, *c.names )
        return true
    end if

    '' THE ARGUMENT MAY BE A WIDE CONCATENATION, which has no type of its own -- so
    '' asking for one and giving up is how 'wstr(  & wstr( w ) &  )' declined:
    '' the inner conversions lowered and the wstr around them did not.
    if ConcatHasWideTerm_( c, a ) then
        if WideOperand_( c, a, outv ) then return true
    end if

    dim as Tko.TypeId at = c.info->TypeOf_( a )
    if at = Tko.TYPE_NONE then return false

    '' AN ALREADY-WIDE ARGUMENT IS THE IDENTITY, and fbc emits no call at all:
    '' 'print wstr( cmp )' over a 'wstring * 20' is 'fb_PrintWstr( 0, (uint16*)CMP, 1 )'.
    '' Falling through instead made the whole expression decline.
    if IsWideString_( c, at ) then
        outv = LowerAddr( c, a )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' A NARROW STRING: the raw data pointer, not the descriptor.
    dim as longint zn
    dim as long sk = StrSwapKind_( c, at, zn )
    if sk = 0 then
        dim as MirValue d = LowerAddr( c, a )
        if d.kind = cast( ubyte, MV_NONE ) then return false
        '' Field 0 of the descriptor is its data pointer.
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = d
        fa.imm = 0
        dim as MirValue pa = Emit( c, fa )
        if pa.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue raw = LowerExprLoad( c, pa, MT_PTR )
        if raw.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) sargs
        sargs.Push( cast( ulong, raw.kind ) ) : sargs.Push( cast( ulong, raw.id ) )
        outv = EmitRtl( c, RTL_STR_TO_WSTR, sargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    elseif sk = 1 then
        '' A ZSTRING * N IS already a char array: its address is the char*.
        dim as MirValue za = LowerAddr( c, a )
        if za.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) zargs
        zargs.Push( cast( ulong, za.kind ) ) : zargs.Push( cast( ulong, za.id ) )
        outv = EmitRtl( c, RTL_STR_TO_WSTR, zargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' A UDT WITH 'operator cast'. 'wstr( u )' over one whose cast yields a WSTRING is
    '' the identity, and over one that yields a narrow string it is the ordinary
    '' conversion -- WideOperand_ knows the first and NarrowToWideTemp_ the second.
    if c.types->Kind( at ) = Tko.TK_UDT then
        if WideOperand_( c, a, outv ) then return true
        return NarrowToWideTemp_( c, a, outv )
    end if

    '' A SCALAR. Which entry point, and what the argument widens to, both come from the
    '' operand's own type.
    if c.types->Kind( at ) <> Tko.TK_BUILTIN then return false
    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    select case c.types->BuiltinOf( at )
    case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG, Tko.TY_BOOLEAN
        r = RTL_INT_TO_WSTR
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG
        r = RTL_UINT_TO_WSTR
    case Tko.TY_INTEGER, Tko.TY_LONGINT
        r = RTL_LONGINT_TO_WSTR : want = MT_I64
    case Tko.TY_UINTEGER, Tko.TY_ULONGINT
        r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    case Tko.TY_SINGLE
        r = RTL_FLOAT_TO_WSTR : want = MT_F32
    case Tko.TY_DOUBLE
        r = RTL_DOUBLE_TO_WSTR : want = MT_F64
    case else
        return false
    end select

    dim as MirValue av = LowerExpr( c, a )
    if av.kind = cast( ubyte, MV_NONE ) then return false
    av = Coerce( c, av, want, IsUnsignedType( c, at ) )
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' One store, which SWAP needs three of.
sub StoreThrough _
    ( byref c as Ctx, byref addr as MirValue, byref val as MirValue )
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub

'' A string assignment whose destination is a SLOT rather than an expression: the
'' result descriptor of a string-returning function, which no source node names.
function LowerStringAssignToSlot _
    ( byref c as Ctx, byval slot as long, byval value as Tko.NodeId ) as boolean
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    return LowerStringAssignTo( c, dst, Tko.NODE_NONE, value )
end function

function LowerStringAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if IsStringType( c, c.info->TypeOf_( target ) ) = false then return false
    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerStringAssignTo( c, dst, target, value )
end function

'' The body of both: 'target' is only needed to spot a self-reference in the chain and
'' may be NODE_NONE when the destination is a slot with no node of its own.
function LowerStringAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval target as Tko.NodeId, _
      byval value as Tko.NodeId ) as boolean

    '' A '+' chain is flattened and emitted as ONE assign followed by concat-assigns,
    '' which is exactly what fbc does: 'a = b + c' is fb_StrAssign(a,b) then
    '' fb_StrConcatAssign(a,c), with no temporary at all.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )

    '' If the destination is read AFTER it would be written, the chain cannot be built
    '' in place: 'a = b + a' would overwrite a before reading it. fbc builds such a
    '' chain in a temporary and assigns from that.
    dim as boolean needsTemp = false
    if target <> Tko.NODE_NONE then
        for i as long = 1 to terms.Count - 1
            if SameLValue( c, target, cast( Tko.NodeId, terms[i] ) ) then needsTemp = true
        next
    end if
    if needsTemp then return LowerConcatViaTemp( c, dst, terms )

    '' THE FLAVOUR COMES FROM THE DESTINATION, and the SOURCE literals follow it: a
    '' ustring takes fb_UStrAssign and a UTF-16 literal with a tagged length.
    dim as boolean isU = IsUStringType( c, c.info->TypeOf_( target ) )

    '' The first term is assigned, every later one concatenated onto it. When the
    '' destination IS the first term, the assign is a self-assignment and is skipped.
    for i as long = 0 to terms.Count - 1
        dim as Tko.NodeId term = cast( Tko.NodeId, terms[i] )
        if i = 0 then
            if target <> Tko.NODE_NONE then
                if SameLValue( c, target, term ) then continue for
            end if
        end if
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, term, isU ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        if i = 0 then
            EmitRtl( c, iif( isU, RTL_USTR_ASSIGN, RTL_STR_ASSIGN ), args )
        else
            EmitRtl( c, iif( isU, RTL_USTR_CONCAT_ASSIGN, RTL_STR_CONCAT_ASSIGN ), args )
        end if
    next
    return true
end function

'' A byref ZSTRING parameter takes the DATA POINTER, not a descriptor and not the
'' address of one. Measured, all three spellings:
''
''     P2( (char*)"lit" )     a literal: the bytes themselves
''     P2( (char*)ZS )        a 'zstring * N': its own address
''     P2( *(char**)&S )      a STRING: the pointer LOADED out of the descriptor
''
'' The wide half of this is WideOperand_, which already existed for the same reason.
function ZstrDataOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if id = Tko.NODE_NONE then return false
    if c.ast->Kind( id ) = Tko.N_STRING_LIT then
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = c.m->AddStringLiteral( StringLitText_( c, id ), *c.names )
        return true
    end if

    dim as longint n
    dim as long k = StrSwapKind_( c, c.info->TypeOf_( id ), n )
    if k = 1 then
        outv = LowerAddr( c, id )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if k = 0 then
        '' StrDescriptorOf_ RATHER THAN LowerAddr, so an rvalue works too: 'str( t )'
        '' has no address, and fbc copies it into a temporary descriptor before taking
        '' the pointer. Everything with an address comes back as its own address here,
        '' so the variable case is unchanged.
        dim as MirValue da
        if StrDescriptorOf_( c, id, da ) = false then da = LowerAddr( c, id )
        if da.kind = cast( ubyte, MV_NONE ) then return false
        '' The data pointer is the descriptor's FIRST field, which is why this is a
        '' plain load and not a field address.
        outv = LowerExprLoad( c, da, MT_PTR )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    return false
end function


'' 'a &= b' AND 'a += b' OVER A STRING, which is the same statement: measured, fbc
'' emits 'fb_StrConcatAssign( &S, -1ll, src, len, 0 )' for both spellings.
''
'' The operator was recorded on the statement and then thrown away for '&=': the
'' dispatch treated it as PLAIN, so 's &= "b"' lowered to fb_StrAssign -- an
'' assignment, not an append. It verified, it emitted code, it counted as fully
'' lowered, and it was wrong every time. '+=' declined instead, because the compound
'' path works in the target's MIR type and a string is an aggregate.
''
'' Only the shapes fbc reaches with ONE call are lowered. A fixed 'zstring * N' or
'' 'string * N' destination builds a temporary first -- 'fb_StrConcat( &TMP, Z, 10,
'' "f", 2 )' then 'fb_StrAssign( Z, 10, vr, -1, 0 )' -- and a narrow source appended
'' to a WIDE destination needs a temporary's lifetime as well. Those decline, which
'' is the honest answer where half of the model would be a wrong one.
function LowerConcatAssignStmt _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind ) as boolean

    if (op <> Tko.TK_AMPEQ) andalso (op <> Tko.TK_PLUSEQ) then return false
    dim as Tko.TypeId tt = c.info->TypeOf_( target )
    if tt = Tko.TYPE_NONE then return false

    if IsStringType( c, tt ) then
        dim as MirValue dst = LowerAddr( c, target )
        if dst.kind = cast( ubyte, MV_NONE ) then return false
        dim as boolean isU = IsUStringType( c, tt )
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, value, isU ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        EmitRtl( c, iif( isU, RTL_USTR_CONCAT_ASSIGN, RTL_STR_CONCAT_ASSIGN ), args )
        return true
    end if

    '' A FIXED WIDE STRING with a wide source: 'fb_WstrConcatAssign( W, 50ll, W2 )'.
    if IsWideString_( c, tt ) then
        return LowerWideConcatAssign( c, target, WideStringElems( c, tt ), value )
    end if
    return false
end function

'' Flatten a left-leaning '+' chain into its terms, in source order.
sub FlattenConcat _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outp as FB.Array( of ulong ) )

    if id = Tko.NODE_NONE then return
    if c.ast->Kind( id ) = Tko.N_BINARY then
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' '&' AND '+' ARE THE SAME OPERATION on strings -- measured: fbc emits
        '' fb_StrAssign followed by fb_StrConcatAssign for both, instruction for
        '' instruction. Only '+' was flattened, so 'b = a & p' declined outright while
        '' 'b = a + p' beside it lowered. ('and' is FreeBASIC's bitwise operator, so
        '' '&' is never ambiguous here.)
        dim as Tko.TokenKind bop = cast( Tko.TokenKind, bp->op )
        if (bop = Tko.TK_PLUS) orelse (bop = Tko.TK_AMP) then
            FlattenConcat( c, bp->lhs, outp )
            FlattenConcat( c, bp->rhs, outp )
            return
        end if
    end if
    outp.Push( cast( ulong, id ) )
end sub

'' Whether two expressions name the same storage. Only the simple cases are needed:
'' anything else falls back to the general path rather than guessing.
function SameLValue _
    ( byref c as Ctx, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Tko.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function


end namespace

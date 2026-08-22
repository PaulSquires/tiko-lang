'' lowerstr.bas -- string lowering and the runtime call helper.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The division
'' is by subject rather than by size: everything here is about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Defined below; the wide-string helpers above it classify a narrow operand.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

'' Local to this file: the two halves of concatenation lowering call each other.
declare sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
declare sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
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
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[0] ) ) = false then return false
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[1] ) ) = false then return false
    dim as MirValue acc = EmitRtl( c, RTL_STR_CONCAT, args )

    '' Any further terms concatenate onto the temporary in place.
    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Fbx.NodeId, terms[i] ) ) = false then return false
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

'' Up to 'maxDigits' digits in 'radix', greedy, value clamped to a byte. Shared by
'' the hex escape and the three '&' forms, which differ only in radix and digit count.
private function ReadRadix_ _
    ( byref f as Fbx.SourceFile, byval base_ as long, byval limit as long, _
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
    ( byref f as Fbx.SourceFile, byval base_ as long, byval limit as long, _
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
function StringLitText_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as string

    if c.ast->Kind( id ) <> Fbx.N_STRING_LIT then return ""
    dim as Fbx.LiteralPayload ptr lp = _
        @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->strLength <= 0 then return ""
    '' The literal's OWN file, not the node's loc: a literal built by macro expansion is
    '' repointed at the use site for diagnostics, and its text does not live there.
    dim as Fbx.SourceFile ptr f = c.srcMgr->FileAt( cast( Fbx.FileId, lp->strFile ) )
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
    '' ZSTRING for a literal holding only byte escapes -- and fbx does not model a wide
    '' literal. Decoding the byte escapes around it and dropping the wide ones would
    '' produce a literal that is neither compiler's answer. 2120 occurrences in the
    '' corpus, and they stay an OPEN GAP rather than a wrong one.
    dim as boolean decode = (lp->strKind = cast( ubyte, Fbx.STRK_ESCAPED ))
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

'' ------------------------------------------------------------------ runtime

'' A call to a runtime function, by table id. Nothing here spells a runtime name: the
'' inventory is the only place that does (docs/plan/11 section 3).
function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue

    dim as MirValue v
    '' The LINKER-VISIBLE name, which on win32 carries the underscore and the stdcall
    '' '@N'. A 32-bit pointer means win32: Linux is 64-bit only by decision.
    dim as boolean is32 = (c.types->target.pointerBits = 32)
    dim as Fbx.InternId nm = c.names->GetString( RtlLinkName( r, is32 ) )
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
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    dim as MirValue v
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return v
    if (s->flags and Fbx.SYMF_BUILTIN) <> 0 then
        return ConstInt( c, cast( longint, s->payload ), MT_I8 )
    end if
    if (s->flags and Fbx.SYMF_FUNCNAME) <> 0 then
        return LowerTextAddr( c, Fbx.Mangle.ProcNameOrMain( _
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
    if s->kind = cast( ubyte, Fbx.SYM_ENUMCONST ) then
        dim as MirType emt = LowerType( c.info->TypeOf_( id ), *c.types )
        '' An enum is a 32-bit integer to fbc, and that is what an unrecognised type
        '' falls back to here rather than the i64 a plain constant would take.
        if (emt = MT_VOID) orelse (emt = MT_AGG) then emt = MT_I32
        return ConstInt( c, cast( longint, s->payload ), emt )
    end if

    if s->kind = cast( ubyte, Fbx.SYM_CONSTANT ) then
        if s->payload = 0 then return v
        dim as Fbx.NodeId item = cast( Fbx.NodeId, s->payload )
        if c.ast->Kind( item ) <> Fbx.N_VAR_ITEM then return v
        dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
        dim as Fbx.Check.ConstVal cv = _
            Fbx.Check.ConstOf( *c.ast, ip->b, *c.srcMgr, *c.names, _
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
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
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
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    dim as Fbx.BuiltinType b = c.types->BuiltinOf( t )
    return (b = Fbx.TY_STRING) orelse (b = Fbx.TY_USTRING)
end function

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
    ( byref c as Ctx, byval slot as long, byval target as Fbx.NodeId, _
      byval value as Fbx.NodeId ) as boolean

    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    if value = Fbx.NODE_NONE then
        ZeroStrDescriptor( c, dst )
        return true
    end if

    '' A concatenation cannot go through fb_StrInit, which takes one source. Zero the
    '' descriptor so it is a valid empty string, then build into it the ordinary way.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )
    if terms.Count <> 1 then
        ZeroStrDescriptor( c, dst )
        if target = Fbx.NODE_NONE then return true
        return LowerStringAssign( c, target, value )
    end if

    dim as FB.Array( of ulong ) args
    PushStrArg( args, dst )
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[0] ) ) = false then
        '' The source did not lower, so the descriptor must still be made valid --
        '' its fb_StrDelete is registered either way.
        ZeroStrDescriptor( c, dst )
        return false
    end if
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( 0 )
    EmitRtl( c, RTL_STR_INIT, args )
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
function LowerPrint( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    '' 'print using' is a different statement shape -- bracketed by Init and End, with
    '' its own flatter set of entry points -- and lives in lowerusing.bas.
    if sp->extra <> 0 then return LowerPrintUsing( c, id )

    '' THE FILE NUMBER. It is not a different statement, it is the first argument that
    '' was being hard-coded to 0 -- 219 corpus statements declined for it. Lowered ONCE
    '' here and reused for every item, which is what fbc does: 'print #h, a, b' puts h
    '' in a temporary and passes that temporary twice, so a channel expression with a
    '' side effect runs once.
    '' The console channel is the IMMEDIATE 0, not an instruction producing 0. fbc
    '' writes 'fb_PrintInt( 0, ... )' and so did fbx before this; materialising a
    '' const would add an instruction to every print in the tree for nothing.
    dim as MirValue chan
    chan.kind = cast( ubyte, MV_CONST_INT )
    chan.ty = cast( ubyte, MT_I32 )
    chan.id = 0
    if sp->a <> Fbx.NODE_NONE then
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
        dim as Fbx.NodeId it = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Fbx.N_PRINT_SEP then continue for

        '' What follows decides the mask: a ';' suppresses, a ',' tabs, and anything
        '' else -- including running out of children -- ends the line.
        dim as long mask = 1
        if i + 1 < sp->count then
            dim as Fbx.NodeId nx = cast( Fbx.NodeId, c.ast->children[sp->first + i + 1] )
            if c.ast->Kind( nx ) = Fbx.N_PRINT_SEP then
                dim as Fbx.StmtPayload ptr np = StmtOf( c, nx )
                if np->op = cast( ushort, Fbx.TK_COMMA ) then
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
function PrintRtlFor( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
    if t = Fbx.TYPE_NONE then return RTL_NONE
    select case c.types->Kind( t )
    case Fbx.TK_POINTER, Fbx.TK_PROC : return RTL_PRINT_ULONGINT
    case Fbx.TK_ENUM                 : return RTL_PRINT_INT
    case Fbx.TK_BUILTIN
        select case c.types->BuiltinOf( t )
        case Fbx.TY_BYTE      : return RTL_PRINT_BYTE
        case Fbx.TY_UBYTE     : return RTL_PRINT_UBYTE
        case Fbx.TY_SHORT     : return RTL_PRINT_SHORT
        case Fbx.TY_USHORT    : return RTL_PRINT_USHORT
        case Fbx.TY_LONG      : return RTL_PRINT_INT
        case Fbx.TY_ULONG     : return RTL_PRINT_UINT
        case Fbx.TY_LONGINT   : return RTL_PRINT_LONGINT
        case Fbx.TY_ULONGINT  : return RTL_PRINT_ULONGINT
        case Fbx.TY_SINGLE    : return RTL_PRINT_SINGLE
        case Fbx.TY_DOUBLE    : return RTL_PRINT_DOUBLE
        case Fbx.TY_BOOLEAN   : return RTL_PRINT_BOOL
        case Fbx.TY_INTEGER
            if c.types->target.pointerBits = 32 then return RTL_PRINT_INT
            return RTL_PRINT_LONGINT
        case Fbx.TY_UINTEGER
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
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

    if t = Fbx.TYPE_NONE then return -1
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
    if c.types->Kind( t ) = Fbx.TK_BUILTIN then
        if c.types->BuiltinOf( t ) = Fbx.TY_ZSTRING then
            n = 0
            return 1
        end if
    end if

    if c.types->Kind( t ) <> Fbx.TK_ARRAY then return -1
    dim as Fbx.TypeId el = c.types->Inner( t )
    if el = Fbx.TYPE_NONE then return -1
    if c.types->Kind( el ) <> Fbx.TK_BUILTIN then return -1
    n = c.types->ElemCount( t )
    if n <= 0 then return -1
    select case c.types->BuiltinOf( el )
    case Fbx.TY_ZSTRING : return 1
    case Fbx.TY_WSTRING : return 2
    case Fbx.TY_FIXSTR
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

'' LINE INPUT #n, dst -- read a whole line from a file into a string.
''
'' Measured from fbc's C:
''
''     fb_FileLineInput( 1, (void*)&S$0, -1ll, 0 );      dst is a STRING
''     fb_FileLineInput( 1, (void*)Z$0,   8ll, 0 );      dst is a ZSTRING * 8
''
'' Same (pointer, length) convention as the swap runtime: -1 for a var-length string
'' and the element count for a fixed one. The fourth argument is 0 in every form fbc
'' emits here.
''
'' The CONSOLE form -- 'line input s', with or without a prompt -- is a different entry
'' point (fb_LineInput, six arguments including a prompt descriptor) and still declines.
function LowerLineInput( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->a = Fbx.NODE_NONE then return false      '' console form
    if sp->c <> Fbx.NODE_NONE then return false     '' a prompt: console form only
    if sp->count <> 1 then return false

    dim as Fbx.NodeId dst = cast( Fbx.NodeId, c.ast->children[sp->first] )
    dim as longint dlen
    if StrSwapKind_( c, c.info->TypeOf_( dst ), dlen ) < 0 then return false

    dim as MirValue fn = LowerExpr( c, sp->a )
    if fn.kind = cast( ubyte, MV_NONE ) then return false
    fn = Coerce( c, fn, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    dim as MirValue da = LowerAddr( c, dst )
    if da.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, fn.kind ) ) : args.Push( cast( ulong, fn.id ) )
    args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dlen ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_FILE_LINEINPUT, args )
    return true
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
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    dim as string lenNm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )
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

    dim as Fbx.NodeId a = cast( Fbx.NodeId, c.ast->children[lp->first] )
    dim as Fbx.TypeId at = c.info->TypeOf_( a )
    if at = Fbx.TYPE_NONE then return false

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
        if c.ast->Kind( a ) = Fbx.N_STRING_LIT then
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
        outv = EmitRtl( c, RTL_STR_LEN, sargs )
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
function IifArmType_( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId
    if c.ast->Kind( id ) <> Fbx.N_CALL then return Fbx.TYPE_NONE
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return Fbx.TYPE_NONE
    if lp->target = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return Fbx.TYPE_NONE
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then
        return Fbx.TYPE_NONE
    end if
    for k as long = 1 to 2
        dim as Fbx.TypeId at = _
            c.info->TypeOf_( cast( Fbx.NodeId, c.ast->children[lp->first + k] ) )
        if at <> Fbx.TYPE_NONE then return at
    next
    return Fbx.TYPE_NONE
end function


function IsIifCall_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref condE as Fbx.NodeId, _
      byref thenE as Fbx.NodeId, byref elseE as Fbx.NodeId ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return false
    if lp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then return false
    condE = cast( Fbx.NodeId, c.ast->children[lp->first] )
    thenE = cast( Fbx.NodeId, c.ast->children[lp->first + 1] )
    elseE = cast( Fbx.NodeId, c.ast->children[lp->first + 2] )
    return true
end function

'' Whether a node is an 'iif' whose ARMS are strings.
''
'' Decided from an arm's type rather than from the call's, because Check computes no
'' type for an iif call at all. Asked BEFORE anything is lowered: LowerIif emits a
'' whole branch sequence, so a caller that tried it speculatively and then fell
'' through to another path would evaluate both arms twice.
function IsStringIif_( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return false
    if lp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then return false

    for k as long = 1 to 2
        dim as Fbx.NodeId arm = cast( Fbx.NodeId, c.ast->children[lp->first + k] )
        if c.ast->Kind( arm ) = Fbx.N_STRING_LIT then return true
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
'' The result is a temporary the caller must release with fb_WstrDelete. fbx does not
'' model that lifetime yet, so this LEAKS one wide temporary per conversion -- stated
'' rather than hidden, and no worse than not compiling the program at all.
function LowerWstrOf _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "wstr" then return false

    dim as Fbx.NodeId a = cast( Fbx.NodeId, c.ast->children[lp->first] )

    '' A STRING LITERAL is FOLDED, not converted. Measured: fbc emits L"abc" and no
    '' call at all -- 'wstr( "  ab  " )' becomes '(uint16*)L"  ab  "'. Sending it
    '' through fb_StrToWstr would have needed a descriptor the literal does not have,
    '' which is why this declined: 2,496 corpus statements, all of them
    '' 'dim w as wstring * 50 = trim( wstr( "..." ) )' and its relatives.
    if c.ast->Kind( a ) = Fbx.N_STRING_LIT then
        dim as string wlit = StringLitText_( c, a )
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = c.m->AddWideStringLiteral( wlit, *c.names )
        return true
    end if

    dim as Fbx.TypeId at = c.info->TypeOf_( a )
    if at = Fbx.TYPE_NONE then return false

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

    '' A SCALAR. Which entry point, and what the argument widens to, both come from the
    '' operand's own type.
    if c.types->Kind( at ) <> Fbx.TK_BUILTIN then return false
    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    select case c.types->BuiltinOf( at )
    case Fbx.TY_BYTE, Fbx.TY_SHORT, Fbx.TY_LONG, Fbx.TY_BOOLEAN
        r = RTL_INT_TO_WSTR
    case Fbx.TY_UBYTE, Fbx.TY_USHORT, Fbx.TY_ULONG
        r = RTL_UINT_TO_WSTR
    case Fbx.TY_INTEGER, Fbx.TY_LONGINT
        r = RTL_LONGINT_TO_WSTR : want = MT_I64
    case Fbx.TY_UINTEGER, Fbx.TY_ULONGINT
        r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    case Fbx.TY_SINGLE
        r = RTL_FLOAT_TO_WSTR : want = MT_F32
    case Fbx.TY_DOUBLE
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

'' The runtime entry point for reading ONE destination of a given type.
private function InputRtlFor _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as RtlId

    n = -1
    if t = Fbx.TYPE_NONE then return RTL_NONE
    if IsWideString_( c, t ) then
        n = WideStringElems( c, t )
        return RTL_INPUT_WSTR
    end if
    dim as longint zn
    dim as long sk = StrSwapKind_( c, t, zn )
    if sk = 0 then return RTL_INPUT_STRING
    if sk = 1 then
        n = zn
        return RTL_INPUT_STRING
    end if
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return RTL_NONE
    select case c.types->BuiltinOf( t )
    case Fbx.TY_BYTE      : return RTL_INPUT_BYTE
    case Fbx.TY_UBYTE, Fbx.TY_BOOLEAN : return RTL_INPUT_UBYTE
    case Fbx.TY_SHORT     : return RTL_INPUT_SHORT
    case Fbx.TY_USHORT    : return RTL_INPUT_USHORT
    case Fbx.TY_LONG      : return RTL_INPUT_INT
    case Fbx.TY_ULONG     : return RTL_INPUT_UINT
    case Fbx.TY_INTEGER, Fbx.TY_LONGINT   : return RTL_INPUT_LONGINT
    case Fbx.TY_UINTEGER, Fbx.TY_ULONGINT : return RTL_INPUT_ULONGINT
    case Fbx.TY_SINGLE    : return RTL_INPUT_SINGLE
    case Fbx.TY_DOUBLE    : return RTL_INPUT_DOUBLE
    end select
    return RTL_NONE
end function

'' A PROMPT DESCRIPTOR. fbc always passes one, borrowed from the runtime, and an
'' ABSENT prompt is the empty string rather than a null pointer.
private function InputPrompt( byref c as Ctx, byval promptE as Fbx.NodeId ) as MirValue
    '' NOT named 'text': inside namespace Fbx.Mir that resolves to the Fbx.Text
    '' NAMESPACE, and the error it produces names a period rather than the collision.
    dim as string ptext = ""
    if promptE <> Fbx.NODE_NONE then
        if c.ast->Kind( promptE ) = Fbx.N_STRING_LIT then
            ptext = StringLitText_( c, promptE )
        end if
    end if
    dim as FB.Array( of ulong ) ta
    ta.Push( cast( ulong, MV_GLOBAL ) )
    ta.Push( cast( ulong, c.m->AddStringLiteral( ptext, *c.names ) ) )
    ta.Push( cast( ulong, MV_CONST_INT ) )
    ta.Push( cast( ulong, len( ptext ) ) )
    return EmitRtl( c, RTL_STR_TEMPZ, ta )
end function

'' INPUT and LINE INPUT.
''
'' Measured from fbc. INPUT is a START call and then one call per destination, each
'' passed BY ADDRESS:
''
''     fb_ConsoleInput( promptDesc, -1, -1 );  fb_InputInt( addr )
''     fb_FileInput( 1 );                      fb_InputInt( addr )
''
'' The two flags are addQuestionMark and echoNewline, -1 for true. A LEADING semicolon
'' clears the second.
''
'' LINE INPUT is a different shape entirely -- ONE call with the destination inside it:
''
''     fb_LineInput( promptDesc, dst, -1ll, 0, addQuestion, echoNewline )
''     fb_FileLineInput( 1, dst, -1ll, 0 )
function LowerInput _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval isLine as boolean ) as boolean

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    '' A LEADING semicolon suppresses the echoed newline. The parser marks it with
    '' bit 4, because bit 1 already meant LINE INPUT.
    dim as long echoNewline = -1
    if (sp->extra and 4) <> 0 then echoNewline = 0
    '' A comma after the prompt suppresses the question mark and a semicolon keeps it.
    '' The parser does not record which, so it is kept -- fbc's default and the
    '' commoner spelling.
    dim as long addQuestion = -1

    dim as boolean toFile = (sp->a <> Fbx.NODE_NONE)
    dim as MirValue chan
    if toFile then
        dim as MirValue ch = LowerExpr( c, sp->a )
        if ch.kind = cast( ubyte, MV_NONE ) then return false
        chan = Coerce( c, ch, MT_I32, IsUnsignedType( c, c.info->TypeOf_( sp->a ) ) )
    end if

    if isLine then
        if sp->count <> 1 then return false
        dim as Fbx.NodeId dst = cast( Fbx.NodeId, c.ast->children[sp->first] )
        dim as longint dn
        if InputRtlFor( c, c.info->TypeOf_( dst ), dn ) = RTL_NONE then return false
        dim as MirValue da = LowerAddr( c, dst )
        if da.kind = cast( ubyte, MV_NONE ) then return false

        dim as FB.Array( of ulong ) args
        if toFile then
            args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )
            args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
            EmitRtl( c, RTL_FILE_LINEINPUT, args )
            return true
        end if
        dim as MirValue pr = InputPrompt( c, sp->c )
        if pr.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, pr.kind ) ) : args.Push( cast( ulong, pr.id ) )
        args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, addQuestion ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, echoNewline ) )
        EmitRtl( c, RTL_LINEINPUT, args )
        return true
    end if

    if sp->count = 0 then return false

    '' EVERY DESTINATION IS CHECKED FIRST. Emitting the start call and then declining
    '' on the third variable would leave the program prompting for input it never
    '' reads.
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId d = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        dim as longint dn2
        if InputRtlFor( c, c.info->TypeOf_( d ), dn2 ) = RTL_NONE then return false
    next

    dim as FB.Array( of ulong ) sargs
    if toFile then
        sargs.Push( cast( ulong, chan.kind ) ) : sargs.Push( cast( ulong, chan.id ) )
        EmitRtl( c, RTL_FILE_INPUT, sargs )
    else
        dim as MirValue pr2 = InputPrompt( c, sp->c )
        if pr2.kind = cast( ubyte, MV_NONE ) then return false
        sargs.Push( cast( ulong, pr2.kind ) ) : sargs.Push( cast( ulong, pr2.id ) )
        sargs.Push( cast( ulong, MV_CONST_INT ) ) : sargs.Push( cast( ulong, addQuestion ) )
        sargs.Push( cast( ulong, MV_CONST_INT ) ) : sargs.Push( cast( ulong, echoNewline ) )
        EmitRtl( c, RTL_CONSOLE_INPUT, sargs )
    end if

    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId d = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        dim as longint dn3
        dim as RtlId r = InputRtlFor( c, c.info->TypeOf_( d ), dn3 )
        dim as MirValue da2 = LowerAddr( c, d )
        if da2.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) dargs
        dargs.Push( cast( ulong, da2.kind ) ) : dargs.Push( cast( ulong, da2.id ) )
        if r = RTL_INPUT_STRING then
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( cast( ulong, dn3 ) )
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( 0 )
        elseif r = RTL_INPUT_WSTR then
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( cast( ulong, dn3 ) )
        end if
        EmitRtl( c, r, dargs )
    next
    return true
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
    ( byref c as Ctx, byval slot as long, byval value as Fbx.NodeId ) as boolean
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    return LowerStringAssignTo( c, dst, Fbx.NODE_NONE, value )
end function

function LowerStringAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    if IsStringType( c, c.info->TypeOf_( target ) ) = false then return false
    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerStringAssignTo( c, dst, target, value )
end function

'' The body of both: 'target' is only needed to spot a self-reference in the chain and
'' may be NODE_NONE when the destination is a slot with no node of its own.
function LowerStringAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval target as Fbx.NodeId, _
      byval value as Fbx.NodeId ) as boolean

    '' A '+' chain is flattened and emitted as ONE assign followed by concat-assigns,
    '' which is exactly what fbc does: 'a = b + c' is fb_StrAssign(a,b) then
    '' fb_StrConcatAssign(a,c), with no temporary at all.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )

    '' If the destination is read AFTER it would be written, the chain cannot be built
    '' in place: 'a = b + a' would overwrite a before reading it. fbc builds such a
    '' chain in a temporary and assigns from that.
    dim as boolean needsTemp = false
    if target <> Fbx.NODE_NONE then
        for i as long = 1 to terms.Count - 1
            if SameLValue( c, target, cast( Fbx.NodeId, terms[i] ) ) then needsTemp = true
        next
    end if
    if needsTemp then return LowerConcatViaTemp( c, dst, terms )

    '' The first term is assigned, every later one concatenated onto it. When the
    '' destination IS the first term, the assign is a self-assignment and is skipped.
    for i as long = 0 to terms.Count - 1
        dim as Fbx.NodeId term = cast( Fbx.NodeId, terms[i] )
        if i = 0 then
            if target <> Fbx.NODE_NONE then
                if SameLValue( c, target, term ) then continue for
            end if
        end if
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, term ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        if i = 0 then
            EmitRtl( c, RTL_STR_ASSIGN, args )
        else
            EmitRtl( c, RTL_STR_CONCAT_ASSIGN, args )
        end if
    next
    return true
end function

'' The (pointer, length) pair for one term of a concatenation.
function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Fbx.NodeId ) as boolean

    if c.ast->Kind( term ) = Fbx.N_STRING_LIT then
        '' Named litText, not text: 'Text' is a namespace and FreeBASIC is
        '' case-insensitive, so a local called text shadows it.
        dim as string litText = StringLitText_( c, term )
        PushStrLiteralArg( args, c.m->AddStringLiteral( litText, *c.names ), _
                           len( litText ) )
        return true
    end if
    '' A STRING 'iif' produces a temporary DESCRIPTOR, whose address is exactly what
    '' this needs. Tried before the type test because Check computes no type for an
    '' iif call, so a type-first test would never reach it.
    '' THE DESTINATION IS ALREADY KNOWN TO BE A STRING, so an iif here is a string
    '' iif whatever its arms look like. Asking IsStringIif_ instead meant every
    '' 'iif( c, hex( 1 ), hex( 2 ) )' declined: Check computes no type for an
    '' intrinsic call, so neither arm looked like a string and the whole statement
    '' produced nothing.
    dim as Fbx.NodeId iC, iT, iE
    if IsIifCall_( c, term, iC, iT, iE ) then
        dim as MirValue iv
        if LowerStringIif_( c, iC, iT, iE, iv ) = false then return false
        if iv.kind = cast( ubyte, MV_NONE ) then return false
        PushStrArg( args, iv )
        return true
    end if

    '' 'trim( s )', 'left( s, n )' and the rest hand back a descriptor pointer, which
    '' is exactly what a term is. Tried before the type test: Check computes no type
    '' for these calls either.
    dim as MirValue rvv
    if LowerStrRvalue( c, term, rvv ) then
        PushStrArg( args, rvv )
        return true
    end if

    '' A FIXED-LENGTH STRING IS A CHAR ARRAY WITH NO DESCRIPTOR, so it passes its
    '' ADDRESS and its DECLARED LENGTH where a var-length string passes -1 and lets the
    '' descriptor say. Measured -- 'dim as string c : dim as zstring * 8 fa : c = fa':
    ''
    ''     fb_StrAssign( (void*)&C$1, -1ll, (void*)FA$1, 8ll, 0 );
    ''
    '' PushStrArg's -1 would have made the runtime read a length out of the first bytes
    '' of the text. The reverse direction -- a fixed destination -- was already handled;
    '' this is the same fact on the other side, and it declined outright: 'c = fa' is
    '' one of the commonest shapes in the corpus and produced nothing at all.
    '' A CONCATENATION, before the type test below claims it. Reached from the string
    '' COMPARISON path -- 'if a + b = c' -- where the operands are not flattened; the
    '' assignment path flattens first, so a term is never a concat there.
    dim as MirValue tcc
    if ConcatToTemp_( c, term, tcc ) then
        args.Push( cast( ulong, tcc.kind ) ) : args.Push( cast( ulong, tcc.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        return true
    end if

    '' A UDT CONVERTED BY 'operator cast'. A bare char* passes LENGTH 0 here, not -1
    '' and not a declared count: measured, 'r = u' is
    '' 'fb_StrAssign( &R, -1ll, vr, 0ll, 0 )'. 0 means NUL-terminated, work it out.
    dim as boolean tRaw = false
    dim as MirValue tuc
    if UserCastToStr_( c, term, tuc, tRaw ) then
        args.Push( cast( ulong, tuc.kind ) ) : args.Push( cast( ulong, tuc.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, iif( tRaw, 0, cast( longint, -1 ) ) ) )
        return true
    end if

    '' A FIXED-LENGTH STRING passes its address and its ENCODED length -- kind 3 comes
    '' back with the sign-tagged constant already in 'zn', so this is the same push as
    '' the zstring case and the two share a branch.
    dim as longint zn
    dim as long zk = StrSwapKind_( c, c.info->TypeOf_( term ), zn )
    if (zk = 1) orelse (zk = 3) then
        dim as MirValue za = LowerAddr( c, term )
        if za.kind <> cast( ubyte, MV_NONE ) then
            args.Push( cast( ulong, za.kind ) )
            args.Push( cast( ulong, za.id ) )
            PushStrLen_( c, args, zn )
            return true
        end if
    end if

    if IsStringType( c, c.info->TypeOf_( term ) ) = false then return false
    dim as MirValue src = LowerAddr( c, term )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    PushStrArg( args, src )
    return true
end function

'' Flatten a left-leaning '+' chain into its terms, in source order.
sub FlattenConcat _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )

    if id = Fbx.NODE_NONE then return
    if c.ast->Kind( id ) = Fbx.N_BINARY then
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' '&' AND '+' ARE THE SAME OPERATION on strings -- measured: fbc emits
        '' fb_StrAssign followed by fb_StrConcatAssign for both, instruction for
        '' instruction. Only '+' was flattened, so 'b = a & p' declined outright while
        '' 'b = a + p' beside it lowered. ('and' is FreeBASIC's bitwise operator, so
        '' '&' is never ambiguous here.)
        dim as Fbx.TokenKind bop = cast( Fbx.TokenKind, bp->op )
        if (bop = Fbx.TK_PLUS) orelse (bop = Fbx.TK_AMP) then
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
    ( byref c as Ctx, byval a as Fbx.NodeId, byval b as Fbx.NodeId ) as boolean
    if (a = Fbx.NODE_NONE) orelse (b = Fbx.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Fbx.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function


end namespace

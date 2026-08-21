'' lowerstr.bas -- string lowering and the runtime call helper.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The division
'' is by subject rather than by size: everything here is about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Local to this file: the two halves of concatenation lowering call each other.
declare function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Fbx.NodeId ) as boolean
declare sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
declare sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
declare sub StoreThrough _
    ( byref c as Ctx, byref addr as MirValue, byref val as MirValue )
declare function PrintOne _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean
declare function PrintRtlFor( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
declare sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
declare function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean
declare sub FlattenConcat _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )


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
                               c.types->target.pointerBits )
        if cv.known = false then return v
        dim as MirType mt = LowerType( c.info->TypeOf_( id ), *c.types )
        if mt = MT_VOID then mt = MT_I64
        '' ConstOf answers INTEGERS only, so a float constant never reaches here with a
        '' known value -- and must not be given one by casting an integer field to a
        '' double, which would make 'const PI = 3.5' into 3 without a word.
        if IsFloatTy( mt ) then return v
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

'' Zeroes a 24-byte string descriptor.
''
'' fbc emits '__builtin_memset( &A, 0, 24 )' for a string local with no initialiser.
'' MIR has no memset, so this is three i64 stores -- which mem2reg folds away for a
'' local that is written before it is read anyway.
''
'' This is NOT cosmetic. A string local always registers an fb_StrDelete for its scope
'' exit, so a descriptor that was never written would hand the runtime a wild pointer
'' to free.
sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    for off as long = 0 to 16 step 8
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = dst
        fa.imm = off
        dim as MirValue p = Emit( c, fa )
        dim as MirValue z
        z.kind = cast( ubyte, MV_CONST_INT )
        z.ty = cast( ubyte, MT_I64 )
        z.id = 0
        dim as MirInst st_
        st_.op = cast( ushort, M_STORE )
        st_.ty = cast( ubyte, MT_VOID )
        st_.a = p
        st_.b = z
        Emit( c, st_ )
    next
end sub

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

    '' 'print using' still declines: it brackets the items with fb_PrintUsingInit and
    '' fb_PrintUsingEnd and calls a different entry point per item type.
    if sp->extra <> 0 then return false

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

'' One PRINT item. 'chan' is the file number, already lowered to a value by the caller
'' -- the console is 0 and 'print #n' passes n. It is the SAME argument slot either way:
'' measured from fbc's C, 'print #1, x' is 'fb_PrintInt( 1, x, 1 )' against
'' 'fb_PrintInt( 0, x, 1 )' for the console, and no other call and no other shape.
private function PrintOne _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long, _
      byref chan as MirValue ) as boolean

    dim as Fbx.TypeId t = c.info->TypeOf_( it )
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, chan.kind ) ) : args.Push( cast( ulong, chan.id ) )

    if IsStringType( c, t ) then
        '' fb_PrintString takes an FBSTRING DESCRIPTOR, not a (pointer, length) pair
        '' like fb_StrAssign does. A literal has no descriptor, so fbc borrows a
        '' temporary one from the runtime and prints that:
        ''
        ''     FBSTRING* vr$4 = fb_StrAllocTempDescZEx( "lit", 3 );
        ''     fb_PrintString( 0, vr$4, 1 );
        ''
        '' Passing the literal's BYTES here instead would have the runtime read a
        '' descriptor out of string data.
        dim as MirValue desc
        if c.ast->Kind( it ) = Fbx.N_STRING_LIT then
            dim as string litText = StringLitText_( c, it )
            '' The length here is the literal's EXACT length, not the len+1 that
            '' fb_StrAssign and fb_StrConcat take. Measured: fbc passes 2 for "x" to
            '' fb_StrAssign but 3 for "lit" to fb_StrAllocTempDescZEx. The Z in the
            '' name is the difference -- it already knows the bytes are terminated,
            '' so it is not being told to include the terminator in the count.
            dim as FB.Array( of ulong ) ta
            ta.Push( cast( ulong, MV_GLOBAL ) )
            ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
            ta.Push( cast( ulong, MV_CONST_INT ) )
            ta.Push( cast( ulong, len( litText ) ) )
            desc = EmitRtl( c, RTL_STR_TEMPZ, ta )
        else
            desc = LowerAddr( c, it )
        end if
        if desc.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_PRINT_STRING, args )
        return true
    end if

    dim as RtlId which = PrintRtlFor( c, t )
    if which = RTL_NONE then return false
    dim as MirValue v = LowerExpr( c, it )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    v = Coerce( c, v, LowerType( t, *c.types ) )
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    PushConst( args, mask )
    EmitRtl( c, which, args )
    return true
end function

'' The print entry point for a type. There is no generic one, and a POINTER has none of
'' its own -- fbc sends it through fb_PrintULongint.
private function PrintRtlFor( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
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
private sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, v ) )
end sub


'' A string relational operator.
''
'' MEASURED from fbc: one fb_StrCompare, then the operator applied against ZERO.
''
''     int32 vr$5 = fb_StrCompare( &A$1, -1ll, &B$1, -1ll );
''     if( (int64)vr$5 != 0ll ) goto ...          ' for 'a = b'
''
'' so '=' becomes 'cmp == 0', '<' becomes 'cmp < 0', and so on -- the same operator,
'' with the second operand replaced by 0. The (pointer, length) pairs follow the
'' fb_StrAssign convention, where a literal's length INCLUDES the terminator: fbc passes
'' 4 for "lit" here, not the 3 fb_StrAllocTempDescZEx takes.
function LowerStrCompare _
    ( byref c as Ctx, byval bp as Fbx.BinaryPayload ptr, _
      byval tk as Fbx.TokenKind ) as MirValue

    dim as MirValue none_
    select case tk
    case Fbx.TK_EQ, Fbx.TK_NE, Fbx.TK_LT, Fbx.TK_GT, Fbx.TK_LE, Fbx.TK_GE
    case else
        '' Concatenation and the rest are not comparisons and do not belong here.
        return none_
    end select

    dim as FB.Array( of ulong ) args
    if EmitStrTerm( c, args, bp->lhs ) = false then return none_
    if EmitStrTerm( c, args, bp->rhs ) = false then return none_
    dim as MirValue cmp = EmitRtl( c, RTL_STR_COMPARE, args )
    if cmp.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirValue zero_
    zero_.kind = cast( ubyte, MV_CONST_INT )
    zero_.ty = cast( ubyte, MT_I32 )
    zero_.id = 0
    dim as MirInst ins
    ins.op = cast( ushort, BinOpFor( tk, MT_I32, false ) )
    ins.ty = cast( ubyte, MT_I8 )
    ins.a = cmp
    ins.b = zero_
    if ins.op = cast( ushort, M_NONE ) then return none_
    return Emit( c, ins )
end function


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
private function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

    if t = Fbx.TYPE_NONE then return -1
    if IsStringType( c, t ) then
        n = -1
        return 0
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
    end select
    return -1
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

function LowerSwap( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if (sp->a = Fbx.NODE_NONE) orelse (sp->b = Fbx.NODE_NONE) then return false

    dim as Fbx.TypeId t = c.info->TypeOf_( sp->a )
    if t = Fbx.TYPE_NONE then return false

    dim as MirValue la = LowerAddr( c, sp->a )
    dim as MirValue lb = LowerAddr( c, sp->b )
    if (la.kind = cast( ubyte, MV_NONE )) orelse (lb.kind = cast( ubyte, MV_NONE )) then
        return false
    end if

    '' THE LENGTH ARGUMENT IS NOT ALWAYS -1. Measured from fbc's own C:
    ''
    ''     fb_StrSwap( &S1, -1, 0, &S2, -1, 0 )        string  x string
    ''     fb_StrSwap( Z1,   5, 0, Z2,   5, 0 )        zstring * 5, both sides
    ''     fb_StrSwap( &S1, -1, 0, Z1,   5, 0 )        MIXED -- each side its own
    ''     fb_WstrSwap( W1, 5, W2, 5 )                 wstring, a DIFFERENT function
    ''
    '' Passing -1 for a fixed-length operand tells the runtime to read a descriptor out
    '' of character data. That was live for the mixed case: a var-length left operand
    '' took this branch and both sides went out as -1.
    dim as longint na, nb_
    dim as long ka = StrSwapKind_( c, t, na )
    dim as long kb = StrSwapKind_( c, c.info->TypeOf_( sp->b ), nb_ )
    if (ka >= 0) andalso (kb >= 0) then
        '' WSTRING has its own entry point and does not mix with the byte forms; fbc
        '' emits something else again for that pairing, so it is declined rather than
        '' guessed at.
        if (ka = 2) <> (kb = 2) then return false
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, la.kind ) ) : args.Push( cast( ulong, la.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, na ) )
        if ka = 2 then
            args.Push( cast( ulong, lb.kind ) ) : args.Push( cast( ulong, lb.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, nb_ ) )
            EmitRtl( c, RTL_WSTR_SWAP, args )
            return true
        end if
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, lb.kind ) ) : args.Push( cast( ulong, lb.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, nb_ ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        EmitRtl( c, RTL_STR_SWAP, args )
        return true
    end if

    '' THE OPERANDS MAY DIFFER IN TYPE. fbc allows 'swap' between a long and a double
    '' and CONVERTS across the assignments -- the temporary is typed to the LEFT operand
    '' and each store converts into its destination:
    ''
    ''     int32 TMP = A;   A = fb_D2I( B );   B = (double)TMP;
    ''
    '' Loading both sides through one type instead reinterprets the bits, which lowers
    '' cleanly, verifies, and is wrong. This was exactly that bug for one commit.
    dim as Fbx.TypeId rt = c.info->TypeOf_( sp->b )
    if rt = Fbx.TYPE_NONE then return false
    dim as MirType mtl = LowerType( t, *c.types )
    dim as MirType mtr = LowerType( rt, *c.types )
    if (mtl = MT_VOID) orelse (mtr = MT_VOID) then return false
    '' An aggregate has no single load/store, so it is declined rather than
    '' half-swapped. Strings are the aggregate that matters and took the path above.
    '' TWO AGGREGATES of the same size swap as BYTES: fbc emits
    '' 'fb_MemSwap( &U1, &U2, 16 )' for a pair of 16-byte UDTs. Different sizes are
    '' not a swap fbc accepts, so they still decline.
    if (mtl = MT_AGG) andalso (mtr = MT_AGG) then
        '' A UDT's size lives in the LAYOUT TABLE, not in TypeContext.Layout -- the
        '' same two-step LocalFor makes when it sizes an aggregate slot. Asking the
        '' type alone gives 0 and the swap silently declined.
        dim as long sza = c.types->Layout( t ).size
        dim as long szb = c.types->Layout( rt ).size
        dim as long uia = c.udts->Find( t )
        if uia >= 0 then sza = c.udts->udts[uia].size
        dim as long uib = c.udts->Find( rt )
        if uib >= 0 then szb = c.udts->udts[uib].size
        if (sza > 0) andalso (sza = szb) then
            dim as FB.Array( of ulong ) margs
            margs.Push( cast( ulong, la.kind ) ) : margs.Push( cast( ulong, la.id ) )
            margs.Push( cast( ulong, lb.kind ) ) : margs.Push( cast( ulong, lb.id ) )
            margs.Push( cast( ulong, MV_CONST_INT ) ) : margs.Push( cast( ulong, sza ) )
            EmitRtl( c, RTL_MEM_SWAP, margs )
            return true
        end if
    end if
    if (mtl = MT_AGG) orelse (mtr = MT_AGG) then return false

    dim as long slot = NewTempLocal( c, mtl, c.types->Layout( t ).size )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    StoreThrough( c, tmp, LowerExprLoad( c, la, mtl ) )
    StoreThrough( c, la, Coerce( c, LowerExprLoad( c, lb, mtr ), mtl ) )
    StoreThrough( c, lb, Coerce( c, LowerExprLoad( c, tmp, mtl ), mtr ) )
    return true
end function

'' One store, which SWAP needs three of.
private sub StoreThrough _
    ( byref c as Ctx, byref addr as MirValue, byref val as MirValue )
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub

function LowerStringAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    if IsStringType( c, c.info->TypeOf_( target ) ) = false then return false
    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    '' A '+' chain is flattened and emitted as ONE assign followed by concat-assigns,
    '' which is exactly what fbc does: 'a = b + c' is fb_StrAssign(a,b) then
    '' fb_StrConcatAssign(a,c), with no temporary at all.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )

    '' If the destination is read AFTER it would be written, the chain cannot be built
    '' in place: 'a = b + a' would overwrite a before reading it. fbc builds such a
    '' chain in a temporary and assigns from that.
    dim as boolean needsTemp = false
    for i as long = 1 to terms.Count - 1
        if SameLValue( c, target, cast( Fbx.NodeId, terms[i] ) ) then needsTemp = true
    next
    if needsTemp then return LowerConcatViaTemp( c, dst, terms )

    '' The first term is assigned, every later one concatenated onto it. When the
    '' destination IS the first term, the assign is a self-assignment and is skipped.
    for i as long = 0 to terms.Count - 1
        dim as Fbx.NodeId term = cast( Fbx.NodeId, terms[i] )
        if (i = 0) andalso SameLValue( c, target, term ) then continue for
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
        if cast( Fbx.TokenKind, bp->op ) = Fbx.TK_PLUS then
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

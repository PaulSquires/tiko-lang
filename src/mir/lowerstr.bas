'' lowerstr.bas -- string lowering and the runtime call helper.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The division
'' is by subject rather than by size: everything here is about the string runtime.

#include once "mir/lowerctx.bi"
#include once "support/fbstr.bi"

namespace Tko.Mir

'' The string FLAVOUR predicates, split out at the 1500-line cap.
#include once "mir/lowerstrkind.bas"

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

    dim as boolean isU = ConcatTermsAreU_( c, terms )

    '' fb_StrConcat takes the destination descriptor first, then the two operands.
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) )
    args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ), isU ) = false then return false
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[1] ), isU ) = false then return false
    dim as MirValue acc = EmitRtl( c, iif( isU, RTL_USTR_CONCAT, RTL_STR_CONCAT ), args )

    '' Any further terms concatenate onto the temporary in place.
    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Tko.NodeId, terms[i] ), isU ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) )
        more.Push( 0 )
        EmitRtl( c, iif( isU, RTL_USTR_CONCAT_ASSIGN, RTL_STR_CONCAT_ASSIGN ), more )
    next

    dim as FB.Array( of ulong ) fin
    PushStrArg( fin, dst )
    PushStrArg( fin, tmp )
    fin.Push( cast( ulong, MV_CONST_INT ) )
    fin.Push( 0 )
    EmitRtl( c, iif( isU, RTL_USTR_ASSIGN, RTL_STR_ASSIGN ), fin )
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

'' IS THIS CHAIN A USTRING CHAIN? Any term being one makes the whole concatenation
'' UTF-16 -- 'a & "y"' over a ustring is fb_UStrConcat with a UTF-16 literal -- and a
'' literal on its own says nothing, so the terms are asked one at a time.
function ConcatTermsAreU_ _
    ( byref c as Ctx, byref terms as FB.Array( of ulong ) ) as boolean

    for i as long = 0 to terms.Count - 1
        if IsUStringType( c, c.info->TypeOf_( cast( Tko.NodeId, terms[i] ) ) ) then
            return true
        end if
    next
    return false
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

    dim as boolean isU = ConcatTermsAreU_( c, terms )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) ) : args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ), isU ) = false then return false
    if EmitStrTerm( c, args, cast( Tko.NodeId, terms[1] ), isU ) = false then return false
    EmitRtl( c, iif( isU, RTL_USTR_CONCAT, RTL_STR_CONCAT ), args )

    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Tko.NodeId, terms[i] ), isU ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) )
        more.Push( 0 )
        EmitRtl( c, iif( isU, RTL_USTR_CONCAT_ASSIGN, RTL_STR_CONCAT_ASSIGN ), more )
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
        '' AT THE CONSTANT'S OWN DECLARED WIDTH. The INITIALISER is what was folded
        '' and it knows nothing about the type it is declared as, so
        '' 'const v as ubyte = not u' read back as -1 where fbc has 255 -- and it
        '' lowered and verified, as an i8 holding the wrong number.
        cv = Tko.Check.ClampConstToTypeRef( *c.ast, ip->a, cv, _
                                            c.types->target.pointerBits )
        dim as MirType mt = LowerType( c.info->TypeOf_( id ), *c.types )
        if mt = MT_VOID then mt = MT_I64
        '' AN INTEGER CONSTANT WHOSE INITIALISER THE EVALUATOR CANNOT FOLD is lowered
        '' from that initialiser too, for the same reason the float one below is.
        '' 'const N = sizeof( T )' is the shape: the size comes from the UDT LAYOUT,
        '' which is computed after Check and which the evaluator therefore has no way to
        '' reach -- while lowering, where the layout exists, folds it to a plain
        '' constant. Every READ of such a constant was silently valueless, and
        '' 'const IMAGE_BUFFER_SIZE = sizeof( fb.IMAGE ) + ...' is how gfx/image-expr.bas
        '' sizes every buffer in it.
        ''
        '' A constant's initialiser is a constant expression, so this emits constants
        '' and not work -- and it is only reached where the evaluator has already failed.
        if (cv.known = false) andalso (IsFloatTy( mt ) = false) then
            dim as MirValue iv2 = LowerExpr( c, ip->b )
            if iv2.kind = cast( ubyte, MV_NONE ) then return v
            return Coerce( c, iv2, mt, IsUnsignedType( c, c.info->TypeOf_( id ) ) )
        end if
        '' ConstOf answers INTEGERS only, so a float constant never reaches here with
        '' a known value -- and must not be given one by casting an integer field to a
        '' double, which would make 'const PI = 3.5' into 3 without a word.
        ''
        '' It is lowered from its INITIALISER instead. A constant's initialiser is a
        '' constant expression, so lowering it emits the value directly, and no
        '' evaluator has to learn about floats to get there. Declining was 862 of one
        '' corpus file's statements -- every 'iif( c, T1, 0.0 )' over a
        '' 'const T1 as double', where BOTH arms came out empty.
        '' A FLOAT CONSTANT IS ALWAYS LOWERED FROM ITS INITIALISER, even when the
        '' INTEGER evaluator answered -- '^' is a double operator over integer
        '' literals, so 'const A = 2^10' folded to the integer 1024 with a DOUBLE
        '' type, and refusing that declined every use. Casting the integer field to a
        '' double is still not allowed: it would turn 'const PI = 3.5' into 3.
        if IsFloatTy( mt ) then
            dim as MirValue fv = LowerExpr( c, ip->b )
            if fv.kind = cast( ubyte, MV_NONE ) then return v
            return Coerce( c, fv, mt )
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

    '' A WIDE SOURCE FOR A NARROW DESTINATION does not go through fb_StrInit at all:
    '' 'dim as string c = w & s' builds the wide temporary and then transfers it with
    '' fb_WstrAssignToA_Init. The ASSIGNMENT form of this was already here; the
    '' DECLARATION had no route to it, so every one of them dropped its initialiser --
    '' 119 of them in string/concat.bas, the concatenation matrix.
    if slot >= 0 then
        dim as Tko.TypeId dt0 = c.f->locals[slot].frontendType
        if dt0 = Tko.TYPE_NONE then dt0 = c.info->TypeOf_( target )
        if IsUStringType( c, dt0 ) = false then
            '' A LITERAL CONTAINING A UNICODE ESCAPE IS WIDE and does not follow its
            '' context: '#print typeof( !"\u0041" )' is WSTRING * 3 while '!"\n"'
            '' is ZSTRING. Without it 'dim as string s = !"\u0041\u0042"' put the
            '' twelve characters of the SPELLING in a narrow global; fbc emits
            '' 'fb_WstrAssignToA_Init( &S, -1, L"AB", 0 )'.
            '' ...AND A WIDE CALL WHOSE TYPE IS EMPTY. 'wchr( 65 )' and 'wspace( n )'
            '' have no type at all -- Check computes none for an unbound callee -- so
            '' a type-and-literal test said narrow and
            '' 'dim s as zstring * 10 = wchr( 65 )' declined, while 'wstr( "B" )'
            '' beside it lowered. Measured, fbc folds the code and emits
            '' 'fb_WstrAssignToA_Init( S1, 10, L"A", 0 )'.
            dim as boolean wideInit = ConcatHasWideTerm_( c, value )
            if wideInit = false then
                wideInit = IsWideString_( c, c.info->TypeOf_( value ) )
            end if
            if wideInit = false then wideInit = LitHasUnicodeEscape_( c, value )
            if wideInit = false then wideInit = TermIsWide_( c, value )
            if wideInit then
                ZeroStrDescriptor( c, dst )
                if LowerWideToNarrowSlot( c, slot, dt0, value, true ) then return true
                return false
            end if
        end if
    end if

    '' A concatenation cannot go through fb_StrInit, which takes one source. Zero the
    '' descriptor so it is a valid empty string, then build into it the ordinary way.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )
    if terms.Count <> 1 then
        ZeroStrDescriptor( c, dst )
        '' THROUGH THE SLOT, not through 'target'. At a declaration 'target' is the
        '' N_VAR_ITEM, which is not an expression and has no address: LowerStringAssign
        '' asked it for one, got nothing and returned false -- and the caller was
        '' discarding that answer, so 'dim as string a = b + c' emitted the zeroed
        '' descriptor and DROPPED THE INITIALISER, silently and with nothing declined.
        '' The self-reference check LowerStringAssign does with 'target' has nothing to
        '' find here: the descriptor was just zeroed, so a chain naming the variable
        '' being declared reads the empty string either way.
        dim as FB.Array( of ulong ) cterms
        FlattenConcat( c, value, cterms )
        dim as boolean dIsU = false
        if slot >= 0 then dIsU = IsUStringType( c, c.f->locals[slot].frontendType )
        if dIsU = false then dIsU = IsUStringType( c, c.info->TypeOf_( target ) )
        if StrChainNeedsConvert( c, dIsU, cterms ) then
            '' A DECLARATION's trailing flag is -1, so the conversion cannot go through
            '' the assignment path: it would pass 0 and the runtime would release a
            '' descriptor that was never written.
            if LowerUStrChain( c, dst, dIsU, cterms, true ) then return true
            if dIsU then return LowerNarrowChainToU_( c, dst, cterms, true )
            return false
        end if
        return LowerStringAssignToSlot( c, slot, value )
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

    '' A DECLARATION converts too, and its trailing flag is -1 where an assignment's
    '' is 0 -- the same distinction fb_StrInit and fb_StrAssign make by being separate
    '' functions.
    if StrTermFlavour_( c, cast( Tko.NodeId, terms[0] ) ) <> STF_NEUTRAL then
        dim as long tf0 = StrTermFlavour_( c, cast( Tko.NodeId, terms[0] ) )
        dim as boolean mismatch = iif( isU, (tf0 <> STF_UTF16), (tf0 = STF_UTF16) )
        if mismatch then
            if LowerStrConvertTerm( c, dst, isU, cast( Tko.NodeId, terms[0] ), true ) then
                return true
            end if
            ZeroStrDescriptor( c, dst )
            return false
        end if
    end if

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

    '' A SEPARATOR IS CONSUMED BY THE ITEM IMMEDIATELY BEFORE IT, and one with no item
    '' before it PRINTS ON ITS OWN. Measured, and it is uniform:
    ''
    ''     print ,       fb_PrintVoid( 0, 2 )
    ''     print ;       fb_PrintVoid( 0, 0 )
    ''     print ,,      fb_PrintVoid( 0, 2 ) twice
    ''     print ,;      fb_PrintVoid( 0, 2 ), fb_PrintVoid( 0, 0 )
    ''     print 1,,     fb_PrintLongint( 0, 1, 2 ), fb_PrintVoid( 0, 2 )
    ''     print ,1      fb_PrintVoid( 0, 2 ), fb_PrintLongint( 0, 1, 1 )
    ''     print 1,2,    fb_PrintLongint( 0, 1, 2 ), fb_PrintLongint( 0, 2, 2 )
    ''
    '' -- the last one is the check: a TRAILING separator after an item is that
    '' item's mask and adds nothing.
    ''
    '' The loop skipped every separator outright, so a print whose list is ONLY
    '' separators emitted NOTHING AT ALL -- and counted as lowered, because nothing
    '' declined. 'print #(1), ,' is how string/print_using.bas writes a blank
    '' tabbed field, and the file lowered clean with the statement missing.
    dim as long usedSep = -1
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Tko.N_PRINT_SEP then
            '' 'print x; using f; a' -- A USING THAT STARTS PART WAY THROUGH. What
            '' precedes it has just been printed plainly; everything after it belongs
            '' to the format, so the rest of the list is handed to the USING run and
            '' this loop is done. Measured: fbc emits the plain items, then Init, the
            '' formatted items, and End.
            dim as Tko.StmtPayload ptr usp = StmtOf( c, it )
            if usp->op = cast( ushort, Tko.KW_USING ) then
                return LowerPrintUsing( c, id, i + 1, usp->a )
            end if
            '' NOT consumed by an item before it: it prints on its own.
            if i <> usedSep then
                dim as long smask = 0
                if usp->op = cast( ushort, Tko.TK_COMMA ) then smask = 2
                dim as FB.Array( of ulong ) sa
                sa.Push( cast( ulong, chan.kind ) ) : sa.Push( cast( ulong, chan.id ) )
                PushConst( sa, smask )
                EmitRtl( c, RTL_PRINT_VOID, sa )
            end if
            continue for
        end if

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
                usedSep = i + 1
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
'' A DOTTED PATH THROUGH A TYPE OR A NAMESPACE rather than through an object --
'' 'T.field', 'T.Inner.field', 'ns.name'. What distinguishes it is the LEFTMOST name: a
'' type or a namespace, never a variable.
private function QualifiedStaticPath_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as boolean

    if id = Tko.NODE_NONE then return false
    dim as Tko.NodeId cur = id
    dim as long guard = 0
    while (c.ast->Kind( cur ) = Tko.N_MEMBER) andalso (guard < 64)
        guard += 1
        cur = c.ast->binaries[cast( long, c.ast->nodes[cast( long, cur )].data )].lhs
    wend
    if cur = id then return false
    if c.ast->Kind( cur ) <> Tko.N_IDENT then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( cur ) )
    if s = 0 then return false
    select case s->kind
    case cast( ubyte, Tko.SYM_UDT ), cast( ubyte, Tko.SYM_NAMESPACE ), _
         cast( ubyte, Tko.SYM_TYPEDEF )
        return true
    end select
    return false
end function

'' 'len( T.field )' AND 'sizeof( T.field )' OVER A TYPE NAME ARE COMPILE-TIME CONSTANTS.
''
'' There is no object, so there is nothing to measure at run time -- and tiko-lang
'' INVENTED ONE. It allocated a local of the type, took a field address inside it and
'' called fb_StrLen on that: a length read out of a frame slot nothing had written.
'' It lowered, it verified, and it counted as a statement successfully compiled.
''
'' Measured, over 'type T: const zs = "hello" : z as zstring * 10 : w as wstring * 10 :
'' s as string : sl as long : end type':
''
''     len( T.zs )     5     the CONSTANT'S TEXT length
''     sizeof( T.zs )  6     ...and its byte size, the NUL included
''     len( T.z )     10     'zstring * 10' -- its DECLARED SIZE, not a strlen
''     len( T.w )     20     'wstring * 10' -- twenty BYTES, not ten characters
''     len( T.s )     24     the descriptor
''     len( T.sl )     4
''
'' -- so every one of them is the member's own size, and LEN and SIZEOF differ only over
'' a string CONSTANT, where len is the text and sizeof the bytes it occupies.
''
'' The same holds through a namespace: 'len( ns.s )' over 'const s = "hello"' is 5.
private function LowerStaticMemberLen_ _
    ( byref c as Ctx, byval a as Tko.NodeId, byval isSizeof as boolean, _
      byref outv as MirValue ) as boolean

    if QualifiedStaticPath_( c, a ) = false then return false

    '' A STRING CONSTANT MEASURES ITS TEXT. It has no storage of its own, so the size
    '' its type would give is the size of whatever the initialiser was written as.
    dim as string ct
    if ConstStringTextOf_( c, a, ct ) then
        dim as longint n = len( ct )
        if isSizeof then n += 1
        outv = ConstInt( c, n, MT_I64 )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    dim as Tko.TypeId mt2 = c.info->TypeOf_( a )
    if mt2 = Tko.TYPE_NONE then return false
    dim as long sz = SizeOfType( c, mt2 )
    if sz <= 0 then return false
    outv = ConstInt( c, sz, MT_I64 )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

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

    '' A DOTTED PATH THROUGH A TYPE NAME IS A COMPILE-TIME SIZE, and there is no object
    '' to measure -- see LowerStaticMemberLen_, which is also where the phantom instance
    '' this used to allocate came from. Tried before the type test below because a
    '' string CONSTANT member has no type of its own to report.
    if LowerStaticMemberLen_( c, a, isSizeof, outv ) then return true

    '' A NAME THAT IS BOTH A TYPE AND A PROCEDURE is, inside SIZEOF, the TYPE.
    '' An identifier in expression position prefers the VALUE class, so
    '' 'type f1 ... : declare sub f1 : print sizeof( f1 )' measured the SUB and
    '' declined. Measured: fbc folds it to the type's size -- 'fb_PrintLongint(
    '' 0, 8ll, 1 )' for a one-integer type.
    if (isSizeof) andalso (c.ast->Kind( a ) = Tko.N_IDENT) then
        dim as Tko.Symbol ptr asy = c.syms->SymbolAt( c.info->RefOf( a ) )
        if asy <> 0 then
            if asy->kind = cast( ubyte, Tko.SYM_PROC ) then
                '' THROUGH 'altClass', not a fresh lookup: an expression node inside a
                '' procedure has no recorded scope -- Collect never walks a body -- so
                '' there is nothing to look the name up FROM. The slot already holds
                '' both classes and this is the link between them.
                dim as Tko.Symbol ptr tsy = c.syms->SymbolAt( asy->altClass )
                if tsy <> 0 then
                    if tsy->type_ <> Tko.TYPE_NONE then
                        dim as long tsz = SizeOfType( c, tsy->type_ )
                        if tsz > 0 then
                            outv = ConstInt( c, tsz, MT_I64 )
                            return true
                        end if
                    end if
                end if
            end if
        end if
    end if

    dim as Tko.TypeId at = c.info->TypeOf_( a )
    if at = Tko.TYPE_NONE then return false

    '' 'len( string )' NAMES A TYPE, not a value, and folds to that type's SIZE like
    '' SIZEOF does: measured, fbc emits 24 for 'len( string )' -- the descriptor -- and
    '' 2 for 'len( wstring )'. The string branches below asked a TYPE REFERENCE for an
    '' address, which it has not got, so both declined while 'sizeof( string )' beside
    '' them folded.
    dim as boolean lenOfType = (c.ast->Kind( a ) = Tko.N_TYPEREF)

    '' WIDE: one argument, no length.
    if (IsWideString_( c, at )) andalso (isSizeof = false) andalso (lenOfType = false) then
        '' A WIDE EXPRESSION HAS NO ADDRESS. 'len( wstr( x ) )' is wide-typed --
        '' 'WSTRING * 1' -- so this branch claimed it and then asked an N_CALL for an
        '' address, which it has not got, and the whole statement declined. Every
        '' flavour did: over a var-length string, over a 'zstring * N' and over a
        '' literal alike. WideOperand_ is what BUILDS one, and it is what every other
        '' wide site already uses; only this one asked for an address directly.
        dim as MirValue wa = LowerAddr( c, a )
        if wa.kind = cast( ubyte, MV_NONE ) then
            if WideOperand_( c, a, wa ) = false then return false
        end if
        if wa.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) wargs
        wargs.Push( cast( ulong, wa.kind ) ) : wargs.Push( cast( ulong, wa.id ) )
        outv = EmitRtl( c, RTL_WSTR_LEN, wargs )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' NARROW: a descriptor passes -1, a fixed ZSTRING its element count.
    dim as longint zn = -1
    dim as boolean narrow = false
    if (isSizeof = false) andalso (lenOfType = false) then
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
    if (isSizeof = false) andalso (lenOfType = false) then
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
        ''
        '' A CONCATENATION IS ASKED TERM BY TERM. Check types 'a & b' as a plain
        '' string whatever its operands are, so the type alone said narrow and
        '' 'len( a & b )' over two ustrings measured a UTF-16 temporary with fb_StrLen.
        dim as boolean lenU = IsUStringType( c, at )
        if (lenU = false) andalso (c.ast->Kind( a ) = Tko.N_BINARY) then
            dim as FB.Array( of ulong ) lterms
            FlattenConcat( c, a, lterms )
            if lterms.Count > 1 then lenU = ConcatTermsAreU_( c, lterms )
        end if
        outv = EmitRtl( c, iif( lenU, RTL_USTR_LEN, RTL_STR_LEN ), sargs )
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
    if lp->count < 1 then return false
    if lp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    '' ...and the WIDE RADIX FAMILY, which is wide by the same rule and for the same
    '' reason: Check computes no type for the call, so only the NAME says so.
    select case Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    '' ...AND 'wspace( n )', which is wide for the same reason and was not here:
    '' it lowered standalone -- fb_WstrSpace -- and compared against a wstring, but
    '' inside a CONCATENATION TermIsWide_ asks this list, decided the term was
    '' narrow, and sent it to the narrow emitter, which had nothing to give.
    '' Measured: 'wstr( "a" ) + wspace( 3 )' is
    '' 'fb_WstrConcat( L"a", fb_WstrSpace( 3 ) )'.
    '' 'wchr( a, b, ... )' IS VARIADIC and wide whatever its arity, which is why the
    '' one-argument guard is per-name and no longer at the top: measured,
    '' 'dim s as zstring * 10 = wchr( 65 )' is
    '' 'fb_WstrAssignToA_Init( S1, 10, L"A", 0 )' -- the code folded to a wide
    '' literal -- and tiko-lang declined it while 'wstr( "B" )' beside it lowered.
    case "wstr", "whex", "woct", "wbin", "wspace"
        return (lp->count = 1)
    case "wchr"
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
        '' Through the wide reader, so a '\uXXXX' is a CODE UNIT here and not six
        '' characters of spelling.
        dim as long wch2 = 0
        dim as long wg2 = WideLitGlobal_( c, a, wch2 )
        if wg2 < 0 then return false
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = wg2
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
        '' A NARROW CONCATENATION HAS NO ADDRESS. Measured, fbc builds it into a
        '' temporary descriptor and converts THAT:
        ''
        ''     vr$6 = fb_StrConcat( &TMP$4$0, "asd", 4, vr$3, -1 );
        ''     vr$8 = fb_StrToWstr( (char*)*(char**)&TMP$5$0 );
        ''
        '' -- which is 'wstr( "asd" + chr( 0 ) )', the shape wstring/instr_0.bas is
        '' written out of. Asking only for an address declined every one of them.
        if d.kind = cast( ubyte, MV_NONE ) then
            if ConcatToTemp_( c, a, d ) = false then
                '' NOR HAS A CALL. 'f( hex( 1 ) )' against a 'byref w as wstring'
                '' parameter is measured as a NARROW temporary and then the
                '' conversion:
                ''
                ''     vr$20 = fb_HEX_l( 1 );
                ''     fb_StrAssign( &TMP$6$0, -1, vr$20, -1, 0 );
                ''     vr$22 = fb_StrToWstr( (char*)*(char**)&TMP$6$0 );
                ''
                '' -- the same temporary a byval string parameter gets. Without it
                '' every narrow RVALUE handed to a wide parameter declined:
                '' functions/temp-strings.bas writes the shape twelve times.
                dim as long nslot = _
                    NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
                if nslot < 0 then return false
                dim as MirValue nd
                nd.kind = cast( ubyte, MV_LOCAL )
                nd.ty = cast( ubyte, MT_PTR )
                nd.id = nslot
                ZeroStrDescriptor( c, nd )
                if StrInitFrom_( c, nd, a ) = false then return false
                '' Released at the END OF THE STATEMENT, beside the other string
                '' temporaries, which is the life fbc gives it.
                c.strTemps.Push( cast( ulong, nslot ) )
                d = nd
            end if
        end if
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
    elseif sk = 3 then
        '' A 'string * N' IS NOT A CHAR ARRAY THE WAY A ZSTRING IS: it is SPACE-PADDED
        '' and carries no terminator, so its N bytes cannot be handed to fb_StrToWstr
        '' as a C string. Measured, fbc copies it into a var-length temporary first and
        '' converts THAT:
        ''
        ''   fb_StrAssign( &TMP$2$0, -1ll, (void*)FS$0, -9223372036854775798ll, 0 );
        ''   vr$6 = fb_StrToWstr( (char*)*(char**)&TMP$2$0 );
        ''
        '' -- the second argument being the TAGGED length of the fixed string, which is
        '' what tells the runtime to stop at N bytes and trim the padding.
        ''
        '' fbc emits a third call after those two, copying the temporary BACK into the
        '' fixed string, which is its general byref-temp protocol; nothing here writes
        '' the temporary, so it is a no-op and is not reproduced.
        ''
        '' Without this row 'wstr( fs )' produced nothing, and it takes the enclosing
        '' statement with it: overload/strings_ptr.bas is twelve calls that each pass
        '' one.
        dim as MirValue fa2 = LowerAddr( c, a )
        if fa2.kind = cast( ubyte, MV_NONE ) then return false
        dim as long fslot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
        if fslot < 0 then return false
        dim as MirValue fd
        fd.kind = cast( ubyte, MV_LOCAL )
        fd.ty = cast( ubyte, MT_PTR )
        fd.id = fslot
        ZeroStrDescriptor( c, fd )
        dim as FB.Array( of ulong ) faa
        faa.Push( cast( ulong, fd.kind ) ) : faa.Push( cast( ulong, fd.id ) )
        faa.Push( cast( ulong, MV_CONST_INT ) )
        faa.Push( cast( ulong, cast( ulongint, -1 ) ) )
        faa.Push( cast( ulong, fa2.kind ) ) : faa.Push( cast( ulong, fa2.id ) )
        '' ALREADY ENCODED: StrSwapKind_ hands back a FIXSTR's length in the tagged
        '' form, because that is the only form any runtime call wants it in --
        '' encoding it a second time here would set the tag bit on a value that
        '' already has it. And it is a 64-BIT constant, so it goes through
        '' PushStrLen_: pushing it as a ulong truncates the tag away and the runtime
        '' reads a plain length of 10.
        PushStrLen_( c, faa, zn )
        faa.Push( cast( ulong, MV_CONST_INT ) ) : faa.Push( 0 )
        EmitRtl( c, RTL_STR_ASSIGN, faa )
        '' Released at the END OF THE STATEMENT, with the other string temporaries.
        c.strTemps.Push( cast( ulong, fslot ) )

        dim as MirInst ffa
        ffa.op = cast( ushort, M_FIELD_ADDR )
        ffa.ty = cast( ubyte, MT_PTR )
        ffa.a = fd
        ffa.imm = 0
        dim as MirValue fpa = Emit( c, ffa )
        if fpa.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue fraw = LowerExprLoad( c, fpa, MT_PTR )
        if fraw.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) fargs
        fargs.Push( cast( ulong, fraw.kind ) ) : fargs.Push( cast( ulong, fraw.id ) )
        outv = EmitRtl( c, RTL_STR_TO_WSTR, fargs )
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
    '' A POINTER RENDERS AS ITS ADDRESS, unsigned -- measured, 'wstr( p )' is
    '' 'fb_ULongintToWstr( (uint64)P$0 )' for every pointer type. It is not a
    '' BUILTIN, so the test below refused it and the call came out untyped.
    dim as boolean atPtr = (c.types->Kind( at ) = Tko.TK_POINTER)
    if (c.types->Kind( at ) <> Tko.TK_BUILTIN) andalso (atPtr = false) then return false
    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    if atPtr then r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    if atPtr = false then
        select case c.types->BuiltinOf( at )
    '' BOOLEAN IS ITS OWN RENDERER, not an integer one -- measured, 'wstr( b )' is
    '' 'fb_BoolToWstr( B$0 )', and fb_IntToWstr writes -1 and 0 where fbc writes
    '' "true" and "false". The narrow half of this table already had the distinction.
    case Tko.TY_BOOLEAN
        r = RTL_BOOL_TO_WSTR : want = MT_I8
    case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG
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
    end if

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

    '' A STRING-TO-STRING 'cast' IS THE IDENTITY -- see StrIdentityConvOperand_. Left
    '' in place it looked like a CONVERSION term and took the transcoding path, which
    '' has nothing to convert and declined.
    dim as Tko.NodeId sicv = StrIdentityConvOperand_( c, value )
    if sicv <> Tko.NODE_NONE then value = sicv

    '' A '+' chain is flattened and emitted as ONE assign followed by concat-assigns,
    '' which is exactly what fbc does: 'a = b + c' is fb_StrAssign(a,b) then
    '' fb_StrConcatAssign(a,c), with no temporary at all.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )

    '' If the destination is read AFTER it would be written, the chain cannot be built
    '' in place: 'a = b + a' would overwrite a before reading it. fbc builds such a
    '' chain in a temporary and assigns from that.
    '' THE FLAVOUR COMES FROM THE DESTINATION -- BUT THE TERMS DO NOT FOLLOW IT. A
    '' ustring transcodes rather than copies, so a term of another flavour takes a
    '' different entry point entirely, and pushing it as if it shared the destination's
    '' flavour is what put UTF-8 bytes in a UTF-16 descriptor. Decided BEFORE the
    '' temporary path below, which builds the whole chain with one flavour's calls.
    ''
    '' One term converts. A CHAIN needing a conversion declines: fbc folds the narrow
    '' part first and then transcodes once, or builds the ustring temporary with
    '' fb_UStrConcatUA and fb_UStrConcatAU depending on WHICH SIDE is the ustring, and
    '' half of that model would be a wrong answer rather than a partial one.
    dim as boolean isU0 = IsUStringType( c, c.info->TypeOf_( target ) )
    if target = Tko.NODE_NONE then isU0 = IsUStringDest_( c, dst )
    if StrChainNeedsConvert( c, isU0, terms ) then
        if terms.Count = 1 then
            return LowerStrConvertTerm( c, dst, isU0, cast( Tko.NodeId, terms[0] ), false )
        end if
        if LowerUStrChain( c, dst, isU0, terms, false ) then return true
        '' AN ALL-NARROW CHAIN INTO A USTRING folds narrow first and transcodes ONCE:
        '' 'u = q + q' is fb_StrConcat into a temporary and then fb_UStrAssignFromA.
        if isU0 then return LowerNarrowChainToU_( c, dst, terms, false )
        return false
    end if

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
    if target = Tko.NODE_NONE then isU = IsUStringDest_( c, dst )

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

#include once "mir/lowerconcat.bas"

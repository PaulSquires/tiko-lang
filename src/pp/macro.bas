'' macro.bas -- macro definition, argument binding and expansion.  Included by pp.bas.
''
'' Expansion pushes a FRAME rather than splicing into the input, which is what makes
'' hide sets free: the macro is hidden exactly while its frame is on the stack, and
'' rescanning happens naturally because the main loop reads from the top frame.

namespace Fbx

'' ------------------------------------------------------------------ definition

private function PpFindOrAddMacro _
    ( byref e as PpEngine, byval id as InternId ) as PpMacro ptr

    dim as long slot = SlotOf( e, id )
    if slot > 0 then return @e.macros[slot - 1]

    dim as PpMacro m
    m.name = id
    m.isFunc = false
    m.isVariadic = false
    m.isDefined = false
    m.builtin = PPB_NONE
    e.macros.Push( m )
    SetSlot( e, id, e.macros.Count )
    return @e.macros[e.macros.Count - 1]
end function

'' Shared by #define and #macro: read '( a, b, ... )' if it is glued to the name.
private sub PpReadParams( byref e as PpEngine, byval m as PpMacro ptr )
    dim as Token t
    if PeekOnLine( e, t ) = false then return

    '' A '(' separated by whitespace introduces an expression, not a parameter list.
    dim as boolean glued = (Tk( t ) = TK_LPAREN) andalso ((t.flags and TF_SPACE_BEFORE) = 0)
    if glued = false then return

    m->isFunc = true
    Advance( e )

    do
        if PeekOnLine( e, t ) = false then exit do
        if Tk( t ) = TK_RPAREN then
            Advance( e )
            exit do
        end if

        if Tk( t ) = TK_IDENT then
            m->params.Push( cast( ulong, t.literal ) )
            Advance( e )
        elseif Tk( t ) = TK_ELLIPSIS then
            m->isVariadic = true
            Advance( e )
        else
            Advance( e )
        end if

        if PeekOnLine( e, t ) then
            if Tk( t ) = TK_COMMA then Advance( e )
        end if
    loop
end sub

private sub PpDefine( byref e as PpEngine, byval at as SourceLoc, byval isBlock as boolean )
    dim as Token t
    if PeekOnLine( e, t ) = false then
        Report( e, FBX0316, at, iif( isBlock, "macro", "define" ) )
        return
    end if
    if Tk( t ) <> TK_IDENT then
        '' Redefining a keyword is legal in FreeBASIC and the corpus does it.
        if IsKeywordKind( Tk( t ) ) = false then
            Report( e, FBX0316, t.loc, iif( isBlock, "macro", "define" ) )
            SkipToEol( e )
            return
        end if
    end if

    dim as InternId id = cast( InternId, t.literal )
    if Tk( t ) <> TK_IDENT then
        id = e.names->GetString( Text.LowerAscii( TokenKindText( Tk( t ) ) ) )
    end if
    Advance( e )

    dim as PpMacro ptr m = PpFindOrAddMacro( e, id )
    if m->isDefined then Report( e, FBX0305, at, e.names->Spelling( id ) )

    m->isDefined = true
    m->isFunc = false
    m->isVariadic = false
    m->builtin = PPB_NONE
    m->loc = at
    m->params.Clear( )
    m->body.Clear( )

    PpReadParams( e, m )

    if isBlock = false then
        CollectLine( e, m->body )
        return
    end if

    '' #macro ... #endmacro: the body runs to a '#endmacro' directive line.
    SkipToEol( e )
    do
        dim as Token u
        if PeekTok( e, u ) = false then
            Report( e, FBX0311, at )
            exit do
        end if

        dim as boolean atLineStart = (u.flags and TF_AT_LINE_START) <> 0
        if (Tk( u ) = TK_HASH) andalso atLineStart then
            '' Look at the word after '#' without consuming it unless it matches.
            dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
            dim as long save = f->pos
            Advance( e )
            dim as Token w
            dim as boolean isEnd = false
            if PeekOnLine( e, w ) then
                dim as string word = ""
                if Tk( w ) = TK_IDENT then
                    word = e.names->Spelling( cast( InternId, w.literal ) )
                else
                    word = Text.LowerAscii( TokenKindText( Tk( w ) ) )
                end if
                isEnd = (word = "endmacro")
            end if
            if isEnd then
                SkipToEol( e )
                exit do
            end if
            f->pos = save
        end if

        m->body.Push( u )
        Advance( e )
    loop
end sub

private sub PpUndef( byref e as PpEngine, byval at as SourceLoc )
    dim as Token t
    if PeekOnLine( e, t ) = false then
        Report( e, FBX0316, at, "undef" )
        return
    end if
    if Tk( t ) = TK_IDENT then
        dim as PpMacro ptr m = MacroFor( e, cast( InternId, t.literal ) )
        if m <> 0 then m->isDefined = false
    end if
    SkipToEol( e )
end sub

'' ------------------------------------------------------------------- expansion

type ArgList
    as FB.Array( of long ) firsts    '' index into flat
    as FB.Array( of long ) counts
    as TokenVec            flat
end type

'' Read '( a, b )' from the input, honouring nesting and string literals. Returns
'' false when the invocation is unterminated, which is an error, not a silent stop.
private function PpReadArgs _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref args as ArgList ) as boolean

    dim as Token t
    if PeekTok( e, t ) = false then return false
    if Tk( t ) <> TK_LPAREN then return false
    Advance( e )

    dim as long depth = 1
    dim as long first = 0
    dim as long count = 0
    dim as boolean started = false

    do
        if PeekTok( e, t ) = false then
            Report( e, FBX0307, m->loc, e.names->Spelling( m->name ) )
            return false
        end if

        dim as TokenKind k = Tk( t )
        if k = TK_EOF then
            Report( e, FBX0307, m->loc, e.names->Spelling( m->name ) )
            return false
        end if

        if k = TK_LPAREN then
            depth += 1
        elseif k = TK_RPAREN then
            depth -= 1
            if depth = 0 then
                Advance( e )
                exit do
            end if
        elseif (k = TK_COMMA) andalso (depth = 1) then
            '' A variadic macro's last parameter swallows the remaining commas.
            dim as boolean lastIsVariadic = m->isVariadic andalso _
                                            (args.firsts.Count >= m->params.Count)
            if lastIsVariadic = false then
                args.firsts.Push( first )
                args.counts.Push( count )
                Advance( e )
                first = args.flat.Count
                count = 0
                started = true
                continue do
            end if
        end if

        if started = false then
            first = args.flat.Count
            started = true
        end if
        args.flat.Push( t )
        count += 1
        Advance( e )
    loop

    if started orelse (m->params.Count > 0) then
        args.firsts.Push( first )
        args.counts.Push( count )
    end if
    return true
end function

private function ArgIndexOf( byval m as PpMacro ptr, byval id as InternId ) as long
    for i as long = 0 to m->params.Count - 1
        if cast( InternId, m->params[i] ) = id then return i
    next
    return -1
end function

private function ArgText _
    ( byref e as PpEngine, byref args as ArgList, byval idx as long ) as string

    if (idx < 0) orelse (idx >= args.firsts.Count) then return ""
    dim as string s = ""
    dim as long first = args.firsts[idx]
    for i as long = 0 to args.counts[idx] - 1
        dim as Token t = args.flat[first + i]
        dim as boolean sep = ((t.flags and TF_SPACE_BEFORE) <> 0) andalso (i > 0)
        if sep then s += " "
        s += SpellOf( e, t )
    next
    return s
end function

'' Substitute parameters into the body, handling '#' stringise and '##' paste.
private sub PpSubstitute _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref args as ArgList, _
      byval useLoc as SourceLoc, byref outv as TokenVec )

    dim as long i = 0
    while i < m->body.Count
        dim as Token bt = m->body[i]
        dim as TokenKind bk = Tk( bt )

        '' The operand of 'defined' is NOT parameter-substituted. Verified against
        '' fbc: with '#define YES 1' and '#macro M( s ) : #if defined( s )', both
        '' 'M( YES )' and 'M( NOPE )' report NOT defined -- the operand is taken
        '' literally, as the identifier written in the body. The corpus test
        '' pp/defined-udt.bas compiles only because of this.
        dim as boolean isDefined = (bk = KW_DEFINED)
        if bk = TK_IDENT then
            isDefined = (e.names->Spelling( cast( InternId, bt.literal ) ) = "defined")
        end if
        if isDefined then
            bt.flags or= TF_FROM_MACRO
            outv.Push( bt )
            i += 1
            '' Copy an optional '(' and the operand verbatim, whatever they are.
            if (i < m->body.Count) andalso (Tk( m->body[i] ) = TK_LPAREN) then
                dim as Token lp = m->body[i]
                lp.flags or= TF_FROM_MACRO
                outv.Push( lp )
                i += 1
            end if
            if i < m->body.Count then
                dim as Token op = m->body[i]
                op.flags or= TF_FROM_MACRO
                outv.Push( op )
                i += 1
            end if
            continue while
        end if

        '' '#param' -> a string literal holding the argument's source text.
        if bk = TK_HASH then
            dim as boolean haveNext = (i + 1 < m->body.Count)
            if haveNext then
                dim as Token nt = m->body[i + 1]
                if Tk( nt ) = TK_IDENT then
                    dim as long ai = ArgIndexOf( m, cast( InternId, nt.literal ) )
                    if ai >= 0 then
                        RelexInto( e, """" & ArgText( e, args, ai ) & """", useLoc, outv )
                        i += 2
                        continue while
                    end if
                end if
            end if
        end if

        '' 'a##b' -> paste the two spellings and re-lex the result.
        dim as boolean pasteNext = false
        if i + 1 < m->body.Count then
            pasteNext = (Tk( m->body[i + 1] ) = TK_HASH) andalso _
                        (i + 2 < m->body.Count) andalso _
                        (Tk( m->body[i + 2] ) = TK_HASH)
        end if
        if pasteNext then
            dim as string lhs = ""
            if bk = TK_IDENT then
                dim as long ai = ArgIndexOf( m, cast( InternId, bt.literal ) )
                if ai >= 0 then lhs = ArgText( e, args, ai ) else lhs = SpellOf( e, bt )
            else
                lhs = SpellOf( e, bt )
            end if

            dim as string rhs = ""
            if i + 3 < m->body.Count then
                dim as Token rt = m->body[i + 3]
                if Tk( rt ) = TK_IDENT then
                    dim as long ai = ArgIndexOf( m, cast( InternId, rt.literal ) )
                    if ai >= 0 then rhs = ArgText( e, args, ai ) else rhs = SpellOf( e, rt )
                else
                    rhs = SpellOf( e, rt )
                end if
            end if

            RelexInto( e, lhs & rhs, useLoc, outv )
            i += 4
            continue while
        end if

        '' A plain parameter reference splices the argument's tokens.
        if bk = TK_IDENT then
            dim as long ai = ArgIndexOf( m, cast( InternId, bt.literal ) )
            if ai >= 0 then
                if ai < args.firsts.Count then
                    dim as long first = args.firsts[ai]
                    for j as long = 0 to args.counts[ai] - 1
                        dim as Token at = args.flat[first + j]
                        at.flags or= TF_FROM_MACRO
                        outv.Push( at )
                    next
                end if
                i += 1
                continue while
            end if
        end if

        bt.flags or= TF_FROM_MACRO
        outv.Push( bt )
        i += 1
    wend
end sub

declare function PpExpandBuiltin _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean

'' Expand the macro named by 'use'. Returns true when it consumed the name.
private function PpExpand _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean

    if m->builtin <> PPB_NONE then return PpExpandBuiltin( e, m, use )

    '' A function-like macro not followed by '(' is just an identifier, as in C.
    if m->isFunc then
        dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
        dim as long save = f->pos
        Advance( e )

        dim as Token nxt
        dim as boolean haveParen = PeekTok( e, nxt ) andalso (Tk( nxt ) = TK_LPAREN)
        if haveParen = false then
            f->pos = save
            return false
        end if

        dim as ArgList args
        if PpReadArgs( e, m, args ) = false then return true

        dim as long want = m->params.Count
        dim as long got = args.firsts.Count
        dim as boolean countOk = (got = want) orelse (m->isVariadic andalso (got >= want))
        if countOk = false then
            Report( e, FBX0306, use.loc, e.names->Spelling( m->name ), str( want ) )
            return true
        end if

        dim as TokenVec ptr buf = new TokenVec
        PpSubstitute( e, m, args, use.loc, *buf )
        e.outp->expansionCount += 1
        PushFrame( e, buf, m->name, FILE_NONE, true )
        return true
    end if

    Advance( e )
    dim as TokenVec ptr buf = new TokenVec
    dim as ArgList empty
    PpSubstitute( e, m, empty, use.loc, *buf )
    e.outp->expansionCount += 1
    PushFrame( e, buf, m->name, FILE_NONE, true )
    return true
end function

'' -------------------------------------------------------------------- builtins

function PpExpandBuiltin _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean

    Advance( e )

    dim as DecodedLoc d = e.src->Decode( use.loc )
    dim as TokenVec ptr buf = new TokenVec

    select case as const m->builtin
    case PPB_LINE
        RelexInto( e, str( d.lineNo ), use.loc, *buf )

    case PPB_FILE
        RelexInto( e, """" & e.src->PathOf( d.file ) & """", use.loc, *buf )

    case PPB_FILE_NQ, PPB_PATH
        RelexInto( e, e.src->PathOf( d.file ), use.loc, *buf )

    case PPB_DATE
        RelexInto( e, """" & date( ) & """", use.loc, *buf )

    case PPB_TIME
        RelexInto( e, """" & time( ) & """", use.loc, *buf )

    case PPB_UNIQUEID
        '' A fresh identifier per use. Deterministic: it counts uses, nothing else.
        dim as ArgList args
        PpReadArgs( e, m, args )
        e.uniqueCounter += 1
        RelexInto( e, "__fbx_uid_" & e.uniqueCounter, use.loc, *buf )

    case PPB_QUOTE
        '' The whole point of the lexer keeping (loc, length) on every token: the
        '' argument's exact source bytes are recoverable, including non-ASCII ones
        '' that could never be an identifier (probe L9).
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            RelexInto( e, """" & ArgText( e, args, 0 ) & """", use.loc, *buf )
        end if

    case PPB_UNQUOTE
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as string s = ArgText( e, args, 0 )
            dim as long a = instr( s, """" )
            dim as long b = instrrev( s, """" )
            if (a > 0) andalso (b > a) then s = mid( s, a + 1, b - a - 1 )
            RelexInto( e, s, use.loc, *buf )
        end if

    case PPB_ARG_COUNT
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as long n = args.firsts.Count
            if (n = 1) andalso (args.counts[0] = 0) then n = 0
            RelexInto( e, str( n ), use.loc, *buf )
        end if

    case PPB_JOIN
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as string s = ""
            for i as long = 0 to args.firsts.Count - 1
                s += ArgText( e, args, i )
            next
            RelexInto( e, s, use.loc, *buf )
        end if

    case else
        Report( e, FBX0314, use.loc, e.names->Spelling( m->name ) )
    end select

    if buf->IsEmpty( ) then
        delete buf
        return true
    end if
    e.outp->expansionCount += 1
    PushFrame( e, buf, m->name, FILE_NONE, true )
    return true
end function

end namespace

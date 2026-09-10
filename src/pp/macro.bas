'' macro.bas -- macro definition, argument binding and expansion.  Included by pp.bas.
''
'' Expansion pushes a FRAME rather than splicing into the input, which is what makes
'' hide sets free: the macro is hidden exactly while its frame is on the stack, and
'' rescanning happens naturally because the main loop reads from the top frame.

namespace Tko

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

'' Shared by #define and #macro: read '( a, b, ... )'.
''
'' The whitespace rule is NOT shared, which is measured rather than assumed:
''
''     #define m (a) a+1      object-like, body '(a) a+1'   -- the C rule
''     #macro m ( a )         a PARAMETER list, space and all
''
'' so '#macro t ? ( n, stmt... )' -- which the corpus writes -- takes two arguments.
'' THE NAME A MACRO PARAMETER IS DECLARED OR REFERENCED BY, or 0 when the token is not
'' a name at all. A KEYWORD counts: '#macro M( T, WIDTH, MASKALL )' is what fb/mathint.bi
'' writes, and WIDTH is the WIDTH statement. Measured -- fbc accepts it and substitutes
'' it like any other parameter.
''
'' Only the DECLARATION was rejected, so the macro was recorded as taking TWO parameters
'' and every use of it reported 'takes 2 argument(s)'. That is one file's whole header
'' failing to parse, and with it every test written against the module.
''
'' The keyword's own lowercase spelling is interned, which is what PpDefine already does
'' for a macro NAMED after a keyword -- both sides have to agree or the reference in the
'' body would not match the parameter in the list.
private function ParamNameId_ _
    ( byref e as PpEngine, byref t as Token ) as InternId

    if Tk( t ) = TK_IDENT then return cast( InternId, t.literal )
    if IsKeywordKind( Tk( t ) ) then
        return e.names->GetString( Text.LowerAscii( TokenKindText( Tk( t ) ) ) )
    end if
    return 0
end function

private sub PpReadParams( byref e as PpEngine, byval m as PpMacro ptr, byval isBlock as boolean )
    dim as Token t
    if PeekOnLine( e, t ) = false then return

    if Tk( t ) <> TK_LPAREN then return
    if (isBlock = false) andalso ((t.flags and TF_SPACE_BEFORE) <> 0) then return

    m->isFunc = true
    Advance( e )

    do
        if PeekOnLine( e, t ) = false then exit do
        if Tk( t ) = TK_RPAREN then
            Advance( e )
            exit do
        end if

        dim as InternId pn = ParamNameId_( e, t )
        if (pn <> 0) andalso (Tk( t ) <> TK_ELLIPSIS) then
            m->params.Push( cast( ulong, pn ) )
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

'' Is this redefinition the same as the one before it? Only an OBJECT-LIKE macro may
'' be redefined at all, and only with the same tokens. Whitespace is not compared --
'' 'X   _Y' and 'X _Y' are the same macro, measured.
private function IdenticalRedefinition_ _
    ( byval m as PpMacro ptr, byval oldIsFunc as boolean, _
      byref oldBody as TokenVec ) as boolean

    if m->isFunc orelse oldIsFunc then return false
    if m->body.Count <> oldBody.Count then return false
    for i as long = 0 to m->body.Count - 1
        if m->body[i].kind <> oldBody[i].kind then return false
        if m->body[i].literal <> oldBody[i].literal then return false
    next
    return true
end function

private sub PpDefine( byref e as PpEngine, byval at as SourceLoc, byval isBlock as boolean )
    dim as Token t
    if PeekOnLine( e, t ) = false then
        Report( e, TKO0316, at, iif( isBlock, "macro", "define" ) )
        return
    end if
    if Tk( t ) <> TK_IDENT then
        '' Redefining a keyword is legal in FreeBASIC and the corpus does it.
        if IsKeywordKind( Tk( t ) ) = false then
            Report( e, TKO0316, t.loc, iif( isBlock, "macro", "define" ) )
            SkipToEol( e )
            return
        end if
    end if

    dim as InternId id = cast( InternId, t.literal )
    if Tk( t ) <> TK_IDENT then
        id = e.names->GetString( Text.LowerAscii( TokenKindText( Tk( t ) ) ) )
    end if
    Advance( e )

    '' A '?' directly after the name marks the macro as callable WITHOUT parentheses.
    '' It must be consumed before the parameter list, or the '(' that follows is never
    '' seen and the macro is defined as object-like with its parameters left as body
    '' tokens -- which is what happened: 'NAME x' failed and 'NAME( x )' expanded without
    '' substituting anything.
    dim as boolean optParens = false
    dim as Token qt
    if PeekOnLine( e, qt ) then
        if Tk( qt ) = TK_QUESTION then
            optParens = true
            Advance( e )
        end if
    end if

    dim as PpMacro ptr m = PpFindOrAddMacro( e, id )

    '' An OBJECT-LIKE macro may be redefined with an IDENTICAL token sequence; a
    '' FUNCTION-LIKE one may not be redefined at all. Measured, and neither half is
    '' obvious -- C allows the identical redefinition for both:
    ''
    ''     #define X _Y   twice           accepted
    ''     #define X _Y then #define X _Z  error 4
    ''     #define F(a) a twice           error 4
    ''     #define X   _Y then #define X _Y  accepted -- TOKENS, not text
    ''
    '' 29 corpus files failed on this one rule: windows.bi defines
    '' InterlockedIncrement in winnt.bi and again in winbase.bi, both under
    '' '#ifdef __FB_64BIT__', both genuinely active on win64. It looked for a long
    '' time like a conditional-stack bug -- the two definitions sit under mutually
    '' exclusive-LOOKING guards 1,500 lines apart -- and it was not one. A probe
    '' inserted at the first definition proved tiko-lang knew the target was 64-bit there.
    dim as boolean wasDefined = m->isDefined
    '' ...EXCEPT OVER TRUE AND FALSE, WHICH MAY BE REDEFINED FREELY. fbc marks both
    '' consts symbSetCanRedef (symb-keyword.bas) and answers a '#define TRUE 1' with
    '' 'warning 39(1): Redefinition of intrinsic' -- measured -- not an error, and the
    '' new value then wins: 'print TRUE' is 1 and '#if TRUE' is still taken. Headers
    '' write that unguarded, so reporting TKO0305 here would fail every one of them,
    '' which is what defining the pair in the first place did until this line.
    dim as boolean wasRedefinable = (m->builtin = PPB_SELF)
    dim as boolean oldIsFunc = m->isFunc
    dim as TokenVec oldBody
    if wasDefined then
        for i as long = 0 to m->body.Count - 1
            oldBody.Push( m->body[i] )
        next
    end if

    m->isDefined = true
    m->isFunc = false
    m->isVariadic = false
    m->optParens = optParens
    '' Where it was defined, so the block that closes takes it with it.
    m->blockDepth = e.blockDepth
    m->builtin = PPB_NONE
    m->loc = at
    m->params.Clear( )
    m->body.Clear( )

    PpReadParams( e, m, isBlock )

    if isBlock = false then
        CollectLine( e, m->body, true )
        if wasDefined andalso (wasRedefinable = false) then
            if IdenticalRedefinition_( m, oldIsFunc, oldBody ) = false then
                Report( e, TKO0305, at, e.names->Spelling( id ) )
            end if
        end if
        return
    end if

    '' #macro ... #endmacro: the body runs to a '#endmacro' directive line.
    ''
    '' ...WHICH STARTS ON THE NEXT PHYSICAL LINE, whatever the header ends with. A
    '' trailing '_' on the header is not a continuation into the body -- measured, fbc
    '' runs
    ''
    ''     #macro case_T(T) _
    ''     case sizeof(T)
    ''         CU_ASSERT_EQUAL( cva_arg( p, T ), i )
    ''     #endmacro
    ''
    '' with the case line as the BODY's first line, and 'm( a ) _' over a single
    '' 'print a' prints, so the body cannot have been swallowed either. SkipToEol
    '' stops at an EOL and a continuation REMOVES the EOL, so the first body line went
    '' into the header and vanished: every 'case_T( byte )' expanded to the assert with
    '' no CASE in front of it, which is 'expected end SELECT' and then a parse desync
    '' that unbound the enclosing procedure's name. functions/var_args-gcc.bas, and
    '' fbcunit.bi's own CU_ASSERT_EQUAL landing after the vanished case.
    ''
    '' A continuation INSIDE the parameter list is untouched -- PpReadParams has
    '' already consumed those, and fbc accepts '#macro m( a, _' with 'b )' below it.
    SkipMacroHeader_( e )
    do
        dim as Token u
        if PeekTok( e, u ) = false then
            Report( e, TKO0311, at )
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

    '' THE BODY HAS NO EOL AT EITHER END. The capture pushes every token between the
    '' '#macro NAME( params )' line and the '#endmacro' line, and that run BEGINS with
    '' the header line's own end-of-line and ENDS with the last body line's -- two
    '' tokens fbc's model does not have.
    ''
    '' Measured with 'fbc -pp'. A one-line body used in EXPRESSION position --
    '' 's = m( 5 )' over '#macro m( a ) / a + 1 / #endmacro' -- is 's = 5 + 1' on ONE
    '' line, and tiko-lang put the header's EOL between 's =' and the body: the
    '' statement split in two, the assignment got no value, and every '#macro' called
    '' from inside an expression declined. A '#define' with the same body was right all
    '' along, which is what made it look like a macro-expansion problem rather than a
    '' capture one.
    ''
    '' Both ends trim a RUN, not one token: measured, a body with two leading and three
    '' trailing blank lines loses all five. An EOL strictly INSIDE the run stays --
    '' 'print 5 / (blank) / print 5 + 1' keeps its blank line -- so this trims only the
    '' ends, and a body of nothing but EOLs becomes genuinely empty, which is what
    '' 'print 1 : m( ) : print 2' shows fbc doing.
    ''
    '' One program changes direction: a body whose FIRST line is a preprocessor
    '' directive, invoked after a ':', becomes an error. fbc errors on it too.
    dim as long lead = 0
    while lead < m->body.Count
        if Tk( m->body[lead] ) <> TK_EOL then exit while
        lead += 1
    wend
    if lead > 0 then
        for i as long = lead to m->body.Count - 1
            m->body[i - lead] = m->body[i]
        next
        for i as long = 1 to lead
            m->body.Pop( )
        next
    end if
    '' THE TRAILING RUN IS LEFT ALONE, and that is a MEASURED DIVERGENCE rather than an
    '' oversight. fbc's model has no end-of-line there either -- 'm( 5 ) : print "x"'
    '' over a two-line body puts the last body line and the 'print' on ONE line -- but
    '' trimming it here cost 830 corpus declines against the 4 the leading trim buys.
    ''
    '' __FB_ARG_LISTEXPAND__ synthesises 'M( 1 ) : M( 2 ) : M( 3 )' as TEXT and relies on
    '' each expansion ending where it does; without the trailing end-of-line the
    '' repetitions run together and 'const n' inside the body is declared twice in one
    '' scope. pp/macro-arg-listexpand.bas went from 0 declines to 415.
    ''
    '' The leading trim is what the two broken shapes needed; this one is only about
    '' matching fbc's token layout exactly, and it is not worth that.
    ''
    '' AND A THIRD TIME, 2026-08-28, with a NARROWER rule: trim only where the
    '' invocation sits in the MIDDLE OF AN EXPRESSION -- not at a line start and
    '' not after a ':' -- which is the only place the kept end-of-line is wrong.
    '' It fixes exactly what it was meant to:
    ''
    ''   #macro h( ) / "hello" / #endmacro   s = h( ) + "x"   -> "hellox"
    ''
    '' -- fbc compiles that, and an INTERIOR newline is genuinely a statement
    '' break there too ('s = two( )' over a two-line body is fbc error 119). It
    '' STILL BREAKS __FB_ARG_LISTEXPAND__: tests/mir/arg-listexpand's golden --
    '' verified against fbc's own C, F(5,1,5) F(3,3,5) F(1,5,5) -- comes out with
    '' the arguments re-associated. So the dependency is INSIDE an expansion, not
    '' at its call site, and neither the line-start nor the ':' test can see it.
    '' Reverted. Whatever depends on this, find it before a fourth attempt.

    '' RE-MEASURED 2026-08-26, because __FB_ARG_LISTEXPAND__ now writes the ' : '
    '' between its repetitions itself and the old reason looked spent. It is not: the
    '' pp corpus went from 77 declines to 900 and five preprocessor goldens changed.
    '' Whatever else depends on the trailing end-of-line, it is not only LISTEXPAND --
    '' find out what before trying this a third time.
end sub

private sub PpUndef( byref e as PpEngine, byval at as SourceLoc )
    dim as Token t
    if PeekOnLine( e, t ) = false then
        Report( e, TKO0316, at, "undef" )
        return
    end if
    if Tk( t ) = TK_IDENT then
        dim as PpMacro ptr m = MacroFor( e, cast( InternId, t.literal ) )
        if m <> 0 then m->isDefined = false
    elseif IsKeywordKind( Tk( t ) ) then
        '' '#undef short'. fbc keeps keywords in the symbol table, so undefining one
        '' removes the reserved word itself; here that is a de-reservation applied to
        '' every token that leaves the preprocessor from now on. A keyword can never
        '' also be a macro -- '#define short 5' is fbc's error 4 -- so there is no
        '' order to get wrong. See DereserveKw_ in pp.bas for the measurements.
        DereserveKw_( e, Tk( t ) )
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
    ( byref e as PpEngine, byval m as PpMacro ptr, byref args as ArgList, _
      byval bare as boolean = false ) as boolean

    '' 'bare' is the parenthesis-less form a '#macro NAME?( a )' allows: the arguments
    '' run to the END OF LINE instead of to a closing paren, and a comma separates them
    '' at nesting depth zero rather than one.
    dim as Token t
    if bare = false then
        if PeekTok( e, t ) = false then return false
        if Tk( t ) <> TK_LPAREN then return false
        Advance( e )
    end if

    dim as long depth = iif( bare, 0, 1 )
    '' COMMAS THAT BELONG TO A NESTED PARENTHESIS-LESS MACRO ARE NOT SEPARATORS.
    ''
    ''     foo( bar 1, 2, 3, baz( 4, 5, 6 ) )
    ''
    '' -- 'bar' is a '#macro bar?( a, b, c )', so it takes '1, 2, 3' and the whole
    '' thing is TWO arguments to foo, not four. Splitting on every comma at the
    '' separator depth reported "macro 'foo' takes 2 argument(s)" and lost the
    '' statement. fbc accepts all six spellings and prints the same string for each.
    ''
    '' A VARIADIC one is not counted: how many commas it claims is not knowable
    '' from its declaration, so those keep splitting as they did.
    dim as long pendingCommas = 0
    dim as long first = 0
    dim as long count = 0
    dim as boolean started = false

    do
        if PeekTok( e, t ) = false then
            Report( e, TKO0307, m->loc, e.names->Spelling( m->name ) )
            return false
        end if

        dim as TokenKind k = Tk( t )
        if k = TK_EOF then
            '' Running out of tokens is only an error for the parenthesised form; the
            '' bare form is simply finished.
            if bare then exit do
            Report( e, TKO0307, m->loc, e.names->Spelling( m->name ) )
            return false
        end if
        if bare andalso (k = TK_EOL) then exit do

        if k = TK_LPAREN then
            depth += 1
        elseif k = TK_RPAREN then
            depth -= 1
            '' ONLY THE PARENTHESISED FORM ENDS AT A ')'. The bare form starts at
            '' depth 0, so the ')' closing a nested parenthesised argument --
            '' 'foo bar( 1, 2, 3 ), baz( 4, 5, 6 )' -- brought depth back to 0 and
            '' ended the invocation there, one argument in.
            if (depth = 0) andalso (bare = false) then
                Advance( e )
                exit do
            end if
        elseif (k = TK_COMMA) andalso (depth = iif( bare, 0, 1 )) then
            '' A variadic macro's last parameter swallows the remaining commas.
            '' 'a, rest...' is two parameters, so the swallow starts once the
            '' argument being collected IS the last one -- one earlier than the
            '' count of parameters.
            dim as boolean lastIsVariadic = m->isVariadic andalso _
                                            (args.firsts.Count >= m->params.Count - 1)
            if pendingCommas > 0 then
                '' A nested bare macro's own separator: part of THIS argument.
                pendingCommas -= 1
            elseif lastIsVariadic = false then
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
        '' ...and if that was a bare invocation of a parenthesis-less macro, the
        '' commas it is about to claim belong to it. Checked AFTER the advance,
        '' because deciding needs the token that follows the name.
        if k = TK_IDENT then
            dim as PpMacro ptr im = MacroFor( e, cast( InternId, t.literal ) )
            if im <> 0 then
                dim as boolean claims = im->isFunc andalso im->optParens
                if claims then claims = (im->isVariadic = false)
                if claims then claims = (im->params.Count > 1)
                if claims then
                    dim as Token nx
                    dim as boolean lp = PeekTok( e, nx )
                    if lp then lp = (Tk( nx ) = TK_LPAREN)
                    if lp = false then
                        pendingCommas += im->params.Count - 1
                    end if
                end if
            end if
        end if
    loop

    if started orelse (m->params.Count > 0) then
        args.firsts.Push( first )
        args.counts.Push( count )
    end if
    return true
end function

'' ONE ARGUMENT'S TOKENS, MACRO-EXPANDED, then folded to a VALUE -- number or string.
''
'' The same walk BuiltinIntArg_ does; it throws a string away, which is right for the
'' builtins that want a count and wrong for __FB_EVAL__, which wants whichever the
'' expression turned out to be.
private function BuiltinValueArg_ _
    ( byref e as PpEngine, byref args as ArgList, byval idx as long, _
      byref ok as boolean ) as PpValue

    dim as PpValue empty_
    ok = false
    if (idx < 0) orelse (idx >= args.firsts.Count) then return empty_

    dim as TokenVec ptr raw = new TokenVec
    dim as long first = args.firsts[idx]
    for i as long = 0 to args.counts[idx] - 1
        raw->Push( args.flat[first + i] )
    next

    dim as long baseDepth = e.frames.Count
    dim as long savedFloor = e.frameFloor
    e.frameFloor = baseDepth
    PushFrame( e, raw, INTERN_NONE, FILE_NONE, true )

    dim as TokenVec expanded
    dim as long guard = 0
    do
        guard += 1
        if guard > 100000 then exit do
        if e.frames.Count <= baseDepth then exit do
        dim as Token t
        if PeekTok( e, t ) = false then exit do
        if e.frames.Count <= baseDepth then exit do
        if Tk( t ) = TK_IDENT then
            dim as InternId id = cast( InternId, t.literal )
            dim as PpMacro ptr mm = MacroFor( e, id )
            if (mm <> 0) andalso (IsHidden( e, id ) = false) then
                if PpExpand( e, mm, t ) then continue do
            end if
        end if
        Advance( e )
        expanded.Push( t )
    loop
    e.frameFloor = savedFloor
    while e.frames.Count > baseDepth
        PopFrame( e )
    wend

    return PpEvalValueTokens( e, expanded, ok )
end function

'' A FOLDED VALUE, RE-EMITTED AS A CANONICAL LITERAL -- what __FB_EVAL__ produces.
''
'' Measured against fbc, and the rule is exactly three cases:
''
''   a WIDE result            !"\uXXXX" per character, four UPPERCASE hex digits
''   a narrow result WITH a NUL   !"\xNN" per byte
''   any other narrow result  $"..." with the bytes VERBATIM and nothing escaped
''
'' An integer is plain decimal, whatever radix it was written in: '&hFF' is '255'.
''
'' ONLY THE THIRD CASE IS PRODUCED HERE, and the other two DECLINE rather than being
'' approximated. Both need the literal's escapes DECODED and its narrow/wide flavour
'' known, and the preprocessor reads a raw source span: it has neither. Emitting the
'' undecoded bytes would be a different string with nothing to say so.
''
'' A QUOTE IN THE RESULT IS EMITTED RAW, and that is not a defect to route around --
'' it is the only way the corpus's own idiom works. pp/macro-eval.bas assigns a STRING
'' through a macro:
''
''     #define tmp __FB_EVAL__( expr )
''     __FB_UNQUOTE__( __FB_EVAL__( "#define " + sym + " " + __FB_QUOTE__( tmp ) ) )
''     assign( "x", "hello" )
''
'' and every step of that was measured with 'fbc64 -pp':
''
''     __FB_EVAL__( "hello" )                    $"hello"
''     __FB_QUOTE__( tmp )                       $"$""hello"""
''     __FB_EVAL__( "#define x " + that )        $"#define x $"hello""
''
'' -- the last one holds two INNER quotes and fbc writes them raw. Declining there
'' left 'x' undefined, so 'CU_ASSERT_EQUAL( x, "hello" )' reached lowering with a bare
'' identifier for an argument and the call declined at lowercall.bas:875.
''
'' The broken-relex worry is real but it is fbc's own: measured, 'dim s as string =
'' __FB_EVAL__( "A" + chr(34) + "B" )' is error 3 plus warning 12 in fbc too. Where
'' the result feeds __FB_UNQUOTE__ -- which is what the idiom does -- the three tokens
'' it relexes into rejoin, spacing and all, into the text UNQUOTE wanted.
''
'' A NEWLINE STILL DECLINES. fbc emits CR/LF raw as well ('__FB_EVAL__( "A" + chr(10)
'' + "B" )' is two warning 12s and error 42), so BOTH compilers reject that program;
'' the difference is only which diagnostic, and relexing a literal that spans a line
'' break is not a shape this buffer models.
private function EvalLiteral_ _
    ( byref v as PpValue, byref ok as boolean ) as string

    ok = true
    if v.isStr = false then return str( v.num )
    '' A WIDE RESULT IS STILL REFUSED. It re-emits as '!"\uXXXX"' per character,
    '' four UPPERCASE hex digits -- measured, __FB_EVAL__( wstr("A") ) is
    '' '\u0041' -- and the preprocessor has no wide value to render.
    '' A WIDE RESULT IS '!"\uXXXX"' PER CHARACTER, four UPPERCASE hex digits.
    '' Measured, one probe per shape:
    ''
    ''   wstr( "A" )                        \u0041
    ''   wstr( "A" ) + wstr( "B" )           \u0041\u0042
    ''   wstr( "A" ) + wstr( !"\0" )         \u0041\u0000
    ''   wstr( !"\\" ) three times          \u005C\u005C\u005C
    ''
    '' ASCII ONLY. The preprocessor holds the value as BYTES, and above 127 a
    '' byte is not a code unit -- the source encoding decides what it is, and
    '' emitting it as one would put a different character in the literal. That
    '' case declines, as the whole wide family did before this.
    if v.wide then
        if v.escaped then
            ok = false
            return ""
        end if
        for i as long = 1 to len( v.str_ )
            if asc( mid( v.str_, i, 1 ) ) > 127 then
                ok = false
                return ""
            end if
        next
        dim as string w = "!" & chr( 34 )
        for i as long = 1 to len( v.str_ )
            w += "\u" & Tko.Text.UpperAscii( hex( asc( mid( v.str_, i, 1 ) ), 4 ) )
        next
        return w & chr( 34 )
    end if
    if v.escaped then
        ok = false
        return ""
    end if
    '' A NUL ANYWHERE MAKES IT THE HEX FORM, every byte of it. Measured:
    '' __FB_EVAL__( "A" + !"\0" ) is '\x41\x00' and not a truncated "A" -- the NUL
    '' that ends a literal at RUNTIME does not end this one.
    dim as boolean hasNul = false
    for i as long = 1 to len( v.str_ )
        if asc( mid( v.str_, i, 1 ) ) = 0 then
            hasNul = true
            exit for
        end if
    next
    if hasNul then
        dim as string h = "!" & chr( 34 )
        for i as long = 1 to len( v.str_ )
            '' ONE backslash: a plain FreeBASIC literal processes no escapes, so
            '' the doubled spelling emitted the text of an escape rather than one.
            h += "\x" & Tko.Text.UpperAscii( hex( asc( mid( v.str_, i, 1 ) ), 2 ) )
        next
        return h & chr( 34 )
    end if
    '' A NEWLINE IN THE RESULT DECLINES -- see the header: fbc emits it raw and errors
    '' on its own output, and a literal spanning a line break is not modelled here.
    '' A QUOTE DOES NOT: it goes out raw, exactly as fbc writes it, because
    '' '__FB_UNQUOTE__( __FB_EVAL__( ... __FB_QUOTE__( tmp ) ) )' cannot work otherwise.
    '' A TAB is fine and is emitted raw, which is what fbc does with it.
    for i as long = 1 to len( v.str_ )
        dim as long ch = asc( mid( v.str_, i, 1 ) )
        if (ch = 10) orelse (ch = 13) then
            ok = false
            return ""
        end if
    next
    return "$" & chr( 34 ) & v.str_ & chr( 34 )
end function

'' ONE ARGUMENT'S TOKENS, MACRO-EXPANDED, as text.
''
'' Split out of BuiltinIntArg_, which did the same walk and then read an integer.
private function ExpandedArgText_ _
    ( byref e as PpEngine, byref args as ArgList, byval idx as long ) as string

    if (idx < 0) orelse (idx >= args.firsts.Count) then return ""

    dim as TokenVec ptr raw = new TokenVec
    dim as long first = args.firsts[idx]
    for i as long = 0 to args.counts[idx] - 1
        raw->Push( args.flat[first + i] )
    next

    dim as long baseDepth = e.frames.Count
    '' THE FRAMES BELOW THIS ONE ARE NOT THIS WALK'S TO POP. See PpEngine.frameFloor:
    '' without it a nested builtin whose ')' ends the enclosing frame took that frame
    '' and the macro body's with it, and its own result then landed below this walk.
    dim as long savedFloor = e.frameFloor
    e.frameFloor = baseDepth
    PushFrame( e, raw, INTERN_NONE, FILE_NONE, true )

    dim as string outp = ""
    dim as long n = 0
    '' THE FIRST TOKEN AN EXPANSION PRODUCES TAKES THE SPACING OF THE NAME THAT
    '' TRIGGERED IT, not its own. A macro's body begins after the space separating it
    '' from the name in the '#define', so that space sits on its first body token --
    '' and emitting it put one where the source had none:
    ''
    ''   #define A 1 : #define C   A+A
    ''   '#x' over C   ->   fbc [1+1],   tiko [1+ 1]
    ''
    '' -- the second A expands to a body whose '1' carries the define's space. Measured
    '' against '#define B A + A', which is [1 + 1] in both: the space that survives is
    '' the one at the USE, which is exactly this rule.
    ''
    '' FIRST WINS on a nested expansion: the outer trigger's spacing is what the run
    '' begins with, and an inner macro at the head of that body must not overwrite it.
    dim as boolean pendSet = false
    dim as boolean pendSpace = false
    dim as long guard = 0
    do
        guard += 1
        if guard > 100000 then exit do
        if e.frames.Count <= baseDepth then exit do
        dim as Token t
        if PeekTok( e, t ) = false then exit do
        if e.frames.Count <= baseDepth then exit do
        if Tk( t ) = TK_IDENT then
            dim as InternId id = cast( InternId, t.literal )
            dim as PpMacro ptr mm = MacroFor( e, id )
            if (mm <> 0) andalso (IsHidden( e, id ) = false) then
                dim as boolean trigSpace = ((t.flags and TF_SPACE_BEFORE) <> 0)
                if PpExpand( e, mm, t ) then
                    if pendSet = false then
                        pendSet = true
                        pendSpace = trigSpace
                    end if
                    continue do
                end if
            end if
        end if
        Advance( e )
        dim as boolean spBefore = ((t.flags and TF_SPACE_BEFORE) <> 0)
        if pendSet then
            spBefore = pendSpace
            pendSet = false
        end if
        if spBefore andalso (n > 0) then outp += " "
        outp += SpellOf( e, t )
        n += 1
    loop
    e.frameFloor = savedFloor
    while e.frames.Count > baseDepth
        PopFrame( e )
    wend
    return outp
end function

'' A run of the re-split list, comma-joined.
private function ListJoin_ _
    ( byref lst as FB.Array( of string ), byval from as long, byval upto as long ) as string

    dim as string s = ""
    dim as long last = upto
    if last > lst.Count - 1 then last = lst.Count - 1
    for i as long = from to last
        if i > from then s += ", "
        s += lst[i]
    next
    return s
end function

'' THE ARGUMENTS FROM 'from' ON, EXPANDED AND THEN RE-SPLIT on top-level commas.
''
'' This is what makes the __FB_ARG_* family work at all, and it is not the C rule.
'' Measured, with '#define P 1, 2':
''
''     __FB_ARG_COUNT__( P )            2      not 1
''     __FB_ARG_COUNT__( P, 9 )         3
''     __FB_ARG_EXTRACT__( 0, P, 9 )    1
''     __FB_ARG_EXTRACT__( 2, P, 9 )    9
''     __FB_ARG_LISTEXPAND__( M, 1, P, 9 )   three calls: M(1) M(2) M(9)
''
'' -- so a macro standing in for a LIST contributes every element of it. Splitting on
'' the written commas first, which is what this did, made '__FB_ARG_EXTRACT__( 0, L )'
'' expand to the whole of L and every higher index expand to NOTHING: 52 statements in
'' pp/macro-arg-extract.bas, whose entire subject this is.
'' THE TOKENS ON ONE SIDE OF A NEEDLE. __FB_ARG_LEFTOF__ and __FB_ARG_RIGHTOF__ are
'' the same scan with the two halves swapped, so they are one function.
''
'' Every rule below was measured by reading 'fbc -pp' output, and three of them are not
'' guessable:
''
''   __FB_ARG_LEFTOF__( a b c d, b c )      EMPTY -- a needle of more than ONE token
''                                          never matches, however it is spelled
''   __FB_ARG_LEFTOF__( a b, a, zz )        zz    -- the needle WAS found and the left
''                                          side is empty, and an empty RESULT is what
''                                          reaches for the third argument, not a
''                                          missing needle
''   __FB_ARG_LEFTOF__( , a, zz )           EMPTY -- but an empty TEXT does not, even
''                                          though its result is empty too
''
'' The match is case-insensitive ('1 TO 2' is split by 'to'), and every argument --
'' text, needle and the fallback alike -- is macro-expanded first.
private function SplitAtToken_ _
    ( byref e as PpEngine, byref text_ as string, byref needle as string, _
      byval wantLeft as boolean ) as string

    if len( trim( text_ ) ) = 0 then return ""
    dim as TokenVec tv, nv
    RelexInto( e, text_, LOC_NONE, tv )
    RelexInto( e, needle, LOC_NONE, nv )
    if nv.Count <> 1 then return ""

    dim as string want = Text.LowerAscii( SpellOf( e, nv[0] ) )
    dim as long hit = -1
    for i as long = 0 to tv.Count - 1
        if Text.LowerAscii( SpellOf( e, tv[i] ) ) = want then
            hit = i
            exit for
        end if
    next
    if hit < 0 then return ""

    dim as long lo_ = 0
    dim as long hi_ = hit - 1
    if wantLeft = false then
        lo_ = hit + 1
        hi_ = tv.Count - 1
    end if
    '' Respelled the way ArgText does it, so the spacing that came in comes back out
    '' and a stringize of the result reads as it was written.
    dim as string s = ""
    for i as long = lo_ to hi_
        dim as boolean sep = ((tv[i].flags and TF_SPACE_BEFORE) <> 0) andalso (i > lo_)
        if sep then s += " "
        s += SpellOf( e, tv[i] )
    next
    return s
end function

private sub ExpandedArgList_ _
    ( byref e as PpEngine, byref args as ArgList, byval from as long, _
      byref outp as FB.Array( of string ) )

    dim as string joined = ""
    for i as long = from to args.firsts.Count - 1
        if i > from then joined += ", "
        joined += ExpandedArgText_( e, args, i )
    next

    '' A comma inside PARENTHESES or a STRING LITERAL is not a separator -- the same
    '' rule PpReadArgs follows when it reads the invocation in the first place.
    dim as long depth = 0
    dim as boolean inQuote = false
    dim as string cur = ""
    for i as long = 0 to len( joined ) - 1
        dim as ubyte ch = joined[i]
        if inQuote then
            cur += chr( ch )
            if ch = 34 then inQuote = false
            continue for
        end if
        select case ch
        case 34
            inQuote = true
            cur += chr( ch )
        case 40, 91
            depth += 1
            cur += chr( ch )
        case 41, 93
            depth -= 1
            cur += chr( ch )
        case 44
            if depth = 0 then
                outp.Push( trim( cur ) )
                cur = ""
            else
                cur += chr( ch )
            end if
        case else
            cur += chr( ch )
        end select
    next
    outp.Push( trim( cur ) )
end sub

'' An argument to a builtin macro, MACRO-EXPANDED and then read as an integer.
''
'' The step of a __FB_ARG_LISTEXPAND__ is usually written as a literal, but fbc accepts
'' a macro there -- '#define S 2' then '__FB_ARG_LISTEXPAND__( M, S, ... )' chunks by
'' two. Arguments arrive here UNEXPANDED, because PpReadArgs takes raw tokens off the
'' input, so reading the spelling directly would see 'S' and give up.
''
'' Only a signed integer is accepted, not an expression: every use in the corpus and in
'' the runtime headers is a small literal, and a half-understood expression here would
'' silently chunk the list the wrong way rather than say so.
private function BuiltinIntArg_ _
    ( byref e as PpEngine, byref args as ArgList, byval idx as long, _
      byref ok as boolean ) as longint

    ok = false
    if (idx < 0) orelse (idx >= args.firsts.Count) then return 0

    dim as TokenVec ptr raw = new TokenVec
    dim as long first = args.firsts[idx]
    for i as long = 0 to args.counts[idx] - 1
        raw->Push( args.flat[first + i] )
    next

    dim as long baseDepth = e.frames.Count
    '' THE FRAMES BELOW THIS ONE ARE NOT THIS WALK'S TO POP. See PpEngine.frameFloor:
    '' without it a nested builtin whose ')' ends the enclosing frame took that frame
    '' and the macro body's with it, and its own result then landed below this walk.
    dim as long savedFloor = e.frameFloor
    e.frameFloor = baseDepth
    PushFrame( e, raw, INTERN_NONE, FILE_NONE, true )

    dim as TokenVec expanded
    dim as long guard = 0
    do
        guard += 1
        if guard > 100000 then exit do
        if e.frames.Count <= baseDepth then exit do
        dim as Token t
        if PeekTok( e, t ) = false then exit do
        if e.frames.Count <= baseDepth then exit do
        if Tk( t ) = TK_IDENT then
            dim as InternId id = cast( InternId, t.literal )
            dim as PpMacro ptr mm = MacroFor( e, id )
            if (mm <> 0) andalso (IsHidden( e, id ) = false) then
                if PpExpand( e, mm, t ) then continue do
            end if
        end if
        Advance( e )
        expanded.Push( t )
    loop
    e.frameFloor = savedFloor
    while e.frames.Count > baseDepth
        PopFrame( e )
    wend

    return PpEvalIntTokens( e, expanded, ok )
end function

private function ArgIndexOf( byval m as PpMacro ptr, byval id as InternId ) as long
    for i as long = 0 to m->params.Count - 1
        if cast( InternId, m->params[i] ) = id then return i
    next
    return -1
end function

'' The stringised form of an argument, as fbc spells it. MEASURED:
''
''     #define S(a) #a
''     S( x = "5" )      ->   $"x = ""5"""
''
'' Two things, and the first was missing. A quote INSIDE the argument is DOUBLED, or
'' it closes the literal early -- 'x = "5"' re-lexed as three tokens, "x = " then 5
'' then "", which is why 113 corpus files reported 'expected )' at a fbcunit assert.
''
'' And the literal is '$'-prefixed, i.e. NON-escaped, so a backslash in the argument
'' stays a backslash rather than becoming an escape. That costs nothing today (tiko-lang does
'' not decode escapes yet) and is free to get right now rather than later.
private function Stringised_( byref t as string ) as string
    dim as string r = "$"""
    '' A NEWLINE BECOMES A SPACE. A string literal cannot carry a raw one, so the
    '' result would not re-lex: with the macro bodies written across lines, as the
    '' corpus writes them, a nested __FB_QUOTE__ arrived as
    '' '<EOL>$"1 2 3"<EOL> <EOL>$"4 5 6"<EOL>' and the literal was truncated at the
    '' first one -- 'missing closing quote', and a WRONG STRING beside it. fbc gives
    '' '$"1 2 3" $"4 5 6"', which is the whitespace runs collapsed and trimmed.
    dim as boolean pendSpace = false
    dim as boolean seenAny = false
    for i as long = 0 to len( t ) - 1
        dim as long ch = t[i]
        dim as boolean isWs = (ch = 32) orelse (ch = 9)
        if isWs = false then isWs = (ch = 13) orelse (ch = 10)
        if isWs then
            '' Leading whitespace is dropped rather than turned into a space.
            if seenAny then pendSpace = true
            continue for
        end if
        if pendSpace then
            r += " "
            pendSpace = false
        end if
        seenAny = true
        if ch = 34 then r += """"
        r += chr( ch )
    next
    return r + """"
end function

'' The inverse of Stringised_: the VALUE of a text that is ONE string literal.
''
'' What was here read the first quote and the last quote and took what lay between, so
'' a literal carrying a DOUBLED quote came back with the doubling still in it. That is
'' not a decline -- it is a WRONG STRING, silently:
''
''     __FB_UNQUOTE__( "dim s as string = ""freebasic""" )
''
'' relexed to 'dim s as string = "" freebasic ""' and tiko-lang initialised s to the
'' EMPTY string, where fbc prints 'freebasic'. Measured, both.
''
'' A '$' or '!' prefix belongs to the literal and is not part of its value. Escapes are
'' NOT processed: in -lang fb a plain literal does not have them, and a '!' one is left
'' to whatever relexes the result -- returning ok=false for it would decline where the
'' old code at least produced the text.
''
'' ok is false when the text is not exactly one literal (adjacent literals, a trailing
'' token, a lone quote inside), and the caller keeps its previous, cruder strip.
private function Unstringised_( byref t as string, byref ok as boolean ) as string
    ok = false
    dim as string src = trim( t )
    dim as long i = 0
    if len( src ) = 0 then return ""
    if (src[0] = 36) orelse (src[0] = 33) then i = 1   '' '$' or '!'
    if i >= len( src ) then return ""
    if src[i] <> 34 then return ""
    i += 1
    dim as string r = ""
    do while i < len( src )
        if src[i] <> 34 then
            r += chr( src[i] )
            i += 1
            continue do
        end if
        '' A quote: doubled it is one quote of the value, alone it closes the literal
        '' and anything after it means this was never a single literal.
        dim as boolean doubled = (i + 1 < len( src )) andalso (src[i + 1] = 34)
        if doubled then
            r += chr( 34 )
            i += 2
            continue do
        end if
        if i <> len( src ) - 1 then return ""
        ok = true
        return r
    loop
    return ""
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

'' The arguments from 'from' onward, comma-joined -- the tail a builtin passes on.
private function ArgTail_ _
    ( byref e as PpEngine, byref args as ArgList, byval from as long, _
      byval upto as long ) as string

    dim as string s = ""
    dim as long last = upto
    if last >= args.firsts.Count then last = args.firsts.Count - 1
    for i as long = from to last
        if i > from then s += ", "
        s += ArgText( e, args, i )
    next
    return s
end function

'' One operand of a '##', as text: a PARAMETER contributes its argument, and anything
'' else its own spelling.
''
'' THE ARGUMENT IS EXPANDED FIRST, which is the OPPOSITE of C and is measured:
''
''     #define A 1
''     #define CAT(a,b) a##b
''     CAT( q, A )     ->  q1        (C would give 'qA')
''     CAT( A, A )     ->  11
''
'' Both operands come through here, so one call covers left and right. The '#'
'' stringise operator had the same bug and the same fix.
''
'' It is what the SEQUENCE-SIZE idiom is built on -- a chain of macros each expanding to
'' the next, driven by a parenthesised sequence and pasted onto a prefix. Pasting the raw
'' spellings gave 'SEQ_SIZE_SEQ_SIZE_0' where fbc gives 'SEQ_SIZE_SEQ_SIZE_3', so the
'' answer was 0 for every sequence and the '(a)(b)(c)' tokens survived into the
'' statement after it.
private function PasteSpelling_ _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref args as ArgList, _
      byref t as Token ) as string

    dim as InternId pn = ParamNameId_( e, t )
    if pn <> 0 then
        dim as long ai = ArgIndexOf( m, pn )
        if ai >= 0 then return ExpandedArgText_( e, args, ai )
    end if
    return SpellOf( e, t )
end function

'' '##_' IS A LINE JOIN, NOT A PASTE, and it has to be recognised BEFORE the paste
'' below sees it -- otherwise the '{' or the ',' in front of it is pasted onto the
'' spelling '_' and the join is lost. Measured on fbc:
''
''     #define ENT(x) x, ##_        over  BEGIN() / ENT(1) / ENT(2) / END()
''         one statement, 'dim a(0 to ...) as long = { 1, 2, 9 }'
''
''     ##  at end of line, no '_'   fbc error 9, and the '#' survives into the output
''     _   at end of line, no '##'  does NOT continue across the macro boundary
''
'' So the pair joins and neither half does it alone. What is joined is the NEXT end of
'' line to reach the output, which EmitTok is what decides -- see e.eatNextEol, and the
'' three shapes measured there.
private function IsLineJoinAt_ _
    ( byref e as PpEngine, byval m as PpMacro ptr, byval j as long ) as boolean

    if (j + 2) >= m->body.Count then return false
    if Tk( m->body[j] ) <> TK_HASH then return false
    if Tk( m->body[j + 1] ) <> TK_HASH then return false
    if Tk( m->body[j + 2] ) <> TK_IDENT then return false
    if e.names->Spelling( cast( InternId, m->body[j + 2].literal ) ) <> "_" then return false

    '' THE '_' MUST END THE LINE, and leaving that out was caught by an existing test
    '' rather than by a probe: 'private function V##_ overload( ... )' pastes the NAME
    '' 'Foo_' -- fbc emits '_Z4FOO_u7INTEGER' for it -- and reading that as a line join
    '' dropped the paste and the declaration with it. mir/line-continuation is the test,
    '' and it exists because fb/vector.bi once declared 'Vec2fdim' for the same reason.
    ''
    '' At the very end of the body counts: that is the '#define ENT(x) x, ##_' form,
    '' where there is no body EOL and the INVOCATION's is what goes.
    if (j + 3) >= m->body.Count then return true
    if Tk( m->body[j + 3] ) <> TK_EOL then return false
    '' A ':' is a TK_EOL and is not a line end -- the same distinction EmitTok makes.
    return ((m->body[j + 3].flags and TF_COLON) = 0)
end function

'' Substitute parameters into the body, handling '#' stringise and '##' paste.
private sub PpSubstitute _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref args as ArgList, _
      byval useLoc as SourceLoc, byref outv as TokenVec )

    dim as long i = 0
    while i < m->body.Count
        if IsLineJoinAt_( e, m, i ) then
            '' A MARKER, NOT A FLAG. This loop walks the whole body before one token
            '' of it is emitted, so arming e.eatNextEol here ate whichever EOL came
            '' FIRST in the body rather than the first one after the join: a body of
            '' two lines whose second ends in '##_' lost the separator between line
            '' one and line two and kept the invocation's EOL -- one statement split
            '' where fbc joins, which is what made pp/token-pasting.bas's static
            '' array declaration vanish. EmitTok arms the join when this reaches it.
            dim as Token mark = m->body[i]
            mark.kind = cast( ushort, TK_EOL )
            mark.length = 0
            mark.flags or= TF_FROM_MACRO or TF_SYNTHESISED or TF_JOIN_MARK
            mark.flags and= not (TF_COLON or TF_AT_LINE_START)
            outv.Push( mark )
            i += 3
            continue while
        end if

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
                dim as InternId np = ParamNameId_( e, nt )
                if np <> 0 then
                    dim as long ai = ArgIndexOf( m, np )
                    if ai >= 0 then
                        '' THE ARGUMENT IS EXPANDED FIRST. Measured, and it is the
                        '' opposite of C, whose '#' stringifies the raw operand:
                        ''
                        ''   #define A 1 : #define B A+A
                        ''   SHOW( A )     ->  [1]
                        ''   SHOW( B )     ->  [1+1]
                        ''   SHOW( A B )   ->  [1 1+1]
                        ''
                        '' -- fully expanded, not one level: B becomes A+A and then
                        '' 1+1. tiko-lang stringified the RAW text and produced [A],
                        '' [B] and [A B].
                        RelexInto( e, _
                            Stringised_( ExpandedArgText_( e, args, ai ) ), _
                            useLoc, outv )
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
            '' ...unless it is the line join, which the top of the loop handles once
            '' the token in front of it has been emitted normally.
            if pasteNext andalso IsLineJoinAt_( e, m, i + 1 ) then pasteNext = false
        end if
        if pasteNext then
            dim as string acc = PasteSpelling_( e, m, args, bt )
            if i + 3 < m->body.Count then
                acc += PasteSpelling_( e, m, args, m->body[i + 3] )
            end if
            i += 4

            '' 'a##b##c' pastes LEFT TO RIGHT, and '##' is TWO tokens, so after the
            '' first paste the cursor lands ON the second '##' rather than on the
            '' result -- where nothing recognises it and both hashes are emitted
            '' literally. fbcunit writes 'tests.##suite_name##.init' and got
            '' 'tests.mysuite##.init'.
            ''
            '' The spellings accumulate and are re-lexed ONCE at the end, which is what
            '' fbc does: it cannot make '.mysuite' one token either, and does not try.
            while (i + 2 < m->body.Count) andalso _
                  (Tk( m->body[i] ) = TK_HASH) andalso (Tk( m->body[i + 1] ) = TK_HASH)
                acc += PasteSpelling_( e, m, args, m->body[i + 2] )
                i += 3
            wend

            RelexInto( e, acc, useLoc, outv )
            continue while
        end if

        '' A plain parameter reference splices the argument's tokens.
        dim as InternId bp = ParamNameId_( e, bt )
        if bp <> 0 then
            dim as long ai = ArgIndexOf( m, bp )
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

'' AN ARGUMENT THAT IS A BARE MACRO INVOCATION IS EXPANDED BEFORE IT IS SUBSTITUTED.
''
'' Substitution pushes an argument's RAW tokens and lets the rescan expand them,
'' which is right for everything except this one shape. Given
''
''     #macro foo ? ( a, b )    __fb_quote__( a b )    #endmacro
''     foo( bar 1, 2, 3, baz( 4, 5, 6 ) )
''
'' the body becomes '__fb_quote__( bar 1, 2, 3 baz( 4, 5, 6 ) )' -- and 'bar' read
'' bare runs to END OF LINE, so its third argument swallowed 'baz( 4, 5, 6 )' and
'' the string came out '$"1 2 3 $""4 5 6""' where fbc gives '$"1 2 3" $"4 5 6"'.
'' Lowered, verified, and wrong.
''
'' Expanding the argument first turns it into one literal token before it is placed
'' next to the following one, so there is no boundary left to lose. Only arguments
'' that BEGIN with a bare-callable name are touched: every other substitution keeps
'' the raw-token behaviour it had.
private sub PreExpandBareArgs_ _
    ( byref e as PpEngine, byref args as ArgList )

    dim as long n = args.firsts.Count
    if n = 0 then return

    dim as boolean anyBare = false
    for ai as long = 0 to n - 1
        if args.counts[ai] < 2 then continue for
        dim as Token t0 = args.flat[args.firsts[ai]]
        if Tk( t0 ) <> TK_IDENT then continue for
        dim as PpMacro ptr im = MacroFor( e, cast( InternId, t0.literal ) )
        if im = 0 then continue for
        if (im->isFunc = false) orelse (im->optParens = false) then continue for
        if Tk( args.flat[args.firsts[ai] + 1] ) = TK_LPAREN then continue for
        anyBare = true
        exit for
    next
    if anyBare = false then return

    dim as ArgList outA
    for ai as long = 0 to n - 1
        dim as boolean isBare = false
        if args.counts[ai] >= 2 then
            dim as Token t0 = args.flat[args.firsts[ai]]
            if Tk( t0 ) = TK_IDENT then
                dim as PpMacro ptr im = MacroFor( e, cast( InternId, t0.literal ) )
                if im <> 0 then
                    isBare = im->isFunc andalso im->optParens
                    if isBare then
                        isBare = (Tk( args.flat[args.firsts[ai] + 1] ) <> TK_LPAREN)
                    end if
                end if
            end if
        end if

        dim as long first = outA.flat.Count
        dim as long count = 0
        if isBare then
            dim as TokenVec tv
            RelexInto( e, ExpandedArgText_( e, args, ai ), LOC_NONE, tv )
            for j as long = 0 to tv.Count - 1
                dim as Token nt = tv[j]
                '' THE ARGUMENT'S OWN LEADING SPACE SURVIVES THE REPLACEMENT.
                '' Relexed tokens carry the spacing of the synthesised text, so two
                '' bare arguments in a row came out '$"1 2 3"$"4 5 6"' -- fbc puts
                '' a space there, and it is the space that was before 'baz'.
                if j = 0 then
                    dim as Token t0f = args.flat[args.firsts[ai]]
                    nt.flags = nt.flags and (not TF_SPACE_BEFORE)
                    nt.flags = nt.flags or (t0f.flags and TF_SPACE_BEFORE)
                end if
                outA.flat.Push( nt )
                count += 1
            next
        else
            for j as long = 0 to args.counts[ai] - 1
                outA.flat.Push( args.flat[args.firsts[ai] + j] )
                count += 1
            next
        end if
        outA.firsts.Push( first )
        outA.counts.Push( count )
    next

    args.flat.Clear( )
    args.firsts.Clear( )
    args.counts.Clear( )
    for j as long = 0 to outA.flat.Count - 1
        args.flat.Push( outA.flat[j] )
    next
    for j as long = 0 to outA.firsts.Count - 1
        args.firsts.Push( outA.firsts[j] )
        args.counts.Push( outA.counts[j] )
    next
end sub

'' THE EXPANSION'S TRAILING END-OF-LINE, dropped unless the invocation was itself
'' synthesised.
''
'' fbc's model has no end-of-line at the end of a macro body: 's = h( ) + h( )' over
'' a one-line '#macro' is ONE statement to fbc, and the kept EOL split it in two --
'' 'expected a statement' at the '+'. pp/macro_trim.bas is six of those.
''
'' TRIMMING IT AT DEFINITION WAS TRIED THREE TIMES AND REVERTED THREE TIMES.
'' __FB_ARG_LISTEXPAND__ synthesises 'M( 1 ) : M( 2 ) : M( 3 )' as TEXT and relies
'' on each repetition ending where it does; without the end-of-line they run
'' together and a 'const' inside the body is declared twice in one scope.
'' pp/macro-arg-listexpand.bas went 0 declines to 415 and the pp corpus 77 to 900.
'' Two call-site tests were tried as well -- not at a line start, not after a ':' --
'' and the note after the third attempt is the way in: 'the dependency is INSIDE an
'' expansion, not at its call site'.
''
'' TF_SYNTHESISED is that distinction, and TF_FROM_MACRO is not: 'h( )' written
'' inside 'CU_ASSERT_EQUAL( h( ) + h( ), ... )' is carried into the assert's body as
'' an ARGUMENT and takes TF_FROM_MACRO on the way, while still being a name the
'' program wrote. Only RelexInto sets TF_SYNTHESISED, and LISTEXPAND's repetitions
'' are the only thing here that comes through it.
''
'' A body of several LINES keeps its end-of-line either way: the trailing run is
'' trimmed, not the interior ones, so nothing that depends on statements staying
'' apart is touched.
private sub TrimExpansionTail_ _
    ( byref use as Token, byref buf as TokenVec )

    if (use.flags and TF_SYNTHESISED) <> 0 then return
    while buf.Count > 0
        if Tk( buf[buf.Count - 1] ) <> TK_EOL then exit while
        '' THE LINE-JOIN MARKER IS A TK_EOL AND IS NOT A TRAILING ONE. Trimming it
        '' would throw away the join in the '#define ENT(x) x, ##_' shape, where the
        '' marker IS the last thing in the body and the EOL it eats is the caller's.
        if (buf[buf.Count - 1].flags and TF_JOIN_MARK) <> 0 then exit while
        buf.Pop( )
    wend
end sub

declare function PpExpandBuiltin _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean

'' Expand the macro named by 'use'. Returns true when it consumed the name.
private function PpExpand _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean

    '' PPB_SELF -- TRUE and FALSE -- IS DEFINED BUT NEVER EXPANDS. Returning false
    '' means "the name was not consumed", so every caller falls through to its own
    '' Advance-and-emit and the identifier reaches the parser unchanged, where the
    '' symbol table resolves it as the BOOLEAN const it is in fbc (symb-keyword.bas,
    '' -1 and 0). Emitting the name from an expansion frame instead cannot work:
    '' IsHidden always returns false -- fbc has no hide set, measured -- so a
    '' self-emitting expansion re-enters itself and dies at PP_MAX_FRAMES, which is
    '' what '#if TRUE' did on the first attempt at this.
    if m->builtin = PPB_SELF then return false
    if m->builtin <> PPB_NONE then return PpExpandBuiltin( e, m, use )

    '' A function-like macro not followed by '(' is just an identifier, as in C.
    if m->isFunc then
        '' LOOK WITHOUT MOVING. Advancing first and restoring f->pos on a miss loses the
        '' token after the name when the name ENDS its frame -- see PeekTokAhead.
        dim as Token nxt
        dim as boolean haveParen = PeekTokAhead( e, nxt ) andalso (Tk( nxt ) = TK_LPAREN)
        '' '#macro NAME?( a )' may be written without parentheses -- 'NAME x'. Only with
        '' the '?': a plain function-like macro used bare is not an invocation at all,
        '' and fbc reports the name as an undeclared variable rather than expanding it.
        dim as boolean bare = false
        if haveParen = false then
            if m->optParens = false then return false
            bare = true
        end if

        '' only now is the name consumed
        Advance( e )

        dim as ArgList args
        if PpReadArgs( e, m, args, bare ) = false then return true

        dim as long want = m->params.Count
        dim as long got = args.firsts.Count
        '' A VARIADIC TAIL MAY BE EMPTY: '#macro m( a, c... )' invoked as 'm( 1 )' is
        '' legal, and the test for it -- '#if #c = ""' -- is the usual way a macro asks
        '' whether it got any. Requiring got >= want made the empty case, which is the
        '' one worth testing for, the one that could not be written.
        dim as long need = want
        if m->isVariadic then need = want - 1
        dim as boolean countOk = (got = want) orelse (m->isVariadic andalso (got >= need))
        if countOk = false then
            Report( e, TKO0306, use.loc, e.names->Spelling( m->name ), str( want ) )
            return true
        end if

        PreExpandBareArgs_( e, args )
        dim as TokenVec ptr buf = new TokenVec
        PpSubstitute( e, m, args, use.loc, *buf )
        TrimExpansionTail_( use, *buf )
        e.outp->expansionCount += 1
        PushFrame( e, buf, m->name, FILE_NONE, true, use.loc )
        return true
    end if

    Advance( e )
    dim as TokenVec ptr buf = new TokenVec
    dim as ArgList empty
    PpSubstitute( e, m, empty, use.loc, *buf )
    e.outp->expansionCount += 1
    PushFrame( e, buf, m->name, FILE_NONE, true, use.loc )
    return true
end function

#include once "pp/macrobuiltin.bas"

end namespace

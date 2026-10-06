'' macrobuiltin.bas -- the __FB_* BUILTIN macros.
''
'' Split out of macro.bas at the 1500-line lint cap. It is INCLUDED into the same
'' compilation unit, so the private helpers above it -- Stringised_, ExpandedArgText_,
'' PpReadArgs and the rest -- stay visible exactly as they were.


'' -------------------------------------------------------------------- builtins

private function FileShown_( byref e as PpEngine, byref d as DecodedLoc ) as string
    if d.shownName <> INTERN_NONE then return e.src->ShownPathOf( d )
    dim as boolean included = false
    for each f as ulong in e.allIncluded
        if cast( FileId, f ) = d.file then included = true
    next
    if included = false then return e.src->ShownPathOf( d )
    dim as string ap = e.src->AbsPathOf( d.file )
    #ifdef __FB_WIN32__
        for k as long = 0 to len( ap ) - 1
            if ap[k] = 47 then ap[k] = 92
        next
    #endif
    return ap
end function

function PpExpandBuiltin _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean

    Advance( e )

    '' THE USE SITE, NOT THE BODY TOKEN'S OWN LOC. Inside a macro body 'use' is the
    '' token as it sits in the DEFINITION, so __LINE__ reported the '#define' line for
    '' every expansion -- measured against fbc 1.10, which reports 3 and 4 for two uses
    '' of a macro defined on line 1, where tiko-lang reported 1 twice. __FILE__ was the
    '' same bug: a macro defined in a header named the HEADER wherever it was used.
    '' See UseSiteLoc_ in pp.bas for why the outermost expansion is the one that
    '' answers. Nothing else here is position-dependent, so nothing else changes.
    dim as DecodedLoc d = e.src->Decode( UseSiteLoc_( e, use ) )
    dim as TokenVec ptr buf = new TokenVec

    select case as const m->builtin
    case PPB_LINE
        RelexInto( e, str( e.src->Decode( LineSiteLoc_( e, use ) ).lineNo ), use.loc, *buf )

    '' AN INCLUDED FILE'S __FILE__ IS ITS ABSOLUTE PATH -- measured, fbc prints
    '' 'C:\...\f68\sub\inc.bi' where tiko printed the spelling 'sub/inc.bi'; the root
    '' keeps the name it was given, and a '#line' name wins over both (audit F-68).
    case PPB_FILE
        RelexInto( e, """" & FileShown_( e, d ) & """", use.loc, *buf )

    case PPB_FILE_NQ
        RelexInto( e, e.src->ShownPathOf( d ), use.loc, *buf )

    '' __PATH__ IS THE FILE'S DIRECTORY, ABSOLUTE AND QUOTED -- measured, fbc prints
    '' 'C:\Users\...\f54' for a file in that directory. It shared __FILE_NQ__'s branch
    '' and expanded to the bare file name: 'print __PATH__' over p2.bas was ''p2' is not
    '' declared' (audit F-54).
    case PPB_PATH
        dim as string ap = e.src->AbsPathOf( d.file )
        #ifdef __FB_WIN32__
            for k as long = 0 to len( ap ) - 1
                if ap[k] = 47 then ap[k] = 92
            next
        #endif
        dim as long cut = 0
        for k as long = len( ap ) - 1 to 0 step -1
            if (ap[k] = 47) orelse (ap[k] = 92) then
                cut = k
                exit for
            end if
        next
        RelexInto( e, """" & left( ap, cut ) & """", use.loc, *buf )

    case PPB_DATE
        RelexInto( e, """" & date( ) & """", use.loc, *buf )

    '' __DATE_ISO__ IS THE SAME DAY IN THE OTHER ORDER. Measured, one probe on
    '' 2026-08-28: __DATE__ is "08-28-2026" and __DATE_ISO__ is "2026-08-28".
    '' FreeBASIC's DATE( ) gives the first, so this reorders its fields rather
    '' than asking the clock twice -- a run that straddles midnight would
    '' otherwise put two different days in one program.
    case PPB_DATE_ISO
        dim as string dmy = date( )
        dim as string iso = mid( dmy, 7, 4 ) & "-" & mid( dmy, 1, 2 ) & "-" & _
                            mid( dmy, 4, 2 )
        RelexInto( e, """" & iso & """", use.loc, *buf )

    case PPB_TIME
        RelexInto( e, """" & time( ) & """", use.loc, *buf )

    case PPB_UNIQUEID, PPB_UNIQUEID_PUSH, PPB_UNIQUEID_POP
        '' A STACK PER NAME. The previous version handed back a fresh identifier on
        '' every use, so two references to __FB_UNIQUEID__( k ) in one scope named two
        '' different variables -- which is what the fbcunit callstack macros do, and
        '' the reason 1,633 corpus statements arrived at lowering as calls to an
        '' undefined '__fb_uniqueid_push__'. Measured from fbc:
        ''
        ''     __fb_uniqueid_push__( k )   a NEW id becomes k's current one
        ''     __fb_uniqueid__( k )        THE SAME id until the next push or pop
        ''     __fb_uniqueid_pop__( k )    k's previous id is current again
        ''
        '' Push and pop expand to NOTHING. They fall through to the common tail with
        '' an empty buffer rather than returning early: the buffer is heap-allocated
        '' and the tail is what releases it.
        dim as ArgList uargs
        PpReadArgs( e, m, uargs )
        dim as InternId ukey = _
            e.names->GetString( Text.LowerAscii( ArgText( e, uargs, 0 ) ) )

        if m->builtin = PPB_UNIQUEID_PUSH then
            e.uniqueCounter += 1
            e.uidNames.Push( cast( ulong, ukey ) )
            e.uidValues.Push( cast( ulong, e.uniqueCounter ) )
        else
            '' The innermost entry for this name, found by scanning backwards.
            dim as long utop = -1
            for i as long = e.uidNames.Count - 1 to 0 step -1
                if cast( InternId, e.uidNames[i] ) = ukey then
                    utop = i
                    exit for
                end if
            next

            if m->builtin = PPB_UNIQUEID_POP then
                '' AN UNMATCHED POP IS AN ERROR, not a no-op. Measured -- and two corpus
                '' files exist to assert exactly that:
                ''
                ''     a.bas(1) error 17: Syntax error, expanding: __FB_UNIQUEID_POP__
                ''
                '' Shifted down rather than popped, because the entry to drop is not
                '' always the array's top -- two names can interleave.
                if utop < 0 then
                    Report( e, TKO0319, use.loc, ArgText( e, uargs, 0 ) )
                end if
                if utop >= 0 then
                    for i as long = utop to e.uidNames.Count - 2
                        e.uidNames[i] = e.uidNames[i + 1]
                        e.uidValues[i] = e.uidValues[i + 1]
                    next
                    e.uidNames.Pop( )
                    e.uidValues.Pop( )
                end if
            else
                '' A BARE __FB_UNIQUEID__ WITH NO STACK -- never pushed, or popped back to empty -- is
                '' NOTHING: '__FB_QUOTE__( __FB_UNIQUEID__( k ) )' is "" (pp/macro-uniqueid.bas). It opened
                '' a stack of its own and named an id.
                if utop >= 0 then RelexInto( e, "__tko_uid_" & e.uidValues[utop], use.loc, *buf )
            end if
        end if

    case PPB_QUOTE
        '' The whole point of the lexer keeping (loc, length) on every token: the
        '' argument's exact source bytes are recoverable, including non-ASCII ones
        '' that could never be an identifier (probe L9).
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            '' Stringised_, NOT a naive wrap in quotes -- the same fix '#' already had
            '' and this did not. A QUOTE INSIDE THE ARGUMENT has to be DOUBLED or it
            '' closes the literal early: '__FB_QUOTE__( "2,3" )' came back as an EMPTY
            '' string plus two stray tokens, and the whole statement then declined --
            '' every one of the 27 in pp/macro-arg-extract.bas.
            '' Measured: fbc doubles the inner quotes and prefixes '$', so a backslash
            '' in the argument stays a backslash.
            '' AND THE ARGUMENT IS EXPANDED FIRST, exactly as '#' is -- measured:
            '' '__FB_QUOTE__( B )' over '#define B A+A' is "1+1", not "B".
            RelexInto( e, Stringised_( ExpandedArgText_( e, args, 0 ) ), _
                       use.loc, *buf )
        end if

    case PPB_UNQUOTE
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            '' THE ARGUMENT IS EXPANDED FIRST, exactly as QUOTE's is. The corpus's own
            '' idiom is '__FB_UNQUOTE__( __FB_EVAL__( "#define " "X" " 1" ) )' -- fold a
            '' directive's text and then let it BE a directive -- and reading the raw
            '' argument saw the nested builtin's NAME rather than the string it folds to,
            '' so the synthesised '#define' had no identifier after it.
            dim as string s = ExpandedArgText_( e, args, 0 )
            dim as boolean uok = false
            dim as string u = Unstringised_( s, uok )
            if uok then
                s = u
            else
                dim as long a = instr( s, """" )
                dim as long b = instrrev( s, """" )
                if (a > 0) andalso (b > a) then s = mid( s, a + 1, b - a - 1 )
            end if
            RelexInto( e, s, use.loc, *buf )
        end if

    case PPB_EVAL
        '' __FB_EVAL__( expr ) -- ONE ARGUMENT, macro-expanded, folded, and re-emitted
        '' as a canonical literal. See EvalLiteral_ for what each result renders as and
        '' which two decline.
        ''
        '' There is no '#__FB_EVAL__' directive form: measured, fbc answers error 17 for
        '' one, so this is an expression builtin and nothing else.
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            if args.firsts.Count <> 1 then
                Report( e, TKO0325, use.loc, e.names->Spelling( m->name ) )
            else
                dim as boolean vok = false
                dim as PpValue v = BuiltinValueArg_( e, args, 0, vok )
                if vok then
                    dim as boolean rok = false
                    dim as string lit = EvalLiteral_( v, rok )
                    '' A RESULT THIS CANNOT RENDER IS LEFT UNEXPANDED, which is what
                    '' the name did before the builtin existed: the statement declines
                    '' rather than receiving a literal that is not the one fbc emits.
                    if rok then RelexInto( e, lit, use.loc, *buf )
                else
                    Report( e, TKO0325, use.loc, e.names->Spelling( m->name ) )
                end if
            end if
        end if

    '' __FB_MIN_VERSION__( major, minor, patch ): -1 when the compiler is at least that
    '' version, else 0 -- in an expression and in '#if' alike. Measured on fbc-modern
    '' 1.20.0: ( 1, 20, 0 ) is -1, ( 1, 20, 1 ) is 0, and two arguments are its error 1,
    '' an argument count mismatch. tiko answers for TKO_FBC_COMPAT, the version it is
    '' compatible with and reports as __FB_VER_MAJOR__ and the rest.
    case PPB_MIN_VERSION
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            if args.firsts.Count <> 3 then
                Report( e, TKO0306, UseSiteLoc_( e, use ), e.names->Spelling( m->name ), "3" )
            else
                dim as boolean ok0, ok1, ok2
                dim as longint wa = BuiltinIntArg_( e, args, 0, ok0 )
                dim as longint wb = BuiltinIntArg_( e, args, 1, ok1 )
                dim as longint wc = BuiltinIntArg_( e, args, 2, ok2 )
                if (ok0 andalso ok1 andalso ok2) = false then
                    Report( e, TKO0324, UseSiteLoc_( e, use ), "1", e.names->Spelling( m->name ) )
                else
                    dim as string fv = TKO_FBC_COMPAT
                    dim as long d1 = instr( fv, "." )
                    dim as long d2 = instr( d1 + 1, fv, "." )
                    dim as longint ha = valint( left( fv, d1 - 1 ) )
                    dim as longint hb = valint( mid( fv, d1 + 1, d2 - d1 - 1 ) )
                    dim as longint hc = valint( mid( fv, d2 + 1 ) )
                    dim as boolean atLeast = (ha > wa)
                    if ha = wa then atLeast = (hb > wb) orelse ((hb = wb) andalso (hc >= wc))
                    RelexInto( e, iif( atLeast, "-1", "0" ), use.loc, *buf )
                end if
            end if
        end if

    case PPB_ARG_COUNT
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as FB.Array( of string ) lst
            ExpandedArgList_( e, args, 0, lst )
            dim as long n = lst.Count
            if (n = 1) andalso (len( lst[0] ) = 0) then n = 0
            RelexInto( e, str( n ), use.loc, *buf )
        end if

    case PPB_ARG_EXTRACT
        '' __FB_ARG_EXTRACT__( i, a, b, c ) -> the i'th of the list, ZERO-BASED.
        ''
        '' AN INDEX PAST THE END EXPANDS TO NOTHING rather than being an error of its
        '' own -- measured: 'f( 0, __FB_ARG_EXTRACT__( 5, 1, 2 ) )' fails as an argument
        '' count mismatch at the CALL, which is what an empty expansion produces. A
        '' NEGATIVE index is rejected here, matching fbc's own syntax error.
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as boolean iok = false
            dim as longint i = BuiltinIntArg_( e, args, 0, iok )
            '' ...AND NOT A FLOAT, NOR A NAME NO MACRO GIVES A VALUE: the evaluator reads
            '' '3.147' as 3 and an unknown 'jimArg' as 0, where fbc gives 17 and 42
            '' (fbc-modern 1.20, 2026-09-29; pp/macro-arg-extract-fail and -fail3).
            if iok andalso (args.firsts.Count > 0) then
                for ti as long = 0 to args.counts[0] - 1
                    dim as Token at_ = args.flat[args.firsts[0] + ti]
                    if Tk( at_ ) = TK_FLOAT_LIT then iok = false
                    if Tk( at_ ) = TK_IDENT then
                        if MacroFor( e, cast( InternId, at_.literal ) ) = 0 then iok = false
                    end if
                next
            end if
            if (iok = false) orelse (i < 0) then
                '' At the USE SITE, where fbc reports it, not at the body token.
                Report( e, TKO0324, UseSiteLoc_( e, use ), "1", e.names->Spelling( m->name ) )
            else
                '' The LIST is everything after the index, expanded and RE-SPLIT --
                '' so a macro standing in for several elements contributes all of
                '' them, which is the whole point of this builtin.
                dim as FB.Array( of string ) lst
                ExpandedArgList_( e, args, 1, lst )
                if i < lst.Count then
                    RelexInto( e, lst[cast( long, i )], use.loc, *buf )
                end if
            end if
        end if

    case PPB_IIF
        '' __FB_IIF__( cond, a, b ) -- the PREPROCESSOR's conditional, and not the
        '' language's: measured with 'fbc -pp', only the selected arm appears in the
        '' output at all, so the other one need not even be well formed.
        ''
        '' The condition is a constant expression on EXPANDED tokens, the same input
        '' '#if' is given -- '__FB_IIF__( A+B, 1, 2 )' with '#define A 1' and
        '' '#define B 2' takes the first arm.
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as TokenVec cv
            RelexInto( e, ExpandedArgText_( e, args, 0 ), LOC_NONE, cv )
            dim as boolean cok = false
            dim as boolean truthy = PpEvalCondition( e, cv, cok )
            if cok = false then
                Report( e, TKO0324, use.loc, "1", e.names->Spelling( m->name ) )
            else
                '' RAW, not expanded: the arm goes back through the ordinary expansion
                '' path once it is relexed into the buffer.
                RelexInto( e, ArgText( e, args, iif( truthy, 1, 2 ) ), use.loc, *buf )
            end if
        end if

    case PPB_ARG_LEFTOF, PPB_ARG_RIGHTOF
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as string text_ = ExpandedArgText_( e, args, 0 )
            dim as string needle = trim( ExpandedArgText_( e, args, 1 ) )
            dim as string res = _
                SplitAtToken_( e, text_, needle, (m->builtin = PPB_ARG_LEFTOF) )
            if (len( res ) = 0) andalso (len( trim( text_ ) ) > 0) then
                if args.firsts.Count > 2 then res = ExpandedArgText_( e, args, 2 )
            end if
            RelexInto( e, res, use.loc, *buf )
        end if

    case PPB_ARG_LISTEXPAND
        '' __FB_ARG_LISTEXPAND__( M, step, a, b, c ) -> M called over the list.
        ''
        '' MEASURED from fbc's own C output, because none of it is guessable:
        ''
        ''   step = 0    one call with the whole list.
        ''   step = n    successive CHUNKS of n, front to back; the last is short.
        ''               'M, 2, 1, 2, 3, 4, 5' is M(1,2) M(3,4) M(5).
        ''   step = -n   successive TAILS, dropping n from the front each time and
        ''               always passing everything that remains.
        ''               'M, -2, 1, 2, 3, 4, 5' is M(1..5) M(3,4,5) M(5).
        ''
        '' A step wider than the list is one call with all of it, either sign.
        ''
        '' The calls are emitted as TEXT and re-lexed, so M expands by the ordinary
        '' path -- there is nothing special about the macro being invoked. They are
        '' separated by ':' rather than a newline because RelexInto drops TK_EOL, and
        '' two statements run together would parse as one.
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as boolean sok = false
            dim as longint stp = BuiltinIntArg_( e, args, 1, sok )
            if sok = false then
                Report( e, TKO0324, use.loc, "2", e.names->Spelling( m->name ) )
            else
                dim as string mname = trim( ArgText( e, args, 0 ) )
                '' ...and the LIST is re-split the same way here.
                dim as FB.Array( of string ) lst
                ExpandedArgList_( e, args, 2, lst )
                if (lst.Count = 1) andalso (len( lst[0] ) = 0) then lst.Pop( )
                dim as long n = lst.Count                  '' the list length
                dim as string s = ""
                dim as long calls = 0
                if n > 0 then
                    if stp = 0 then
                        s = mname + "( " + ListJoin_( lst, 0, n - 1 ) + " )"
                    elseif stp > 0 then
                        dim as long at = 0
                        while at < n
                            dim as long last = at + cast( long, stp ) - 1
                            if last > n - 1 then last = n - 1
                            if calls > 0 then s += " : "
                            s += mname + "( " + ListJoin_( lst, at, last ) + " )"
                            calls += 1
                            at += cast( long, stp )
                        wend
                    else
                        dim as long drop = cast( long, -stp )
                        dim as long at = 0
                        while at < n
                            if calls > 0 then s += " : "
                            s += mname + "( " + ListJoin_( lst, at, n - 1 ) + " )"
                            calls += 1
                            at += drop
                        wend
                    end if
                end if
                if len( s ) > 0 then RelexInto( e, s, use.loc, *buf )
            end if
        end if


    case PPB_JOIN
        '' __FB_JOIN__ EXPANDS ITS ARGUMENTS BEFORE PASTING THEM, which is where it
        '' parts company with C's '##'. Measured, and the case that settles it is the
        '' one the two rules disagree about:
        ''
        ''   #define A 1 : #define B 2 : #define AB 99
        ''   __FB_JOIN__( A, B )   ->   12, not 99 and not 'AB'
        ''
        '' -- 12 is expand-then-paste; 99 would be paste-then-rescan and 'AB' would
        '' be paste-with-no-rescan. Pasting the RAW text produced the identifier AB,
        '' which is undeclared, so every join over macro arguments declined while
        '' '__FB_JOIN__( 1, 2 )' beside it worked. pp/macro-join.bas is twelve of them.
        ''
        '' STRINGIFY IS THE OTHER WAY ROUND and stays so: '#x' must NOT expand, which
        '' is why the two helpers exist side by side.
        dim as ArgList args
        if PpReadArgs( e, m, args ) then
            dim as string s = ""
            for i as long = 0 to args.firsts.Count - 1
                s += ExpandedArgText_( e, args, i )
            next
            RelexInto( e, s, use.loc, *buf )
        end if

    case else
        Report( e, TKO0314, use.loc, e.names->Spelling( m->name ) )
    end select

    if buf->IsEmpty( ) then
        delete buf
        return true
    end if
    e.outp->expansionCount += 1
    PushFrame( e, buf, m->name, FILE_NONE, true, use.loc )
    return true
end function

'' Moved here from macro.bas and directive.bas at the 1500-line cap.

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
function Stringised_( byref t as string ) as string
    dim as string r = "$"""
    '' A NEWLINE BECOMES A SPACE. A string literal cannot carry a raw one, so the
    '' result would not re-lex: with the macro bodies written across lines, as the
    '' corpus writes them, a nested __FB_QUOTE__ arrived as
    '' '<EOL>$"1 2 3"<EOL> <EOL>$"4 5 6"<EOL>' and the literal was truncated at the
    '' first one -- 'missing closing quote', and a WRONG STRING beside it. fbc gives
    '' '$"1 2 3" $"4 5 6"', which is the whitespace runs collapsed and trimmed.
    ''
    '' ...BUT A RUN OF SPACES OR TABS IS KEPT AS WRITTEN: measured, '#x' over 'a   +   b'
    '' is "a   +   b" in fbc, and tiko collapsed it to "a + b" (audit F-54). Only a run
    '' with a line break in it becomes one space; leading and trailing runs go.
    dim as string pend = ""
    dim as boolean pendBreak = false
    dim as boolean seenAny = false
    for i as long = 0 to len( t ) - 1
        dim as long ch = t[i]
        dim as boolean isWs = (ch = 32) orelse (ch = 9)
        if isWs = false then isWs = (ch = 13) orelse (ch = 10)
        if isWs then
            '' Leading whitespace is dropped rather than turned into a space.
            if seenAny then
                if (ch = 13) orelse (ch = 10) then pendBreak = true else pend += chr( ch )
            end if
            continue for
        end if
        if pendBreak then
            r += " "
        elseif len( pend ) > 0 then
            r += pend
        end if
        pend = "" : pendBreak = false
        seenAny = true
        if ch = 34 then r += """"
        r += chr( ch )
    next
    return r + """"
end function

'' A TOKEN OF '#print' / '#error' AS fbc SHOWS IT: an object-like macro is EXPANDED --
'' measured, '#define K 5' then '#print K' prints 5 where tiko printed K (audit F-68).
'' A function-like macro or a builtin is shown as written; the depth stops a cycle.
private function PrintSpell_( byref e as PpEngine, byref t as Token, byval depth as long ) as string
    if (Tk( t ) = TK_IDENT) andalso (depth < 32) then
        dim as PpMacro ptr m = MacroFor( e, cast( InternId, t.literal ) )
        if m <> 0 then
            if (m->isFunc = false) andalso (m->builtin = PPB_NONE) then
                dim as string r = ""
                for k as long = 0 to m->body.Count - 1
                    if k > 0 then r += " "
                    r += PrintSpell_( e, m->body[k], depth + 1 )
                next
                return r
            end if
        end if
    end if
    return SpellOf( e, t )
end function

'' THE WHITESPACE BETWEEN TWO ARGUMENT TOKENS, AS WRITTEN, when both come straight from one
'' line of source: '#x' over 'a   +   b' is "a   +   b" in fbc (audit F-54). Anything else
'' -- a token an expansion made, a gap across a line, a comment in it -- is one space.
function GapText_( byref e as PpEngine, byref a as Token, byref b as Token ) as string
    dim as long ni = PasteNoteOf_( e, b, true )   '' a paste's own gap -- ppspell.bas
    if (ni >= 0) andalso (len( e.pasteGap[ni] ) > 0) then return e.pasteGap[ni]
    dim as FileId fileA, fileB
    dim as long oa = e.src->LocOffset( a.loc, fileA )
    dim as long ob = e.src->LocOffset( b.loc, fileB )
    if (fileA = FILE_NONE) orelse (fileA <> fileB) then return " "
    dim as long gapFrom = oa + cast( long, a.length )
    if (ob <= gapFrom) orelse (ob - gapFrom > 256) then return " "
    dim as SourceFile ptr f = e.src->FileAt( fileA )
    if f = 0 then return " "
    dim as string g = ""
    for k as long = gapFrom to ob - 1
        dim as ubyte ch = f->text[k]
        if (ch <> 32) andalso (ch <> 9) then return " "
        g += chr( ch )
    next
    return g
end function

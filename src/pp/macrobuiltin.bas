'' macrobuiltin.bas -- the __FB_* BUILTIN macros.
''
'' Split out of macro.bas at the 1500-line lint cap. It is INCLUDED into the same
'' compilation unit, so the private helpers above it -- Stringised_, ExpandedArgText_,
'' PpReadArgs and the rest -- stay visible exactly as they were.


'' -------------------------------------------------------------------- builtins

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
        RelexInto( e, str( d.lineNo ), use.loc, *buf )

    case PPB_FILE
        RelexInto( e, """" & e.src->ShownPathOf( d ) & """", use.loc, *buf )

    case PPB_FILE_NQ, PPB_PATH
        RelexInto( e, e.src->ShownPathOf( d ), use.loc, *buf )

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
                '' A bare __FB_UNIQUEID__ with no push in front of it still has to
                '' name something, so it opens the stack itself.
                if utop < 0 then
                    e.uniqueCounter += 1
                    e.uidNames.Push( cast( ulong, ukey ) )
                    e.uidValues.Push( cast( ulong, e.uniqueCounter ) )
                    utop = e.uidNames.Count - 1
                end if
                RelexInto( e, "__tko_uid_" & e.uidValues[utop], use.loc, *buf )
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
            if (iok = false) orelse (i < 0) then
                Report( e, TKO0324, use.loc, "1", e.names->Spelling( m->name ) )
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

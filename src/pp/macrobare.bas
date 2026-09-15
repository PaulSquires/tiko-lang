'' macrobare.bas -- an argument that is a bare macro invocation, expanded before it is
'' substituted.
''
'' Split out of macro.bas at the 1500-line cap and included from it in the same place.
'' Nothing in it changed in the move.

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

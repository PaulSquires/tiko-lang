'' ppspell.bas -- SpellOf, MergeLiterals and RelexInto. Moved out of pp.bas verbatim on
'' 2026-10-06 for the 1500-line cap. #included by pp.bas IN PLACE, inside its 'namespace Tko',
'' where the block stood: ppjoin.bas and macro.bas, which follow it, call all three.

'' WHAT A RE-LEXED TOKEN'S SOURCE SPAN CAN NO LONGER SAY. RelexInto repoints the loc at the use
'' site, so the span is somebody else's text and two tokens of one paste sit at ONE loc:
''   - an identifier's CASE -- PpSpell falls back to the FOLDED name, and '#define J(a,b) a##b'
''     then '#J(X,Y)' was "xy" where fbc gives "XY" (pp/token-pasting.bas, 31 asserts);
''   - the GAP in front of a token -- 'a ## b' keeps both spaces under fbc, "X  Y", and
''     GapText_ could only answer " ".
'' RelexInto records either against (loc, kind, id); the newest entry wins, so two pastes at one
'' use site that differ only in case or spacing read the second's -- the one place this is
'' still wrong. -1 when nothing was recorded.
private function PasteNoteOf_( byref e as PpEngine, byref t as Token, byval wantGap as boolean ) as long
    if (t.flags and TF_SYNTHESISED) = 0 then return -1
    for i as long = e.pasteLoc.Count - 1 to 0 step -1
        if (e.pasteLoc[i] = cast( ulong, t.loc )) andalso (e.pasteId[i] = cast( ulong, t.literal )) andalso _
           (e.pasteKind[i] = cast( ulong, t.kind )) then
            '' The newest entry that HAS the answer: a speculative join's re-lex ('Y' against
            '' ')', ppjoin.bas) notes the same token again with no gap of its own.
            if len( iif( wantGap, e.pasteGap[i], e.pasteText[i] ) ) > 0 then return i
        end if
    next
    return -1
end function

private function SpellOf( byref e as PpEngine, byref t as Token ) as string
    dim as long ni = iif( Tk( t ) = TK_IDENT, PasteNoteOf_( e, t, false ), -1 )
    if (ni >= 0) andalso (len( e.pasteText[ni] ) > 0) then return e.pasteText[ni]
    return PpSpell( *e.src, *e.names, *e.lits, t )
end function

'' Rewrite every literal token in a freshly produced vector so its index points into
'' the ONE merged pool. Done at the point tokens enter -- from a file or from a
'' re-lex -- so nothing downstream has to know which pool a token came from.
sub MergeLiterals _
    ( byref e as PpEngine, byref toks as TokenVec, byref from as LiteralVec )

    for i as long = 0 to toks.Count - 1
        dim as TokenKind k = cast( TokenKind, toks[i].kind )
        dim as boolean isLit = (k = TK_INT_LIT) orelse (k = TK_FLOAT_LIT) orelse _
                               (k = TK_STRING_LIT)
        if isLit = false then continue for
        dim as long idx = cast( long, toks[i].literal )
        if idx >= from.Count then continue for
        (*e.lits).Push( from[idx] )
        toks[i].literal = cast( ulong, (*e.lits).Count - 1 )
    next
end sub

'' Re-lex a piece of text into tokens. Used by ## pasting and by __FB_UNQUOTE__.
private sub RelexInto _
    ( byref e as PpEngine, byval raw as string, byval at as SourceLoc, _
      byref outv as TokenVec )

    dim as FileId vf = e.src->AddVirtual( "<paste>", raw )
    dim as Lex.Result r
    Lex.Run( *e.src, vf, *e.names, *e.kw, *e.diags, r )
    MergeLiterals( e, r.tokens, r.literals )
    for i as long = 0 to r.tokens.Count - 1
        dim as Token t = r.tokens[i]
        if Tk( t ) = TK_EOF then exit for
        if Tk( t ) = TK_EOL then continue for
        '' Everything out of here is SYNTHESISED, whatever loc it ends up carrying.
        t.flags or= TF_SYNTHESISED
        '' A NUMERIC literal records no text span -- only strings do, because for a
        '' file token the token's own loc and length already point at the digits. That
        '' stops being true here: the loc is about to be repointed at the use site, and
        '' SpellOf would then read one character of the INVOCATION and call it the
        '' number. Recording the span into the paste buffer keeps the spelling readable
        '' -- and it must be the SPELLING, not the value, so '&HFF' does not come back
        '' as '255' through a stringize.
        ''
        '' Silent, and it made '#if __FB_ARG_COUNT__( a, b ) = 2' false: the count was
        '' produced correctly and then read back as whatever byte sat at the use site.
        dim as boolean isNum = (Tk( t ) = TK_INT_LIT) orelse (Tk( t ) = TK_FLOAT_LIT)
        if isNum andalso (t.length > 0) then
            dim as long li = cast( long, t.literal )
            if (li >= 0) andalso (li < (*e.lits).Count) then
                dim as Literal ptr lp = @(*e.lits)[li]
                if lp->textLength = 0 then
                    dim as DecodedLoc nd = e.src->Decode( t.loc )
                    lp->textFile = cast( long, nd.file )
                    lp->textOffset = nd.offset
                    lp->textLength = t.length
                end if
            end if
        end if
        '' Point at the USE site, not into the throwaway <paste> buffer: that is
        '' where the user can actually see something (docs/plan/03 section 6.5).
        '' An identifier's spelling and a token's gap are in the buffer and nowhere else --
        '' see PasteNoteOf_.
        if at <> LOC_NONE then
            dim as DecodedLoc id_ = e.src->Decode( t.loc )
            dim as SourceFile ptr idf = e.src->FileAt( id_.file )
            dim as string sp = "", gp = ""
            if (idf <> 0) andalso (Tk( t ) = TK_IDENT) andalso (t.length > 0) andalso _
               ((id_.offset + t.length) <= idf->text.Count) then
                sp = space( t.length )
                memcpy( strptr( sp ), @idf->text[id_.offset], t.length )
                if sp = e.names->Spelling( cast( InternId, t.literal ) ) then sp = ""
            end if
            if (idf <> 0) andalso ((t.flags and TF_SPACE_BEFORE) <> 0) then
                dim as long k = id_.offset
                while (k > 0) andalso ((idf->text[k - 1] = 32) orelse (idf->text[k - 1] = 9))
                    k -= 1
                wend
                if id_.offset - k > 1 then
                    gp = space( id_.offset - k )
                    memcpy( strptr( gp ), @idf->text[k], id_.offset - k )
                end if
            end if
            if (len( sp ) > 0) orelse (len( gp ) > 0) then
                e.pasteLoc.Push( cast( ulong, at ) ) : e.pasteId.Push( cast( ulong, t.literal ) )
                e.pasteKind.Push( cast( ulong, t.kind ) ) : e.pasteText.Push( sp ) : e.pasteGap.Push( gp )
            end if
            t.loc = at
        end if
        t.flags or= TF_FROM_MACRO
        outv.Push( t )
    next
end sub

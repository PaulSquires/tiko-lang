'' ppjoin.bas -- the adjacency re-lex, and the joins inside substitution. Moved out of
'' pp.bas verbatim on 2026-09-27 for the 1500-line cap. #included by pp.bas IN PLACE, inside
'' its 'namespace Tko', where the block stood: it follows SpellOf and RelexInto, which it
'' calls, and precedes macro.bas, which uses PieceVec, PieceMark_ and JoinSubstituted_.

'' ------------------------------------------------------- the adjacency re-lex
'' fbc's preprocessor substitutes TEXT and re-lexes the line, so the LAST token a
'' macro emits and the NEXT token of the enclosing stream become ONE token whenever
'' the source put nothing between them. Measured on fbc 'fbc64 -pp', all of these:
''
''   #define letter(s) #s + letter : #define letter__ ""
''       letter (o)__      ->  $"o" + ""        the fold in pp/hello.bas
''   #define letterX "z"
''       letter (o)X       ->  $"o" + "z"       so it is not about '__'
''       letter (o) __     ->  $"o" + letter  __  and error 89: A SPACE STOPS IT
''   #define M(x) x 12
''       M(a)34            ->  a 1234           NUMBER meets number
''   #define M(x) x <
''       M(a)> 3           ->  a <> 3           OPERATOR meets operator
''   #define M(x) x
''       M(ab)cd           ->  abcd             the ARGUMENT's tail joins too
''   #define M(x) x ab
''       M(q)12            ->  q ab12
''   #define M(x) x "s"
''       M(q)ab            ->  q "s"ab          '"s"ab' re-lexes as TWO; no join
''   #define N 12 : #define M(x) x N
''       M(a)ab            ->  a Nab            the join happens BEFORE the rescan,
''                                              so 'N' never expands
''   #define foobar(z) (z*2) : #define M(y) y foo
''       M(a)bar(3)        ->  a (3*2)          the JOINED name then expands, and
''                                              takes its arguments from the source
''   #define A(x) x q : #define B(x) r x
''       A(1)B(2)          ->  1 qB(2)          'B' is joined away, never invoked
''
'' And the FRONT of an expansion never joins -- fbc emits a space before the result:
''
''   #define A bc :  (A)12  ->  ( bc)12
''
'' So "re-lex the concatenation, and take it only if it comes back as EXACTLY ONE
'' token" is not an approximation of the rule, it IS the rule: the '"s"ab' and the
'' '( bc)12' cases fall out of it rather than needing to be excluded. A pair that
'' re-lexes to two tokens is what "no join" means.
''
'' Three guards, each of which is load-bearing:
''
''   frameFloor + 1 -- an ARGUMENT being expanded on its own (ExpandedArgText_) sits
''   one frame above the floor, and the frame BELOW it is the caller's, not the text
''   this argument is being spliced into. Reaching into it would join an argument's
''   tail onto something it never touches.
''
''   Non-empty spellings -- the only way a bad SpellOf could pass the one-token test
''   is by contributing nothing, which would DELETE a token rather than join two.
''
''   joinTried -- PeekTok is called many times over one position; without it every
''   refusal re-runs the lexer.
private function TryTailJoin_( byref e as PpEngine ) as boolean
    if e.frames.Count <= (e.frameFloor + 1) then return false
    if e.frames.Count < 2 then return false

    dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
    if f->file <> FILE_NONE then return false      '' only an expansion has a seam
    if f->toks = 0 then return false
    if f->pos <> (f->toks->Count - 1) then return false
    if f->joinTried = f->pos then return false
    f->joinTried = f->pos

    dim as Token a = f->toks->At( f->pos )
    dim as TokenKind ka = Tk( a )
    if (ka = TK_EOL) orelse (ka = TK_EOF) then return false

    dim as PpFrame ptr g = @e.frames[e.frames.Count - 2]
    if g->toks = 0 then return false
    if g->pos > (g->toks->Count - 1) then return false
    dim as Token b = g->toks->At( g->pos )
    dim as TokenKind kb = Tk( b )
    if (kb = TK_EOL) orelse (kb = TK_EOF) then return false
    if (b.flags and TF_SPACE_BEFORE) <> 0 then return false
    if (b.flags and TF_AT_LINE_START) <> 0 then return false

    dim as string sa = SpellOf( e, a )
    dim as string sb = SpellOf( e, b )
    if (len( sa ) = 0) orelse (len( sb ) = 0) then return false

    dim as TokenVec jv
    RelexInto( e, sa + sb, a.loc, jv )
    if jv.Count <> 1 then return false

    dim as Token j = jv[0]
    '' The joined token stands where the expansion's tail stood: it takes that token's
    '' leading spacing and line position, never the swallowed one's.
    dim as ushort keep = a.flags and _
        (TF_SPACE_BEFORE or TF_AT_LINE_START or TF_COLON or TF_LINE_JOINED)
    j.flags = (j.flags and (not (TF_SPACE_BEFORE or TF_AT_LINE_START or _
                                 TF_COLON or TF_LINE_JOINED))) or keep
    '' Through a pointer: 'v->At( i ) = x' parses the '=' as equality inside the
    '' argument list (fbc warning 34) and assigns nothing.
    dim as Token ptr slot = @f->toks->At( f->pos )
    *slot = j
    g->pos += 1
    '' A further token may be flush against this one as well -- '(a)(b)__' joins twice.
    f->joinTried = -1
    return true
end function

'' ------------------------------------------------ joins INSIDE a substitution
'' THE SAME RE-LEX, ONE LEVEL IN: where a substituted argument meets the body with
'' nothing between them. fbc substitutes an argument's TEXT into the body's text and
'' re-lexes the result, so the two become ONE token wherever the two spellings lex as
'' one. Measured with 'fbc64 -pp':
''
''   #define m(n) n.5        m(2)      ->  2.5
''   #define m(n) n .5       m(2)      ->  2 .5   and error 3: A SPACE STOPS IT
''   #define m(n) 1n         m(2)      ->  12
''   #define m(n) n.n        m(2)      ->  2.2    two joins, left to right
''   #define m(n) 1en        m(2)      ->  1e2, so 100
''   #define m(a,b) a.b      m(3,)     ->  3.0    an EMPTY argument still joins
''   #define m(op) 1 op= 2   m(<)      ->  1 <= 2
''   #define m(n) "x"n       m("y")    ->  "x""y", the one string x"y
''   #define m(n,k) n##k.5   m(1,2)    ->  12.5   a PASTE's result joins too
''   #define m(n) ne3        m(2)      ->  ne3, an identifier: never the parameter
''
'' tiko spliced the argument's tokens beside the body's, so 'm( 2 )' over 'n.5' was the
'' integer 2 and then the float .5 -- "expected the end of the statement".
''
'' NOT COVERED, and both measured: an argument whose EDGE is itself a macro name joins
'' in fbc, which expands the argument's text first -- '#define two 2' with '1n' gives
'' 12, where tiko splices 'two' and the rescan's own tail join cannot reach the front of
'' an expansion. And '&hn' needs '&h' to survive lexing with no digits after it, which
'' it does not; no corpus file or bundled header writes either shape.
type PieceVec as FB.Array( of long )
type ByteVec as FB.Array( of ubyte )

'' Two tokens, joined if their spellings re-lex as exactly one -- TryTailJoin_'s rule,
'' and its reasons, applied to a seam inside the expansion instead of the one at its end.
private function JoinPair_ _
    ( byref e as PpEngine, byref a as Token, byref b as Token, _
      byref j as Token ) as boolean

    dim as TokenKind ka = Tk( a )
    dim as TokenKind kb = Tk( b )
    if (ka = TK_EOL) orelse (ka = TK_EOF) then return false
    if (kb = TK_EOL) orelse (kb = TK_EOF) then return false
    if ((a.flags or b.flags) and TF_JOIN_MARK) <> 0 then return false

    dim as string sa = SpellOf( e, a )
    dim as string sb = SpellOf( e, b )
    if (len( sa ) = 0) orelse (len( sb ) = 0) then return false
    '' No token of the language begins or ends with one of these, so a parameter's
    '' commonest neighbours -- 'f( n )', 'a, n', 'n )' -- cost no re-lex at all.
    if instr( "()[]{},;:", right( sa, 1 ) ) > 0 then return false
    if instr( "()[]{},;:", left( sb, 1 ) ) > 0 then return false

    '' A RE-LEX THAT REPORTS SOMETHING IS NOT A JOIN: '&' against 'hx' would say "'&' is
    '' not followed by any digits" about text nobody wrote. Diagnostics are buffered
    '' until Flush, so a speculative one is taken back off the pending list.
    dim as long e0 = e.diags->errors
    dim as long w0 = e.diags->warnings
    dim as long p0 = e.diags->pending.Count
    dim as TokenVec jv
    RelexInto( e, sa + sb, a.loc, jv )
    dim as boolean reported = (e.diags->errors <> e0) orelse (e.diags->warnings <> w0)
    if e.diags->pending.Count <> p0 then reported = true
    if reported then
        while e.diags->pending.Count > p0
            e.diags->pending.Pop( )
        wend
        e.diags->errors = e0
        e.diags->warnings = w0
        return false
    end if
    if jv.Count <> 1 then return false

    j = jv[0]
    '' The joined token stands where the LEFT one stood: it takes that token's leading
    '' spacing and line position, never the swallowed one's.
    dim as ushort keep = a.flags and _
        (TF_SPACE_BEFORE or TF_AT_LINE_START or TF_COLON or TF_LINE_JOINED)
    j.flags = (j.flags and (not (TF_SPACE_BEFORE or TF_AT_LINE_START or _
                                 TF_COLON or TF_LINE_JOINED))) or keep
    j.flags or= TF_FROM_MACRO
    return true
end function

'' One substituted run, as three numbers: where it starts in the output, where it ends
'' (BELOW the start for an empty argument), and whether the body had no space in front
'' of it.
private sub PieceMark_ _
    ( byref pieces as PieceVec, byval first as long, byval last_ as long, _
      byval bodyFlags as ushort )
    pieces.Push( first )
    pieces.Push( last_ )
    dim as long g = 0
    if (bodyFlags and TF_SPACE_BEFORE) = 0 then g = 1
    pieces.Push( g )
end sub

'' Walk the finished body and join every seam that TOUCHES a substituted run. Two body
'' tokens are left alone -- they were lexed together already -- and so are the tokens
'' INSIDE an argument, which keep the spacing the call wrote.
private sub JoinSubstituted_ _
    ( byref e as PpEngine, byref toks as TokenVec, byref pieces as PieceVec )

    if pieces.Count = 0 then return
    dim as long n = toks.Count
    if n < 2 then return

    '' 0 a body token, 1 the first token of a substituted run, 2 inside one.
    dim as ByteVec kind_
    dim as ByteVec glued
    for i as long = 0 to n - 1
        kind_.Push( 0 )
        dim as ubyte gb = 0
        if (toks[i].flags and TF_SPACE_BEFORE) = 0 then gb = 1
        glued.Push( gb )
    next

    for pi as long = 0 to pieces.Count - 3 step 3
        dim as long f = pieces[pi]
        dim as long l = pieces[pi + 1]
        dim as boolean g = (pieces[pi + 2] <> 0)
        if f >= n then continue for
        if f > l then
            '' AN EMPTY ARGUMENT still lets its neighbours meet: '#define m(a,b) a.b'
            '' invoked as 'm( 3, )' is '3.' to fbc, a DOUBLE.
            if (kind_[f] = 0) andalso g then kind_[f] = 1
            continue for
        end if
        kind_[f] = 1
        if g then glued[f] = 1 else glued[f] = 0
        for i as long = f + 1 to l
            if i < n then kind_[i] = 2
        next
    next

    dim as TokenVec outv
    dim as ByteVec outKind
    for i as long = 0 to n - 1
        dim as boolean tryJoin = (outv.Count > 0) andalso (kind_[i] <> 2)
        if tryJoin then tryJoin = (glued[i] <> 0)
        if tryJoin then tryJoin = (kind_[i] = 1) orelse (outKind[outKind.Count - 1] <> 0)
        if tryJoin then
            dim as Token j
            if JoinPair_( e, outv.At( outv.Count - 1 ), toks[i], j ) then
                '' Through a pointer, as TryTailJoin_ does: 'v.At( i ) = x' reads the
                '' '=' as equality inside the argument list and assigns nothing.
                dim as Token ptr slot = @outv.At( outv.Count - 1 )
                *slot = j
                dim as ubyte ptr kslot = @outKind.At( outKind.Count - 1 )
                *kslot = 1
                continue for
            end if
        end if
        outv.Push( toks[i] )
        outKind.Push( kind_[i] )
    next

    toks.Clear( )
    for i as long = 0 to outv.Count - 1
        toks.Push( outv[i] )
    next
end sub

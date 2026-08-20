'' pp.bas -- see pp.bi
''
'' The engine is a stack of token FRAMES. A frame is either a file's token vector or
'' a macro expansion buffer. Next( ) pops exhausted frames, which is what makes
'' include and expansion the same mechanism and gives hide sets for free: a macro is
'' hidden exactly while one of its own frames is on the stack.

#include once "pp/pp.bi"
#include once "support/text.bi"
#include once "fb/filesystem.bi"

namespace Fbx

'' ------------------------------------------------------------------ the state

type PpFrame
    as TokenVec ptr toks
    as long      pos
    as InternId  hides         '' macro whose expansion this is; 0 for a file
    as FileId    file          '' 0 for an expansion buffer
    as boolean   owned         '' expansion buffers are ours to delete
end type

type PpCond
    as boolean   active        '' emitting in this branch
    as boolean   taken         '' some branch of this #if already ran
    as boolean   parentActive
    as boolean   seenElse
    as SourceLoc loc
end type

type PpEngine
    as SourceManager ptr src
    as Interner ptr      names
    as KeywordMap ptr    kw
    as DiagnosticEngine ptr diags
    as PpConfig ptr      cfg
    as PpResult ptr      outp

    as FB.Array( of PpFrame ) frames
    as FB.Array( of PpCond )  conds
    as MacroVec               macros
    as IdVec                  macroSlot     '' InternId -> macros index + 1
    as FB.Array( of any ptr ) lexed         '' Lex.Result ptr, one per FileId
    as IdVec                  onceFiles     '' FileId values marked #include once
    as FileId                 rootFile
    as long                   uniqueCounter
    as boolean                stopped
end type

'' --------------------------------------------------------------- small helpers

private function Tk( byref t as Token ) as TokenKind
    return cast( TokenKind, t.kind )
end function

private function SlotOf( byref e as PpEngine, byval id as InternId ) as long
    if id = INTERN_NONE then return 0
    if cast( long, id ) >= e.macroSlot.Count then return 0
    return cast( long, e.macroSlot[cast( long, id )] )
end function

private sub SetSlot( byref e as PpEngine, byval id as InternId, byval slot as long )
    while e.macroSlot.Count <= cast( long, id )
        e.macroSlot.Push( 0 )
    wend
    e.macroSlot[cast( long, id )] = cast( ulong, slot )
end sub

private function MacroFor( byref e as PpEngine, byval id as InternId ) as PpMacro ptr
    dim as long slot = SlotOf( e, id )
    if slot = 0 then return 0
    dim as PpMacro ptr m = @e.macros[slot - 1]
    if m->isDefined = false then return 0
    return m
end function

private function IsHidden( byref e as PpEngine, byval id as InternId ) as boolean
    for i as long = 0 to e.frames.Count - 1
        if e.frames[i].hides = id then return true
    next
    return false
end function

private function Emitting( byref e as PpEngine ) as boolean
    if e.conds.IsEmpty( ) then return true
    return e.conds[e.conds.Count - 1].active
end function

private sub Report _
    ( byref e as PpEngine, byval id as DiagId, byval at as SourceLoc, _
      byval a0 as string = "", byval a1 as string = "" )
    e.diags->Report( id, PointRange( at ), a0, a1 )
end sub

'' ---------------------------------------------------------------- token access
'' The frame stack is the whole engine. Everything else is bookkeeping on top.

private sub PushFrame _
    ( byref e as PpEngine, byval toks as TokenVec ptr, byval hides as InternId, _
      byval file as FileId, byval owned as boolean )

    if e.frames.Count >= PP_MAX_FRAMES then
        Report( e, FBX0304, LOC_NONE, str( PP_MAX_FRAMES ) )
        e.stopped = true
        return
    end if

    dim as PpFrame f
    f.toks = toks
    f.pos = 0
    f.hides = hides
    f.file = file
    f.owned = owned
    e.frames.Push( f )
    if e.frames.Count > e.outp->maxDepth then e.outp->maxDepth = e.frames.Count
end sub

private sub PopFrame( byref e as PpEngine )
    if e.frames.IsEmpty( ) then return
    dim as PpFrame f = e.frames[e.frames.Count - 1]
    e.frames.Pop( )
    if f.owned andalso (f.toks <> 0) then delete f.toks
end sub

'' Peek the next token without consuming, skipping exhausted frames. Returns false at
'' the very end of everything.
private function PeekTok( byref e as PpEngine, byref outTok as Token ) as boolean
    while e.frames.Count > 0
        dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
        '' A file frame's trailing TK_EOF is consumed by the include machinery, not
        '' handed out: only the root's EOF reaches the output.
        dim as long last = f->toks->Count - 1
        if f->pos > last then
            PopFrame( e )
            continue while
        end if
        dim as Token t = f->toks->At( f->pos )
        dim as boolean fileEof = (f->file <> FILE_NONE) andalso (Tk( t ) = TK_EOF)
        if fileEof andalso (e.frames.Count > 1) then
            PopFrame( e )
            continue while
        end if
        outTok = t
        return true
    wend
    return false
end function

private sub Advance( byref e as PpEngine )
    if e.frames.IsEmpty( ) then return
    e.frames[e.frames.Count - 1].pos += 1
end sub

'' Next token on the CURRENT line of the current frame, without crossing TK_EOL.
'' Directives are line-scoped, so every directive parser uses this.
private function PeekOnLine( byref e as PpEngine, byref outTok as Token ) as boolean
    if e.frames.IsEmpty( ) then return false
    dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
    if f->pos > f->toks->Count - 1 then return false
    dim as Token t = f->toks->At( f->pos )
    dim as boolean ends = (Tk( t ) = TK_EOL) orelse (Tk( t ) = TK_EOF)
    if ends then return false
    outTok = t
    return true
end function

private sub SkipToEol( byref e as PpEngine )
    dim as Token t
    while PeekOnLine( e, t )
        Advance( e )
    wend
end sub

'' Collect the rest of the directive line, unexpanded.
private sub CollectLine _
    ( byref e as PpEngine, byref outv as TokenVec, _
      byval throughColon as boolean = false )
    while e.frames.IsEmpty( ) = false
        dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
        if f->pos > f->toks->Count - 1 then exit while
        dim as Token t = f->toks->At( f->pos )
        if Tk( t ) = TK_EOF then exit while
        if Tk( t ) = TK_EOL then
            if throughColon = false then exit while
            if (t.flags and TF_COLON) = 0 then exit while
        end if
        outv.Push( t )
        Advance( e )
    wend
end sub

private sub EmitTok( byref e as PpEngine, byref t as Token )
    e.outp->tokens.Push( t )
end sub

'' -------------------------------------------------------------- token spelling
'' Needed by stringisation and by ## pasting, both of which work on source text.

private function SpellOf( byref e as PpEngine, byref t as Token ) as string
    dim as TokenKind k = Tk( t )
    if k = TK_IDENT then
        '' The FOLDED spelling is in the interner; the original is in the source.
        dim as DecodedLoc d = e.src->Decode( t.loc )
        dim as SourceFile ptr f = e.src->FileAt( d.file )
        if (f <> 0) andalso (t.length > 0) then
            dim as string s = space( t.length )
            memcpy( strptr( s ), @f->text[d.offset], t.length )
            return s
        end if
        return e.names->Spelling( cast( InternId, t.literal ) )
    end if

    dim as string spellText = TokenKindText( k )
    if len( spellText ) > 0 then return spellText

    '' A LITERAL's text comes from ITS OWN recorded file and span, never from the token's
    '' loc. RelexInto repoints synthesised tokens at the use site so diagnostics land
    '' somewhere visible, and reading the span at that loc then returned the INVOCATION's
    '' source text -- which is what made '#param' echo the macro call instead of the
    '' argument.
    dim as boolean isLit = (k = TK_INT_LIT) orelse (k = TK_FLOAT_LIT) orelse _
                           (k = TK_STRING_LIT)
    if isLit then
        dim as long li = cast( long, t.literal )
        if (li >= 0) andalso (li < e.outp->literals.Count) then
            dim as Literal ptr lp = @e.outp->literals[li]
            dim as SourceFile ptr lf = e.src->FileAt( cast( FileId, lp->textFile ) )
            if (lf <> 0) andalso (lp->textLength > 0) then
                if (lp->textOffset + lp->textLength) <= lf->text.Count then
                    dim as string ls = space( lp->textLength )
                    memcpy( strptr( ls ), @lf->text[lp->textOffset], lp->textLength )
                    '' The span excludes the quotes, which the spelling must carry.
                    if k = TK_STRING_LIT then return """" & ls & """"
                    return ls
                end if
            end if
            if k = TK_STRING_LIT then return """"""
        end if
    end if

    '' Anything else: the exact source span at the token's location.
    dim as DecodedLoc d = e.src->Decode( t.loc )
    dim as SourceFile ptr f = e.src->FileAt( d.file )
    if (f = 0) orelse (t.length = 0) then return ""
    dim as string s = space( t.length )
    memcpy( strptr( s ), @f->text[d.offset], t.length )
    return s
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
        e.outp->literals.Push( from[idx] )
        toks[i].literal = cast( ulong, e.outp->literals.Count - 1 )
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
        '' Point at the USE site, not into the throwaway <paste> buffer: that is
        '' where the user can actually see something (docs/plan/03 section 6.5).
        if at <> LOC_NONE then t.loc = at
        t.flags or= TF_FROM_MACRO
        outv.Push( t )
    next
end sub

'' Forward declarations: the three parts below reference each other freely, and the
'' main loop below them references all three. They are #included rather than compiled
'' separately so the whole preprocessor is one translation unit.
declare function PpEvalCondition _
    ( byref e as PpEngine, byref toks as TokenVec, byref ok as boolean ) as boolean
declare function PpExpand _
    ( byref e as PpEngine, byval m as PpMacro ptr, byref use as Token ) as boolean
declare sub PpDefine( byref e as PpEngine, byval at as SourceLoc, byval isBlock as boolean )
declare sub PpUndef( byref e as PpEngine, byval at as SourceLoc )
declare sub PpDirective( byref e as PpEngine, byref hashTok as Token )
declare function PpLexFile( byref e as PpEngine, byval file as FileId ) as TokenVec ptr
declare function IsDirectiveWord( byval w as string ) as boolean
declare sub PpDefineBuiltins( byref e as PpEngine )
declare sub PpDefineFromCommandLine( byref e as PpEngine )
declare function PpFindOrAddMacro( byref e as PpEngine, byval id as InternId ) as PpMacro ptr

end namespace

#include once "pp/ppexpr.bas"
#include once "pp/macro.bas"
#include once "pp/directive.bas"

namespace Fbx

'' ------------------------------------------------------------------- the loop

'' ------------------------------------------------------------------- the pump
''
'' One iteration of the old monolithic loop, restructured so it can stop after
'' emitting a single token. Everything else about it is unchanged: this is the same
'' logic, driven differently.

private sub PpFinish( byref e as PpEngine )
    '' Unbalanced conditionals are the user's error, reported once per open block.
    while e.conds.IsEmpty( ) = false
        Report( e, FBX0303, e.conds[e.conds.Count - 1].loc )
        e.conds.Pop( )
    wend

    dim as Token eof
    eof.kind = cast( ushort, TK_EOF )
    eof.flags = TF_AT_LINE_START
    eof.loc = e.src->LocFor( e.rootFile, 0 )
    eof.length = 0
    eof.literal = 0
    e.outp->tokens.Push( eof )
end sub

'' Advance the engine until it has emitted at least one token, or input is done.
'' Returns false when nothing more will ever be produced.
private function PpStep( byref e as PpEngine ) as boolean
    dim as long before = e.outp->tokens.Count

    do
        if e.stopped then return false

        dim as Token t
        if PeekTok( e, t ) = false then return false

        dim as TokenKind k = Tk( t )

        '' ---- a directive: '#' at the start of a line.
        '' Recognised in EXPANSION frames as well as file frames: a '#macro' body may
        '' contain '#if', and fbc evaluates it at expansion time (probe P1). Dropping
        '' this emits BOTH branches of every such conditional -- wrong output that
        '' merely happens to parse, which is why the corpus numbers LOOK better
        '' without it. They are not.
        dim as boolean isHash = (k = TK_HASH)
        dim as boolean atLineStart = (t.flags and TF_AT_LINE_START) <> 0
        if isHash andalso atLineStart then
            Advance( e )
            PpDirective( e, t )
            continue do
        end if

        '' ---- inside a false #if branch nothing else matters
        if Emitting( e ) = false then
            Advance( e )
            continue do
        end if

        '' ---- a macro name expands; anything else is output
        if k = TK_IDENT then
            dim as InternId id = cast( InternId, t.literal )
            dim as PpMacro ptr m = MacroFor( e, id )
            dim as boolean expandable = (m <> 0) andalso (IsHidden( e, id ) = false)
            if expandable then
                if PpExpand( e, m, t ) then continue do
            end if
        end if

        Advance( e )
        EmitTok( e, t )
        if e.outp->tokens.Count > before then return true
    loop
end function

sub PpOpen _
    ( byref st as PpStream, byref src as SourceManager, byval root as FileId, _
      byref names as Interner, byref kwmap as KeywordMap, _
      byref diags as DiagnosticEngine, byref cfg as PpConfig, _
      byref outp as PpResult )

    dim as PpEngine ptr e = new PpEngine
    e->src = @src
    e->names = @names
    e->kw = @kwmap
    e->diags = @diags
    e->cfg = @cfg
    e->outp = @outp
    e->rootFile = root
    e->uniqueCounter = 0
    e->stopped = false

    st.engine = e
    st.outp = @outp
    st.finished = false

    PpDefineBuiltins( *e )
    PpDefineFromCommandLine( *e )

    dim as TokenVec ptr rootToks = PpLexFile( *e, root )
    if rootToks = 0 then
        PpFinish( *e )
        st.finished = true
        return
    end if
    PushFrame( *e, rootToks, INTERN_NONE, root, false )
end sub

function PpEnsure( byref st as PpStream, byval want as long ) as boolean
    if st.engine = 0 then return false
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )

    while st.outp->tokens.Count <= want
        if st.finished then return false
        if PpStep( *e ) = false then
            PpFinish( *e )
            st.finished = true
            return (st.outp->tokens.Count > want)
        end if
    wend
    return true
end function

sub PpClose( byref st as PpStream )
    if st.engine = 0 then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    while e->frames.IsEmpty( ) = false
        PopFrame( *e )
    wend
    for each p as any ptr in e->lexed
        if p <> 0 then delete cast( Lex.Result ptr, p )
    next
    delete e
    st.engine = 0
end sub

sub PpRun _
    ( byref src as SourceManager, byval root as FileId, _
      byref names as Interner, byref kwmap as KeywordMap, _
      byref diags as DiagnosticEngine, byref cfg as PpConfig, _
      byref outp as PpResult )

    dim as PpStream st
    PpOpen( st, src, root, names, kwmap, diags, cfg, outp )
    dim as long i = 0
    while PpEnsure( st, i )
        i += 1
    wend
    PpClose( st )
end sub

'' ----------------------------------------------------------------------- dump

function PpDump _
    ( byref src as SourceManager, byref names as Interner, _
      byref r as PpResult ) as string

    dim as string outp = ""
    outp += "preprocessed: " & r.tokens.Count & " tokens, " & _
            r.includeCount & " includes, " & r.expansionCount & " expansions, " & _
            "depth " & r.maxDepth & chr( 10 )

    dim as long index = 0
    for each t as Token in r.tokens
        dim as DecodedLoc d = src.Decode( t.loc )
        dim as TokenKind k = cast( TokenKind, t.kind )

        dim as string row = ""
        row += right( "     " & str( index ), 5 ) & " "
        row += right( "    " & str( d.lineNo ), 4 ) & ":"
        row += left( str( d.column ) & "    ", 4 ) & " "
        row += left( TokenKindName( k ) & "                    ", 20 )

        if k = TK_IDENT then
            row += "'" & names.Spelling( cast( InternId, t.literal ) ) & "'"
        else
            dim as string spellText = TokenKindText( k )
            if len( spellText ) > 0 then row += "'" & spellText & "'"
        end if

        if (t.flags and TF_FROM_MACRO) <> 0 then row += " [macro]"
        outp += rtrim( row ) & chr( 10 )
        index += 1
    next
    return outp
end function

end namespace

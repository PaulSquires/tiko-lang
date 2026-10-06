'' pp.bas -- see pp.bi
''
'' The engine is a stack of token FRAMES. A frame is either a file's token vector or
'' a macro expansion buffer. Next( ) pops exhausted frames, which is what makes
'' include and expansion the same mechanism and gives hide sets for free: a macro is
'' hidden exactly while one of its own frames is on the stack.

#include once "pp/pp.bi"
#include once "pp/ppmodule.bi"
#include once "support/text.bi"
#include once "fb/filesystem.bi"

namespace Tko

'' ------------------------------------------------------------------ the state

type PpFrame
    as TokenVec ptr toks
    as long      pos
    as InternId  hides         '' macro whose expansion this is; 0 for a file
    as FileId    file          '' 0 for an expansion buffer
    as boolean   owned         '' expansion buffers are ours to delete
    '' The position TryTailJoin_ has already looked at and refused, so a peek that
    '' happens ten times over the same token re-lexes the pair once. -1 is "not yet".
    as long      joinTried
    '' WHERE THE MACRO NAME THAT OPENED THIS FRAME WAS WRITTEN. LOC_NONE for a file
    '' frame and for the internal buffers that are not a macro use.
    ''
    '' __LINE__ and __FILE__ inside a macro body have to answer for the USE site, and
    '' the body token's own loc is the DEFINITION site. Measured on fbc 1.10, with the
    '' body on line 1 of the file:
    ''
    ''     #define where_(e) print __LINE__       used on lines 3 and 4
    ''                                            fbc: 3 then 4    tiko-lang: 1 twice
    ''     #define inner_ __LINE__ / #define outer_ inner_   in an INCLUDED header
    ''                                            fbc: the includER's line, and
    ''                                            __FILE__ likewise names the
    ''                                            includER -- tiko-lang named the .bi
    ''
    '' So it is the OUTERMOST expansion that answers, not the innermost, which is why
    '' this is a per-frame field read from the bottom of the expansion stack rather
    '' than the 'use' token PpExpandBuiltin already has. Every fbcunit assertion in the
    '' corpus reported its '#define' line instead of the failing line without it.
    as SourceLoc useLoc
    '' ...BUT __LINE__ ANSWERS FOR THE INVOCATION'S END: measured, fbc prints 4 for a call
    '' written 'SHOW( 1, _' on line 3 and '2 )' on line 4, and 7 for one spanning 5 to 7.
    '' The closing ')' -- or useLoc when there is none (audit LEX16).
    as SourceLoc lineLoc
    '' A MODULE'S INTERFACE (RFC-0004 §5): read as the module wrote it -- no macro of the
    '' importer's expands inside it.
    as boolean   iface
    '' ...and it, and every header it includes, is read FOR AN '#import': none of it ends
    '' the importer's header, so the next '#import' is still allowed. Inherited by every
    '' frame pushed above one.
    as boolean   inImport
end type

type PpCond
    as boolean   active        '' emitting in this branch
    as boolean   taken         '' some branch of this #if already ran
    as boolean   parentActive
    as boolean   seenElse
    as SourceLoc loc
    as string    userName      '' first non-predefined name its conditions read (ppmodule.bas)
end type

'' How deep '#pragma push' may nest per option before it is refused.
const PP_OPTION_STACK_MAX = 32

type PpEngine
    '' How deep PpReadArgs' eager expansion is nested -- see its use in macro.bas.
    as long argNest
    as SourceManager ptr src
    as Interner ptr      names
    as KeywordMap ptr    kw
    as DiagnosticEngine ptr diags
    as PpConfig ptr      cfg
    as PpResult ptr      outp

    as FB.Array( of PpFrame ) frames
    '' THE LOWEST FRAME COUNT PeekTok MAY POP TO. Zero everywhere except inside a
    '' builtin that is expanding ONE ARGUMENT of its own -- see ExpandedArgText_.
    ''
    '' PeekTok pops exhausted frames until it finds a token, and it had no floor: when
    '' a nested builtin's ')' was the LAST token of the frame that contained it, the
    '' cascade ran on past that frame and past the enclosing macro body's, deleting
    '' both. The inner builtin then pushed its result onto a stack shorter than the
    '' outer walk's own baseDepth, so the outer loop stopped immediately and returned
    '' "", and the orphaned frame drained into the main output instead --
    ''
    ''     #define q __FB_QUOTE__( __FB_ARG_COUNT__( a, b, c ) )
    ''     print q      fbc: print $"3"      tiko: an EMPTY string, then a stray 3
    ''
    '' PeekOnLine's own pop is deliberately NOT floored: a synthesised directive
    '' continuing onto the invoking line depends on crossing exactly that boundary.
    as long                   frameFloor
    as FB.Array( of PpCond )  conds
    as MacroVec               macros
    as IdVec                  macroSlot     '' InternId -> macros index + 1
    '' THE NAMES THE PARSER HAS DECLARED SO FAR, so 'defined( X )' can answer for a
    '' TYPE, ENUM, CONST or module-level DIM and not only for a macro. Indexed by
    '' InternId exactly as macroSlot is; non-zero means declared.
    ''
    '' It works because the preprocessor is PULL-BASED: the parser drives it, so by
    '' the time a '#ifndef' is evaluated the parser has already read everything above
    '' it. The information was always there at the right moment -- nothing recorded it
    '' anywhere this side could reach. AfxD2D1.bi guards 'type D3DCOLORVALUE' with
    '' '#ifndef D3DCOLORVALUE' 737 lines after declaring it, and 74 of AfxNova's
    '' examples stopped on the second definition.
    ''
    '' AN APPROXIMATION OF fbc's SYMBOL TABLE, and deliberately a small one: it knows
    '' nothing of scopes, overloads or types. What it answers is exactly the question
    '' a header guard asks -- has this name been declared above me.
    as IdVec                  declaredMark
    '' ...AND THE ONES DECLARED OUTSIDE ANY NAMESPACE, by folded id: what a '#define' may
    '' not take (TKO0371). fbc's '#define' over 'N.foo' at module level is fine.
    as IdVec                  topDeclared
    '' ...AND THE ONES DECLARED IN A NAMESPACE, by folded id: "|fb|a.b|", the namespaces
    '' that declare it. A '#define' may not take one of those either once a module-level
    '' 'using' has imported the namespace -- usingPaths, "|fb|" (TKO0371).
    as StrVec                 nsMemberOf
    as string                 usingPaths
    '' ...AND THE VALUE, for the ones that have one. FreeBASIC's '#if' reads a CONST
    '' like any other term -- measured, 'const K = 5' then '#if K = 5' takes the true
    '' branch under fbc and did not under tiko-lang, because an identifier that
    '' survived expansion was read as an undefined macro and an undefined macro is 0.
    '' win/_mingw.bi declares '_WIN32_WINNT' as a const rather than a macro, so every
    '' '#if _WIN32_WINNT >= &h0600' in the Windows headers took the FALSE branch and
    '' the Vista-and-later half of them was never compiled.
    ''
    '' Filled by the PARSER, which is sound for the same reason the marks beside it
    '' are: the preprocessor is pull-based, so everything above this directive has
    '' already been read. Only what folds to an integer at PARSE time is recorded --
    '' a literal, a negated literal, or another const already known -- and a name with
    '' no value keeps the old answer of 0 rather than guessing.
    as IdVec                  constMark
    as FB.Array( of longint ) constVal
    '' WHAT '#if typeof( name )' READS (T61), filled by the parser on the same terms: by
    '' folded InternId, a variable's declared type and a typedef's target as a KEY --
    '' 'K<token kind>' for a builtin or 'N<InternId>' for a named type, then ' ptr' per
    '' level -- or "" for none; and a mark on each TYPE, UNION and ENUM name, the types
    '' that are their own answer. Only what the parser could spell is recorded: a 'var'
    '' or a parameter is not, and keeps the old TKO0308 rather than a guess.
    as StrVec                 varTypeKey
    as StrVec                 typedefKey
    as IdVec                  typeNameMark
    '' ...AND WHERE: by folded id, the namespaces declaring a type of that name, "|ns|" each
    '' and "||" for none; every 'using' as "|from>to|"; and the namespace being parsed.
    '' fbc's 'typeof' names a type IN FULL -- 'N1.T' -- and finds a bare 'T' in the current
    '' namespace, then the enclosing ones, then through the usings (namespace/ns-using*.bas).
    as StrVec                 typeNs
    as string                 usingIn
    as string                 curNs
    as FB.Array( of any ptr ) lexed         '' Lex.Result ptr, one per FileId
    '' WHERE THE LITERALS AND THE LEXED FILES ACTUALLY LIVE -- this engine's own, or
    '' the invocation's shared ones. See PpConfig.sharedLits.
    as LiteralVec ptr             lits
    as FB.Array( of any ptr ) ptr lexp
    as boolean                    ownsLexed
    as IdVec                  onceFiles     '' FileId values marked #include once
    '' EVERY file included so far, once or not: '#include once' skips one already in here
    '' -- measured, fbc does, after a plain '#include' of it (audit F-54).
    as IdVec                  allIncluded
    as FileId                 rootFile
    as long                   uniqueCounter
    '' '##_' AT THE END OF A MACRO BODY LINE IS A LINE JOIN, and what it joins is the
    '' NEXT END OF LINE -- wherever that comes from. Measured on fbc, three shapes:
    ''
    ''   #macro M() : dim q as long = 1 + ##_ : 2 : print q : #endmacro
    ''       'dim q as long = 1 + 2' then a NEW line for 'print q'. Exactly one EOL
    ''       goes, the body's own, and the one after '2' stays
    ''
    ''   #macro N() : dim r as long = 3 + ##_ : #endmacro   then  N() / 4
    ''       'dim r as long = 3 + 4'. Here the EOL that goes is the INVOCATION's, so
    ''       the rule cannot be "drop a body EOL" -- it is "drop the next one"
    ''
    ''   #define ENT(x) x, ##_    over  BEGIN() / ENT(1) / ENT(2) / END()
    ''       the whole array initialiser becomes one statement, which is what
    ''       pp/token-pasting.bas is for
    ''
    '' '##' at end of line WITHOUT the '_' is not this: fbc reports error 9 and the '#'
    '' survives into the output. Only the pair joins.
    as boolean                eatNextEol
    '' __FB_UNIQUEID__ IS A STACK PER NAME, not a fresh id per use. Measured:
    ''
    ''     __fb_uniqueid_push__( k )   a NEW id becomes k's current one
    ''     __fb_uniqueid__( k )        THE SAME id every time until a push or pop
    ''     __fb_uniqueid_pop__( k )    k's previous id is current again
    ''
    '' Two parallel arrays used as one stack: names are interned, so the top entry
    '' for a name is found by scanning backwards. The stacks are shallow (the
    '' fbcunit headers nest two deep) so a linear scan is the right shape.
    '' '#pragma reserve' -- one entry per directive, the name and the modes it claimed.
    '' PLAIN, ASM and EXTERN are three INDEPENDENT modes: measured, '(asm)' then
    '' '(extern)' is accepted and either one twice is fbc's error 4, and a BARE reserve is
    '' its own mode rather than both of the others -- 'reserve x' then 'reserve (asm) x'
    '' is accepted while 'reserve x' twice is not.
    as IdVec                  reserveNames
    as IdVec                  reserveModes
    as IdVec                  uidNames      '' InternId, innermost last
    as IdVec                  uidValues     '' the counter value that name maps to
    as boolean                stopped

    '' '#undef' OF A KEYWORD -- see DereserveKw_. Index = TokenKind, value = the
    '' InternId of that keyword's folded spelling once it has been de-reserved, and
    '' 0 while it is still a keyword.
    as IdVec                  dereserved

    '' BLOCK NESTING, counted on the tokens that reach the OUTPUT -- so a 'sub'
    '' that arrived through a macro expansion counts, which is how fbcunit's TEST
    '' opens one. Only SUB, FUNCTION and SCOPE are tracked: they are the forms the
    '' corpus defines macros inside, and counting a form wrongly would undefine
    '' macros EARLY, which is worse than the over-permissiveness it replaces.
    as long                   blockDepth
    as ushort                 prevKw        '' the last keyword emitted, for END
    '' The statement being emitted has had a token that is not PRIVATE or PUBLIC: a SUB,
    '' FUNCTION or SCOPE after one is no definition's head (see PpTrackBlock).
    as boolean                stmtDirty

    '' '#pragma private' / '#pragma profile' and their push/pop stacks. Two options,
    '' each a boolean reported through a predefined macro; index 0 is private, 1 is
    '' profile. Fixed-size because the pragma is a nesting marker in a header, not a
    '' data structure -- and fbc itself errors on underflow rather than growing.
    as long                   optionValue( 0 to 1 )
    as long                   optionDepth( 0 to 1 )
    as long                   optionStack( 0 to (2 * PP_OPTION_STACK_MAX) - 1 )
    as PpModState             modst         '' '#module' / '#import' / '#export': ppmodule.bas
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

'' DECLARED-NAME MARKS. Kept on the engine, set by the parser through the stream, and
'' read by 'defined'. The slot array grows on demand exactly as macroSlot's does; an
'' InternId past the end has simply not been declared.
private sub MarkDeclared_( byref e as PpEngine, byval id as InternId, byval kind as long = 1 )
    if id = INTERN_NONE then return
    dim as long ix = cast( long, id )
    while e.declaredMark.Count <= ix
        e.declaredMark.Push( 0 )
    wend
    e.declaredMark[ix] = cast( ulong, iif( kind < 1, 1, kind ) )
end sub

'' THE KIND a declared name was noted with -- parser/declkind.bas -- or 0 for none.
private function DeclaredKind_( byref e as PpEngine, byval id as InternId ) as long
    if id = INTERN_NONE then return 0
    dim as long ix = cast( long, id )
    if ix >= e.declaredMark.Count then return 0
    return cast( long, e.declaredMark[ix] )
end function

private function IsDeclared_( byref e as PpEngine, byval id as InternId ) as boolean
    if id = INTERN_NONE then return false
    dim as long ix = cast( long, id )
    if ix >= e.declaredMark.Count then return false
    return (e.declaredMark[ix] <> 0)
end function

'' DEFINED TO '#ifdef' AND 'defined( )' THOUGH THE PARSER EXPANDS THEM: '__FUNCTION__',
'' '__FUNCTION_NQ__' and '__FB_QUERY_SYMBOL__'. Measured, fbc takes the true branch for all
'' three; tiko took none.
private function IsDefinedBuiltin_( byref e as PpEngine, byval id as InternId ) as boolean
    if IsDeclared_( e, id ) then return true
    if id = INTERN_NONE then return false
    dim as string s = lcase( e.names->Spelling( id ) )
    return (s = "__function__") orelse (s = "__function_nq__") orelse (s = "__fb_query_symbol__")
end function

private sub MarkConst_ _
    ( byref e as PpEngine, byval id as InternId, byval v as longint )

    if id = INTERN_NONE then return
    dim as long ix = cast( long, id )
    while e.constMark.Count <= ix
        e.constMark.Push( 0 )
        e.constVal.Push( 0 )
    wend
    e.constMark[ix] = 1
    e.constVal[ix] = v
end sub

'' A declaration in a module's interface: not the importer's name (RFC-0004 §5).
private function InIfaceFile_( byref e as PpEngine, byval at as SourceLoc ) as boolean
    if (at = LOC_NONE) orelse (e.modst.ifaceFiles.Count = 0) then return false
    dim as ulong f = cast( ulong, e.src->Decode( at ).file )
    for each x as ulong in e.modst.ifaceFiles
        if x = f then return true
    next
    return false
end function

sub PpNoteConst _
    ( byref st as PpStream, byval nm as InternId, byval v as longint, _
      byval at as SourceLoc )
    if st.engine = 0 then return
    if InIfaceFile_( *cast( PpEngine ptr, st.engine ), at ) then return
    MarkConst_( *cast( PpEngine ptr, st.engine ), nm, v )
end sub

'' The value a '#if' should read for a name, when the parser has recorded one.
function PpConstValue _
    ( byref e as PpEngine, byval nm as InternId, byref outv as longint ) as boolean

    if nm = INTERN_NONE then return false
    dim as long ix = cast( long, nm )
    if ix >= e.constMark.Count then return false
    if e.constMark[ix] = 0 then return false
    outv = e.constVal[ix]
    return true
end function

'' Whether a name has a recorded value at all -- the parser asks, so a const built
'' from another one can copy it.
function PpNotedConst _
    ( byref st as PpStream, byval nm as InternId, byref outv as longint ) as boolean
    if st.engine = 0 then return false
    return PpConstValue( *cast( PpEngine ptr, st.engine ), nm, outv )
end function

sub PpNoteType _
    ( byref st as PpStream, byval nm as InternId, byref key as string, _
      byval what as long, byval at as SourceLoc )
    if (st.engine = 0) orelse (nm = INTERN_NONE) then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    if InIfaceFile_( *e, at ) then return
    dim as long ix = cast( long, e->names->Fold( nm ) )
    select case what
    case PP_TYPE_NAMED
        while e->typeNameMark.Count <= ix
            e->typeNameMark.Push( 0 )
        wend
        e->typeNameMark[ix] = 1
    case PP_TYPE_TYPEDEF
        if len( key ) = 0 then return
        while e->typedefKey.Count <= ix
            e->typedefKey.Push( "" )
        wend
        e->typedefKey[ix] = key
    case else
        if len( key ) = 0 then return
        while e->varTypeKey.Count <= ix
            e->varTypeKey.Push( "" )
        wend
        e->varTypeKey[ix] = key
    end select
end sub

sub PpNoteDeclared _
    ( byref st as PpStream, byval nm as InternId, byval at as SourceLoc, byval kind as long, _
      byval atTop as boolean, byval nsPath as string )
    if st.engine = 0 then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    if InIfaceFile_( *e, at ) then return
    MarkDeclared_( *e, nm, kind )
    if nm = INTERN_NONE then return
    dim as long ix = cast( long, e->names->Fold( nm ) )
    if (atTop = false) andalso (len( nsPath ) > 0) then
        while e->nsMemberOf.Count <= ix
            e->nsMemberOf.Push( "" )
        wend
        dim as string tagged = "|" & nsPath & "|"
        if instr( e->nsMemberOf[ix], tagged ) = 0 then
            if len( e->nsMemberOf[ix] ) = 0 then e->nsMemberOf[ix] = "|"
            e->nsMemberOf[ix] += nsPath & "|"
        end if
    end if
    if atTop = false then return
    while e->topDeclared.Count <= ix
        e->topDeclared.Push( 0 )
    wend
    e->topDeclared[ix] = 1
end sub

sub PpSetNamespace( byref st as PpStream, byval path as string )
    if st.engine = 0 then return
    cast( PpEngine ptr, st.engine )->curNs = path
end sub

sub PpNoteUsingIn( byref st as PpStream, byval fromNs as string, byval path as string )
    if (st.engine = 0) orelse (len( path ) = 0) then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    dim as string pr = fromNs & ">" & path
    if len( e->usingIn ) = 0 then e->usingIn = "|"
    if instr( e->usingIn, "|" & pr & "|" ) = 0 then e->usingIn += pr & "|"
end sub

sub PpNoteTypeNs( byref st as PpStream, byval nm as InternId, byval nsPath as string )
    if (st.engine = 0) orelse (nm = INTERN_NONE) then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    dim as long ix = cast( long, e->names->Fold( nm ) )
    while e->typeNs.Count <= ix
        e->typeNs.Push( "" )
    wend
    if len( e->typeNs[ix] ) = 0 then e->typeNs[ix] = "|"
    if instr( e->typeNs[ix], "|" & nsPath & "|" ) = 0 then e->typeNs[ix] += nsPath & "|"
end sub

sub PpNoteUsing( byref st as PpStream, byval path as string )
    if (st.engine = 0) orelse (len( path ) = 0) then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    if len( e->usingPaths ) = 0 then e->usingPaths = "|"
    if instr( e->usingPaths, "|" & path & "|" ) = 0 then e->usingPaths += path & "|"
end sub

function PpHasDeclared( byref st as PpStream, byval nm as InternId ) as boolean
    if st.engine = 0 then return false
    return IsDeclared_( *cast( PpEngine ptr, st.engine ), nm )
end function

private function MacroFor( byref e as PpEngine, byval id as InternId ) as PpMacro ptr
    dim as long slot = SlotOf( e, id )
    if slot = 0 then return 0
    dim as PpMacro ptr m = @e.macros[slot - 1]
    if m->isDefined = false then return 0
    return m
end function

'' FBC HAS NO HIDE SET. This painted every macro blue for the whole of its own
'' expansion, the way C does, and that is not FreeBASIC: measured,
''
''     #define f(x) x        print f(f(f(f(1))))    fbc prints 1, tiko-lang declined
''     #define M(A,B) __FB_JOIN__(A,B)
''                           M( A, M( B, C ) )      fbc gives 123, tiko-lang gave 1
''                                                  AND left 'm ( 2 , 3 )' in the
''                                                  stream -- a wrong value, emitted
''
'' A macro reached again through its own ARGUMENT is an ordinary nested invocation to
'' fbc, and only TRUE self-recursion is refused: '#define f(x) f(x)' and '#define A A+1'
'' are both 'error 89: Recursive DEFINE not allowed'.
''
'' Nothing is hidden now, and runaway expansion is caught where it always was -- the
'' frame cap, PP_MAX_FRAMES, which reports TKO0304 and stops. The 'hides' field stays
'' on the frame because the dump reads it.
private function IsHidden( byref e as PpEngine, byval id as InternId ) as boolean
    return false
end function

private function Emitting( byref e as PpEngine ) as boolean
    if e.conds.IsEmpty( ) then return true
    return e.conds[e.conds.Count - 1].active
end function

private sub Report _
    ( byref e as PpEngine, byval id as DiagId, byval at as SourceLoc, _
      byval a0 as string = "", byval a1 as string = "" )
    if e.cfg->scanQuiet then return          '' see PpConfig.scanQuiet
    e.diags->Report( id, PointRange( at ), a0, a1 )
end sub

'' ---------------------------------------------------------------- token access
'' The frame stack is the whole engine. Everything else is bookkeeping on top.

private sub PushFrame _
    ( byref e as PpEngine, byval toks as TokenVec ptr, byval hides as InternId, _
      byval file as FileId, byval owned as boolean, _
      byval useLoc as SourceLoc = LOC_NONE, byval lineLoc as SourceLoc = LOC_NONE )

    if e.frames.Count >= PP_MAX_FRAMES then
        Report( e, TKO0304, LOC_NONE, str( PP_MAX_FRAMES ) )
        e.stopped = true
        return
    end if

    dim as PpFrame f
    f.toks = toks
    f.pos = 0
    f.joinTried = -1
    f.hides = hides
    f.file = file
    f.owned = owned
    f.useLoc = useLoc
    f.lineLoc = iif( lineLoc <> LOC_NONE, lineLoc, useLoc )
    if e.frames.Count > 0 then f.inImport = e.frames[e.frames.Count - 1].inImport
    e.frames.Push( f )
    if e.frames.Count > e.outp->maxDepth then e.outp->maxDepth = e.frames.Count
end sub

'' Where the source WROTE the thing being expanded -- the loc __LINE__, __FILE__ and
'' __PATH__ have to answer for.
''
'' The OUTERMOST expansion wins, so this walks down to the innermost FILE frame and
'' takes the first recorded use site above it. Measured on fbc 1.10: with '#define
'' inner_ __LINE__' and '#define outer_ inner_' both in an included header, 'outer_'
'' on line 4 of the includer prints 4 -- not the header's line, and not inner_'s. The
'' innermost frame's own use site would give inner_'s line inside outer_'s body,
'' which is a line in the header again.
''
'' Falls back to the token's own loc, which is right for a builtin used directly in a
'' file and is what every non-macro path already did.
private function UseSiteLoc_ _
    ( byref e as PpEngine, byref use as Token ) as SourceLoc

    dim as long fileAt = -1
    for i as long = e.frames.Count - 1 to 0 step -1
        if e.frames[i].file <> FILE_NONE then
            fileAt = i
            exit for
        end if
    next
    if fileAt < 0 then return use.loc

    for i as long = fileAt + 1 to e.frames.Count - 1
        if e.frames[i].useLoc <> LOC_NONE then return e.frames[i].useLoc
    next
    return use.loc
end function

'' The same walk for __LINE__, which answers with the outermost expansion's LINE site.
private function LineSiteLoc_( byref e as PpEngine, byref use as Token ) as SourceLoc
    dim as long fileAt = -1
    for i as long = e.frames.Count - 1 to 0 step -1
        if e.frames[i].file <> FILE_NONE then fileAt = i : exit for
    next
    if fileAt < 0 then return use.loc
    for i as long = fileAt + 1 to e.frames.Count - 1
        if e.frames[i].lineLoc <> LOC_NONE then return e.frames[i].lineLoc
    next
    return use.loc
end function

private sub PopFrame( byref e as PpEngine )
    if e.frames.IsEmpty( ) then return
    dim as PpFrame f = e.frames[e.frames.Count - 1]
    e.frames.Pop( )
    if f.owned andalso (f.toks <> 0) then delete f.toks
end sub

'' ADJACENCY: the last token an expansion emits and the next token of the enclosing
'' stream RE-LEX AS ONE when nothing separates them in the source. Defined below, next
'' to RelexInto, which is what it is built on; declared here because PeekTok is where
'' the seam becomes visible.
declare function TryTailJoin_( byref e as PpEngine ) as boolean
declare function PpModNextFile( byref e as PpEngine ) as boolean

'' Peek the next token without consuming, skipping exhausted frames. Returns false at
'' the very end of everything.
private function PeekTok( byref e as PpEngine, byref outTok as Token ) as boolean
    while e.frames.Count > 0
        dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
        '' A file frame's trailing TK_EOF is consumed by the include machinery, not
        '' handed out: only the root's EOF reaches the output.
        dim as long last = f->toks->Count - 1
        if f->pos > last then
            if e.frames.Count <= e.frameFloor then return false
            PopFrame( e )
            continue while
        end if
        dim as Token t = f->toks->At( f->pos )
        dim as boolean fileEof = (f->file <> FILE_NONE) andalso (Tk( t ) = TK_EOF)
        '' ...AND A MODULE UNIT'S ROOT EOF IS ITS NEXT FILE, when it has one (ppmodule.bas).
        if fileEof andalso (e.frames.Count = 1) then
            if PpModNextFile( e ) then continue while
        end if
        if fileEof andalso (e.frames.Count > 1) then
            if e.frames.Count <= e.frameFloor then return false
            PopFrame( e )
            continue while
        end if
        '' The seam: 't' may be the last token of an expansion and the next token of
        '' the frame below may be flush against it. Joining REWRITES this frame's last
        '' token, so re-read rather than handing out the stale one.
        if TryTailJoin_( e ) then continue while
        outTok = t
        return true
    wend
    return false
end function

'' Peek the token AFTER the current one, consuming and popping NOTHING.
''
'' A function-like macro name is only an invocation when a '(' follows it, and the
'' obvious way to look -- Advance, PeekTok, restore f->pos on a miss -- LOSES A TOKEN.
'' When the name is the LAST token of its frame, PeekTok's own pop cascade deletes that
'' frame, so the saved 'f' points at a popped slot and the restore writes nothing; the
'' caller in PpStep then advances the ENCLOSING frame and eats the token PeekTok had
'' merely looked at --
''
''     #define fn(x) x
''     #define tailfn fn
''     tailfn zzz
''
''         fbc -pp:  ' fn zzz'   (measured, fbc 1.10.1)
''         tiko was: ' fn'       -- 'zzz' gone, silently.
''
'' So the lookahead must not mutate. This walks the frame stack downward instead,
'' mirroring PeekTok's two skip rules -- an exhausted frame, and a file frame's
'' trailing TK_EOF -- and its frameFloor, with 'idx + 1' standing in for the frame
'' count PeekTok would have had after the pops it is not doing.
private function PeekTokAhead( byref e as PpEngine, byref outTok as Token ) as boolean
    dim as long idx = e.frames.Count - 1
    '' the token we are looking PAST, skipped on the top frame only
    dim as long skip = 1
    while idx >= 0
        dim as PpFrame ptr f = @e.frames[idx]
        dim as long p = f->pos + skip
        skip = 0
        if p > f->toks->Count - 1 then
            if (idx + 1) <= e.frameFloor then return false
            idx -= 1
            continue while
        end if
        dim as Token t = f->toks->At( p )
        dim as boolean fileEof = (f->file <> FILE_NONE) andalso (Tk( t ) = TK_EOF)
        dim as boolean nested = (idx + 1) > 1
        if fileEof andalso nested then
            if (idx + 1) <= e.frameFloor then return false
            idx -= 1
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

'' Next token on the CURRENT line, without crossing TK_EOL. Directives are line-scoped,
'' so every directive parser uses this.
''
'' A SYNTHESISED DIRECTIVE CONTINUES ON THE LINE THAT INVOKED IT. '__FB_UNQUOTE__(
'' "#define n1 " ) __FB_QUOTE__( 42 )' re-lexes the first half into an EXPANSION FRAME
'' that ends immediately after 'n1' -- and fbc defines n1 as '"42"', reading on into the
'' rest of the invoking line. Stopping at the frame's end instead defined it EMPTY and
'' left the quoted half behind as a stray expression: 76 declines in
'' pp/macro-arg-extract.bas, which is the file that exists to test this.
''
'' Only an EXPANSION frame is crossed. A FILE frame ends the line whatever follows it --
'' a directive must not run past the end of the file it was written in.
private function PeekOnLine( byref e as PpEngine, byref outTok as Token ) as boolean
    while e.frames.Count > 0
        dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
        if f->pos > f->toks->Count - 1 then
            if f->file <> FILE_NONE then return false
            if e.frames.Count = 1 then return false
            PopFrame( e )
            continue while
        end if
        dim as Token t = f->toks->At( f->pos )
        dim as boolean ends = (Tk( t ) = TK_EOL) orelse (Tk( t ) = TK_EOF)
        if ends then return false
        outTok = t
        return true
    wend
    return false
end function

private sub SkipToEol( byref e as PpEngine )
    dim as Token t
    while PeekOnLine( e, t )
        Advance( e )
    wend
end sub

'' ...and the same to the end of the PHYSICAL line: it stops at the first token that
'' followed a line continuation. Only the '#macro' header wants this -- see the comment
'' at its call site.
private sub SkipMacroHeader_( byref e as PpEngine )
    dim as Token t
    while PeekOnLine( e, t )
        if (t.flags and TF_LINE_JOINED) <> 0 then exit while
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

'' ------------------------------------------------------- '#undef' OF A KEYWORD
''
'' fbc's keywords are ENTRIES IN THE SYMBOL TABLE, so '#undef short' deletes one and
'' the word becomes an ordinary identifier for the rest of the compilation. That is
'' the first thing quirk/undef.bas asks for, and it is the half of '#undef' that can
'' be answered WITHOUT the symbol table the preprocessor does not have: the lexer's
'' keyword decision is the only thing in play, and this layer owns the token stream.
''
'' MEASURED against fbc-modern (probe/p1..p11, 2026-09-09):
''
''   #undef short : type short as integer : dim x as short : print sizeof(x)
''                                       -> 8. Before this, tiko-lang printed 2:
''                                          the 'type' alias was ignored SILENTLY and
''                                          the corpus file did not even decline.
''   #undef short : dim short as integer = 5 : print short      -> 5, so the word is
''                                          a plain identifier, not a removed type
''   #undef short : dim x as short         -> error 14. Nothing puts it back.
''   #undef mod   : dim mod as integer = 7 -> 7. OPERATOR-class words go too.
''   #define short 5                       -> error 4, Duplicated definition. A
''                                          keyword and a macro can never share a
''                                          name, so '#undef NAME' is unambiguous.
''   sub s( ) : #undef short : ... : end sub  then 'dim y as short' -> error 14.
''                                          NOT block-scoped, unlike a '#define'.
''   #undef short then #include a file that writes 'type short as double'
''                                       -> sizeof( short ) = 8. It crosses files.
''   #undef NeverExisted                  -> accepted, no diagnostic.
''
'' What this does NOT do is the other half: '#undef f1' / '#undef N' remove a
'' PROCEDURE or a NAMESPACE from fbc's symbol table, and nothing here can see those.
'' See HANDOFF's "The PREPROCESSOR CANNOT SEE DECLARED SYMBOLS".
private function DereservedId_ _
    ( byref e as PpEngine, byval k as TokenKind ) as InternId
    if cast( long, k ) >= e.dereserved.Count then return INTERN_NONE
    return cast( InternId, e.dereserved[cast( long, k )] )
end function

private sub DereserveKw_( byref e as PpEngine, byval k as TokenKind )
    '' The folded spelling is already interned -- InitKeywords interns every keyword
    '' FIRST, so this looks the existing id up rather than making a new one.
    dim as InternId id = e.names->GetString( Text.LowerAscii( TokenKindText( k ) ) )
    while e.dereserved.Count <= cast( long, k )
        e.dereserved.Push( 0 )
    wend
    e.dereserved[cast( long, k )] = cast( ulong, id )
end sub

'' fbc's warning 44 (TKO0206). The rule implemented here is exactly the one the
'' measurement supports: A RESERVED WORD THAT REACHES THE PARSER CARRYING A SUFFIX.
''
'' Why here and not in the lexer: the lexer sees every token in the file, including the
'' ones in a false '#if' branch, and fbc warns about none of those (measured). A token
'' reaching EmitTok is by construction live. A '#macro' body token reaches it once per
'' expansion, which is also fbc's count -- measured, a suffixed keyword in a body
'' expanded twice is two warnings. fbc puts each at the INVOCATION line and this puts
'' it at the body's own, because a body token here keeps its definition loc; that is
'' where every diagnostic in a macro body already points and is not this one's to move.
''
'' NOT covered, and deliberately so rather than guessed at:
''   - suffixes on ORDINARY IDENTIFIERS. 'dim a$' is legal and silent; 'n%' naming an
''     'n as integer' warns. Telling those apart is a name-resolution question and
''     there is nothing here to answer it with.
''   - suffixes on words consumed by a DIRECTIVE and never emitted -- '#include%',
''     '#line%', '#pragma msbitfields%'. Those need a call per directive, not one rule.
''   - suffixes on CONTEXTUAL words that are not reserved: 'open ... for binary as% #1'
''     warns on 'as' (reserved, covered) but 'put #1,,x,,trans%' does not reach a
''     keyword at all.

'' THE CLASSIC '$' SPELLINGS. 'CHR$', 'MID$', 'STR$' and their family are not CHR with
'' a suffix -- the '$' is part of a second, accepted name for the intrinsic, and fbc
'' warns about none of them. suffix-fb.bas says so itself: 26 of them under one
'' 'WARN( 0 )' (its lines 1022-1047 after the '#line 1000'), immediately followed by
'' 'WARN( 4 )' over 'wchr$ wstr$ wstring$ bin$', which are NOT in the family and do
'' warn. Sixteen of the 26 are keywords here; the rest lex as identifiers and never
'' reach this code.
''
'' KNOWN SHORTFALL, ONE SITE. 'STRING$' is in the family as a FUNCTION and out of it as
'' a TYPE: measured, 'print string$( 3, 65 )' is silent and 'dim a as string$' is
'' warning 44. Type position is a parser fact and there is none of it here, so this
'' takes the silent half and misses suffix-fb.bas(373). Under-warning by one beats
'' warning on every 'chr$' in the corpus.
private function IsClassicDollarName( byval k as TokenKind ) as boolean
    select case k
    case KW_CHR, KW_STR, KW_STRING, KW_MKS, KW_MKD, KW_MKL, KW_MKI, KW_MKSHORT, _
         KW_MKLONGINT, KW_LTRIM, KW_RTRIM, KW_MID, KW_LCASE, KW_UCASE, KW_TRIM, _
         KW_INPUT
        return true
    end select
    return false
end function

'' 'OPEN ... FOR BINARY ACCESS READ WRITE' -- and ONLY that phrase -- swallows the
'' second word's suffix. Measured, six ways:
''
''     access write%           warns          suffix-fb.bas(895)
''     access read% write%     read% only     suffix-fb.bas(897)
''     access read write%      silent         probe p5(5)
''     access read% write      read% only     probe p5(6)
''     lock% write%            warns          suffix-fb.bas(904)
''     lock% read% write%      warns BOTH     suffix-fb.bas(906)
''
'' so it is not "WRITE after READ" -- 'lock read write%' warns -- it is the ACCESS
'' clause, whose READ WRITE fbc consumes with a lookahead that never reaches the
'' warning. Two tokens of history is the whole context needed, and this is the only
'' place the preprocessor keeps any.
private function InAccessReadWrite( byref e as PpEngine, byval k as TokenKind ) as boolean
    if k <> KW_WRITE then return false
    dim as long n = e.outp->tokens.Count
    if n < 2 then return false
    if cast( TokenKind, e.outp->tokens[n - 1].kind ) <> KW_READ then return false
    return (cast( TokenKind, e.outp->tokens[n - 2].kind ) = KW_ACCESS)
end function

private sub WarnIgnoredSuffix( byref e as PpEngine, byref t as Token )
    if (t.flags and TF_HAS_SUFFIX) = 0 then return
    dim as TokenKind kind = Tk( t )
    '' A KEYWORD ONLY, and the SHORTFALL IS DELIBERATE.
    ''
    '' The note that used to be here said an ordinary identifier cannot be covered
    '' because 'dim a$' is legal and silent and telling a legal suffix from an ignored
    '' one needs name resolution. THAT IS MEASURABLY WRONG: in '#lang "fb"' there is no
    '' legal one. Every spelling warns, and the declaration form is an error as well --
    ''
    ''     dim as string s : print s$        1 warning
    ''     dim as integer n : print n%       1 warning
    ''     dim n% as integer : print n%      2 warnings, BOTH sites
    ''     dim a$ : a$ = "x" : print a$      3 warnings AND 2 errors
    ''     print left%( s, 2 )               1 warning -- a PRELUDE function here, not
    ''                                       a keyword, which is why left/right/space
    ''                                       are in the shortfall
    ''
    '' Dropping this test was TRIED. It takes suffix-fb.bas from 464 of fbc's 544 sites
    '' to 526 -- and introduces TEN FALSE POSITIVES, which is the one thing this rule
    '' may not do. Two more sub-rules stand between here and the identifier form, and
    '' the second is why it is not merely more work:
    ''
    ''   1. THE CLASSIC '$' NAMES ALSO LEX AS IDENTIFIERS. inkey$, space$, left$ and
    ''      command$ are prelude functions here, so IsClassicDollarName below never
    ''      sees them. Fixable: match the SPELLING rather than the token kind.
    ''   2. 'type T%' IS SILENT AND 'type ALIAS% as integer' WARNS -- measured, one
    ''      line apart. A UDT declaration head and a typedef head are the same two
    ''      tokens; what separates them is whether 'as' FOLLOWS the name. EmitTok
    ''      looks BACKWARD at what it has already emitted, the way InAccessReadWrite
    ''      does, and has no lookahead at all. That one site is suffix-fb.bas(337).
    ''
    '' So the gap is not 'needs name resolution'; it is one token of lookahead this
    '' layer does not have. 464 with zero false positives beats 526 with one.
    if IsKeywordKind( kind ) = false then return

    dim as ushort sufBits = (t.flags and TF_SUFFIX_MASK) shr TF_SUFFIX_SHIFT
    if cast( SuffixChar, sufBits ) = SUFC_DOLLAR then
        if IsClassicDollarName( kind ) then return
    end if
    if InAccessReadWrite( e, kind ) then return

    '' What fbc quotes is the SOURCE TEXT, case preserved. Read the span, and accept it
    '' only when it still spells this token -- a macro-expanded or pasted token had its
    '' loc repointed at the use site, exactly as SpellOf documents, and the span there
    '' is the invocation's text. The fallback is the canonical spelling plus the
    '' recorded suffix character.
    dim as string suffix = SuffixCharText( t.flags )
    dim as string canon = Text.LowerAscii( TokenKindText( Tk( t ) ) )
    dim as DecodedLoc d = e.src->Decode( t.loc )
    dim as SourceFile ptr f = e.src->FileAt( d.file )
    dim as string spell = canon & suffix
    if (f <> 0) andalso (t.length = len( spell )) then
        if (d.offset + t.length) <= f->text.Count then
            dim as string s = space( t.length )
            memcpy( strptr( s ), @f->text[d.offset], t.length )
            if Text.LowerAscii( s ) = spell then spell = s
        end if
    end if

    Report( e, TKO0206, t.loc, spell )
end sub

private sub EmitTok( byref e as PpEngine, byref t as Token )
    WarnIgnoredSuffix( e, t )
    '' A KEYWORD THAT HAS BEEN '#undef'ED leaves as an identifier. Done on the way
    '' out rather than in the lexer because a file is lexed once, in full, before
    '' the directive that de-reserves the word has run. 't' is byref so the caller's
    '' copy changes too, which is what keeps PpTrackBlock's view consistent: a
    '' de-reserved 'sub' is not a block opener either.
    if IsKeywordKind( Tk( t ) ) then
        dim as InternId id = DereservedId_( e, Tk( t ) )
        if id <> INTERN_NONE then
            t.kind = cast( ushort, TK_IDENT )
            t.literal = cast( ulong, id )
        end if
    end if

    '' The '##_' line join, consumed by the FIRST end of line that reaches the output
    '' after it. Doing it here rather than in the substitution loop is what makes the
    '' body and the invocation cases one rule instead of two.
    '' A ':' IS ALSO A TK_EOL and is NOT what a line join joins: 'a : b' is two
    '' statements on one line and there is no line to continue. TF_COLON is the only
    '' thing that tells them apart -- both are one byte.
    '' THE MARKER ITSELF, which stands where the '##_' stood in the body. It arms the
    '' join and is never output. Checked BEFORE the eat below so that two joins in a
    '' row arm once each rather than the second cancelling the first.
    if (t.flags and TF_JOIN_MARK) <> 0 then
        e.eatNextEol = true
        return
    end if
    if e.eatNextEol andalso (Tk( t ) = TK_EOL) andalso ((t.flags and TF_COLON) = 0) then
        e.eatNextEol = false
        return
    end if
    e.outp->tokens.Push( t )
end sub

'' -------------------------------------------------------------- token spelling
'' Needed by stringisation and by ## pasting, both of which work on source text.

'' A BLOCK STRING spells back as ONE LINE: the escaped literal with the same value. Its
'' payload holds real newlines, and a spelling gets re-lexed -- by a paste, by
'' __FB_UNQUOTE__, and by a module interface, which writes a const or a generic body out as
'' text -- where a newline would end the literal. The payload's '""' pairs stay, since an
'' escaped literal collapses them too; a plain or raw payload's backslashes are doubled.
private function BlockSpelling_( byref payload as string, byval kind as StringKind ) as string
    dim as string r = "!" & chr( 34 )
    for i as long = 0 to len( payload ) - 1
        dim as ubyte ch = payload[i]
        if ch = 10 then
            r &= chr( 92, 110 )
        elseif (ch = 92) andalso (kind <> STRK_ESCAPED) then
            r &= chr( 92, 92 )
        else
            r &= chr( ch )
        end if
    next
    return r & chr( 34 )
end function

function PpSpell _
    ( byref src as SourceManager, byref names as Interner, _
      byref lits as LiteralVec, byref t as Token ) as string
    dim as TokenKind k = Tk( t )
    if k = TK_IDENT then
        '' The FOLDED spelling is in the interner; the original is in the source.
        dim as string folded = names.Spelling( cast( InternId, t.literal ) )
        dim as DecodedLoc d = src.Decode( t.loc )
        dim as SourceFile ptr f = src.FileAt( d.file )
        if (f <> 0) andalso (t.length > 0) then
            if (d.offset + t.length) <= f->text.Count then
                dim as string s = space( t.length )
                memcpy( strptr( s ), @f->text[d.offset], t.length )
                '' ...BUT ONLY WHEN THE SPAN IS STILL THIS TOKEN. A PASTED identifier
                '' had its loc REPOINTED AT THE USE SITE, exactly as the numeric
                '' literals in RelexInto did, so the span read the INVOCATION's text
                '' instead of the name: 'INNER( c##a )' inside 'OUTER( s )' pasted
                '' 'p' with the first two characters of 'OUTER(' and produced 'pou'.
                '' An identifier has no text span of its own to record, so the check is
                '' that the source text FOLDS TO THE INTERNED SPELLING -- which keeps
                '' the original CASE for every real source token and falls back to the
                '' folded name for a synthesised one.
                ''
                '' It was silent: 'pou' is a perfectly good identifier, simply not one
                '' that is declared, and an undeclared name in an expression is an
                '' untyped node rather than an error. 63 corpus declines in
                '' string/concat.bas were this one paste.
                if Text.LowerAscii( s ) = Text.LowerAscii( folded ) then return s
            end if
        end if
        return folded
    end if

    dim as string spellText = TokenKindText( k )
    if len( spellText ) > 0 then
        '' A KEYWORD IS SPELLED AS IT WAS WRITTEN, not as the table spells it.
        '' TokenKindText is UPPERCASE, so a stringize of one came back shouting:
        ''
        ''     #define S( x ) #x
        ''     S( integer ptr )     fbc: 'integer ptr'   tiko: 'INTEGER PTR'
        ''
        '' The IDENTIFIER branch above has read the source span since it was
        '' written -- which is why 'S( Hello World )' was right all along and
        '' only the keywords were wrong.
        ''
        '' THE SAME GUARD IT USES: take the span only when it FOLDS TO the
        '' canonical text. A synthesised or pasted token has its loc repointed at
        '' the use site, so the span there is somebody else's source, and the
        '' table's spelling is the right answer for it.
        dim as DecodedLoc kd = src.Decode( t.loc )
        dim as SourceFile ptr kf = src.FileAt( kd.file )
        if (kf <> 0) andalso (t.length > 0) then
            if (kd.offset + t.length) <= kf->text.Count then
                dim as string ks = space( t.length )
                memcpy( strptr( ks ), @kf->text[kd.offset], t.length )
                if Text.LowerAscii( ks ) = Text.LowerAscii( spellText ) then
                    return ks
                end if
            end if
        end if
        return spellText
    end if

    '' A LITERAL's text comes from ITS OWN recorded file and span, never from the token's
    '' loc. RelexInto repoints synthesised tokens at the use site so diagnostics land
    '' somewhere visible, and reading the span at that loc then returned the INVOCATION's
    '' source text -- which is what made '#param' echo the macro call instead of the
    '' argument.
    dim as boolean isLit = (k = TK_INT_LIT) orelse (k = TK_FLOAT_LIT) orelse _
                           (k = TK_STRING_LIT)
    if isLit then
        dim as long li = cast( long, t.literal )
        if (li >= 0) andalso (li < lits.Count) then
            dim as Literal ptr lp = @lits[li]
            dim as SourceFile ptr lf = src.FileAt( cast( FileId, lp->textFile ) )
            if (lf <> 0) andalso (lp->textLength > 0) then
                if (lp->textOffset + lp->textLength) <= lf->text.Count then
                    dim as string ls = space( lp->textLength )
                    memcpy( strptr( ls ), @lf->text[lp->textOffset], lp->textLength )
                    '' The span excludes the quotes AND the prefix, which the
                    '' spelling must carry: fbc spells a string literal back with the
                    '' prefix it was written with, and there is no file-versus-
                    '' synthesised distinction. Measured, all four:
                    ''
                    ''     #define t $"hello"  len( __FB_QUOTE__( t ) ) = 8, $"hello"
                    ''     #define t "hello"   len( __FB_QUOTE__( t ) ) = 7, "hello"
                    ''     #define t !"a\tb"   len( __FB_QUOTE__( t ) ) = 7, !"a\tb"
                    ''     #define S(a) #a     len( S( $"q" ) ) = 4, $"q"
                    ''
                    '' An earlier attempt at this added '$' UNCONDITIONALLY, which put
                    '' one on plain literals and broke three tests/pp goldens; the
                    '' note left behind read that as 'synthesised literals take no
                    '' prefix'. They do -- a nested __FB_QUOTE__ gives fbc
                    '' '$"1 2 3" $"4 5 6"' -- and strKind is what says which.
                    if (k = TK_STRING_LIT) andalso (lp->strBlock <> 0) then
                        return BlockSpelling_( ls, cast( StringKind, lp->strKind ) )
                    end if
                    if k = TK_STRING_LIT then
                        dim as string pfx = ""
                        select case cast( StringKind, lp->strKind )
                        case STRK_RAW     : pfx = "$"
                        case STRK_ESCAPED : pfx = "!"
                        end select
                        return pfx & """" & ls & """"
                    end if
                    return ls
                end if
            end if
            if k = TK_STRING_LIT then return """"""
        end if
    end if

    '' Anything else: the exact source span at the token's location.
    dim as DecodedLoc d = src.Decode( t.loc )
    dim as SourceFile ptr f = src.FileAt( d.file )
    if (f = 0) orelse (t.length = 0) then return ""
    dim as string s = space( t.length )
    memcpy( strptr( s ), @f->text[d.offset], t.length )
    return s
end function

private function SpellOf( byref e as PpEngine, byref t as Token ) as string
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
        if at <> LOC_NONE then t.loc = at
        t.flags or= TF_FROM_MACRO
        outv.Push( t )
    next
end sub

#include once "pp/ppjoin.bas"

'' Forward declarations: the three parts below reference each other freely, and the
'' main loop below them references all three. They are #included rather than compiled
'' separately so the whole preprocessor is one translation unit.
declare function PpEvalCondition _
    ( byref e as PpEngine, byref toks as TokenVec, byref ok as boolean ) as boolean
declare function PpEvalIntTokens _
    ( byref e as PpEngine, byref toks as TokenVec, byref ok as boolean ) as longint
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
declare sub PpModAfterBuiltins( byref e as PpEngine )
declare function PpModFirstUserIdent( byref e as PpEngine ) as string
declare sub PpModNoteElse( byref e as PpEngine, byval c as PpCond ptr )
declare function PpModPreDirective _
    ( byref e as PpEngine, byref word as string, byval at as SourceLoc ) as boolean
declare function PpModBeforeEmit( byref e as PpEngine, byref t as Token ) as boolean
declare sub PpModDirective( byref e as PpEngine, byref word as string, byval at as SourceLoc )
declare sub PpModJournal( byref e as PpEngine, byval m as PpMacro ptr )
declare sub PpModEndFile( byref e as PpEngine )
declare function PpModRefuse( byref e as PpEngine, byref what as string, byval at as SourceLoc ) as boolean
declare sub PpModNoteHeader( byref e as PpEngine, byval from as FileId, byval got as FileId )
declare function PpModQualifiedMacro( byref e as PpEngine, byref t as Token ) as boolean

end namespace

#include once "pp/ppexpr.bas"
#include once "pp/macrotaken.bas"
#include once "pp/macro.bas"
#include once "pp/directive.bas"
#include once "pp/ppmodule.bas"

namespace Tko

'' ------------------------------------------------------------------- the loop

'' ------------------------------------------------------------------- the pump
''
'' One iteration of the old monolithic loop, restructured so it can stop after
'' emitting a single token. Everything else about it is unchanged: this is the same
'' logic, driven differently.

private sub PpFinish( byref e as PpEngine )
    '' Unbalanced conditionals are the user's error, reported once per open block.
    while e.conds.IsEmpty( ) = false
        '' A SCAN STOPS INSIDE AN '#if' by design (PpConfig.scanHeader); the file is not unbalanced.
        if e.cfg->scanHeader = false then Report( e, TKO0303, e.conds[e.conds.Count - 1].loc )
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

'' BLOCK NESTING, on the token about to be emitted.
''
'' fbc's preprocessor shares the compiler's SCOPED symbol table, so a '#define'
'' inside a procedure dies with it. Measured:
''
''     sub a( ) : #define M 1 : print M : end sub
''     sub b( ) : #define M 2 : print M : end sub      accepted, prints 1 then 2
''     sub a( ) : #define M 1 : end sub : print M      error 42, M not declared
''
'' tiko-lang's preprocessor is a separate pass over a flat table, so the second
'' '#define' was 'macro already defined' and the file was lost from there --
'' pp/token-pasting.bas redefines four macros in each of six TEST bodies, and
'' fbcunit's TEST expands to 'sub ... end sub'.
''
'' ONLY SUB, FUNCTION AND SCOPE. fbc scopes to any block, a FOR body included, but
'' every extra form is another chance to miscount -- and miscounting UNDEFINES A
'' MACRO EARLY, which breaks working code, where missing a form merely leaves
'' tiko-lang as permissive as it already was.
''
'' A BLOCK OPENS ONLY AT THE HEAD OF A STATEMENT -- 'sub f', 'private function g',
'' 'scope' -- and 'end sub' closes one. Anywhere else the word opens nothing: 'declare
'' sub', 'exit sub', and every form that merely NAMES a procedure type. Those were
'' told apart by the keyword just before, which missed 'declare const function',
'' 'declare static sub', 'declare virtual function', a field or variable 'as sub( )',
'' 'type Fn as function( ) as long' and a result 'as function( )': each counted a block
'' nothing closed. Measured: a '#define' in a SUB before a 'dim cb as sub( )' then
'' outlived the SUB -- fbc-modern prints 1, 2 for two SUBs each defining M, tiko-lang
'' refused the second as TKO0305 -- and every macro after fb/fserror.bi's
'' 'declare const function' was left out of an editor scan (PpSnapshotMacros).
''
'' 'function = x' at a statement's head is a RESULT ASSIGNMENT, not a definition.
private sub PpTrackBlock( byref e as PpEngine, byref t as Token )
    dim as TokenKind k = Tk( t )
    dim as TokenKind pk = cast( TokenKind, e.prevKw )
    dim as boolean opener = false
    dim as boolean closer = false

    if (k = KW_SUB) orelse (k = KW_FUNCTION) orelse (k = KW_SCOPE) then
        if pk = KW_END then
            closer = true
        elseif e.stmtDirty = false then
            opener = true
            '' 'function = expr' assigns the result, and 'Function as DWORD' is a FIELD --
            '' win/winnt.bi has three -- so neither opens anything (T89). Counted as blocks,
            '' they left windows.bi three deep, and every macro defined after it was dropped
            '' at the next header's 'end function': '#import "std/tui"' then "std/fs" lost tui.
            dim as Token nx
            if PeekTok( e, nx ) then
                if (k = KW_FUNCTION) andalso (Tk( nx ) = TK_EQ) then opener = false
                if Tk( nx ) = KW_AS then opener = false
            end if
        end if
    end if

    if opener then e.blockDepth += 1
    if closer then
        if e.blockDepth > 0 then e.blockDepth -= 1
        '' Everything defined deeper than the block just closed goes with it.
        for i as long = 0 to e.macros.Count - 1
            if e.macros[i].isDefined then
                if e.macros[i].blockDepth > e.blockDepth then
                    e.macros[i].isDefined = false
                end if
            end if
        next
    end if

    '' Only KEYWORDS are remembered: an identifier between END and SUB is not a
    '' thing, and remembering every token would make 'end' stale.
    '' An END OF STATEMENT forgets it: in 'if x then end f( )' then 'scope' on the
    '' next line, the END is the END statement, and keeping it turned that 'scope'
    '' into a closer that undefined every macro of the enclosing depth.
    if IsKeywordKind( k ) then
        e.prevKw = cast( ushort, k )
    elseif k = TK_EOL then
        e.prevKw = 0
    end if
    '' A ':' is a TK_EOL too (TF_COLON), so 'sub f( ) : end sub' is two statements.
    if k = TK_EOL then
        e.stmtDirty = false
    elseif (k <> KW_PRIVATE) andalso (k <> KW_PUBLIC) then
        e.stmtDirty = true
    end if
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
        '' ...AND WHILE SKIPPING, a continuation does not join lines: '#if 0 / print _ /
        '' #endif' closes at that '#endif' (fbc-modern 1.20, 2026-09-30; pp/if-skip-1.bas).
        '' The lexer joined them, so the '#' is the first token of its physical line.
        if (atLineStart = false) andalso ((t.flags and TF_LINE_JOINED) <> 0) then atLineStart = (Emitting( e ) = false)
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
        dim as boolean inIface = (e.frames.Count > 0)
        if inIface then inIface = e.frames[e.frames.Count - 1].iface
        if (k = TK_IDENT) andalso (inIface = false) andalso (e.modst.aliasIds.Count > 0) then
            if PpModQualifiedMacro( e, t ) then continue do
        end if
        if (k = TK_IDENT) andalso (inIface = false) then
            dim as InternId id = cast( InternId, t.literal )
            dim as PpMacro ptr m = MacroFor( e, id )
            dim as boolean expandable = (m <> 0) andalso (IsHidden( e, id ) = false)
            if expandable then
                if PpExpand( e, m, t ) then continue do
            end if
        end if

        if PpModBeforeEmit( e, t ) then return false
        Advance( e )
        EmitTok( e, t )
        PpTrackBlock( e, t )
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

    '' THE SHARED POOLS, OR THIS ENGINE'S OWN. Both or neither: see PpConfig.sharedLits.
    if cfg.sharedLits <> 0 then
        e->lits = cfg.sharedLits
    else
        e->lits = @outp.literals
    end if
    if cfg.sharedLexed <> 0 then
        e->lexp = cfg.sharedLexed
        e->ownsLexed = false
    else
        e->lexp = @e->lexed
        e->ownsLexed = true
    end if
    e->eatNextEol = false
    e->stopped = false

    st.engine = e
    st.outp = @outp
    st.finished = false

    PpDefineBuiltins( *e )
    PpModAfterBuiltins( *e )
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

sub PpSnapshotMacros( byref st as PpStream, byref outp as MacroInfoVec )
    outp.Clear( )
    if st.engine = 0 then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    for i as long = 0 to e->macros.Count - 1
        dim as PpMacro ptr m = @e->macros[i]
        '' A builtin has no source; one undefined or scoped to a block is not visible
        '' where the editor would offer it.
        if m->builtin <> 0 then continue for
        if m->isDefined = false then continue for
        if m->blockDepth <> 0 then continue for
        dim as PpMacroInfo mi
        mi.name = m->name
        mi.loc = m->loc
        mi.isFunc = m->isFunc
        outp.Push( mi )
    next
end sub

sub PpClose( byref st as PpStream )
    if st.engine = 0 then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    while e->frames.IsEmpty( ) = false
        PopFrame( *e )
    wend
    '' 'lexed' IS ALWAYS THIS ENGINE'S. When the cache is shared, 'lexp' points at the
    '' invocation's array -- freed by CompilerContext's destructor -- and 'lexed' holds
    '' only the files that lexed with a diagnostic, which are not shared. When it is
    '' not shared the two are the same array, so this frees each result exactly once.
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

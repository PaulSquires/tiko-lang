'' directive.bas -- directive dispatch, includes and predefined macros.
'' Included by pp.bas.

namespace Tko

'' ------------------------------------------------------------------- includes

'' Lex a file once and keep the result alive: every token's (loc, length) points into
'' the source manager's buffers, and the literal pool lives in the Lex.Result.
private function PpLexFile( byref e as PpEngine, byval file as FileId ) as TokenVec ptr
    while e.lexed.Count <= cast( long, file )
        e.lexed.Push( 0 )
    wend

    dim as long idx = cast( long, file )
    if e.lexed[idx] <> 0 then return @(cast( Lex.Result ptr, e.lexed[idx] )->tokens)

    dim as Lex.Result ptr r = new Lex.Result
    Lex.Run( *e.src, file, *e.names, *e.kw, *e.diags, *r )
    MergeLiterals( e, r->tokens, r->literals )
    e.lexed[idx] = r
    return @r->tokens
end function

private function PpAlreadyOnce( byref e as PpEngine, byval file as FileId ) as boolean
    for each f as ulong in e.onceFiles
        if cast( FileId, f ) = file then return true
    next
    return false
end function

'' Resolution order: relative to the INCLUDING file first, then the -i paths. This is
'' fbc's order and it is what makes a library's internal includes work regardless of
'' the working directory.
'' '#foreignlib' (fbc-modern RFC-0005). The rules below are fbc's, read from
'' fbForeignLibResolve and then checked against its own error tests:
''
''     #foreignlib ID (STATIC|DYNAMIC) "spec" (, "spec")*
''
' A spec of "system:name" is handed to the linker as a bare name and resolved no
'' further. Anything else is a BASE NAME made absolute against the directory of the
'' source that wrote it, then probed -- most specific variant first:
''
''     stem_<os>_<arch>   stem_<os>   stem_<arch>   stem
''
'' with the extensions the kind and target allow. An axis with no tag drops the
'' variants that would need it rather than inventing a spelling.
private function ForeignLibOsTag_( byref e as PpEngine ) as string
    if e.cfg->targetIsWindows then return "windows"
    return "linux"
end function

'' x86-64 IS THE ONLY ARCHITECTURE (D14), so this is not a choice today. It stays a
'' function because the variant list is built around an axis that CAN be empty, and
'' an ARM64 target would fill this in rather than rewrite the loop.
private function ForeignLibArchTag_( byref e as PpEngine ) as string
    if e.cfg->targetIs64 then return "x86_64"
    return "x86"
end function

'' STATIC prefers an archive, DYNAMIC an import library. Windows gets '.lib' in
'' both: it is the MSVC spelling of each.
private sub ForeignLibExts_ _
    ( byref e as PpEngine, byval isStatic as boolean, byref outp as StrVec )
    if isStatic then
        outp.Push( ".a" )
        if e.cfg->targetIsWindows then outp.Push( ".lib" )
    else
        if e.cfg->targetIsWindows then
            outp.Push( ".dll.a" )
            outp.Push( ".lib" )
            outp.Push( ".dll" )
        else
            outp.Push( ".so" )
        end if
    end if
end sub

'' One spec to a file on disk, or "" if nothing matched. 'tried' collects every
'' candidate so the diagnostic can list them -- fbc's does, and a probe that fails
'' silently on four variants times three extensions is a bad afternoon.
private function ForeignLibResolve_ _
    ( byref e as PpEngine, byval at as SourceLoc, byref spec as string, _
      byval isStatic as boolean, byref tried as string ) as string

    tried = ""

    '' 'system:name' resolves nothing -- the linker is expected to know it.
    if lcase( left( spec, 7 ) ) = "system:" then
        return mid( spec, 8 )
    end if

    '' SOURCE-RELATIVE, not relative to the working directory: a binding written in
    '' a header must find the library sitting beside that header whoever includes it.
    dim as string base_ = spec
    for i as long = 1 to len( base_ )
        if mid( base_, i, 1 ) = "\" then mid( base_, i, 1 ) = "/"
    next
    dim as boolean absolute_ = false
    if instr( base_, ":" ) > 0 then absolute_ = true
    if left( base_, 1 ) = "/" then absolute_ = true
    if absolute_ = false then
        '' The PHYSICAL file, unlike '#include' above: '#foreignlib' is tiko's own
        '' (RFC-0005) and probes for binaries that ship beside the real source, where
        '' a '#line' name is a fiction about text rather than a place on disk.
        dim as DecodedLoc d = e.src->Decode( at )
        dim as string here = e.src->PathOf( d.file )
        dim as string dir_ = ""
        for i as long = len( here ) to 1 step -1
            dim as ubyte c = here[i - 1]
            if (c = 47) orelse (c = 92) then
                dir_ = left( here, i )
                exit for
            end if
        next
        base_ = dir_ & base_
    end if

    dim as string dirPart = ""
    dim as string stem = base_
    for i as long = len( base_ ) to 1 step -1
        dim as ubyte c = base_[i - 1]
        if (c = 47) orelse (c = 92) then
            dirPart = left( base_, i )
            stem = mid( base_, i + 1 )
            exit for
        end if
    next
    if len( stem ) = 0 then return ""

    dim as string os_ = ForeignLibOsTag_( e )
    dim as string arch = ForeignLibArchTag_( e )

    dim as StrVec variants
    if (len( os_ ) > 0) andalso (len( arch ) > 0) then variants.Push( stem & "_" & os_ & "_" & arch )
    if len( os_ ) > 0 then variants.Push( stem & "_" & os_ )
    if len( arch ) > 0 then variants.Push( stem & "_" & arch )
    variants.Push( stem )

    dim as StrVec exts
    ForeignLibExts_( e, isStatic, exts )

    for v as long = 0 to variants.Count - 1
        for x as long = 0 to exts.Count - 1
            dim as string cand = dirPart & variants[v] & exts[x]
            dim as long fh = freefile
            if open( cand for input as #fh ) = 0 then
                close #fh
                return cand
            end if
            tried += "    " & cand & chr( 10 )
        next
    next
    return ""
end function

private sub PpInclude( byref e as PpEngine, byval at as SourceLoc, byval once as boolean )
    dim as Token t
    if PeekOnLine( e, t ) = false then
        Report( e, TKO0316, at, "include" )
        return
    end if

    dim as boolean isOnce = once
    '' '#include once "..."' -- the modifier comes before the path.
    if Tk( t ) = TK_IDENT then
        if e.names->Spelling( cast( InternId, t.literal ) ) = "once" then
            isOnce = true
            Advance( e )
            if PeekOnLine( e, t ) = false then
                Report( e, TKO0316, at, "include" )
                return
            end if
        end if
    end if

    if Tk( t ) <> TK_STRING_LIT then
        Report( e, TKO0316, t.loc, "include" )
        SkipToEol( e )
        return
    end if

    dim as string spelled = SpellOf( e, t )
    dim as long a = instr( spelled, """" )
    dim as long b = instrrev( spelled, """" )
    dim as string rel = ""
    if (a > 0) andalso (b > a) then rel = mid( spelled, a + 1, b - a - 1 )
    Advance( e )
    SkipToEol( e )

    '' The directory of the INCLUDING file. Done by hand rather than through
    '' PathSplit, which wants an Array( of ustring ) and would cost more than it saves.
    ''
    '' A '#line' NAME IS WHAT A RELATIVE INCLUDE RESOLVES AGAINST -- measured, and it
    '' surprised me: after '#line 5 "sub/fake.bas"', '#include "h.bi"' picks sub/h.bi
    '' and falls back to the working directory only when that does not exist. The
    '' generator that emitted the '#line' is describing where the text came FROM, and
    '' fbc takes it at its word.
    dim as DecodedLoc d = e.src->Decode( at )
    dim as string here = e.src->ShownPathOf( d )
    dim as string dir_ = ""
    for i as long = len( here ) to 1 step -1
        dim as ubyte c = here[i - 1]
        dim as boolean isSep = (c = 47) orelse (c = 92)
        if isSep then
            dir_ = left( here, i )
            exit for
        end if
    next

    dim as FileId got = FILE_NONE
    dim as ustring why = ""

    dim as ustring firstTry = FB.PathJoin( dir_, rel )
    got = e.src->LoadFile( firstTry, why )

    if got = FILE_NONE then
        for each p as string in *e.cfg->includePaths
            dim as ustring cand = FB.PathJoin( p, rel )
            got = e.src->LoadFile( cand, why )
            if got <> FILE_NONE then exit for
        next
    end if

    if got = FILE_NONE then got = e.src->LoadFile( rel, why )

    if got = FILE_NONE then
        Report( e, TKO0301, at, rel )
        return
    end if

    if PpAlreadyOnce( e, got ) then return
    if isOnce then e.onceFiles.Push( cast( ulong, got ) )

    e.outp->includeCount += 1
    dim as TokenVec ptr toks = PpLexFile( e, got )
    PushFrame( e, toks, INTERN_NONE, got, false )
end sub

'' ---------------------------------------------------------------- conditionals

private sub PushCond _
    ( byref e as PpEngine, byval taken as boolean, byval at as SourceLoc )

    if e.conds.Count >= PP_MAX_CONDS then
        Report( e, TKO0304, at, str( PP_MAX_CONDS ) )
        e.stopped = true
        return
    end if

    dim as boolean parentActive = Emitting( e )
    dim as PpCond c
    c.parentActive = parentActive
    c.taken = taken andalso parentActive
    c.active = c.taken
    c.seenElse = false
    c.loc = at
    e.conds.Push( c )
end sub

'' Expand the rest of the line, then evaluate it. Expansion has to happen first:
'' '#if MY_FLAG' is meaningless otherwise.
''
'' This runs the REAL expander over a frame rather than hand-rolling a partial one.
'' The hand-rolled version expanded only object-like macros, so '#if TWO( a, b ) = 2'
'' and '#if __FB_ARG_COUNT__( args ) = 0' silently took the false branch.
private sub PpExpandRestOfLine _
    ( byref e as PpEngine, byref expanded as TokenVec )

    dim as TokenVec ptr raw = new TokenVec
    CollectLine( e, *raw )

    dim as long baseDepth = e.frames.Count
    PushFrame( e, raw, INTERN_NONE, FILE_NONE, true )

    dim as long guard = 0
    do
        guard += 1
        if guard > 200000 then exit do
        if e.frames.Count <= baseDepth then exit do

        dim as Token t
        if PeekTok( e, t ) = false then exit do
        '' PeekTok pops exhausted frames, so the condition frame may have gone.
        if e.frames.Count <= baseDepth then exit do

        '' 'defined X' must NOT expand X, so the operand is passed through.
        dim as boolean isDefinedKw = (Tk( t ) = KW_DEFINED)
        dim as boolean isDefinedId = false
        if Tk( t ) = TK_IDENT then
            isDefinedId = (e.names->Spelling( cast( InternId, t.literal ) ) = "defined")
        end if
        if isDefinedKw orelse isDefinedId then
            expanded.Push( t )
            Advance( e )
            if PeekTok( e, t ) andalso (e.frames.Count > baseDepth) then
                if Tk( t ) = TK_LPAREN then
                    expanded.Push( t )
                    Advance( e )
                end if
            end if
            if PeekTok( e, t ) andalso (e.frames.Count > baseDepth) then
                expanded.Push( t )
                Advance( e )
            end if
            continue do
        end if

        if Tk( t ) = TK_IDENT then
            dim as InternId id = cast( InternId, t.literal )
            dim as PpMacro ptr m = MacroFor( e, id )
            dim as boolean expandable = (m <> 0) andalso (IsHidden( e, id ) = false)
            if expandable then
                if PpExpand( e, m, t ) then continue do
            end if
        end if

        Advance( e )
        expanded.Push( t )
    loop

    '' Drop anything the expansion left on the stack.
    while e.frames.Count > baseDepth
        PopFrame( e )
    wend

end sub

private function PpEvalRestOfLine _
    ( byref e as PpEngine, byval at as SourceLoc, byval what as string ) as boolean

    dim as TokenVec expanded
    PpExpandRestOfLine( e, expanded )

    dim as boolean ok = false
    dim as boolean result = PpEvalCondition( e, expanded, ok )
    if ok = false then Report( e, TKO0308, at, what )
    return result
end function

'' Defined further down this file; the option pragmas redefine a predefined macro.
declare sub PpDefineValue _
    ( byref e as PpEngine, byval spelling as string, byval body as string )

'' The OPTION pragmas -- '#pragma private' and '#pragma profile' -- and their stacks.
''
'' Each is a boolean that a predefined macro reports, so setting one is redefining
'' __FB_OPTION_PRIVATE__ or __FB_OPTION_PROFILE__. Measured by running fbc's #print:
''
''     (start)                       0
''     #pragma private              -1     bare form means TRUE
''     #pragma private = false       0
''     #pragma push( private, true )-1     push SETS as well as saves
''     #pragma pop( private )        0     restores what push saved
''     #pragma pop( private )              error 101, "Cannot pop stack, underflow"
''
'' Ignoring them left __FB_OPTION_PRIVATE__ at 0 for ever, and the two corpus files
'' that test these pragmas assert their way through all six states -- 21 '#assert'
'' lines that fbc passes and tiko-lang would have called failures.
private sub PragmaOption _
    ( byref e as PpEngine, byval at as SourceLoc, byval which as string, _
      byval isPush as boolean, byval isPop as boolean )

    dim as string nm = "__FB_OPTION_" & Text.UpperAscii( which ) & "__"
    dim as long idx = iif( which = "private", 0, 1 )

    if isPop then
        if e.optionDepth( idx ) <= 0 then
            Report( e, TKO0318, at, which )
            return
        end if
        e.optionDepth( idx ) -= 1
        dim as long v = e.optionStack( idx * PP_OPTION_STACK_MAX + e.optionDepth( idx ) )
        e.optionValue( idx ) = v
        PpDefineValue( e, nm, str( v ) )
        return
    end if

    '' The VALUE, if one is written: 'private = false', 'push( private, false )'.
    '' Absent means TRUE, which is what the bare form does.
    dim as long v = -1
    dim as Token t
    while PeekOnLine( e, t )
        '' 'true' and 'false' are PREDECLARED CONSTANTS, not keywords -- 'dim as
        '' integer true' is a duplicate definition to fbc, not a syntax error -- so
        '' they arrive as identifiers and are recognised by spelling.
        dim as TokenKind k = Tk( t )
        if k = TK_IDENT then
            select case Text.LowerAscii( e.names->Spelling( cast( InternId, t.literal ) ) )
            case "false" : v = 0
            case "true"  : v = -1
            end select
        end if
        if k = TK_INT_LIT then
            if t.literal = 0 then v = 0 else v = -1
        end if
        Advance( e )
    wend

    if isPush then
        if e.optionDepth( idx ) < PP_OPTION_STACK_MAX then
            e.optionStack( idx * PP_OPTION_STACK_MAX + e.optionDepth( idx ) ) = _
                e.optionValue( idx )
            e.optionDepth( idx ) += 1
        end if
    end if
    e.optionValue( idx ) = v
    PpDefineValue( e, nm, str( v ) )
end sub

'' ------------------------------------------------------------------- dispatch

private function PpDirectiveWord( byref e as PpEngine, byref outTok as Token ) as string
    if PeekOnLine( e, outTok ) = false then return ""
    dim as TokenKind k = Tk( outTok )
    if k = TK_IDENT then return e.names->Spelling( cast( InternId, outTok.literal ) )
    if IsKeywordKind( k ) then return Text.LowerAscii( TokenKindText( k ) )
    return ""
end function

'' Is the word after '#' actually a directive? This is the gate that makes it safe to
'' recognise directives inside a macro EXPANSION: a stringising '#param' is also a '#'
'' at the start of a body line, and treating that as a directive is what broke the
'' first attempt (204,274 diagnostics instead of 8,074).
function IsDirectiveWord( byval w as string ) as boolean
    select case w
    case "if", "ifdef", "ifndef", "elseif", "elseifdef", "elseifndef", "else", "endif", _
         "define", "undef", "macro", "endmacro", "include", "error", "print", "assert", _
         "pragma", "lang", "inclib", "libpath", "cmdline", "cinclude", "foreignlib"
        return true
    end select
    return false
end function

private sub PpDirective( byref e as PpEngine, byref hashTok as Token )
    dim as SourceLoc at = hashTok.loc
    dim as Token w
    dim as string word = PpDirectiveWord( e, w )
    if len( word ) = 0 then
        SkipToEol( e )
        return
    end if
    Advance( e )

    '' Conditional directives are handled even inside a skipped branch, because the
    '' nesting has to stay balanced. Everything else is ignored while skipping.
    select case word
    case "if"
        if Emitting( e ) then
            PushCond( e, PpEvalRestOfLine( e, at, "if" ), at )
        else
            SkipToEol( e )
            PushCond( e, false, at )
        end if
        return

    case "ifdef", "ifndef"
        dim as boolean defined_ = false
        dim as Token t
        if PeekOnLine( e, t ) then
            if Tk( t ) = TK_IDENT then
                defined_ = (MacroFor( e, cast( InternId, t.literal ) ) <> 0)
            end if
        end if
        SkipToEol( e )
        if word = "ifndef" then defined_ = (defined_ = false)
        PushCond( e, defined_, at )
        return

    case "elseif", "elseifdef", "elseifndef", "else"
        if e.conds.IsEmpty( ) then
            Report( e, TKO0302, at, word )
            SkipToEol( e )
            return
        end if
        dim as PpCond ptr c = @e.conds[e.conds.Count - 1]
        if c->seenElse then Report( e, TKO0302, at, word )

        dim as boolean want = false
        select case word
        case "else"
            c->seenElse = true
            SkipToEol( e )
            want = true
        case "elseif"
            if c->parentActive andalso (c->taken = false) then
                want = PpEvalRestOfLine( e, at, "elseif" )
            else
                SkipToEol( e )
            end if
        case else
            dim as Token t
            dim as boolean d = false
            if PeekOnLine( e, t ) then
                if Tk( t ) = TK_IDENT then
                    d = (MacroFor( e, cast( InternId, t.literal ) ) <> 0)
                end if
            end if
            SkipToEol( e )
            if word = "elseifndef" then d = (d = false)
            want = d
        end select

        c->active = c->parentActive andalso (c->taken = false) andalso want
        if c->active then c->taken = true
        return

    case "endif"
        SkipToEol( e )
        if e.conds.IsEmpty( ) then
            Report( e, TKO0302, at, "endif" )
        else
            e.conds.Pop( )
        end if
        return
    end select

    if Emitting( e ) = false then
        SkipToEol( e )
        return
    end if

    select case word
    case "include"
        PpInclude( e, at, false )

    case "define"
        PpDefine( e, at, false )

    case "macro"
        PpDefine( e, at, true )

    case "endmacro"
        '' Only reachable when unbalanced; PpDefine consumes the matching one.
        Report( e, TKO0311, at )
        SkipToEol( e )

    case "undef"
        PpUndef( e, at )

    case "error"
        dim as TokenVec rest
        CollectLine( e, rest )
        dim as string msg = ""
        for i as long = 0 to rest.Count - 1
            if i > 0 then msg += " "
            msg += SpellOf( e, rest[i] )
        next
        Report( e, TKO0309, at, msg )

    case "print"
        dim as TokenVec rest
        CollectLine( e, rest )
        dim as string msg = ""
        for i as long = 0 to rest.Count - 1
            if i > 0 then msg += " "
            msg += SpellOf( e, rest[i] )
        next
        Report( e, TKO0315, at, msg )

    case "assert"
        '' NOT a preprocessor directive. fbc's '#assert' takes a COMPILE-TIME
        '' expression that can name types and symbols -- the corpus writes
        '' '#assert typeof( b ) = typeof( byte )' -- so it cannot be evaluated here.
        '' It is passed through for the parser, with its arguments macro-expanded by
        '' the ordinary main loop.
        EmitTok( e, hashTok )
        EmitTok( e, w )
        '' ...EXCEPT 'defined X', WHOSE OPERAND MUST NOT EXPAND, which is the same rule
        '' '#if' applies and this had no share of: '#assert defined( M2 )' over a
        '' '#macro M2' substituted M2's BODY between DEFINED and ')' and the line became
        '' TKO0401. fbc compiles it clean.
        dim as Token dt
        if PeekOnLine( e, dt ) then
            dim as boolean isDefKw = (Tk( dt ) = KW_DEFINED)
            if (isDefKw = false) andalso (Tk( dt ) = TK_IDENT) then
                isDefKw = (e.names->Spelling( cast( InternId, dt.literal ) ) = "defined")
            end if
            if isDefKw then
                EmitTok( e, dt )
                Advance( e )
                dim as boolean paren = false
                if PeekOnLine( e, dt ) then
                    if Tk( dt ) = TK_LPAREN then
                        paren = true
                        EmitTok( e, dt )
                        Advance( e )
                    end if
                end if
                if PeekOnLine( e, dt ) then
                    EmitTok( e, dt )
                    Advance( e )
                end if
                if paren then
                    if PeekOnLine( e, dt ) then
                        if Tk( dt ) = TK_RPAREN then
                            EmitTok( e, dt )
                            Advance( e )
                        end if
                    end if
                end if
            end if
        end if

    case "lang"
        dim as Token t
        dim as string mode = ""
        if PeekOnLine( e, t ) then
            dim as string sp = SpellOf( e, t )
            dim as long a = instr( sp, """" )
            dim as long b = instrrev( sp, """" )
            if (a > 0) andalso (b > a) then mode = mid( sp, a + 1, b - a - 1 )
        end if
        SkipToEol( e )
        if (len( mode ) > 0) andalso (Text.LowerAscii( mode ) <> "fb") then
            Report( e, TKO0317, at, mode )
        end if

    case "pragma"
        '' Unknown pragmas warn, never error (docs/plan/03 section 6.2).
        dim as Token t
        dim as string which = ""
        if PeekOnLine( e, t ) then which = PpDirectiveWord( e, t )
        if len( which ) > 0 then Advance( e )

        '' 'push( private )' and 'pop( private )' name the option INSIDE the parens,
        '' so the word after the pragma is the verb and the one after '(' the option.
        dim as boolean isPush = (which = "push")
        dim as boolean isPop = (which = "pop")
        dim as string opt = which
        if isPush orelse isPop then
            if PeekOnLine( e, t ) then
                if Tk( t ) = TK_LPAREN then
                    Advance( e )
                    opt = PpDirectiveWord( e, t )
                    if len( opt ) > 0 then Advance( e )
                    if PeekOnLine( e, t ) then
                        if Tk( t ) = TK_COMMA then Advance( e )
                    end if
                end if
            end if
        end if

        select case opt
        case "private", "profile"
            PragmaOption( e, at, opt, isPush, isPop )
            SkipToEol( e )
        case "reserve"
            '' '#pragma reserve [ ( asm [, extern] ) ] name'. Only the two options exist;
            '' anything else is fbc's error 7. An empty '( )' and a missing comma are both
            '' tolerated, which was measured.
            dim as long modes = 0
            dim as boolean sawParen = false
            if PeekOnLine( e, t ) then
                if Tk( t ) = TK_LPAREN then
                    sawParen = true
                    Advance( e )
                    do
                        if PeekOnLine( e, t ) = false then exit do
                        if Tk( t ) = TK_RPAREN then
                            Advance( e )
                            exit do
                        end if
                        if Tk( t ) = TK_COMMA then
                            Advance( e )
                            continue do
                        end if
                        dim as string o = PpDirectiveWord( e, t )
                        if len( o ) = 0 then exit do
                        Advance( e )
                        select case o
                        case "asm"    : modes or= 2
                        case "extern" : modes or= 4
                        case else
                            Report( e, TKO0763, at, o )
                            SkipToEol( e )
                            return
                        end select
                    loop
                end if
            end if
            if sawParen = false then modes = 1
            '' THE NAME. Without one fbc says error 14; that half is not modelled here.
            dim as string rname = ""
            if PeekOnLine( e, t ) then rname = PpDirectiveWord( e, t )
            if len( rname ) > 0 then
                Advance( e )
                dim as InternId rid = e.names->Fold( e.names->GetString( rname ) )
                if modes <> 0 then
                    dim as boolean clash = false
                    for i as long = 0 to e.reserveNames.Count - 1
                        if e.reserveNames[i] <> cast( ulong, rid ) then continue for
                        if (cast( long, e.reserveModes[i] ) and modes) <> 0 then
                            clash = true
                            exit for
                        end if
                    next
                    if clash then
                        Report( e, TKO0764, at, rname )
                    else
                        e.reserveNames.Push( cast( ulong, rid ) )
                        e.reserveModes.Push( cast( ulong, modes ) )
                        '' ...AND ONTO THE RESULT, which outlives this engine. Only the
                        '' plain form reserves the name for the LANGUAGE: '( asm )' and
                        '' '( extern )' reserve it for the assembler and the linker, and
                        '' fbc still lets the source declare it. Measured: 'reserve foo'
                        '' then 'dim as integer foo' is error 4, and the parenthesised
                        '' forms are accepted.
                        if (modes and 1) <> 0 then
                            if e.outp <> 0 then
                                e.outp->reservedNames.Push( cast( ulong, rid ) )
                            end if
                        end if
                    end if
                end if
            end if
            SkipToEol( e )
        case "once"
            '' '#pragma once' IS '#include once' SAID FROM THE OTHER END, and it was a
            '' NO-OP -- listed as recognised and then skipped. So a header guarded that
            '' way was re-read every time, and one that includes ITSELF, which
            '' pp/inc2self.bi does, recursed until the frame cap.
            ''
            '' The file is the one this directive is IN, not the one being included,
            '' which is why it cannot share PpInclude's push.
            if e.frames.IsEmpty( ) = false then
                dim as FileId cf = e.frames[e.frames.Count - 1].file
                if cf <> FILE_NONE then
                    if PpAlreadyOnce( e, cf ) = false then
                        e.onceFiles.Push( cast( ulong, cf ) )
                    end if
                end if
            end if
            SkipToEol( e )
        case else
            SkipToEol( e )
            select case which
            case "push", "pop", "msg", "reserve"
            case else
                if len( which ) > 0 then Report( e, TKO0312, at, which )
            end select
        end select

    case "inclib", "libpath"
        '' THE SOURCE'S HALF OF THE LINK LINE. '#inclib "z"' is exactly '-l z' and
        '' '#libpath "d"' exactly '-p d' -- measured against fbc 1.20.0, which emits
        '' -lz in both cases and in the same place. The order is command line first,
        '' then pragma, then the compiler's own directories; also measured.
        ''
        '' NOT EXPANDED. fbc takes the literal as written; a macro that produced a
        '' library name would be a different feature and is not one fbc has.
        dim as Token t2
        if PeekOnLine( e, t2 ) = false then
            Report( e, TKO0326, at, word )
            SkipToEol( e )
            return
        end if
        if Tk( t2 ) <> TK_STRING_LIT then
            Report( e, TKO0326, t2.loc, word )
            SkipToEol( e )
            return
        end if
        dim as string spelled2 = SpellOf( e, t2 )
        dim as long qa = instr( spelled2, """" )
        dim as long qb = instrrev( spelled2, """" )
        dim as string val2 = ""
        if (qa > 0) andalso (qb > qa) then val2 = mid( spelled2, qa + 1, qb - qa - 1 )
        Advance( e )
        SkipToEol( e )
        '' AN EMPTY ONE IS DROPPED rather than passed on: '-l' with nothing after it
        '' is a clang error about the NEXT argument, which names the wrong thing.
        if len( val2 ) > 0 then
            if word = "inclib" then
                e.outp->incLibs.Push( val2 )
            else
                e.outp->libPaths.Push( val2 )
            end if
        end if

    case "cmdline"
        '' NOT IMPLEMENTED, AND NOW IT SAYS SO. It was skipped in silence, which is
        '' the worst of the three options: the corpus writes '#cmdline "-d
        '' CMDLINESYMBOL"' and '#cmdline "-w error"', so a skipped directive means
        '' the symbol is undefined or the warnings are not errors, and the file then
        '' compiles to something the author did not ask for with nothing said.
        ''
        '' It is not the same shape as '#inclib' and '#libpath'. Those name one
        '' thing the link needs; '#cmdline' injects arbitrary OPTIONS from inside a
        '' source that is already being compiled under the options it wants to
        '' change. fbc's answer is '-restart' -- it re-invokes itself with the new
        '' command line -- and anything less than that is a subset that works until
        '' someone writes the option that needs it.
        if e.cfg->reportUnsupported then Report( e, TKO0310, at, word )
        SkipToEol( e )

    case "line"
        '' '#line <number> [ "file" ]' RENUMBERS FROM THIS LINE, not from the next --
        '' measured: '#line 100' on physical line 2 makes physical line 3 report 101,
        '' and the error for a fault on physical line 4 says '(103)'.
        ''
        '' The number is MACRO-EXPANDED but is not an expression. Both halves are
        '' measured: '#define N 50' then '#line N' renumbers, while '#line 10+2' is
        '' fbc's error 3 at the '+' and '#line -3' its error 17 at the '-'. So a
        '' single literal, after expansion, and nothing cleverer.
        dim as TokenVec lnToks
        PpExpandRestOfLine( e, lnToks )

        if lnToks.Count = 0 then
            Report( e, TKO0331, at )
        elseif Tk( lnToks[0] ) <> TK_INT_LIT then
            Report( e, TKO0331, lnToks[0].loc )
        else
            dim as TokenVec one
            one.Push( lnToks[0] )
            dim as boolean lnOk = false
            dim as longint lnVal = PpEvalIntTokens( e, one, lnOk )
            if lnOk = false then
                Report( e, TKO0331, lnToks[0].loc )
            else
                '' fbc's line counter is 32 bits: '#line 3000000000' makes the next
                '' line report -1294967295 rather than saturating or erroring.
                dim as long shownLine = cast( long, lnVal )

                dim as InternId shownName = INTERN_NONE
                dim as boolean hasName = false
                dim as boolean lnBad = false
                if lnToks.Count >= 2 then
                    if Tk( lnToks[1] ) <> TK_STRING_LIT then
                        '' '#line 10 foo.bas' is fbc's error 3, and it applies the
                        '' NUMBER before rejecting the name -- the message reads
                        '' 'p.bas(10)'. So the mark is still recorded below.
                        Report( e, TKO0332, lnToks[1].loc )
                        lnBad = true
                    else
                        dim as string lnSp = SpellOf( e, lnToks[1] )
                        dim as long lq = instr( lnSp, """" )
                        dim as long rq = instrrev( lnSp, """" )
                        dim as string nm = ""
                        if (lq > 0) andalso (rq > lq) then nm = mid( lnSp, lq + 1, rq - lq - 1 )
                        shownName = e.names->GetString( nm )
                        hasName = true
                    end if
                end if
                if (lnBad = false) andalso (lnToks.Count > 2) then
                    Report( e, TKO0332, lnToks[2].loc )
                end if

                dim as DecodedLoc lnAt = e.src->Decode( at )
                if lnAt.file <> FILE_NONE then
                    e.src->AddLineMark( lnAt.file, lnAt.physLine, shownLine, _
                                        shownName, hasName )
                end if
            end if
        end if

    case "cinclude"
        if e.cfg->reportUnsupported then Report( e, TKO0310, at, word )
        SkipToEol( e )

    case "foreignlib"
        '' #foreignlib ID (STATIC|DYNAMIC) "spec" (, "spec")*
        dim as Token ft
        if PeekOnLine( e, ft ) = false then
            Report( e, TKO0327, at )
            SkipToEol( e )
            return
        end if
        if Tk( ft ) <> TK_IDENT then
            Report( e, TKO0327, ft.loc )
            SkipToEol( e )
            return
        end if
        dim as string flId = ucase( SpellOf( e, ft ) )
        Advance( e )

        '' STATIC OR DYNAMIC, MANDATORY. fbc never infers it from what happens to be
        '' on disk -- the same directory may hold both, and picking by luck would
        '' make the build depend on which was built last.
        dim as boolean flStatic = false
        dim as boolean flHaveKind = false
        if PeekOnLine( e, ft ) then
            dim as string kw = ucase( SpellOf( e, ft ) )
            if kw = "STATIC" then
                flStatic = true
                flHaveKind = true
                Advance( e )
            elseif kw = "DYNAMIC" then
                flStatic = false
                flHaveKind = true
                Advance( e )
            end if
        end if
        if flHaveKind = false then
            Report( e, TKO0328, at, flId )
            SkipToEol( e )
            return
        end if

        dim as string flSig = ""
        dim as boolean flBad = false
        do
            if PeekOnLine( e, ft ) = false then
                Report( e, TKO0327, at )
                flBad = true
                exit do
            end if
            if Tk( ft ) <> TK_STRING_LIT then
                Report( e, TKO0327, ft.loc )
                flBad = true
                exit do
            end if
            dim as string sp2 = SpellOf( e, ft )
            dim as long qa2 = instr( sp2, """" )
            dim as long qb2 = instrrev( sp2, """" )
            dim as string spec = ""
            if (qa2 > 0) andalso (qb2 > qa2) then spec = mid( sp2, qa2 + 1, qb2 - qa2 - 1 )
            Advance( e )
            if len( spec ) = 0 then
                Report( e, TKO0327, ft.loc )
                flBad = true
                exit do
            end if
            dim as string tried = ""
            dim as string got = ForeignLibResolve_( e, at, spec, flStatic, tried )
            if len( got ) = 0 then
                dim as string kindTxt = iif( flStatic, "static", "dynamic" )
                Report( e, TKO0329, at, flId & " " & kindTxt & " " & spec, tried )
                flBad = true
                exit do
            end if
            e.outp->foreignLibFiles.Push( got )
            flSig += got & ";"
            '' A comma continues the list; anything else ends it.
            if PeekOnLine( e, ft ) = false then exit do
            if Tk( ft ) <> TK_COMMA then exit do
            Advance( e )
        loop

        if flBad = false then
            '' THE SAME NAME TWICE IS A REBIND ONLY IF THE SET DIFFERS. Binding it
            '' identically twice is what an include guard-less header does when two
            '' files pull it in, and that is not a mistake.
            dim as boolean flDup = false
            for i as long = 0 to e.outp->foreignLibNames.Count - 1
                dim as string ent = e.outp->foreignLibNames[i]
                dim as long tabAt = instr( ent, chr( 9 ) )
                if left( ent, tabAt - 1 ) = flId then
                    if mid( ent, tabAt + 1 ) <> flSig then Report( e, TKO0330, at, flId )
                    flDup = true
                    exit for
                end if
            next
            if flDup = false then
                e.outp->foreignLibNames.Push( flId & chr( 9 ) & flSig )
            end if
        end if
        SkipToEol( e )

    case else
        Report( e, TKO0300, at, word )
        SkipToEol( e )
    end select
end sub

'' ------------------------------------------------------------ predefined macros

private sub PpDefineValue _
    ( byref e as PpEngine, byval spelling as string, byval body as string )

    dim as InternId id = e.names->GetString( Text.LowerAscii( spelling ) )
    dim as PpMacro ptr m = PpFindOrAddMacro( e, id )
    m->isDefined = true
    m->isFunc = false
    m->builtin = PPB_NONE
    m->body.Clear( )
    if len( body ) > 0 then RelexInto( e, body, LOC_NONE, m->body )
end sub

'' A predefined FUNCTION-LIKE macro of one parameter.
''
'' LOBYTE / HIBYTE / LOWORD / HIWORD are not keywords and not compiler intrinsics --
'' measured, fbc reports "Argument count mismatch, expanding: LOBYTE" for a two-argument
'' call and "Duplicated definition, lobyte" (the SYMBOL wording, not the keyword's
'' "found 'sgn'") for 'dim lobyte'. They are predefined MACROS, and 'fbc -pp' prints
'' their bodies outright. A one-parameter helper is all four of them need.
private sub PpDefineFunc1 _
    ( byref e as PpEngine, byval spelling as string, byval body as string )

    dim as InternId id = e.names->GetString( Text.LowerAscii( spelling ) )
    dim as PpMacro ptr m = PpFindOrAddMacro( e, id )
    m->isDefined = true
    m->isFunc = true
    m->isVariadic = false
    m->optParens = false
    m->builtin = PPB_NONE
    m->params.Clear( )
    m->params.Push( cast( ulong, e.names->GetString( "x" ) ) )
    m->body.Clear( )
    RelexInto( e, body, LOC_NONE, m->body )
end sub

private sub PpDefineBuiltinMacro _
    ( byref e as PpEngine, byval spelling as string, byval which as PpBuiltin, _
      byval isFunc as boolean )

    dim as InternId id = e.names->GetString( Text.LowerAscii( spelling ) )
    dim as PpMacro ptr m = PpFindOrAddMacro( e, id )
    m->isDefined = true
    m->isFunc = isFunc
    m->builtin = cast( ubyte, which )
end sub

private sub PpDefineBuiltins( byref e as PpEngine )
    '' Identity. __FB_VERSION__ deliberately reports the fbc release tiko-lang is
    '' compatible with, so existing '#if __FB_VERSION__ >= ...' guards keep working;
    '' tiko-lang's own identity is __TKO_VERSION__ (docs/plan/03 section 6.3).
    PpDefineValue( e, "__FB_VERSION__", """" & TKO_FBC_COMPAT & """" )
    PpDefineValue( e, "__TKO_VERSION__", """" & _
        str( TKO_VERSION_MAJOR ) & "." & str( TKO_VERSION_MINOR ) & "." & _
        str( TKO_VERSION_PATCH ) & TKO_VERSION_SUFFIX & """" )
    PpDefineValue( e, "__FB_SIGNATURE__", """tiko-lang""" )
    PpDefineValue( e, "__FB_LANG__", """fb""" )
    PpDefineValue( e, "__FB_BACKEND__", """llvm""" )

    '' Target. From the TARGET, not from an '#ifdef' at tiko-lang's own compile time, which
    '' is what made '-target linux-x86_64' produce a Windows environment.
    dim as boolean onWindows = true
    dim as boolean on64 = true
    if e.cfg <> 0 then
        onWindows = e.cfg->targetIsWindows
        on64 = e.cfg->targetIs64
    end if
    '' EMPTY-BODIED, like __FB_64BIT__ below and for the same measured reason:
    '' '#if __FB_WIN32__' is error 9 "Expected expression" in fbc, not a true branch.
    if onWindows then
        PpDefineValue( e, "__FB_WIN32__", "" )
    else
        PpDefineValue( e, "__FB_LINUX__", "" )
        PpDefineValue( e, "__FB_UNIX__", "" )
    end if

    '' DEFINED AND EMPTY on a 64-bit target, and NOT DEFINED AT ALL on a 32-bit one.
    '' Measured: fbc errors on '#if __FB_64BIT__' -- "Expected expression" -- because
    '' the macro has no body, and the corpus agrees, testing it with #ifdef, #ifndef or
    '' defined() in all 208 places it appears and never with #if.
    if on64 then
        PpDefineValue( e, "__FB_64BIT__", "" )
    end if
    PpDefineValue( e, "__FB_PCOS__", "" )

    '' The instruction set, empty-bodied like the rest of this group. fbc defines it
    '' on x86 and x86-64 alike; 11 corpus references, every one an '#ifdef' or a
    '' 'defined( )', and tiko-lang defined it NOWHERE -- so all eleven took the wrong branch.
    PpDefineValue( e, "__FB_X86__", "" )

    '' Everything tiko-lang is not is NOT DEFINED AT ALL.
    ''
    '' They used to be defined and zero, on the reasoning that the corpus writes
    '' '#if __FB_DOS__' rather than '#ifdef'. That reasoning was never true and is
    '' now measured false: of the 43 references to __FB_DOS__, __FB_ARM__, __FB_JS__,
    '' __FB_XBOX__ and __FB_SSE__ in the corpus, the number written as a bare '#if'
    '' is ZERO -- every one is '#ifdef', '#ifndef' or 'defined( )'. Defining them at
    '' all inverted all 43, silently, in the direction that compiles the wrong half
    '' of a platform test. fbc defines none of them on this target.
    '' -1 UNDER '-mt', 0 OTHERWISE, which is fbc's spelling of a true boolean and
    '' was measured rather than assumed: '#print __FB_MT__' emits 0 without the
    '' flag and -1 with it. Note it is DEFINED either way, so '#ifdef __FB_MT__' is
    '' true in both -- code testing for threading has to use '#if'.
    ''
    '' This was hard-coded to 0, so '-mt' changed nothing anywhere.
    PpDefineValue( e, "__FB_MT__", iif( e.cfg->threadSafe, "-1", "0" ) )
    PpDefineValue( e, "__FB_DEBUG__", "0" )
    '' __FB_ERR__ IS A BITMASK, and the values are fbc's, measured with '#print':
    ''
    ''     no flag  0        -e  513        -ex  515        -exx  1823
    ''
    '' Not decoded into named bits here. The corpus tests the WHOLE value, headers
    '' branch on 'is it nonzero', and inventing names for bits whose meaning has not
    '' been measured would be a guess wearing a label.
    dim as string errVal = "0"
    select case e.cfg->errLevel
    case 1 : errVal = "513"
    case 2 : errVal = "515"
    case 3 : errVal = "1823"
    end select
    PpDefineValue( e, "__FB_ERR__", errVal )
    PpDefineValue( e, "__FB_GCC__", "0" )
    '' STRINGS, not numbers. The corpus writes '#if __FB_FPMODE__ = "fast"' and
    '' '#if __FB_FPMODE__ <> "fast"' -- comparing those against 0 is not false, it is
    '' meaningless, and six files depend on the answer. Measured from fbc on this
    '' target: FPMODE "precise", FPU "x87", ASM "intel".
    PpDefineValue( e, "__FB_FPU__", """x87""" )
    PpDefineValue( e, "__FB_FPMODE__", """precise""" )
    PpDefineValue( e, "__FB_ASM__", """intel""" )
    PpDefineValue( e, "__FB_OPTION_BYVAL__", "0" )
    PpDefineValue( e, "__FB_OPTION_DYNAMIC__", "0" )
    PpDefineValue( e, "__FB_OPTION_ESCAPE__", "0" )
    '' -1, NOT 0. Measured with fbc's own '#print': both of these are TRUE by default
    '' on this toolchain, and the two corpus files that walk '#pragma profile' through
    '' its states assert exactly that on their first line. The pragma stack below
    '' starts from the same value, or the first pop would restore the wrong one.
    PpDefineValue( e, "__FB_OPTION_EXPLICIT__", "-1" )
    PpDefineValue( e, "__FB_OPTION_GOSUB__", "0" )
    PpDefineValue( e, "__FB_OPTION_PRIVATE__", "0" )
    PpDefineValue( e, "__FB_OPTION_PROFILE__", "-1" )
    e.optionValue( 1 ) = -1
    PpDefineValue( e, "__FB_OUT_EXE__", "-1" )
    PpDefineValue( e, "__FB_OUT_LIB__", "0" )
    PpDefineValue( e, "__FB_OUT_DLL__", "0" )
    PpDefineValue( e, "__FB_OUT_OBJ__", "0" )

    '' The BYTE/WORD extractors. Bodies copied from 'fbc -pp', which prints them
    '' verbatim; HIWORD is the one that differs by target, because on win32 the
    '' &hFFFF0000 mask is redundant once the shift has run and fbc omits it.
    PpDefineFunc1( e, "lobyte", "(cuint(x) and &h000000FF)" )
    PpDefineFunc1( e, "hibyte", "((cuint(x) and &h0000FF00) shr 8)" )
    PpDefineFunc1( e, "loword", "(cuint(x) and &h0000FFFF)" )
    if on64 then
        PpDefineFunc1( e, "hiword", "((cuint(x) and &hFFFF0000) shr 16)" )
    else
        PpDefineFunc1( e, "hiword", "(cuint(x) shr 16)" )
    end if

    '' Builtins that manipulate tokens rather than carry a value.
    PpDefineBuiltinMacro( e, "__FILE__", PPB_FILE, false )
    PpDefineBuiltinMacro( e, "__FILE_NQ__", PPB_FILE_NQ, false )
    PpDefineBuiltinMacro( e, "__PATH__", PPB_PATH, false )
    PpDefineBuiltinMacro( e, "__LINE__", PPB_LINE, false )
    PpDefineBuiltinMacro( e, "__DATE__", PPB_DATE, false )
    PpDefineBuiltinMacro( e, "__DATE_ISO__", PPB_DATE_ISO, false )
    PpDefineBuiltinMacro( e, "__TIME__", PPB_TIME, false )
    PpDefineBuiltinMacro( e, "__FB_QUOTE__", PPB_QUOTE, true )
    PpDefineBuiltinMacro( e, "__FB_UNQUOTE__", PPB_UNQUOTE, true )
    PpDefineBuiltinMacro( e, "__FB_ARG_COUNT__", PPB_ARG_COUNT, true )
    PpDefineBuiltinMacro( e, "__FB_ARG_EXTRACT__", PPB_ARG_EXTRACT, true )
    PpDefineBuiltinMacro( e, "__FB_IIF__", PPB_IIF, true )
    PpDefineBuiltinMacro( e, "__FB_ARG_LEFTOF__", PPB_ARG_LEFTOF, true )
    PpDefineBuiltinMacro( e, "__FB_ARG_RIGHTOF__", PPB_ARG_RIGHTOF, true )
    PpDefineBuiltinMacro( e, "__FB_ARG_LISTEXPAND__", PPB_ARG_LISTEXPAND, true )
    PpDefineBuiltinMacro( e, "__FB_JOIN__", PPB_JOIN, true )
    PpDefineBuiltinMacro( e, "__FB_EVAL__", PPB_EVAL, true )
    PpDefineBuiltinMacro( e, "__FB_UNIQUEID__", PPB_UNIQUEID, true )
    PpDefineBuiltinMacro( e, "__FB_UNIQUEID_PUSH__", PPB_UNIQUEID_PUSH, true )
    PpDefineBuiltinMacro( e, "__FB_UNIQUEID_POP__", PPB_UNIQUEID_POP, true )
end sub

private sub PpDefineFromCommandLine( byref e as PpEngine )
    for each d as string in *e.cfg->defines
        dim as long at = instr( d, "=" )
        if at > 0 then
            PpDefineValue( e, left( d, at - 1 ), mid( d, at + 1 ) )
        else
            PpDefineValue( e, d, "-1" )
        end if
    next
end sub

end namespace

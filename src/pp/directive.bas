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
    dim as DecodedLoc d = e.src->Decode( at )
    dim as string here = e.src->PathOf( d.file )
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
private function PpEvalRestOfLine _
    ( byref e as PpEngine, byval at as SourceLoc, byval what as string ) as boolean

    dim as TokenVec ptr raw = new TokenVec
    CollectLine( e, *raw )

    dim as long baseDepth = e.frames.Count
    PushFrame( e, raw, INTERN_NONE, FILE_NONE, true )

    dim as TokenVec expanded
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
        case else
            SkipToEol( e )
            select case which
            case "once", "push", "pop", "msg", "reserve"
            case else
                if len( which ) > 0 then Report( e, TKO0312, at, which )
            end select
        end select

    case "inclib", "libpath", "cmdline"
        '' Recorded for the driver in a later phase; no semantic effect here.
        SkipToEol( e )

    case "cinclude", "foreignlib"
        if e.cfg->reportUnsupported then Report( e, TKO0310, at, word )
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
    PpDefineValue( e, "__FB_MT__", "0" )
    PpDefineValue( e, "__FB_DEBUG__", "0" )
    PpDefineValue( e, "__FB_ERR__", "0" )
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

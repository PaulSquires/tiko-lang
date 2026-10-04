'' macros.bas -- object-like macros as constants and aliases. See import.bi.
''
'' '#define MAX_PATH 260' is a token sequence, not a value, and what it means depends on
'' everything the header defined before it. So its value is not worked out here by reading
'' the tokens: CLANG folds it, in the real header's context, through a second parse of the
'' same unit with one probe per macro appended:
''
''     __auto_type __tko_probe_17 = (MAX_PATH);
''
'' and clang_Cursor_Evaluate reads the initialiser back. An integer becomes 'const
'' MAX_PATH = 260' -- decimal, with 'ull' when clang says it is unsigned -- a float its
'' FreeBASIC STR( ), and a string a quoted literal.
''
'' A MACRO THAT IS NOT AN EXPRESSION -- a keyword, a statement, half of one -- breaks the
'' probe parse. Its line in the unit says which probe it was; that one is dropped and the
'' parse runs again, at most MAX_ROUNDS times. A macro whose brackets do not balance never
'' gets that far: rpc.h's '#define RpcTryExcept __try {' opens a block that clang's error
'' recovery closes at the END of the unit, and the errors it reports there cost the last
'' three probes their values -- windows.h's SOFTKEYBOARD_TYPE_T1 among them.
''
'' WHAT IS LEFT is asked a second question: what does it EXPAND to? Windows spells ~1,100
'' names as macros standing for another name --
''
''     #define GetMessage __MINGW_NAME_AW(GetMessage)
''
'' -- and stringifying the macro gives its full expansion, 'GetMessageW', which clang hands
'' back as a string. When that is a plain identifier naming something this import declared,
'' the macro becomes '#define GetMessage GetMessageW', so unsuffixed Win32 code works as
'' written.
''
'' NOT IMPORTED, deliberately: function-like macros (a C expression compiler is the only
'' honest translation, and a nearly-right one is worse than none); NULL (FreeBASIC's own
'' crt headers define it); anything spelled __x or _X (the implementation's); a value that
'' is a pointer; infinity and NaN, which FreeBASIC has no literal for.

#include once "cimport/import.bi"

namespace Tko.CImport

const MAX_ROUNDS = 16
const CXEval_Int = 1, CXEval_Float = 2, CXEval_StrLiteral = 4
const CXType_Pointer_ = 101
const CXToken_Punctuation = 0     '' Index.h:4999
const NONFINITE_ = "!nonfinite"     '' a probe value no FreeBASIC literal spells

'' ---------------------------------------------------------------- candidates

private function IsReservedSpelling_( byref n as string ) as boolean
    if len( n ) < 2 then return false
    if n[0] <> asc( "_" ) then return false
    if n[1] = asc( "_" ) then return true
    return (n[1] >= asc( "A" )) andalso (n[1] <= asc( "Z" ))
end function

'' Do the replacement list's (), [] and {} balance? Tokens, not characters -- a '(' in a
'' string or character literal is not a bracket.
private function Balanced_( byref x as CImp, byval c as CXCursor ) as boolean
    dim as CXToken ptr toks
    dim as ulong nt
    x.api->tokenize( x.tu, x.api->getCursorExtent( c ), @toks, @nt )
    if toks = 0 then return true
    dim as long depth = 0
    dim as boolean ok = true
    for i as long = 0 to cast( long, nt ) - 1
        if x.api->getTokenKind( toks[i] ) = CXToken_Punctuation then
            select case ClangText( *x.api, x.api->getTokenSpelling( x.tu, toks[i] ) )
            case "(", "[", "{" : depth += 1
            case ")", "]", "}" : depth -= 1
            end select
            if depth < 0 then ok = false
        end if
    next
    x.api->disposeTokens( x.tu, toks, nt )
    return ok andalso (depth = 0)
end function

sub MacroCandidate( byref x as CImp, byval c as CXCursor )
    if x.opts->noMacros then return
    if x.api->Cursor_isMacroFunctionLike( c ) then return
    if x.api->Cursor_isMacroBuiltin( c ) then return
    dim as string n = CursorName( x, c )
    if len( n ) = 0 then return
    if n = "NULL" then return
    if IsReservedSpelling_( n ) then return
    '' A MACRO FROM NO HEADER -- clang's command line: -cdefine, and the UNICODE that
    '' '#define UNICODE' before '#cinclude' passes on. It is the caller's, not the
    '' header's, and 'const UNICODE = 1' under a FreeBASIC-side UNICODE macro read as
    '' 'const  = 1'.
    dim as any ptr mf
    x.api->getExpansionLocation( x.api->getCursorLocation( c ), @mf, 0, 0, 0 )
    if mf = 0 then return
    if Balanced_( x, c ) = false then return
    '' A macro redefined keeps its FIRST position; its value is whatever clang says it is
    '' at the end of the unit, which is where the probes are. By interned id: a scan of
    '' the list per macro was five seconds of windows.h's 23,000.
    dim as long nid = cast( long, x.strs.GetString( n ) )
    if nid < x.macroSeen.Count then
        if x.macroSeen[nid] then return
    end if
    MacroSeen( x, n )
    x.macroNames.Push( n )
end sub

'' Marks a macro as considered -- by this import, or by the earlier one a delta import is
'' seeded with, whose binding already has it.
sub MacroSeen( byref x as CImp, byref n as string )
    dim as long nid = cast( long, x.strs.GetString( n ) )
    while x.macroSeen.Count <= nid
        x.macroSeen.Push( 0 )
    wend
    x.macroSeen[nid] = 1
end sub

sub NoteDecl( byref x as CImp, byref cname as string, byval uid as long )
    dim as long id = cast( long, x.strs.GetString( cname ) )
    while x.cDeclUsr.Count <= id
        x.cDeclUsr.Push( 0 )
    wend
    x.cDeclUsr[id] = uid + 1
end sub

'' ---------------------------------------------------------------- one probe parse

type Probe_
    as CImp ptr x
    as string prefix              '' '__tko_probe_' or '__tko_alias_'
    as string ptr values          '' index -> text, "" when nothing usable
    as long n
    as boolean aliasMode
end type

private function ProbeIndex_( byref nm as string, byref prefix as string ) as long
    if left( nm, len( prefix ) ) <> prefix then return -1
    return valint( mid( nm, len( prefix ) + 1 ) )
end function

'' A value clang folded, as FreeBASIC text -- or "" when there is nothing to import.
'' THE SHORTEST SPELLING THAT READS BACK AS THE SAME DOUBLE -- 15, 16 or 17 significant
'' digits. 'str( d )' gave 16 at most, so DBL_MAX's 1.797693134862316e+308 read back as
'' INF and 0.1 + 0.2 as 0.3 (audit F-50); 17 always round-trips.
private function FloatText_( byval d as double ) as string
    dim as zstring * 40 buf
    for digits as long = 15 to 17
        snprintf( @buf, 40, "%.*g", digits, d )
        if strtod( @buf, 0 ) = d then exit for
    next
    return buf
end function

private function ValueText_( byref x as CImp, byval vd as CXCursor ) as string
    '' A POINTER-VALUED macro -- '((HANDLE)-1)', '((void*)0)' -- evaluates to an integer
    '' too. It is not a constant FreeBASIC can hold as the same thing, so it is dropped.
    dim as CXType vt = x.api->getCanonicalType( x.api->getCursorType( vd ) )
    dim as any ptr ev = x.api->Cursor_Evaluate( vd )
    if ev = 0 then return ""
    dim as string r
    select case x.api->EvalResult_getKind( ev )
    case CXEval_Int
        if vt.kind <> CXType_Pointer_ then
            dim as longint v = x.api->EvalResult_getAsLongLong( ev )
            if x.api->EvalResult_isUnsignedInt( ev ) then
                r = str( cast( ulongint, v ) ) & "ull"
            else
                r = str( v )
            end if
        end if
    case CXEval_Float
        dim as double d = x.api->EvalResult_getAsDouble( ev )
        '' A FINITE STAND-IN FOR INFINITY WOULD BE A DIFFERENT NUMBER WEARING THE RIGHT
        '' NAME. NaN is the value unequal to itself; infinity is the one that stays itself
        '' when halved. Either is marked, to be ledgered rather than lost without a word.
        if (d = d) andalso ((d = 0) orelse (d / 2 <> d)) then r = FloatText_( d ) else r = NONFINITE_
    case CXEval_StrLiteral
        dim as zstring ptr z = x.api->EvalResult_getAsStr( ev )
        if z <> 0 then
            dim as string s = *z
            '' A quote or a line break has no spelling in a FreeBASIC string literal.
            if (instr( s, """" ) = 0) andalso (instr( s, chr( 10 ) ) = 0) andalso _
               (instr( s, chr( 13 ) ) = 0) then
                r = """" & s & """"
            end if
        end if
    end select
    x.api->EvalResult_dispose( ev )
    return r
end function

private function ProbeVisit_ cdecl _
    ( byval c as CXCursor, byval parent as CXCursor, byval client as any ptr ) as long
    dim as Probe_ ptr p = client
    dim as CImp ptr xp = p->x
    if xp->api->getCursorKind( c ) <> CXCursor_VarDecl then return CXChildVisit_Continue
    dim as long i = ProbeIndex_( CursorName( *xp, c ), p->prefix )
    if (i < 0) orelse (i >= p->n) then return CXChildVisit_Continue
    if p->aliasMode then
        dim as any ptr ev = xp->api->Cursor_Evaluate( c )
        if ev <> 0 then
            if xp->api->EvalResult_getKind( ev ) = CXEval_StrLiteral then
                dim as zstring ptr z = xp->api->EvalResult_getAsStr( ev )
                if z <> 0 then p->values[i] = *z
            end if
            xp->api->EvalResult_dispose( ev )
        end if
    else
        p->values[i] = ValueText_( *xp, c )
    end if
    return CXChildVisit_Continue
end function

'' Parse the unit with 'lines' appended -- line k is probe k -- and read each probe back.
'' Probes whose line clang reports an error on are cleared from 'live' and the parse runs
'' again; returns false only when an error cannot be pinned on a probe.
private function ProbeParse_( byref x as CImp, lines() as string, live() as boolean, _
                              byval n as long, byref prelude as string, byref prefix as string, _
                              byval aliasMode as boolean, values() as string ) as boolean
    dim as string unitName = "tiko-cimport-macros.c"
    dim as long baseLine = 1
    for i as long = 1 to len( x.unitText )
        if x.unitText[i - 1] = 10 then baseLine += 1
    next
    for i as long = 1 to len( prelude )
        if prelude[i - 1] = 10 then baseLine += 1
    next

    dim as Tko.StrVec av
    for i as long = 0 to x.args.Count - 1
        av.Push( x.args[i] )
    next
    av.Push( "-ferror-limit=0" )
    dim as zstring ptr argv( 0 to av.Count )
    for i as long = 0 to av.Count - 1
        argv( i ) = strptr( av[i] )
    next

    for round as long = 1 to MAX_ROUNDS
        dim as string text = x.unitText & prelude
        for i as long = 0 to n - 1
            if live( i ) then text &= lines( i )
            text &= chr( 10 )
        next
        dim as CXUnsavedFile uf
        uf.Filename = strptr( unitName )
        uf.Contents = strptr( text )
        uf.Length = len( text )
        dim as any ptr idx = x.api->createIndex( 0, 0 )
        dim as any ptr tu = x.api->parseTranslationUnit( idx, strptr( unitName ), @argv( 0 ), _
            av.Count, @uf, 1, CXTranslationUnit_DetailedPreprocessingRecord or _
            CXTranslationUnit_SkipFunctionBodies or CXTranslationUnit_KeepGoing )
        if tu = 0 then
            x.api->disposeIndex( idx )
            return false
        end if

        dim as long dropped = 0, unpinned = 0
        for di as long = 0 to x.api->getNumDiagnostics( tu ) - 1
            dim as any ptr d = x.api->getDiagnostic( tu, di )
            if x.api->getDiagnosticSeverity( d ) >= 3 then
                dim as any ptr f
                dim as ulong ln, col, off
                x.api->getExpansionLocation( x.api->getDiagnosticLocation( d ), @f, @ln, @col, @off )
                dim as long k = cast( long, ln ) - baseLine
                dim as string fn
                if f <> 0 then fn = ClangText( *x.api, x.api->getFileName( f ) )
                if (fn = unitName) andalso (k >= 0) andalso (k < n) then
                    if live( k ) then
                        live( k ) = false
                        dropped += 1
                    end if
                else
                    unpinned += 1
                end if
            end if
            x.api->disposeDiagnostic( d )
        next

        if (dropped = 0) andalso (unpinned = 0) then
            dim as Probe_ p
            p.x = @x
            p.prefix = prefix
            p.values = @values( 0 )
            p.n = n
            p.aliasMode = aliasMode
            x.api->visitChildren( x.api->getTranslationUnitCursor( tu ), @ProbeVisit_, @p )
            x.api->disposeTranslationUnit( tu )
            x.api->disposeIndex( idx )
            return true
        end if
        x.api->disposeTranslationUnit( tu )
        x.api->disposeIndex( idx )
        if dropped = 0 then return false
    next
    return false
end function

'' ---------------------------------------------------------------- the pass

private function IsIdent_( byref s as string ) as boolean
    if len( s ) = 0 then return false
    for i as long = 0 to len( s ) - 1
        dim as ubyte ch = s[i]
        dim as boolean ok = (ch = asc( "_" )) orelse ((ch >= asc( "A" )) andalso (ch <= asc( "Z" ))) _
                            orelse ((ch >= asc( "a" )) andalso (ch <= asc( "z" )))
        if (i > 0) andalso (ch >= asc( "0" )) andalso (ch <= asc( "9" )) then ok = true
        if ok = false then return false
    next
    return true
end function

sub MacroPass( byref x as CImp )
    dim as long n = x.macroNames.Count
    if n = 0 then return

    dim as string lines( 0 to n - 1 )
    dim as boolean live( 0 to n - 1 )
    dim as string values( 0 to n - 1 )
    for i as long = 0 to n - 1
        lines( i ) = "__auto_type __tko_probe_" & i & " = (" & x.macroNames[i] & ");"
        live( i ) = true
    next
    if (x.opts->macroValState = 1) andalso (x.opts->macroValues.Count = n) then
        for i as long = 0 to n - 1
            values( i ) = x.opts->macroValues[i]
        next
    elseif x.opts->macroValState = -1 then
        return
    elseif ProbeParse_( x, lines(), live(), n, chr( 10 ), "__tko_probe_", false, values() ) = false then
        '' An error no probe explains: the constants are left out rather than guessed.
        x.opts->macroValState = -1
        return
    else
        x.opts->macroValState = 1
        for i as long = 0 to n - 1
            x.opts->macroValues.Push( values( i ) )
        next
    end if

    '' THE CONSTANTS, in definition order. A constant's name is a VALUE name and is claimed
    '' like one; a renamed constant is renamed for the user, since a CONST is not a symbol
    '' the linker sees.
    for i as long = 0 to n - 1
        if len( values( i ) ) = 0 then continue for
        if values( i ) = NONFINITE_ then
            Skip( x, "define", x.macroNames[i], "value is infinity or NaN, which has no FreeBASIC literal" )
            continue for
        end if
        dim as string nm = NameClaim( x, NS_VALUE, x.macroNames[i], RK_CONST )
        x.decls.Push( "const " & nm & " = " & values( i ) )
    next

    '' THE ALIASES. Whatever produced no value is stringified; an expansion that is a plain
    '' identifier naming something declared here becomes a #define.
    dim as long na = 0
    for i as long = 0 to n - 1
        if len( values( i ) ) = 0 then na += 1
    next
    if na = 0 then return
    dim as string alines( 0 to n - 1 )
    dim as boolean alive( 0 to n - 1 )
    dim as string exps( 0 to n - 1 )
    for i as long = 0 to n - 1
        alive( i ) = (len( values( i ) ) = 0)
        alines( i ) = "const char *__tko_alias_" & i & " = __tko_str(" & x.macroNames[i] & ");"
    next
    dim as string prelude = chr( 10 ) & "#define __tko_str2(x) #x" & chr( 10 ) & _
                            "#define __tko_str(x) __tko_str2(x)" & chr( 10 )
    if (x.opts->macroExpState = 1) andalso (x.opts->macroExps.Count = n) then
        for i as long = 0 to n - 1
            exps( i ) = x.opts->macroExps[i]
        next
    elseif x.opts->macroExpState = -1 then
        return
    elseif ProbeParse_( x, alines(), alive(), n, prelude, "__tko_alias_", true, exps() ) = false then
        x.opts->macroExpState = -1
        return
    else
        x.opts->macroExpState = 1
        for i as long = 0 to n - 1
            x.opts->macroExps.Push( exps( i ) )
        next
    end if

    '' TWO ALIASES CANNOT SHARE A NAME. FreeBASIC's #define is case-insensitive, so
    '' commdlg.h's CHOOSECOLOR and ChooseColor, two names to C, are one here -- and a #define
    '' rewrites tokens before the parser sees them, so keeping either would silently send
    '' every use of the other to the wrong target. Both go, and the ledger says so.
    dim as string target( 0 to n - 1 )
    for i as long = 0 to n - 1
        if len( exps( i ) ) = 0 then continue for
        dim as string e = trim( exps( i ) )
        if IsIdent_( e ) = false then continue for
        if e = x.macroNames[i] then continue for
        dim as long cid = cast( long, x.strs.GetString( e ) )
        if cid >= x.cDeclUsr.Count then continue for
        dim as long u = x.cDeclUsr[cid] - 1
        if u < 0 then continue for
        if (UsrState( x, u ) and US_EMITTED) = 0 then continue for
        target( i ) = UsrFbName( x, u )
    next
    '' ...AND AN ALIAS CANNOT SHARE A NAME WITH ANYTHING DECLARED, for the same reason:
    '' mingw's '#define toascii __toascii' beside winuser.h's ToAscii would rewrite every
    '' ToAscii. fbc-modern's reason, word for word.
    for i as long = 0 to n - 1
        if len( target( i ) ) = 0 then continue for
        dim as string li = lcase( x.macroNames[i] )
        dim as boolean clash = NameTaken( x, x.macroNames[i] )
        for j as long = 0 to n - 1
            if (j <> i) andalso (len( target( j ) ) > 0) andalso (lcase( x.macroNames[j] ) = li) then
                clash = true
            end if
        next
        if clash then
            Skip( x, "define", x.macroNames[i], "'" & trim( exps( i ) ) & "' cannot be aliased: " & _
                  "the name is not unique once case is ignored, and a #define is case-insensitive" )
            continue for
        end if
        x.decls.Push( "#define " & x.macroNames[i] & " " & target( i ) )
        x.aliasNames.Push( x.macroNames[i] )
    next
end sub

end namespace

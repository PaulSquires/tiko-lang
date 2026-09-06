'' cmdline.bas -- see cmdline.bi

#include once "driver/cmdline.bi"
#include once "support/text.bi"
#include once "fb/filesystem.bi"

namespace Tko

dim shared as OptInfo optTable( 0 to OPT_COUNT - 1 )
dim shared as boolean optTableReady = false

sub InitOptTable( )
    if optTableReady then return

    optTable(OPT_NONE).spelling = @""
    optTable(OPT_NONE).kind = OPTK_FLAG
    optTable(OPT_NONE).category = OPTCAT_GENERAL
    optTable(OPT_NONE).argName = @""
    optTable(OPT_NONE).help = @""

    #macro OPT( o_id, o_spell, o_kind, o_cat, o_arg, o_help )
        optTable(o_id).spelling = @o_spell
        optTable(o_id).kind = o_kind
        optTable(o_id).category = o_cat
        optTable(o_id).argName = @o_arg
        optTable(o_id).help = @o_help
    #endmacro
    TKO_OPT_LIST( OPT )
    #undef OPT

    optTableReady = true
end sub

function OptInfoOf( byval id as OptId ) as OptInfo ptr
    InitOptTable( )
    dim as boolean bad = (id < 0) orelse (id >= OPT_COUNT)
    if bad then return @optTable(OPT_NONE)
    return @optTable(id)
end function

function CategoryName( byval c as OptCategory ) as string
    select case c
    case OPTCAT_INPUT  : return "Input"
    case OPTCAT_OUTPUT : return "Output"
    case OPTCAT_TARGET : return "Target"
    case OPTCAT_DIAG   : return "Diagnostics"
    case OPTCAT_DEVEL  : return "Compiler development"
    case else          : return "General"
    end select
end function

constructor DriverOptions( )
    this.outputPath = ""
    this.targetName = ""
    this.target = Tko.HostTarget( )
    this.widthOverride = 0
    this.compileOnly = false
    this.debugInfo = false
    this.threadSafe = false
    this.optLevel = 0
    this.showHelp = false
    this.helpCategory = ""
    this.showVersion = false
    this.verbose = false
    this.warningsAsErrors = false
    this.maxErrors = DIAG_DEFAULT_MAX_ERRORS
    this.colorMode = COLOR_AUTO
    this.diagFormat = DIAGFMT_FBC
    this.dumpSource = false
    this.dumpTokens = false
    this.lexOnly = false
    this.ppOnly = false
    this.dumpPp = false
    this.dumpAst = false
    this.parseExpr = false
    this.parseOnly = false
    this.dumpTypes = false
    this.dumpSymbols = false
    this.resolveOnly = false
    this.dumpIr = false
    this.emitIr = false
    this.emitAsm = false
    this.keepTemps = false
    this.stats = false
    this.timePasses = false
    this.bootstrapCheck = false
end constructor

end namespace

namespace Tko.Cmdline

function VersionText( ) as string
    dim as string v = str( Tko.TKO_VERSION_MAJOR ) & "." & _
                      str( Tko.TKO_VERSION_MINOR ) & "." & _
                      str( Tko.TKO_VERSION_PATCH ) & Tko.TKO_VERSION_SUFFIX

    dim as string arch = "x86_64"
    #ifdef __FB_WIN32__
        dim as string os_ = "win64"
    #else
        dim as string os_ = "linux-" & arch
    #endif

    dim as string outp = ""
    outp += "tiko-lang " & v & " -- a FreeBASIC-compatible compiler" & chr( 10 )
    outp += "target " & os_ & ", language compatibility fbc " & Tko.TKO_FBC_COMPAT & chr( 10 )
    outp += "built with FreeBASIC " & __FB_VERSION__ & " (" & __FB_SIGNATURE__ & ")" & chr( 10 )
    return outp
end function

function HelpText( byval category as string = "" ) as string
    Tko.InitOptTable( )

    dim as string want = Tko.Text.LowerAscii( trim( category ) )
    dim as boolean filtered = (len( want ) > 0)

    dim as string outp = ""
    outp += "usage: tiko-lang [options] <inputs...>" & chr( 10 ) & chr( 10 )

    for c as long = Tko.OPTCAT_GENERAL to Tko.OPTCAT_DEVEL
        dim as string catName = Tko.CategoryName( cast( Tko.OptCategory, c ) )
        dim as boolean skip = filtered andalso _
                              (instr( Tko.Text.LowerAscii( catName ), want ) = 0)
        if skip then continue for

        dim as string body = ""
        for i as long = 1 to Tko.OPT_COUNT - 1
            dim as Tko.OptInfo ptr info = Tko.OptInfoOf( cast( Tko.OptId, i ) )
            if info->category <> c then continue for

            dim as string spell = *info->spelling
            dim as string arg = *info->argName
            if len( arg ) > 0 then
                if info->kind = Tko.OPTK_JOINED then
                    spell += "<" & arg & ">"
                else
                    spell += " <" & arg & ">"
                end if
            end if
            while len( spell ) < 30
                spell += " "
            wend
            body += "  " & spell & *info->help & chr( 10 )
        next

        if len( body ) > 0 then
            outp += catName & ":" & chr( 10 ) & body & chr( 10 )
        end if
    next

    if filtered andalso (len( outp ) < 40) then
        outp += "  (no options in a category matching '" & category & "')" & chr( 10 )
    end if
    return outp
end function

'' Split "--opt=value" into its two halves. Returns false when there is no '='.
private function SplitEq _
    ( byval arg as string, byref lhs as string, byref rhs as string ) as boolean

    dim as long at = instr( arg, "=" )
    if at = 0 then return false
    lhs = left( arg, at - 1 )
    rhs = mid( arg, at + 1 )
    return true
end function

'' tiko-lang ships no headers of its own, and until this it searched no directory it had
'' not been given: '#include "vbcompat.bi"' failed where fbc compiles it clean. fbc's
'' search ends at <exe-dir>/inc, and 144 of the corpus's 145 include failures are that
'' one missing rule -- 17 of them parse completely clean once it is there.
''
'' Appended LAST, so every -i the user gave still wins, and only if the directory
'' actually exists: a search path that is not there costs a stat per include for
'' nothing. Both layouts are tried, because tiko-lang lives in bin/ and fbc does not:
''
''     <exe-dir>/inc        fbc's shape
''     <exe-dir>/../inc     tiko-lang's, with the exe in bin/
''
'' TKO_INCLUDE overrides both, which is how a build with no bundled headers -- the
'' corpus runs, today -- points at a header set without every caller repeating -i.
private sub AppendDefaultIncludeDir( byref opts as Tko.DriverOptions )
    dim as ustring env_ = environ( "TKO_INCLUDE" )
    if len( env_ ) > 0 then
        opts.includePaths.Push( env_ )
        return
    end if

    dim as ustring exeDir = exepath( )
    if len( exeDir ) = 0 then return

    dim as ustring cand = FB.PathJoin( exeDir, "inc" )
    if FB.IsDir( cand ) then
        opts.includePaths.Push( cand )
        return
    end if

    cand = FB.PathJoin( FB.PathParent( exeDir ), "inc" )
    if FB.IsDir( cand ) then opts.includePaths.Push( cand )
end sub

'' The library half of the same rule, and it was the half still missing: the include
'' search learned <exe-dir>/inc above, but a link still had to be told where libfb.a
'' was -- the packaged toolchain's own MANIFEST tells the reader to type
'' '-p lib/win64 -p lib/win64-fb' on every build. fbc needs neither, and this is why:
'' it appends <exe-dir>/lib/<target> after the -p paths and searches it last. Measured,
'' not assumed -- 'fbc64 -v hello.bas' emits
''
''     -L "<prefix>\lib\win64" -L "."
''
'' with no -p given, and with '-p X' the X comes FIRST. The directory is per target
'' where inc/ is not, which is fbc's shape too and the reason the two rules cannot
'' share one helper.
''
'' TWO directories are appended, not one, and the second is ours alone. tiko-rt is a
'' partial runtime: its thread layer calls fb_AtomicCasLong, which only fbc's libfb
'' defines, so the packaged tree carries lib/<target>-fb behind lib/<target> and a
'' single -lfb resolves out of whichever has it first. Ours first is the whole point
'' -- reverse them and the link silently picks up fbc's runtime instead. When tiko-rt
'' is complete the '-fb' directory stops existing and this stops finding it; nothing
'' else here changes.
''
'' Appended LAST and only when the directory is really there, for the reason the
'' include rule gives: a -p the user typed still wins, and a path that does not exist
'' buys a stat per library for nothing.
''
'' TKO_LIBPATH overrides the bundled tree, exactly as TKO_INCLUDE overrides inc/. It
'' used to be read in FindTools, and only when no -p was given at all; it is read here
'' now because a default pushed into libPaths would have made that test true forever
'' and dropped the variable on the floor without saying so.
private sub AppendDefaultLibDir( byref opts as Tko.DriverOptions )
    dim as ustring env_ = environ( "TKO_LIBPATH" )
    if len( env_ ) > 0 then
        opts.libPaths.Push( env_ )
        return
    end if

    dim as ustring exeDir = exepath( )
    if len( exeDir ) = 0 then return

    '' <exe-dir>/lib is fbc's shape, which the packaged toolchain copies;
    '' <exe-dir>/../lib is the development tree, where the exe sits in bin/.
    dim as ustring root = FB.PathJoin( exeDir, "lib" )
    if FB.IsDir( root ) = false then
        root = FB.PathJoin( FB.PathParent( exeDir ), "lib" )
        if FB.IsDir( root ) = false then return
    end if

    dim as ustring cand = FB.PathJoin( root, opts.targetName )
    if FB.IsDir( cand ) then opts.libPaths.Push( cand )

    cand = FB.PathJoin( root, opts.targetName & "-fb" )
    if FB.IsDir( cand ) then opts.libPaths.Push( cand )
end sub

private function MatchExact( byval arg as string ) as Tko.OptId
    Tko.InitOptTable( )
    for i as long = 1 to Tko.OPT_COUNT - 1
        dim as Tko.OptInfo ptr info = Tko.OptInfoOf( cast( Tko.OptId, i ) )
        if *info->spelling = arg then return cast( Tko.OptId, i )
    next
    return Tko.OPT_NONE
end function

'' Longest joined prefix wins, so "-Wno-" beats a hypothetical "-W".
private function MatchJoined _
    ( byval arg as string, byref value as string ) as Tko.OptId

    Tko.InitOptTable( )
    dim as Tko.OptId best = Tko.OPT_NONE
    dim as long bestLen = 0

    for i as long = 1 to Tko.OPT_COUNT - 1
        dim as Tko.OptInfo ptr info = Tko.OptInfoOf( cast( Tko.OptId, i ) )
        if info->kind <> Tko.OPTK_JOINED then continue for
        dim as string spell = *info->spelling
        dim as long n = len( spell )
        dim as boolean fits = (len( arg ) > n) andalso (left( arg, n ) = spell)
        if fits andalso (n > bestLen) then
            best = cast( Tko.OptId, i )
            bestLen = n
            value = mid( arg, n + 1 )
        end if
    next
    return best
end function

function Parse _
    ( byref args as Tko.StrVec, byref opts as Tko.DriverOptions, _
      byref diags as Tko.DiagnosticEngine ) as boolean

    Tko.InitOptTable( )

    dim as boolean ok = true
    dim as boolean noMoreOptions = false
    dim as long i = 0
    dim as long n = args.Count

    while i < n
        dim as string arg = args[i]

        dim as boolean isOption = (len( arg ) > 1) andalso (arg[0] = asc( "-" ))
        if noMoreOptions orelse (isOption = false) then
            opts.inputs.Push( arg )
            i += 1
            continue while
        end if

        if arg = "--" then
            noMoreOptions = true
            i += 1
            continue while
        end if

        '' Three spellings are tried in order: exact, --opt=value, then joined.
        dim as string value = ""
        dim as boolean haveValue = false
        dim as Tko.OptId id = MatchExact( arg )

        if id = Tko.OPT_NONE then
            dim as string lhs = "", rhs = ""
            if SplitEq( arg, lhs, rhs ) then
                id = MatchExact( lhs )
                if id <> Tko.OPT_NONE then
                    value = rhs
                    haveValue = true
                end if
            end if
        end if

        if id = Tko.OPT_NONE then
            id = MatchJoined( arg, value )
            if id <> Tko.OPT_NONE then haveValue = true
        end if

        if id = Tko.OPT_NONE then
            diags.ReportGlobal( Tko.TKO0100, arg )
            ok = false
            i += 1
            continue while
        end if

        dim as Tko.OptInfo ptr info = Tko.OptInfoOf( id )

        '' A separated value is consumed only for OPTK_VALUE, and only when the
        '' next argument exists. --help is the one option whose value is optional.
        dim as boolean wantsValue = (info->kind = Tko.OPTK_VALUE) orelse _
                                    (info->kind = Tko.OPTK_OPTVALUE)
        if wantsValue andalso (haveValue = false) then
            dim as boolean optionalValue = (info->kind = Tko.OPTK_OPTVALUE)
            dim as boolean hasNext = (i + 1 < n)

            '' An OPTIONAL value must be attached: '--dump-tokens=pp', never
            '' '--dump-tokens pp'. Consuming a separate argument would make
            '' 'tiko-lang --dump-tokens file.bas' ambiguous -- and it silently ate the
            '' input file when this was first written.
            dim as boolean takeIt = hasNext andalso (optionalValue = false)

            if takeIt then
                value = args[i + 1]
                haveValue = true
                i += 1
            elseif optionalValue = false then
                diags.ReportGlobal( Tko.TKO0101, arg )
                ok = false
                i += 1
                continue while
            end if
        end if

        select case id
        case Tko.OPT_HELP
            opts.showHelp = true
            if haveValue then opts.helpCategory = value
        case Tko.OPT_VERSION  : opts.showVersion = true
        case Tko.OPT_VERBOSE  : opts.verbose = true

        case Tko.OPT_INCLUDE  : opts.includePaths.Push( value )
        case Tko.OPT_DEFINE   : opts.defines.Push( value )
        case Tko.OPT_LIBPATH  : opts.libPaths.Push( value )
        case Tko.OPT_MAINMOD  : opts.mainModule = value
        case Tko.OPT_LIB      : opts.libs.Push( value )

        case Tko.OPT_OUTPUT   : opts.outputPath = value
        case Tko.OPT_COMPILE  : opts.compileOnly = true
        case Tko.OPT_DEBUG    : opts.debugInfo = true
        case Tko.OPT_MT       : opts.threadSafe = true

        case Tko.OPT_OPTLEVEL
            dim as long lvl = valint( value )
            dim as boolean bad = (len( value ) <> 1) orelse (lvl < 0) orelse (lvl > 3)
            if bad then
                diags.ReportGlobal( Tko.TKO0106, value, "-O" )
                ok = false
            else
                opts.optLevel = lvl
            end if

        case Tko.OPT_TARGET
            dim as boolean known = false
            dim as Tko.TargetId t = Tko.TargetFromName( value, known )
            if known = false then
                diags.ReportGlobal( Tko.TKO0103, value )
                ok = false
            else
                opts.target = t
                opts.targetName = Tko.TargetName( t )
            end if

        '' -m32 and -m64 pick the WIDTH of the target family, and are resolved after
        '' the whole line is read so that they do not depend on where they appear.
        case Tko.OPT_M64      : opts.widthOverride = 64
        case Tko.OPT_M32      : opts.widthOverride = 32

        case Tko.OPT_WERROR   : opts.warningsAsErrors = true
        case Tko.OPT_WNO
            dim as Tko.DiagId d = Tko.DiagIdFromName( value )
            if d = Tko.DIAG_NONE then
                diags.ReportGlobal( Tko.TKO0105, value )
            else
                opts.ignoredDiags.Push( Tko.DiagIdName( d ) )
            end if

        case Tko.OPT_MAXERR
            dim as long m = valint( value )
            if m < 1 then
                diags.ReportGlobal( Tko.TKO0106, value, "-fmax-errors" )
                ok = false
            else
                opts.maxErrors = m
            end if

        case Tko.OPT_COLOR
            dim as string w = Tko.Text.LowerAscii( value )
            select case w
            case "always" : opts.colorMode = Tko.COLOR_ALWAYS
            case "never"  : opts.colorMode = Tko.COLOR_NEVER
            case "auto"   : opts.colorMode = Tko.COLOR_AUTO
            case else
                diags.ReportGlobal( Tko.TKO0106, value, "--color" )
                ok = false
            end select

        case Tko.OPT_DIAGFMT
            dim as string w = Tko.Text.LowerAscii( value )
            select case w
            case "fbc" : opts.diagFormat = Tko.DIAGFMT_FBC
            case "gnu" : opts.diagFormat = Tko.DIAGFMT_GNU
            case else
                diags.ReportGlobal( Tko.TKO0106, value, "--diagnostics-format" )
                ok = false
            end select

        case Tko.OPT_DUMPSRC   : opts.dumpSource = true
        case Tko.OPT_DUMPTOK
            opts.dumpTokens = true
            if haveValue then
                dim as string w = Tko.Text.LowerAscii( value )
                select case w
                case "pp"  : opts.dumpPp = true
                case "raw" : opts.dumpPp = false
                case else
                    diags.ReportGlobal( Tko.TKO0106, value, "--dump-tokens" )
                    ok = false
                end select
            end if
        case Tko.OPT_LEXONLY   : opts.lexOnly = true
        case Tko.OPT_PPONLY    : opts.ppOnly = true
        case Tko.OPT_DUMPAST   : opts.dumpAst = true
        case Tko.OPT_PARSEEXPR : opts.parseExpr = true
        case Tko.OPT_PARSEONLY : opts.parseOnly = true
        case Tko.OPT_DUMPTYPES : opts.dumpTypes = true
        case Tko.OPT_DUMPSYMS  : opts.dumpSymbols = true
        case Tko.OPT_RESOLVE   : opts.resolveOnly = true
        case Tko.OPT_MANGLE    : opts.dumpMangle = true
        case Tko.OPT_CHECK     : opts.checkOnly = true
        case Tko.OPT_UDT       : opts.dumpUdt = true
        case Tko.OPT_VTABLE    : opts.dumpVtable = true
        case Tko.OPT_RTL       : opts.dumpRtl = true
        case Tko.OPT_DUMPIR    : opts.dumpIr = true
        case Tko.OPT_EMITIR    : opts.emitIr = true
        case Tko.OPT_EMITASM   : opts.emitAsm = true
        case Tko.OPT_KEEPTEMPS : opts.keepTemps = true
        case Tko.OPT_STATS     : opts.stats = true
        case Tko.OPT_TIMEPASS  : opts.timePasses = true
        case Tko.OPT_SUBSET    : opts.bootstrapCheck = true
        end select

        i += 1
    wend

    '' The width override. -m32 IS NOW AN ERROR EVERYWHERE: x86-64 is the only
    '' architecture (D14), so there is no 32-bit target left to select. It is
    '' rejected rather than ignored -- silently producing a 64-bit binary for
    '' someone who asked for 32 is worse than telling them.
    if opts.widthOverride = 32 then
        diags.ReportGlobal( Tko.TKO0104 )
        ok = false
    end if
    opts.targetName = Tko.TargetName( opts.target )

    AppendDefaultIncludeDir( opts )
    AppendDefaultLibDir( opts )

    return ok
end function

end namespace

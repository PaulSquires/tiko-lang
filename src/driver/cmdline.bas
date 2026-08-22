'' cmdline.bas -- see cmdline.bi

#include once "driver/cmdline.bi"
#include once "support/text.bi"
#include once "fb/filesystem.bi"

namespace Fbx

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
    FBX_OPT_LIST( OPT )
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
    this.target = Fbx.HostTarget( )
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

namespace Fbx.Cmdline

function VersionText( ) as string
    dim as string v = str( Fbx.FBX_VERSION_MAJOR ) & "." & _
                      str( Fbx.FBX_VERSION_MINOR ) & "." & _
                      str( Fbx.FBX_VERSION_PATCH ) & Fbx.FBX_VERSION_SUFFIX

    dim as string arch = "x86_64"
    #ifdef __FB_WIN32__
        dim as string os_ = "win64"
    #else
        dim as string os_ = "linux-" & arch
    #endif

    dim as string outp = ""
    outp += "fbx " & v & " -- a FreeBASIC-compatible compiler" & chr( 10 )
    outp += "target " & os_ & ", language compatibility fbc " & Fbx.FBX_FBC_COMPAT & chr( 10 )
    outp += "built with FreeBASIC " & __FB_VERSION__ & " (" & __FB_SIGNATURE__ & ")" & chr( 10 )
    return outp
end function

function HelpText( byval category as string = "" ) as string
    Fbx.InitOptTable( )

    dim as string want = Fbx.Text.LowerAscii( trim( category ) )
    dim as boolean filtered = (len( want ) > 0)

    dim as string outp = ""
    outp += "usage: fbx [options] <inputs...>" & chr( 10 ) & chr( 10 )

    for c as long = Fbx.OPTCAT_GENERAL to Fbx.OPTCAT_DEVEL
        dim as string catName = Fbx.CategoryName( cast( Fbx.OptCategory, c ) )
        dim as boolean skip = filtered andalso _
                              (instr( Fbx.Text.LowerAscii( catName ), want ) = 0)
        if skip then continue for

        dim as string body = ""
        for i as long = 1 to Fbx.OPT_COUNT - 1
            dim as Fbx.OptInfo ptr info = Fbx.OptInfoOf( cast( Fbx.OptId, i ) )
            if info->category <> c then continue for

            dim as string spell = *info->spelling
            dim as string arg = *info->argName
            if len( arg ) > 0 then
                if info->kind = Fbx.OPTK_JOINED then
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

'' fbx ships no headers of its own, and until this it searched no directory it had
'' not been given: '#include "vbcompat.bi"' failed where fbc compiles it clean. fbc's
'' search ends at <exe-dir>/inc, and 144 of the corpus's 145 include failures are that
'' one missing rule -- 17 of them parse completely clean once it is there.
''
'' Appended LAST, so every -i the user gave still wins, and only if the directory
'' actually exists: a search path that is not there costs a stat per include for
'' nothing. Both layouts are tried, because fbx lives in bin/ and fbc does not:
''
''     <exe-dir>/inc        fbc's shape
''     <exe-dir>/../inc     fbx's, with the exe in bin/
''
'' FBX_INCLUDE overrides both, which is how a build with no bundled headers -- the
'' corpus runs, today -- points at a header set without every caller repeating -i.
private sub AppendDefaultIncludeDir( byref opts as Fbx.DriverOptions )
    dim as ustring env_ = environ( "FBX_INCLUDE" )
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

private function MatchExact( byval arg as string ) as Fbx.OptId
    Fbx.InitOptTable( )
    for i as long = 1 to Fbx.OPT_COUNT - 1
        dim as Fbx.OptInfo ptr info = Fbx.OptInfoOf( cast( Fbx.OptId, i ) )
        if *info->spelling = arg then return cast( Fbx.OptId, i )
    next
    return Fbx.OPT_NONE
end function

'' Longest joined prefix wins, so "-Wno-" beats a hypothetical "-W".
private function MatchJoined _
    ( byval arg as string, byref value as string ) as Fbx.OptId

    Fbx.InitOptTable( )
    dim as Fbx.OptId best = Fbx.OPT_NONE
    dim as long bestLen = 0

    for i as long = 1 to Fbx.OPT_COUNT - 1
        dim as Fbx.OptInfo ptr info = Fbx.OptInfoOf( cast( Fbx.OptId, i ) )
        if info->kind <> Fbx.OPTK_JOINED then continue for
        dim as string spell = *info->spelling
        dim as long n = len( spell )
        dim as boolean fits = (len( arg ) > n) andalso (left( arg, n ) = spell)
        if fits andalso (n > bestLen) then
            best = cast( Fbx.OptId, i )
            bestLen = n
            value = mid( arg, n + 1 )
        end if
    next
    return best
end function

function Parse _
    ( byref args as Fbx.StrVec, byref opts as Fbx.DriverOptions, _
      byref diags as Fbx.DiagnosticEngine ) as boolean

    Fbx.InitOptTable( )

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
        dim as Fbx.OptId id = MatchExact( arg )

        if id = Fbx.OPT_NONE then
            dim as string lhs = "", rhs = ""
            if SplitEq( arg, lhs, rhs ) then
                id = MatchExact( lhs )
                if id <> Fbx.OPT_NONE then
                    value = rhs
                    haveValue = true
                end if
            end if
        end if

        if id = Fbx.OPT_NONE then
            id = MatchJoined( arg, value )
            if id <> Fbx.OPT_NONE then haveValue = true
        end if

        if id = Fbx.OPT_NONE then
            diags.ReportGlobal( Fbx.FBX0100, arg )
            ok = false
            i += 1
            continue while
        end if

        dim as Fbx.OptInfo ptr info = Fbx.OptInfoOf( id )

        '' A separated value is consumed only for OPTK_VALUE, and only when the
        '' next argument exists. --help is the one option whose value is optional.
        dim as boolean wantsValue = (info->kind = Fbx.OPTK_VALUE) orelse _
                                    (info->kind = Fbx.OPTK_OPTVALUE)
        if wantsValue andalso (haveValue = false) then
            dim as boolean optionalValue = (info->kind = Fbx.OPTK_OPTVALUE)
            dim as boolean hasNext = (i + 1 < n)

            '' An OPTIONAL value must be attached: '--dump-tokens=pp', never
            '' '--dump-tokens pp'. Consuming a separate argument would make
            '' 'fbx --dump-tokens file.bas' ambiguous -- and it silently ate the
            '' input file when this was first written.
            dim as boolean takeIt = hasNext andalso (optionalValue = false)

            if takeIt then
                value = args[i + 1]
                haveValue = true
                i += 1
            elseif optionalValue = false then
                diags.ReportGlobal( Fbx.FBX0101, arg )
                ok = false
                i += 1
                continue while
            end if
        end if

        select case id
        case Fbx.OPT_HELP
            opts.showHelp = true
            if haveValue then opts.helpCategory = value
        case Fbx.OPT_VERSION  : opts.showVersion = true
        case Fbx.OPT_VERBOSE  : opts.verbose = true

        case Fbx.OPT_INCLUDE  : opts.includePaths.Push( value )
        case Fbx.OPT_DEFINE   : opts.defines.Push( value )
        case Fbx.OPT_LIBPATH  : opts.libPaths.Push( value )
        case Fbx.OPT_LIB      : opts.libs.Push( value )

        case Fbx.OPT_OUTPUT   : opts.outputPath = value
        case Fbx.OPT_COMPILE  : opts.compileOnly = true
        case Fbx.OPT_DEBUG    : opts.debugInfo = true
        case Fbx.OPT_MT       : opts.threadSafe = true

        case Fbx.OPT_OPTLEVEL
            dim as long lvl = valint( value )
            dim as boolean bad = (len( value ) <> 1) orelse (lvl < 0) orelse (lvl > 3)
            if bad then
                diags.ReportGlobal( Fbx.FBX0106, value, "-O" )
                ok = false
            else
                opts.optLevel = lvl
            end if

        case Fbx.OPT_TARGET
            dim as boolean known = false
            dim as Fbx.TargetId t = Fbx.TargetFromName( value, known )
            if known = false then
                diags.ReportGlobal( Fbx.FBX0103, value )
                ok = false
            else
                opts.target = t
                opts.targetName = Fbx.TargetName( t )
            end if

        '' -m32 and -m64 pick the WIDTH of the target family, and are resolved after
        '' the whole line is read so that they do not depend on where they appear.
        case Fbx.OPT_M64      : opts.widthOverride = 64
        case Fbx.OPT_M32      : opts.widthOverride = 32

        case Fbx.OPT_WERROR   : opts.warningsAsErrors = true
        case Fbx.OPT_WNO
            dim as Fbx.DiagId d = Fbx.DiagIdFromName( value )
            if d = Fbx.DIAG_NONE then
                diags.ReportGlobal( Fbx.FBX0105, value )
            else
                opts.ignoredDiags.Push( Fbx.DiagIdName( d ) )
            end if

        case Fbx.OPT_MAXERR
            dim as long m = valint( value )
            if m < 1 then
                diags.ReportGlobal( Fbx.FBX0106, value, "-fmax-errors" )
                ok = false
            else
                opts.maxErrors = m
            end if

        case Fbx.OPT_COLOR
            dim as string w = Fbx.Text.LowerAscii( value )
            select case w
            case "always" : opts.colorMode = Fbx.COLOR_ALWAYS
            case "never"  : opts.colorMode = Fbx.COLOR_NEVER
            case "auto"   : opts.colorMode = Fbx.COLOR_AUTO
            case else
                diags.ReportGlobal( Fbx.FBX0106, value, "--color" )
                ok = false
            end select

        case Fbx.OPT_DIAGFMT
            dim as string w = Fbx.Text.LowerAscii( value )
            select case w
            case "fbc" : opts.diagFormat = Fbx.DIAGFMT_FBC
            case "gnu" : opts.diagFormat = Fbx.DIAGFMT_GNU
            case else
                diags.ReportGlobal( Fbx.FBX0106, value, "--diagnostics-format" )
                ok = false
            end select

        case Fbx.OPT_DUMPSRC   : opts.dumpSource = true
        case Fbx.OPT_DUMPTOK
            opts.dumpTokens = true
            if haveValue then
                dim as string w = Fbx.Text.LowerAscii( value )
                select case w
                case "pp"  : opts.dumpPp = true
                case "raw" : opts.dumpPp = false
                case else
                    diags.ReportGlobal( Fbx.FBX0106, value, "--dump-tokens" )
                    ok = false
                end select
            end if
        case Fbx.OPT_LEXONLY   : opts.lexOnly = true
        case Fbx.OPT_PPONLY    : opts.ppOnly = true
        case Fbx.OPT_DUMPAST   : opts.dumpAst = true
        case Fbx.OPT_PARSEEXPR : opts.parseExpr = true
        case Fbx.OPT_PARSEONLY : opts.parseOnly = true
        case Fbx.OPT_DUMPTYPES : opts.dumpTypes = true
        case Fbx.OPT_DUMPSYMS  : opts.dumpSymbols = true
        case Fbx.OPT_RESOLVE   : opts.resolveOnly = true
        case Fbx.OPT_MANGLE    : opts.dumpMangle = true
        case Fbx.OPT_CHECK     : opts.checkOnly = true
        case Fbx.OPT_UDT       : opts.dumpUdt = true
        case Fbx.OPT_VTABLE    : opts.dumpVtable = true
        case Fbx.OPT_RTL       : opts.dumpRtl = true
        case Fbx.OPT_DUMPIR    : opts.dumpIr = true
        case Fbx.OPT_EMITIR    : opts.emitIr = true
        case Fbx.OPT_EMITASM   : opts.emitAsm = true
        case Fbx.OPT_KEEPTEMPS : opts.keepTemps = true
        case Fbx.OPT_STATS     : opts.stats = true
        case Fbx.OPT_TIMEPASS  : opts.timePasses = true
        case Fbx.OPT_SUBSET    : opts.bootstrapCheck = true
        end select

        i += 1
    wend

    '' The width override, now that the whole line is known. Linux is 64-bit only by
    '' decision, so -m32 there is an error rather than a silent win32.
    if opts.widthOverride = 32 then
        if Fbx.TargetIsWindows( opts.target ) then
            opts.target = Fbx.TARGET_WIN32
        else
            diags.ReportGlobal( Fbx.FBX0104 )
            ok = false
        end if
    elseif opts.widthOverride = 64 then
        if Fbx.TargetIsWindows( opts.target ) then opts.target = Fbx.TARGET_WIN64
    end if
    opts.targetName = Fbx.TargetName( opts.target )

    AppendDefaultIncludeDir( opts )

    return ok
end function

end namespace

'' subcmd.bas -- see build.bi.

#import "std/containers"
#import "std/fs"
#include once "build/build.bi"
#include once "build/events.bi"
#include once "build/lock.bi"
#include once "driver/driver.bi"
#include once "driver/cmdline.bi"
#include once "driver/diagout.bi"
#include once "support/spawn.bi"

namespace Tko.Build

function IsCommand( byref w as string ) as boolean
    select case w
    case "build", "run", "check", "clean", "metadata"
        return true
    end select
    return false
end function

'' What a subcommand's own command line says (RFC §4). '--options' carries compiler flags
'' for every unit (B15); nothing else of the classic driver's is taken here, so a typo is
'' TKO0100 rather than a flag quietly passed on.
type BuildArgs_
    as string  verb
    as Tko.StrVec roots
    as Tko.StrVec extra
    as string  target
    as string  outPath
    as string  diagFile
    as boolean json
    as boolean verbose
end type

private function ParseArgs_ _
    ( byref args as Tko.StrVec, byref a as BuildArgs_, byref diags as Tko.DiagnosticEngine ) as boolean

    dim as boolean ok = true
    a.verb = args[0]
    dim as long i = 1
    while i < args.Count
        dim as string w = args[i]
        select case w
        case "-target", "-o", "--options", "--message-format", "--diagnostics-file"
            if i + 1 >= args.Count then
                diags.ReportGlobal( Tko.TKO0101, w )
                return false
            end if
            dim as string v = args[i + 1]
            i += 2
            select case w
            case "-target"           : a.target = v
            case "-o"                : a.outPath = v
            case "--diagnostics-file" : a.diagFile = v
            case "--options"         : Tko.Spawn.SplitArgs( v, a.extra )
            case "--message-format"
                if v = "json" then
                    a.json = true
                elseif v <> "text" then
                    diags.ReportGlobal( Tko.TKO0106, v, w )
                    ok = false
                end if
            end select
            continue while
        case "-v"
            a.verbose = true
        '' THE CONSOLE'S COLOUR is the driver's, passed on as given (the test runner says never).
        case "--color=always", "--color=never", "--color=auto"
            a.extra.Push( w )
        case else
            '' HOISTED: a length test beside a comparison is warning 38.
            dim as boolean isOpt = (len( w ) > 1)
            if isOpt then isOpt = (left( w, 1 ) = "-")
            if isOpt then
                diags.ReportGlobal( Tko.TKO0100, w )
                ok = false
            else
                a.roots.Push( w )
            end if
        end select
        i += 1
    wend
    '' -v PRINTS EVERY TOOL'S COMMAND TO STDOUT, which in JSON mode is the event stream.
    dim as boolean wordy = a.verbose
    for each x as string in a.extra
        if (x = "-v") orelse (x = "--time-passes") then wordy = true
    next
    if a.json andalso wordy then
        diags.ReportGlobal( Tko.TKO0154, "-v", "--message-format json" )
        ok = false
    end if
    if ok andalso a.roots.IsEmpty( ) then
        diags.ReportGlobal( Tko.TKO0102 )
        ok = false
    end if
    return ok
end function

'' The classic command line this build runs: the '--options' flags, the roots in order --
'' the first owns main, as in 'tiko a.bas b.bas' -- then what the subcommand settled.
private sub DriverArgs_( byref a as BuildArgs_, byref d as Tko.StrVec )
    for each x as string in a.extra
        d.Push( x )
    next
    for each r as string in a.roots
        d.Push( r )
    next
    if len( a.target ) > 0 then d.Push( "-target" ) : d.Push( a.target )
    if len( a.outPath ) > 0 then d.Push( "-o" ) : d.Push( a.outPath )
    if len( a.diagFile ) > 0 then d.Push( "--diagnostics-file" ) : d.Push( a.diagFile )
    if a.verbose then d.Push( "-v" )
end sub

'' The file name less its extension, the directory kept: the implicit target's name and
'' the stem its lock is named after.
private function Stem_( byref p as string ) as string
    for i as long = len( p ) to 1 step -1
        dim as string ch = mid( p, i, 1 )
        if (ch = "/") orelse (ch = "\") then exit for
        if ch = "." then return left( p, i - 1 )
    next
    return p
end function

private function BaseName_( byref p as string ) as string
    for i as long = len( p ) to 1 step -1
        dim as string ch = mid( p, i, 1 )
        if (ch = "/") orelse (ch = "\") then return mid( p, i + 1 )
    next
    return p
end function

'' The output the classic driver would write for these arguments, by its own rule.
private function ArtifactOf_( byref a as BuildArgs_, byref diags as Tko.DiagnosticEngine ) as string
    if len( a.outPath ) > 0 then return a.outPath
    dim as Tko.StrVec d
    DriverArgs_( a, d )
    dim as Tko.DriverOptions o
    if Tko.Cmdline.Parse( d, o, diags ) = false then return ""
    return Tko.Driver.DefaultOutput( o )
end function

'' ONE BUILD OF AN OUTPUT AT A TIME: '<artefact>.build.lock' beside it (lock.bi).
private function Lock_( byref a as BuildArgs_, byref artifact as string, byref lk as BuildLock, _
                        byref diags as Tko.DiagnosticEngine ) as boolean
    dim as string base_ = artifact
    if len( base_ ) = 0 then base_ = Stem_( a.roots[0] )
    dim as string lp = base_ & ".build.lock"
    if TakeLock( lk, lp ) = LOCK_BUSY then
        diags.ReportGlobal( Tko.TKO0166, artifact, lp )
        return false
    end if
    return true
end function

private function Clean_( byref a as BuildArgs_, byref ctx as Tko.CompilerContext, byref obs as Observer ) as long
    dim as string art = ArtifactOf_( a, ctx.diags )
    if ctx.diags.ErrorCount( ) > 0 then return Tko.EXIT_CMDLINE
    dim as BuildLock lk
    if Lock_( a, art, lk, ctx.diags ) = false then return Tko.EXIT_USER_ERROR
    dim as boolean had = fs.IsFile( art )
    if had then kill( art )
    ReleaseLock( lk )
    EmitLine( obs, """event"":""clean"",""path"":" & JsonStr( art ) & ",""removed"":" & _
                   iif( had, "true", "false" ) )
    return Tko.EXIT_OK
end function

private function Build_( byref a as BuildArgs_, byref ctx as Tko.CompilerContext, byref obs as Observer ) as long
    dim as string art = ArtifactOf_( a, ctx.diags )
    if ctx.diags.ErrorCount( ) > 0 then return Tko.EXIT_CMDLINE
    dim as BuildLock lk
    if Lock_( a, art, lk, ctx.diags ) = false then return Tko.EXIT_USER_ERROR

    dim as string roots = ""
    for each r as string in a.roots
        if len( roots ) > 0 then roots &= ","
        roots &= JsonStr( r )
    next
    EmitLine( obs, """event"":""build-start"",""format"":" & EVENT_FORMAT & ",""target"":" & _
                   JsonStr( BaseName_( Stem_( a.roots[0] ) ) ) & ",""roots"":[" & roots & "]" )

    dim as Tko.StrVec d
    DriverArgs_( a, d )
    dim as long rc = Tko.Driver.Run( d, 0, 0, @obs )
    ReleaseLock( lk )
    return rc
end function

function Entry( byref args as Tko.StrVec ) as long
    if args.IsEmpty( ) then return Tko.Driver.Run( args )
    if IsCommand( args[0] ) = false then return Tko.Driver.Run( args )

    '' THE SUBCOMMAND'S OWN DIAGNOSTICS -- a bad option, a busy lock -- go through an engine
    '' like any run's, rendered the same way and written to the same diagnostics file.
    dim as Tko.CompilerContext ctx
    dim as Observer obs
    obs.t0 = timer
    dim as BuildArgs_ a
    dim as boolean ok = ParseArgs_( args, a, ctx.diags )
    obs.json = a.json
    ctx.options.diagFile = a.diagFile
    if Tko.DiagOut.Start( ctx ) = false then ok = false

    dim as long rc = Tko.EXIT_CMDLINE
    if ok then
        select case a.verb
        case "build"
            rc = Build_( a, ctx, obs )
        case "clean"
            rc = Clean_( a, ctx, obs )
        case else
            ctx.diags.ReportGlobal( Tko.TKO0992, "tiko " & a.verb )
            rc = Tko.EXIT_USER_ERROR
        end select
    end if

    '' The driver's run wrote its own diagnostics file and totals; a failure before it ran
    '' writes them here.
    if obs.finished = false then
        rc = Tko.DiagOut.Finish( ctx, rc )
        obs.errors = ctx.diags.ErrorCount( )
        obs.warnings = ctx.diags.WarningCount( )
    end if
    if a.verb = "build" then
        EmitLine( obs, """event"":""build-end"",""errors"":" & obs.errors & ",""warnings"":" & _
                       obs.warnings & ",""exit"":" & rc & ",""ms"":" & clng( ( timer - obs.t0 ) * 1000 ) )
    end if
    return rc
end function

end namespace

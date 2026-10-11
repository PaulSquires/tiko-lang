'' subcmd.bas -- see build.bi.

#import "std/containers"
#import "std/fs"
#include once "build/build.bi"
#include once "build/events.bi"
#include once "build/lock.bi"
#include once "build/plan.bi"
#include once "driver/driver.bi"
#include once "driver/diagout.bi"
#include once "driver/manifest.bi"
#include once "driver/modresolve.bi"
#include once "support/spawn.bi"
#include once "support/diskcache.bi"

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
private function ParseArgs_ _
    ( byref args as Tko.StrVec, byref a as BuildArgs, byref diags as Tko.DiagnosticEngine ) as boolean

    dim as boolean ok = true
    a.verb = args[0]
    dim as long i = 1
    while i < args.Count
        dim as string w = args[i]
        select case w
        case "-target", "-o", "--options", "--message-format", "--diagnostics-file", "--profile", "--format", "--manifest"
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
            case "--profile"         : a.profile = v : a.hasProfile = true
            case "--manifest"        : a.manifest = v
            '' 'metadata --format json' (RFC §8.2): the one format there is.
            case "--format"
                if v <> "json" then
                    diags.ReportGlobal( Tko.TKO0106, v, w )
                    ok = false
                end if
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
        '' NOTHING READ FROM OR WRITTEN TO THE CACHE, modules or roots (B3).
        case "--no-cache"
            a.extra.Push( "--no-module-cache" )
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
                a.words.Push( w )
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
    return ok
end function

'' A WORD IS A TARGET when a manifest is in force and the word could not be a file name --
'' no '.', no separator -- else a ROOT. A target that the manifest does not have is TKO0160.
private function Classify_ _
    ( byref a as BuildArgs, byval hasM as boolean, byref m as Tko.Modules.Manifest, _
      byref targets as Tko.StrVec, byref roots as Tko.StrVec, byref diags as Tko.DiagnosticEngine ) as boolean

    dim as boolean ok = true
    for each w as string in a.words
        dim as boolean nameLike = hasM andalso (instr( w, "." ) = 0) andalso (instr( w, "/" ) = 0) andalso (instr( w, "\" ) = 0)
        if nameLike = false then
            roots.Push( w )
            continue for
        end if
        dim as boolean known = false
        for each t as string in m.targetNames
            if t = w then known = true
        next
        if known then
            targets.Push( w )
        else
            dim as string list_ = ""
            for each t as string in m.targetNames
                list_ &= iif( len( list_ ) > 0, ", ", "" ) & t
            next
            if len( list_ ) = 0 then list_ = "none"
            diags.ReportGlobal( Tko.TKO0160, w, list_ )
            ok = false
        end if
    next
    if ok andalso (targets.Count > 0) andalso (roots.Count > 0) then
        diags.ReportGlobal( Tko.TKO0154, roots[0], "target " & targets[0] )
        ok = false
    end if
    return ok
end function

'' ONE BUILD OF AN OUTPUT AT A TIME: '<artefact>.build.lock' beside it (lock.bi).
private function Lock_( byref p as TargetPlan, byref lk as BuildLock, byref diags as Tko.DiagnosticEngine ) as boolean
    dim as string base_ = p.artifact
    if len( base_ ) = 0 then base_ = Stem( p.roots[0] )
    dim as string lp = base_ & ".build.lock"
    if TakeLock( lk, lp ) = LOCK_BUSY then
        diags.ReportGlobal( Tko.TKO0166, p.artifact, lp )
        return false
    end if
    return true
end function

'' ONE DIAGNOSTICS FILE FOR THE WHOLE BUILD: each target's run wrote its own, and they are
'' joined -- one header, every record in target order, one 'end' with the totals.
private sub MergeDiagFiles_( byref dest as string, byref parts as Tko.StrVec, byval rc as long )
    dim as string header = "", body = ""
    dim as long errs = 0, warns = 0
    for each part as string in parts
        dim as string t
        if Tko.DiskCache.ReadAll( part, t ) = false then continue for
        kill( part )
        dim as long p = 1
        while p <= len( t )
            dim as long e = instr( p, t, chr( 10 ) )
            if e = 0 then e = len( t ) + 1
            dim as string ln = mid( t, p, e - p )
            p = e + 1
            if len( header ) = 0 then
                header = ln
                continue while
            end if
            if ln = header then continue while
            if left( ln, 4 ) = "end" & chr( 9 ) then
                dim as long t1 = instr( 5, ln, chr( 9 ) )
                errs += valint( mid( ln, 5, t1 - 5 ) )
                warns += valint( mid( ln, t1 + 1 ) )
                continue while
            end if
            if len( ln ) > 0 then body &= ln & chr( 10 )
        wend
    next
    if len( header ) = 0 then return
    dim as long fh = freefile
    if open( dest for output as #fh ) <> 0 then return
    print #fh, header & chr( 10 ) & body & "end" & chr( 9 ) & errs & chr( 9 ) & warns & chr( 9 ) & rc & chr( 10 );
    close #fh
end sub

private sub BuildStart_( byref obs as Observer, byref p as TargetPlan )
    EmitLine( obs, """event"":""build-start"",""format"":" & EVENT_FORMAT & ",""target"":" & _
                   JsonStr( p.name ) & ",""profile"":" & JsonStr( p.profile ) & ",""roots"":" & _
                   JsonArr( p.roots ) )
end sub

private sub BuildEnd_( byref obs as Observer, byref p as TargetPlan, byval rc as long )
    EmitLine( obs, """event"":""build-end"",""target"":" & JsonStr( p.name ) & ",""errors"":" & _
                   obs.errors & ",""warnings"":" & obs.warnings & ",""exit"":" & rc & ",""ms"":" & _
                   clng( ( timer - obs.t0 ) * 1000 ) )
end sub

'' THE PLANS, in order: every named target, or every target, or the implicit one.
private function Plan_ _
    ( byref a as BuildArgs, byval hasM as boolean, byref m as Tko.Modules.Manifest, byref mdir as string, _
      byref names as Tko.StrVec, byref ctx as Tko.CompilerContext, byref plans as Tko.StrVec ) as boolean
    '' 'plans' holds the target names, "" for the implicit one; each is planned again when
    '' built, which is cheap, so no array of plans has to be carried.
    if names.Count = 0 then
        plans.Push( "" )
        return true
    end if
    dim as Tko.StrVec arts
    dim as boolean ok = true
    for each n as string in names
        dim as TargetPlan p
        if PlanTarget( a, m, mdir, n, iif( a.hasProfile, a.profile, "debug" ), p, ctx.diags ) = false then
            ok = false
            continue for
        end if
        '' TWO TARGETS MAY NOT WRITE ONE FILE (TKO0165).
        for k as long = 0 to arts.Count - 1
            if arts[k] = p.artifact then ctx.diags.ReportGlobal( Tko.TKO0165, plans[k], n, p.artifact ) : ok = false
        next
        arts.Push( p.artifact )
        plans.Push( n )
    next
    return ok
end function

private function PlanOne_ _
    ( byref a as BuildArgs, byref m as Tko.Modules.Manifest, byref mdir as string, byref n as string, _
      byref p as TargetPlan, byref diags as Tko.DiagnosticEngine ) as boolean
    if len( n ) = 0 then return PlanImplicit( a, m, p, diags )
    return PlanTarget( a, m, mdir, n, iif( a.hasProfile, a.profile, "debug" ), p, diags )
end function

private function Build_ _
    ( byref a as BuildArgs, byref m as Tko.Modules.Manifest, byref mdir as string, _
      byref plans as Tko.StrVec, byref ctx as Tko.CompilerContext, byref obs as Observer ) as long

    dim as long rc = Tko.EXIT_OK
    dim as Tko.StrVec diagParts
    for i as long = 0 to plans.Count - 1
        dim as TargetPlan p
        '' Several targets: each run writes a diagnostics file of its own, joined at the end.
        dim as string ownDiag = a.diagFile
        if (len( a.diagFile ) > 0) andalso (plans.Count > 1) then
            a.diagFile = ownDiag & "." & i
            diagParts.Push( a.diagFile )
        end if
        dim as boolean planned = PlanOne_( a, m, mdir, plans[i], p, ctx.diags )
        a.diagFile = ownDiag
        if planned = false then
            rc = Tko.EXIT_CMDLINE
            exit for
        end if
        dim as string outDir = Tko.Modules.DirOfFile( p.artifact )
        if (len( outDir ) > 0) andalso (fs.IsDir( outDir ) = false) then fs.CreateDirAll( outDir )
        dim as BuildLock lk
        if Lock_( p, lk, ctx.diags ) = false then
            rc = Tko.EXIT_USER_ERROR
            exit for
        end if
        obs.finished = false
        BuildStart_( obs, p )
        rc = Tko.Driver.Run( p.dargs, 0, 0, @obs )
        ReleaseLock( lk )
        BuildEnd_( obs, p, rc )
        '' FAIL FAST (RFC B14): no target starts after one fails.
        if rc <> Tko.EXIT_OK then exit for
    next
    if diagParts.Count > 0 then MergeDiagFiles_( a.diagFile, diagParts, rc )
    return rc
end function

private function Clean_ _
    ( byref a as BuildArgs, byref m as Tko.Modules.Manifest, byref mdir as string, _
      byref plans as Tko.StrVec, byref ctx as Tko.CompilerContext, byref obs as Observer ) as long

    for each n as string in plans
        dim as TargetPlan p
        if PlanOne_( a, m, mdir, n, p, ctx.diags ) = false then return Tko.EXIT_CMDLINE
        dim as BuildLock lk
        if Lock_( p, lk, ctx.diags ) = false then return Tko.EXIT_USER_ERROR
        dim as boolean had = fs.IsFile( p.artifact )
        if had then kill( p.artifact )
        ReleaseLock( lk )
        EmitLine( obs, """event"":""clean"",""target"":" & JsonStr( p.name ) & ",""path"":" & _
                       JsonStr( p.artifact ) & ",""removed"":" & iif( had, "true", "false" ) )
    next
    return Tko.EXIT_OK
end function

'' 'tiko metadata' (RFC §8.2): the project as one JSON object, nothing compiled. The module
'' graph and the search paths come from a '--print-graph' run of each target, reported to
'' the observer rather than printed (modgraph.bas).
private function Metadata_ _
    ( byref a as BuildArgs, byval hasM as boolean, byref m as Tko.Modules.Manifest, byref mdir as string, _
      byref plans as Tko.StrVec, byref ctx as Tko.CompilerContext, byref obs as Observer ) as long

    dim as long rc = Tko.EXIT_OK
    dim as Tko.StrVec profiles
    ProfileNames( m, profiles )
    dim as string tj = "", uj = "", pj = ""
    for each pn as string in profiles
        dim as Tko.StrVec fl
        if ProfileFlags( m, pn, fl, ctx.diags ) = false then rc = Tko.EXIT_CMDLINE
        pj &= iif( len( pj ) > 0, ",", "" ) & "{""name"":" & JsonStr( pn ) & ",""flags"":" & JsonArr( fl ) & "}"
    next
    obs.json = false
    for each n as string in plans
        dim as TargetPlan p
        if PlanOne_( a, m, mdir, n, p, ctx.diags ) = false then
            rc = Tko.EXIT_CMDLINE
            continue for
        end if
        dim as string outs = ""
        if len( n ) > 0 then
            for each pn as string in profiles
                outs &= iif( len( outs ) > 0, ",", "" ) & JsonStr( pn ) & ":" & _
                        JsonStr( TargetOutput( a, m, mdir, n, pn, ctx.diags ) )
            next
        else
            outs = JsonStr( p.profile ) & ":" & JsonStr( p.artifact )
        end if
        tj &= iif( len( tj ) > 0, ",", "" ) & "{""name"":" & JsonStr( p.name ) & ",""kind"":" & JsonStr( p.kind ) & _
              ",""implicit"":" & iif( len( n ) = 0, "true", "false" ) & ",""main"":" & JsonStr( p.roots[0] ) & _
              ",""roots"":" & JsonArr( p.roots ) & ",""resources"":" & JsonArr( p.resources ) & _
              ",""defines"":" & JsonArr( p.defines ) & ",""flags"":" & JsonArr( p.flags ) & _
              ",""outputs"":{" & outs & "}}"
        '' THE GRAPH RUN: the target's flags and roots, its target triple, '--print-graph'.
        dim as Tko.StrVec g
        for each x as string in p.flags
            if (x <> "-v") andalso (x <> "--time-passes") then g.Push( x )
        next
        for each x as string in p.roots
            g.Push( x )
        next
        for each x as string in p.defines
            g.Push( "-d" ) : g.Push( x )
        next
        if len( a.target ) > 0 then g.Push( "-target" ) : g.Push( a.target )
        g.Push( "--print-graph" )
        obs.includesJson = "[]" : obs.definesJson = "[]"
        dim as long grc = Tko.Driver.Run( g, 0, 0, @obs )
        if grc <> Tko.EXIT_OK then rc = grc
        for each r as string in p.roots
            uj &= iif( len( uj ) > 0, ",", "" ) & "{""target"":" & JsonStr( p.name ) & ",""root"":" & JsonStr( r ) & _
                  ",""defines"":" & obs.definesJson & ",""includes"":" & obs.includesJson & "}"
        next
    next
    dim as string mj = ""
    for each x as string in obs.modJson
        mj &= iif( len( mj ) > 0, ",", "" ) & x
    next
    dim as string pkg = "null"
    if hasM then
        pkg = "{""name"":" & JsonStr( m.name ) & ",""manifest"":" & JsonStr( Rel( mdir, "tiko.toml" ) ) & _
              ",""root"":" & JsonStr( mdir ) & "}"
    end if
    dim as string sj = obs.searchJson
    if len( sj ) = 0 then sj = "null"
    print "{""format"":" & EVENT_FORMAT & ",""package"":" & pkg & ",""profiles"":[" & pj & _
          "],""targets"":[" & tj & "],""modules"":[" & mj & "],""searchPaths"":" & sj & _
          ",""units"":[" & uj & "]}" & chr( 10 );
    return rc
end function

function Entry( byref args as Tko.StrVec ) as long
    if args.IsEmpty( ) then return Tko.Driver.Run( args )
    if IsCommand( args[0] ) = false then return Tko.Driver.Run( args )

    '' THE SUBCOMMAND'S OWN DIAGNOSTICS -- a bad option, a manifest, a busy lock -- go through
    '' an engine like any run's, rendered the same way and written to the same file.
    dim as Tko.CompilerContext ctx
    dim as Observer obs
    obs.t0 = timer
    dim as BuildArgs a
    dim as boolean ok = ParseArgs_( args, a, ctx.diags )
    obs.json = a.json
    ctx.options.diagFile = a.diagFile
    if Tko.DiagOut.Start( ctx ) = false then ok = false

    '' THE MANIFEST: '--manifest' -- tiko.toml or the directory holding it -- else the nearest
    '' tiko.toml at or above the current directory, if any. Paths in it stay relative to it.
    dim as string mdir = ""
    if len( a.manifest ) > 0 then
        mdir = a.manifest
        if lcase( right( mdir, 9 ) ) = "tiko.toml" then mdir = Tko.Modules.DirOfFile( mdir )
        if len( mdir ) = 0 then mdir = "."
        if Tko.Modules.HasManifest( mdir ) = false then
            ctx.diags.ReportGlobal( Tko.TKO0144, "no tiko.toml in '" & mdir & "'" )
            ok = false
        end if
    else
        mdir = FindManifestDir( )
    end if
    dim as boolean hasM = (len( mdir ) > 0)
    dim as Tko.Modules.Manifest m
    if ok andalso hasM then
        if Tko.Modules.LoadManifest( ctx, mdir, m ) = false then ok = false
    end if
    dim as Tko.StrVec targets, roots, plans
    if ok then ok = Classify_( a, hasM, m, targets, roots, ctx.diags )
    '' THE PROFILE, checked once rather than once per target.
    if ok andalso a.hasProfile then
        dim as Tko.StrVec pf
        ok = ProfileFlags( m, a.profile, pf, ctx.diags )
    end if
    if ok then
        if (targets.Count = 0) andalso (roots.Count = 0) then
            '' NO WORDS: every target of the manifest, or nothing to do.
            for each t as string in m.targetNames
                targets.Push( t )
            next
            if targets.Count = 0 then
                ctx.diags.ReportGlobal( Tko.TKO0102 )
                ok = false
            end if
        end if
    end if
    if ok then
        if roots.Count > 0 then
            a.words.Clear( )
            for each r as string in roots
                a.words.Push( r )
            next
        end if
        ok = Plan_( a, hasM, m, mdir, targets, ctx, plans )
    end if

    dim as long rc = Tko.EXIT_CMDLINE
    if ok then
        select case a.verb
        case "build"
            rc = Build_( a, m, mdir, plans, ctx, obs )
        case "clean"
            rc = Clean_( a, m, mdir, plans, ctx, obs )
        case "metadata"
            rc = Metadata_( a, hasM, m, mdir, plans, ctx, obs )
        case else
            ctx.diags.ReportGlobal( Tko.TKO0992, "tiko " & a.verb )
            rc = Tko.EXIT_USER_ERROR
        end select
    end if

    '' A failure before any driver run is written here; a run wrote its own file and totals.
    dim as boolean ran = obs.finished
    if ran = false then rc = Tko.DiagOut.Finish( ctx, rc )
    '' ...and one raised after a run -- a later target's busy lock -- still reaches the console.
    if ran then ctx.diags.Flush( )
    if (a.verb = "build") andalso (ran = false) then
        obs.errors = ctx.diags.ErrorCount( )
        obs.warnings = ctx.diags.WarningCount( )
        EmitLine( obs, """event"":""build-end"",""errors"":" & obs.errors & ",""warnings"":" & _
                       obs.warnings & ",""exit"":" & rc & ",""ms"":" & clng( ( timer - obs.t0 ) * 1000 ) )
    end if
    return rc
end function

end namespace

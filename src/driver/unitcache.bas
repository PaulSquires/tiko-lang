'' unitcache.bas -- see unitcache.bi.

#import "std/containers"
#import "std/fs"
#include once "driver/unitcache.bi"
#include once "driver/unit.bi"
#include once "driver/modcache.bi"
#include once "driver/modbuild.bi"
#include once "driver/modresolve.bi"
#include once "support/diskcache.bi"
#include once "support/text.bi"
#include once "support/spawn.bi"
#include once "support/platform.bi"
#include once "build/events.bi"

namespace Tko.UnitCache

'' The name a unit's last key is kept under, for -v's miss reason: one per source path.
private function Chain_( byref ctx as Tko.CompilerContext, byval i as long ) as string
    dim as string p = ctx.sources.AbsPathOf( cast( Tko.FileId, i ) )
    #ifdef __FB_WIN32__
        p = Tko.Text.LowerAscii( p )
    #endif
    return "unit-" & Tko.DiskCache.Hash( p )
end function

sub Open _
    ( byref ctx as Tko.CompilerContext, byref args as Tko.StrVec, byval restartDepth as long, _
      byval eligible as boolean, byref s as Store )

    s.root = ""
    '' A 'tiko build', or one of its children (--build-only-unit), which runs as a classic
    '' compile but must store the root it was given.
    dim as boolean isChild = (ctx.options.buildOnlyUnit > 0)
    if ((ctx.build = 0) andalso (isChild = false)) orelse (eligible = false) orelse (restartDepth > 0) then return
    '' TKO_TEST_CHILD_EXIT: a child that dies with this code before it compiles anything, so
    '' a test can reach TKO0167 (tests/driver/build-parallel-crash). Read in a child only.
    if isChild andalso (valint( environ( "TKO_TEST_CHILD_EXIT" ) ) <> 0) then end valint( environ( "TKO_TEST_CHILD_EXIT" ) )
    if Tko.DiskCache.CompilerStamp( ) = "" then return
    s.root = Tko.Modules.ModuleCacheRoot( ctx )
    '' THE REST OF THE COMMAND LINE, in order: what the option lines of the key do not name
    '' still reaches it. Not the inputs (each unit keys its own source), and not what cannot
    '' reach an object: the output, the diagnostics file, -v, the console's colour.
    s.args = ""
    dim as long k = 0
    while k < args.Count
        dim as string w = args[k]
        k += 1
        if (w = "-o") orelse (w = "--diagnostics-file") orelse (w = "--build-only-unit") then
            k += 1
            continue while
        end if
        if (w = "-v") orelse (w = "--time-passes") orelse (left( w, 8 ) = "--color=") then continue while
        dim as boolean isInput = false
        for each x as string in ctx.options.inputs
            if x = w then isInput = true
        next
        if isInput then continue while
        s.args &= " " & w
    wend
end sub

function TryHit _
    ( byref ctx as Tko.CompilerContext, byref s as Store, byval i as long, byref key as string, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec ) as boolean

    key = ""
    if len( s.root ) = 0 then return false
    dim as Tko.FileId id = cast( Tko.FileId, i )
    dim as string hitObj, hitIface, hitLibs
    if s.state.Count > i then
        '' THE PROBE'S ANSWER, when RunChildren made one: no second look.
        key = s.pkey[i]
        dim as boolean cached = (s.state[i] = UNIT_HIT) orelse (s.state[i] = UNIT_CHILD)
        if cached = false then return false
        hitObj = s.pobj[i] : hitLibs = s.plibs[i]
    else
        key = Tko.Modules.UnitKey( ctx, id, Tko.Driver.IsMainUnit_( ctx, id, i ), i = 1, s.args )
        if Tko.Modules.ModuleCacheLookup( ctx, s.root, key, hitObj, hitIface, hitLibs ) = false then
            if ctx.options.verbose then
                print "unit " & ctx.sources.PathOf( id ) & ": miss (" & _
                      Tko.Modules.MissReason( s.root, Chain_( ctx, i ), key ) & ")"
            end if
            return false
        end if
        if ctx.options.verbose then print "unit " & ctx.sources.PathOf( id ) & ": hit"
    end if
    '' AN ARCHIVE NAMES ITS MEMBERS AFTER THEIR SOURCES, so the entry's obj.o is copied to the
    '' name the compile would have given it (unit.bas).
    if ctx.options.outKind = Tko.OUT_STATICLIB then
        dim as string mp = Tko.Driver.StripExt_( ctx.sources.PathOf( id ) ) & ".o"
        fs.CopyFile( hitObj, mp, true )
        tempObjs.Push( mp )
        hitObj = mp
    end if
    linkObjs.Push( hitObj )
    Tko.Modules.ReplayLibs( ctx, hitLibs )
    return true
end function

sub Before( byref ctx as Tko.CompilerContext, byref linkObjs as Tko.StrVec, byref m as Mark )
    m.libs0 = ctx.options.pragmaLibs.Count
    m.paths0 = ctx.options.pragmaLibPaths.Count
    m.files0 = ctx.options.pragmaLibFiles.Count
    m.objs0 = linkObjs.Count
    m.errs0 = ctx.diags.ErrorCount( )
    m.warns0 = ctx.diags.WarningCount( )
end sub

function After _
    ( byref ctx as Tko.CompilerContext, byref s as Store, byval i as long, byref key as string, _
      byref m as Mark, byref linkObjs as Tko.StrVec ) as string

    if len( key ) = 0 then return "compiled"
    dim as string why = ""
    if ctx.diags.ErrorCount( ) <> m.errs0 then
        why = "it has errors"
    elseif ctx.diags.WarningCount( ) <> m.warns0 then
        why = "it has warnings, which a cached object would not report again"
    elseif ctx.unitUsesClock then
        why = "it expands __DATE__, __DATE_ISO__ or __TIME__"
    elseif linkObjs.Count <= m.objs0 then
        why = "it made no object"
    end if
    dim as string dl
    if len( why ) = 0 then
        if Tko.Modules.ModuleCacheDeps( ctx, dl ) = false then why = "a file it read cannot be stamped"
    end if
    if len( why ) > 0 then
        '' TKO0169, a note, under -v only: a build that is merely slower is not a problem.
        if ctx.options.verbose then ctx.diags.ReportGlobal( Tko.TKO0169, ctx.sources.PathOf( cast( Tko.FileId, i ) ), why )
        return "miss"
    end if
    s.keys.Push( key )
    s.chains.Push( Chain_( ctx, i ) )
    s.objs.Push( linkObjs[linkObjs.Count - 1] )
    s.libs.Push( Tko.Modules.LibsSince( ctx, m.libs0, m.paths0, m.files0 ) )
    s.deps.Push( dl )
    return "miss"
end function

sub Commit( byref ctx as Tko.CompilerContext, byref s as Store )
    if len( s.root ) = 0 then return
    for k as long = 0 to s.keys.Count - 1
        if fs.IsFile( s.objs[k] ) = false then continue for
        Tko.Modules.ModuleCacheCommit( s.root, s.keys[k], s.chains[k], s.objs[k], "", s.libs[k], s.deps[k] )
    next
end sub

function Crashed( byref s as Store, byval i as long ) as boolean
    if s.state.Count <= i then return false
    return s.state[i] = UNIT_CRASHED
end function

sub Report( byref ctx as Tko.CompilerContext, byref s as Store, byval i as long, byref status as string )
    if i <= s.emitted then exit sub
    dim as string st = status
    if (s.state.Count > i) andalso (s.state[i] = UNIT_CHILD) then st = "miss"
    Tko.Build.OnUnit( ctx.build, "root", ctx.sources.PathOf( cast( Tko.FileId, i ) ), st )
    s.emitted = i
end sub

'' Unit i against the cache, without compiling: its state, key, and a hit's object and libs.
private sub Probe_( byref ctx as Tko.CompilerContext, byref s as Store, byval i as long, byval hitState as long )
    dim as Tko.FileId id = cast( Tko.FileId, i )
    dim as string key = Tko.Modules.UnitKey( ctx, id, Tko.Driver.IsMainUnit_( ctx, id, i ), i = 1, s.args )
    dim as string hitObj, hitIface, hitLibs
    s.pkey[i] = key
    if Tko.Modules.ModuleCacheLookup( ctx, s.root, key, hitObj, hitIface, hitLibs ) then
        s.state[i] = hitState
        s.pobj[i] = hitObj
        s.plibs[i] = hitLibs
    end if
end sub

'' Send the events of every unit from the frontier on whose outcome is settled -- a hit, or
'' a child's that the cache now holds -- and stop at the first that is not: the loop sends
'' that one, and the rest, in order. So the events come in unit order whatever order the
'' children finish in, and -j 1 and -j 8 send the same ones.
private sub Advance_( byref ctx as Tko.CompilerContext, byref s as Store, byval srcCount as long )
    while s.emitted < srcCount
        dim as long nx = s.emitted + 1
        dim as boolean settled = (s.state[nx] = UNIT_HIT) orelse (s.state[nx] = UNIT_CHILD)
        if settled = false then exit while
        Report( ctx, s, nx, "hit" )
    wend
end sub

function RunChildren _
    ( byref ctx as Tko.CompilerContext, byref s as Store, byref args as Tko.StrVec, _
      byval srcCount as long ) as long

    s.emitted = 0
    if len( s.root ) = 0 then return Tko.EXIT_OK
    '' NOT IN A CHILD, and not for an archive, whose module members every child would write
    '' beside the output at once (modbuild.bas ArchiveMemberPath).
    if ctx.options.buildOnlyUnit > 0 then return Tko.EXIT_OK
    if ctx.options.outKind = Tko.OUT_STATICLIB then return Tko.EXIT_OK
    dim as long jobs = Tko.Spawn.DefaultJobs( )
    if (jobs < 2) orelse (srcCount < 2) then return Tko.EXIT_OK
    dim as string exe = Tko.Platform.SelfPath( )
    if len( exe ) = 0 then return Tko.EXIT_OK

    '' THE PROBE: every root against the cache.
    for i as long = 0 to srcCount
        '' cast: an enum CONSTANT passed byref arrives as 0 -- tiko's own bug, which the seed
        '' that builds this source has too (repro in the B4 notes); a cast is an expression.
        s.state.Push( cast( ulong, UNIT_MISS ) ) : s.pkey.Push( "" ) : s.pobj.Push( "" ) : s.plibs.Push( "" )
    next
    dim as Tko.IdVec misses
    for i as long = 1 to srcCount
        Probe_( ctx, s, i, UNIT_HIT )
        if s.state[i] = UNIT_MISS then misses.Push( i )
        '' -v's line for the unit, as TryHit prints it when no probe ran -- and the miss's
        '' reason now, before a child's entry replaces the key it is told against.
        if ctx.options.verbose then
            dim as string pth = ctx.sources.PathOf( cast( Tko.FileId, i ) )
            if s.state[i] = UNIT_HIT then
                print "unit " & pth & ": hit"
            else
                print "unit " & pth & ": miss (" & Tko.Modules.MissReason( s.root, Chain_( ctx, i ), s.pkey[i] ) & ")"
            end if
        end if
    next
    Advance_( ctx, s, srcCount )
    if misses.Count < 2 then return Tko.EXIT_OK

    '' THE CHILDREN: this run's command line, each argument quoted, plus the one root.
    dim as string base_ = ""
    for each a as string in args
        base_ &= Tko.Spawn.QuoteArg( a ) & " "
    next
    dim as long rc = Tko.EXIT_OK
    dim as Tko.IdVec running
    dim as containers.Array( of longint ) procs
    dim as long nextMiss = 0
    dim as boolean stopStarting = false
    while (nextMiss < misses.Count) orelse (running.Count > 0)
        '' Start up to the budget -- none after a child failed: the loop compiles the rest.
        while (stopStarting = false) andalso (nextMiss < misses.Count) andalso (running.Count < jobs)
            dim as long u = misses[nextMiss]
            nextMiss += 1
            dim as Tko.Spawn.Proc p = Tko.Spawn.Start( exe, base_ & "--build-only-unit " & u, true )
            if p = 0 then
                s.state[u] = UNIT_REDO
                continue while
            end if
            running.Push( u ) : procs.Push( p )
        wend
        if running.Count = 0 then exit while
        '' The OLDEST child first: one wait at a time, and the events want the earliest units.
        dim as long u0 = running[0]
        dim as long crc = Tko.Spawn.Wait( procs[0] )
        for k as long = 1 to running.Count - 1
            running[k - 1] = running[k] : procs[k - 1] = procs[k]
        next
        running.Pop( ) : procs.Pop( )
        '' A tiko exits 0 to 5; anything else is a crash (Windows' 0xC0000005 reads negative).
        if (crc < -1) orelse (crc > Tko.EXIT_TOOL_FAILED) then
            s.state[u0] = UNIT_CRASHED
            rc = Tko.Driver.ToolFail_( ctx, Tko.EXIT_CHILD_CRASHED, Tko.TKO0167, _
                    ctx.sources.PathOf( cast( Tko.FileId, u0 ) ), str( crc ) )
            stopStarting = true
            continue while
        end if
        if crc <> Tko.EXIT_OK then stopStarting = true
        '' Did it store the unit? Then this run links its entry; else the loop compiles it.
        s.state[u0] = UNIT_REDO
        Probe_( ctx, s, u0, UNIT_CHILD )
        if ctx.options.verbose andalso (s.state[u0] = UNIT_CHILD) then
            print "unit " & ctx.sources.PathOf( cast( Tko.FileId, u0 ) ) & ": compiled by a parallel job"
        end if
        Advance_( ctx, s, srcCount )
    wend
    return rc
end function

end namespace

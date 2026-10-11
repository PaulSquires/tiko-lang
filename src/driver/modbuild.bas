'' modbuild.bas -- building the modules a program imports (ADR 0017; RFC-0005 §3).
''
'' The graph is built from the roots' headers (modgraph.bas), and each module in its order
'' is compiled as one unit -- the same pass 'tiko -c <dir>' runs (unit.bas, modunit.bas) --
'' into an intermediate object that joins the link, as a root's does. Then the roots are
'' compiled, with '#import' no longer TKO0992.
''
'' Each module, once compiled, leaves its interface behind for the ones after it and for
'' the roots to read (modiface.bas). The first module that fails ends the build: what
'' imports it could only fail after it.
''
'' THE CACHE (modcache.bas) is asked first, in the same order: a module whose key -- its
'' sources, the options, and its closure's interfaces -- has an entry is not compiled. Its
'' object is linked from the entry, its interface read from it, and what it adds to the
'' link replayed. '-v' says which, per module.

#import "std/containers"
#import "std/fs"
#include once "support/diskcache.bi"
#include once "driver/modbuild.bi"
#include once "driver/modgraph.bi"
#include once "driver/unit.bi"
#include once "driver/modresolve.bi"
#include once "driver/modcache.bi"
#include once "build/events.bi"

namespace Tko.Modules

function ArchiveMemberPath( byref ctx as Tko.CompilerContext ) as string
    return JoinPath( DirOfFile( ctx.options.outputPath ), ctx.modChain & ".o" )
end function

'' What a unit added to the link since the counts were taken, as a cache entry's libs.txt.
function LibsSince _
    ( byref ctx as Tko.CompilerContext, byval libs0 as long, byval paths0 as long, _
      byval files0 as long ) as string
    dim as string libs = ""
    for k as long = libs0 to ctx.options.pragmaLibs.Count - 1
        libs &= "lib" & chr( 9 ) & ctx.options.pragmaLibs[k] & chr( 10 )
    next
    for k as long = paths0 to ctx.options.pragmaLibPaths.Count - 1
        libs &= "libpath" & chr( 9 ) & ctx.options.pragmaLibPaths[k] & chr( 10 )
    next
    for k as long = files0 to ctx.options.pragmaLibFiles.Count - 1
        libs &= "libfile" & chr( 9 ) & ctx.options.pragmaLibFiles[k] & chr( 10 )
    next
    if ctx.unitThreadRtl then libs &= "mt" & chr( 9 ) & "1" & chr( 10 )
    return libs
end function

'' A cached unit's contribution to the link, as its entry recorded it.
sub ReplayLibs( byref ctx as Tko.CompilerContext, byref libs as string )
    dim as long p = 1
    while p <= len( libs )
        dim as long e = instr( p, libs, chr( 10 ) )
        if e = 0 then e = len( libs ) + 1
        dim as string ln = mid( libs, p, e - p )
        p = e + 1
        dim as long t = instr( ln, chr( 9 ) )
        if t = 0 then continue while
        dim as string v = mid( ln, t + 1 )
        select case left( ln, t - 1 )
        case "lib"     : ctx.options.pragmaLibs.Push( v )
        case "libpath" : ctx.options.pragmaLibPaths.Push( v )
        case "libfile" : ctx.options.pragmaLibFiles.Push( v )
        case "mt"      : ctx.options.threadSafe = true
        end select
    wend
end sub

'' A DIRECTORY NO OTHER RUN HAS, in the temporary directory: 'mkdir' fails when the name is
'' taken, so the first name it makes is this run's alone -- a clock-based NAME was not, for two
'' runs started in the same millisecond. "" when none can be made.
private function PrivateTempDir_( ) as string
    dim as string tmp = environ( "TEMP" )
    if len( tmp ) = 0 then tmp = environ( "TMPDIR" )
    if len( tmp ) = 0 then tmp = "/tmp"
    dim as string stamp_ = hex( cast( ulong, ( timer * 1000000 ) mod 4294967296 ) )
    for n as long = 0 to 999
        dim as string d = JoinPath( tmp, "tiko-" & stamp_ & "-" & n )
        if mkdir( d ) = 0 then return d
    next
    return ""
end function

function BuildImports _
    ( byref ctx as Tko.CompilerContext, byval rootCount as long, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec, _
      byref toolExit as long, byval scanOnly as boolean ) as boolean

    dim as ModGraph g
    if BuildGraph( ctx, rootCount, true, g ) = false then return false
    if g.chains.Count = 0 then return true

    '' --emit-ir AND --emit-asm name one file per root, and where each module's IR would go
    '' is not decided. '-c' writes each module's object beside the output (RFC-0005 §6).
    dim as boolean stops = (scanOnly = false) andalso (ctx.options.emitIr orelse ctx.options.emitAsm)
    if stops then
        ctx.diags.ReportGlobal( Tko.TKO0992, _
            "--emit-ir and --emit-asm of a program that imports modules" )
        return false
    end if
    ctx.modObjPaths.Clear( )

    '' A RUN WITH NO OUTPUT -- '--dump-ir' and the other dumps -- still compiles every module it
    '' imports, into the cache. Its intermediates were '<output>.<i>.o' with no output, so
    '' '.80.o' in the working directory, which every such run shares: measured 2026-10-11, of
    '' 8 parallel '--dump-ir's of one program 4 to 7 failed TKO0113, each having had its
    '' '.80.o.ll' deleted by another -- the suite's intermittent exit-5 failures. Such a run
    '' compiles its modules in a directory of its own, removed once the cache holds them.
    dim as string privDir = ""
    dim as boolean noOutput = (len( ctx.options.outputPath ) = 0)
    if noOutput andalso (ctx.options.compileOnly = false) andalso (scanOnly = false) then
        privDir = PrivateTempDir_( )
        if len( privDir ) > 0 then ctx.options.outputPath = JoinPath( privDir, "m" )
    end if

    ctx.importsBuilt = true
    ctx.ifaceChains.Clear( )
    ctx.ifaceDirs.Clear( )
    ctx.ifaceTexts.Clear( )
    ctx.ifaceFiles.Clear( )
    for i as long = 0 to g.chains.Count - 1
        ctx.ifaceChains.Push( g.chains[i] )
        ctx.ifaceDirs.Push( NormPath( g.dirs[i] ) )
        ctx.ifaceTexts.Push( "" )
        ctx.ifaceFiles.Push( cast( ulong, Tko.FILE_NONE ) )
    next
    ctx.ifaceOrder.Clear( )
    for each o as ulong in g.order
        ctx.ifaceOrder.Push( o )
    next
    ctx.ifaceEdgeFrom.Clear( )
    ctx.ifaceEdgeTo.Clear( )
    for e as long = 0 to g.edgeFrom.Count - 1
        ctx.ifaceEdgeFrom.Push( g.edgeFrom[e] )
        ctx.ifaceEdgeTo.Push( g.edgeTo[e] )
    next
    ctx.ifaceRootDir = DirOfFile( ctx.sources.PathOf( cast( Tko.FileId, 1 ) ) )
    '' NOT FOR A SCAN: ModuleCacheRoot MAKES the directory, and an editor scanning as you
    '' type must not create or fill the user's module cache.
    dim as string cacheRoot = ""
    if scanOnly = false then cacheRoot = ModuleCacheRoot( ctx )
    '' THE CACHE IS FILLED AFTER THE OBJECTS EXIST. A module's clang runs while the next
    '' module's front end does (driver/objqueue.bi), so what each entry will hold is kept
    '' here and stored once the queue has drained.
    dim as Tko.StrVec storeKeys, storeObjs, storeIfaces, storeLibs, storeChains, storeDeps

    for each n as ulong in g.order
        ctx.modChain = g.chains[n]
        ctx.modPkgName = g.pkgNames[n]
        ctx.modPkgRoot = g.pkgRoots[n]
        ctx.modName = mid( ctx.modChain, instrrev( ctx.modChain, "." ) + 1 )
        ctx.modFiles.Clear( )
        for k as long = 0 to g.fileCount[n] - 1
            ctx.modFiles.Push( g.fileIds[g.fileFirst[n] + k] )
        next
        ctx.modFileCount = ctx.modFiles.Count
        if ctx.modFileCount = 0 then continue for

        '' THE SCAN: the front end, the interface, the harvest -- and on to the next module
        '' whatever this one's errors, because the code being scanned is being written.
        if scanOnly then
            dim as Tko.StrVec noRestart
            Tko.Driver.CompileUnit( ctx, cast( long, ctx.modFiles[0] ), 1, 1, false, _
                                    linkObjs, tempObjs, toolExit, noRestart )
            continue for
        end if

        dim as string key, hitObj, hitIface, hitLibs
        '' NO COMPILER STAMP, NO CACHE: an entry it made could not be told from one an older
        '' compiler made (audit F-38).
        if Tko.DiskCache.CompilerStamp( ) = "" then cacheRoot = ""
        if len( cacheRoot ) > 0 then key = ModuleKey( ctx, n )
        if ModuleCacheLookup( ctx, cacheRoot, key, hitObj, hitIface, hitLibs ) then
            if ctx.options.verbose then print "module " & ctx.modChain & ": hit"
            Tko.Build.OnUnit( ctx.build, "module", ctx.modChain, "hit" )
            '' An ARCHIVE keeps the member's name: not the entry's 'obj.o', the chain's. '-c'
            '' leaves the object beside the output, for the roots' records to name.
            if ctx.options.compileOnly then
                dim as string cp = ArchiveMemberPath( ctx )
                fs.CopyFile( hitObj, cp, true )
                ctx.modObjPaths.Push( AbsPath( cp ) )  '' absolute: the link that reads it may run anywhere
                hitObj = cp
            elseif ctx.options.outKind = Tko.OUT_STATICLIB then
                dim as string mp = ArchiveMemberPath( ctx )
                fs.CopyFile( hitObj, mp, true )
                tempObjs.Push( mp )
                hitObj = mp
            end if
            linkObjs.Push( hitObj )
            ctx.ifaceTexts[n] = hitIface
            ctx.ifaceFiles[n] = cast( ulong, ctx.sources.AddVirtual( ctx.modChain & ".tki", hitIface ) )
            ReplayLibs( ctx, hitLibs )
            continue for
        end if
        if ctx.options.verbose andalso (len( cacheRoot ) > 0) then
            print "module " & ctx.modChain & ": miss (" & MissReason( cacheRoot, ctx.modChain, key ) & ")"
        end if

        '' WHAT THIS MODULE ADDS TO THE LINK is what its compile appends, and is recorded.
        dim as long libs0 = ctx.options.pragmaLibs.Count
        dim as long paths0 = ctx.options.pragmaLibPaths.Count
        dim as long files0 = ctx.options.pragmaLibFiles.Count
        dim as long objs0 = linkObjs.Count
        dim as Tko.StrVec restartArgs
        '' A module cannot '#cmdline' (TKO0366), so this never asks for a restart.
        Tko.Driver.CompileUnit( ctx, cast( long, ctx.modFiles[0] ), 1, 1, true, _
                                linkObjs, tempObjs, toolExit, restartArgs )
        if (toolExit <> Tko.EXIT_OK) orelse Tko.Driver.FrontendFailed_( ctx ) then exit for
        Tko.Build.OnUnit( ctx.build, "module", ctx.modChain, "miss" )
        if ctx.options.compileOnly andalso (linkObjs.Count > objs0) then
            ctx.modObjPaths.Push( AbsPath( linkObjs[linkObjs.Count - 1] ) )
        end if
        if (len( cacheRoot ) > 0) andalso (linkObjs.Count > objs0) then
            dim as string libs = LibsSince( ctx, libs0, paths0, files0 )
            dim as string dl
            '' A MODULE THAT READ THE CLOCK IS NOT STORED: a hit would link the first build's
            '' __DATE__ / __TIME__ into every later one (tiko-build B0, 2026-10-11).
            if ctx.unitUsesClock then
                if ctx.options.verbose then
                    print "module " & ctx.modChain & ": not stored (it expands __DATE__, __DATE_ISO__ or __TIME__)"
                end if
            elseif ModuleCacheDeps( ctx, dl ) then
                storeKeys.Push( key ) : storeObjs.Push( linkObjs[linkObjs.Count - 1] )
                storeIfaces.Push( ctx.ifaceTexts[n] ) : storeLibs.Push( libs )
                storeChains.Push( ctx.modChain ) : storeDeps.Push( dl )
            end if
        end if
    next
    if storeKeys.Count > 0 then
        dim as long drained = Tko.Driver.DrainObjects( ctx )
        if (drained <> Tko.EXIT_OK) andalso (toolExit = Tko.EXIT_OK) then toolExit = drained
        if toolExit = Tko.EXIT_OK then
            for k as long = 0 to storeKeys.Count - 1
                ModuleCacheCommit( cacheRoot, storeKeys[k], storeChains[k], storeObjs[k], _
                                   storeIfaces[k], storeLibs[k], storeDeps[k] )
            next
        end if
    end if
    ctx.modChain = ""
    ctx.modName = ""
    ctx.modFiles.Clear( )
    ctx.modFileCount = 0
    if len( privDir ) > 0 then
        ctx.options.outputPath = ""
        fs.RemoveDirAll( privDir )
    end if
    return (toolExit = Tko.EXIT_OK) andalso (Tko.Driver.FrontendFailed_( ctx ) = false)
end function

function EmitInterface( byref ctx as Tko.CompilerContext, byref dir_ as string ) as long
    dim as string d = AbsPath( dir_ )
    while (len( d ) > 1) andalso (right( d, 1 ) = "/")
        d = left( d, len( d ) - 1 )
    wend
    dim as Tko.StrVec files
    ModuleFiles( d, files )
    if files.Count = 0 then
        ctx.diags.ReportGlobal( Tko.TKO0147, d )
        return Tko.EXIT_USER_ERROR
    end if
    dim as string parent = DirOfFile( d )
    '' THE ROOT: one line importing the directory, standing beside it as a file would. A
    '' directory under a search root or the toolchain's pkg/ is imported by its package
    '' path, so its chain is the one 'tiko -c <dir>' gives it; any other relatively, so the
    '' nearest tiko.toml above it names its package, as for a dependency's importer.
    dim as ModWhere w
    ChainForDir( ctx, dir_, w )            '' as given: the search roots are spelled so too
    dim as string path_ = "./" & mid( d, instrrev( d, "/" ) + 1 )
    if w.pkgName <> ANON_PACKAGE then
        path_ = w.chain
        for i as long = 0 to len( path_ ) - 1
            if path_[i] = 46 then path_[i] = 47
        next
    end if
    ctx.sources.AddBuffer( JoinPath( parent, "__tko_emit_tki__.tiko" ), _
                           "#import " & chr( 34 ) & path_ & chr( 34 ) & chr( 10 ) )
    '' Each module the build compiles leaves an intermediate object, named after the
    '' output; there is none, so they go to the temporary directory and are deleted.
    dim as string privDir = PrivateTempDir_( )
    if len( privDir ) = 0 then privDir = environ( "TEMP" )
    ctx.options.outputPath = JoinPath( privDir, "tiko-emit-tki" )
    dim as Tko.StrVec linkObjs, tempObjs
    dim as long toolExit = Tko.EXIT_OK
    dim as boolean ok = BuildImports( ctx, 1, linkObjs, tempObjs, toolExit )
    for each t as string in tempObjs
        if fs.IsFile( t ) then kill( t )
    next
    if privDir <> environ( "TEMP" ) then fs.RemoveDirAll( privDir )
    if ok = false then return iif( toolExit <> Tko.EXIT_OK, toolExit, Tko.EXIT_USER_ERROR )
    for i as long = 0 to ctx.ifaceDirs.Count - 1
        dim as string a = AbsPath( ctx.ifaceDirs[i] ), b = AbsPath( d )
        #ifdef __FB_WIN32__
            a = Tko.Text.LowerAscii( a ) : b = Tko.Text.LowerAscii( b )
        #endif
        if a <> b then continue for
        print ctx.ifaceTexts[i];
        return Tko.EXIT_OK
    next
    ctx.diags.ReportGlobal( Tko.TKO0152 )
    return Tko.EXIT_CMDLINE
end function

end namespace

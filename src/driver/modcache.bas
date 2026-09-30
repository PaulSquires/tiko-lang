'' modcache.bas -- the module build cache (ADR 0017; RFC-0005 §4).
''
'' AN ENTRY IS A DIRECTORY named by the FNV-64 of its key:
''
''     key.txt     the whole key: compared on a hit, so a collision is a miss
''     iface.tki   the module's interface, as its importers read it
''     obj.o       the module's object
''     libs.txt    what the module adds to the link, one 'kind <tab> value' a line
''     deps.txt    every file the unit read that is not one of its sources -- headers,
''                 #cinclude bindings -- as 'size <tab> mtime <tab> path'. WRITTEN LAST:
''                 an entry without it does not exist.
''
'' THE KEY NAMES THE INTERFACE OF EVERY MODULE IN THE IMPORT CLOSURE, not its sources: a
'' body edit in a dependency changes its object and not its interface, so what imports it
'' keeps its key and is not rebuilt. It is the whole closure, since an importer's object
'' holds the layouts of its dependencies' dependencies' types too.
''
'' A failed compile is never stored. Two builds storing one entry race harmlessly: each
'' file is committed whole (support/diskcache.bas), and the key decides the content.
''
'' <root>/chains/<chain>.<hash of its directory>.key is the last key stored for a chain,
'' read only to say, under -v, which line of the key made a miss. By directory too, because
'' the pool is shared: two projects' 'main.util' must not overwrite each other's.
''
'' ONE POOL SERVES EVERY PROJECT, so THE KEY SAYS WHERE: the module's directory and each
'' include path are absolute (and case-folded on Windows -- KeyPath_). Written as given they were relative, and two projects laid
'' out alike, built each from its own directory, made one key for one module source -- the
'' second got the first's object, compiled against the first's headers, since deps.txt
'' (absolute) names the first's files, which had not changed.

#include once "driver/modcache.bi"
#include once "driver/modresolve.bi"
#include once "support/diskcache.bi"
#include once "codegen/target.bi"
#include once "fb/filesystem.bi"

'' The runtime's UTC clock: ticks of 100 ns since 0001-01-01, the unit FB.FileInfo's
'' ModifiedUtc( ) reports -- so an entry's age is one subtraction. fbc-modern's runtime and
'' tiko-rt both define it (lib/rt/src/chrono/clock.bas).
extern "C"
    declare function fb_DtClockUtcNow( ) as longint
end extern

namespace Tko.Modules

private function Nl_( ) as string
    return chr( 10 )
end function

'' ------------------------------------------------------------ keeping the pool small
''
'' NOTHING WAS EVER DELETED -- 139 entries, 46 MB, in the author's first three days of
'' modules (2026-09-30). A key names the compiler that built it by size and time, so each
'' rebuild of tiko orphaned the whole pool, as did every edit to a module's sources and
'' every scratch directory removed. Three things remove entries now (ADR 0017 §21):
''
''   SUPERSEDED, when a module is stored: the entry last stored for the same chain from the
''   same directory, when its key differs only in the module's sources and its closure's
''   interfaces -- one compiler, target, option set and include path. Another configuration's
''   stays, or two installs or two targets would rebuild on every alternation.
''
''   UNUSED, at most once a day: an entry no build has written or read for seven days. A hit
''   rewrites the entry's 'used' stamp. Go trims its build cache the same way.
''
''   ALL of them: 'tiko --clean-module-cache'.
''
'' Only a directory named like an entry -- sixteen hex digits -- holding a key.txt is ever
'' removed, and never the pool itself: TKO_MODCACHE may name any directory.

const TICKS_PER_DAY as longint = 864000000000ll
const UNUSED_DAYS as long = 7

private function Mtime_( byref p as string ) as longint
    dim as FB.FsResultInfo r = FB.Stat( p )
    if r.IsOk( ) = false then return 0
    return r.Value( ).ModifiedUtc( )
end function

private function IsEntry_( byref root as string, byref nm as string ) as boolean
    if len( nm ) <> 16 then return false
    for i as long = 0 to 15
        dim as ubyte c = nm[i]
        dim as boolean hexd = ((c >= asc( "0" )) andalso (c <= asc( "9" ))) orelse _
                              ((c >= asc( "a" )) andalso (c <= asc( "f" )))
        if hexd = false then return false
    next
    return FB.IsFile( JoinPath( JoinPath( root, nm ), "key.txt" ) )
end function

'' When a build last wrote or read the entry: its 'used' stamp, else its key.
private function LastUse_( byref d as string ) as longint
    dim as longint t = Mtime_( JoinPath( d, "used" ) )
    if t = 0 then t = Mtime_( JoinPath( d, "key.txt" ) )
    return t
end function

'' A key without its sources and interfaces: what says which build the entry is for.
private function Config_( byref key as string ) as string
    dim as string r = ""
    dim as long p = 1
    while p <= len( key )
        dim as long e = instr( p, key, Nl_( ) )
        if e = 0 then e = len( key ) + 1
        dim as string ln = mid( key, p, e - p )
        p = e + 1
        if left( ln, 7 ) = "source " then continue while
        if left( ln, 6 ) = "iface " then continue while
        r &= ln & Nl_( )
    wend
    return r
end function

'' The chain records whose entry is gone.
private sub DropStaleChains_( byref root as string )
    dim as string cd = JoinPath( root, "chains" )
    dim as FB.Array( of FB.DirEntry ) es
    if FB.ListDir( cd, es ).IsOk( ) = false then return
    for k as long = 0 to es.Count - 1
        if es[k].IsFile( ) = false then continue for
        dim as string p = JoinPath( cd, es[k].Name( ) )
        if right( p, 4 ) <> ".key" then continue for
        dim as string last_
        if Tko.DiskCache.ReadAll( p, last_ ) = false then continue for
        if FB.IsDir( JoinPath( root, Tko.DiskCache.Hash( last_ ) ) ) = false then FB.RemoveFile( p )
    next
end sub

'' At most once a day, the entries unused for UNUSED_DAYS. The stamp is written FIRST, so two
'' builds starting together do not both walk the pool.
private sub Trim_( byref root as string )
    dim as string tf = JoinPath( root, "trim.txt" )
    dim as longint now_ = fb_DtClockUtcNow( )
    dim as longint last_ = Mtime_( tf )
    if (last_ > 0) andalso (now_ - last_ < TICKS_PER_DAY) then return
    Tko.DiskCache.Commit( tf, "", 7 )
    dim as FB.Array( of FB.DirEntry ) es
    if FB.ListDir( root, es ).IsOk( ) = false then return
    for k as long = 0 to es.Count - 1
        if es[k].IsDirectory( ) = false then continue for
        dim as string nm = es[k].Name( )
        if IsEntry_( root, nm ) = false then continue for
        dim as string d = JoinPath( root, nm )
        dim as longint used_ = LastUse_( d )
        if used_ = 0 then continue for
        if now_ - used_ > UNUSED_DAYS * TICKS_PER_DAY then FB.RemoveDirAll( d )
    next
    DropStaleChains_( root )
end sub

private function PoolDir_( byref ctx as Tko.CompilerContext ) as string
    dim as string root = environ( "TKO_MODCACHE" )
    if len( root ) = 0 then
        root = Tko.DiskCache.UserCacheDir( "modcache" )
        if len( root ) = 0 then
            ctx.diags.ReportGlobal( Tko.TKO0150, "no user cache directory; set TKO_MODCACHE" )
            return ""
        end if
    end if
    if FB.IsDir( root ) = false then FB.CreateDirAll( root )
    if FB.IsDir( root ) = false then
        ctx.diags.ReportGlobal( Tko.TKO0150, "cannot create '" & root & "'" )
        return ""
    end if
    return root
end function

function ModuleCacheRoot( byref ctx as Tko.CompilerContext ) as string
    if ctx.options.noModuleCache then return ""
    dim as string root = PoolDir_( ctx )
    if len( root ) > 0 then Trim_( root )
    return root
end function

function CleanModuleCache( byref ctx as Tko.CompilerContext ) as string
    dim as string root = PoolDir_( ctx )
    if len( root ) = 0 then return ""
    dim as long n = 0
    dim as FB.Array( of FB.DirEntry ) es
    if FB.ListDir( root, es ).IsOk( ) then
        for k as long = 0 to es.Count - 1
            if es[k].IsDirectory( ) = false then continue for
            dim as string nm = es[k].Name( )
            if IsEntry_( root, nm ) = false then continue for
            if FB.RemoveDirAll( JoinPath( root, nm ) ).IsOk( ) then n += 1
        next
    end if
    DropStaleChains_( root )
    return "removed " & n & " module cache entr" & iif( n = 1, "y", "ies" ) & " from " & root & Nl_( )
end function

'' Module n's dependencies, all of them, each once.
private sub Closure_ _
    ( byref ctx as Tko.CompilerContext, byval n as long, byref seen as FB.Array( of ubyte ) )
    for e as long = 0 to ctx.ifaceEdgeFrom.Count - 1
        if cast( long, ctx.ifaceEdgeFrom[e] ) <> n then continue for
        dim as long m = cast( long, ctx.ifaceEdgeTo[e] )
        if seen[m] <> 0 then continue for
        seen[m] = 1
        Closure_( ctx, m, seen )
    next
end sub

'' A PATH AS THE KEY SPELLS IT: absolute, and CASE-FOLDED ON WINDOWS, where the filesystem
'' folds case. The editor passes 'C:/dev/tiko-editor-tiko/Toolchains/...' and a shell
'' '.../toolchains/...' -- one directory, and it made two keys, so every fbx module was
'' rebuilt (~15 s) for a compile whose object was already cached. Elsewhere exactly.
private function KeyPath_( byref p as string ) as string
    #ifdef __FB_WIN32__
        return Tko.Text.LowerAscii( AbsPath( p ) )
    #else
        return AbsPath( p )
    #endif
end function

function ModuleKey( byref ctx as Tko.CompilerContext, byval n as long ) as string
    dim as string nl = Nl_( )
    dim as Tko.DriverOptions ptr o = @ctx.options
    dim as string k = "tki-format 1" & nl
    k &= "tiko " & Tko.DiskCache.Stamp( command( 0 ) ) & nl
    k &= "triple " & Tko.Codegen.TargetFor( o->target ).triple & nl
    k &= "options e=" & o->errLevel & " g=" & iif( o->debugInfo, 1, 0 ) & _
         " O=" & o->optLevel & " mt=" & iif( o->threadSafe, 1, 0 ) & _
         " w=" & iif( o->warningsAsErrors, 1, 0 ) & " maxinstdepth=" & o->maxInstDepth & nl
    '' A module's headers are found through these.
    for each p as string in o->includePaths
        k &= "include " & KeyPath_( p ) & nl
    next
    '' ...and a #cinclude binding is made with these.
    for each p as string in o->cDefines
        k &= "cdefine " & p & nl
    next
    for each p as string in o->cOpts
        k &= "copt " & p & nl
    next
    k &= "csysroot " & o->cSysroot & " cnomacros " & iif( o->cNoMacros, 1, 0 ) & nl
    '' The package's [defines], which the module is compiled with.
    dim as Tko.StrVec pdefs
    PackageDefines( ctx, ctx.modPkgName, pdefs )
    for each d as string in pdefs
        k &= "define " & d & nl
    next
    k &= "module " & ctx.ifaceChains[n] & nl
    k &= "dir " & KeyPath_( ctx.ifaceDirs[n] ) & nl
    '' Its sources, in the order the unit reads them -- sorted already (ModuleFiles).
    for each f as ulong in ctx.modFiles
        dim as string p = ctx.sources.AbsPathOf( cast( Tko.FileId, f ) )
        dim as string text_
        Tko.DiskCache.ReadAll( p, text_ )
        dim as long cut = instrrev( p, "/" )
        if instrrev( p, chr( 92 ) ) > cut then cut = instrrev( p, chr( 92 ) )
        k &= "source " & mid( p, cut + 1 ) & " " & len( text_ ) & " " & _
             Tko.DiskCache.Hash( text_ ) & nl
    next
    '' The interfaces of its closure, by chain -- the graph's chain order is the sort.
    dim as FB.Array( of ubyte ) seen
    for i as long = 0 to ctx.ifaceChains.Count - 1
        seen.Push( 0 )
    next
    Closure_( ctx, n, seen )
    dim as Tko.StrVec lines_
    for i as long = 0 to ctx.ifaceChains.Count - 1
        if seen[i] = 0 then continue for
        lines_.Push( "iface " & ctx.ifaceChains[i] & " " & Tko.DiskCache.Hash( ctx.ifaceTexts[i] ) )
    next
    '' Insertion sort: a closure is small.
    for i as long = 1 to lines_.Count - 1
        dim as string v = lines_[i]
        dim as long j = i - 1
        while (j >= 0) andalso (lines_[j] > v)
            lines_[j + 1] = lines_[j]
            j -= 1
        wend
        lines_[j + 1] = v
    next
    for each l as string in lines_
        k &= l & nl
    next
    return k
end function

private function EntryDir_( byref root as string, byref key as string ) as string
    return JoinPath( root, Tko.DiskCache.Hash( key ) )
end function

function ModuleCacheLookup _
    ( byref ctx as Tko.CompilerContext, byref root as string, byref key as string, _
      byref objPath as string, byref iface as string, byref libs as string ) as boolean

    if len( root ) = 0 then return false
    dim as string d = EntryDir_( root, key )
    dim as string deps, k
    if Tko.DiskCache.ReadAll( JoinPath( d, "deps.txt" ), deps ) = false then return false
    if Tko.DiskCache.ReadAll( JoinPath( d, "key.txt" ), k ) = false then return false
    if k <> key then return false
    dim as long p = 1
    while p <= len( deps )
        dim as long e = instr( p, deps, Nl_( ) )
        if e = 0 then e = len( deps ) + 1
        dim as string ln = mid( deps, p, e - p )
        p = e + 1
        if len( ln ) = 0 then continue while
        dim as long t1 = instr( ln, chr( 9 ) )
        dim as long t2 = 0
        if t1 > 0 then t2 = instr( t1 + 1, ln, chr( 9 ) )
        if t2 = 0 then return false
        if Tko.DiskCache.Stamp( mid( ln, t2 + 1 ) ) <> left( ln, t2 - 1 ) then return false
    wend
    if Tko.DiskCache.ReadAll( JoinPath( d, "iface.tki" ), iface ) = false then return false
    if Tko.DiskCache.ReadAll( JoinPath( d, "libs.txt" ), libs ) = false then return false
    objPath = JoinPath( d, "obj.o" )
    if FB.IsFile( objPath ) = false then return false
    '' USED: what keeps the entry past the seven-day trim.
    Tko.DiskCache.Commit( JoinPath( d, "used" ), "", 8 )
    return true
end function

'' The last key stored for this chain FROM THIS DIRECTORY: the key's own 'dir' line says
'' which.
private function ChainFile_( byref root as string, byref chain as string, byref key as string ) as string
    dim as string d = ""
    dim as long at = instr( Nl_( ) & key, Nl_( ) & "dir " )
    if at > 0 then
        dim as long e = instr( at, key, Nl_( ) )
        if e = 0 then e = len( key ) + 1
        d = mid( key, at, e - at )
    end if
    return JoinPath( JoinPath( root, "chains" ), chain & "." & Tko.DiskCache.Hash( d ) & ".key" )
end function

sub ModuleCacheStore _
    ( byref ctx as Tko.CompilerContext, byref root as string, byref key as string, _
      byref objPath as string, byref iface as string, byref libs as string )

    if len( root ) = 0 then return
    dim as string d = EntryDir_( root, key )
    if FB.IsDir( d ) = false then FB.CreateDirAll( d )
    if FB.IsDir( d ) = false then return
    '' What the unit read that is not its own source nor an interface held in memory.
    dim as string dl = ""
    dim as Tko.StrVec done_
    for each f as ulong in ctx.unitFilesRead
        dim as boolean own = false
        for each m as ulong in ctx.modFiles
            if m = f then own = true
        next
        if own then continue for
        dim as Tko.SourceFile ptr sf = ctx.sources.FileAt( cast( Tko.FileId, f ) )
        if sf = 0 then continue for
        if sf->isVirtual then continue for
        dim as string p = ctx.sources.AbsPathOf( cast( Tko.FileId, f ) )
        dim as boolean dup = false
        for each x as string in done_
            if x = p then dup = true
        next
        if dup then continue for
        done_.Push( p )
        dim as string st = Tko.DiskCache.Stamp( p )
        if len( st ) = 0 then return
        dl &= st & chr( 9 ) & p & Nl_( )
    next
    dim as string obj
    if Tko.DiskCache.ReadAll( objPath, obj ) = false then return
    if Tko.DiskCache.Commit( JoinPath( d, "key.txt" ), key, 1 ) = false then return
    if Tko.DiskCache.Commit( JoinPath( d, "iface.tki" ), iface, 2 ) = false then return
    if Tko.DiskCache.Commit( JoinPath( d, "obj.o" ), obj, 3 ) = false then return
    if Tko.DiskCache.Commit( JoinPath( d, "libs.txt" ), libs, 4 ) = false then return
    if Tko.DiskCache.Commit( JoinPath( d, "deps.txt" ), dl, 5 ) = false then return
    dim as string cd = JoinPath( root, "chains" )
    if FB.IsDir( cd ) = false then FB.CreateDirAll( cd )
    '' THE ENTRY THIS ONE SUPERSEDES: the same chain from the same directory, built the same
    '' way, from sources or interfaces that have since changed. Nothing can hit it again.
    dim as string cf = ChainFile_( root, ctx.modChain, key )
    dim as string prev
    if Tko.DiskCache.ReadAll( cf, prev ) then
        if (prev <> key) andalso (Config_( prev ) = Config_( key )) then
            dim as string pd = EntryDir_( root, prev )
            if (pd <> d) andalso IsEntry_( root, Tko.DiskCache.Hash( prev ) ) then FB.RemoveDirAll( pd )
        end if
    end if
    Tko.DiskCache.Commit( cf, key, 6 )
end sub

function MissReason _
    ( byref root as string, byref chain as string, byref key as string ) as string
    dim as string last_
    if Tko.DiskCache.ReadAll( ChainFile_( root, chain, key ), last_ ) = false then
        return "new"
    end if
    dim as long p = 1
    while p <= len( key )
        dim as long e = instr( p, key, Nl_( ) )
        if e = 0 then e = len( key ) + 1
        dim as string ln = mid( key, p, e - p )
        p = e + 1
        if instr( Nl_( ) & last_, Nl_( ) & ln & Nl_( ) ) = 0 then return ln
    wend
    return "a file it read changed"
end function

end namespace

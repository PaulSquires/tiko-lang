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
'' <root>/chains/<chain>.key is the last key stored for a chain, read only to say, under
'' -v, which line of the key made a miss.

#include once "driver/modcache.bi"
#include once "driver/modresolve.bi"
#include once "support/diskcache.bi"
#include once "codegen/target.bi"
#include once "fb/filesystem.bi"

namespace Tko.Modules

private function Nl_( ) as string
    return chr( 10 )
end function

function ModuleCacheRoot( byref ctx as Tko.CompilerContext ) as string
    if ctx.options.noModuleCache then return ""
    dim as string root = environ( "TKO_MODCACHE" )
    if len( root ) = 0 then
        dim as string first_ = DirOfFile( ctx.sources.AbsPathOf( cast( Tko.FileId, 1 ) ) )
        dim as string d = first_
        dim as string found = ""
        for guard as long = 0 to 64
            if len( d ) = 0 then exit for
            if FB.IsFile( JoinPath( d, "tiko.toml" ) ) then
                found = d
                exit for
            end if
            dim as string up_ = DirOfFile( d )
            if (len( up_ ) = 0) orelse (up_ = d) then exit for
            d = up_
        next
        if len( found ) = 0 then found = first_
        root = JoinPath( JoinPath( found, ".tiko" ), "cache" )
    end if
    if FB.IsDir( root ) = false then FB.CreateDirAll( root )
    if FB.IsDir( root ) = false then
        ctx.diags.ReportGlobal( Tko.TKO0150, "cannot create '" & root & "'" )
        return ""
    end if
    return root
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
        k &= "include " & p & nl
    next
    '' ...and a #cinclude binding is made with these.
    for each p as string in o->cDefines
        k &= "cdefine " & p & nl
    next
    for each p as string in o->cOpts
        k &= "copt " & p & nl
    next
    k &= "csysroot " & o->cSysroot & " cnomacros " & iif( o->cNoMacros, 1, 0 ) & nl
    k &= "module " & ctx.ifaceChains[n] & nl
    k &= "dir " & ctx.ifaceDirs[n] & nl
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
    return FB.IsFile( objPath )
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
    Tko.DiskCache.Commit( JoinPath( cd, ctx.modChain & ".key" ), key, 6 )
end sub

function MissReason _
    ( byref root as string, byref chain as string, byref key as string ) as string
    dim as string last_
    if Tko.DiskCache.ReadAll( JoinPath( JoinPath( root, "chains" ), chain & ".key" ), last_ ) = false then
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

'' cicache.bas -- the #cinclude cache: a binding, kept on disk under a key. See cicache.bi.
''
'' AN ENTRY IS A DIRECTORY named by the key's hash:
''
''     key.txt      the whole key, so a hash collision is a miss and not a wrong binding
''     binding.bi   the binding -- a REAL file, so a diagnostic in it names a real path
''     state.txt    what the import decided, to seed a delta after it (cimport/state.bas)
''     deps.txt     every file clang read, as 'size <tab> mtime <tab> path'
''
'' deps.txt IS WRITTEN LAST and an entry without one does not exist: a reader that finds
'' a half-written entry misses, and re-imports. Every file goes in under a temporary name
'' and is MOVED over its final one -- an atomic replace in tiko's runtime (ReplaceFileW,
'' rename on POSIX) -- so two builds committing the same entry at once each leave a whole
'' file, and since the key decides the content, whichever wins is right.
''
'' A HIT RE-CHECKS EVERY DEPENDENCY: a header edited since, or a size that changed, is a
'' miss. Size and modification time, not content -- the cost of a hash over windows.h's
'' 600 files on every build is what the cache exists to avoid.

#include once "driver/cicache.bi"
#include once "fb/filesystem.bi"
#include once "codegen/target.bi"

namespace Tko.CImportDriver

'' FNV-1a, 64 bits, as sixteen hex digits: the entry's directory name.
private function Hash_( byref s as string ) as string
    dim as ulongint h = &hCBF29CE484222325ull
    for i as long = 0 to len( s ) - 1
        h xor= s[i]
        h *= &h100000001B3ull
    next
    return lcase( hex( h, 16 ) )
end function

private function Env_( byref n as string ) as string
    return environ( n )
end function

'' The file's size and modification time, as the dependency list records them. "" when it
'' is not there.
private function Stamp_( byref path_ as string ) as string
    dim as FB.FsResultInfo r = FB.Stat( path_ )
    if r.IsOk( ) = false then return ""
    dim as FB.FileInfo fi = r.Value( )
    if fi.IsFile( ) = false then return ""
    return str( fi.Size( ) ) & chr( 9 ) & str( fi.ModifiedUtc( ) )
end function

'' WHERE THE ENTRIES LIVE: -ccachedir, else the user's cache directory. "" with -cnocache,
'' which is no read and no write.
function CacheRoot( byref ctx as Tko.CompilerContext ) as string
    if ctx.options.cNoCache then return ""
    if len( ctx.options.cCacheDir ) then return ctx.options.cCacheDir
#ifdef __FB_WIN32__
    dim as string base_ = Env_( "LOCALAPPDATA" )
    if len( base_ ) = 0 then return ""
    return base_ & "\tiko\cimport"
#else
    dim as string base_ = Env_( "XDG_CACHE_HOME" )
    if len( base_ ) = 0 then
        dim as string home = Env_( "HOME" )
        if len( home ) = 0 then return ""
        base_ = home & "/.cache"
    end if
    return base_ & "/tiko/cimport"
#endif
end function

'' The first 'gcc' on PATH: how clang finds MinGW for the win64 target, and so which
'' MinGW's headers a binding was made from.
private function GccOnPath_( ) as string
    dim as string p = Env_( "PATH" )
#ifdef __FB_WIN32__
    dim as string sep = ";", exe = "\gcc.exe"
#else
    dim as string sep = ":", exe = "/gcc"
#endif
    dim as long st = 1
    while st <= len( p ) + 1
        dim as long en = instr( st, p, sep )
        if en = 0 then en = len( p ) + 1
        dim as string d = mid( p, st, en - st )
        if len( d ) andalso FB.IsFile( d & exe ) then return d & exe
        st = en + 1
    wend
    return ""
end function

'' EVERYTHING A BINDING DEPENDS ON THAT IS NOT A FILE clang reads -- those are the
'' dependency list. The importer (the running tiko, by size and time: a rebuilt one makes
'' different bindings), libclang and its headers, the target, where clang finds the
'' system's headers, and the working directory, which a quoted header resolves against.
function CacheKey _
    ( byref ctx as Tko.CompilerContext, byref api as Tko.CImport.ClangApi, _
      byref importKey as string ) as string
    dim as string nl = chr( 10 )
    dim as string k = "tiko-cimport-cache 1" & nl & importKey
    k &= "tiko " & Stamp_( command( 0 ) ) & nl
    k &= "libclang " & api.libPath & nl & "clang " & api.version & nl
    k &= "resource " & Tko.CImport.ClangResourceDir( api ) & nl
    k &= "cwd " & curdir( ) & nl
    k &= "triple " & Tko.Codegen.TargetFor( ctx.options.target ).triple & nl
    k &= "CPATH " & Env_( "CPATH" ) & nl & "C_INCLUDE_PATH " & Env_( "C_INCLUDE_PATH" ) & nl
    k &= "INCLUDE " & Env_( "INCLUDE" ) & nl
    k &= "VCToolsInstallDir " & Env_( "VCToolsInstallDir" ) & nl
    k &= "WindowsSdkDir " & Env_( "WindowsSdkDir" ) & nl
    if ctx.options.target = Tko.TARGET_WIN64 then k &= "gcc " & GccOnPath_( ) & nl
    return k
end function

private function ReadAll_( byref path_ as string, byref text as string ) as boolean
    dim as long f = freefile( )
    if open( path_ for binary access read as #f ) <> 0 then return false
    dim as longint n = lof( f )
    text = space( n )
    if n > 0 then get #f, , text
    close #f
    return true
end function

'' Write under a temporary name, then move it over the real one.
private function Commit_( byref path_ as string, byref text as string, byval serial as long ) as boolean
    dim as string tmp = path_ & "." & hex( cast( ulongint, timer * 1000000.0 ), 12 ) & "." & serial & ".tmp"
    dim as long f = freefile( )
    if open( tmp for binary access write as #f ) <> 0 then return false
    if len( text ) then put #f, , text
    close #f
    dim as FB.FsResultBool r = FB.MoveFile( tmp, path_, true )
    if r.IsOk( ) = false then
        FB.RemoveFile( tmp )
        return false
    end if
    return true
end function

function CacheLookup _
    ( byref root as string, byref key as string, byref bindingPath as string, _
      byref text as string, byref state as string ) as boolean
    if len( root ) = 0 then return false
    dim as string d = root & "/" & Hash_( key )
    dim as string deps, k
    if ReadAll_( d & "/deps.txt", deps ) = false then return false
    if ReadAll_( d & "/key.txt", k ) = false then return false
    if k <> key then return false
    dim as long p = 1
    while p <= len( deps )
        dim as long e = instr( p, deps, chr( 10 ) )
        if e = 0 then e = len( deps ) + 1
        dim as string ln = mid( deps, p, e - p )
        p = e + 1
        if len( ln ) = 0 then continue while
        dim as long t1 = instr( ln, chr( 9 ) )
        dim as long t2 = instr( t1 + 1, ln, chr( 9 ) )
        if (t1 = 0) orelse (t2 = 0) then return false
        if Stamp_( mid( ln, t2 + 1 ) ) <> left( ln, t2 - 1 ) then return false
    wend
    if ReadAll_( d & "/state.txt", state ) = false then return false
    bindingPath = d & "/binding.bi"
    return ReadAll_( bindingPath, text )
end function

function CacheStore _
    ( byref root as string, byref key as string, byref text as string, _
      byref state as string, byref deps as Tko.StrVec ) as string
    if len( root ) = 0 then return ""
    dim as string d = root & "/" & Hash_( key )
    if FB.IsDir( d ) = false then
        FB.CreateDirAll( d )
        if FB.IsDir( d ) = false then return ""
    end if
    dim as string dl
    for i as long = 0 to deps.Count - 1
        dim as string st = Stamp_( deps[i] )
        if len( st ) = 0 then return ""
        dl &= st & chr( 9 ) & deps[i] & chr( 10 )
    next
    if Commit_( d & "/key.txt", key, 1 ) = false then return ""
    if Commit_( d & "/binding.bi", text, 2 ) = false then return ""
    if Commit_( d & "/state.txt", state, 3 ) = false then return ""
    if Commit_( d & "/deps.txt", dl, 4 ) = false then return ""
    return d & "/binding.bi"
end function

end namespace

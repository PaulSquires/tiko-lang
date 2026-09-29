'' modresolve.bas -- where an '#import' path leads. The preprocessor has already checked
'' its form (src/pp/ppmodule.bas); this finds the directory, and names the module.

#include once "driver/modresolve.bi"
#include once "driver/manifest.bi"
#include once "support/text.bi"
#include once "fb/filesystem.bi"

namespace Tko.Modules


'' Paths compare CASE-INSENSITIVELY on Windows, where the filesystem does, and exactly
'' elsewhere.
private function SamePath_( byref a as string, byref b as string ) as boolean
    #ifdef __FB_WIN32__
        return Tko.Text.LowerAscii( a ) = Tko.Text.LowerAscii( b )
    #else
        return a = b
    #endif
end function

function NormPath( byref p as string ) as string
    dim as string s = p
    for i as long = 0 to len( s ) - 1
        if s[i] = 92 then s[i] = 47
    next

    '' The part no '..' may climb above: '/', or a drive 'C:/'.
    dim as string prefix = ""
    if left( s, 1 ) = "/" then
        prefix = "/"
        s = mid( s, 2 )
    elseif (len( s ) >= 3) andalso (mid( s, 2, 2 ) = ":/") then
        prefix = left( s, 3 )
        s = mid( s, 4 )
    end if

    dim as Tko.StrVec segs
    dim as long st = 1
    do
        dim as long sl = instr( st, s, "/" )
        dim as string seg = iif( sl = 0, mid( s, st ), mid( s, st, sl - st ) )
        if (seg = "") orelse (seg = ".") then
            '' nothing
        elseif seg = ".." then
            dim as boolean canPop = (segs.Count > 0)
            if canPop then canPop = (segs[segs.Count - 1] <> "..")
            if canPop then
                segs.Pop( )
            elseif len( prefix ) = 0 then
                segs.Push( ".." )          '' a relative path may begin above its base
            end if
        else
            segs.Push( seg )
        end if
        if sl = 0 then exit do
        st = sl + 1
    loop

    dim as string outp = prefix
    for i as long = 0 to segs.Count - 1
        if i > 0 then outp += "/"
        outp += segs[i]
    next
    if len( outp ) = 0 then outp = "."
    return outp
end function

function JoinPath( byref a as string, byref b as string ) as string
    if (len( a ) = 0) orelse (a = ".") then return NormPath( b )
    return NormPath( a & "/" & b )
end function

function AbsPath( byref p as string ) as string
    dim as boolean absolute_ = (instr( p, ":" ) > 0) orelse (left( p, 1 ) = "/")
    if absolute_ then return NormPath( p )
    return JoinPath( curdir( ), p )
end function

function DirOfFile( byref p as string ) as string
    dim as string n = NormPath( p )
    dim as long sl = instrrev( n, "/" )
    if sl = 0 then return "."
    if sl = 1 then return "/"
    dim as string d = left( n, sl - 1 )
    if right( d, 1 ) = ":" then d += "/"
    return d
end function

'' Is p the directory root, or inside it?
private function IsWithin_( byref p as string, byref root as string ) as boolean
    if root = "." then
        dim as boolean up = (p = "..") orelse (left( p, 3 ) = "../")
        dim as boolean abs_ = (left( p, 1 ) = "/") orelse (mid( p, 2, 1 ) = ":")
        return (up = false) andalso (abs_ = false)
    end if
    if SamePath_( p, root ) then return true
    dim as string pre = left( p, len( root ) + 1 )
    return SamePath_( pre, root & "/" )
end function

'' What follows root in p, which is inside it: "" for root itself.
private function Below_( byref p as string, byref root as string ) as string
    if root = "." then return iif( p = ".", "", p )
    if len( p ) <= len( root ) then return ""
    return mid( p, len( root ) + 2 )
end function

private function ChainOf_( byref pkgName as string, byref rel as string ) as string
    dim as string c = Tko.Text.LowerAscii( pkgName )
    if len( rel ) = 0 then return c
    dim as string r = Tko.Text.LowerAscii( rel )
    for i as long = 0 to len( r ) - 1
        if r[i] = 47 then r[i] = 46
    next
    return c & "." & r
end function

'' THE PACKAGE SEARCH ROOTS, in order: each -i the user gave (not the bundled header
'' directory, which cmdline.bas appends after them), then each TKO_PATH entry.
private sub SearchRoots_( byref ctx as Tko.CompilerContext, byref roots as Tko.StrVec )
    for i as long = 0 to ctx.options.userIncludeCount - 1
        roots.Push( NormPath( ctx.options.includePaths[i] ) )
    next
    dim as string env_ = environ( "TKO_PATH" )
    #ifdef __FB_WIN32__
        const SEP = ";"
    #else
        const SEP = ":"
    #endif
    dim as long st = 1
    while st <= len( env_ )
        dim as long sp = instr( st, env_, SEP )
        dim as string one_ = iif( sp = 0, mid( env_, st ), mid( env_, st, sp - st ) )
        if len( one_ ) > 0 then roots.Push( NormPath( one_ ) )
        if sp = 0 then exit while
        st = sp + 1
    wend
end sub

'' THE TOOLCHAIN'S PACKAGE TREE: --pkg-dir, else TKO_PKG, else <exe-dir>/pkg, else
'' <exe-dir>/../pkg -- the same two layouts the default include directory is found in
'' (cmdline.bas). --pkg-dir is for a host whose executable is not tiko's: in the editor's
'' tikoParser.dll, <exe-dir> is the editor's folder.
private function PkgDir_( byref ctx as Tko.CompilerContext ) as string
    if len( ctx.options.pkgDir ) > 0 then return NormPath( ctx.options.pkgDir )
    dim as string env_ = environ( "TKO_PKG" )
    if len( env_ ) > 0 then return NormPath( env_ )
    dim as string exeDir = exepath( )
    if len( exeDir ) = 0 then return ""
    dim as string cand = JoinPath( exeDir, "pkg" )
    if FB.IsDir( cand ) then return cand
    cand = JoinPath( exeDir, "../pkg" )
    if FB.IsDir( cand ) then return cand
    return ""
end function

sub ResetPackages( byref ctx as Tko.CompilerContext )
    ctx.pkgNames.Clear( ) : ctx.pkgRoots.Clear( )
    ctx.pkgDepOwner.Clear( ) : ctx.pkgDepName.Clear( ) : ctx.pkgDepPath.Clear( )
    ctx.pkgDefOwner.Clear( ) : ctx.pkgDefText.Clear( )
    ctx.pkgDdDep.Clear( ) : ctx.pkgDdText.Clear( )
    ctx.pkgRootKnown = false
end sub

private function PkgIndex_( byref ctx as Tko.CompilerContext, byref name_ as string ) as long
    for i as long = 0 to ctx.pkgNames.Count - 1
        if ctx.pkgNames[i] = name_ then return i
    next
    return -1
end function

'' ONE PACKAGE NAME, ONE ROOT (TKO0149). The first time a name is met its manifest, if it
'' has one, is read: its name must be the one the package was found by (TKO0146), and 'std'
'' belongs to the toolchain (TKO0148).
private function Register_ _
    ( byref ctx as Tko.CompilerContext, byref name_ as string, byref root as string, _
      byval isRoot as boolean ) as boolean
    dim as string n = Tko.Text.LowerAscii( name_ )
    dim as long at = PkgIndex_( ctx, n )
    if at >= 0 then
        if SamePath_( ctx.pkgRoots[at], NormPath( root ) ) then return true
        ctx.diags.ReportGlobal( Tko.TKO0149, n, ctx.pkgRoots[at], NormPath( root ) )
        return false
    end if
    ctx.pkgNames.Push( n )
    ctx.pkgRoots.Push( NormPath( root ) )
    dim as string idx = str( ctx.pkgNames.Count - 1 )
    if HasManifest( root ) = false then return true
    dim as Manifest m
    if LoadManifest( ctx, root, m ) = false then return false
    if (isRoot = false) andalso (m.name <> n) then
        ctx.diags.ReportGlobal( Tko.TKO0146, n, "its tiko.toml names it '" & m.name & "'" )
        return false
    end if
    if m.name = "std" then
        dim as string pk = PkgDir_( ctx )
        dim as boolean toolchain_ = (len( pk ) > 0)
        if toolchain_ then toolchain_ = SamePath_( NormPath( root ), JoinPath( pk, "std" ) )
        if toolchain_ = false then
            ctx.diags.ReportGlobal( Tko.TKO0148, "std" )
            return false
        end if
    end if
    for k as long = 0 to m.depNames.Count - 1
        ctx.pkgDepOwner.Push( idx ) : ctx.pkgDepName.Push( m.depNames[k] ) : ctx.pkgDepPath.Push( m.depPaths[k] )
    next
    for each d as string in m.defines
        ctx.pkgDefOwner.Push( idx ) : ctx.pkgDefText.Push( d )
    next
    if isRoot then
        for k as long = 0 to m.ddDep.Count - 1
            ctx.pkgDdDep.Push( Tko.Text.LowerAscii( m.ddDep[k] ) ) : ctx.pkgDdText.Push( m.ddDefine[k] )
        next
    end if
    return true
end function

function RootPackage _
    ( byref ctx as Tko.CompilerContext, byref name_ as string, byref root as string ) as boolean
    if ctx.pkgRootKnown then
        name_ = ctx.pkgRootName
        root = ctx.pkgRootDir
        return true
    end if
    ctx.pkgRootKnown = true
    dim as string first_ = DirOfFile( ctx.sources.PathOf( cast( Tko.FileId, 1 ) ) )
    ctx.pkgRootName = ANON_PACKAGE
    ctx.pkgRootDir = first_
    '' The nearest tiko.toml at or above the first root's directory.
    '' Found by the absolute path, and kept in the roots' own spelling -- the first root's
    '' directory with as many '..' as it took -- since paths compare lexically.
    dim as string abs_ = DirOfFile( ctx.sources.AbsPathOf( cast( Tko.FileId, 1 ) ) )
    dim as string d = abs_
    dim as string rel = first_
    for guard as long = 0 to 64
        if HasManifest( d ) then
            dim as Manifest m
            if LoadManifest( ctx, d, m ) = false then return false
            ctx.pkgRootName = m.name
            ctx.pkgRootDir = NormPath( rel )
            exit for
        end if
        dim as string up_ = DirOfFile( d )
        if (len( up_ ) = 0) orelse SamePath_( up_, d ) then exit for
        d = up_
        rel = JoinPath( rel, ".." )
    next
    name_ = ctx.pkgRootName
    root = ctx.pkgRootDir
    if ctx.pkgRootName = ANON_PACKAGE then return true
    return Register_( ctx, ctx.pkgRootName, ctx.pkgRootDir, true )
end function

sub PackageDefines( byref ctx as Tko.CompilerContext, byref name_ as string, byref outv as Tko.StrVec )
    outv.Clear( )
    dim as long at = PkgIndex_( ctx, Tko.Text.LowerAscii( name_ ) )
    if at < 0 then return
    dim as string idx = str( at )
    for k as long = 0 to ctx.pkgDefOwner.Count - 1
        if ctx.pkgDefOwner[k] = idx then outv.Push( ctx.pkgDefText[k] )
    next
    '' The root's [dependencies.<this>.defines], key by key.
    for k as long = 0 to ctx.pkgDdDep.Count - 1
        if ctx.pkgDdDep[k] <> ctx.pkgNames[at] then continue for
        dim as string kk = Tko.Text.LowerAscii( left( ctx.pkgDdText[k], instr( ctx.pkgDdText[k], "=" ) ) )
        dim as boolean replaced = false
        for q as long = 0 to outv.Count - 1
            if Tko.Text.LowerAscii( left( outv[q], instr( outv[q], "=" ) ) ) = kk then
                outv[q] = ctx.pkgDdText[k]
                replaced = true
            end if
        next
        if replaced = false then outv.Push( ctx.pkgDdText[k] )
    next
end sub

sub ModuleFiles( byref dir_ as string, byref files as Tko.StrVec )
    dim as FB.Array( of FB.DirEntry ) entries
    if FB.ListDir( dir_, entries ).IsOk( ) = false then return
    for k as long = 0 to entries.Count - 1
        if entries[k].IsFile( ) = false then continue for
        dim as string nm = entries[k].Name( )
        '' A MODULE'S SOURCES are '.tiko' files, and the legacy '.bas' (T14). A '.ti' is a header.
        dim as string lnm = Tko.Text.LowerAscii( nm )
        if (right( lnm, 4 ) <> ".bas") andalso (right( lnm, 5 ) <> ".tiko") then continue for
        '' Insertion sort: a module is a handful of files.
        dim as string key = Tko.Text.LowerAscii( nm )
        dim as long at = files.Count
        files.Push( nm )
        while at > 0
            if Tko.Text.LowerAscii( files[at - 1] ) <= key then exit while
            files[at] = files[at - 1]
            at -= 1
        wend
        files[at] = nm
    next
end sub

sub ChainForDir( byref ctx as Tko.CompilerContext, byref dir_ as string, byref outw as ModWhere )
    dim as string d = NormPath( dir_ )
    dim as Tko.StrVec roots
    SearchRoots_( ctx, roots )
    dim as string pk = PkgDir_( ctx )
    if len( pk ) > 0 then roots.Push( pk )
    for i as long = 0 to roots.Count - 1
        if IsWithin_( d, roots[i] ) = false then continue for
        if SamePath_( d, roots[i] ) then continue for
        dim as string rel = Below_( d, roots[i] )
        dim as long sl = instr( rel, "/" )
        dim as string first_ = iif( sl = 0, rel, left( rel, sl - 1 ) )
        dim as string rest = iif( sl = 0, "", mid( rel, sl + 1 ) )
        outw.dir_ = d
        outw.pkgName = Tko.Text.LowerAscii( first_ )
        outw.pkgRoot = JoinPath( roots[i], first_ )
        outw.chain = ChainOf_( first_, rest )
        return
    next
    dim as long sl = instrrev( d, "/" )
    outw.dir_ = d
    outw.pkgName = ANON_PACKAGE
    outw.pkgRoot = DirOfFile( d )
    outw.chain = ChainOf_( ANON_PACKAGE, mid( d, sl + 1 ) )
end sub

function ResolveImport _
    ( byref ctx as Tko.CompilerContext, byref rec as Tko.PpImport, _
      byref fromDir as string, byref pkgName as string, byref pkgRoot as string, _
      byref outw as ModWhere ) as boolean

    dim as string p = rec.path
    dim as Tko.SourceRange at = Tko.PointRange( rec.loc )

    '' ---- 1. relative, inside the importing file's package.
    dim as boolean relative = (left( p, 2 ) = "./") orelse (left( p, 3 ) = "../")
    if relative then
        dim as string target = JoinPath( fromDir, p )
        if IsWithin_( target, pkgRoot ) = false then
            ctx.diags.Report( Tko.TKO0142, at, p, pkgRoot )
            return false
        end if
        if FB.IsDir( target ) = false then
            ctx.diags.Report( Tko.TKO0140, at, p, target )
            return false
        end if
        outw.dir_ = target
        outw.pkgName = pkgName
        outw.pkgRoot = pkgRoot
        outw.chain = ChainOf_( pkgName, Below_( target, pkgRoot ) )
        return true
    end if

    dim as long sl = instr( p, "/" )
    dim as string first_ = iif( sl = 0, p, left( p, sl - 1 ) )
    dim as string rest = iif( sl = 0, "", mid( p, sl + 1 ) )
    dim as string lfirst = Tko.Text.LowerAscii( first_ )

    '' ---- 2 and 3: the current package, and its manifest's dependencies. 'std' skips them.
    if lfirst <> "std" then
        dim as string proot = ""
        if lfirst = Tko.Text.LowerAscii( pkgName ) then proot = pkgRoot
        if len( proot ) = 0 then
            dim as string owner = str( PkgIndex_( ctx, Tko.Text.LowerAscii( pkgName ) ) )
            for k as long = 0 to ctx.pkgDepName.Count - 1
                if (ctx.pkgDepOwner[k] = owner) andalso (ctx.pkgDepName[k] = lfirst) then proot = ctx.pkgDepPath[k]
            next
            if len( proot ) > 0 then
                if FB.IsDir( proot ) = false then
                    ctx.diags.ReportGlobal( Tko.TKO0146, lfirst, "no directory at '" & proot & "'" )
                    return false
                end if
                if Register_( ctx, lfirst, proot, false ) = false then return false
            end if
        end if
        if len( proot ) > 0 then
            dim as string target = iif( len( rest ) = 0, proot, JoinPath( proot, rest ) )
            if FB.IsDir( target ) = false then
                ctx.diags.Report( Tko.TKO0140, at, p, target )
                return false
            end if
            outw.dir_ = target
            outw.pkgName = lfirst
            outw.pkgRoot = proot
            outw.chain = ChainOf_( first_, rest )
            return true
        end if
    end if

    '' ---- 4 and 5: a package named by the first segment.

    dim as Tko.StrVec roots
    if Tko.Text.LowerAscii( first_ ) <> "std" then SearchRoots_( ctx, roots )
    dim as string pk = PkgDir_( ctx )
    if len( pk ) > 0 then roots.Push( pk )

    dim as string tried = ""
    for i as long = 0 to roots.Count - 1
        dim as string proot = JoinPath( roots[i], first_ )
        if FB.IsDir( proot ) = false then
            tried += iif( len( tried ) > 0, ", ", "" ) & proot
            continue for
        end if
        '' THE PACKAGE IS FOUND, so this is the answer whether or not the module is in it:
        '' a later root holding another package of the same name does not get a say.
        dim as string target = iif( len( rest ) = 0, proot, JoinPath( proot, rest ) )
        if FB.IsDir( target ) = false then
            ctx.diags.Report( Tko.TKO0140, at, p, target )
            return false
        end if
        if Register_( ctx, lfirst, proot, false ) = false then return false
        outw.dir_ = target
        outw.pkgName = lfirst
        outw.pkgRoot = proot
        outw.chain = ChainOf_( first_, rest )
        return true
    next

    if len( tried ) = 0 then tried = "no -i, no TKO_PATH, and no toolchain pkg/ directory"
    ctx.diags.Report( Tko.TKO0140, at, p, tried )
    return false
end function

end namespace

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
    if (ctx.build = 0) orelse (eligible = false) orelse (restartDepth > 0) then return
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
        if (w = "-o") orelse (w = "--diagnostics-file") then
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
    key = Tko.Modules.UnitKey( ctx, id, Tko.Driver.IsMainUnit_( ctx, id, i ), i = 1, s.args )
    dim as string hitObj, hitIface, hitLibs
    if Tko.Modules.ModuleCacheLookup( ctx, s.root, key, hitObj, hitIface, hitLibs ) = false then
        if ctx.options.verbose then
            print "unit " & ctx.sources.PathOf( id ) & ": miss (" & _
                  Tko.Modules.MissReason( s.root, Chain_( ctx, i ), key ) & ")"
        end if
        return false
    end if
    if ctx.options.verbose then print "unit " & ctx.sources.PathOf( id ) & ": hit"
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

end namespace

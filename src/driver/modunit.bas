'' modunit.bas -- compiling one module as one unit (ADR 0017; RFC-0003 §1-2).
''
'' A MODULE IS COMPILED AS ONE TRANSLATION UNIT: its .bas files, sorted, read one after
'' another by one preprocessor engine (PpConfig.moduleFiles), parsed into one tree. That
'' is not a choice -- generic instantiation re-parses token ranges of the unit's single
'' token vector, so a module whose files were separate units could not instantiate a
'' generic declared in one of them from another.
''
'' THE SEED IS HERMETIC. A module never sees its importer's macros, and no importer is
'' here to see: the command line's -d defines are dropped, the output kind is always an
'' object -- whatever the program that links it will be -- and __TKO_MODULE__ names the
'' chain. What a module's compiled form depends on is its own files and the target.

#import "std/containers"
#include once "driver/modunit.bi"
#include once "driver/modresolve.bi"
#include once "support/text.bi"

namespace Tko.Modules

function PrepareModuleUnit _
    ( byref ctx as Tko.CompilerContext, byref dir_ as string, byref srcInputs as Tko.StrVec ) as boolean

    dim as ModWhere w
    ChainForDir( ctx, dir_, w )
    dim as Tko.StrVec files
    ModuleFiles( w.dir_, files )
    if files.Count = 0 then
        ctx.diags.ReportGlobal( Tko.TKO0147, w.dir_ )
        return false
    end if
    srcInputs.Clear( )
    ctx.modFiles.Clear( )
    for each nm as string in files
        srcInputs.Push( JoinPath( w.dir_, nm ) )
        '' Loaded first, before anything else: FileIds 1..n.
        ctx.modFiles.Push( cast( ulong, srcInputs.Count ) )
    next
    ctx.modChain = w.chain
    ctx.modName = mid( w.chain, instrrev( w.chain, "." ) + 1 )
    ctx.modFileCount = files.Count
    ctx.modPkgName = w.pkgName
    ctx.modPkgRoot = w.pkgRoot
    return true
end function

sub ModuleUnitConfig _
    ( byref ctx as Tko.CompilerContext, byref cfg as Tko.PpConfig, _
      byref files as Tko.IdVec, byref noDefines as Tko.StrVec )

    files.Clear( )
    for each f as ulong in ctx.modFiles
        files.Push( f )
    next
    cfg.moduleFiles = @files
    cfg.moduleChain = ctx.modChain
    '' No -d: a module never sees its importer's macros. Its PACKAGE's [defines] it does
    '' see (RFC-0007 §2).
    PackageDefines( ctx, ctx.modPkgName, noDefines )
    cfg.defines = @noDefines
    cfg.outKind = 3
    cfg.cmdlineIgnored = true
end sub

end namespace

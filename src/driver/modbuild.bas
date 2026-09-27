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

#include once "driver/modbuild.bi"
#include once "driver/modgraph.bi"
#include once "driver/unit.bi"
#include once "driver/modresolve.bi"

namespace Tko.Modules

function BuildImports _
    ( byref ctx as Tko.CompilerContext, byval rootCount as long, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec, _
      byref toolExit as long ) as boolean

    dim as ModGraph g
    if BuildGraph( ctx, rootCount, true, g ) = false then return false
    if g.chains.Count = 0 then return true

    '' THE OUTPUT KINDS THAT STOP BEFORE A LINK name one file per root; where each module's
    '' object or IR would go is phase P9's question (RFC-0005 §6).
    dim as boolean stops = ctx.options.compileOnly orelse ctx.options.emitIr orelse ctx.options.emitAsm
    if stops then
        ctx.diags.ReportGlobal( Tko.TKO0992, _
            "-c, --emit-ir and --emit-asm of a program that imports modules (phase P9)" )
        return false
    end if

    ctx.importsBuilt = true
    ctx.ifaceChains.Clear( )
    ctx.ifaceFiles.Clear( )
    for i as long = 0 to g.chains.Count - 1
        ctx.ifaceChains.Push( g.chains[i] )
        ctx.ifaceFiles.Push( cast( ulong, Tko.FILE_NONE ) )
    next
    ctx.ifaceEdgeFrom.Clear( )
    ctx.ifaceEdgeTo.Clear( )
    for e as long = 0 to g.edgeFrom.Count - 1
        ctx.ifaceEdgeFrom.Push( g.edgeFrom[e] )
        ctx.ifaceEdgeTo.Push( g.edgeTo[e] )
    next
    ctx.ifaceRootDir = DirOfFile( ctx.sources.PathOf( cast( Tko.FileId, 1 ) ) )

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
        dim as Tko.StrVec restartArgs
        '' A module cannot '#cmdline' (TKO0366), so this never asks for a restart.
        Tko.Driver.CompileUnit( ctx, cast( long, ctx.modFiles[0] ), 1, 1, true, _
                                linkObjs, tempObjs, toolExit, restartArgs )
        if (toolExit <> Tko.EXIT_OK) orelse Tko.Driver.FrontendFailed_( ctx ) then exit for
    next
    ctx.modChain = ""
    ctx.modName = ""
    ctx.modFiles.Clear( )
    ctx.modFileCount = 0
    return (toolExit = Tko.EXIT_OK) andalso (Tko.Driver.FrontendFailed_( ctx ) = false)
end function

end namespace

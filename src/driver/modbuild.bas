'' modbuild.bas -- building the modules a program imports (ADR 0017; RFC-0005 §3).
''
'' The graph is built from the roots' headers (modgraph.bas), and each module in its order
'' is compiled as one unit -- the same pass 'tiko -c <dir>' runs (unit.bas, modunit.bas) --
'' into an intermediate object that joins the link, as a root's does. Then the roots are
'' compiled, with '#import' no longer TKO0992.
''
'' NOT YET (phase P3 continues): an importer cannot name what a module exports until the
'' module's interface is read into it (RFC-0004). Until then a root may import a module
'' and use nothing of it -- which already links the module in, and runs its top-level code
'' before the program's.

#include once "driver/modbuild.bi"
#include once "driver/modgraph.bi"
#include once "driver/unit.bi"

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
    for each n as ulong in g.order
        ctx.modChain = g.chains[n]
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
    next
    ctx.modChain = ""
    ctx.modName = ""
    ctx.modFiles.Clear( )
    ctx.modFileCount = 0
    return (toolExit = Tko.EXIT_OK) andalso (Tko.Driver.FrontendFailed_( ctx ) = false)
end function

end namespace

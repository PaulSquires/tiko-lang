'' modgraph.bas -- the build graph (ADR 0017; RFC-0005 §1-2).
''
'' DISCOVERY READS HEADERS ONLY. Each file is run through the preprocessor with
'' PpConfig.scanHeader, which stops where the part of a file that may hold '#import' ends
'' (src/pp/ppmodule.bas) -- so the graph costs a few lines of each file, not a compile.
'' A root file is scanned with the command line's -d defines, a module file without them:
'' a module never sees its importer's macros, and its header is read the way its compile
'' will read it.
''
'' A MODULE IS A DIRECTORY. Every .bas in it is a file of the module and must begin
'' '#module' (TKO0145); subdirectories are other modules. The graph's nodes are modules,
'' named by chain, and an edge is an '#import' in any of a module's files.
''
'' THE ORDER is dependencies first, and between modules with no path from one to the other
'' it is the chains' own order -- Go's rule since 1.21, which makes it a function of the
'' graph and never of the command line. A cycle is refused and named whole (TKO0141).

#include once "driver/modgraph.bi"
#include once "driver/modresolve.bi"
#include once "driver/unit.bi"
#include once "support/text.bi"
#include once "pp/pp.bi"
#include once "fb/filesystem.bi"

namespace Tko.Modules

private function NodeFor_( byref g as ModGraph, byref w as ModWhere, byval loc as Tko.SourceLoc ) as long
    for i as long = 0 to g.chains.Count - 1
        if g.chains[i] = w.chain then return i
    next
    g.chains.Push( w.chain )
    g.dirs.Push( w.dir_ )
    g.pkgNames.Push( w.pkgName )
    g.pkgRoots.Push( w.pkgRoot )
    g.firstLoc.Push( cast( ulong, loc ) )
    return g.chains.Count - 1
end function

'' THE HEADER OF ONE FILE. isRoot: scanned with the command line's defines.
private sub ScanFile_ _
    ( byref ctx as Tko.CompilerContext, byval id as Tko.FileId, byval isRoot as boolean, _
      byref pr as Tko.PpResult, byval quiet as boolean )

    dim as Tko.PpConfig cfg = Tko.Driver.MakePpConfig( ctx )
    cfg.scanHeader = true
    cfg.scanQuiet = quiet
    cfg.cmdlineIgnored = true
    dim as Tko.StrVec noDefines
    if isRoot = false then cfg.defines = @noDefines
    Tko.PpRun( ctx.sources, id, ctx.names, ctx.keywords, ctx.diags, cfg, pr )
end sub

'' Every import of one file, resolved and added as an edge from node 'from' -- or, for a
'' root file, from nowhere (from = -1): a root is never imported, so it needs no node.
private sub AddImports_ _
    ( byref ctx as Tko.CompilerContext, byref g as ModGraph, byref pr as Tko.PpResult, _
      byval from as long, byref fromDir as string, byref pkgName as string, _
      byref pkgRoot as string )

    for k as long = 0 to pr.imports.Count - 1
        dim as ModWhere w
        if ResolveImport( ctx, pr.imports[k], fromDir, pkgName, pkgRoot, w ) = false then
            continue for
        end if
        dim as long m = NodeFor_( g, w, pr.imports[k].loc )
        if from < 0 then continue for
        g.edgeFrom.Push( cast( ulong, from ) )
        g.edgeTo.Push( cast( ulong, m ) )
        g.edgeLoc.Push( cast( ulong, pr.imports[k].loc ) )
    next
end sub

private sub ExpandNode_ _
    ( byref ctx as Tko.CompilerContext, byref g as ModGraph, byval n as long, byval quiet as boolean )
    dim as string dir_ = g.dirs[n]
    dim as Tko.StrVec files
    ModuleFiles( dir_, files )
    g.fileFirst.Push( cast( ulong, g.fileIds.Count ) )
    if files.Count = 0 then
        ctx.diags.Report( Tko.TKO0147, Tko.PointRange( cast( Tko.SourceLoc, g.firstLoc[n] ) ), dir_ )
        return
    end if
    for each nm as string in files
        dim as string path_ = JoinPath( dir_, nm )
        dim as ustring why = ""
        dim as Tko.FileId id = ctx.sources.LoadFile( path_, why )
        if id = Tko.FILE_NONE then
            ctx.diags.ReportGlobal( Tko.TKO0001, path_, Tko.Text.UStringToUtf8( why ) )
            continue for
        end if
        g.fileIds.Push( cast( ulong, id ) )
        dim as Tko.PpResult pr
        ScanFile_( ctx, id, false, pr, quiet )
        '' A module file that is not one is the compile's to report when the scan is quiet.
        if (pr.isModuleFile = false) andalso (quiet = false) then
            ctx.diags.Report( Tko.TKO0145, Tko.PointRange( ctx.sources.LocFor( id, 0 ) ), path_, dir_ )
        end if
        '' Copies, not references into the arrays AddImports_ is about to grow.
        dim as string pn = g.pkgNames[n]
        dim as string pr_ = g.pkgRoots[n]
        AddImports_( ctx, g, pr, n, dir_, pn, pr_ )
    next
    g.fileCount.Push( cast( ulong, g.fileIds.Count ) - g.fileFirst[n] )
end sub

'' ------------------------------------------------------------------ cycles

private sub ReportCycle_( byref ctx as Tko.CompilerContext, byref g as ModGraph, _
                          byval fromK as long, byval closing as long )
    dim as string text_ = ""
    for k as long = fromK to g.stackNode.Count - 1
        text_ += g.chains[g.stackNode[k]] & " -> "
    next
    text_ += g.chains[g.edgeTo[closing]]
    ctx.diags.Report( Tko.TKO0141, _
        Tko.PointRange( cast( Tko.SourceLoc, g.edgeLoc[closing] ) ), text_ )
    for k as long = fromK + 1 to g.stackNode.Count - 1
        ctx.diags.AddNote( Tko.TKO0906, _
            Tko.PointRange( cast( Tko.SourceLoc, g.edgeLoc[g.stackEdge[k]] ) ) )
    next
    g.cycled = true
end sub

private sub Visit_( byref ctx as Tko.CompilerContext, byref g as ModGraph, _
                    byval n as long, byval via as long )
    g.color[n] = 1
    g.stackNode.Push( cast( ulong, n ) )
    g.stackEdge.Push( cast( ulong, iif( via < 0, 0, via ) ) )
    for e as long = 0 to g.edgeFrom.Count - 1
        if g.cycled then exit for
        if cast( long, g.edgeFrom[e] ) <> n then continue for
        dim as long m = g.edgeTo[e]
        if g.color[m] = 1 then
            dim as long fromK = 0
            for k as long = 0 to g.stackNode.Count - 1
                if cast( long, g.stackNode[k] ) = m then fromK = k
            next
            ReportCycle_( ctx, g, fromK, e )
        elseif g.color[m] = 0 then
            Visit_( ctx, g, m, e )
        end if
    next
    g.stackNode.Pop( )
    g.stackEdge.Pop( )
    g.color[n] = 2
end sub

'' ------------------------------------------------------------------- order

'' Dependencies first; among the modules that are ready, the least chain.
private sub Order_( byref g as ModGraph, byref order as Tko.IdVec )
    dim as long n = g.chains.Count
    dim as Tko.IdVec placed
    for i as long = 0 to n - 1
        placed.Push( 0 )
    next
    for round_ as long = 1 to n
        dim as long best = -1
        for i as long = 0 to n - 1
            if placed[i] <> 0 then continue for
            dim as boolean ready = true
            for e as long = 0 to g.edgeFrom.Count - 1
                if cast( long, g.edgeFrom[e] ) <> i then continue for
                if placed[g.edgeTo[e]] = 0 then ready = false : exit for
            next
            if ready = false then continue for
            if best < 0 then
                best = i
            elseif g.chains[i] < g.chains[best] then
                best = i
            end if
        next
        if best < 0 then exit for         '' only after a cycle, which is reported already
        placed[best] = 1
        order.Push( cast( ulong, best ) )
    next
end sub

function BuildGraph _
    ( byref ctx as Tko.CompilerContext, byval rootCount as long, byval quiet as boolean, _
      byref g as ModGraph ) as boolean

    if rootCount < 1 then return true
    dim as long errorsBefore = ctx.diags.ErrorCount( )

    '' The root files' package: the FIRST root file's directory (RFC-0007 §1).
    '' The roots' package: the nearest tiko.toml's, else the anonymous one (RFC-0007 §1).
    ResetPackages( ctx )
    dim as string anon, rootDir
    if RootPackage( ctx, anon, rootDir ) = false then return false
    for r as long = 1 to rootCount
        dim as Tko.FileId id = cast( Tko.FileId, r )
        dim as Tko.PpResult pr
        ScanFile_( ctx, id, true, pr, quiet )
        dim as string here = DirOfFile( ctx.sources.PathOf( id ) )
        AddImports_( ctx, g, pr, -1, here, anon, rootDir )
    next

    '' The worklist is the node list itself: expanding a node appends the new ones.
    dim as long i = 0
    while i < g.chains.Count
        ExpandNode_( ctx, g, i, quiet )
        i += 1
    wend

    for k as long = 0 to g.chains.Count - 1
        g.color.Push( 0 )
    next
    for k as long = 0 to g.chains.Count - 1
        if g.cycled then exit for
        if g.color[k] = 0 then Visit_( ctx, g, k, -1 )
    next

    if ctx.diags.ErrorCount( ) > errorsBefore then return false
    Order_( g, g.order )
    return true
end function

function PrintGraph( byref ctx as Tko.CompilerContext, byval rootCount as long ) as long
    dim as ModGraph g
    if BuildGraph( ctx, rootCount, false, g ) = false then return Tko.EXIT_USER_ERROR
    dim as Tko.IdVec order
    for each o as ulong in g.order
        order.Push( o )
    next
    dim as long width_ = 0
    for k as long = 0 to g.chains.Count - 1
        if len( g.chains[k] ) > width_ then width_ = len( g.chains[k] )
    next
    for each n as ulong in order
        dim as string ln = g.chains[n] & space( width_ - len( g.chains[n] ) + 2 ) & g.dirs[n]
        '' What it imports, by chain, sorted and once each.
        dim as Tko.StrVec deps
        for e as long = 0 to g.edgeFrom.Count - 1
            if g.edgeFrom[e] <> n then continue for
            dim as string c = g.chains[g.edgeTo[e]]
            dim as boolean seen = false
            for each d as string in deps
                if d = c then seen = true : exit for
            next
            if seen then continue for
            dim as long at = deps.Count
            deps.Push( c )
            while at > 0
                if deps[at - 1] <= c then exit while
                deps[at] = deps[at - 1]
                at -= 1
            wend
            deps[at] = c
        next
        if deps.Count > 0 then
            ln += "  ["
            for d as long = 0 to deps.Count - 1
                if d > 0 then ln += " "
                ln += deps[d]
            next
            ln += "]"
        end if
        print ln
    next
    return Tko.EXIT_OK
end function

end namespace

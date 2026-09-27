'' modgraph.bi -- the build graph: every module the inputs import, their order, and the
'' cycle report (ADR 0017; RFC-0005 §1-2). See modgraph.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"
#include once "pp/pp.bi"

namespace Tko.Modules

'' THE GRAPH, as parallel arrays: one index per module, one per edge.
type ModGraph
    as Tko.StrVec chains
    as Tko.StrVec dirs
    as Tko.StrVec pkgNames
    as Tko.StrVec pkgRoots
    as Tko.IdVec  firstLoc      '' where the module was first imported, for TKO0147
    '' Each module's files, as FileIds: fileIds[fileFirst[n] .. + fileCount[n] - 1].
    as Tko.IdVec  fileFirst
    as Tko.IdVec  fileCount
    as Tko.IdVec  fileIds
    as Tko.IdVec  edgeFrom
    as Tko.IdVec  edgeTo
    as Tko.IdVec  edgeLoc       '' the '#import', for TKO0906
    '' The depth-first search: 0 unvisited, 1 on the stack, 2 done.
    as Tko.IdVec  color
    as Tko.IdVec  stackNode
    as Tko.IdVec  stackEdge     '' the edge that reached stackNode[k]; unused for k = 0
    as boolean    cycled
    '' Dependencies first, ties by chain.
    as Tko.IdVec  order
end type

'' THE GRAPH OF THE FIRST rootCount SOURCES: every module they reach, its files loaded, the
'' cycle check, the order. quiet: the headers' own diagnostics are left to the compile.
'' False when an error was reported.
declare function BuildGraph _
    ( byref ctx as Tko.CompilerContext, byval rootCount as long, byval quiet as boolean, _
      byref g as ModGraph ) as boolean

'' '--print-graph'. Reads the header of each of the first rootCount source files and of
'' every file of every module they reach, and prints one line per module in build order:
''
''     chain  directory  [the chains it imports]
''
'' Returns the exit code; nothing is printed once an error has been reported.
declare function PrintGraph( byref ctx as Tko.CompilerContext, byval rootCount as long ) as long

end namespace

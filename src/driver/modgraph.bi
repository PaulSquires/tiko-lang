'' modgraph.bi -- the build graph: every module the inputs import, their order, and the
'' cycle report (ADR 0017; RFC-0005 §1-2). See modgraph.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.Modules

'' '--print-graph'. Reads the header of each of the first rootCount source files and of
'' every file of every module they reach, and prints one line per module in build order:
''
''     chain  directory  [the chains it imports]
''
'' Returns the exit code; nothing is printed once an error has been reported.
declare function PrintGraph( byref ctx as Tko.CompilerContext, byval rootCount as long ) as long

end namespace

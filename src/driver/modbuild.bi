'' modbuild.bi -- building the modules a program imports (ADR 0017; RFC-0005 §3). See
'' modbuild.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.Modules

'' THE MODULES THE FIRST rootCount SOURCES IMPORT, each compiled once, dependencies first,
'' into an object that joins the link. Nothing when no root imports anything. False, with
'' the reason reported, when the graph or a module failed.
declare function BuildImports _
    ( byref ctx as Tko.CompilerContext, byval rootCount as long, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec, _
      byref toolExit as long ) as boolean

end namespace

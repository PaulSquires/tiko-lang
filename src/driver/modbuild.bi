'' modbuild.bi -- building the modules a program imports (ADR 0017; RFC-0005 §3). See
'' modbuild.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.Modules

'' THE MODULES THE FIRST rootCount SOURCES IMPORT, each compiled once, dependencies first,
'' into an object that joins the link. Nothing when no root imports anything. False, with
'' the reason reported, when the graph or a module failed.
'' 'scanOnly' IS THE EDITOR SCAN (src/driver/scan.bas): each module runs the front end only,
'' publishes its interface and is harvested -- no object, and the module cache is neither
'' read nor written (nor its directory made).
declare function BuildImports _
    ( byref ctx as Tko.CompilerContext, byval rootCount as long, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec, _
      byref toolExit as long, byval scanOnly as boolean = false ) as boolean

'' WHERE A MODULE'S OBJECT GOES when the output is a static library, whose members keep
'' their names: '<chain>.o' beside the archive -- 'std.strings.o'.
declare function ArchiveMemberPath( byref ctx as Tko.CompilerContext ) as string

end namespace

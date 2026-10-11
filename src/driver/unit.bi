'' unit.bi -- compiling one translation unit: preprocess, parse, check, lower, emit. See
'' unit.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"
#include once "codegen/target.bi"
#include once "pp/pp.bi"

namespace Tko.Driver

'' ONE UNIT OF THE BUILD. Everything the per-unit pass reads or writes that outlives the
'' unit is a parameter, so the loop in Run hands over exactly what it used to share with
'' its own body:
''
''     i, srcCount          which unit, and how many there are (a '.ll' is named by both)
''     restartDepth         0 unless this pass is a '#cmdline' restart
''     wantsOutput          the run builds something, rather than dumping
''     linkObjs, tempObjs   the objects to link, and the ones this run must delete
''     toolExit             the first toolchain failure; never reset once set
''
'' RETURNS TRUE WHEN THE UNIT ASKS FOR A '#cmdline' RESTART, with the words to restart
'' with in restartArgs. The restart is Run's to perform: it is a fresh Run( ) over the
'' command line, which only Run has.
declare function CompileUnit _
    ( byref ctx as Tko.CompilerContext, byval i as long, byval srcCount as long, _
      byval restartDepth as long, byval wantsOutput as boolean, _
      byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec, _
      byref toolExit as long, byref restartArgs as Tko.StrVec ) as boolean

'' Does unit i's top-level code become 'main'? (unit.bas; the unit cache keys on it too)
declare function IsMainUnit_ _
    ( byref ctx as Tko.CompilerContext, byval id as Tko.FileId, byval i as long ) as boolean

'' ---- driver.bas's helpers that the unit pass calls too. Defined there.
declare function ModuleStem( byref path_ as string ) as string
declare function StripExt_( byref path_ as string ) as string
declare function ToolFail_ _
    ( byref ctx as Tko.CompilerContext, byval code as long, byval id as Tko.DiagId, _
      byref a0 as string = "", byref a1 as string = "", byref a2 as string = "" ) as long
declare function FrontendFailed_( byref ctx as Tko.CompilerContext ) as boolean
declare function EmitStopFile_ _
    ( byref ctx as Tko.CompilerContext, byref irText as string, _
      byref td as Tko.Codegen.TargetDescription, byval id as Tko.FileId, _
      byval i as long, byval srcCount as long ) as long
'' WAITS FOR EVERY QUEUED clang -c (driver/objqueue.bi) and returns the first failure, already
'' reported, or EXIT_OK. Called before anything reads an object.
declare function DrainObjects( byref ctx as Tko.CompilerContext ) as long

declare function BuildFromIr _
    ( byref ctx as Tko.CompilerContext, byref irText as string, _
      byref td as Tko.Codegen.TargetDescription, byref objPath as string ) as long
declare function MakePpConfig( byref ctx as Tko.CompilerContext ) as Tko.PpConfig
'' Is an fb_ name a runtime procedure -- for Check.ReportUndeclared. Defined in unit.bas.
declare function IsRtlName( byref nm as string ) as boolean

end namespace

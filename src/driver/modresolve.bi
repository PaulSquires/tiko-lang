'' modresolve.bi -- where an '#import' path leads (ADR 0017; RFC-0007 §3). See
'' modresolve.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"
#include once "pp/pp.bi"

namespace Tko.Modules

'' WHERE A MODULE IS, and what it is called. Paths are '/'-separated and LEXICAL: a path
'' the user gave relative stays relative, so what the graph prints and what a test's
'' golden holds is the same on every machine.
type ModWhere
    as string dir_       '' the module's directory
    as string chain      '' package name, then the directory path below the package root:
                         '' 'acme.net.http'. Lower case: FreeBASIC names are not cased.
    as string pkgName    '' the first chain component
    as string pkgRoot    '' the package's root directory, which relative imports stay inside
end type

'' THE PACKAGE OF THE ROOT FILES when no manifest names one (RFC-0007 §1): the first
'' root file's directory, called 'main'.
const ANON_PACKAGE = "main"

'' Lexical normalisation: '\' to '/', '.' dropped, '..' applied where it can be.
declare function NormPath( byref p as string ) as string
declare function JoinPath( byref a as string, byref b as string ) as string
declare function DirOfFile( byref p as string ) as string

'' RESOLVE ONE IMPORT, read in a file of the package pkgName rooted at pkgRoot, whose own
'' directory is fromDir. On failure the diagnostic is already reported at rec.loc.
''
'' The search, first hit wins (RFC-0007 §3; sources 2 and 3, the manifest's, are phase P8):
''   1. './' or '../': relative to fromDir, and never outside pkgRoot (TKO0142)
''   4. each -i directory, then each TKO_PATH entry, holding a directory named S
''   5. the toolchain's pkg/ directory
'' 'std' skips 4: the standard library always comes from the toolchain.
'' THE .bas FILES OF A MODULE DIRECTORY, sorted case-folded so the order is the same on
'' every host.
declare sub ModuleFiles( byref dir_ as string, byref files as Tko.StrVec )

'' WHAT A DIRECTORY GIVEN ON THE COMMAND LINE IS CALLED, for 'tiko -c <dir>' (phase P2). Under
'' a package search root, its path below that root: 'libs/acme/net/http' with '-i libs' is
'' acme.net.http. Under none, a module of the anonymous package: 'main.http'.
declare sub ChainForDir( byref ctx as Tko.CompilerContext, byref dir_ as string, byref outw as ModWhere )

declare function ResolveImport _
    ( byref ctx as Tko.CompilerContext, byref rec as Tko.PpImport, _
      byref fromDir as string, byref pkgName as string, byref pkgRoot as string, _
      byref outw as ModWhere ) as boolean

end namespace

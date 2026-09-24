'' cimportmode.bi -- the driver's C-header modes: '-cimport' and '--cimport-probe'. D16.
''
'' Both take C headers rather than FreeBASIC sources, so both run before the driver asks
'' for an input and stop when they are done.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.CImportDriver

'' Was either mode asked for?
declare function Asked( byref o as Tko.DriverOptions ) as boolean

'' Run it and return the exit code. 'clangExe' is the toolchain's clang, beside which
'' libclang is looked for.
declare function Run( byref ctx as Tko.CompilerContext, byref clangExe as string ) as long

end namespace

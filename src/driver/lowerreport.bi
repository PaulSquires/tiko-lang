'' lowerreport.bi -- the '--dump-ir' lowering report. See lowerreport.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"
#include once "mir/lower.bi"

namespace Tko.Driver

'' The summary line 'sum_', then the breakdown of what did not lower -- by node kind,
'' by what it was inside, by the lowering line that gave up. Printed only when stdout is
'' not the IR itself.
declare sub PrintLowerReport _
    ( byref ctx as Tko.CompilerContext, byref lst as Tko.Mir.LowerStats, byref sum_ as string )

end namespace

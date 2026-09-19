'' diagout.bi -- the --diagnostics-file, written.
''
'' diag/machine formats the records; this writes them, because the driver is the only
'' module that may touch the filesystem (driver.bi).
''
'' ONCE, AT THE END. Start creates the file empty and switches the engine to collecting
'' records; Finish writes header, records and the 'end' record in one go, from the pass
'' that actually returns. A '#cmdline' restart runs Start in pass one and never Finish
'' there -- pass one's diagnostics are discarded, as fbc's are -- so the file holds pass
'' two's run exactly once. A run that dies between the two leaves the EMPTY file, which a
'' reader takes as "did not finish", never the previous run's records.

#ifndef __TKO_DIAGOUT_BI__
#define __TKO_DIAGOUT_BI__

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.DiagOut

    '' True when there is no file to write or it was created. False, with TKO0117
    '' reported and the path forgotten, when it cannot be written.
    declare function Start( byref ctx as Tko.CompilerContext ) as boolean

    '' Flush the engine, write the file if one was asked for, and return rc unchanged --
    '' so every exit of Run( ) can read 'return Tko.DiagOut.Finish( ctx, code )'.
    declare function Finish( byref ctx as Tko.CompilerContext, byval rc as long ) as long

end namespace

#endif

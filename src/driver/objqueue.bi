'' objqueue.bi -- the clang -c runs a build has started and not yet waited for.
''
'' THE FRONT END DOES NOT WAIT FOR CLANG. BuildFromIr (driver.bas) writes a unit's '.ll',
'' starts clang on it and returns; the next unit's front end runs while it compiles, and up
'' to 'maxJobs' run at once. Everything that needs an object -- the link, the archive, the
'' module cache, a '#cmdline' restart -- drains the queue first (DrainObjects), and that is
'' where a failed compile is reported, with the same diagnostic and exit code as when it ran
'' inline. Measured on tiko-lang's own 123 units: see docs/tiko-speed in the workspace.
''
'' IN UNIT ORDER: each object joins the link list when its job STARTS, so the link order is
'' the order the units were compiled in, whichever clang finished first.
''
'' TKO_JOBS=1 is the old behaviour exactly: clang runs inline and nothing is queued.

#pragma once

#include once "tko.bi"
#include once "support/spawn.bi"

namespace Tko

    type ObjQueue
        as long                     maxJobs        '' 0 until the first object is built
        as containers.Array( of longint )   procs          '' 0 once waited for
        as StrVec                   irPaths, objPaths, triples
        as containers.Array( of ubyte )     wantElf
        as containers.Array( of double )    starts
        as long                     reaped         '' jobs [0, reaped) have been waited for
        as boolean                  keepTemps
    end type

end namespace

'' events.bi -- what a 'tiko build' tells its caller (tiko-build RFC-0001 §8.1).
''
'' THE OBSERVER IS HANDED TO Driver.Run as an 'any ptr', as the editor scan's result is, so
'' the driver reports what it builds without knowing who listens; 0 for a classic run, and
'' every On* below does nothing then. With '--message-format json' each event is one JSON
'' object on one line of stdout, written as it happens; in text mode nothing is printed and
'' the console is exactly a classic run's.

#pragma once

#include once "tko.bi"

namespace Tko.Build

    '' Version of the JSON stream; build-start carries it, and an editor checks it.
    const EVENT_FORMAT = 1

    type Observer
        as boolean json
        as double  t0
        as long    units          '' unit events so far
        as boolean finished       '' OnFinish ran: the driver's run reached its end
        as long    exitCode
        as long    errors
        as long    warnings
    end type

    '' 'kind' is "module" or "root"; 'status' is "hit", "miss" or "compiled" (B1 caches no
    '' root, so a root is always compiled).
    declare sub OnUnit _
        ( byval obs as any ptr, byref kind as string, byref unitName as string, byref status as string )
    '' 'kind' is "exe", "dll", "lib" or "obj"; the path as the link wrote it.
    declare sub OnArtifact( byval obs as any ptr, byref kind as string, byref path_ as string )
    '' The run's totals, from DiagOut.Finish -- once per run, the '#cmdline' restart included.
    declare sub OnFinish _
        ( byval obs as any ptr, byval errors as long, byval warnings as long, byval rc as long )

    '' A JSON string literal, quotes included: '"', '\' and control characters escaped,
    '' everything else -- UTF-8 included -- as it is.
    declare function JsonStr( byref s as string ) as string
    declare sub EmitLine( byref obs as Observer, byref body as string )

end namespace

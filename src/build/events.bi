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
        '' 'tiko metadata' (B2): what a '--print-graph' run reports instead of printing --
        '' each module once, as a JSON object, and where the last run looked for imports.
        as Tko.StrVec modChains
        as Tko.StrVec modJson
        as string     searchJson
        as string     includesJson
        as string     definesJson
    end type

    '' 'kind' is "module" or "root"; 'status' is "hit", "miss" or "compiled" (B1 caches no
    '' root, so a root is always compiled).
    declare sub OnUnit _
        ( byval obs as any ptr, byref kind as string, byref unitName as string, byref status as string )
    '' How many units the build has -- modules and roots -- once the module graph is known,
    '' before the first unit event: {"event":"plan","units":N}.
    declare sub OnPlan( byval obs as any ptr, byval units as long )
    '' 'kind' is "exe", "dll", "lib" or "obj"; the path as the link wrote it.
    declare sub OnArtifact( byval obs as any ptr, byref kind as string, byref path_ as string )
    '' The run's totals, from DiagOut.Finish -- once per run, the '#cmdline' restart included.
    declare sub OnFinish _
        ( byval obs as any ptr, byval errors as long, byval warnings as long, byval rc as long )

    '' One module of a '--print-graph' run: its chain, directory, package, files and the chains
    '' it imports. Kept once per chain, across the runs of every target.
    declare sub OnModule _
        ( byval obs as any ptr, byref chain as string, byref dir_ as string, byref pkg as string, _
          byref files as Tko.StrVec, byref imports as Tko.StrVec )
    '' ...and where that run looked: the package search roots, the toolchain's pkg/, and its
    '' include directories and '-d' defines.
    declare sub OnSearch _
        ( byval obs as any ptr, byref roots as Tko.StrVec, byref pkg as string, _
          byref includes as Tko.StrVec, byref defines as Tko.StrVec )

    '' A JSON array of strings.
    declare function JsonArr( byref v as Tko.StrVec ) as string

    '' A JSON string literal, quotes included: '"', '\' and control characters escaped,
    '' everything else -- UTF-8 included -- as it is.
    declare function JsonStr( byref s as string ) as string
    declare sub EmitLine( byref obs as Observer, byref body as string )

end namespace

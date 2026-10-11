'' unitcache.bi -- a 'tiko build' caches its classic roots too (tiko-build RFC-0001 §6; B3).
''
'' THE MODULE CACHE'S POOL AND DISCIPLINE, a different key. An entry is the module entry's
'' files with an empty interface: key.txt, obj.o, libs.txt and deps.txt, committed after the
'' objects exist. A hit links obj.o and replays libs.txt; deps.txt -- every file the unit read,
'' and every include candidate it tried and did not find -- is re-checked first, as a
'' module's is. The key is Modules.UnitKey.
''
'' ONLY UNDER 'tiko build', only when it links, and never:
''   - after a '#cmdline' restart: the first run's key would not say what the restart added;
''   - for a unit with an error or a WARNING, which a hit would not report again;
''   - for a unit that expands __DATE__, __DATE_ISO__ or __TIME__ (B0: a hit would print the
''     first build's clock);
''   - under --no-module-cache, which 'tiko build --no-cache' passes.
'' A classic 'tiko a.bas b.bas' caches nothing, as before.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.UnitCache

    type Store
        as string     root       '' the pool; "" when this run caches no unit
        as string     args       '' the key's 'args' line
        as Tko.StrVec keys
        as Tko.StrVec chains
        as Tko.StrVec objs
        as Tko.StrVec libs
        as Tko.StrVec deps
    end type

    '' What the run held before a unit compiled, so After( ) can say what it added.
    type Mark
        as long libs0
        as long paths0
        as long files0
        as long objs0
        as long errs0
        as long warns0
    end type

    '' 'eligible': the run links (no -c, no IR or assembly stop, no dump, no scan).
    declare sub Open _
        ( byref ctx as Tko.CompilerContext, byref args as Tko.StrVec, byval restartDepth as long, _
          byval eligible as boolean, byref s as Store )
    '' Unit i from the cache: its object joins the link and its libraries are replayed.
    '' 'key' is set either way ("" when the unit is not cached at all).
    declare function TryHit _
        ( byref ctx as Tko.CompilerContext, byref s as Store, byval i as long, byref key as string, _
          byref linkObjs as Tko.StrVec, byref tempObjs as Tko.StrVec ) as boolean
    declare sub Before( byref ctx as Tko.CompilerContext, byref linkObjs as Tko.StrVec, byref m as Mark )
    '' After unit i compiled: remembered for Commit when it may be stored. Returns the unit
    '' event's status -- "miss" when the cache is on, "compiled" when it is not.
    declare function After _
        ( byref ctx as Tko.CompilerContext, byref s as Store, byval i as long, byref key as string, _
          byref m as Mark, byref linkObjs as Tko.StrVec ) as string
    '' Once the objects exist and before the link deletes them.
    declare sub Commit( byref ctx as Tko.CompilerContext, byref s as Store )

end namespace

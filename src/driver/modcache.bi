'' modcache.bi -- the module build cache (ADR 0017; RFC-0005 §4). See modcache.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.Modules

'' WHERE ENTRIES LIVE: TKO_MODCACHE, else '.tiko/cache' beside the nearest tiko.toml at or
'' above the first root's directory, else beside the first root. "" under
'' --no-module-cache, and when the directory cannot be made (TKO0150, and the build goes on
'' uncached).
declare function ModuleCacheRoot( byref ctx as Tko.CompilerContext ) as string

'' THE KEY of module n of the build (ctx.ifaceChains[n]), whose dependencies' interfaces are
'' already in ctx.ifaceTexts. One line per item.
declare function ModuleKey( byref ctx as Tko.CompilerContext, byval n as long ) as string

'' A HIT: the entry exists, its key is this one, and every file it records is as it was.
'' objPath, the interface text and the libraries are the entry's.
declare function ModuleCacheLookup _
    ( byref ctx as Tko.CompilerContext, byref root as string, byref key as string, _
      byref objPath as string, byref iface as string, byref libs as string ) as boolean

'' Store what a compile of the module just made. A failure to store is not an error.
declare sub ModuleCacheStore _
    ( byref ctx as Tko.CompilerContext, byref root as string, byref key as string, _
      byref objPath as string, byref iface as string, byref libs as string )

'' '-v': why a miss missed -- the first line of this key that the chain's last stored key
'' did not have, or 'new'.
declare function MissReason _
    ( byref root as string, byref chain as string, byref key as string ) as string

end namespace

'' modcache.bi -- the module build cache (ADR 0017; RFC-0005 §4). See modcache.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.Modules

'' WHERE ENTRIES LIVE: TKO_MODCACHE, else ONE POOL FOR EVERY PROJECT in the user's cache
'' directory, <LOCALAPPDATA>/tiko/modcache or <XDG_CACHE_HOME|~/.cache>/tiko/modcache. ""
'' under --no-module-cache, and when there is none or it cannot be made (TKO0150, and the
'' build goes on uncached).
declare function ModuleCacheRoot( byref ctx as Tko.CompilerContext ) as string

'' '--clean-module-cache': every entry of the pool removed, and a line saying how many.
declare function CleanModuleCache( byref ctx as Tko.CompilerContext ) as string

'' THE KEY of module n of the build (ctx.ifaceChains[n]), whose dependencies' interfaces are
'' already in ctx.ifaceTexts. One line per item.
declare function ModuleKey( byref ctx as Tko.CompilerContext, byval n as long ) as string
'' ...and a classic ROOT's, for 'tiko build' (tiko-build RFC-0001 §6.1; unitcache.bas).
'' 'args' is the command line less its inputs and what cannot reach an object.
declare function UnitKey _
    ( byref ctx as Tko.CompilerContext, byval id as Tko.FileId, byval isMain as boolean, _
      byval first as boolean, byref args as string ) as string

'' A HIT: the entry exists, its key is this one, and every file it records is as it was.
'' objPath, the interface text and the libraries are the entry's.
declare function ModuleCacheLookup _
    ( byref ctx as Tko.CompilerContext, byref root as string, byref key as string, _
      byref objPath as string, byref iface as string, byref libs as string ) as boolean

'' Store what a compile of the module just made, in TWO STEPS: what the unit read is taken
'' from the context straight after its compile (ModuleCacheDeps; false = a dependency has no
'' stamp, store nothing), and the entry is written once its object exists -- after the object
'' queue drains (driver/objqueue.bi), when the context already describes a later module.
'' A failure to store is not an error.
declare function ModuleCacheDeps( byref ctx as Tko.CompilerContext, byref dl as string ) as boolean
declare sub ModuleCacheCommit _
    ( byref root as string, byref key as string, byref chain as string, _
      byref objPath as string, byref iface as string, byref libs as string, byref dl as string )

'' '-v': why a miss missed -- the first line of this key that the chain's last stored key
'' did not have, or 'new'.
declare function MissReason _
    ( byref root as string, byref chain as string, byref key as string ) as string

end namespace

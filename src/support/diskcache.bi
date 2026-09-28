'' diskcache.bi -- what an on-disk cache is built from: a 64-bit FNV, a file's stamp, and
'' the write-then-rename commit. Shared by the #cinclude cache (driver/cicache.bas) and the
'' module cache (driver/modcache.bas). See diskcache.bas.

#pragma once

#include once "tko.bi"

namespace Tko.DiskCache

'' FNV-1a, 64 bits, as sixteen lower-case hex digits.
declare function Hash( byref s as string ) as string

'' The file's size and modification time, TAB-separated. "" when it is not a file.
declare function Stamp( byref path_ as string ) as string

'' The whole file. False when it cannot be opened.
declare function ReadAll( byref path_ as string, byref text as string ) as boolean

'' Write under a temporary name, then move it over the real one. 'serial' tells apart the
'' temporaries of one commit made in the same microsecond.
declare function Commit( byref path_ as string, byref text as string, byval serial as long ) as boolean

'' <the user's cache directory>/tiko/<leaf>: %LOCALAPPDATA% on Windows, $XDG_CACHE_HOME or
'' ~/.cache elsewhere. "" when the environment names none.
declare function UserCacheDir( byref leaf as string ) as string

end namespace

'' manifest.bi -- a package's tiko.toml (ADR 0017; RFC-0007 §2). See manifest.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"

namespace Tko.Modules

type Manifest
    as string  dir_          '' the directory holding tiko.toml
    as string  name          '' [package] name, lower case
    '' [dependencies] x = { path = "..." }: the key, and the path resolved against dir_.
    as StrVec  depNames
    as StrVec  depPaths
    '' [defines], as NAME=value, the form '-d' takes.
    as StrVec  defines
    '' [dependencies.x.defines]: honoured only in the root's manifest. ddDep[k] is x.
    as StrVec  ddDep
    as StrVec  ddDefine
end type

'' READ dir_/tiko.toml. False with the reason reported (TKO0144) when it is not the subset
'' RFC-0007 §2 allows; when the file is not there, false and nothing reported -- ask
'' HasManifest first.
declare function HasManifest( byref dir_ as string ) as boolean
declare function LoadManifest _
    ( byref ctx as Tko.CompilerContext, byref dir_ as string, byref m as Manifest ) as boolean

end namespace

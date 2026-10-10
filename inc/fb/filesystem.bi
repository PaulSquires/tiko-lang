'' fb/filesystem.bi -- the modern filesystem module, in one include
''
'' Specified in C:\dev\docs\filesystem\. Mirrors inc/containers.bi: this file is an
'' umbrella and contains no declarations of its own.
''
'' Everything lives in NAMESPACE FB and nothing is added to the global
'' namespace, so a program that already defines its own PathJoin, FsError or
'' Stat is unaffected. Write `using FB` to drop the qualification.
''
'' NOTHING HERE REPLACES ANYTHING. inc/file.bi, inc/dir.bi and the legacy Dir,
'' FileExists, FileLen, FileCopy, Kill, Name, MkDir and RmDir are untouched and
'' undeprecated; a program using them compiles and behaves exactly as before.
'' The only new consequence is that a better option now sits next to them.
''
'' ALL SEVEN PHASES EXIST TODAY, RFC-0001 through RFC-0009.

#pragma once

#if __FB_LANG__ <> "fb"
	#error "fb/filesystem.bi requires -lang fb (it uses namespaces)"
#endif

'' Phase 1 -- RFC-0001, RFC-0002
#include once "fb/fserror.bi"
#include once "fb/fspath.bi"

'' Phase 2 -- RFC-0003, RFC-0004
#include once "fb/fsinfo.bi"
#include once "fb/fsdir.bi"

'' Phase 3 -- RFC-0005
#include once "fb/fsops.bi"

'' Phase 4 -- RFC-0006
#include once "fb/fsglob.bi"

'' Phase 5 -- RFC-0007
#include once "fb/fslink.bi"

'' Phase 6 -- RFC-0008
#include once "fb/fsvolume.bi"

'' Phase 7 -- RFC-0009
#include once "fb/fsadvanced.bi"

'' fbx.bi -- common definitions shared by every fbx module.
''
'' This is the only header every translation unit includes. Keep it small: version
'' identity, exit codes, and the handful of scalar typedefs the whole compiler agrees on.
'' Anything with behaviour belongs in its own subsystem header.

#ifndef __FBX_BI__
#define __FBX_BI__

#include once "crt.bi"

'' fb/array.bi, NOT containers.bi. containers.bi pulls in fb/hash.bi, whose HashOf
'' overloads are not PRIVATE, so including it from more than one module of a
'' multi-module program produces duplicate symbols at link time. fbx only needs
'' Array today; when Map/Set are wanted, hash.bi has to be included from exactly one
'' module (or fixed upstream). Recorded in docs/internals/known-toolchain-issues.md.
#include once "fb/array.bi"

namespace Fbx

    '' ---------------------------------------------------------------- identity

    const FBX_VERSION_MAJOR  as long = 0
    const FBX_VERSION_MINOR  as long = 1
    const FBX_VERSION_PATCH  as long = 0
    const FBX_VERSION_SUFFIX as string = "-dev"

    '' The fbc release whose language and runtime ABI fbx targets. Reported as
    '' __FB_VERSION__ so existing '#if __FB_VERSION__ >= ...' guards keep working;
    '' fbx's own identity is __FBX_VERSION__. See docs/plan/03 section 6.3.
    const FBX_FBC_COMPAT as string = "1.20.0"

    '' --------------------------------------------------------------- exit codes
    '' docs/plan/12 section 3. Code 4 is reserved for internal compiler errors so
    '' CI can treat an ICE as a P0 regardless of test outcome.

    enum ExitCode
        EXIT_OK          = 0
        EXIT_USER_ERROR  = 1
        EXIT_CMDLINE     = 2
        EXIT_NO_TOOLCHAIN= 3
        EXIT_ICE         = 4
        EXIT_TOOL_FAILED = 5
    end enum

    '' -------------------------------------------------------------- scalar ids
    '' Handles, not pointers. 0 always means "none" so a zeroed record is empty.

    type InternId as ulong
    type FileId   as ulong

    const INTERN_NONE as InternId = 0
    const FILE_NONE   as FileId   = 0

    '' Byte buffers are the substrate for source text, emitted output and arena
    '' storage. Aliased here because a generic cannot be instantiated directly in a
    '' TYPE field -- it has to go through a concrete alias first.
    type ByteBuf as FB.Array( of ubyte )

    '' Lives here rather than in driver/options.bi because the preprocessor needs it
    '' and may not depend on the driver.
    type StrVec as FB.Array( of string )

end namespace

#endif

'' dump.bi -- the textual form of MIR, which is a TEST SURFACE rather than a
'' debugging convenience (docs/plan/13): the golden tests assert on this text.

#ifndef __FBX_MIR_DUMP_BI__
#define __FBX_MIR_DUMP_BI__

#include once "mir/mir.bi"

namespace Fbx.Mir
    declare function DumpModule _
        ( byref m as MirModule, byref names as Fbx.Interner ) as string
end namespace

#endif

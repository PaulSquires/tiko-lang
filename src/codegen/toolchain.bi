'' toolchain.bi -- running clang and the linker.
''
'' docs/plan/10 section 5. tiko-lang emits textual LLVM IR and hands it to a real clang;
'' this is the only file that knows how either external tool is spelled.
''
'' WHY AN EXTERNAL CLANG AT ALL is decision D1: emitting IR and shelling out costs a
'' process per translation unit and buys a code generator, an optimiser and every
'' target LLVM supports, none of which this project could write. The cost is that the
'' toolchain must be FOUND, and that a missing one is a diagnostic rather than a crash.

#ifndef __TKO_TOOLCHAIN_BI__
#define __TKO_TOOLCHAIN_BI__

#include once "tko.bi"
#include once "codegen/target.bi"

namespace Tko.Codegen

    type ToolPaths
        as string clangExe
        '' Where libfb lives, IN SEARCH ORDER. A list, not one path: a runtime may be
        '' partial and resolve the rest from one behind it.
        as FB.Array( of string ) libPaths
        as boolean found
        as string why              '' when found is false
    end type

    '' In order: an explicit option, the environment, then the conventional places.
    '' docs/plan/12 section 4 gives the same order for every external tool, so that
    '' one override works the same way everywhere.
    declare function FindTools _
        ( byref clangOpt as string, byref libOpt as FB.Array( of string ) ) as ToolPaths

    '' '.ll' to '.o'. Returns the process exit code; 0 is success.
    declare function CompileIr _
        ( byref t as ToolPaths, byref target as TargetDescription, _
          byref irPath as string, byref objPath as string, _
          byval keepTemps as boolean ) as long

    '' ObjectS to an executable -- plural, and it always was in this comment.
    '' It took ONE path until 2026-09-04, which is why a program could never be
    '' built from more than one module.
    declare function LinkExe _
        ( byref t as ToolPaths, byref target as TargetDescription, _
          byref objs as Tko.StrVec, byref outPath as string ) as long

end namespace

#endif

'' target.bi -- what the backend needs to know about the machine it is emitting for.
''
'' docs/plan/10 section 3: the frontend already carries a TargetLayout -- the sizes and
'' alignments it may not hard-code -- and this is the rest of it, the part only a code
'' generator asks for. The layout is EMBEDDED rather than duplicated: two records of
'' target facts would be two chances to disagree about the width of a pointer.
''
'' Nothing here is a guess. The datalayout string is what clang itself prints for the
'' target (clang -S -emit-llvm on an empty file), not a transcription, because a
'' datalayout that disagrees with the one clang -c assumes is a silent miscompile
'' rather than an error.

#ifndef __TKO_TARGET_BI__
#define __TKO_TARGET_BI__

#include once "tko.bi"
#include once "types/type.bi"
#include once "mir/mir.bi"   '' for the calling-convention constants

namespace Tko.Codegen

    '' How the object file is put together, which decides the linker and the name
    '' mangling that wraps whatever the frontend already did.
    enum ObjFormat
        OBJ_COFF = 0        '' Windows
        OBJ_ELF             '' Linux
    end enum

    '' Which classifier the ABI pass runs. They are genuinely different algorithms, not
    '' two parameter sets of one -- Win64 classifies by SIZE alone and SysV by walking
    '' an aggregate's fields into eight-byte classes -- so this selects code rather
    '' than data.
    enum AbiKind
        ABI_WIN64 = 0
        ABI_SYSV_AMD64
    end enum

    type TargetDescription
        as TargetId     id
        as string       triple
        as string       dataLayout
        as ObjFormat    objFormat
        as AbiKind      abi
        as TargetLayout layout
        '' The convention a procedure gets when the source names none. All three
        '' collapse on x86-64; win32 is where this stops being cosmetic.
        as ubyte        defaultCallConv
    end type

    declare function TargetFor( byval t as TargetId ) as TargetDescription

end namespace

#endif

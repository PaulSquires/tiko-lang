'' target.bas -- one record per target, and nothing computed from another.

#include once "codegen/target.bi"

namespace Tko.Codegen

'' THE DATALAYOUT STRINGS ARE CLANG'S OWN, read out of it rather than transcribed:
''
''     clang -S -emit-llvm -O0 empty.c -o -
''
'' A datalayout that disagrees with the one 'clang -c' assumes does not fail; it
'' silently lays a structure out differently on the two sides of the object file. So
'' the string is evidence, and it is refreshed the same way if a clang version ever
'' changes it.
''
'' Windows 64 and Windows 32 share nothing here -- 'm:w' is the mangling for both, but
'' the pointer sizes and stack alignment differ -- so each is written out in full.
const DL_WIN64 as string = _
    "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
const DL_WIN32 as string = _
    "e-m:x-p:32:32-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:32-n8:16:32-a:0:32-S32"
const DL_LINUX64 as string = _
    "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"

'' WINDOWS IS THE MinGW ABI, not the Microsoft one. D13 as originally written said the
'' opposite -- the runtime was to be recompiled with clang for
'' 'x86_64-pc-windows-msvc' and the gnu triple was never to be passed. That premise
'' does not hold against either runtime that exists, which was measured:
''
''   fbc's C libfb   fb_config.h identifies Windows ONLY through __MINGW32__ or
''                   __CYGWIN__. Under the msvc triple clang defines neither, so every
''                   file stops at the first header with "Couldn't identify target
''                   system!". Forcing the MinGW branch moves it to _ssize_t -- 21
''                   errors in one small file, before the 72 win32-specific sources.
''
''   tiko-rt         the FreeBASIC reimplementation. Its win64 archive imports
''                   __mingw_sprintf and __iob_func, and it is built to drop into
''                   fbc's own link line. Linking it under the msvc triple against
''                   libcmt fails on exactly those symbols.
''
'' So the msvc triple produced objects that could not link against anything. Amended on
'' the author's decision, with the measurements above as the evidence.
''
'' THE TRIPLE IS UNVERSIONED and clang -c warns about it either way -- measured:
''
''     warning: overriding the module target triple with
''              x86_64-pc-windows-msvc19.44.35222 [-Woverride-module]
''
'' It warned whether the triple was written out or LEFT OUT ALTOGETHER, because what
'' clang compares against carries the installed toolchain's version and nothing
'' tiko-lang writes ever will. The driver passes '-Wno-override-module' and also passes
'' '-target' explicitly, so the module's own triple line and the compilation agree by
'' construction rather than by assumption.
function TargetFor( byval t as TargetId ) as TargetDescription
    dim as TargetDescription d
    d.id = t
    d.layout = TargetLayoutFor( t )
    d.defaultCallConv = Tko.Mir.TKO_CC_CDECL
    select case t
    case TARGET_WIN32
        d.triple = "i686-w64-windows-gnu"
        d.dataLayout = DL_WIN32
        d.objFormat = OBJ_COFF
        '' x86-32 has no register classifier worth the name; the ABI pass's win32 half
        '' is stack rules and the stdcall/pascal distinction that x86-64 collapses.
        d.abi = ABI_WIN64
        '' STDCALL IS THE DEFAULT ON WIN32 for anything fbc declares itself, and that
        '' is a real difference rather than a spelling: it decides who pops the stack.
        d.defaultCallConv = Tko.Mir.TKO_CC_STDCALL
    case TARGET_LINUX_X86_64
        d.triple = "x86_64-pc-linux-gnu"
        d.dataLayout = DL_LINUX64
        d.objFormat = OBJ_ELF
        d.abi = ABI_SYSV_AMD64
    case else                   '' TARGET_WIN64
        d.triple = "x86_64-w64-windows-gnu"
        d.dataLayout = DL_WIN64
        d.objFormat = OBJ_COFF
        d.abi = ABI_WIN64
    end select
    return d
end function

end namespace

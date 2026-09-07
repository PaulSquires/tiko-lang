'' toolchain.bas -- see the header.

#include once "codegen/toolchain.bi"

namespace Tko.Codegen

private function FileExists_( byref p as string ) as boolean
    if len( p ) = 0 then return false
    dim as long fh = freefile
    if open( p for input as #fh ) <> 0 then return false
    close #fh
    return true
end function

function FindTools _
    ( byref clangOpt as string, byref libOpt as FB.Array( of string ) ) as ToolPaths

    dim as ToolPaths t
    t.found = false

    '' 1. THE EXPLICIT OPTION always wins, and it is not second-guessed: someone who
    ''    passes a path has a reason, and silently searching past a wrong one hides it.
    if len( clangOpt ) > 0 then
        t.clangExe = clangOpt
    else
        '' 2. The environment.
        t.clangExe = environ( "TKO_CLANG" )
        if len( t.clangExe ) = 0 then
            '' 3. The conventional install. NOT a PATH search: on Windows 'clang' on
            ''    PATH is as often a stale one from another toolchain as the intended
            ''    one, and a backend that silently used a DIFFERENT clang than the
            ''    datalayout was measured against is the failure this whole file exists
            ''    to avoid. An explicit path or the environment says which.
            t.clangExe = "C:\Program Files\LLVM\bin\clang.exe"
        end if
    end if
    if FileExists_( t.clangExe ) = false then
        t.why = "clang not found at '" & t.clangExe & "'" & _
                " -- set TKO_CLANG to the clang to use"
        return t
    end if

    '' The search order arrives already decided: the -p paths the user typed, then
    '' the bundled <exe-dir>/lib/<target> and its '-fb' backing directory, or
    '' TKO_LIBPATH in place of those. Cmdline settles all of it -- see
    '' AppendDefaultLibDir -- because only there is the target final, and because
    '' TKO_LIBPATH read HERE could only ever have been reached when no -p was given,
    '' which a bundled default would have made impossible.
    for i as long = 0 to libOpt.Count - 1
        t.libPaths.Push( libOpt[i] )
    next
    t.found = true
    return t
end function

'' A path with spaces in it needs quoting, and on Windows most of them have spaces.
private function Q( byref s as string ) as string
    return """" & s & """"
end function

function CompileIr _
    ( byref t as ToolPaths, byref target as TargetDescription, _
      byref irPath as string, byref objPath as string, _
      byval keepTemps as boolean ) as long

    '' '-target' IS PASSED EXPLICITLY, always.
    ''
    '' docs/plan/11 D13 says clang's own default triple is the right one and the flag
    '' must not be passed. That was written when the runtime was to be rebuilt for
    '' 'x86_64-pc-windows-msvc'; the runtimes that actually exist -- fbc's libfb and
    '' tiko-rt both -- are MinGW-ABI on Windows, so the triple is a real choice again.
    '' Passing it makes the module's own 'target triple' line and the compilation agree
    '' BY CONSTRUCTION rather than by assumption, whichever way that choice lands.
    ''
    '' '-Wno-override-module': clang warns that it is overriding the module's triple
    '' whenever the version suffixes differ, which they always do -- measured, and it
    '' warns even when the .ll names no triple at all. The warning is about the suffix,
    '' not about the target.
    dim as string cmd = _
        "-target " & target.triple & " -Wno-override-module -c " & _
        Q( irPath ) & " -o " & Q( objPath )
    dim as long rc = exec( t.clangExe, cmd )
    if keepTemps = false then
        if rc = 0 then kill( irPath )
    end if
    return rc
end function

function LinkExe _
    ( byref t as ToolPaths, byref target as TargetDescription, _
      byref objs as Tko.StrVec, byref outPath as string ) as long

    '' THE LINK LINE IS THE RUNTIME'S, not this compiler's invention. tiko-rt is built
    '' to drop into fbc's link line, and on Windows it needs the printer and GDI import
    '' libraries explicitly: its file layer references fb_DevLptOpen, which pulls
    '' io_printer, which imports from winspool and gdi32. The C runtime gets away
    '' without them because nothing references that entry point unless a program opens
    '' a file -- so this is not optional and not symmetrical.
    '' EVERY OBJECT, IN THE ORDER GIVEN. Order is not cosmetic to a linker: an
    '' archive is searched once, at the point it appears, so a module naming a symbol
    '' has to come before whatever resolves it.
    dim as string cmd = "-target " & target.triple
    for i as long = 0 to objs.Count - 1
        cmd += " " & Q( objs[i] )
    next
    cmd += " -o " & Q( outPath )
    '' EVERY LIBRARY PATH, IN THE ORDER GIVEN, and each one's libfb named as a FILE
    '' rather than found with '-lfb'.
    ''
    '' '-L a -L b -lfb' does not do what it looks like: a single '-l' resolves ONCE,
    '' from the first path that has the archive, and never consults the second. That is
    '' fine for a complete runtime and wrong for a partial one -- tiko-rt is partial
    '' today, its thread_sched references fb_AtomicCasLong, and only fbc's libfb defines
    '' it. Naming both archives in order is what actually puts one behind the other.
    ''
    '' The '-L' entries are still emitted, because the CRT support libraries
    '' (-lmingw32, -lmingwex) have to come from the same place as crt2.o.
    for i as long = 0 to t.libPaths.Count - 1
        cmd += " -L" & Q( t.libPaths[i] )
    next
    '' EACH ONE ONLY IF IT IS THERE. A '-p' path need not carry the runtime:
    '' lib/gfx/lib/<target> holds libtkogfx.a and nothing else, and naming a
    '' libfb.a that does not exist fails the link with clang's own 'no such file
    '' or directory' before it has looked at a single object.
    '' THE USER'S LIBRARIES FIRST, ahead of the runtime. Measured: fbc emits
    '' '-lzzz -lfb ...' for both '#inclib "zzz"' and '-l zzz', never the reverse.
    '' The order is not cosmetic -- a user library calls INTO libfb, and an archive
    '' is searched once, at the point it appears, so a runtime placed before it
    '' cannot satisfy what it turns out to need.
    ''
    '' NAMED WITH -l AND NOT AS A FILE, unlike the runtime archives below. The
    '' runtime is named by path because two directories hold a libfb.a and both are
    '' wanted; a user library has one spelling, and letting the search path find it
    '' is also what lets '-l m' reach a system library that is in none of these
    '' directories.
    '' AND THE MSVC TARGET NEEDS HELP FINDING THEM, which is measured and is not
    '' something fbc can answer -- fbc is a MinGW toolchain and has only ever had one
    '' convention. The two Windows targets do not agree on what '-l greet' means:
    ''
    ''     win64        -lgreet  ->  libgreet.a     found
    ''     win64-msvc   -lgreet  ->  greet.lib      LNK1181, cannot open input file
    ''
    '' A FreeBASIC library is called libgreet.a. Since win64-msvc became the default
    '' target, taking '-l' at face value there would have made every FB-named library
    '' -- including every one tiko itself produces -- unfindable by the name the
    '' source uses. So on that target the FB-conventional name is looked for in the
    '' search paths and named as a FILE when it is there. The archive format is the
    '' same either way; only the lookup differs, which is why this works at all.
    ''
    '' NOT DONE ON THE OTHER TARGETS, deliberately. MinGW ld and ELF ld already find
    '' lib<name>.a from -l, and they consider more than that: on Linux a -p directory
    '' holding both libfoo.so and libfoo.a should yield the SHARED one, and resolving
    '' to a file here would quietly pick the static.
    for i as long = 0 to t.libs.Count - 1
        dim as string named = ""
        if target.id = TARGET_WIN64_MSVC then
            for k as long = 0 to t.libPaths.Count - 1
                dim as string cand = t.libPaths[k] & "/lib" & t.libs[i] & ".a"
                if FileExists_( cand ) then
                    named = cand
                    exit for
                end if
            next
        end if
        '' Nothing found means it is not ours to resolve: a system library lives in
        '' none of these directories, and '-l' is what reaches it.
        if len( named ) > 0 then
            cmd += " " & Q( named )
        else
            cmd += " -l" & t.libs[i]
        end if
    next

    for i as long = 0 to t.libPaths.Count - 1
        dim as string rtLib = t.libPaths[i] & "/libfb.a"
        if FileExists_( rtLib ) then cmd += " " & Q( rtLib )
    next

    '' AND libtkogfx.a WHERE ONE EXISTS, named the same way and for the same
    '' reason: '-ltkogfx' resolves once, from the first path that has it.
    ''
    '' IT IS OPTIONAL, and silently so. A program that never writes SCREEN or
    '' PSET emits no fb_Gfx* call and needs no graphics archive, which is the
    '' common case; naming a file that is not there would fail every one of
    '' those links. A program that DOES use graphics and has no archive gets
    '' the linker's own message naming the symbol -- 'unresolved external
    '' symbol fb_GfxScreen' -- which says more than anything this could.
    ''
    '' AFTER libfb.a, because libtkogfx calls INTO the runtime -- it shares
    '' __fb_ctx and calls fb_End -- and an archive is searched once, where it
    '' appears.
    for i as long = 0 to t.libPaths.Count - 1
        dim as string gfxLib = t.libPaths[i] & "/libtkogfx.a"
        if FileExists_( gfxLib ) then cmd += " " & Q( gfxLib )
    next

    '' THE SYSTEM LIBRARIES THE RUNTIME REACHES INTO, and they are not the same set on
    '' the two platforms. Neither list is guessable; each was found by linking and
    '' reading what was still undefined.
    if target.id = TARGET_WIN64_MSVC then
        '' THE MICROSOFT ABI. Not a variant of the MinGW branch below -- it shares none
        '' of it. There is no crt2.o to point '-B' at, because the UCRT supplies the
        '' startup; clang's own msvc driver finds it.
        ''
        '' -llegacy_stdio_definitions IS NOT OPTIONAL. The UCRT does not EXPORT
        '' sprintf: it is inline in <stdio.h>, so a caller that is not a C translation
        '' unit cannot link it. Measured; docs/tiko-rt RFC-0006 section 12.
        ''
        '' /INCLUDE:tkort_msvc_init_ IS NOT OPTIONAL EITHER, and for a subtler reason.
        '' An archive member is extracted only when it RESOLVES AN UNDEFINED SYMBOL,
        '' and nothing references a CRT initialiser -- the CRT walks a section, it does
        '' not call a name. So tiko-rt's msvcinit.o sits in the archive and is never
        '' linked: measured, the locale stays "C" and UCASE leaves every accented
        '' character alone. Naming it is the supported way to pull one in.
        ''
        '' THE IMPORT LIBRARIES ARE THE SAME SET THE MinGW BRANCH NEEDS, plus ws2_32:
        '' getaddrinfo and friends resolve under MSVC only when it is on the line, and
        '' that is a link-library question rather than an ABI one.
        cmd += " -llegacy_stdio_definitions"
        cmd += " -lwinspool -lgdi32 -luser32 -ladvapi32 -lwinmm -lmsimg32 -lversion -limm32 -lws2_32"
        cmd += " -Xlinker /INCLUDE:tkort_msvc_init_"
    elseif target.objFormat = OBJ_COFF then
        '' THE C RUNTIME MUST COME FROM THE SAME TOOLCHAIN AS libfb, and that is not
        '' clang's default sysroot. fbc's crt2.o is built SJLJ (winlibs64-sjlj-9.3.0);
        '' the MinGW clang finds on its own is SEH, and mixing them leaves
        '' '__mingw_init_ehandler' and '__security_init_cookie' undefined. '-B' points
        '' clang's file search at the directory holding crt2.o, crtbegin.o and crtend.o.
        ''
        '' LINUX MUST NOT GET THIS. There the system's own crt1.o and libc are the right
        '' ones, and pointing '-B' at a directory of FreeBASIC archives only hides them.
        for i as long = 0 to t.libPaths.Count - 1
            cmd += " -B" & Q( t.libPaths[i] )
        next
        '' The printer and GDI imports: tiko-rt's file layer references fb_DevLptOpen,
        '' which pulls io_printer, which imports from winspool and gdi32. The C runtime
        '' gets away without them because nothing reaches that entry point unless a
        '' program opens a file.
        cmd += " -lwinspool -lgdi32"
    else
        '' ELF. '-ltinfo' is the counterpart of the pair above: the runtime's console
        '' layer calls tgoto and tputs, which live in terminfo. '-lm' and '-lpthread'
        '' are the ordinary companions of a runtime that does arithmetic and threads.
        cmd += " -lm -lpthread -ltinfo"
    end if
    return exec( t.clangExe, cmd )
end function

end namespace

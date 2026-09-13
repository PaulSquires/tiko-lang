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
            ''    On Linux the conventional install is the distribution's, which is
            ''    where Ubuntu's clang-18 package puts it; the Windows path is what a
            ''    Linux build used to look for, and every link failed.
            #ifdef __FB_WIN32__
                t.clangExe = "C:\Program Files\LLVM\bin\clang.exe"
            #else
                t.clangExe = "/usr/bin/clang"
            #endif
        end if
    end if
    '' llvm-ar FROM CLANG'S OWN DIRECTORY. Derived rather than searched: the two
    '' ship together, and an 'ar' found on PATH would as often be some other
    '' toolchain's.
    dim as long cut_ = 0
    for i as long = len( t.clangExe ) to 1 step -1
        dim as string ch = mid( t.clangExe, i, 1 )
        if (ch = "/") orelse (ch = "\") then
            cut_ = i
            exit for
        end if
    next
    dim as string arName = "llvm-ar"
    dim as string rcName = "llvm-rc"
    #ifdef __FB_WIN32__
        arName += ".exe"
        rcName += ".exe"
    #endif
    t.arExe = left( t.clangExe, cut_ ) & arName
    t.rcExe = left( t.clangExe, cut_ ) & rcName

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

'' A '.rc' TO A '.res', which lld-link consumes directly -- no separate cvtres
'' step and no object in between. fbc goes the other way, asking GoRC for a COFF
'' object; the outcome is the same .rsrc section.
''
'' '-fo' AND NOT '/fo'. llvm-rc accepts both, and the dash form is the one that
'' survives being pasted into a shell: MSYS rewrote '/fo' into a path and llvm-rc
'' then complained that exactly one input file should be provided, naming neither.
function CompileRc _
    ( byref t as ToolPaths, byref rcPath as string, _
      byref resPath as string ) as long

    if FileExists_( t.rcExe ) = false then return -1
    return exec( t.rcExe, "-fo " & Q( resPath ) & " " & Q( rcPath ) )
end function

'' 'rcs': replace members, create the archive, write an index. The index is what
'' lets a linker resolve out of it without reading every member, and an archive
'' without one links only by accident of member order.
function ArchiveLib _
    ( byref t as ToolPaths, byref objs as Tko.StrVec, _
      byref outPath as string ) as long

    if FileExists_( t.arExe ) = false then return -1
    '' The archive is REPLACED, not added to. 'rcs' updates members in place, so a
    '' stale one from a previous build with a name no longer produced would survive
    '' and keep resolving symbols the sources no longer define.
    kill( outPath )
    dim as string cmd = "rcs " & Q( outPath )
    for i as long = 0 to objs.Count - 1
        cmd += " " & Q( objs[i] )
    next
    return exec( t.arExe, cmd )
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
    if (t.optLevel > 0) andalso (t.optLevel <= 3) then cmd += " -O" & t.optLevel
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
    '' LLD, NOT WHATEVER THE MACHINE HAS. clang picks a linker by looking at the
    '' host: for the msvc triple it finds Visual Studio's link.exe, and for the gnu
    '' one an ld.exe off PATH -- measured, it was reaching C:\dev\utils\mingw64.
    '' Both are external installs that vary per machine, and neither is the one this
    '' compiler's behaviour was measured against. lld ships inside the LLVM install
    '' tiko already requires for clang, so naming it removes a dependency rather
    '' than adding one.
    ''
    '' MEASURED EQUIVALENT, 2026-09-06: the same hello world links and runs under
    '' both, on both Windows targets. lld's msvc output is 2.5% larger (168,448
    '' against 164,352) and its gnu output smaller (681,472 against 731,044).
    ''
    '' THIS DOES NOT MAKE win64-msvc SELF-CONTAINED. clang still adds
    '' '-defaultlib:libcmt' and '-defaultlib:oldnames', and libcmt.lib,
    '' vcruntime.lib and oldnames.lib come from Visual Studio. Linking msvcrt.dll
    '' instead -- we ship an import library for it -- is a decision about which CRT
    '' the runtime uses, not a flag.
    dim as string cmd = "-target " & target.triple & " -fuse-ld=lld"
    '' ...WHERE THERE IS ONE. Ubuntu's clang package does not carry lld, and on such a
    '' host every link died with clang's 'invalid linker name in argument
    '' -fuse-ld=lld'. Beside clang or on the system path it is used; otherwise clang
    '' links with the platform's own ld. ELF records no link time either way.
    #ifndef __FB_WIN32__
        dim as long sl = instrrev( t.clangExe, "/" )
        if (FileExists_( left( t.clangExe, sl ) & "ld.lld" ) = false) andalso _
           (FileExists_( "/usr/bin/ld.lld" ) = false) then
            cmd = "-target " & target.triple
        end if
    #endif

    '' A REPRODUCIBLE LINK. lld writes the wall clock into the COFF header's TimeDateStamp,
    '' and that was the ONLY difference left between stage3 and stage4 of the bootstrap:
    '' four bytes at offset 128, with every other byte of 4,178,432 identical. The MinGW
    '' driver takes --no-insert-timestamp and writes zero; lld-link takes /Brepro and
    '' writes a hash of the image instead. ELF carries no link time at all.
    if target.id = TARGET_WIN64_MSVC then
        cmd += " -Xlinker /Brepro"
    elseif target.objFormat = OBJ_COFF then
        cmd += " -Wl,--no-insert-timestamp"
    end if

    '' A DLL, AND ITS IMPORT LIBRARY. Spelled through -Xlinker rather than with
    '' clang's own -shared, because the import library has no clang spelling and
    '' both halves belong together.
    ''
    '' THE DASH FORMS, not /DLL and /IMPLIB. lld-link accepts either; the dash ones
    '' survive being written down and pasted into a shell, where a leading slash is
    '' rewritten into a path by MSYS -- which turned '/DLL' into 'C:/Program
    '' Files/Git/DLL' while this was being measured. tiko execs clang directly and
    '' is not subject to that, but the reproduction in a bug report would be.
    if t.buildDll then
        cmd += " -Xlinker -dll"
        if len( t.implibPath ) > 0 then
            cmd += " -Xlinker -implib:" & t.implibPath
        end if
    end if

    '' STRIP, WHICH fbc DOES AND THIS DID NOT. Read out of fbc.bas and then
    '' measured: '-s' is on the link line by default and absent under '-g'.
    '' It is worth more here than there, because tiko links a runtime whose C
    '' members and CRT carry line tables: a hello world on the gnu target was
    '' 731,044 bytes and is 163,840 stripped, .debug_info alone accounting for
    '' 311 KB of it.
    ''
    '' NOT ON THE MSVC TARGET. '-s' is a gnu-linker flag, and MSVC keeps debug data
    '' in a separate PDB rather than in the image -- stripping the msvc output
    '' changes nothing, measured.
    if (target.id <> TARGET_WIN64_MSVC) andalso t.stripSymbols then
        cmd += " -s"
    end if
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
    '' The '#foreignlib' bindings first: they named an exact file, so there is
    '' nothing to resolve and no reason to let a search path answer differently.
    for i as long = 0 to t.libFiles.Count - 1
        cmd += " " & Q( t.libFiles[i] )
    next

    for i as long = 0 to t.libs.Count - 1
        dim as string named = ""
        '' TWO SPELLINGS, AND THE IMPORT LIBRARY WINS -- which is GNU ld's order and
        '' was measured, not assumed: with libfblib.dll.a and libfblib.a both in one
        '' directory, 'fbc -l fblib' produced a program that RAN, so it took the
        '' import library. Had it taken the empty static one the link would have
        '' failed on the undefined symbol.
        ''
        '' lib<name>.dll.a IS WHAT fbc's OWN -dll PRODUCES, so a tiko program calling
        '' an fbc-built DLL finds it by the name the source uses. Without this the
        '' link asked lld-link for '<name>.lib' and stopped there.
        if target.id = TARGET_WIN64_MSVC then
            for k as long = 0 to t.libPaths.Count - 1
                dim as string dllImp = t.libPaths[k] & "/lib" & t.libs[i] & ".dll.a"
                dim as string statLib = t.libPaths[k] & "/lib" & t.libs[i] & ".a"
                if FileExists_( dllImp ) then
                    named = dllImp
                    exit for
                elseif FileExists_( statLib ) then
                    named = statLib
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

    '' THE RUNTIME, AND WHICH ONE. '-mt' picks libfbmt.a over libfb.a, which is
    '' fbc's rule -- measured, its link line carries -lfbmt in place of -lfb and
    '' never both. Both archives are built for every target and both have always
    '' been packaged; until now nothing named the second, so '-mt' quietly linked
    '' the single-threaded runtime and a threaded program got whichever behaviour
    '' that happened to give.
    dim as string rtName = iif( t.threadSafe, "/libfbmt.a", "/libfb.a" )
    for i as long = 0 to t.libPaths.Count - 1
        dim as string rtLib = t.libPaths[i] & rtName
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
        '' -llegacy_stdio_definitions IS NOT PASSED, and this comment used to say it was
        '' "NOT OPTIONAL" -- true when it was written and false by the time anyone read
        '' it. The reason it was needed still holds: the UCRT does not EXPORT sprintf,
        '' which is inline in <stdio.h>, so a caller that is not a C translation unit
        '' cannot link it (docs/tiko-rt RFC-0006 section 12). What changed is WHO
        '' supplies it -- tiko-rt's own src/c/msvccrt.c does, along with fprintf,
        '' snprintf and vsprintf, so linking the library as well is a DUPLICATE SYMBOL:
        '' 'sprintf already defined in libfbmt.a(msvccrt.o)'. That is not theoretical;
        '' it is what the msvc gate hit when it followed this comment instead of the
        '' code below it.
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
        '' NO VISUAL STUDIO. '-nostdlib' turns off clang's own defaults --
        '' '-defaultlib:libcmt' and '-defaultlib:oldnames' -- and with them the only
        '' reason this target reached into an installed Visual Studio. Measured
        '' 2026-09-06: libcmt.lib, libvcruntime.lib, oldnames.lib and
        '' legacy_stdio_definitions.lib come from VC Tools and nowhere else, and
        '' Microsoft's own redistributable set carries runtime DLLs and no static
        '' libraries at all.
        ''
        '' WHAT REPLACES IT IS ucrtbase.dll, a Windows system component present on
        '' every Windows 10 and later, reached through the import library we generate
        '' ourselves (build/mkmsvcimplibs.sh). It exports 2,650 symbols -- every mem*
        '' and str* routine, fileno, the whole stdio core -- and the six it does not
        '' export are tiko-rt's own src/c/msvccrt.c: mainCRTStartup, _fltused, atexit,
        '' sprintf, time/localtime and __chkstk.
        ''
        '' MEASURED: a hello world links and runs at 20,480 bytes against fbc's
        '' 48,640, needing only ucrtbase.dll and KERNEL32.dll, and PRINT USING
        '' matches fbc byte for byte.
        '' kernel32 IS NAMED EXPLICITLY, and it was not before: clang's own defaults
        '' brought it in, and '-nostdlib' drops those too. The first build without it
        '' failed on Sleep, CreateSemaphoreA and CloseHandle from tiko-rt's thread
        '' and timing layers.
        cmd += " -nostdlib -lucrtbase -lkernel32"
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

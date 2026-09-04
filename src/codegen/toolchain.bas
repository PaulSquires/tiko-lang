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

    if libOpt.Count > 0 then
        for i as long = 0 to libOpt.Count - 1
            t.libPaths.Push( libOpt[i] )
        next
    else
        dim as string envp = environ( "TKO_LIBPATH" )
        if len( envp ) > 0 then t.libPaths.Push( envp )
    end if
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
      byref objPath as string, byref outPath as string ) as long

    '' THE LINK LINE IS THE RUNTIME'S, not this compiler's invention. tiko-rt is built
    '' to drop into fbc's link line, and on Windows it needs the printer and GDI import
    '' libraries explicitly: its file layer references fb_DevLptOpen, which pulls
    '' io_printer, which imports from winspool and gdi32. The C runtime gets away
    '' without them because nothing references that entry point unless a program opens
    '' a file -- so this is not optional and not symmetrical.
    dim as string cmd = "-target " & target.triple & " " & Q( objPath ) & _
                        " -o " & Q( outPath )
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
    for i as long = 0 to t.libPaths.Count - 1
        cmd += " " & Q( t.libPaths[i] & "/libfb.a" )
    next

    '' THE SYSTEM LIBRARIES THE RUNTIME REACHES INTO, and they are not the same set on
    '' the two platforms. Neither list is guessable; each was found by linking and
    '' reading what was still undefined.
    if target.objFormat = OBJ_COFF then
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

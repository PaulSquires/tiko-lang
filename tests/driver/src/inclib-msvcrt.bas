'' '#inclib "msvcrt"' IS crt.bi's REQUEST FOR THE C RUNTIME, and on windows-x86_64 the C
'' runtime is ucrtbase.dll, which every link on that target already names. Written out
'' here rather than by including crt.bi, so the test does not depend on the toolchain's
'' headers.
''
'' Passed on to the linker it failed two ways, depending on the machine:
''   - WITH Visual Studio installed, clang's msvc driver searches VC's library path
''     before any -L, found VC's static msvcrt.lib (startup objects), and the link
''     failed: duplicate __chkstk, _fltused and atexit against tiko-rt's msvccrt.o.
''   - WITHOUT it, our own import library answered and the program imported the C
''     library from msvcrt.dll AND ucrtbase.dll -- two heaps in one process.
'' The test asserts the import table, so it means the same thing on both machines.
#inclib "msvcrt"

declare function strlen cdecl alias "strlen" ( byval s as const zstring ptr ) as uinteger

print strlen( "abcd" )

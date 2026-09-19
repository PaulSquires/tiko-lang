[Home](Home) › [Programmer's Guide](Category-Programmer-s-Guide) › **Shared Libraries - DOS**

# Shared Libraries - DOS

A shared library is compiled code that can be loaded and used later when running an executable.

Description

DOS supports shared libraries (dynamic link libraries) with some limitations compared to Linux and Windows. The DOS target uses the `dxe3gen` utility from DJ's GNU Programming Platform (DJGPP) for creating a DXE file (shared library).

Supported

- shared library file names have `.DXE` file name extension
- [`DyLibLoad`](Dylibload), [`DyLibSymbol`](Dylibsymbol), and [`DyLibFree`](Dylibfree) for dynamic loading
- import libraries can be used (but see below in Limitations)
- [`#inclib`](Inclib) and [`Declare`](Declare) for declaring subs and functions when using import libraries.

Limitations

- no global variables shared between DXE's (extern / common shared, etc)
  no gfx functions allowed in DXE's (dylibload() will fail)  
  no static libraries allowed in DXE's (dylibload() will fail)  
  full file name with `.DXE` must be used with [`DyLibLoad`](Dylibload)  
  DXE's must only use procedures available in libfb or the library source code itself, otherwise dylibload() will fail (even though compilation of the DXE will have succeeded)  
  no complex [`Type`](Type-Udt)'s or types with [`Extends`](Extends). Types having member procedures can not be exported  
  [`Export`](Export) is allowed but also ignored; all public procedures are exported  
  Exported symbols on DOS have the underscore ( `'_'` ) and is required with [`DyLibSymbol`](Dylibsymbol).  
  Mutli-threaded build of the fb runtime not exported and is likely not to work (more testing needed at the time of this writing).

DXE3GEN

`dxe3gen` is a utility which allows you to create files which contain dynamically loadable code (DXE). DXE is used as a synonym for \`dynamically loadable executable module'. See [dxe3gen](http://www.delorie.com/djgpp/doc/utils/utils_19.html).

 `dxe3gen` expects that `DXE_LD_LIBRARY_PATH` to be set. If the environment variable is not already set, fbc will set the variable to fbc's library path before invoking `dxe3gen`.

 In fbc standalone set-up, custom linker script `dxe.ld` is expected to be present in fbc's library path since `dxe3gen` will invoke `'ld'` linker to generate and executable, which in turn is converted to a `.DXE` file.

Shared Library Using Run-time Dynamic Loading

In this first example, we use `d1.bas` source for the DXE and `m1.bas` for the test. This example will also work on Linux and Windows with no changes, however, differences are noted in the example sources.

 `$ fbc d1.bas`, on DOS, will produce `d1.dxe` dynamic link library and `libd1_il.a` import library.  
 `$ fbc m1.bas`, on DOS, will produce `m1.exe` executable.

 Library loading and function pointer loading is handled manually by the user at run-time.

```freebasic
'' d1.bas - dynamic link library

'' tell fbc to build a dynamic link library

#cmdline "-dll"

'' on DOS:

''   - creates d1.dxe (dynamic link library)

''   - creates libd1_il.a (import library)

'' on Windows:

''   - creates d1.dll (dynamic link library)

''   - creates libd1.dll.a (import library)

''   - either d1.dll or libd1.dll.a must be found to link an

''     executable using d1.dll

''   - d1.dll must be found to load and run an executable

''     using d1.dll

'' on Linux:

''   - creates libd1.so (dynamic link library)

''   - libd1.so must be found to load and run an executable

''     using libd1.do

''   - $ LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./executable

Sub proc_d1( ByRef fromproc As Const String ) Export

    Print __FILE__ & " : " & __FUNCTION__ & " @ " & _

        Hex(ProcPtr(proc_d1),SizeOf(Any Ptr)*2) & _

        " called from: " & fromproc

End Sub
```

```freebasic
'' m1.bas - dynamically load "D1" library and symbol "PROC_D1" at run time

''

'' library loading and symbol pointers are managed

'' manually by the user.

#define NULL 0

'' variable to hold a handle to the loaded dynamic link libray

Dim library As Any Ptr

'' prototype the function pointer

Type PROC_D1_PTR As Sub( ByRef from As Const String )

'' variable to hold a pointer to the sub/function in the dll

Dim proc_d1 As PROC_D1_PTR

'' some differences in naming between DOS and other targets,

'' so assign the names to some constants so the build process

'' can work on DOS and other targets:

#ifdef __FB_DOS__

    Const D1_DLL_NAME = "d1.dxe"

    Const PROC_D1_NAME = "_PROC_D1"

#else

    Const D1_DLL_NAME = "d1"

    Const PROC_D1_NAME = "PROC_D1"

#endif

'' try to load in the libray

library = DyLibLoad( D1_DLL_NAME )

If( library = NULL ) Then

    Print "unable to load library " + D1_DLL_NAME

    End 1

End If

'' get a function pointer to the procedure defined in the DXE

proc_d1 = DyLibSymbol( library, PROC_D1_NAME )

If( proc_d1 = NULL ) Then

    Print "unable to load symbol " + PROC_D1_NAME

    End 1

End If

'' call the loaded procedure

proc_d1( __FILE__ & " : " & __FUNCTION__ )

'' release the library

DyLibFree( library )
```

Shared Library Using Import Library

In this example, we use `d1.bas` source (from above) for the DXE and `m2.bas` below for the test. This example will also work on Linux and Windows with no changes, however, differences are noted in the example sources.

 `$ fbc d1.bas` (from above), on DOS, will produce `d1.dxe` dynamic link library and `libd1_il.a` import library.  
 `$ fbc m2.bas`, on DOS, will produce `m2.exe` executable.

 Library loading and function exports are handled automatically by the executable loader and run time start up code. The include file `d1.bi` is not strictly needed, however is good practice to have a single place where functions are declared so there are no mismatches between usage across multiple modules.

```freebasic
'' d1.bi - include file for d1.bas declarations

#pragma Once

Declare Sub proc_d1( ByRef from As Const String )
```

```freebasic
'' m2.bas - link to import library

'' use an import library for d1.dxe/d1.dll/d1.so

''

'' library loading and symbol pointers are managed

'' automatically by the operating system and/or

'' runtime start-up code.

'' import libraries are named differently on

'' DOS compared to other targets.  Or in case of

'' at least win/linux not actually needed.  On DOS

'' #inclib will cause linker to look for libd1_il.a

'' when linking this executable.  The import library includes

'' some start-up code to export functions from the dynamic

'' link library when it is loaded at runtime.

#ifdef __FB_DOS__

    #inclib "d1_il"

#else

    #inclib "d1"

#endif

'' include declarations for the library from a header

#include Once "d1.bi"

'' call the function in the DLL

proc_d1( __FILE__ & " : " & __FUNCTION__ )

#ifdef __FB_DOS__

'' add a module constructor to initialize the exports from

'' rtlib at run time.  Should be the first call made.

'' Careful: module constructor order is not guaranteed so

'' this is likely the only constructor that can be present

'' in the entire application, aside from the implicit

'' constructors in the DXE file that initialize it's exports.

''

Private Sub __fb_init_libfb_dxe Constructor

    DyLibLoad( "" )

End Sub

#endif
```

Version

- some support since fbc 1.06.0 with improved support in fbc 1.10.0

See also

- [Shared Libraries](Shared-Libraries)
- [`#inclib`](Inclib)
- [`#include`](procedures-Include)
- [Compiler Option: -dll](Compiler-Option-Dll)
- [Compiler Option: -dylib](Compiler-Option-Dylib)

---

**Category:** [Programmer's Guide](Category-Programmer-s-Guide)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

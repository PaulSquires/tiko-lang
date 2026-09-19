[Home](Home) › [Tutorials](Category-Tutorials) › **Shared Libraries**

# Shared Libraries

A shared library is compiled code that can be loaded and used later when running an executable.

 When the compiler makes an executable, the basic source files are first turned in to object files. The object files are then linked together to make an executable. A shared library is much like a static library in that it contains object files. But a shared library is also like an executable in that it only gets loaded when the executable is running.

 The library is referred to as shared, because the code in the library is loaded by an executable at runtime and can be loaded by more than one executable, even though there might only be one copy of the shared library.

 Once the library is made, we can then use the code that it contains just as if we were compiling the source directly with our program.

 **Shared Library Example**
 **Using Shared Libraries on Windows**
 **Using Shared Libraries on Linux**
 Using Shared Libraries on DOS => see its own page:**[Shared Libraries - DOS](Shared-Libraries-Dos)**
 **Executables that export symbols**
 **Loading Shared Libraries Dynamically**
 **Exchanging/Sharing variables with shared library on Windows**
 **Creating import Libraries from def files, or import libraries or def files from DLL files, on Windows**

Shared Library Example

Following is a simple example of creating a shared library using these three files:

Our library will be a single module providing a single function:

```freebasic
'' mylib.bas

'' compile with: fbc -dll mylib.bas

'' Add two numbers together and return the result

Public Function Add2( ByVal x As Integer, ByVal y As Integer ) As Integer Export

  Return( x + y )

End Function
```

 Compile the library with:

`fbc -dll mylib.bas`

The `-dll` option tells the compiler to take the source code, `mylib.bas`, and turn it in to an object file `mylib.o`, then store the object file in to a shared library. The name of the shared library will have a `.so` extension or `.dll` extension depending on if the platform is the linux or windows version. A library might contain many modules (source files) each with many functions, but for this simple example, it is just one each.

 Making a shared library is almost identical to making a static library except for the addition of [`Export`](Export) specifier at first line of procedure definition. `Export` tells the compiler to make the function visible to other executables loading the shared library.

To make use of the library in some other source code, we need some way of telling the compiler what exactly is in the library. A good way to do this is to put the declarations ( also called an interface, or API ) for the library in to a header file:

```freebasic
'' mylib.bi

#inclib "mylib"

Declare Function Add2( ByVal x As Integer, ByVal y As Integer ) As Integer
```

 There is no need to compile the header. We want this in its source form so it can be included with other source files. The [`#inclib`](Inclib) statement will tell the compiler the name of a shared library that we need to link with at runtime running an executable that needs it.

With our library (.dll / .so file) and a header (.bi file) we can try them out in a test program:

```freebasic
'' mytest.bas

'' compile with: fbc mytest.bas

#include Once "mylib.bi"

Print Add2(1,2)
```

 The [`#include`](procedures-Include) statement tells the compiler to include the source code from `mylib.bi` just as if we had typed it in to the original source. With the way we have written our include file, it tells the compiler everything it needs to know about the library.

 We compile this with:

`fbc mytest.bas`

Then when we run the `mytest` executable, we should get the result of:

```freebasic
 3

```

More than one source module can be used when making a library. And basic programs can use more than one library by including each needed header. Some libraries are so large that they might use several headers. On very large projects, making shared libraries out of some code modules that seldom change can improve compile times and link times dramatically.

 Shared libraries can optionally contain debugging information specified with the *[-g](Compiler-Option-G)* command line option.

 A shared library can optionally have module constructors, a main code, and module destructors. The module constructors, then the main code are executed at library load. The module destructors are executed at library unload.

 Object files, and therefore shared libraries, are platform specific and in some cases specific to a particular version of the compiler and FreeBASIC runtime library.

Using Shared Libraries on Windows

On Windows, the shared library must be stored in a location where it can be found by the executable that needs it a run-time.

 The operating system may search the following directories:

The order in which directories are searched may depend on the Windows version in use, and on what settings that the operating system is configured with.

Using Shared Libraries on Linux

By default, Linux will not normally search the current directory or the directory from which the executable was loaded. You will need to either:

To run the executable `./mytest/` and temporarily tell linux to search the current directory, use the following shell command:

```freebasic
LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./mytest
```

Executables that export symbols

If an executable has symbols that must be available to other shared libraries when those shared libraries are loaded, use the [`Export`](Export) export specifier at first line of procedure definition, and the *[-export](Compiler-Option-Export)* command line option when making (linking) the executable.

 The *[-export](Compiler-Option-Export)* option has no extra effect when used with the *[-dylib](Compiler-Option-Dylib)* or *[-dll](Compiler-Option-Dll)* command line options.

Loading Shared Libraries Dynamically

Shared libraries can be loaded and used at run time by dynamically loading the library and its symbols at runtime.

Procedures in the shared library must use the [`Export`](Export) specifier at first line of procedure definition to ensure that the symbols name is placed in the shared library's export table:

```freebasic
'' mydll.bas

'' compile as: fbc -dll mydll.bas

'' This will create mydll.dll (and libmydll.dll.a import library) on Windows,

'' and libmydll.so on Linux.

''

'' Note: libmydll.dll.a is an import library, it's only needed when creating

'' an executable that calls any of mydll's functions, only distribute

'' the DLL files with your apps, do not include the import libraries,

'' they are useless to end-users.

'' Simple exported function; the <alias "..."> disables FB's default

'' all-upper-case name mangling, so the DLL will export AddNumbers() instead of

'' ADDNUMBERS().

Function AddNumbers Alias "AddNumbers"( ByVal a As Integer, ByVal b As Integer ) As Integer Export

    Function = a + b

End Function
```

```freebasic
'' load.bas: Loads mydll.dll (or libmydll.so) at runtime, calls one of mydll's

'' functions and prints the result. mydll is not needed at compile time.

'' compile as: fbc test.bas

''

'' Note: The compiled mydll.dll (or libmydll.so) dynamic library is expected

'' to be available in the current directory.

'' Note we specify just "mydll" as library file name; this is to ensure

'' compatibility between Windows and Linux, where a dynamic library

'' has different file name and extension.

Dim As Any Ptr libhandle = DyLibLoad( "mydll" )

If( libhandle = 0 ) Then

    Print "Failed to load the mydll dynamic library, aborting program..."

    End 1

End If

'' This function pointer will be used to call the function from mydll, after

'' the address has been found. Note: It must have the same calling

'' convention and parameters.

Dim AddNumbers As Function( ByVal As Integer, ByVal As Integer ) As Integer

AddNumbers = DyLibSymbol( libhandle, "AddNumbers" )

If( AddNumbers = 0 ) Then

    Print "Could not retrieve the AddNumbers() function's address from the mydll library, aborting program..."

    End 1

End If

Randomize Timer

Dim As Integer x = Rnd * 10

Dim As Integer y = Rnd * 10

Print x; " +"; y; " ="; AddNumbers( x, y )

'' Done with the library; the OS will automatically unload libraries loaded

'' by a process when it terminates, but we can also force unloading during

'' our program execution to save resources; this is what the next line does.

'' Remember that once you unload a previously loaded library, all the symbols

'' you got from it via dylibsymbol will become invalid, and accessing them

'' will cause the application to crash.

DyLibFree( libhandle )
```

Exchanging/Sharing variables with shared library on Windows

Windows does not support the [`Common`](Common) or [`Extern`](Extern) keywords for directly sharing variables with a shared library.  
 Otherwise (running on any platform), passing a parameter (by value or by reference) to a library procedure or returning a variable (by value or by reference) from a library function allows to indirectly exchange data (by value) or share data (by reference) with a shared library.

 Example of workaround on Windows for sharing data (by reference) between main and dll code (works on any platform):  
 (dll loadable statically or dynamically as desired)

```freebasic
' dllShareData.bas to be compile with -dll

' Sharing data between main and dll code

' 'Alias' clause (in addition to 'Export') allows compatibility with dll loaded statically or dynamically

' share main variable

Dim Shared ByRef As Integer Idll = *CPtr(Integer Ptr, 0)

Sub passIntByRef Alias"passIntByRef"(ByRef i As Integer) Export

    Print "   dll code receives by reference main integer"

    @Idll = @i

End Sub

Sub printIdll Alias"printIdll"() Export

    Print "   dll code prints its own reference"

    Print "   " & Idll

End Sub

Sub incrementIdll Alias"incrementIdll"() Export

    Idll += 1

End Sub

' share dll variable

Dim Shared As Integer Jdll = 5

Function returnIntByRef Alias"returnIntByRef"() ByRef As Integer Export

    Print "   dll code returns by reference dll integer"

    Return Jdll

End Function

Sub printJdll Alias"printJdll"() Export

    Print "   dll code prints its dll integer"

    Print "   " & Jdll

End Sub

Sub incrementJdll Alias"incrementJdll"() Export

    Jdll +=1

End Sub
```

```freebasic
' mainShareData.bas

' Sharing data between main and dll code

' 'Alias' clause allows compatibility with dll loaded statically or dynamically

' dll loaded statically

    #inclib "dllShareData"

    Declare Sub passIntByRef Alias"passIntByRef"(ByRef i As Integer)

    Declare Function returnIntByRef Alias"returnIntByRef"() ByRef  As Integer

    Declare Sub printIdll Alias"printIdll"()

    Declare Sub printJdll Alias"printJdll"()

    Declare Sub incrementIdll Alias"incrementIdll"()

    Declare Sub incrementJdll Alias"incrementJdll"()

 ' or dll loaded dynamically

    'Dim As Any Ptr libhandle = DyLibLoad("dllShareData")

    'Dim As Sub(Byref i As Integer) passIntByRef = DyLibSymbol(libhandle, "passIntByRef")

    'Dim As Function() Byref  As Integer returnIntByRef = DyLibSymbol(libhandle, "returnIntByRef")

    'Dim As Sub() printIdll = DyLibSymbol(libhandle, "printIdll")

    'Dim As Sub() printJdll = DyLibSymbol(libhandle, "printJdll")

    'Dim As Sub() incrementIdll = DyLibSymbol(libhandle, "incrementIdll")

    'Dim As Sub() incrementJdll = DyLibSymbol(libhandle, "incrementJdll")

' share main variable

Dim Shared As Integer Imain = 1

Print "main code passes by reference main integer to dll code"

passIntByref(Imain)

Print "main code requests dll code to print its own reference"

printIdll()

Print "main code increments its main integer value"

Imain += 1

Print "main code requests dll code to print its own reference"

printIdll()

Print "main code requests dll to increments its own reference"

incrementIdll()

Print "main code prints its main integer"

Print "" & Imain

Print

' share dll variable

Dim Shared ByRef As Integer Jdll = *CPtr(Integer Ptr, 0)

Print "main code requests by reference dll integer from dll code"

Dim As Integer Ptr pJdll = @(returnIntByRef())

Print "main code receives by reference dll integer"

@Jdll = pJdll

Print "main code prints its own reference"

Print "" & Jdll

Print "main code requests dll to increment its dll integer value"

incrementJdll()

Print "main code prints its own reference"

Print "" & Jdll

Print "main code increments its own reference"

Jdll += 1

Print "main code requests dll code to print its dll integer"

printJdll()

Print

' for dll loaded dynamically

    'DyLibFree(libhandle)

Sleep
```

Simpler example of workaround on Windows for sharing data (by a single static function returning by reference) between main and dll code (works on any platform):  
 (dll loadable statically or dynamically as desired)

```freebasic
' dllShareData2.bas to be compile with -dll

' Sharing data between main and dll code by using static funtion returning by reference

' 'Alias' clause (in addition to 'Export') allows compatibility with dll loaded statically or dynamically

Function returnIntByRef Alias"returnIntByRef"() ByRef As Integer Export

    Static As Integer Jdll = 1

    Return Jdll

End Function

Sub printJdll Alias"printJdll"() Export

    Print "   dll code prints the reference"

    Print "   " & returnIntByRef()

End Sub

Sub incrementJdll Alias"incrementJdll"() Export

    returnIntByRef() +=1

End Sub
```

```freebasic
' mainShareData2.bas

' Sharing data between main and dll code by using static funtion returning by reference

' 'Alias' clause allows compatibility with dll loaded statically or dynamically

' dll loaded statically

    #inclib "dllShareData2"

    Declare Function returnIntByRef Alias"returnIntByRef"() ByRef  As Integer

    Declare Sub printJdll Alias"printJdll"()

    Declare Sub incrementJdll Alias"incrementJdll"()

 ' or dll loaded dynamically

    'Dim As Any Ptr libhandle = DyLibLoad("dllShareData2")

    'Dim As Function() Byref As Integer returnIntByRef = DyLibSymbol(libhandle, "returnIntByRef")

    'Dim As Sub() printJdll = DyLibSymbol(libhandle, "printJdll")

    'Dim As Sub() incrementJdll = DyLibSymbol(libhandle, "incrementJdll")

Print "main code requests dll code to print the reference"

printJdll()

Print "main code prints the reference"

Print "" & returnIntByRef()

Print

Print "main code requests dll to increment the reference"

incrementJdll()

Print "main code requests dll code to print the reference"

printJdll()

Print "main code prints the reference"

Print "" & returnIntByRef()

Print

Print "main code increments the reference"

returnIntByRef() += 1

Print "main code prints the reference"

Print "" & returnIntByRef()

Print "main code requests dll code to print the reference"

printJdll()

Print

' for dll loaded dynamically

    'DyLibFree(libhandle)

Sleep
```

**Note:**

If the shared variable (by reference) is a pointer to any structure (memory buffer, type instance, etc.) then this structure is itself also shared with the library (passing the pointer by reference even allows a dynamic reallocation of the structure).

Creating import Libraries from def files, or import libraries or def files from DLL files, on Windows

When using a third-party dll in FreeBASIC on Windows, it may be necessary to manually build an import library or a def file to satisfy the linker.

 Syntax to create the import library file `(*.dll.a)` for Windows, from the def file `(*.def)` of an existing DLL `(*.dll)`:

**-** 32-bit:

`drive:\FreeBASIC\bin\win32\dlltool.exe -d XXX.def -l libXXX.dll.a`

**-** 64-bit:

`drive:\FreeBASIC\bin\win64\dlltool.exe -m i386:x86-64 --as-flags --64 -d XXX.def -l libXXX.dll.a`

Syntax to create the import library file `(*.dll.a)` for Windows, directly from an existing DLL `(*.dll)`:

**-** 32-bit:

`drive:\FreeBASIC\bin\win32\dlltool -k -d XXX.dll -l libXXX.dll.a`

**-** 64-bit:

`drive:\FreeBASIC\bin\win64\dlltool -k -d XXX.dll -l libXXX.dll.a`

Syntax to create the def file `(*.def)` for Windows, from an existing DLL `(*.dll)`:

**-** 32-bit:

`drive:\FreeBASIC\bin\win32\dlltool --dllname XXX.dll --output-def XXX.def`

**-** 64-bit:

`drive:\FreeBASIC\bin\win64\dlltool --dllname XXX.dll --output-def XXX.def`

or using -D and -z:

**-** 32-bit:

`drive:\FreeBASIC\bin\win32\dlltool -D XXX.dll -z XXX.def`

**-** 64-bit:

`drive:\FreeBASIC\bin\win64\dlltool -D XXX.dll -z XXX.def`

with:

`drive:\FreeBASIC\`

FreeBASIC installation path

`XXX`

name of the lib and def file

See also

- [Shared Libraries - DOS](Shared-Libraries-Dos)
- [Static Libraries](Static-Libraries)
- [`#inclib`](Inclib)
- [`#include`](procedures-Include)
- [Compiler Option: -dll](Compiler-Option-Dll)
- [Compiler Option: -export](Compiler-Option-Export)
- [Compiler Option: -dylib](Compiler-Option-Dylib)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

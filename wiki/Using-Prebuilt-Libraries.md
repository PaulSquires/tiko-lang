[Home](Home) › [Tutorials](Category-Tutorials) › **Using Prebuilt Libraries**

# Using Prebuilt Libraries

FreeBASIC is distributed with many headers for common or popular libraries. The headers allow a programmer to use functions available in these existing static or shared libraries (DLLs).

 The libraries themselves are not distributed with FreeBASIC, but most can be downloaded from the web and readily installed. Some other libraries may need to be first compiled from sources to be used. Please see the documentation for the specific library on how to configure, install, and use them.  
 Note that the system architecture of the library has to match the architecture of the application. For example, to successfully use a library in a x86 (32-bit) application, a x86 (32-bit) library is required.

 Some static or shared libraries (DLLs) may be already present on the system since they might be part of FreeBASIC itself or the operating system.

 Although many headers can be used on any of the platforms supported by FreeBASIC, some headers are platform specific and will not be usable on other platforms.

FreeBASIC headers

There are a few headers that are specific to FreeBASIC and expose some functions that are otherwise not available:

- `inc/fbc-int/array.bi` - Declaration for [`Fbarray (Array Descriptor Structure And Access)`](Fbarray-Array-Descriptor-Structure-and-Access), [`Arraylen`](Arraylen), [`Arraysize`](Arraysize).
  `inc/datetime.bi` - Declarations for [`DateSerial`](Dateserial), [`DateValue`](Datevalue), [`IsDate`](Isdate), [`Year`](Year), [`Month`](Month), [`Day`](Day), [`Weekday`](Weekday), [`TimeSerial`](Timeserial), [`TimeValue`](Timevalue), [`Hour`](Hour), [`Minute`](Minute), [`Second`](Second), [`Now`](Now), [`DateAdd`](Dateadd), [`DatePart`](Datepart), [`DateDiff`](Datediff), [`MonthName`](Monthname), [`WeekdayName`](Weekdayname).  
  `inc/dir.bi` - Constants to be used with [`Dir`](Dir).  
  `inc/fbgfx.bi` - Additional constants and structures to be used with graphics commands such as [`MultiKey`](Multikey), [`ScreenControl`](Screencontrol), and [`ScreenEvent`](Screenevent), [`ImageCreate`](Imagecreate).  
  `inc/fbio.bi` - Declaration for [`IsRedirected`](Isredirected).  
  `inc/fblimits.bi` - Constants for minimum and maximum values of built-in number.  
  `inc/fbprng.bi` - Constants to be used with [`Randomize`](Randomize), and also unfinished structures for other random number generators.  
  `inc/fbthread.bi` - Declaration for [`ThreadDetach`](Threaddetach) and [`ThreadSelf`](Threadself).  
  `inc/file.bi` - Declarations for [`FileCopy`](Filecopy), [`FileAttr`](Fileattr), [`FileLen`](Filelen), [`FileExists`](Fileexists), [`FileDateTime`](Filedatetime).  
  `inc/fbc-int/symbol.bi` - Declaration for [`__Fb_Query_Symbol__`](Fb-Query-Symbol) and its associated sub-macros.  
  `inc/crt/string.bi` - Declarations for [`Format`](Format).  
  `inc/vbcompat.bi` - Includes datetime.bi, dir.bi, file.bi, and string.bi plus additional constants compatible with Microsoft Visual Basic.

C Runtime (CRT)

Where possible cross-platform compatible headers have been provided for the C runtime (CRT). For example,

```freebasic
#include Once "crt.bi"

printf( !"Hello World\n" )
```

To include a specific CRT header, prefix the name of the header file with `"crt/"`. For example:

```freebasic
#include Once "crt/stdio.bi"

Dim f As FILE Ptr

f = fopen("somefile.txt", "w")

fprintf( f, "Hello File\n")

fclose( f )
```

Windows API

Many (many) headers for the Windows API are available for inclusion in FreeBASIC source code. In most cases the only include file needed is "windows.bi". For example,

```freebasic
#include Once "windows.bi"

MessageBox( null, "Hello World", "FreeBASIC", MB_OK )
```

To include a specific Windows API header, prefix the name of the header with "win/" for example:

`#include Once "win/ddraw.bi"`

Browse the "inc/win/" directory where FreeBASIC was installed to see all of the available Windows API headers.

Other Headers Provided

See the [External Libraries Index](External-Libraries-Index) for an overview of the additional headers shipped with FreeBASIC. The page also describes the file(s) that need to be included to use the library. Alternatively one can browse the "inc/" directory located where FreeBASIC was installed to find other headers. It is possible that headers might be available for a library you need to use. Some headers are located in "inc/" and others might be located in a sub-directory. To include headers located in a subdirectory of "inc/", prefix the name of the header with the name of the directory where it is located.  
 For example:

```freebasic
'' located at inc/curl.bi

#include Once "curl.bi"

'' located at inc/GL/gl.bi

#include Once "GL/gl.bi"
```

Requirements for Using Prebuilt Static Libraries

- The source code must include the appropriate headers using [`#include`](procedures-Include).
  The static library must be linked at compile time by using either [`#inclib`](Inclib) in the source code or by using the [`-l`](Compiler-Option-L) option on the command line to specify the name of the library.

Requirements for Using Prebuilt Shared Libraries

- The source code must include the appropriate headers using [`#include`](procedures-Include).
- The shared library (.DLL) must be present on the host computer where the compiled program will run.

Version


See also

- [Static Libraries](Static-Libraries)
- [Shared Libraries (DLLs)](Shared-Libraries)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

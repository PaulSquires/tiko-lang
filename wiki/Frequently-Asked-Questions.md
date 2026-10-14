[Home](Home) › [FAQs](Category-FAQs) › **Frequently Asked Questions**

# Frequently Asked Questions

**FreeBASIC questions:**

**- What is FreeBASIC?**
 **- Who is responsible for FreeBASIC?**
 **- Why should I use FreeBASIC rather than QBasic?**
 **- Why should I use FreeBASIC rather than some other newer BASIC ?**
 **- How fast is FreeBASIC?**
 **- How compatible is FreeBASIC with QuickBASIC?**
 **- How compatible is FreeBASIC with Windows? DOS? Linux?**
 **- Does FreeBASIC support Object Oriented Programming?**
 **- What are the future plans with FB / ToDo list ?**
 **- Can I program GUI applications in FB ?**
 **- Is FB suitable for complex / big applications?**
 **- Can I use a non-latin charset in my FreeBASIC applications?**
 **- Can I use Serial/COM and Hardware/CPU ports in FB?**

**Getting Started with FreeBASIC questions**

**- Where can I find more information about FreeBASIC?**
 **- Why doesn't the QB GUI open when I start FreeBASIC?**
 **- Can I have an offline version of the documentation?**
 **- What's the idea behind the FB dialects?**
 **- Why does my program crash when I define an array larger than xx?**
 **- Why does my program fail to compile with the message 'cannot find -llibname'?**

**Advanced FreeBASIC**

**- How do I link to C libraries?**
 **- Can I use a debugger?**
 **- What's the goal of the AR.EXE, AS.EXE and LD.EXE files included with FB ?**
 **- Is there a limit on how big my source files can be?**
 **- Can I write an OS in FreeBASIC ?**
 **- I'm developing an OS, can FreeBASIC be ported to my OS ?**
 **- Does FreeBASIC support returning reference from Functions, like in C++?**

See also

**FreeBASIC questions**

 **What is FreeBASIC?**

FreeBASIC is a free, BASIC compiler for Windows (32-bit and 64-bit), 32 bit protected-mode DOS (COFF executables, like DJGPP), and Linux (x86, x86_64, and ARM). It began as an attempt to create a code-compatible, free alternative to Microsoft QuickBASIC, but has quickly grown into a powerful development tool, already including support for libraries such as Allegro, SDL, OpenGL, and many others with its default installation.

 Aside from having a syntax mostly compatible with QuickBASIC, FreeBASIC introduces several new features to the aged language, including pointers to variables and functions, and unsigned data types.

 FreeBASIC compiler is self-hosting - written in FreeBASIC, the libraries however are written in C.

Back to top

 **Who is responsible for FreeBASIC?**

The first versions of FreeBASIC were developed exclusively by V1ctor. Later versions gained contributions from many people, including Lillo, who developed the Linux port and the graphics library, and DrV, who developed the DOS port.

 See the [FreeBASIC Credits](Credits-in-Alphabetical-Order) page.

Back to top

 **Why should I use FreeBASIC rather than QBasic?**

FreeBASIC has innumerable advantages over QBasic, QuickBASIC, PDS, and Visual Basic for DOS.

Back to top

 **Why should I use FreeBASIC rather than some other newer BASIC ?**

FreeBASIC has many traits which make it more desirable than most other BASIC language implementations:

Back to top

 **How fast is FreeBASIC?**

Most tests run by the community have shown FreeBASIC is significantly faster than QuickBASIC, faster than most other GPL or commercial BASICs, and often approaching GCC in terms of speed.  
 The [Computer Languages Benchmark Game](http://shootout.alioth.debian.org/gp4/benchmark.php?test=all&lang=all), an independent test team, give FreeBASIC for Linux a speed 1.8 times slower than GNU g++. Tests are about calculation, memory and disk access speed in console programs, no graphics capabilities were tested. This is not a bad result considering FreeBASIC is not yet an optimizing compiler.  
 One area where there is a notable speed deficiency is in 32-bit console modes. While FreeBASIC is consistently on-par with other 32-bit console mode applications, 32-bit console mode operations are significantly slower than 16-bit console operations, as seen in QuickBASIC. In DOS version, some I/O operations can slow down after porting from a 16-bit BASIC to FB - optimizing the code brings the speed back.

Back to top

 **How compatible is FreeBASIC with QuickBASIC?**

The FreeBASIC built in graphics library emulates the most used QB graphics modes (modes 7,12,13) and implements all the drawing primitives featured in QB.  
 Most compatibility problems arise from the use of 8086-DOS-hardware specific low-level techniques in the old QB programs. VGA port programming, DOS interrupts, memory segment switching, poking to the screen memory or music playing using the PC speaker are not directly supported, even if they can be supported/emulated by external libraries.  
 Other issues in porting old QB programs, like variable name clashes with new FB keywords, variables with the name of a QB keyword plus a type suffix, default integer size being 32 bits in FB, are addressed by running FreeBASIC with the commandline switch `-lang qb` .

 See [Differences between FreeBASIC and QuickBASIC](Differences-From-Qb).

Back to top

 **How compatible is FreeBASIC with Windows? DOS? Linux?**

FreeBASIC is fully compatible with Windows, MS-DOS, FreeDOS and Linux. When planning to create a program for all three platforms, however, keep API availability in mind -- code utilizing OpenGL will work in Windows and Linux, for example, but won't in DOS, because OpenGL is not available for DOS.

Back to top

 **Does FreeBASIC support Object Oriented Programming?**

FreeBASIC supports classes (user-defined types) with member functions (methods), static methods, static member variables, constructors, destructors, properties, operator overloading, single inheritance, virtual and abstract methods (polymorphism) and Run-Time Type Information (RTTI). Future plans regarding OOP functionality include adding support for multiple inheritance and/or interfaces. For more information see: [A Beginners Guide to Types as Objects](Beginners-Guide-to-Types-as-Objects-Part-1).

Back to top

 **What are the future plans with FB / ToDo list ?**

You can find out what's planned for the future releases by directly looking at [the compiler's todo.txt](http://sourceforge.net/p/fbc/code/ci/master/tree/todo.txt).

Back to top

 **Can I program GUI applications in FB ?**

Yes, you can. Headers allowing you to call the GUI API of Windows and Linux are supplied with the respective versions, but the programs made this way are not portable.  
 There are some API wrappers and experimental RAD applications that create non-portable GUI code for Windows.  
 For portable programming a multiplatform GUI wrapper library as GTK or wx-Widgets may be used. GTK headers are provided with FB, but the OOP functionality currently available in FB prevents the use of wx-Widgets. The programs created with these libraries may require the user to install the wrapper libraries in their systems.  
 For games and small graphics applications there are some FB-specific libraries that draw and manage simple controls as buttons and edit boxes inside the graphics screen, programs made with those libs are entirely portable.

Back to top

 **Is FB suitable for complex / big applications?**

The FB compiler is self-hosting, it is programmed itself in FB. That means more than 120 000 lines of code at the moment, a fairly complex application.

Back to top

 **Can I use a non-latin charset in my FreeBASIC applications?**

FreeBASIC has the Unicode support provided by the C runtime library for the given platform. This means FB DOS won't help you with Unicode. On other platforms you can use [Wstrings](Wstring) to support any charset you need. The File OPEN keyword has an additional [Encoding](Encoding) parameter allowing for different encodings. As FreeBASIC is coded itself in FB, this means you can code your source in an Unicode editor so the comments and string literals can be in any character set (keywords, labels and names for variables and procedures must be kept inside the ASCII set..).  
 For the output to screen the support is different from console to graphics. In console mode wstring printing in non latin charsets is supported if the console font supports them. Graphics mode uses an internal CP437 charset (the old DOS charset) font so non-latin output requires a custom made raster font and the use of the [Draw String](Draw-String) keyword. Third party tools exist to grab an external font and convert it to the DRAW STRING format.

Back to top

 **Can I use Serial/COM and Hardware/CPU ports in FB?**

Yes, FB has built in functions to access the serial/COM port and hardware/CPU ports with no need of external libraries. See the OS specific FAQ's for details for your OS, and [Open Com](Open-Com), [Inp](Inp) and [Out](Out) .

Back to top

**Getting Started with FreeBASIC questions**

 **Where can I find more information about FreeBASIC?**

The FreeBASIC Wiki is the most up-to-date manual for using FreeBASIC, available [here](http://www.freebasic.net/wiki/).

 Active FreeBASIC related forums, besides the [official one](http://www.freebasic.net/forum), can be found at [qbasicnews](http://www.qbasicnews.com/), [Pete's QB Site](http://www.petesqbsite.com/phpBB3/) , [the FB Games directory](http://games.freebasic.net/forum/index.php) or [freebasic-portal.de (in German)](http://www.freebasic-portal.de).

 Active magazines which regularly have FreeBASIC related articles are [QB Express](http://www.petesqbsite.com/sections/express/express.shtml) and [QBXL Magazine](http://www.qbxl.net/). These magazines are always looking for new articles, so if you think you've got a good idea for an article about FreeBASIC, submit it!

Back to top

 **Why doesn't the QB GUI open when I start FreeBASIC?**

QB had an Integrated Development Environment (IDE). FreeBASIC does not.  
 FreeBASIC is only a compiler, not a complete QuickBASIC clone. It is a console mode application. It will accept a BAS file on the command line, and spit out an EXE file.  
 You can create the BAS file with the simplest plain text editor in your OS (Notepad, EDIT, nano,...), then run the compiler.  
 If you can't live without syntax coloring, error highlighting, multiple file managing, integrated debugger, context help or other features, you need an IDE. See the OS specific FAQ's for the IDE's and editors available.

 Back to top

 **Can I have an offline version of the documentation?**

This online Wiki is the official documentation for FB. Usually it is up-to-date with the latest improvements found in the development version of FB.  
 Offline versions of this wiki (in CHM, HTML and other formats) are available from the [Documentation directory at the compiler's downloads site on SourceForge](http://sourceforge.net/projects/fbc/files/Documentation/).

Back to top

 **What's the idea behind the FB dialects?**

The idea is to allow improvements in the language while maintaining backwards compatibility with QB code. The quirks of the QB syntax are not compatible with the more rigid style required by OOP. The new FB keywords often clashed with variable names in old QB programs. QB allowed to use freely dots in variable names and procedures not being UDT's.  
 The three dialects (-lang fb, -lang qb, -lang fblite) allow to combine the best of two worlds.

- `lang fb` provides the framework required for OOP programming . Other dialects don't give access to OOP.
  `lang qb` will allow the developers to keep increasing the compatibility with qb programs. Newer keywords in FB can be used by preceding them with two underscores. For example, `Getmouse` can be called by using `_``_Getmouse`  
  `lang fblite` offers FreeBASIC language compatibility, with a more QBASIC-compatible coding style.

See [Compiler Dialects](Freebasic-Dialects) for details.

Back to top

 **Why does my program crash when I define an array larger than xx ?**

This generally happens because you made an *[automatic](Storage-Classes)* fixed-length array too large, and it is corrupting the program stack. You have a couple of options:

- if possible, reduce the size of the *automatic* array
  create a variable-length array, by

  - defining the array with an empty subscript list (using [`Dim`](Dim)), or
  defining the array with variable subscripts instead of numeric literals, [Constants](Const) or [Enums](Enum) (using [`Dim`](Dim)), or  
  defining the array with [`ReDim`](Redim)

  reserve more memory for the program stack by using the `-t` [command-line option](Quick-Start#compile-a-program) when compiling. The default is `-t 1024` (kilobytes) or `-t 2048` (kilobytes). Note: it's a bad idea to use very large values here.  
  create a *static* array by defining the array with [`Static`](procedures-Static) rather than [`Dim`](Dim) (only locally visible, but globally preserved)  
  define the array with [`Shared`](Shared) access using [`Dim`](Dim) (this makes the array fully global)  
  use [Pointers](Pointers) and [Memory Functions](Memory-Functions) like [`Allocate`](Allocate) and [`Deallocate`](Deallocate) to manage memory yourself - this is the preferred way for storing big buffers, but not for beginners.

*Static* and *variable-length* arrays don't use the program stack for their element data, so do not have the problem associated with *automatic* fixed-length arrays. See [Storage Classes](Storage-Classes) for more information. Note that storing huge buffers as *static* or increasing the stack size far above the default is not a very good idea, since it increases the fixed amount of memory needed to load and start you program, even if most of it is not used later, and can result in performance degrade, or even refusing your program to load at all.

Back to top

 **Why does my program fail to compile with the message 'cannot find -llibname'"?**

This is an error raised by the linker. The program is supposed to link to an external library, designated in the program code with [`#inclib`](Inclib) or on the compiler command line with [`-l`](Compiler-Option-L). However, the linker has been unable to find a matching file in any of the library paths. Check the homepage of the library you want to compile with to find out how to download it, or check ExtLibTOC to see if information about the library can be found there. For general information on libraries and how to use them see [Using Prebuilt Libraries](Using-Prebuilt-Libraries) and the related pages listed there.

Back to top

**Advanced FreeBASIC**

 **How do I link to C libraries?**

C libraries are set up in much the same way in FreeBASIC as they are in C. Every library included with FreeBASIC has a basic include file named "*library name*.bi" which uses the [#inclib](Inclib) metacommand to include the library, and the [Declare Statement](Declare) to declare the functions within the library. FreeBASIC includes hundreds of BI files, see full list of library headers [here](External-Libraries-Index).

Back to top

 **Can I use a debugger?**

FreeBASIC can use preferably a debugger compatible with GNU GDB.

See the OS specific FAQ's for details for your OS.

Back to top

 **What's the goal of the AR.EXE, AS.EXE and LD.EXE files included with FB ?**

AS.EXE is GAS, the "GNU assembler". It is always involved in compilation. LD.EXE is the "GNU linker", involved in creation of executables. AR.EXE is the "GNU archiver", in fact a librarian, creating `.A` libraries.

Back to top

 **Is there a limit on how big my source files can be?**

Yes, since FreeBASIC is a fully 32-bit compiler it may operate on source files up to theoretically 4GB or 4294967296 bytes, however your RAM capacity should be significantly above the size of your source, otherwise the compilation won't finish or will be very slow at least.

Back to top

 **Can I write an OS in FreeBASIC ?**

YES and NO. If you really insist to write an OS and involve FB, the answer is YES. If the question is, whether it is a good idea that you, even more if a beginner, should start coding an OS using FB now, the answer is NO. Several pitfalls apply:

FreeBASIC relies on GCC, and available informations about developing an OS in C apply to FreeBASIC as well. FB will help you neither more nor less than GCC.

Back to top

 **I'm developing an OS, can FreeBASIC be ported to my OS ?**

 Depends. If your OS at least egalizes the functionality of DOS with DPMI32 (console I/O (seeking, multiple files open, ...), file I/O, memory management) **and** has a port of GCC, then the answer is YES. If you have at least an other somewhat compliant C compiler **with** libraries, it might be possible. You can't reasonably port FB for example to an OS allowing to load or save a file in one block only, or a 16-bit OS.

 Back to top

 **Does FreeBASIC support returning references from Functions, like in C++?**

 Yes, this functionality exists. Procedures can now return references using `ByRef as datatype` for the return type.

 Back to top

See also

- [Win32 related FAQ](Windows-Related-Faq)
- [DOS related FAQ](Dos-Related-Faq)
- [Linux related FAQ](Linux-Related-Faq)

and

- [FB Runtime Library FAQ](Frequently-Asked-Fb-Runtime-Library-Questions)
- [Frequently Asked FreeBASIC Graphics Library Questions](Frequently-Asked-Freebasic-Graphics-Library-Questions)

---

**Category:** [FAQs](Category-FAQs)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

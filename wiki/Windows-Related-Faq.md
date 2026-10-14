[Home](Home) › [FAQs](Category-FAQs) › **Windows Related FAQ**

# Windows Related FAQ

**Windows:**

**- Which IDEs are available for Windows?**
 **- Can I get rid of the console / 'DOS' screen in a graphics application?**
 **- My GUI program does nothing when run / The program compiles but I get a permission denied error in the linker**
 **- How can I debug my program?**
 **- Why Windows refuses to run my code using OUT and/or INP?**
 **- I get the error 'Cannot start blah.exe because xxxx.dll was not found.' or similar. What is missing?**
 **- Does FreeBASIC work with Windows Vista/7?**
 **- Where can I find some tutorials on programming the Windows GUI?**
 **- Are there Windows GUI code builders for FB?**

**FreeBASIC Windows questions**

 **Which IDEs are available for Windows?**

At the moment three full featured IDEs have been developed specifically for FB: [FBIde](http://fbide.freebasic.net/) (not being updated), [FbEdit](http://fbedit.freebasic.net/) and [WinFBE Editor](https://www.freebasic.net/forum/viewtopic.php?f=8&t=25215). These IDEs require a minimum configuration -as path to the compiler- to work.  
 You can also download [FBIde](http://fbide.freebasic.net/) and [FbEdit](http://fbedit.freebasic.net/) as bundles (Editor + Compiler) that install in a single operation. But the bundled version of the compiler may be out of date.  
 [WinFBE](http://www.freebasic.net/forum/viewtopic.php?f=8&t=25215) Editor (WinFBE_Suite) comes packaged with the latest FB Compiler. It is an all-in-one solution.  
 Commercial "general use" IDEs can be used with FreeBASIC but may require an extensive setup. They are handy for multi language programming, as they provide a unified user interface.  
 Instructions for installing WinFBE, FBIde, and FbEdit can be found here:
 - [IDE Installation guide for Windows](http://www.freebasic.net/forum/viewtopic.php?t=10350)

Back to top

 **Can I get rid of the console / 'DOS' screen in a graphics application?**

Yes. You have to give FreeBASIC the right command for it when you compile your program.

- If you compile from a command prompt, simply add `"-s gui"` to the end, like `"fbc myprg.bas -s gui"`
  If you compile in a specific IDE, you have to edit the "Compiler Defaults".

  - In WinFBE, its "Options->Build Configurations". Add "-s gui" (NO QUOTES) for the build of your choice.
  - In FbEdit select Windows GUI in the targets dropdown list in the right of the tool bar.

Back to top

 **My GUI program does nothing when run / The program compiles but I get a permission denied error in the linker**

The problem may be related with the previous question. If a program tries to PRINT and it was compiled with `"-s gui"` it will freeze because no console is available. If the PRINT is issued before the first window is registered/opened, nothing will show in the screen or in the taskbar. The running program can only be seen in (and killed from) the task manager's processes tab. If a new compilation is tried before killing the process it will give a "Permission denied" error when the compiler tries to modify a still running .exe.  
 In Windows GUI programs do not use console commands. Use MessageBox or print to a log file to issue any error message to the user. Be sure any PRINT to console you used for debugging is not compiled in the final version.

Back to top

 **How can I debug my program?**

FreeBASIC can use any debugger compatible with GNU GDB. Insight Win32 debugger is an user friendly wrapper for GDB.

- Get Insight from [Dev-C++](http://prdownloads.sourceforge.net/dev-cpp/Insight_Binary.DevPak?download)
- Rename the file to Insight.tar.bz2, and decompress it to an empty folder
- Compile your program with the -g switch
- Run \<Your_Insight_Dir>\\bin\\usr\\bin\\Insight.exe
- Do File>Open to load your program into Insight
- From there you can watch, set breakpoints, step, examine memory and registers. Check Insight's help

Back to top

 **Why Windows refuses to run my code using OUT and/or INP?**

Windows requires a driver to be installed to access the hardware ports. FB-Win32 programs using INP and OUT include a built-in driver that installs temporarily for a session. Windows allows only users with Admin rights to run driver installations. This means if you usually run your windows sessions without Admin rights, you will have to use the windows command line command RUNAS to run your program for the first time in each session so Windows allows it to install the driver.  
 If this behavior is not acceptable you can use an external library as [PortIO32](http://www.winfordeng.com/products/portio32/) that installs a permanent port driver.

Back to top

 **I get the error 'Cannot start blah.exe because xxxx.dll was not found.' or similar. What is missing?**

You are trying to run a program using a third party library that resides in a dll not installed in your system.  
 FreeBASIC comes with headers and wrappers required to code for a lot of third party libraries but does not provide the actual runtime dll files.  
 You have to download and install these from their home page. Find in [the Links thread in the Libraries subforum](http://www.freebasic.net/forum/viewtopic.php?t=788) the URL's of the home pages of the libraries provided. You need the binaries for Win32 of the libraries. If you want to develop programs with the libs you will need the documentation too.  
 When releasing compiled code it is good etiquette to provide the third party dll's required to run it.

Back to top

 **Does FreeBASIC work with Windows Vista/7?**

Yes. (Write me!!!)

Back to top

 **Where can I find some tutorials on programming the Windows GUI?**

See the answers to this question in this [thread in the forum](http://www.freebasic.net/forum/viewtopic.php?p=89225)  
 More advanced use requires a frequent consultation of the reference at the [Microsoft Developers Network](http://msdn2.microsoft.com/en-us/library/aa139672.aspx). A local install of the API reference is possible, search Microsoft for the Platform SDK (a huge download) and install just the documentation.

Back to top

 **Are there Windows GUI code builders for FB?**

Yes there are some 3rd party developments generating Windows API code from a windows designer à la Visual Basic:  
 [WinFBE Editor](https://www.freebasic.net/forum/viewtopic.php?f=8&t=25215) (open source) full visual designer similar to Visual Basic.  
 [Jerry Fielden' Ezeegui](http://www.freewebs.com/fielden/) (freeware) uses a "graphical" textmode interface to let you build your code.  
 [mrhx Software's VISG](http://codege.org/projects/visg/) (GPL) has a more classical user interface.  
 Less helpful may be the graphical resource editors generating scripts for the resource compiler. Any editor generating scripts compatible with GoRC can be used, as the one included with [FbEdit](http://fbedit.freebasic.net/index.php). Graphical resource editors are a great help in designing dialogs and menus, but they leave to you the task of writing the window procedures required to make them active.

Back to top

See also

[Compiler FAQ](Frequently-Asked-Questions)  
 [FB Runtime Library FAQ](Frequently-Asked-Fb-Runtime-Library-Questions)

---

**Category:** [FAQs](Category-FAQs)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

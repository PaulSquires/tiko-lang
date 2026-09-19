[Home](Home) › [Tutorials](Category-Tutorials) › **Profiling for gmon/gprof**

# Profiling for gmon/gprof

Profiling can be used to analyze the performance of an application.

 The performance of an application might be measured by how many times functions are called, how much time is spent executing those functions, and which functions are calling other functions. This can help to identify functions that might be taking too long to execute or executed too many times and that might be worth reviewing for optimization.

 FreeBASIC can use GPROF for analyzing the execution of an application. The profiler information is collected while the program is running, and GPROF is used to report on the collected data afterward.

 The three basic steps to profiling a program are:

Full documentation on GPROF is available here: [https://ftp.gnu.org/old-gnu/Manuals/gprof-2.9.1/html_mono/gprof.html](https://ftp.gnu.org/old-gnu/Manuals/gprof-2.9.1/html_mono/gprof.html). If the documentation has moved from that location, simply search the web for "GNU GPROF" and a relevant link should be returned.

 FreeBASIC supports function profiling; not basic-block or line-by-line profiling.

Preparing a Program for Profiling (for gmon/gprof)

Only code that is compiled with the *[-profile](Compiler-Option-Profile)* or *[-profgen gmon](Compiler-Option-Profgen)* command line option can be so profiled.  
 Pass the *[-profile](Compiler-Option-Profile)* or *[-profgen gmon](Compiler-Option-Profgen)* option to the FreeBASIC compiler to prepare the program to be profiled.  
 For example:

```freebasic
fbc program.bas -profile
or
fbc program.bas -profgen gmon
```

This will tell the compiler to insert special startup code at the beginning of the application as well as at the beginning of each function.

Profiling (for gmon/gprof) the Program

The information needed to analyze execution of the program is gathered while the program is running. Run the program to begin collecting the function call information. This information is automatically stored in a file named `gmon.out` in the same directory as the program.

Analyzing the Program's Output

Use GPROF to analyze the output. The default report for GPROF includes descriptions on what each of the columns of values mean. If you are new to using GPROF, you may want to first run the default report and read through the descriptions. The output from GPROF can be saved to a file by redirection.

 Save output from GPROF to `profile.txt`:

```freebasic
gprof program[.exe] > profile.txt
```

Show just the flat report with no descriptions:

```freebasic
gprof program[.exe] --brief --flat-profile > profile.txt
```

Combining the Results of More than One Session

GPROF also has a '--sum' option for conveniently combining results from multiple execution sessions. Here is an example of usable:

- Run your program once. This will create `gmon.out`.
- Use the command :

`mv gmon.out gmon.sum`  
 or  
 `rename gmon.out gmon.sum`.

- Run your program again. This will create new data in `gmon.out`.
- Merge the new data in `gmon.out` into `gmon.sum` using the command:

`gprof --sum program[.exe] gmon.out gmon.sum`

- Repeat the last two steps as often as needed.
- Analyze the summary data using the command:

`gprof program[.exe] gmon.sum > profile.txt`

FreeBASIC Profiling (for gmon/gprof) Internals

When the '-profile' option is enabled, one or more bits of code are added to the program.

The profiling library itself may be in a separate library or part of the C runtime library.

The details may vary from one port of FreeBASIC to the next, but source code built for profiling with FreeBASIC should be compatible with other languages also supporting GPROF.

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

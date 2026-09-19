[Home](Home) › [Tutorials](Category-Tutorials) › **Calling Conventions**

# Calling Conventions

Specifying how procedures are called.

 Calling conventions determine how calling code interacts with procedures when called. They specify rules about how parameters are pushed onto the call stack, how values are returned and when the call stack is cleaned up. This information is useful when interacting with code written in other languages, particularly assembly language. In some cases, calling conventions also apply some kind of name decoration to procedure names.

 FreeBASIC supports 3 calling conventions: **stdcall**, **cdecl** and **pascal**, specified with [`stdcall`](Stdcall), [`cdecl`](Cdecl) and [`pascal`](Pascal), respectively. Calling convention can be specified in either a procedure declaration or definition immediately following the procedure name. The declaration of a procedure must have the same calling convention as the definition.

 In all calling conventions, integral procedure return values are returned in the `EAX`(, `EDX`) register(s), and floating-point return values are stored in the `ST(0)` register (the top of the floating-point stack). User-defined type (UDT) values are returned in the `EAX`(, `EDX`) register(s) if eight (`8`) bytes or smaller, otherwise they are returned in memory by having their address pushed onto the call stack after any parameters.

stdcall

In the **stdcall** convention, procedure parameters are pushed onto the call stack prior to the procedure call (which will push the return address just above parameters) in the reverse order they are declared, that is, from right to left. The procedure is in charge of popping any parameters from the call stack (commonly by appending a constant to the `RET` instruction, signifying the number of bytes to release).

 **stdcall** is the default calling convention on Windows, and for procedures within [`Extern "Windows"`](Extern-End-Extern) and [`Extern "Windows-Ms"`](Extern-End-Extern) blocks. It is also the default convention used in the Windows API.

Platform Differences

- In DOS and Windows platforms, the procedure name is decorated with an "`@N`" suffix, where `N` is the total size, in bytes, of any parameters passed.

cdecl

In the **cdecl** convention, procedure parameters are pushed onto the call stack prior to the procedure call, in the reverse order they are declared, that is, from right to left. The calling code is in charge of popping parameters from the call stack.

 **cdecl** is the default calling convention on Linux, the \*BSDs, and DOS, and for procedures within [`Extern "C"`](Extern-End-Extern) and [`Extern "C++"`](Extern-End-Extern) blocks. It is also the default convention used by most C and C++ compilers.

pascal

In the **pascal** convention, procedure parameters are pushed onto the call stack, in the order they are declared, that is, from left to right. The procedure is in charge of popping any parameters from the call stack.

 **pascal** is the default convention used by Pascal and the Microsoft QuickBASIC series of compilers.

 The following table summarizes the differences between the various calling conventions:

| Calling convention | Parameters are pushed onto the call stack from | Parameters are popped off the call stack by |
| --- | --- | --- |
| stdcall | right to left | the procedure |
| cdecl | right to left | the calling code |
| pascal | left to right | the procedure |

Platform Differences

- In DOS and Windows platforms, all calling conventions decorate procedure names with an underscore (`"_"`) prefix.
  The default calling convention changes depending on the platform. For Windows it is **stdcall**; while on Linux, the \*BSDs, and DOS, it is **cdecl**.

See also

- [`Declare`](Declare), [`Sub`](Sub), [`Function`](procedures-Function)
- [`stdcall`](Stdcall), [`cdecl`](Cdecl), [`pascal`](Pascal)
- [`Extern..End Extern`](Extern-End-Extern)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

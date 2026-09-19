[Home](Home) › [Programmer's Guide](Category-Programmer-s-Guide) › **Asm**

# Asm

Code block that allows the use of architecture-specific instructions.

## Syntax

```freebasic
Asm
architecture-dependent instructions
End Asm
Asm architecture-dependent instructions
```

## Description

The `Asm` block is used to insert specific machine-code instructions in a program in order to perform operations that cannot be carried out using the features of the language or to hand-optimize performance-sensitive sections of code.

 The current FreeBASIC compiler currently only produces code for Intel [80x86](X86-Microprocessor-Architecture)-based machines; however, in the future, the compiler might be ported to a platform which does not support the same instruction set. Therefore, `Asm` blocks should only be used when necessary, and a FreeBASIC-only alternative should be provided if possible.

 The return value of a function may be set by using the [`Function`](procedures-Function) keyword within brackets as shown in the example below.

 `Asm` block comments have the same syntax as usual FreeBASIC [Comments](Rem) - use FreeBASIC-like " `'` " comments, not " `;` " as usual in assembly code.

 **x86 Specific:**

**Syntax**

The syntax of the inline assembler is a simplified form of Intel syntax. Intel syntax is used by the majority of x86 assemblers, such as MASM, TASM, NASM, YASM and FASM. In general, the destination of an instruction is placed first, followed by the source. Variables and functions defined by a program may be referenced in an `Asm` block. The assembler used by FreeBASIC is GAS, using the `.intel_syntax noprefix` directive, and `Asm` blocks are passed through unmodified, except for the substitution of local variable names for stack frame references, and commenting removal.

 Instruction syntax is mostly the same as FASM uses, one important difference is that GAS requires size settings to be followed by the word "`ptr`".

```freebasic
' Assuming "n" is a FB global or local ULONG variable

mov  eax, [n]        ' OK: size is apparent from eax

inc  [n]             ' Not OK: size is not given

inc  dword [n]       ' Not OK: size given, but still not accepted by GAS

inc  dword Ptr [n]   ' OK: "ptr" is needed by GAS here
```

**Register Preservation**

When an `Asm` block is opened, the registers `ebx`, `esi`, and `edi` are pushed to the stack, when the block is closed, these registers are popped back from the stack. This is because these registers are required to be preserved by most or all OS's using the x86 CPU. You can therefore use these registers without explicitly preserving them yourself. You should not change `esp` and `ebp`, since they are usually used to address local variables.
 **Note:** Inside a [`Naked`](Naked) procedure, there is no such register preservation.

**Register Names**

The names of the registers for the x86 architecture are written as follows in an `Asm` block:

**Instruction Set**

See these external references:

**Unsafe instructions**

Note that the FreeBASIC compiler produces 32-bit protected-mode code for the x86 which usually runs in an unprivileged user level; therefore, privileged and sensitive instructions will assemble fine, but possibly won't work correctly or cause a runtime "General Protection Fault", "Illegal instruction", or SIGILL error. The following are the privileged and sensitive instructions as of the Intel Pentium 4 and Xeon:

\*1: sensitive to IOPL, fine in DOS  
 \*2: sensitive to permission bits in CR4, see below

The privileged instructions will work "correctly" in DOS when running on a Ring 0 DPMI kernel, like the (non-default) Ring 0 version of CWSDPMI, WDOSX or D3X, nevertheless most of them are not really useful and dangerous when executed from DPMI code. RDTSC (Read Time Stamp Counter) has been shown to be allowed by most, or all OS'es.

 However the usefulness of RDTSC has been diminished with the advent of multi-core and hibernating CPUs. SSE2 and higher instructions are disabled "by default" after CPU initialization, Windows and Linux usually do enable them, in DOS it is business of the DPMI host: HDPMI32 will enable them, CWSDPMI won't. The INT instruction is usable in the DOS version/target only, note that it works slightly differently from real mode DOS, see also FaqDOS.

 The segment registers (`cs`, `ds`, `es`, `fs`, `gs`) should not be changed from an `Asm` block, except in certain cases with the DOS port (note that they do NOT work the same way as in real-mode DOS, see also FaqDOS). The operating system or DPMI host is responsible for memory management; the meaning of segments (selectors) in protected mode is very different from real-mode memory addressing.

 Note that those "unsafe" instructions are not guaranteed to raise a "visible" crash even when ran with insufficient privilege - the OS or DPMI host can decide to "emulate" them, either functionally (reading from some CRx works under HDPMI32), or "dummy" (nothing happens, instruction will pass silently, like a NOP).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Asm`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Function`](procedures-Function)
- [`Naked`](Naked)

## Examples

```freebasic
'' This is an example for the x86 architecture.

Function AddFive(ByVal num As Long) As Long

    Asm

        mov eax, [num]

        Add eax, 5

        mov [Function], eax

    End Asm

End Function

Dim i As Long = 4

Print "4 + 5 ="; AddFive(i)
```

 `4 + 5 = 9`

 FreeBASIC's Assembler is AS / GAS, the assembler of GCC, so an external program. Some quirks apply:

---

**Category:** [Programmer's Guide](Category-Programmer-s-Guide)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

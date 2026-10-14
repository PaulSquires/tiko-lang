[Home](Home) › **Compiler Option: -asm**

# Compiler Option: -asm

Set assembler format for inline assembly under -gen gcc

Syntax

`-asm < format >`

Parameters

`format`

The assembler format: *intel* or *att*

Description

The `-asm` compiler option sets the assembler format for inline [`Asm`](Asm) blocks when using [-gen gcc](Compiler-Option-Gen).

```freebasic
Dim a As Long = 1

Print a

Asm

    inc dword Ptr [a]

End Asm

Print a
```

```freebasic
Dim a As Long = 1

Print a

Asm

    "incl %0\n" : "+m" (a) : :

End Asm

Print a
```

The x86 ASM backend ([-gen gas](Compiler-Option-Gen)) currently only supports `-asm intel` and using `-asm att` results in an error.

See also

- [\_\_FB_ASM\_\_](Fb-Asm)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

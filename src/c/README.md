# src/c -- the closed list of files that stay C

RFC-0003 section 4. Anything here must be listed below with its reason, or
`build/lint.sh` fails the build. The list is closed: it shrinks, it does not grow.

**Currently empty.** The spike slice (memory, strings, error, startup) needs
nothing from it. The entries expected later, each already justified in RFC-0003:

| Expected file | Reason |
| --- | --- |
| `hinit_x87.c` | x87 control word via `fstcw`/`fldcw` -- inline asm, rejected by `-gen llvm` |
| `sys_portio.c` | `inb`/`outb` -- inline asm, and the fbportio driver path |
| `cpudetect.s` | hand-written assembly |
| `fbrt0.c` `fbrt1.c` `fbrt2.c` | constructor priority 100, below FreeBASIC floor of 101 (PROBE-4) |

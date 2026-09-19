[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Debugging FB**

# Debugging FB

For debugging and development it's a good idea to build the compiler with -g and -exx to enable assertions, plus array boundary and null-pointer checks. For the rtlib/gfxlib2 code, -DDEBUG enables the assertions. Just update config.mk and (re)build. Example config.mk settings:

```freebasic
FBFLAGS := -g -exx
CFLAGS := -g -O0 -DDEBUG
```

 Running fbc inside gdb typically looks like this:

```freebasic
gdb --args fbc foo.bas
```

 Running fbc inside valgrind typically looks like this:

```freebasic
valgrind fbc foo.bas
```

 Also note that fbc can be tested right from inside the build tree, without having to be "installed" somewhere else, which also is a great debugging and development help.

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

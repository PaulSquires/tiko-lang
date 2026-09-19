[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **File contexts**

# File contexts

Because #includes can occur in the middle of input files, the lexer needs to push file contexts to a stack. File input buffer, macro expansion buffer and the token queue form a so-called "context". It is file specific and thus it must be pushed onto a stack, so that the lexer can return to the parent (after parsing an #include), without losing any tokens or macro text. Note that macros can contain #includes too.

 `fb.bas:fbIncludeFile()` basically just consists of:

`lexPush()`  
 `cProgram()`  
 `lexPop()`

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Miscellaneous](Category-Miscellaneous) › **C Header Style Guide**

# C Header Style Guide

About This Guide

 This guide is not a [C tutorial](http://www.cprogramming.com/tutorial.html#ctutorial) or a step by step guide for converting headers. This is a style guide which represents the `ideal` header we would like to maintain. Currently not all of the headers under our control conform to this guide 100%, but work is in progress to do this and all new contributions should attempt to use these standards.

General

- Translations should be very close to the original, so they look familiar and can be updated easily.
  Identifiers (including any #defines) should not be changed unless absolutely necessary.  
  Smaller files may be combined into one bigger header, if they would be #included anyways and all belong to the same library.  
  Original license should be retained.

Coding style

- Headers need to work with the latest FreeBASIC version.
  Naming conflicts between multiple identifiers (due to FreeBASIC's case insensitivity) or an identifier and a FreeBASIC keyword should be resolved by appending an underscore to one identifier.  
  extern "c" blocks should be used instead of cdecl alias "..." for function declarations or function pointer types.  
  Preprocessor directives (including #defines) should be preserved. Exception: Remove if they serve only to select options for different C compilers, i.e. extern differences, then these can be removed unless they provide support for further code. When choosing compilers the choice should favor GNU C.  
  FreeBASIC keywords should be lower-case.

Dealing with constructs not supported by FreeBASIC

- Inline functions should be converted to a macro if appropriate.
  Preprocessor directives inside structure declarations, function bodies, or similar may need to be moved outside because in FreeBASIC they'd be scoped.  
  Declarations spread across multiple lines with preprocessor directives in between them (for example function declarations, or array initializers) will need to be manually rewritten

---

**Category:** [Miscellaneous](Category-Miscellaneous)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

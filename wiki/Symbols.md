[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Symbols**

# Symbols

In order to be able to make the transition from tokens to AST, the parser needs to be able to recognize functions, variables, types, etc. The `symb` module keeps track of all these symbols and their namespaces and scopes. The parser can do lookups in the current scope, or in just specific namespaces. Many AST nodes have a corresponding symbol (e.g. variables and functions).

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

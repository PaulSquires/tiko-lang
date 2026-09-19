[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Quick overview of the call graph**

# Quick overview of the call graph

Showing the recursion between the FB parser, the PP parser, and the lexer:

```freebasic
				+------------------> lexGetLookAhead() --------+
				|                                              |
				|                                              v
	 (begin)        (FB parsing)                (PP parsing)         (lexing)
	fbCompile()  ->  cProgram()  ------------>  lexSkipToken()  ->  lexNextToken()
		|               ^  |                       |     ^              |    ^
		v               |  |                       v     |              v    |
	   fbPreIncludes()  |  |('$include)       ppCheck()  |           ppDefineLoad()
			  |     |  |                       |     |          (macro expansion)
			  v     |  v                       v     |
			 fbIncludeFile()  <--------------  ppParse()
					(#include)    (directives)
```

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

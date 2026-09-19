[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Lexer & preprocessor**

# Lexer & preprocessor

`lex*.bas`: File input, tokenization, macro expansion buffer, token queue, #include contexts.  
 `pp*.bas`: Preprocessor directive parsing, macro expansion text construction.

The lexer reads the source code from the .bas files and translates it into a series of tokens, so the FB parser sees this:

```freebasic
dim as integer i = 5
print i
```

 as:

```freebasic
(Top-level parser retrieves the first token:)
DIM     keyword         (Go to variable declaration parser)
AS      keyword         (Go to datatype parser)
INTEGER keyword         (Data type)
"i"     symbol          (Back to variable declaration, variable identifier)
"="     operator        (Go to initializer parser)
"5"     number literal  (Expression)
EOL     statement end   (Variable declaration parser is done,
			 the variable is added to the AST,
			 back to toplevel parser)
(Next line, next statement)
PRINT   keyword         (Go to QB print quirk function call parser)
"i"     symbol          (Expression, lookup "i" symbol, it's an integer variable,
			 create a CALL to fb_PrintInt(), the expression is the argument)
EOL                     (Print parser is done, back to toplevel)
EOF                     (Top-level parser is done)
```

 The lexer is an abstraction hiding the ugly details of user input (indentation, comments, keyword capitalization, #includes) from the parser. Additionally it does preprocessing, consisting of macro expansion and preprocessor directive parsing. The general idea is to handle all preprocessing in the lexer, so the parser does not get to see it. The parser never calls preprocessor functions, the lexer functions do that.

 [Tokens](Tokens)  
 [Macro storage and expansion](Macros)  
 [Preprocessor directive parsing](Directive-Parsing)  
 [File contexts](File-Contexts)  
 [Quick overview of the call graph](Quick-Overview-of-the-Call-Graph)

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

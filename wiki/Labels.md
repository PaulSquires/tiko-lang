[Home](Home) › [Tutorials](Category-Tutorials) › **Labels**

# Labels

Defines a location in a program.

Syntax

```freebasic
symbolname :

or

literalnumber
```

Description

A label can define a place in a program where [`Goto`](Goto) or [`GoSub`](Gosub) can jump to.  
 A label can also mark [`Data`](Data) blocks, allowing [`Restore`](Restore) to change the [`Read`](Read) sequence.

 A label can be a positive integer line number or a `symbolname`. In both cases, the label must start at the first column of line. A `symbolname` label must end with a colon (:) character.

Example

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

beginning:

3 Print "Hello World!"

Goto beginning
```

```freebasic
'' compile with -lang qb

'$lang: "qb"

'' Labels can be used to "bookmark" DATA blocks, allowing RESTORE to alter the READ sequence.

Read a,b,c

Restore here

Read d,e

Print a,b,c,d,e

Data 1,2,3,4,5

here:

Data 6,7,8
```

 Output:

```freebasic
1,2,3,6,7
```

Dialect Differences

- Line numbers with decimals is available only in the *[-lang qb](Compiler-Option-Lang)* dialect.

Differences from QB

- None if compiled in the *[-lang qb](Compiler-Option-Lang)* dialect.

See also

- [`GoSub`](Gosub)
- [`Goto`](Goto)
- [`Restore`](Restore)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

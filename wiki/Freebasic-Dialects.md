[Home](Home) › [FreeBASIC dialects and QBASIC](Category-FreeBASIC-dialects-and-QBASIC) › **FreeBASIC Dialects**

# FreeBASIC Dialects

The *[-lang](Compiler-Option-Lang)* command-line option changes the language compatibility mode for different dialects of the basic language.

 The *[-lang qb](Compiler-Option-Lang)* dialect allows only what would have been allowed in [QuickBASIC](Microsoft-Quickbasic).

 The *[-lang fblite](Compiler-Option-Lang)* dialect is intended to replace `-lang deprecated`.

 The [`#lang`](procedures-Lang) directive and [`$Lang`](Lang) metacommand specify a dialect from source.

| -lang option | description |
| --- | --- |
| fb | FreeBASIC compatibility (default) |
| qb | qbasic compatibility |
| fblite | FreeBASIC language compatibility, with a more QBASIC-compatible coding style |
| deprecated | compatibility with older FreeBASIC sources |

 The *[-lang](Compiler-Option-Lang)* option was needed to allow FreeBASIC to support object-orientation and other features in the future, without crippling the QuickBASIC support or breaking compatibility with old FreeBASIC sources, and without making FreeBASIC difficult to maintain with many different versions of very similar packages. The QuickBASIC support can continue to be improved, if needed, without breaking the sources written specifically for FreeBASIC.

 To compile old GW-BASIC or QuickBASIC/QBasic sources without too many changes, use the *[-lang qb](Compiler-Option-Lang)* option on the command-line. This option will evolve into a better compatibility with QuickBASIC/QBasic code.

 To compile FreeBASIC sources from 0.16b, use the *[-lang deprecated](Compiler-Option-Lang)* option. This option is maintained for compatibility and will not evolve in the future, and it's likely to disappear when FreeBASIC reaches a non-beta release.

 For programmers who want to access some of FreeBASIC's newer features, but want to retain a more QBASIC-friendly programming style, use the *[-lang fblite](Compiler-Option-Lang)* option. This dialect will not undergo significant changes in the future, but will continue to be maintained and supported.  
 This option is also the most compatible with sources that were made using older versions of FreeBASIC.

 It is recommended to use *[-lang fb](Compiler-Option-Lang)* for new projects, as new features (object classes, inheritance..) will be added exclusively to this dialect.

***-lang fb (the default mode)***

**Not supported:**

 1) implicit variable declaration

2) type suffixes (`!, #, $, %, &`)

3) [`DefByte`](Defbyte), [`DefUByte`](Defubyte), [`DefShort`](Defshort), [`DefUShort`](Defushort), [`DefInt`](Defint), [`DefUInt`](Defuint), [`DefLng`](Deflng), [`DefLongInt`](Deflongint), [`Defulongint`](Defulongint), [`DefSng`](Defsng), [`DefDbl`](Defdbl), [`DefStr`](Defstr)

4) all parameters passed by reference by default

5) `OPTION`s of any kind (no context-sensitivity)

6) periods in symbol names

7) [`GoSub`](Gosub) or [`Return (From Gosub)`](Return-From-Gosub)

8) [`On Gosub`](On-Gosub)

9) [`Resume`](Resume)

10) `'$DYNAMIC`, `'$STATIC`, `'$INCLUDE` meta-commands embedded in comments

11) [`Call`](Call) or [`Let`](Let)

12) numeric labels

13) global symbols with the same name as keywords

***-lang deprecated***

**Supported:** *Anything allowed in version 0.16b, but:*

 1) `GOSUB`/`RETURN` and `ON ... GOSUB` (even at module-level)

**Not supported:**

 1) Classes

2) Operator overloading

3) Constructors, destructors and methods in `TYPE`s.

***-lang fblite***

**Supported:** *Anything allowed in the*[-lang deprecated](Compiler-Option-Lang)*dialect, plus..*

 1) `GOSUB`/`RETURN`

**Not supported:**

 1) [`Scope`](Scope-End-Scope) blocks

***-lang qb***

**Supported:** *Everything not supported/allowed in the*[-lang fb](Compiler-Option-Lang)*dialect, plus..*

 1) [`Call`](Call) can be used with forward-referenced functions.

 2) [`Shared`](Shared) can be used inside functions. (W.I.P.)

 3) All variables, implicitly or explicitly declared, are always allocated in the procedure scope, like in QuickBASIC.

 4) The [`Data`](Data) statement won't look up symbols, every token is assumed to be a literal string even without quotes, like in QuickBASIC.

 **Not supported:**

 1) Multi-threading

2) Classes and Namespaces

 3) Procedure and operator overloading

 4) Constructors, destructors and other member procedures in [`Type`](Type-Udt) definitions.

 5) [`Scope`](Scope-End-Scope) blocks

 6) [`Extern`](Extern-End-Extern) blocks

 7) Variable initialization

---

**Category:** [FreeBASIC dialects and QBASIC](Category-FreeBASIC-dialects-and-QBASIC)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

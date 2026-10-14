[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **$Lang**

# $Lang

Metacommand statement to set the compiler dialect.

## Syntax

```freebasic
'$lang: "lang"
Rem $lang: "lang"
```

## Description

If the *[-forcelang](Compiler-Option-Forcelang)* option was not given on the command line, `$Lang` can be used to set the dialect for the source module in which it appears. At most two passes will be made on the source module. On the first pass, if the specified dialect is anything other than the default dialect (chosen with *[-lang](Compiler-Option-Lang)*, or `"fb"` by default), the compiler will reset the parser for another pass and restart compilation at the beginning of the source module. If this metacommand is encountered again on the second pass, and the specified dialect does not match the new current dialect, a warning is issued and compilation continues. If any errors were encountered on the first pass, the compiler will not attempt a second pass.

 `$Lang` may not be used in any compound statement, scope, or subroutine. However, it may be nested in module level preprocessor statements or used in an include file.

 There is currently no restriction on where this directive may be placed in a source module. In future this may change, therefore best practice would be to use this directive before the first declaration, definition, or executable statement in the source.

 This directive overrides the *[-lang](Compiler-Option-Lang)* option if it was given on the command line. However, if the *[-forcelang](Compiler-Option-Forcelang)* option was given on the command line, this directive will have no effect. A warning is issued, the directive is ignored, and compilation will continue. This allows the user to explicitly override `$Lang` metacommands.

 QuickBASIC will treat it as a comment and silently ignore it.

## Remarks

### Differences from QB

- New to FreeBASIC
- QB handles `'$lang:` as a normal comment

### See also

- [`#lang`](procedures-Lang)
- [`__FB_LANG__`](Fb-Lang)
- [Compiler Option: -lang](Compiler-Option-Lang)
- [Compiler Option: -forcelang](Compiler-Option-Forcelang)
- [FreeBASIC Dialects](Freebasic-Dialects)

## Examples

`'$lang: "qb"`

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

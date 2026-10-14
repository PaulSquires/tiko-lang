[Home](Home) › [Tutorials](Category-Tutorials) › **Identifier Rules**

# Identifier Rules

Naming conventions for FreeBASIC symbols.

Description

An identifier is a symbolic name which uniquely identifies a [variable](Variables), [`Type`](Type-Udt), [`Union`](Union), [`Enum`](Enum), [`Function`](procedures-Function), [`Sub`](Sub), or [`Property`](Property), within its [scope](Variable-Scope) or [`Namespace`](Namespace).

 Identifiers may contain only uppercase and lowercase Latin characters `a`-`z` and `A`-`Z`), digits (`0`-`9`), and the underscore character (`_`). The first character of an identifier must be a letter or underscore, not a digit; if an identifier's length exceeds 128 characters, it will be truncated.

 Identifiers are case-insensitive: `FOO` and `foo` (and all other permutations of uppercase and lowercase) refer to the same symbol.

 In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, identifiers may have a type suffix at the end indicating one of the standard data types:

- `%` for [`Integer`](Integer)
- `&` for [`Long`](Long)
- `!` for [`Single`](Single)
- `#` for [`Double`](Double)
- `$` for [`String`](String)

The use of these suffixes is generally discouraged and is not allowed in the *[-lang fb](Compiler-Option-Lang)* dialect (the default).

 The alternative is to be explicit - for example, `Dim As Integer foo` or `Dim foo As Integer` instead of `Dim foo%`.

 In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, identifiers may contain one or more periods (`.`).

Platform Differences

- Warning:

**-** For 64-bit compiler only and regarding the choice of user module level procedure identifier names, an additional restriction to the above normal 'Identifier Rules' should also exclude in the global namespace all register names or other symbols issued from the only 'intel' format assembler when it is used (the one by default, no problem with 'att' format), because they causes assembler errors or runtime bugs (due to the 64-bit compiler not decorating module level procedure names).
 **-** For x86 and x86_64 only (with any assembler format), the use of an inline asm symbol or a global/external/backend symbol induces a warning if such a symbol is used for a module level procedure or a shared variable in the global namespace.

Dialect Differences

- Periods in symbol names are only supported in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

Differences from QB

- Support for the underscore character (`_`) in symbol names is new to FreeBASIC.

See also

- [Variables](Variables)
- [Identifier Look-ups in namespaces and types](Identifier-Look-Ups-in-Namespaces-and-Types)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

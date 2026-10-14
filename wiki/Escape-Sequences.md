[Home](Home) › **Escape Sequences**

# Escape Sequences

Escape sequences can be used in string literals by using the operator ! .

Usage

`result = !"text"`

Description

The accepted escape sequences in *text* are:

| \\a | beep |
| --- | --- |
| \\b | backspace |
| \\f | formfeed |
| \\l or \\n | newline |
| \\r | carriage return |
| \\t | tab |
| \\unnnn | unicode char in hex |
| \\v | vertical tab |
| \\nnn | ascii char in decimal |
| \\&hnn | ascii char in hex |
| \\&onnn | ascii char in octal |
| \\&bnnnnnnnn | ascii char in binary |
| \\\\ | backslash |
| \\" | double quote |
| \\' | single quote |

Note: The zero-character (\\000 = \\&h00 = \\&o000 = \\&b00000000) is the null terminator. Only characters before the first null terminator can be seen when the literal is used as a [`String`](String). To get a zero character in a string use `Chr(0)` instead.

See also

- [Operator ! (Escaped String)](Operator-Escaped-String-Literal)
- [Operator $ (Non-Escaped String)](Operator-Non-Escaped-String-Literal)
- [`Option Escape`](Option-Escape)
- [`String`](String)
- [`Chr`](Chr)
- [Literals](Literals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

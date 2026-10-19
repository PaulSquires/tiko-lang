[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **CurDir**

# CurDir

Returns the current folder.

## Syntax

```freebasic
Declare Function CurDir ( ) As String
```

## Description

Returns the current directory/folder.

## Return Value

A [`String`](String) which is set to the name of the current directory/folder.

## Remarks

### Usage

`result = CurDir`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Curdir`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Open`](Open)
- [`Dir`](Dir)
- [`ChDir`](Chdir)
- [`MkDir`](Mkdir)
- [`RmDir`](Rmdir)

## Examples

`Print CurDir`  
 output will vary.

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

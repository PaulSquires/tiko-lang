[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Poke**

# Poke

Writes a value to an address, as a byte or as a given type.

## Syntax

```freebasic
Declare Sub Poke ( ByVal address As Any Ptr, ByRef value As UByte )
Declare Sub Poke ( datatype, ByVal address As Any Ptr, ByRef value As datatype )
```

## Parameters

- `datatype`
- `address`
- `value`

## Description

`Poke` assigns a value to a location in memory. It is equivalent to

`*cast(ubyte ptr, address) = value`

or

`*cast(datatype ptr, address) = value`

When `datatype` is a user-defined type, `Poke` assigns `value` using the type's [`Operator Let`](Operator-Let-Assign).

 **Note:** When using `Poke`, the *[-exx](Compiler-Option-Exx)* compiler option does not add code for null-pointer checking (no nullity test on the value of `address`).

## Remarks

### Usage

`Poke [ datatype, ] address, value`

### Differences from QB

- Only the byte form were supported in QB.
- `DEF SEG` isn't needed anymore because the address space is 32-bit flat in FreeBASIC.

### See also

- [`Peek`](Peek)

## Examples

```freebasic
Dim i As Integer, p As Integer Ptr

p = @i

Poke Integer, p, 420

Print Peek(Integer, p)
```

 Will produce the output:

```freebasic
420
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

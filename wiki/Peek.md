[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Peek**

# Peek

Gets the value of an arbitrary type at an address in memory

## Syntax

```freebasic
Declare Function Peek ( ByVal address As Any Ptr ) ByRef As UByte
Declare Function Peek ( datatype, ByVal address As Any Ptr ) ByRef As datatype
```

## Parameters

- `address`
- `datatype`

## Description

This procedure returns a reference to the value in memory given by a memory address, and is equivalent to:

`*cast(ubyte ptr, address)`

or

`*cast(datatype ptr, address)`

thus this keyword can also be used to assign a value to a memory location, similarly to [`Poke`](Poke).

 **Note:** When using `Peek`, the *[-exx](Compiler-Option-Exx)* compiler option does not add code for null-pointer checking (no nullity test on the value of `address`).

## Remarks

### Usage

`Peek( [ datatype, ] address )`

### Differences from QB

- **`Peek`** did not support the `datatype` parameter in QB, and could only return individual bytes.
  **`Peek`** returns a reference in FB, so can be used to set the memory contents of the address, like with [`Operator * (Value Of)`](Operator-Value-of).
  `DEF SEG` isn't needed anymore because the address space is 32-bit flat in FreeBASIC.

### See also

- [`Poke`](Poke)
- [`Operator * (Value Of)`](Operator-Value-of)

## Examples

```freebasic
Dim i As Integer, p As Integer Ptr

p = @i

Poke Integer, p, 420

Print Peek(Integer, p)
```

 will produce the output:

```freebasic
420
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Swap**

# Swap

Exchanges the values of two variables.

## Syntax

```freebasic
Declare Sub Swap ( ByRef a As Any, ByRef b As Any )
```

## Parameters

- `a`
- `b`

## Description

Swaps the value of two variables, including UDT instances (swaps all data members).

 Because a fixed-length string field of STRING\*N type has no terminal null character, `Swap` will pad values with spaces where one of the arguments is of the STRING\*N type.

 **Note:** When the data are referenced by a pointer, alone or within a descriptive structure (a UDT, for example), `Swap` only exchanges the values of the pointers or the contents of the descriptive structures without accessing data themselves.
 For var-len strings, `Swap` only exchanges the descriptors of the strings rather than reallocate memory for exchange all strings data characters.  
 For UDTs, `Swap` simply exchanges the contents of the structures, without any operators or methods being called.

## Remarks

### Usage

`Swap a, b`

### Differences from QB

- None

### See also

- [`Operator = (Assignment)`](Operator-Assign)

## Examples

```freebasic
' using swap to order 2 numbers:

Dim a As Integer, b As Integer

Input "input a number: "; a

Input "input another number: "; b

If a > b Then Swap a, b

Print "the numbers, in ascending order are:"

Print a, b
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

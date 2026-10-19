[Home](Home) › [Array Functions](Category-Array-Functions) › **Arraylen**

# Arraylen

Returns the total number of elements in an array, counting every dimension.

## Syntax

```freebasic
Declare Function ArrayLen ( arrayname() As Const Any ) As UInteger
```

## Parameters

- `arrayname`

## Description

Returns the total number of elements of the array specified by `arrayname()` (taking into account all dimensions of array).

## Remarks

### Usage

```freebasic
#include once "fbc-int/array.bi"

using FB

...

result = ArrayLen(arrayname())
```

### Differences from QB

- New to FreeBASIC.

### See also

- [`Arraysize`](Arraysize)
- [`Fbarray (Array Descriptor Structure And Access)`](Fbarray-Array-Descriptor-Structure-and-Access)

## Examples

```freebasic
#include Once "fbc-int/array.bi"

Using FB

Dim As LongInt array(4, 5)

Dim As UInteger array_length

array_length = ArrayLen(array())

Print array_length                '' 30
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

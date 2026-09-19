[Home](Home) › [Array Functions](Category-Array-Functions) › **Arraysize**

# Arraysize

Provides the size of an array given its array-name.

## Syntax

```freebasic
Declare Function ArraySize ( arrayname() As Const Any ) As UInteger
```

## Parameters

- `arrayname`

## Description

Returns the total size (in bytes) of the array specified by `arrayname()` (size of array element multiplied by total number of array elements).

## Remarks

### Usage

```freebasic
#include once "fbc-int/array.bi"

using FB

...

result = ArraySize(arrayname())
```

### Version

- Since fbc 1.09.0.

### Differences from QB

- New to FreeBASIC.

### See also

- [`Arraylen`](Arraylen)
- [`Fbarray (Array Descriptor Structure And Access)`](Fbarray-Array-Descriptor-Structure-and-Access)

## Examples

```freebasic
#include Once "fbc-int/array.bi"

Using FB

Dim As LongInt array(4, 5)

Dim As UInteger array_size

array_size = ArraySize(array())

Print array_size                 '' 240
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

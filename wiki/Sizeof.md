[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **SizeOf**

# SizeOf

Returns the size of a variable or type in bytes.

## Syntax

```freebasic
SizeOf ( variable | DataType )
```

## Description

The `SizeOf` operator returns an [`Integer`](Integer) value: the number of bytes taken up by a `variable` or `DataType` (including the data fields of a UDT).

 When used with fixed-length strings (including fixed-length [`ZString`](Zstring)s and [`WString`](Wstring)s) it will return the number of bytes they use, and when used with variable-length strings, it will return the size of the string descriptor.  
 (it is equal to [`Len`](Len) only when used with fixed-length strings of STRING\*N type)

 If there is both a user defined type and a variable visible with the same name in the current scope, the user defined type takes precedence over the variable. To ensure that the `SizeOf` takes the variable instead of the user defined type, wrap the argument to `SizeOf` with parentheses to force it to be seen as an expression. For example `Sizeof((variable))`.

 **Note:** When used with array names, `SizeOf` returns the size of the array dadatype, but not the total size of the array. This differs from its behavior in C, where arrays could only be a fixed size, and `sizeof()` would return the number of it used.
 For clarity, it is recommended that you avoid this potential confusion, and use `SizeOf` on the array datatype doing `SizeOf(Typeof(array))`, rather than the array name only doing `SizeOf(array)`.

 Remark: When used with a dereferenced z/wstring pointer, `SizeOf` always returns the number of bytes taken up by one z/wstring character.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Sizeof`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Len`](Len)

## Examples

`Print SizeOf(Byte) ' returns 1`

```freebasic
Type bar

    a As Integer

    b As Double

End Type

Dim foo As bar

Print SizeOf(foo)
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

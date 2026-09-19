[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **WString**

# WString

Standard data type: wide character string

## Syntax

```freebasic
Dim variable As WString * size
Dim variable As WString Ptr
```

## Description

A `WString` is a fixed-size array of wide-chars that never overflows if the size is known at compile-time. It has no descriptor, and does never resize unless it's a pointer and [`Allocate`](Allocate)/[`Reallocate`](Reallocate)/[`Deallocate`](Deallocate) are used directly. When the variable has a fixed `size` (numeric constant, or expression that can be evaluated at compile time), FreeBASIC avoids any overflow that could occur on assignment, by truncating the contents to a length of `size - 1`.

 The end of the string is marked by the character 0 automatically added by the FreeBASIC string handling functions, so that character must never be part of a `WString` or the content will be truncated. The character 0 will be appended when the string is created, and the length will be calculated by scanning the string for the first null character.

 In a `WString`, [`Len`](Len) returns the size of the contained string and [`SizeOf`](Sizeof) returns the space allocated to the `WString`. [`SizeOf`](Sizeof) only works if the size is known by the compiler, i.e. a fixed-size `WString` variable is passed directly, not as a dereferenced pointer or a [`ByRef`](Byref-Parameters) function argument.

 This type is provided for support non-Latin based alphabets. Any intrinsic string function like [`Left`](Left) will work with `WString`s too, as will any string operator.

 When processing source files, FreeBASIC can parse ASCII files with Unicode escape sequences (\\u), or UTF-8, UTF-16LE, UTF-16BE, UTF-32LE and UTF-32BE files, as long as they were saved with Byte Order Mark (BOM).
 **Note:** The most reliable cross-platform code is obtained by encoding without BOM in ASCII/UTF-8 characters.

 The FreeBASIC text file functions can read and write Unicode files in different encodings, provided the [`Encoding`](Encoding) is specified when the file is opened. The text is automatically converted to the internal encoding at read and converted back to the file encoding at write.

 [`SizeOf`](Sizeof)( `WString` ) returns the number of bytes used by a `WString` character in the current platform.

 When allocating dynamic memory for a `WString`, the safest is to use [`CAllocate`](Callocate) (or at worst, to use [`Allocate`](Allocate) followed by an immediate assignment of the string data, as in the second example), in order to avoid creating string data without any null character (the terminal character for a `WString`).

 **Note :** When any operand of a binary operator (as assignment, equal, +, \*, ...) consists in dereferencing a '`Wstring Ptr`' pointer ('`pw`'), this can give a '`Wstring`' string or a '`Numeric`' variable, depending on the other operand. If the other operand is numeric, so the dereferenced '`Wstring Ptr`' pointer ('`*pw`') will be treated as a '`Numeric`' reference to the one character pointed. If a '`Wstring`' pointer indexing '`[]`' operator is used as dereferencing syntax ('`pw[n]`'), it is basically a short-cut version of the '`String`' indexing '`[]`' operator ('`(*pw)[n]`').

## Remarks

### Platform Differences

 Support for wstrings relies in the C runtime library available in the platform and the internal format may vary.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Wstring`.

### Differences from QB

- New to FreeBASIC

### See also

- [`String`](String) (data type)
- [`ZString`](Zstring) (data type)
- [`String`](String-Function) (function)
- [`WString`](Wstring-Function) (function)
- [`WSpace`](Wspace)
- [`WStr`](Wstr)
- [`WChr`](Wchr)
- [`WBin`](Wbin)
- [`WHex`](Whex)
- [`WOct`](Woct)
- [`Winput()`](Winput)
- [`Standard Data Type Limits`](Standard-Data-Type-Limits)
- [`Extends Wstring`](Extends-Wstring)

## Examples

```freebasic
Dim As WString * 13 str1 => "hello, world"

Print str1

Print Len(str1)    'returns 12, the length of the string it contains

Print SizeOf(str1) 'returns 13 * sizeof(wstring), the number of bytes used by the variable
```

```freebasic
Dim As WString Ptr str2

str2 = Allocate( 13 * Len(WString) )

*str2 = "hello, world"

Print *str2

Print Len(*str2)      'returns 12, the length of the string it points to
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

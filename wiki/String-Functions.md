[Home](Home) › [String Functions](Category-String-Functions) › **String Functions**

# String Functions

Statements and Procedures that work with strings.

Description

These statements and procedures provide many ways to create and manipulate strings and substrings. Numbers can be converted to strings and vice-versa. Procedures are also provided to aid in serialization of numeric data, perhaps for persistent storage.

**Creating Strings**

String data types and procedures that create new strings.

**Character Conversions**

Procedures that convert from character codes to strings and back.

**Numeric/Boolean to String Conversions**

Procedures that convert numeric values to strings.

**String to Numeric Conversions**

Procedures that convert strings to numeric values.

**Numeric Serializations**

Procedures that convert raw numeric data to and from strings suitable for storage.

**Working with Substrings**

Procedures that return subsets of strings, or that modify subsets of strings.

***Creating Strings***

**[String](String)**

Standard data type: 8 bit character string.

**[String (Function)](String-Function)**

Returns a [String](String) of multiple characters.

**[ZString](Zstring)**

Standard data type: null terminated 8 bit character string.

**[WString](Wstring)**

Standard data type: wide character string.

**[Wstring (Function)](Wstring-Function)**

Returns a [WString](Wstring) of multiple characters.

**[Space](Space)**

Returns a [String](String) consisting of spaces.

**[WSpace](Wspace)**

Returns a [WString](Wstring) consisting of spaces.

**[Len](Len)**

Returns the length of a string in characters.

***Character Conversion***

**[Asc](Asc)**

Returns an [Integer](Integer) representation of an character.

**[Chr](Chr)**

Returns a string of one or more characters from their ASCII [Integer](Integer) representation.

**[WChr](Wchr)**

Returns a [WString](Wstring) of one or more characters from their Unicode [Integer](Integer) representation.

***Numeric/Boolean to String Conversions***

**[Bin](Bin)**

Returns a binary [String](String) representation of an integral value.

**[WBin](Wbin)**

Returns a binary [WString](Wstring) representation of an integral value.

**[Hex](Hex)**

Returns a hexadecimal [String](String) representation of an integral value.

**[WHex](Whex)**

Returns a hexadecimal [WString](Wstring) representation of an integral value.

**[Oct](Oct)**

Returns an octal [String](String) representation of an integral value.

**[WOct](Woct)**

Returns an octal [WString](Wstring) representation of an integral value.

**[Str](Str)**

Returns the [String](String) representation of numeric value or boolean.

**[WStr](Wstr)**

Returns the [WString](Wstring) representation of numeric value.

**[Format](Format)**

Returns a formatted [String](String) representation of a [Double](Double).

***String to Numeric Conversions***

**[Val](Val)**

Returns the [Double](Double) conversion of a numeric string.

**[ValInt](Valint)**

Returns the [Integer](Integer) conversion of a numeric string.

**[ValLng](Vallng)**

Returns the [Long](Long) conversion of a numeric string.

**[ValUInt](Valuint)**

Returns the [UInteger](Uinteger) conversion of a numeric string.

**[ValULng](Valulng)**

Returns the [ULong](Ulong) conversion of a numeric string.

***Numeric Serialization***

**[MKD](Mkd)**

Returns an eight character [String](String) representation of a [Double](Double).

**[MKI](Mki)**

Returns a four character [String](String) representation of a [Integer](Integer).

**[MKL](Mkl)**

Returns a four character [String](String) representation of a [Long](Long).

**[MKLongInt](Mklongint)**

Returns an eight character [String](String) representation of a [LongInt](Longint).

**[MKS](Mks)**

Returns a four character [String](String) representation of a [Single](Single).

**[MKShort](Mkshort)**

Returns a two character [String](String) representation of a [Short](Short).

**[CVD](Cvd)**

Returns a [Double](Double) representation of an eight character [String](String).

**[CVI](Cvi)**

Returns an [Integer](Integer) representation of a four character [String](String).

**[CVL](Cvl)**

Returns a [Long](Long) representation of a four character [String](String).

**[CVLongInt](Cvlongint)**

Returns a [LongInt](Longint) representation of an eight character [String](String).

**[CVS](Cvs)**

Returns a [Single](Single) representation of a four character [String](String).

**[CVShort](Cvshort)**

Returns a [Short](Short) representation of a two character [String](String).

***Working with Substrings***

**[Left](Left)**

Returns a substring of the leftmost characters in a string.

**[Mid (Function)](Mid-Function)**

Returns a substring of a string.

**[Right](Right)**

Returns a substring of the rightmost characters in a string.

**[LCase](Lcase)**

Returns a copy of a string converted to lowercase alpha characters.

**[UCase](Ucase)**

Returns a copy of a string converted to uppercase alpha characters.

**[LTrim](Ltrim)**

Removes surrounding substrings or characters on the left side of a string.

**[RTrim](Rtrim)**

Removes surrounding substrings or characters on the right side of a string.

**[Trim](Trim)**

Removes surrounding substrings or characters on the left and right side of a string.

**[InStr](Instr)**

Returns the first occurrence of a substring or character within a string.

**[InStrRev](Instrrev)**

Returns the last occurrence of a substring or character within a string.

**[Mid (Statement)](Mid-Statement)**

Copies a substring to a substring of a string.

**[LSet](Lset)**

Left-justifies a string.

**[RSet](Rset)**

Right-justifies a string.

---

**Category:** [String Functions](Category-String-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

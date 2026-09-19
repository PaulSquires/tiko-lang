[Home](Home) › [String Functions](Category-String-Functions) › **Len**

# Len

Returns the length of an expression or data type

## Syntax

```freebasic
Declare Function Len ( ByRef expression As String ) As Integer
Declare Function Len ( ByRef expression As ZString ) As Integer
Declare Function Len ( ByRef expression As WString ) As Integer
Declare Operator Len ( ByRef expression As datatype ) As datatype
Declare Function Len ( datatype ) As Integer
```

## Parameters

- `expression`
- `datatype`

## Description

`Len` returns the length of an expression or the size of a [DataType](Data-Types), in bytes.

 In the first form, if `expression` is of type [`String`](String), [`WString`](Wstring) or [`ZString`](Zstring), the length of the string in characters will be returned. If the expression is of a user defined type, an `Operator Len` compatible with that data type is called. Otherwise, the size of the `expression`'s data type in bytes is returned.

 In the second form, if `expression` is [`ZString`](Zstring) or [`WString`](Wstring), the size in bytes of an ASCII or Unicode character is returned, respectively. If `datatype` is [`String`](String), the size of the string descriptor type is returned.

 If there is both a user defined type and a variable visible with the same name in the current scope, the user defined type takes precedence over the variable. To ensure that the `Len` takes the variable instead of the user defined type, wrap the argument to `Len` with parentheses to force it to be seen as an expression. For example `Len((variable))`.

 **Note:** When used with array names, `Len` returns the length of the array datatype, but not the total number of its elements.
 For clarity, it is recommended that you avoid this potential confusion, and use `Len` on the array datatype doing `Len(Typeof(array))`, rather than the array name only doing `Len(array)`.

 The `Len` unary [`Operator`](Operator) can be overloaded with user defined types.

## Return Value

Returns the size of an expression or [DataType](Data-Types) (including the data fields of a UDT) in bytes.

## Remarks

### Usage

`result = Len( expression )`*or*`result = Len( DataType )`

### Version

- Before fbc 1.08.0:

`Len` was not returning the size of the data fields of a UDT.  
 When a variable from a given namespace was accessed with the namespace's name prefix, the argument to `Len` had to be wrapped with parentheses to force it to be seen as an expression. For example `Len((namespace_name.variable))`.

### Dialect Differences

- `Len` only allows expressions in the *[-lang qb](Compiler-Option-Lang)* dialect.
  Can be used with built-in types and user-defined types in the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### Differences from QB

- Can be used with built-in types and user-defined types in the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.
  None in the *[-lang qb](Compiler-Option-Lang)* dialect.

### See also

- [`SizeOf`](Sizeof)

## Examples

```freebasic
Print Len("hello world") 'returns "11"

Print Len(Integer) ' returns 4

Type xyz

    a As Integer

    b As Integer

End Type

Print Len(xyz) ' returns 8
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

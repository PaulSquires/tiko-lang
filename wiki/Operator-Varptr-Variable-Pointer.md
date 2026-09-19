[Home](Home) › [Operators](Category-Operators) › **Operator Varptr (Variable Pointer)**

# Operator Varptr (Variable Pointer)

Returns the address of a variable or object

## Syntax

```freebasic
Declare Operator VarPtr ( ByRef lhs As T ) As T Ptr
result = VarPtr ( lhs )
```

## Parameters

- `lhs`
- `T`

## Description

This operator returns the address of its operand.

 When the operand is of type [`String`](String), the address of the internal string descriptor is returned. Use [`Operator Strptr (String Pointer)`](Operator-Strptr-String-Pointer) to retrieve the address of the string data.

 The operand cannot be an array, but may be an array element. For example, `"VarPtr(myarray(0))"` returns the address of `"myarray(0)"`.

 [`Operator @ (Address Of)`](Operator-Address-of), when used with variables or objects, has identical behavior.

## Return Value

Returns the address of a variable or object.

## Remarks

### Differences from QB

- None

### See also

- [Pointers](Pointers)
- [`Peek`](Poke)
- [`Poke`](Poke)

## Examples

```freebasic
Dim a As Integer, addr As Integer

a = 10

'' place the address of a in addr

addr = CInt( VarPtr(a) )

'' change all 4 bytes (size of INTEGER) of a

Poke Integer, addr, -1000

Print a

'' place the address of a in addr (same as above)

addr = CInt( @a )

'' print the least or most significant byte, depending on the CPU endianess

Print Peek( addr )
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

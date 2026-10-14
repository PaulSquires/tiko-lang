[Home](Home) › [Operators](Category-Operators) › **Operator * (Value Of)**

# Operator * (Value Of)

Dereferences a pointer

## Syntax

```freebasic
Declare Operator * ( ByRef rhs As T Pointer ) ByRef As T
```

## Parameters

- `rhs`
- `T`

## Description

**`Operator *` (Value of)** returns a reference to the value stored at an address, and is often called the dereference operator. The operand is not modified in any way.
 Any type of [`Pointer`](Pointer-Ptr) can be dereferenced except for an [`Any`](Any) [`Pointer`](Pointer-Ptr).

 As a reference, the result of this operator can be used on the left-hand side of assignments.

 This operator must not be used in case of null pointer because reference is undefined (inducing runtime error).  
 Otherwise, the user must ensure that the pointer value induces access to a valid memory. Otherwise, results are undefined.

 This operator can be overloaded for user-defined types.

## Return Value

Returns a reference to the value stored at the address `rhs`.

## Remarks

### Usage

```freebasic
result = * rhs

or

* rhs = value
```

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator @ (Address Of)`](Operator-Address-of)
- [`Operator [] (Pointer Index)`](Operator-Pointer-Index)

## Examples

```freebasic
'This program demonstrates the use of * to utilize the value a pointer points to.

Dim a As Integer

Dim pa As Integer Ptr

pa=@a 'Here, we use the @ operator to point our integer ptr at 'a'.

' 'a' is, in this case, a standard integer variable.

a=9     'Here we give 'a' a value of 9.

Print "The value of 'a' is";*pa 'Here, we display the value of 'a' using a pointer.

*pa = 1 'Here we use our pointer to change the value of 'a'

Print "The new value of 'a' is";a 'Here we display the new value of 'a'.
```

 Output:

```freebasic
The value of 'a' is 9
The new value of 'a' is 1
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

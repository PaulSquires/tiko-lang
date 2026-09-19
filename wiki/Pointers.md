[Home](Home) › [Tutorials](Category-Tutorials) › **Pointers**

# Pointers

Data types whose values are addresses in memory.

Declaration

Pointers are [Variables](Variables) whose values are addresses in memory, and they are said to 'point' to this memory. The type of data that is pointed to depends on the type of pointer (an `Integer Pointer` points to [`Integer`](Integer) data). Pointers are declared like any other variable, with the suffix "`pointer`" or "`ptr`" following the type name.

Assigning pointer variables

A pointer is a memory address and the value of the pointer itself is that memory address. To assign a pointer variable is to assign it a memory address to something. One way to assign a pointer a memory address is to take the address of some other variable in the program using [`Operator @`](Operator-Address-of) (Address of).

Accessing pointed to data

The data pointed to by a pointer can be accessed with [`Operator *`](Operator-Value-of) (Value of). This operator returns a reference to the data that its operand points to. The following,

```freebasic
Dim myInteger As Integer = 10

Dim myPointer As Integer Pointer = @myInteger

*myPointer = 20

Print myInteger
```

 defines an [`Integer`](Integer) variable called `myInteger` and an [`Integer`](Integer) pointer called `myPointer` that points to the location in memory where `myInteger` is stored. [`Operator @`](Operator-Address-of) (Address of) is used to retrieve the address of `myInteger`. The value of `20` is assigned to the location at which `myPointer` points - the address of `myInteger`, or `@myInteger`. Changes to `*myPointer` directly affect the value of `myInteger` (the expression "`*myPointer`" is the same thing as "`myInteger`").

Pointers to user-defined types

Pointers to user-defined types are defined and used like all other pointers. Accessing a member of a [Type](Type-Udt) or [Class](Class) requires one of the following two methods:

```freebasic
Type myType

    a As Integer

    b As Double

End Type

Dim x As myType

Dim p As myType Pointer = @x

'' 1) dereference the pointer and use the member access operator:

(*p).a = 10

(*p).b = 12.34

'' 2) use the shorthand form of the member access operator:

Print p->a

Print p->b
```

 The first method uses [`Operator . (Member Access)`](Operator-Member-Access). This operator accesses members from references, so the pointer is dereferenced first. The member access operator has higher priority over the dereference operator, so parenthesis are needed to dereference the pointer before using it with the member access operator.

 The second method uses [`Operator -> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access). This operator accesses members from pointers, which are automatically dereferenced. This can make code a little clearer, although both forms produce identical results.

See also

- [`Operator @ (Address Of)`](Operator-Address-of)
- [`Operator * (Value Of)`](Operator-Value-of)
- [`Operator . (Member Access)`](Operator-Member-Access)
- [`Operator -> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access)
- [`VarPtr`](Operator-Varptr-Variable-Pointer)
- [`StrPtr`](Operator-Strptr-String-Pointer)
- [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

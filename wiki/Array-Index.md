[Home](Home) › [Tutorials](Category-Tutorials) › **Array Index**

# Array Index

An array index is the number used to access an [Array](programmer-s-guide-Arrays) of [Variables](Variables) created using the [`Dim`](Dim) command.

Description

The following examples illustrate the use of array elements.

 If we have an array `myArray` with elements of 1 to 10, filled with random data:

```freebasic
Index        Data
1              5
2              2
3              6
4              5
5              9
6              1
7              0
8              4
9              5
10             7
```

 One can access each piece of data separately by pointing to the Index of the array element:  
 `Print myArray(5)`  
 Printing the data contained in the fifth element of `myArray` results in an output of:

```freebasic
	9

```

To change the contents of an array, use it like any other [Variable](Variables):  
 `myArray(3) = 0`  
 To print the contents of `myArray(3)`, use the command:  
 `Print myArray(3)`  
 Which results in an output of:

```freebasic
	0

```

Array elements can be indexed using another [Variable](Variables). In this example we set all elements in our array to zero:

```freebasic
Dim a As Integer

    For a = 1 To 10

      myArray(a) = 0

    Next a
```

 To change a random array element to a random value:

```freebasic
Dim Index As Integer

    Dim Value As Integer

    index = Int(Rnd(1) * 10) + 1 'This line will simply return a random value between 1 and 10

    Value = Int(Rnd(1) * 10) + 1 'This line will do the same

    myArray(index) = Value
```

Example

```freebasic
Declare Sub PrintArray()

Dim Numbers(1 To 10) As Integer

Dim Shared OtherNumbers(1 To 10) As Integer

Dim a As Integer

Numbers(1) = 1

Numbers(2) = 2

OtherNumbers(1) = 3

OtherNumbers(2) = 4

PrintArray ()

For a = 1 To 10

 Print Numbers(a)

Next a

Print OtherNumbers(1)

Print OtherNumbers(2)

Print OtherNumbers(3)

Print OtherNumbers(4)

Print OtherNumbers(5)

Print OtherNumbers(6)

Print OtherNumbers(7)

Print OtherNumbers(8)

Print OtherNumbers(9)

Print OtherNumbers(10)

Sub PrintArray ()

 Dim a As Integer

 For a = 1 To 10

   Print otherNumbers(a)

 Next a

End Sub
```

See also

- [Arrays Overview](programmer-s-guide-Arrays)
- [`Dim`](Dim)
- [`Function`](procedures-Function)
- [`Sub`](Sub)
- [Variables](Variables)
- [Variable Scope](Variable-Scope)
- [`Standard Data Type Limits`](Standard-Data-Type-Limits)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

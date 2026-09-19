[Home](Home) › [Tutorials](Category-Tutorials) › **Pointers, Data Types and Memory**

# Pointers, Data Types and Memory

*Written by [rdc](Rdc)*

 If you read the article [Introduction to Pointers](Introduction-to-Pointers) you know that pointers contain memory location addresses. You can manipulate the data in these memory locations using the dereference operator \*. Using pointers with single data item isn't a problem, but what if you need to store multiple data items together and manipulate them using a pointer? It can get a bit tricky unless you understand how data is stored in memory.

 A single memory location in a computer is 1 byte long. Big enough to hold a single ANSI character (as opposed to Unicode characters, which are wide characters and are two bytes. We won't be discussing Unicode characters in this article.) However, all data types are not a single byte in width. Here is a simple program that displays the length in bytes of each data type.

```freebasic
Dim a As Byte

Dim b As Short

Dim c As Integer

Dim d As LongInt

Dim au As UByte

Dim bu As UShort

Dim cu As UInteger

Dim du As ULongInt

Dim e As Single

Dim f As Double

Dim g As Integer Ptr

Dim h As Byte Ptr

Dim s1 As String * 10 'fixed string

Dim s2 As String      'variable length string

Dim s3 As ZString Ptr 'zstring

s1 = "Hello World!"

s2 = "Hello World from FreeBasic!"

s3 = Allocate( Len( s2 ) + 1 )

*s3 = s2

Print "Byte: ";Len(a)

Print "Short: ";Len(b)

Print "Integer: ";Len(c)

Print "Longint: ";Len(d)

Print "UByte: ";Len(au)

Print "UShort: ";Len(bu)

Print "UInteger: ";Len(cu)

Print "ULongint: ";Len(du)

Print "Single: ";Len(e)

Print "Double: ";Len(f)

Print "Integer Pointer: ";Len(g)

Print "Byte Pointer: ";Len(h)

Print "Fixed String: ";Len(s1)

Print "Variable String: ";Len(s2)

Print "ZString: ";Len(*s3)

Deallocate s3

Sleep
```

 The output is (on 32bit systems):

```freebasic
Byte:  1

Short:  2

Integer:  4

LongInt:  8

UByte:  1

UShort:  2

UInteger:  4

ULongInt:  8

Single:  4

Double:  8

Integer Pointer:  4

Byte Pointer:  4

Fixed String:  10

Variable String:  27

ZString:  27
```

 Notice that the length of a pointer is always 4 bytes long on 32bit systems or 8 bytes long on 64bit systems, the same as an integer, regardless of the data being pointed to, since a pointer contains a memory address and not data.

 Looking at the length of the different data types, you can see that if you were to [Allocate](Allocate) enough space for 10 integers, it would take 40/80 bytes of memory (on 32/64bit systems). Each integer takes up 4/8 bytes (on 32/64bit systems). So the question is, how do you access each integer value from the memory buffer? The answer, pointer math. Take a look at the following program.

```freebasic
Dim aptr As Integer Ptr

'Allocate enough space for 2 integers

aptr = Allocate(Len(Integer) * 2)

'Load our first integer

*aptr = 1

Print "Int #1:", "address: "; aptr, "value: "; *aptr

'Move the pointer to the next integer position

'aptr + 1

'Load our second integer

*(aptr + 1) = 2

Print "Int #2:", "address: "; aptr + 1, "value: "; *(aptr + 1)

Deallocate aptr

Sleep
```

 In this program we dimension two variables, an [Integer](Integer) and an [Integer](Integer) [Pointer](Pointer-Ptr), aptr. Aptr will point to our memory buffer that will contain two integers. The [Allocate](Allocate) function requires the size of the buffer we need, so we multiply the size of an [Integer](Integer) by 2 to reserve 8/16 bytes of memory (on 32/64bit systems, each integer will take 4/8 bytes of space (on 32/64bit systems).

 After the allocation process, aptr contains the address of the first byte of our memory buffer. Storing the first integer is simply a matter of using the dereference operator and setting the value to 1. To print out the value, we again just use \*aptr.

 Now, let me ask you a question: How does the compiler know that the value 1 requires 4/8 bytes (on 32/64bit systems) and not 1 or 2 bytes? Because we dimensioned aptr as an *integer ptr*. The compiler knows that an integer takes 4/8 bytes (on 32/64bit systems) and so loads the data into four bytes of memory. This is why when we print out the value we get 1 and not some strange number.

 To load the second value into our buffer, we use:

 `*(aptr + 1) = 2`

 This may look a little strange at first glance. Aptr points to the first byte in our memory buffer. An integer is 4/8 bytes long (on 32/64bit systems), so to get to the next integer byte position, we must add 4/8 to the address (value of aptr). But the compiler knows that the data being used with this pointer is of size Integer or 4/8 bytes (on 32/64bit systems), so to access the second element, you need to only add 1 to the pointer, which can be expressed as \*(aptr + 1).  
 We need the parenthesis around the add operation because the dereference operator \* has a higher precedence than +. The parenthesis ensure that we perform the add operation first, and then apply the indirection operator.

 Notice that we didn't increment aptr directly. If we did, aptr would no longer point to the start of the memory buffer and the program would crash when we deallocated the buffer since it would [Deallocate](Deallocate) memory outside the memory buffer. If the need arises to directly increment a pointer, then create a temporary pointer variable and increment that, rather than the pointer used in the original allocation.

 Memory buffers and pointers are a powerful way to store and manipulate data in memory. Care must be taken though to ensure that you are accessing the data correctly according to the type of data being stored in the buffer.

 *Last reviewed by sancho3 on February 07, 2018*

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

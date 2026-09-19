[Home](Home) › [Tutorials](Category-Tutorials) › **Introduction to Pointers**

# Introduction to Pointers

*Written by [rdc](Rdc)*

 **What is a Pointer?**

 A pointer is a 4-byte data type (on 32bit systems) or 8-byte data type (on 64bit systems) that holds an address to a memory location. A pointer doesn't contain data, it points to data once it has been initialized. An uninitialized pointer points to nothing and is undefined.

 To understand pointers, think of an egg carton that has numbers 1 through 12 printed on the bottom of each "hole" (where you put the eggs). These holes are like memory locations in a computer; each hole, or memory location, has an address, in this example, 1 through 12. If an egg represents a data item, then an egg in hole 1 has an address of 1.

 Normally, you would access the data directly through the use of variables. When you DIMension a variable of a particular type, you are setting aside storage space for the data. You do not need to know, or care, where the data resides since you can access the data directly through the variable. This is like reaching out and picking up the egg in hole 1 (reading the data) or putting an egg in hole 1 (setting the data) without looking at the numbers written on the bottom of the hole.

 Using pointers is a bit different. Imagine you have a little scrap of paper that will represent our pointer. Right now it is blank and doesn't point to anything. This undefined pointer can't be used until it is initialized. To initialize the pointer, write a 1 on it. Now our pointer is "pointing" to hole 1 in our egg carton. To put data (an egg) in hole 1, we look at our scrap of paper, match it to hole 1 and place the egg in the hole. To retrieve the egg we do just the opposite. We match our slip of paper to hole 1 and then grab the egg. All the putting and getting of the egg has to be done through the slip of paper and is called dereferencing the pointer. That is, we get to the data through the referring address contained in the pointer, the number 1. The pointer doesn't contain the data; it contains a referring address to the data.

 In FreeBASIC we define a pointer using the [Dim](Dim) and [Ptr](Pointer-Ptr) statements:

 `Dim aptr As Integer Ptr`

 This statement corresponds to our blank piece of paper in the above example. The pointer doesn't point to anything and is undefined. If we tried to use the pointer right now, more than likely the program would crash.

 In order for a pointer to be useful, it must be initialized:

```freebasic
Dim aptr As Integer Ptr

aptr = Allocate(SizeOf(Integer))
```

 Here we are using [Allocate](Allocate) to set aside enough space in memory for an [Integer](Integer) and loading the address of that space into aptr. The [SizeOf](Sizeof) macro returns the size in bytes of the passed data type. You could use len instead of [SizeOf](Sizeof) (since .13b) if you prefer.

 Once we have initialized the pointer, we can now use it:

```freebasic
*aptr = 5

Print "aptr: "; *aptr
```

 Notice the \* prefix on aptr. The \* is the dereference operator. This is like matching the number on the slip of paper to the number on the hole in the egg carton. By using the \* operator, we are able to get at the data (egg) contained in the hole pointed at by aptr.

 Here is a complete example program:

```freebasic
Dim aptr As Integer Ptr

aptr = Allocate(SizeOf(Integer))

*aptr = 5

Print "aptr: "; *aptr

Deallocate aptr

Sleep
```

 The [Deallocate](Deallocate) function frees the memory pointed at by aptr, and makes aptr undefined once again. This is like erasing the number on our slip of paper. If we were to use aptr after deallocating it, the program would crash.

 **What Good are Pointers?**

 A major reason for adding pointers to FreeBASIC is that many external libraries require pointers to type structures and pointers to strings. For example, the Win32 API has many structures that must be filled out and then passed to a function through a pointer.

 Another use of a pointer is in a [Type](Type-Udt) definition. [Type](Type-Udt) defs in FreeBASIC can only contain fixed length strings, but what if you don't know the length of a string until the program is running? A pointer can serve this purpose.

 (It should be stated that the Type definitions can now support variable length strings.)

```freebasic
Type mytptr

    sptr As ZString Ptr

End Type

'This function will allocate space for the passed string

'and load it into a memory location, returning the

'pointer to the string.

Declare Function pSetString(ByVal s As String) As ZString Ptr

'type var

Dim mytype As mytptr

'Set a variable string into the type def

mytype.sptr = pSetString("Hello World From FreeBASIC!")

Print "aptr: "; *mytype.sptr

Deallocate(mytype.sptr)

Sleep

End

Function pSetString(ByVal s As String) As ZString Ptr

    Dim sz As ZString Ptr

    'allocate some space + 1 for the chr(0)

    sz = Allocate(Len(s) + 1)

    'load the string into the memory location

    *sz = s

    'return the pointer

    Return sz

End Function
```

 Here we define our type with a field sptr as [ZString](Zstring) [Ptr](Pointer-Ptr). Zstrings are null terminated strings and are used by many external libraries and are designed for dynamic allocations. Once we define our type we create an instance of it with the [Dim](Dim) statement:

 `Dim mytype As mytptr`

 We then call our function pSetString to get the address of the variable length string we want in our [Type](Type-Udt) def.

 `mytype.sptr = pSetString("Hello World From FreeBASIC!")`

 Remember sptr is defined as a pointer, not a string variable, so pSetString is returning a pointer (memory address) to the string not the string itself. In other words, if the string is in hole #1, pSetString returns 1.

 The function pSetString uses a temporary [ZString](Zstring) sz, to [Allocate](Allocate) space for the passed string parameter s. Because a [ZString](Zstring) is a null terminated string, we must add 1 to the length of s for the null terminator in the [Allocate](Allocate) function.

```freebasic
'allocate some space + 1 for the chr(0)

sz = Allocate(Len(s) + 1)
```

 Once we have allocated space for the string, we use the dereference operator \* to load the data into the memory location.

```freebasic
'load the string into the memory location

*sz = s
```

 We then return a pointer (the address of the string) back to our type, which is saved in mytype.sptr.

```freebasic
'return the pointer

Return sz
```

 We can now dereference the string in our type using the dereference operator.

 `Print "aptr: "; *mytype.sptr`

 Pointers can be confusing for the uninitiated, however they need not be if it is kept in mind that the pointer doesn't contain data, it simply points to some data. The pointer is a memory address, and you manipulate that data through the dereference operator \*. It really isn't much different than a normal variable.

 *Last reviewed by sancho3 on February 07, 2018*

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

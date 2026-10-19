[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Deallocate**

# Deallocate

Frees memory from Allocate, CAllocate or Reallocate; does nothing for a null pointer.

## Syntax

```freebasic
Declare Sub Deallocate cdecl ( ByVal pointer As Any Ptr )
```

## Parameters

- `pointer`

## Description

This procedure frees memory that was previously allocated with [`Allocate`](Allocate). `pointer` must be a valid pointer. After the procedure returns, `pointer` will be rendered invalid (pointing to an invalid memory address), and its use (dereferencing or calling **`Deallocate`** again) will result in undefined behavior.

 When memory was allocated to hold a string descriptor, the string must always be destroyed (setting to `"``"`) before deallocate the string descriptor (allowing to deallocate the memory taken up by the string data), otherwise, it is not possible to deallocate it later, and it may induce memory leak in the program continuation.

 Calling **`Deallocate`** on a null pointer induces no action.

## Remarks

### Usage

`Deallocate( pointer )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Deallocate`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Allocate`](Allocate)
- [`Reallocate`](Reallocate)

## Examples

The following example shows how to free previously allocated memory. Note that the pointer is set to null following the deallocation:

```freebasic
Sub DeallocateExample1()

   Dim As Integer Ptr integerPtr = Allocate( Len( Integer ) )  '' initialize pointer to

                                                               '' new memory address

   *integerPtr = 420                                     '' use pointer

   Print *integerPtr

   Deallocate( integerPtr )                              '' free memory back to system

   integerPtr = 0                                        '' and zero the pointer

End Sub

   DeallocateExample1()

   End 0
```

 Although in this case it is unnecessary since the function immediately exits afterwards, setting the pointer to null is a good habit to get into. If the function deallocated memory from a pointer that was passed in by reference, for instance, the pointer that was used in the function call will be rendered invalid, and it is up to the caller to either reassign the pointer or set it to null. Example 3 shows how to correctly handle this kind of situation, and the next example shows the effects of deallocating memory with multiple references.

 In the following example, a different pointer is used to free previously allocated memory:

```freebasic
'' WARNING: "evil" example showing how things should NOT be done

Sub DeallocateExample2()

   Dim As Integer Ptr integerPtr = Allocate( Len( Integer ) )

   '' initialize ^^^ pointer to new memory

   Dim As Integer Ptr anotherIntegerPtr = integerPtr

   '' initialize ^^^ another pointer to the same memory

   *anotherIntegerPtr = 69                     '' use other pointer

   Print *anotherIntegerPtr

   Deallocate( anotherIntegerPtr )             '' free memory back to system

   anotherIntegerPtr = 0                       '' and zero other pointer

'' *integerPtr = 420                           '' undefined behavior; original

                                               '' pointer is invalid

End Sub

   DeallocateExample2()

   End 0
```

 Note that after the deallocation, *both* pointers are rendered invalid. This illustrates another one of the ways that bugs can arise when working with pointers. As a general rule, only deallocate memory previously allocated when you know that there is only one (1) pointer currently pointing at it.

```freebasic
Function createInteger() As Integer Ptr

   Return Allocate( Len( Integer ) )                     '' return pointer to newly

End Function                                             '' allocated memory

Sub destroyInteger( ByRef someIntegerPtr As Integer Ptr )

   Deallocate( someIntegerPtr )                          '' free memory back to system

   someIntegerPtr = 0                                    '' null original pointer

End Sub

Sub DeallocateExample3()

   Dim As Integer Ptr integerPtr = createInteger()       '' initialize pointer to

                                                         '' new memory address

   *integerPtr = 420                                     '' use pointer

   Print *integerPtr

   destroyInteger( integerPtr )                          '' pass pointer by reference

   Assert( integerPtr = 0 )                              '' pointer should now be null

End Sub

   DeallocateExample3()

   End 0
```

 In the program above, a reference pointer in a function is set to null after deallocating the memory it points to. An [`Assert`](Assert) macro is used to test if the original pointer is in fact null after the function call. This example implies the correct way to pass pointers to functions that deallocate the memory they point to is by reference.

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

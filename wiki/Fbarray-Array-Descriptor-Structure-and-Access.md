[Home](Home) › [Array Functions](Category-Array-Functions) › **Fbarray (Array Descriptor Structure And Access)**

# Fbarray (Array Descriptor Structure And Access)

Holds an array's descriptor: its bounds, sizes and data pointers.

## Syntax

```freebasic
From ./inc/fbc-int/array.bi:
# If __FB_LANG__ = "fb"
Namespace FBC
# endif
Const FB_MAXDIMENSIONS As Integer = 8
Type FBARRAYDIM
Dim As UInteger elements '' number of elements
Dim As Integer LBound '' dimension lower bound
```

## Parameters

- `pd`
- `array`

## Description

At compile time, the compiler allocates an array descriptor to store and track information about the array.

 If the number of dimensions is unknown at compile time, then the full `FB_MAXDIMENSIONS` is allocated in the `dimTb()` field. Otherwise, if the number dimensions is known at compile time, then only the number of dimensions needed are allocated.  
 Therefore the allocated `FBARRAY` data may be smaller than the declared `FBARRAY` structure:

allocated `FBARRAY` data size (in bytes) = `Sizeof(FBARRAY) - (FB_MAXDIMENSIONS - (FBARRAY.flags And FBARRAY_FLAGS_DIMENSIONS)) * Sizeof(FBARRAYDIM)`

If an array is passed as argument to a procedure, an array descriptor is allocated. However, if the array is static, fixed length, and never passed as an argument, then all information about the array is known at compile time, including memory locations, and the allocation of a descriptor is optimized out, since all expressions involving the array are compile time constant.

 The array descriptor may also be allocated at run time, as would be in the case of allocating a new UDT containing a variable-length array field member.

 ***WARNING:*** It is inadvisable (especially for a non advanced user) to change the data values ​​of the array descriptor (internal structure of the compiler).
 For that, it is safer to use rather the function `ArrayConstDescriptorPtr()` initializing a pointer declared `As Const FBARRAY Ptr` (or implicitly declared in this way by `Var`).

## Remarks

### Usage

```freebasic
#include once "fbc-int/array.bi"

using FBC

' then:

Dim pd As FBARRAY Ptr

...

pd = ArrayDescriptorPtr ( array() )

' or safer:

Dim pd As Const FBARRAY Ptr

...

pd = ArrayConstDescriptorPtr ( array() )
```

### FBARRAY.index_ptr Pointer to the array data @array(0, 0, ...). This pointer may be outside of the actual array data as a kind of virtual pointer to use when calculating offsets using indexes in to the array. FBARRAY.base_ptr Pointer to the array's memory at the array's lowest bound. For variable-length arrays allocated at run time, this points to the allocated memory region (i.e. malloc) FBARRAY.size Total size in bytes of the array data. Size is equal to total number of elements in the array (all dimensions) multiplied by element length. i.e. size = dimTb(0).elements \* element_len + dimTb(1).elements \* element_len + ... FBARRAY.element_len Size in bytes of an individual element. Must be set to non-zero value. FBARRAY.dimensions Number of valid dimensions in the dimTb() table. A value of zero (0) indicates that dimTb() has FB_MAXDIMENSIONS avaiable, but the array does not yet have number of dimensions defined. On first REDIM, the number of dimensions will be set. FBARRAY.flags The flags field contains information about the array descriptor that needs to be known at run time. FBARRAY_FLAGS_DIMENSIONS : a 4 bit field to indicate the number of elements allocated in dimTb(). If the compiler can determine at compile time that less than FB_MAXDIMENSIONS are needed to represent the array, then only the number of dimensions needed are allocated in dimTb(). The real size allocated for the array descriptor can be calculated by: Sizeof(FBC.FBARRAY) - (FBC.FB_MAXDIMENSIONS - (FBC.ArrayDescriptorPtr(array())->flags And FBC.FBARRAY_FLAGS_DIMENSIONS)) \* Sizeof(FBC.FBARRAYDIM) FBARRAY_FLAGS_FIXED_DIM : if this bit is set, indicates that the number of dimensions are set and are given in dimTb() and must not be changed. FBARRAY_FLAGS_FIXED_LEN : if this bit is set, indicates that the array data is fixed length and must not be resized or reallocated FBARRAY_FLAGS_RESERVED : all other bits are reserved for future use FBARRAY.dimTb() dimTb() is an array of FBARRAYDIM to indicate the bounds of each dimension. If the number of dimensions is unknown at compile time, then the full FB_MAXDIMENSIONS is allocated in the dimTb() field. Otherwise, if the number dimensions is known at compile time, then only the number of dimensions needed are allocated. Therefore the allocated FBARRAY data may be smaller than the declared FBARRAY structure. FBARRAYDIM.elements Number of elements in the dimension. i.e. (ubound-lbound+1) FBARRAYDIM.lbound Lower bound is the lowest valid index in this dimension. FBARRAYDIM.ubound Upper bound is the highest valid index in this dimension. ArrayDescriptorPtr( array() as any ) as FBC.FBARRAY ptr Retrieves a pointer to the array descriptor, returning a pointer to FBC.ARRAY that can be modified (the array descriptor thus referenced is valid until the end of the scope where it is created). ArrayConstDescriptorPtr( array() as const any ) as const FBC.FBARRAY ptr Retrieves a pointer to the array descriptor, returning a pointer to FBC.ARRAY that is read only (the array descriptor thus referenced is valid until the end of the scope where it is created). Example

 Very simple syntaxic example highlighting the access capabilities to the data fields of an array descriptor:

```freebasic
#include "fbc-int/array.bi"

Sub printArrayDescriptor (ByVal p As Any Ptr, ByVal tabulation As Integer = 0, ByRef title As String = "")

    Dim As FBC.FBARRAY Ptr pd = p

    Dim As Integer t = 0

    If title <> "" Then

        Print title

        t = 1

    End If

    Print Space((t    ) * tabulation) & "[@array descriptor: @&h"; Hex(pd, 2 * SizeOf(Any Ptr)) & " / "; _

                                                                   SizeOf(FBC.FBARRAY) - (8 - pd->dimensions) * 3 * SizeOf(Integer) & " bytes]"'

    Print Space((t + 1) * tabulation) & "@array(all_null_indexes)      =&h"; Hex(pd->index_ptr, 2 * SizeOf(Any Ptr))

    Print Space((t + 1) * tabulation) & "@array(all_min_indexes)       =&h"; Hex(pd->base_ptr, 2 * SizeOf(Any Ptr))

    Print Space((t + 1) * tabulation) & "array_total_size_in_bytes     ="; pd->size

    Print Space((t + 1) * tabulation) & "array_element_size_in_bytes   ="; pd->element_len

    Print Space((t + 1) * tabulation) & "number_of_array_dimensions    ="; pd->dimensions

    Print Space((t + 1) * tabulation) & "fixed_len/fixed_dim/dimensions="; (pd->flags And FBC.FBARRAY_FLAGS_FIXED_LEN) Shr 5 & "/"; _

                                                                           (pd->flags And FBC.FBARRAY_FLAGS_FIXED_DIM) Shr 4 & "/"; _

                                                                           (pd->flags And FBC.FBARRAY_FLAGS_DIMENSIONS)

    For i As Integer = 0 To pd->dimensions - 1

        Print Space((t + 1) * tabulation) & "[dimension number:"; i + 1; "]"

        Print Space((t + 2) * tabulation) & "number_of_elements="; pd->dimTb(i).elements

        Print Space((t + 2) * tabulation) & "min_index         ="; pd->dimTb(i).LBound

        Print Space((t + 2) * tabulation) & "max_index         ="; pd->dimTb(i).UBound

    Next i

End Sub

Screen 0

Width , 35

Dim As LongInt test1(0 To 9, 1 To 100)

printArrayDescriptor(FBC.ArrayDescriptorPtr(test1()), 4, "'Dim As Longint test1(0 to 9, 1 to 100)':")

Sleep

Cls

Dim As LongInt test2()

printArrayDescriptor(FBC.ArrayDescriptorPtr(test2()), 4, "'Dim As Longint test2()':")

Print

ReDim test2(0 To 9, 1 To 100)

printArrayDescriptor(FBC.ArrayDescriptorPtr(test2()), 4, "'Redim test2(0 to 9, 1 to 100)':")

Sleep

Cls

Dim As LongInt test3(Any, Any)

printArrayDescriptor(FBC.ArrayDescriptorPtr(test3()), 4, "'Dim As Longint test3(Any, Any)':")

Print

ReDim test3(0 To 9, 1 To 100)

printArrayDescriptor(FBC.ArrayDescriptorPtr(test3()), 4, "'Redim test3(0 to 9, 1 to 100)':")

Sleep
```

 Output example (32-bit):

```freebasic
'Dim As Longint test1(0 to 9, 1 to 100)':
	[@array descriptor: @&h0019DE70 / 48 bytes]
		@array(all_null_indexes)      =&h0019DE98
		@array(all_min_indexes)       =&h0019DEA0
		array_total_size_in_bytes     =8000
		array_element_size_in_bytes   =8
		number_of_array_dimensions    =2
		fixed_len/fixed_dim/dimensions=1/1/2
		[dimension number: 1]
			number_of_elements=10
			min_index         = 0
			max_index         = 9
		[dimension number: 2]
			number_of_elements=100
			min_index         = 1
			max_index         = 100

```

```freebasic
'Dim As Longint test2()':
	[@array descriptor: @&h0019DDF8 / 24 bytes]
		@array(all_null_indexes)      =&h00000000
		@array(all_min_indexes)       =&h00000000
		array_total_size_in_bytes     =0
		array_element_size_in_bytes   =8
		number_of_array_dimensions    =0
		fixed_len/fixed_dim/dimensions=0/0/8

'Redim test2(0 to 9, 1 to 100)':
	[@array descriptor: @&h0019DDF8 / 48 bytes]
		@array(all_null_indexes)      =&h01FD2AB8
		@array(all_min_indexes)       =&h01FD2AC0
		array_total_size_in_bytes     =8000
		array_element_size_in_bytes   =8
		number_of_array_dimensions    =2
		fixed_len/fixed_dim/dimensions=0/0/8
		[dimension number: 1]
			number_of_elements=10
			min_index         = 0
			max_index         = 9
		[dimension number: 2]
			number_of_elements=100
			min_index         = 1
			max_index         = 100

```

```freebasic
'Dim As Longint test3(Any, Any)':
	[@array descriptor: @&h0019DDC8 / 48 bytes]
		@array(all_null_indexes)      =&h00000000
		@array(all_min_indexes)       =&h00000000
		array_total_size_in_bytes     =0
		array_element_size_in_bytes   =8
		number_of_array_dimensions    =2
		fixed_len/fixed_dim/dimensions=0/1/2
		[dimension number: 1]
			number_of_elements=0
			min_index         = 0
			max_index         = 0
		[dimension number: 2]
			number_of_elements=0
			min_index         = 0
			max_index         = 0

'Redim test3(0 to 9, 1 to 100)':
	[@array descriptor: @&h0019DDC8 / 48 bytes]
		@array(all_null_indexes)      =&h01FD4C20
		@array(all_min_indexes)       =&h01FD4C28
		array_total_size_in_bytes     =8000
		array_element_size_in_bytes   =8
		number_of_array_dimensions    =2
		fixed_len/fixed_dim/dimensions=0/1/2
		[dimension number: 1]
			number_of_elements=10
			min_index         = 0
			max_index         = 9
		[dimension number: 2]
			number_of_elements=100
			min_index         = 1
			max_index         = 100

```

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC.

### See also

- [`Arraylen`](Arraylen)
- [`Arraysize`](Arraysize)

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

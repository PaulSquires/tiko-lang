[Home](Home) › [All Categories](Categories) › **Memory Functions**

# Memory Functions

<!-- finder:start -->

Grouped by task. [Memory and pointers](Functions-Memory) lists them beside the rest of the area.

## Allocate and free memory

| Function | What it does | From |
|---|---|---|
| [Allocate](Allocate) | Reserves a number of bytes and returns a pointer to them, or 0; the bytes are not cleared. | built-in |
| [CAllocate](Callocate) | Reserves memory for a number of elements, set to zero, and returns a pointer or 0. | built-in |
| [Reallocate](Reallocate) | Resizes a block, keeping its contents, and returns the new pointer, or 0 on failure. | built-in |
| [Deallocate](Deallocate) | Frees memory from Allocate, CAllocate or Reallocate; does nothing for a null pointer. | built-in |

## Read and write memory by address

| Function | What it does | From |
|---|---|---|
| [Peek](Peek) | Returns a reference to the value at an address, as a byte or as a given type. | built-in |
| [Poke](Poke) | Writes a value to an address, as a byte or as a given type. | built-in |
| [SAdd](Sadd) | Returns a pointer to the characters of a string. | built-in |

## Copy, fill and swap memory

| Function | What it does | From |
|---|---|---|
| [Fb_Memcopy](Fb-Memcopy) | Copies a number of bytes between two memory areas that do not overlap. | built-in |
| [Fb_Memmove](Fb-Memmove) | Copies a number of bytes between two memory areas, even when they overlap. | built-in |
| [fb_MemCopyClear](Fb-Memcopyclear) | Copies the first bytes of one area into another and sets the rest to zero. | built-in |
| [Clear](Clear) | Sets a number of bytes, starting at a variable, to zero or to a given value. | built-in |
| [Swap](Swap) | Exchanges the values of two variables. | built-in |

## Also in this category

- [Memory Functions](Memory-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)

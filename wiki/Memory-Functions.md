[Home](Home) › [Memory Functions](Category-Memory-Functions) › **Memory Functions**

# Memory Functions

Procedures that work with static and dynamic memory.

Description

These procedures provide access to the free store, or heap. Memory from the free store can be reserved and freed, and procedures are provided to read and write directly to that memory.

**Working with Dynamic Memory**

Procedures that reserve, resize or free dynamic memory.

**Miscellaneous Procedures**

Procedures that read or write values to and from addresses in memory.

***Working with Dynamic Memory***

**[Allocate](Allocate)**

Reserves a number of bytes of uninitialized memory and returns the address.

**[CAllocate](Callocate)**

Reserves a number of bytes of initialized (zeroed) memory and returns the address.

**[Reallocate](Reallocate)**

Changes the size of reserved memory.

**[Deallocate](Deallocate)**

Returns reserved memory back to the system.

***Miscellaneous Procedures***

**[Peek](Peek)**

Reads some type of value from an address.

**[Poke](Poke)**

Writes some type of value to an address.

**[Clear](Clear)**

Clears data in an array with a specified value.

**[Fb_Memcopy](Fb-Memcopy)**

Copies a block of memory from a location to another.  
(memory areas must not overlap)

**[fb_MemCopyClear](Fb-Memcopyclear)**

Copies the first part of a block of memory from a location to another and clears the rest.  
(memory areas must not overlap)

**[Fb_Memmove](Fb-Memmove)**

Copies a block of memory from a location to another.  
(memory areas may overlap)

**[Swap](Swap)**

Exchange the contents of two variables.

**[SAdd](Sadd)**

Returns the address for the data in a zstring/wstring variable.

See also

- [Memory Operators](Memory-Operators)

---

**Category:** [Memory Functions](Category-Memory-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

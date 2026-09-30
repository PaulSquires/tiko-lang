[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **WithCancel**

# WithCancel

a cancellable child

## Syntax

```freebasic
WithCancel( parent )
```

## Notes

- a cancellable child

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

dim root as Context
dim ctx as CancelContext = WithCancel( root )

print ctx.IsCancelled( )     '' false

ctx.Cancel( )                '' the caller decides when
print ctx.IsCancelled( )     '' true
print ctx.Err( )             '' cancelled

'' Cancelling a parent cancels its children too, so one Cancel( ) at the
'' top shuts down a whole tree of workers
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

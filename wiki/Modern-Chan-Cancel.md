[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Cancel**

# Cancel

Cancels a `CancelContext`, and every context descended from it.

## Syntax

```freebasic
Cancel( )
```

## Notes

- **Nothing is killed.** Cancellation is a request that a goroutine notices, or does not -- `TerminateThread` would skip destructors and `defer` blocks and leak every mutex the thread held.
- Cancelling a parent cancels its children, so one call shuts down a whole tree of workers.
- Cancelling twice is harmless; the first one wins and `Err` stays `cancelled`.
- After it, `IsCancelled` is TRUE and the channel from `Done` is closed -- which is how a `select` learns about it.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim root as Context
dim ctx as CancelContext = WithCancel( root )

print ctx.IsCancelled( )     '' false
ctx.Cancel( )
print ctx.IsCancelled( )     '' true
print ctx.Err( )             '' cancelled

'' Harmless twice -- the first one wins
ctx.Cancel( )
print ctx.Err( )             '' cancelled

'' NOTHING IS KILLED: a goroutine that never checks its context keeps
'' running, and that is deliberate
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

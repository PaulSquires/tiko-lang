[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **WithTimeout**

# WithTimeout

cancels itself when the deadline passes

## Syntax

```freebasic
WithTimeout( parent, ms )
```

## Notes

- cancels itself when the deadline passes

## Examples

```freebasic
#import "std/tasks"
using tasks

dim root as Context
dim ctx as CancelContext = WithTimeout( root, 50 )

print ctx.IsCancelled( )     '' false

sleep 150, 1
print ctx.IsCancelled( )     '' true
print ctx.Err( )             '' deadline exceeded -- NOT "cancelled"

'' The timeout is a goroutine parked with a deadline, so it costs one
'' pool worker for the duration. Cancelling early unparks it, so it does
'' not outlive the context.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

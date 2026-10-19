[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **IsNil**

# IsNil

Returns true for a default-constructed channel, which blocks forever if used.

## Syntax

```freebasic
IsNil( ) as boolean
```

## Notes

- A **nil channel blocks forever** on `Send` and `Receive`. That is Go's rule, and it looks like a defect until `select` arrives -- where assigning a nil channel is how a case is disabled.
- This exists so a program can assert its own initialisation, because *"my program hangs"* is the symptom of forgetting it.
- `Close` on a nil channel raises.

## Examples

```freebasic
#import "std/tasks"
using tasks

dim ch as Channel( of int32 )
print ch.IsNil( )            '' true -- default-constructed

'' Assert initialisation before anything blocks on it, because the
'' symptom of forgetting is a hang with no message
if ch.IsNil( ) then print "not initialised"

ch = Channel( of int32 )( 4 )
print ch.IsNil( )            '' false
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members

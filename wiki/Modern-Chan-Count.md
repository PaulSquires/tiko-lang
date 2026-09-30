[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Count**

# Count

## Syntax

```freebasic
Count( )
```

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

dim wg as WaitGroup
print wg.Count( )            '' 0

wg.Add( 3 )
print wg.Count( )            '' 3

wg.Done( )
print wg.Count( )            '' 2

'' Read under the lock, so it is a consistent snapshot -- but it is only
'' a snapshot. Do not branch on it to decide whether to wait; call
'' Wait( ) or WaitFor( ), which cannot race.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Waitgroup  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

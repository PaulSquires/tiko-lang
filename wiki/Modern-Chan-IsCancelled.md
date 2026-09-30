[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **IsCancelled**

# IsCancelled

## Syntax

```freebasic
IsCancelled( )
```

## Examples

```freebasic
#include once "fb/sync.bi"
using FB

dim root as Context
dim ctx as CancelContext = WithCancel( root )

print ctx.IsCancelled( )     '' false
ctx.Cancel( )
print ctx.IsCancelled( )     '' true

'' A poll, for a loop that can check between units of work:
''     do while not ctx.IsCancelled( )
''         ... one chunk ...
''     loop
''
'' To BLOCK until cancellation instead, select on Done( ) -- a closed
'' channel is permanently ready, so that case fires at once and forever.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context  
**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

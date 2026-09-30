[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.UnixMicroseconds**

# Instant.UnixMicroseconds

## Syntax

```freebasic
Instant.UnixMicroseconds
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as Instant i = Instant.FromUnixMilliseconds( 1500 )

print i.UnixMicroseconds     '' 1500000
print i.UnixMilliseconds     '' 1500

'' The finest Unix-epoch form. Below this, use Ticks (100 ns).
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

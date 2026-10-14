[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyRefreshLocale**

# MoneyRefreshLocale

Re-reads the monetary settings from the system -- after the user has changed Settings > Region, say.

## Syntax

```freebasic
MoneyRefreshLocale( )
```

## Notes

- The settings are read once, lazily, into a snapshot, because `setlocale` is process-global and `GetLocaleInfoEx` is comparatively slow. This is how you ask for a fresh read.
- NOT thread-safe against a concurrent format: it rewrites the snapshot another thread may be reading. A lock on every `ToString` would cost more than the feature is worth.
- The snapshot is a `dim shared` in `std/money`, and a module exists once per program, so there is one snapshot and this refreshes it for every caller.

## Examples

```freebasic
'' the user changed their Region settings while the program was running
MoneyRefreshLocale( )
RepaintEveryAmount( )
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting

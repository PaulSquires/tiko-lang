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
- A `dim shared` in a .bi included by two modules gives two of them, so this refreshes the CALLING module's snapshot -- the same wall `fb/scheduler.bi` and `fb/logger.bi` describe. In practice one module formats money.

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
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

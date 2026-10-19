[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyLocaleIsValid**

# MoneyLocaleIsValid

Returns false if the system rejected the money locale.

## Syntax

```freebasic
MoneyLocaleIsValid( ) as boolean
```

## Notes

- This exists because the failure is otherwise SILENT. On Linux an ungenerated locale leaves every `lconv` field at its C value -- empty strings, and 127 in `frac_digits` and the sign positions -- with nothing to say the locale was never applied.
- musl has no `LC_MONETARY` at all and always reports C-locale monetary values. glibc and msvcrt are fine.
- Formatting still works when it is false; the fallbacks are `.`, `,`, `3;0` repeating, two fraction digits, symbol first, no space, sign before all. A symbol is never invented, so an amount simply renders without one.

## Examples

```freebasic
if MoneyLocaleIsValid( ) = false then
    dim as MoneyFormat m
    m.Symbol = "$"                  '' we know what currency we are in
end if
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting

[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Unlock**

# Unlock

Removes a previous access restriction (lock) on a file

## Syntax

```freebasic
Unlock #filenum, record
Unlock #filenum, start To end
```

## Parameters

- `filenum`
- `record`
- `start`
- `end`

## Description

`Unlock` removes the temporary access restriction set by [`Lock`](Lock).

 It is strongly recommended to use the same arguments used in the previous [`Lock`](Lock).

 **Note: This command does not always work, neither as documented nor as expected. It appears to be broken at the moment.**

## Remarks

### Differences from QB

- Currently, FB cannot implicitly unlock the entire file
- In [`Random`](Random) mode, FB cannot unlock a range of records

### See also

- [`Lock`](Lock)
- [`Open`](Open)
- [`ScreenUnlock`](Screenunlock)

## Examples

For an example see [`Lock`](Lock).

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

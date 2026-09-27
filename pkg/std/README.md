# std

The tiko standard package: modules shipped with the compiler, imported as
`#import "std/strings"`. `std` always resolves here, never to a project's own package of
that name (RFC-0007 §3, §5).

| Module | What it is |
|---|---|
| `std/strings` | `StartsWith`, `EndsWith`, `Contains`, `Replace`, `Repeat`, `Split`, and the generic `Surround` |
| `std/path` | `Separator`, `JoinPath`, `DirName`, `BaseName`, `Extension`, `IsAbsolute` |

These are the v1 pilot (RFC-0007 §6): small, written as modules from the start, and there
to prove the module system on real code. The header libraries (`containers.bi`, `fb/tui.bi`,
the goroutine headers) stay `#include` libraries.

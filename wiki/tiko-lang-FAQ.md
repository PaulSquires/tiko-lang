# FAQ

**Will my existing FreeBASIC code still compile?**
Yes. Everything is additive, and the only construct that changes meaning is a paren-less call in statement position to a sub named `defer`. See [Compatibility](Compatibility).

**Is this a fork I have to switch to?**
It is a *provable testing ground* for the new features, offered upstream. The stated goal is for this project to cease to exist because its features have landed in the canonical FreeBASIC compiler. See [What Is tiko-lang](What-Is-tiko-lang).

**Do I have to build a compiler?**
No. Prebuilt Windows and Linux compilers are committed to the repository — clone it and run one. See [Quick Start](Quick-Start).

**Which targets are supported?**
win64 and linux-x86_64. 32-bit x86 was dropped: `-target win32` and `-target linux-x86` are refused, and no `fbc32.exe` ships. 32-bit x86 remains reachable for `dos` and `xbox` only, which have no 64-bit form. There is no macOS build; that tree has never been built on darwin.

**Which backends?**
`gcc`, `gas64` and `llvm` on the supported targets, all three first class. `gas` is the 32-bit x86 backend and so is reachable only through `dos`/`xbox`. Every feature works on every backend on every supported target. `-gen llvm` needs a system `clang` 18 or newer on `PATH`, and rejects inline `ASM`/`NAKED` with a real diagnostic rather than miscompiling them.

**Are generics macros?**
No. A generic body is captured as a token chain at declaration and replayed through the real parser once per distinct type-argument list. The code inside is ordinary FreeBASIC and is diagnosed as such — at the body, plus the instantiation chain that reached it. See [Generics](Category-Generics).

**Can I put constraints on a type parameter?**
Not yet — this is the headline known limitation, and it is why `IndexOf`/`Contains` and the whole sort library are free procedures rather than `Array` members.

**Do the containers get special compiler treatment?**
None at all. `Array`, `Map`, `Set`, `LinkedList`, `OrderedMap` and `OrderedSet` are written in ordinary FreeBASIC on top of generics, the iterator protocol and `FOR EACH` — so a better implementation by anybody else is on exactly equal footing.

**What does a type need to be usable with `FOR EACH`?**
`GetIterator( )` returning something with `IsValid( )`, `Value( )` and `MoveNext( )`. That is the whole contract — structural, with no base class, interface or registration. See [Iterator Protocol](Category-Iterators).

**Why `USTRING` when `WSTRING` exists?**
`WSTRING` is 2 bytes on Windows, 4 on Linux and 1 on DOS, it is fixed-length, and appending walks to the terminator — O(n²). `USTRING` is dynamic, UTF-16 on every target, and keeps its length in the descriptor, so `LEN` is O(1) and appending is amortised O(1). Conversion to and from `STRING` is UTF-8 on every target instead of going through the C locale.

**Does the new date/time library replace `datetime.bi`?**
No. `fb/chrono.bi` ships alongside it, and nothing in `datetime.bi`, `vbcompat.bi`, `FORMAT` or the `time_*.c` files changed. The two meet at `FromSerial` / `Serial`.

**Are goroutines as cheap as Go's?**
No. `spawn` gives thousands, not millions. It is a real thread per goroutine, with the arguments copied at the spawn point.

**Where do I report a bug or send a patch?**
<https://github.com/PaulSquires/tiko-lang/issues>

**Where does the language reference in this wiki come from?**
The official FreeBASIC manual, reproduced under the GNU Free Documentation License 1.3. See [License](License).

# FAQ

**Is tiko a fork of fbc?**
No. It is a separate compiler, written from scratch in FreeBASIC, with its own frontend, its own typed IR and an LLVM backend. It compiles the same language as [FBC-Modern](https://github.com/PaulSquires/fbc-modern) (`#lang "fb"`, extensions included) and is measured against fbc, program by program. See [What Is tiko-lang](What-Is-tiko-lang).

**Will my existing FreeBASIC code compile?**
If it is `#lang "fb"` code, that is the aim: the same accept/reject decision as fbc and the same behaviour. The known exceptions are listed on [Compatibility](Compatibility). They include `qb`/`fblite`/`deprecated` dialect code and inline `ASM`, each refused with a diagnostic. Code that must know it is being built by tiko tests `#ifdef __TIKO_COMPILER__`.

**Do I have to build anything?**
Yes, once. The repository holds the compiler's source, not a prebuilt toolchain. `bash build/package.sh --verify` builds one for your host. It needs FBC-Modern's `fbc` to compile tiko, and clang to run it. See [Quick Start](Quick-Start).

**Which targets are supported?**
- `win64-msvc`: the default on Windows, and it needs no Visual Studio.
- `win64`: the MinGW ABI.
- `linux-x86_64`: the default on Linux.

x86-64 only: `-m32` and `-target win32` are refused. There is no macOS or ARM64 target.

**Which backends?**
One: tiko emits LLVM IR and runs clang. There is no `-gen` switch. clang 18 or newer must be installed; tiko looks for it at a fixed path or in `TKO_CLANG`, not on `PATH`. See [LLVM Backend](Category-LLVM-Backend).

**Can I use inline `ASM`?**
Not in a module tiko compiles; it is refused with `TKO0407`. Build that module with fbc for `-target win64` and link it in: objects from the two compilers link both ways on that target.

**Are generics macros?**
No. tiko builds one concrete type per distinct type-argument list, checked like any other type, and mangles it exactly as fbc does, so the symbols match fbc's byte for byte. See [Generics](Category-Generics).

**Can I put constraints on a type parameter?**
No. The language has none, in fbc or in tiko. This is why `IndexOf`/`Contains` and the whole sort library are free procedures rather than `Array` members.

**Do the containers get special compiler treatment?**
None at all. `Array`, `Map`, `Set`, `LinkedList`, `OrderedMap` and `OrderedSet` are ordinary FreeBASIC headers, the same files FBC-Modern ships, written on top of generics, the iterator protocol and `FOR EACH`.

**What does a type need to be usable with `FOR EACH`?**
`GetIterator( )` returning something with `IsValid( )`, `Value( )` and `MoveNext( )`. That is the whole contract — structural, with no base class, interface or registration. See [Iterator Protocol](Category-Iterators).

**Why `USTRING` when `WSTRING` exists?**
- `WSTRING` is 2 bytes on Windows and 4 on Linux. It is fixed-length, and appending walks to the terminator, which is O(n²).
- `USTRING` is dynamic and UTF-16 on every target. It keeps its length in the descriptor, so `LEN` is O(1) and appending is amortised O(1).
- Conversion to and from `STRING` is UTF-8 on every target, instead of going through the C locale.

**Does the new date/time library replace `datetime.bi`?**
No. `fb/chrono.bi` ships alongside it, and the two meet at `FromSerial` / `Serial`.

**Are goroutines as cheap as Go's?**
No. `spawn` copies the call's arguments at the spawn point and queues the call for a pool of operating-system worker threads: tiko-rt's scheduler, `lib/rt/src/thread/sched.bas`, which ports FBC-Modern's. No green threads run underneath.

**Where do I report a bug or send a patch?**
<https://github.com/PaulSquires/tiko-lang/issues>

**Where does the language reference in this wiki come from?**
The official FreeBASIC manual, reproduced under the GNU Free Documentation License 1.3. The ✨ pages began as FBC-Modern's feature documentation. See [License](License).

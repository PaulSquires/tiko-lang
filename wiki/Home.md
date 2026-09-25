# tiko-lang Wiki

**tiko is a FreeBASIC-compatible compiler, written from scratch in FreeBASIC. It compiles `#lang "fb"` with FBC-Modern's extensions: generics, an iterator protocol, `FOR EACH`, tuples and multiple return, `defer`, lambdas and a portable Unicode string type, plus the container, date/time and filesystem libraries built on them.**

This wiki is two things in one place:

1. **The FreeBASIC language reference** — the complete FreeBASIC 1.20.0 manual, every keyword, statement, operator, function, tutorial and compiler page.
2. **The extensions** — everything tiko compiles beyond stock FreeBASIC 1.20.0, and how tiko itself works. Those pages carry the badge below and a ✨ in every index, so you always know which is which.

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang extension.** A page marked like this documents a feature added by tiko-lang. It is **not** available in stock FreeBASIC 1.20.0.

---

## Start here

| | |
|---|---|
| [What Is tiko-lang](What-Is-tiko-lang) | What tiko is, what it compiles, and what it does not |
| [Quick Start](Quick-Start) | Build a toolchain and compile a program |
| [Feature Index](Feature-Index) ✨ | Every tiko-lang feature, one line each, with its reference page |
| [Compatibility](Compatibility) | What differs from fbc, measured, and what is the same |
| [FAQ](tiko-lang-FAQ) | Short answers to the questions that come up first |

## Browse the reference

| | |
|---|---|
| [All Categories](Categories) | Every category in this wiki |
| [Keyword Index](Keyword-Index) | Every page, A–Z |

## The extensions at a glance

**Language:** [Generics](Category-Generics) ✨ · [Iterator Protocol](Category-Iterators) ✨ · [For Each](Category-For-Each) ✨ · [Tuples](Category-Tuples) ✨ · [Defer](Category-Defer) ✨ · [Lambdas](Category-Lambdas) ✨ · [UString](Category-UString) ✨ · [Goroutines and Channels](Category-Goroutines-and-Channels) ✨

**Library:** [Array](Category-Array) ✨ · [Map](Category-Map) ✨ · [Set](Category-Set) ✨ · [LinkedList](Category-LinkedList) ✨ · [OrderedMap and OrderedSet](Category-OrderedMap) ✨ · [Sorting](Category-Sorting) ✨ · [Optional](Category-Optional) ✨ · [Result](Category-Result) ✨ · [SharedPtr and WeakPtr](Category-Smart-Pointers) ✨ · [String Library](Category-String-Library) ✨ · [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨ · [Filesystem Library](Category-Filesystem) ✨ · [Math Library](Category-Math-Library) ✨ · [Logging](Category-Logging) ✨

**Toolchain:** [Foreign Library Linking](Category-Foreign-Library-Linking) ✨ · [LLVM Backend](Category-LLVM-Backend) ✨ · [__TIKO_COMPILER__](Category-Tiko-Compiler-Define) ✨ · [C Header Import](Category-C-Header-Import) ✨

---

*The FreeBASIC manual pages in this wiki are reproduced under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html). See [License](License).*

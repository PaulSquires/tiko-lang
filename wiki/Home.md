# The tiko Language

**Code you can read. Speed you can measure. Binaries you can ship.**

tiko is a compiled, statically typed programming language for building fast, self-contained programs. Its syntax is built to be read: blocks say what they close, keywords are words, and there is very little punctuation to learn. Underneath it is a systems language: generics, tuples, lambdas, typed errors, channels and direct use of C headers, compiled through LLVM to native code, with no virtual machine and no garbage collector.

---

## Start here

| | |
|---|---|
| [What Is tiko](What-Is-tiko-lang) | What the language is, what it targets, and what it does not do |
| [Quick Start](Quick-Start) | Build a toolchain and compile a program |
| [Feature Index](Feature-Index) | Every language feature and library, one line each, with its reference page |
| [FAQ](tiko-lang-FAQ) | Short answers to the questions that come up first |

## Tutorials

| | |
|---|---|
| [Goroutines Tutorial](Modern-Goroutines-Tutorial) | Concurrency from the first `spawn` to cancellation |
| [C Header Import Tutorial](modern-Cinclude-tutorial) | Use a C library with `#cinclude` and no binding layer |
| [Foreign Library Linking Tutorial](modern-Foreignlib-tutorial) | Link a library that ships inside your own source tree |
| [Using C Libraries Tutorial](Using-C-Libraries-Tutorial) | From download to running program: static or dynamic, vendored or installed |
| [SQLite](SQLite-Tutorial) · [raylib](Raylib-Tutorial) · [GLFW](GLFW-Tutorial) · [SDL3](SDL3-Tutorial) | The four most common C libraries, step by step, on Windows and Linux |

## The book

<a href="https://tiko-lang.net/book/"><img align="right" src="tiko-book-cover-spiral-sparse.svg" alt="The tiko Programming Language: book cover" width="200"></a>

***The tiko Programming Language*** is a book for programmers who know another language and are new to tiko. It teaches tiko as a language in its own right, and it is written in the tradition of *The Rust Programming Language* and K&R: the basics move briskly, and the idioms get room.

It starts with the basics (types, control flow, procedures, arrays and strings), then builds abstractions (types, objects, modules, generics, errors, testing). It goes on to the advanced language (tuples, iterators, lambdas, `defer`, concurrency), the standard library, and systems programming: C interop with `#cinclude`, and building and shipping. It ends with three complete projects: a command-line search tool, a concurrent pipeline and a terminal-UI ledger.

Every listing in the book is a real program, compiled and run on Windows and Linux with its output checked. The book is being written.

- **Read it online:** [tiko-lang.net/book](https://tiko-lang.net/book/), an mdBook.
- **Download the PDF:** [the-tiko-programming-language.pdf](https://tiko-lang.net/book/the-tiko-programming-language.pdf).

<br clear="right">

## The language

[Generics](Category-Generics) · [Iterator Protocol](Category-Iterators) · [For Each](Category-For-Each) · [Tuples](Category-Tuples) · [Array Results](Category-Array-Results) · [Collection Initializers](Category-Collection-Initializers) · [Defer](Category-Defer) · [Lambdas](Category-Lambdas) · [Block Strings](Category-Block-Strings) · [UString](Category-UString) · [Fixed-Width Types](Category-Fixed-Width-Types) · [Nullptr](Category-Nullptr) · [Goroutines and Channels](Category-Goroutines-and-Channels)

## The standard library

**Collections and algorithms:** [Array](Category-Array) · [Map](Category-Map) · [Set](Category-Set) · [LinkedList](Category-LinkedList) · [OrderedMap and OrderedSet](Category-OrderedMap) · [Sorting](Category-Sorting)

**Values and text:** [Optional](Category-Optional) · [Result](Category-Result) · [SharedPtr and WeakPtr](Category-Smart-Pointers) · [String Library](Category-String-Library)

**System and numbers:** [Chrono Date and Time](Category-Date-and-Time-Chrono) · [Filesystem Library](Category-Filesystem) · [Math Library](Category-Math-Library) · [Finance](Category-Finance) · [Logging](Category-Logging) · [Terminal TUI Library](Category-Terminal-TUI-Library)

## The toolchain

[tiko build](Category-Tiko-Build) · [C Header Import](Category-C-Header-Import) · [Foreign Library Linking](Category-Foreign-Library-Linking) · [LLVM Backend](Category-LLVM-Backend) · [__TIKO_COMPILER__](Category-Tiko-Compiler-Define)

---

## Compatibility reference

tiko's syntax comes from the most readable family of languages ever designed for people, and it still compiles FreeBASIC 1.20 code (`#lang "fb"`). If you are bringing existing code, or you want the precise definition of a keyword, statement or operator, start here:

| | |
|---|---|
| [Compatibility](Compatibility) | What differs from fbc, measured, and what is the same |
| [All Categories](Categories) | Every category, including the FreeBASIC manual's |
| [Keyword Index](Keyword-Index) | Every keyword and page, A to Z |

The keyword, statement, operator and function pages in this reference are the FreeBASIC 1.20.0 manual, reproduced under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html). See [License](License).

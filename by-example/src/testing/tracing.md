# Tracing

Sometimes the quickest way to see what a program did is to have it tell you. A
trace macro built on the [source information](../preprocessor/sourceinfo.md)
names reports *where* each message came from, and the preprocessor can remove
it completely from a finished build.

```tiko
{{#include ../../examples/testing/tracing.tiko}}
```

**Output** (on standard error)

```text
{{#include ../../examples/testing/tracing.out}}
```

Two decisions in this program are worth copying:

- **Trace output goes to standard error.** `open err` opens the standard error
  stream as a file number. The program's real output stays on standard output,
  so `program > result.txt` still captures exactly the result, and the trace
  goes to the screen, or to a file of its own with `2> trace.txt`.
- **Tracing is switched off by the preprocessor, not by an `if`.** Remove the
  `#define TRACING` line and `TRACE( … )` expands to nothing: the calls and the
  work of building their messages are gone from the program. `TraceAt` itself
  is still compiled; nothing calls it.

`__FILE__`, `__LINE__` and `__FUNCTION__` in the macro's body expand where the
macro is *used*, so each line names the procedure and line of the `TRACE`
call, not of the `#define`.

```admonish note
Standard output and standard error are separate streams with separate buffers.
When both go to the same terminal, how their lines interleave is not fixed.
Send a trace and the output it describes to different places, or send
everything through the trace.
```

### Activities

1. Add a `TRACE` inside the `for` loop and watch the output grow.
2. Remove `#define TRACING` and run the program: what does it print now?
